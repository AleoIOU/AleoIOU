import mockcredits.leo;

// The 'iou' program.
program aleo_iou_v1.aleo {

    struct LoanInfo {
        // The loan ID.
        id: field,
        // The address of the borrower's account.
        borrower: address,
        // The borrower's name.
        borrower_name: field,
        borrower_name_len: u32,
        // The borrower's address.
        borrower_addr_01: field,
        borrower_addr_02: field,
        borrower_addr_len: u32,
        // The address of the lender's account.
        lender: address,
        lender_name: field,
        lender_name_len: u32,
        lender_addr_01: field,
        lender_addr_02: field,
        lender_addr_len: u32,
        // The amount of a loan.
        amount: u64,
        // The repayment deadline of a loan.
        repayment_deadline: u64,
        // The annual interest rate of a loan.
        interest_rate: u64
    }

    // A loan application record.
    record Application {
        owner: address,
        // Always zero.
        gates: u64,
        // The ID of a loan.
        id: field,
        borrower: address,
        borrower_name: field,
        borrower_name_len: u32,
        borrower_addr_01: field,
        borrower_addr_02: field,
        borrower_addr_len: u32,
        lender: address,
        lender_name: field,
        lender_name_len: u32,
        lender_addr_01: field,
        lender_addr_02: field,
        lender_addr_len: u32,
        amount: u64,
        repayment_deadline: u64,
        interest_rate: u64
    }

    // A loan disbursement record.
    record Disbursement {
        owner: address,
        // Always zero.
        gates: u64,
        // The ID of a loan.
        id: field
    }

    // A loan repayment record.
    record Repayment {
        owner: address,
        // Always zero.
        gates: u64,
        // The ID of a loan.
        id: field,
        end_block_height: field,
    }

    // Save loan state in public storage.
    // Using numbers to represent the state of a loan:
    // 1. Number 1 represents "Applied for loan"
    // 2. Number 2 represents "Loan disbursed"
    // 3. Number 3 represents "Loan repaid"
    mapping loan_states: field => u8;
    // Save loan amounts in public storage.
    mapping loan_amounts: field => u64;
    mapping loan_start_heights: field => u32;

    // Apply a loan.
    transition apply(info: LoanInfo) -> (Application, Application) {
        // Authenticate borrower.
        assert_eq(self.caller, info.borrower);

        assert(info.interest_rate >= 2u64);
        assert(info.amount >= 25000u64);

        // Set the loan state to "Applied for loan".
        let state: u8 = 1u8;

        // The borrower applies for a loan from the lender.
        let loan_application_record_for_lender: Application = Application {
            owner: info.lender,
            gates: 0u64,
            id: info.id,
            borrower: info.borrower,
            borrower_name: info.borrower_name,
            borrower_name_len: info.borrower_name_len,
            borrower_addr_01: info.borrower_addr_01,
            borrower_addr_02: info.borrower_addr_02,
            borrower_addr_len: info.borrower_addr_len,
            lender: info.lender,
            lender_name: info.lender_name,
            lender_name_len: info.lender_name_len,
            lender_addr_01: info.lender_addr_01,
            lender_addr_02: info.lender_addr_02,
            lender_addr_len: info.lender_addr_len,
            amount: info.amount,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        // Create a loan application record for the borrower to provide evidence of the loan details.
        let loan_application_record_for_borrower: Application = Application {
            owner: info.borrower,
            gates: 0u64,
            id: info.id,
            borrower: info.borrower,
            borrower_name: info.borrower_name,
            borrower_name_len: info.borrower_name_len,
            borrower_addr_01: info.borrower_addr_01,
            borrower_addr_02: info.borrower_addr_02,
            borrower_addr_len: info.borrower_addr_len,
            lender: info.lender,
            lender_name: info.lender_name,
            lender_name_len: info.lender_name_len,
            lender_addr_01: info.lender_addr_01,
            lender_addr_02: info.lender_addr_02,
            lender_addr_len: info.lender_addr_len,
            amount: info.amount,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        return (
            loan_application_record_for_borrower,
            loan_application_record_for_lender,
        ) then finalize(info.id, state, info.amount);
    }
    // Create a new loan state in the "loan_states" mapping.
    finalize apply(id: field, state: u8, amount: u64) {
        let loan_state: u8 = Mapping::get_or_use(loan_states, id, 0u8);
        // If the contract already exists, roll back the transaction to avoid overwriting
        // the existing loan state.
        assert_eq(loan_state, 0u8);
        // Set the loan state to "Applied for loan".
        Mapping::set(loan_states, id, state);

        // Save loan amounts.
        Mapping::set(loan_amounts, id, amount);
    }

    // Disburse a loan.
    transition disburse(
        loan_application_record: Application,
        credits_from_lender: mockcredits.leo/mockcredits.record,
    ) -> (
        Disbursement,
        mockcredits.leo/mockcredits.record, // transferred_credits
        Disbursement,
        mockcredits.leo/mockcredits.record, // remaining_credits
    ) {
        // Check if the amount of credits meets the loan amount.
        assert(credits_from_lender.microcredits >= loan_application_record.amount);

        let id: field = loan_application_record.id;
        // Set the loan state to "Loan disbursed".
        let new_state: u8 = 2u8;

        // The lender disburses the loan to the borrower.
        let (remaining_credits, transferred_credits): (mockcredits, mockcredits) = mockcredits.leo/transfer_private(
            credits_from_lender,
            loan_application_record.borrower,
            loan_application_record.amount
        );

        // Create loan disbursement record for the borrower to prove that the borrower has received the loan.
        let loan_disbursement_record_for_borrower: Disbursement = Disbursement {
            owner: loan_application_record.borrower,
            gates: 0u64,
            id
        };

        // Create loan disbursement record for the lender to prove that the lender has disbursed the loan.
        let loan_disbursement_record_for_lender: Disbursement = Disbursement {
            owner: loan_application_record.lender,
            gates: 0u64,
            id
        };

        return (
            loan_disbursement_record_for_borrower,
            transferred_credits,
            loan_disbursement_record_for_lender,
            remaining_credits,
        ) then finalize(id, new_state);
    }
    // Update the state of the loan.
    finalize disburse(id: field, new_state: u8) {
        // If the current loan state is not "Applied for loan", roll back the transaction.
        let loan_state: u8 = Mapping::get(loan_states, id);
        assert_eq(loan_state, 1u8);

        // Set the loan state to "Loan disbursed".
        Mapping::set(loan_states, id, new_state);

        // Save the loan start height.
        Mapping::set(loan_start_heights, id, block.height);
    }

    // Repay a loan.
    transition repay(
        loan_application_record: Application,
        loan_disbursement_record: Disbursement,
        credits_from_borrower: mockcredits.leo/mockcredits.record,
        start_block_height: field,
        end_block_height: field
    ) -> (
        Repayment,
        mockcredits.leo/mockcredits.record, // remaining_credits
        Repayment,
        mockcredits.leo/mockcredits.record, // transferred_credits
    ) {
        // Check if the loan ID is the same.
        assert_eq(loan_application_record.id, loan_disbursement_record.id);

        let id: field = loan_application_record.id;
        // Set the loan state to "Loan repaid".
        let new_state: u8 = 3u8;

        // Check if the amount of credits meets the amount of principal plus interest.
        let start_block_height_u64: u64 = start_block_height as u64;
        let end_block_height_u64: u64 = end_block_height as u64;
        let end_block_height_u32: u32 = end_block_height as u32;
        assert(end_block_height_u64 >= start_block_height_u64);

        let interest_rate: u64 = loan_application_record.interest_rate;
        let principal_amount: u64 = loan_application_record.amount;

        let days: u64 = elapsed_days(end_block_height_u64, start_block_height_u64);
        let interest_amount: u64 = days * interest_rate * principal_amount * 1000u64 / 365u64 / 100000u64;

        let principal_plus_interest_amount: u64 = principal_amount + interest_amount;
        let remaining_credits_amount: u64 = credits_from_borrower.microcredits - principal_plus_interest_amount;
        assert(remaining_credits_amount >= 0u64);

        // The borrower repays the loan to the lender.
        let (remaining_credits, transferred_credits): (mockcredits, mockcredits) = mockcredits.leo/transfer_private(
            credits_from_borrower,
            loan_application_record.lender,
            principal_plus_interest_amount
        );

        // Create loan repayment record for the borrower to prove that the borrower has repaid the loan.
        let loan_repayment_record_for_borrower: Repayment = Repayment {
            owner: loan_application_record.borrower,
            gates: 0u64,
            id,
            end_block_height
        };

        // Create a loan repayment record for the lender to prove that the lender has received the repayment.
        let loan_repayment_record_for_lender: Repayment = Repayment {
            owner: loan_application_record.lender,
            gates: 0u64,
            id,
            end_block_height
        };

        return (
            loan_repayment_record_for_borrower,
            remaining_credits,
            loan_repayment_record_for_lender,
            transferred_credits,
        ) then finalize(id, new_state, end_block_height_u32);
    }
    // Update the state of the loan.
    finalize repay(id: field, new_state: u8, end_block_height: u32) {
        // If the current loan state is not "Loan disbursed", roll back the transaction.
        let loan_state: u8 = Mapping::get(loan_states, id);
        assert_eq(loan_state, 2u8);

        // If the end block height is less than current block height, roll back the transaction.
        assert(end_block_height >= block.height);

        // Set the loan state to "Loan repaid".
        Mapping::set(loan_states, id, new_state);
    }

    inline elapsed_days(end_block_height: u64, start_block_height: u64) -> u64 {
        let elapsed_time: u64 = (end_block_height - start_block_height) * 15u64;

        let one_day: u64 = 24u64 * 60u64 * 60u64;
        return elapsed_time / one_day + (elapsed_time % one_day > 0u64 ? 1u64 : 0u64);
    }
}