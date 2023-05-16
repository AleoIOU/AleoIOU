// The 'iou' program.
program iou_v2.aleo {
    // Mock credits record.
    record MockCredits {
        owner: address,
        // Always zero.
        gates: u64,
        microcredits: u64
    }

    // Mining mock credits for demonstration purposes.
    transition mint_for_demo(public receiver: address, public amount: u64) -> MockCredits {
        return MockCredits {
            owner: receiver,
            gates: 0u64,
            microcredits: amount,
        };
    }

    struct LoanInfo {
        // The address of the borrower's account.
        borrower: address,
        // The borrower’s name.
        // Currently there is no String type in Leo language, temporarily use u64 instead.
        borrower_name: u64,
        // The borrower’s address.
        // Currently there is no String type in Leo language, temporarily use u64 instead.
        borrower_address: u64,
        // The borrower’s signature.
        // We want to encode the user's signature photo as input, but it seems that 
        // there is no way to do this at the moment, temporarily use u64 instead.
        borrower_signature: u64,
        // The address of the lender's account.
        lender: address,
        lender_name: u64,
        lender_address: u64,
        lender_signature: u64,
        // The amount of a loan.
        amount: u64,
        // The currency of a loan.
        currency: u64,
        // The date of a loan.
        date: u64,
        // The repayment deadline of a loan.
        // We hope that the smart contract can obtain the state of the blockchain, such as the height.
        repayment_deadline: u64,
        // The annual interest rate of a loan.
        interest_rate: u64
    }

    // A loan record.
    record Loan {
        owner: address,
        // Always zero.
        gates: u64,
        // The ID of a loan, id := BHP256::hash(LoanInfo).
        id: field,
        // Using numbers to represent the state of a loan:
        // 1. Number 1 represents “Applied for loan”
        // 2. Number 2 represents “Loan disbursed”
        // 3. Number 3 represents “Loan repaid”
        state: u8,
        borrower: address,
        borrower_name: u64,
        borrower_address: u64,
        borrower_signature: u64,
        lender: address,
        lender_name: u64,
        lender_address: u64,
        lender_signature: u64,
        amount: u64,
        currency: u64,
        date: u64,
        repayment_deadline: u64,
        interest_rate: u64
    }

    // Save loan state in public storage.
    mapping loan_states: field => u8;
    // Save loan amounts in public storage.
    mapping loan_amounts: field => u64;

    // Apply a loan.
    transition apply(info: LoanInfo) -> (Loan, Loan) {
        // Authenticate borrower.
        assert_eq(self.caller, info.borrower);

        // Generate a new loan ID.
        let id: field = BHP256::hash(info);
        // Set the loan state to “Applied for loan”.
        let state: u8 = 1u8;

        // The borrower applies for a loan from the lender.
        let loan_application_record_for_lender: Loan = Loan {
            owner: info.lender,
            gates: 0u64,
            id,
            state,
            borrower: info.borrower,
            borrower_name: info.borrower_name,
            borrower_address: info.borrower_address,
            borrower_signature: info.borrower_signature,
            lender: info.lender,
            lender_name: info.lender_name,
            lender_address: info.lender_address,
            lender_signature: 0u64,
            amount: info.amount,
            currency: info.currency,
            date: info.date,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        // Create a loan application record for the borrower to provide evidence of the loan details.
        let loan_application_record_for_borrower: Loan = Loan {
            owner: info.borrower,
            gates: 0u64,
            id,
            state,
            borrower: info.borrower,
            borrower_name: info.borrower_name,
            borrower_address: info.borrower_address,
            borrower_signature: info.borrower_signature,
            lender: info.lender,
            lender_name: info.lender_name,
            lender_address: info.lender_address,
            lender_signature: 0u64,
            amount: info.amount,
            currency: info.currency,
            date: info.date,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        return (
            loan_application_record_for_borrower,
            loan_application_record_for_lender
        ) then finalize(id, state, info.amount);
    }
    // Create a new loan state in the "loan_states" mapping.
    finalize apply(id: field, state: u8, amount: u64) {
        let loan_state: u8 = Mapping::get_or_init(loan_states, id, 0u8);
        // If the contract already exists, roll back the transaction to avoid overwriting
        // the existing loan state.
        assert_eq(loan_state, 0u8);
        // Set the loan state to “Applied for loan”.
        Mapping::set(loan_states, id, state);

        // Save loan amounts.
        Mapping::set(loan_amounts, id, amount);
    }

    // Disburse a loan.
    transition disburse(
        loan_application_record: Loan,
        mock_credits_from_lender: MockCredits,
        signature_from_lender: u64
    ) -> (Loan, MockCredits, Loan, MockCredits) {
        // Check if the amount of credits meets the loan amount.
        assert(mock_credits_from_lender.microcredits >= loan_application_record.amount);

        // Check if the loan state is "Applied for loan".
        assert_eq(loan_application_record.state, 1u8);

        let id: field = loan_application_record.id;
        // Set the loan state to “Loan disbursed”.
        let new_state: u8 = 2u8;

        // The lender disburses the loan to the borrower.
        let mock_credits_to_borrower: MockCredits = MockCredits {
            owner: loan_application_record.borrower,
            gates: 0u64,
            microcredits: loan_application_record.amount
        };
        let mock_credits_to_lender: MockCredits = MockCredits {
            owner: loan_application_record.lender,
            gates: 0u64,
            microcredits: mock_credits_from_lender.microcredits - loan_application_record.amount
        };

        // Create loan disbursement record for the lender to prove that the lender has disbursed the loan.
        let loan_disbursement_record_for_borrower: Loan = Loan {
            owner: loan_application_record.borrower,
            gates: 0u64,
            id: loan_application_record.id,
            state: new_state,
            borrower: loan_application_record.borrower,
            borrower_name: loan_application_record.borrower_name,
            borrower_address: loan_application_record.borrower_address,
            borrower_signature: loan_application_record.borrower_signature,
            lender: loan_application_record.lender,
            lender_name: loan_application_record.lender_name,
            lender_address: loan_application_record.lender_address,
            lender_signature: signature_from_lender,
            amount: loan_application_record.amount,
            currency: loan_application_record.currency,
            date: loan_application_record.date,
            repayment_deadline: loan_application_record.repayment_deadline,
            interest_rate: loan_application_record.interest_rate
        };

        // Create loan disbursement record for the borrower to prove that the borrower has received the loan.
        let loan_disbursement_record_for_lender: Loan = Loan {
            owner: loan_application_record.lender,
            gates: 0u64,
            id: loan_application_record.id,
            state: new_state,
            borrower: loan_application_record.borrower,
            borrower_name: loan_application_record.borrower_name,
            borrower_address: loan_application_record.borrower_address,
            borrower_signature: loan_application_record.borrower_signature,
            lender: loan_application_record.lender,
            lender_name: loan_application_record.lender_name,
            lender_address: loan_application_record.lender_address,
            lender_signature: signature_from_lender,
            amount: loan_application_record.amount,
            currency: loan_application_record.currency,
            date: loan_application_record.date,
            repayment_deadline: loan_application_record.repayment_deadline,
            interest_rate: loan_application_record.interest_rate
        };

        return (
            loan_disbursement_record_for_borrower,
            mock_credits_to_borrower,
            loan_disbursement_record_for_lender,
            mock_credits_to_lender
        ) then finalize(id, new_state);
    }
    // Update the state of the loan.
    finalize disburse(id: field, new_state: u8) {
        let loan_state: u8 = Mapping::get(loan_states, id);
        // If the current loan state is not “Applied for loan”, roll back the transaction.
        assert_eq(loan_state, 1u8);
        // Set the loan state to “Loan disbursed”.
        Mapping::set(loan_states, id, new_state);
    }

    // Repay a loan.
    transition repay(
        loan_application_record: Loan,
        loan_disbursement_record: Loan,
        mock_credits_from_borrower: MockCredits
    ) -> (Loan, MockCredits, Loan, MockCredits) {
        // Check if the loan ID is the same.
        assert_eq(loan_application_record.id, loan_disbursement_record.id);

        // Check if the loan state is "Applied for loan".
        assert_eq(loan_disbursement_record.state, 2u8);

        let id: field = loan_disbursement_record.id;
        // Set the loan state to "Loan repaid".
        let new_state: u8 = 3u8;

        // Check if the amount of credits meets the amount of principal plus interest.
        let interest_amount: u64 = loan_disbursement_record.amount / 100u64 * loan_disbursement_record.interest_rate;
        let principal_plus_interest_amount: u64 = loan_disbursement_record.amount + interest_amount;
        let remain_mock_credits_amount: u64 = mock_credits_from_borrower.microcredits - principal_plus_interest_amount;
        assert(remain_mock_credits_amount >= 0u64);

        // The borrower repays the loan to the lender.
        let mock_credits_to_lender: MockCredits = MockCredits {
            owner: loan_disbursement_record.lender,
            gates: 0u64,
            microcredits: principal_plus_interest_amount
        };
        let mock_credits_to_borrower: MockCredits = MockCredits {
            owner: loan_disbursement_record.borrower,
            gates: 0u64,
            microcredits: remain_mock_credits_amount
        };

        // Create loan repayment record for the borrower to prove that the borrower has repaid the loan.
        let loan_repayment_record_for_borrower: Loan = Loan {
            owner: loan_disbursement_record.lender,
            gates: 0u64,
            id: loan_disbursement_record.id,
            state: new_state,
            borrower: loan_disbursement_record.borrower,
            borrower_name: loan_disbursement_record.borrower_name,
            borrower_address: loan_disbursement_record.borrower_address,
            borrower_signature: loan_disbursement_record.borrower_signature,
            lender: loan_disbursement_record.lender,
            lender_name: loan_disbursement_record.lender_name,
            lender_address: loan_disbursement_record.lender_address,
            lender_signature: loan_disbursement_record.lender_signature,
            amount: loan_disbursement_record.amount,
            currency: loan_disbursement_record.currency,
            date: loan_disbursement_record.date,
            repayment_deadline: loan_disbursement_record.repayment_deadline,
            interest_rate: loan_disbursement_record.interest_rate
        };

        // Create a loan repayment record for the lender to prove that the lender has received the repayment.
        let loan_repayment_record_for_lender: Loan = Loan {
            owner: loan_disbursement_record.lender,
            gates: 0u64,
            id: loan_disbursement_record.id,
            state: new_state,
            borrower: loan_disbursement_record.borrower,
            borrower_name: loan_disbursement_record.borrower_name,
            borrower_address: loan_disbursement_record.borrower_address,
            borrower_signature: loan_disbursement_record.borrower_signature,
            lender: loan_disbursement_record.lender,
            lender_name: loan_disbursement_record.lender_name,
            lender_address: loan_disbursement_record.lender_address,
            lender_signature: loan_disbursement_record.lender_signature,
            amount: loan_disbursement_record.amount,
            currency: loan_disbursement_record.currency,
            date: loan_disbursement_record.date,
            repayment_deadline: loan_disbursement_record.repayment_deadline,
            interest_rate: loan_disbursement_record.interest_rate
        };

        return (
            loan_repayment_record_for_borrower,
            mock_credits_to_borrower,
            loan_repayment_record_for_lender,
            mock_credits_to_lender
        ) then finalize(id, new_state);
    }
    // Update the state of the loan.
    finalize repay(id: field, new_state: u8) {
        let loan_state: u8 = Mapping::get(loan_states, id);
        // If the current loan state is not “Loan disbursed”, roll back the transaction.
        assert_eq(loan_state, 2u8);
        // Set the loan state to “Loan repaid”.
        Mapping::set(loan_states, id, new_state);
    }
}