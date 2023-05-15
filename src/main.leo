// The 'iou' program.
program iou.aleo {
    // This contract is a loan contract, which includes the transfer of microcredits
    // in the logic of the lender disbursing the loan to the borrower and the borrower
    // repaying the loan to the lender. 
    // However, because the contract cannot currently operate the microcredits in 
    // the credits record, the Coins record is customized to replace the credits record
    // to facilitate the implementation and description of the logic of this contract.
    record Coins {
        owner: address,
        // Always zero.
        gates: u64,
        // Similar to microcredits in credits record.
        amount: u64
    }

    // Mining coins for demonstration purposes.
    transition mint_for_demo(public receiver: address, public amount: u64) -> Coins {
        return Coins {
            owner: receiver,
            gates: 0u64,
            amount: amount,
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
        // 4. Number 4 represents “Loan settled”
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

    // Save loan state in the smart contract.
    mapping loan_states: field => u8;

    // Store the repayment from borrower in the smart contract.
    mapping coins_for_repayment: field => u64;

    // Apply a loan.
    transition apply(info: LoanInfo) -> (Loan, Loan) {
        // Authenticate borrower.
        assert_eq(self.caller, info.borrower);

        // Generate a new loan id.
        let id: field = BHP256::hash(info);
        // Set the loan state to “Applied for loan”.
        let state: u8 = 1u8;

        // Similar to real-life scenarios, after both parties sign the contract, two copies
        // of the contract are made and each party retains one for subsequent loan verification.
        // Loan application record for borrower.
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

        // Loan application record for lender.
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

        return (
            loan_application_record_for_borrower,
            loan_application_record_for_lender
        ) then finalize(id);
    }
    // Save the loan state in the chain.
    finalize apply(id: field) {
        let loan_state: u8 = Mapping::get_or_init(loan_states, id, 0u8);
        // If the contract already exists, roll back the transaction to avoid overwriting
        // the existing loan status.
        assert_eq(loan_state, 0u8);
        // Set the loan state to “Applied for loan”.
        Mapping::set(loan_states, id, 1u8);
    }

    // Disburse a loan.
    transition disburse(
        loan_application_record: Loan,
        coins_from_lender: Coins,
        signature_from_lender: u64
    ) -> (Loan, Coins, Loan, Coins) {
        // Check if the coin quantity meets the amount.
        assert(coins_from_lender.amount >= loan_application_record.amount);

        // Check the loan state
        assert_eq(loan_application_record.state, 1u8);
        // Set the loan state to “Loan disbursed”.
        let state: u8 = 2u8;

        // Create loan disbursement records for the borrower to prove that the lender has disbursed the loan.
        let loan_disbursement_record_for_borrower: Loan = Loan {
            owner: loan_application_record.borrower,
            gates: 0u64,
            id: loan_application_record.id,
            state,
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

        // Loan disbursement record for lender.
        let loan_disbursement_record_for_lender: Loan = Loan {
            owner: loan_application_record.lender,
            gates: 0u64,
            id: loan_application_record.id,
            state,
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

        // The lender disburses the loan to the borrower.
        let coins_to_borrower: Coins = Coins {
            owner: loan_application_record.borrower,
            gates: 0u64,
            amount: loan_application_record.amount
        };
        let coins_to_lender: Coins = Coins {
            owner: loan_application_record.lender,
            gates: 0u64,
            amount: coins_from_lender.amount - loan_application_record.amount
        };

        return (
            loan_disbursement_record_for_borrower,
            coins_to_borrower,
            loan_disbursement_record_for_lender,
            coins_to_lender
        ) then finalize(loan_application_record.id);
    }
    // Update the state of the loan.
    finalize disburse(id: field) {
        let loan_state: u8 = Mapping::get(loan_states, id);
        // If the current loan state is not “Applied for loan”, roll back the transaction.
        assert_eq(loan_state, 1u8);
        // Set the loan state to “Loan disbursed”.
        Mapping::set(loan_states, id, 2u8);
    }

    // Repay a loan.
    transition repay(
        loan_application_record: Loan,
        loan_disbursement_record: Loan,
        coins_from_borrower: Coins
    ) -> (Loan, Coins) {
        // Check if the loan ID is the same.
        assert_eq(loan_application_record.id, loan_disbursement_record.id);

        // Check the loan state.
        assert_eq(loan_application_record.state, 1u8);
        assert_eq(loan_disbursement_record.state, 2u8);
        let state: u8 = 3u8;

        // Check if the repayment amount satisfies the principal and interest.
        let interest_amount: u64 = loan_disbursement_record.amount / 100u64 * loan_disbursement_record.interest_rate;
        let principal_plus_interest_amount: u64 = loan_disbursement_record.amount + interest_amount;
        let remain_coins_amount: u64 = coins_from_borrower.amount - principal_plus_interest_amount;
        assert(coins_from_borrower.amount >= principal_plus_interest_amount);

        // Create a loan repayment record for the lender to prove that the borrower has repaid the loan.
        let loan_repayment_record: Loan = Loan {
            owner: loan_disbursement_record.lender,
            gates: 0u64,
            id: loan_disbursement_record.id,
            state,
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
        // The remaining coins after deducting the repayment amount.
        let coins_to_borrower: Coins = Coins {
            owner: loan_disbursement_record.borrower,
            gates: 0u64,
            amount: remain_coins_amount
        };

        return (
            loan_repayment_record,
            coins_to_borrower
        ) then finalize(loan_repayment_record.id, principal_plus_interest_amount);
    }
    // Update the state of the loan and store coins onto the chain.
    finalize repay(id: field, principal_plus_interest_amount: u64) {
        let loan_state: u8 = Mapping::get(loan_states, id);
        // If the current loan state is not “Loan disbursed”, roll back the transaction.
        assert_eq(loan_state, 2u8);
        // Set the loan state to “Loan repaid”.
        Mapping::set(loan_states, id, 3u8);
        // Store the repayment from borrower in the smart contract.
        Mapping::set(coins_for_repayment, id, principal_plus_interest_amount);
    }

    // Settle the loan.
    transition settle(loan_disbursement_record: Loan, loan_repayment_record: Loan) -> Coins {
        // Check if the loan ID is the same.
        assert_eq(loan_disbursement_record.id, loan_repayment_record.id);

        // Check the loan state.
        assert_eq(loan_disbursement_record.state, 2u8);
        assert_eq(loan_repayment_record.state, 3u8);
        let state: u8 = 4u8;

        // The lender withdraws the borrower's repayment.
        let interest_amount: u64 = loan_disbursement_record.amount / 100u64 * loan_disbursement_record.interest_rate;
        let principal_plus_interest_amount: u64 = loan_disbursement_record.amount + interest_amount;
        let coins_to_lender: Coins = Coins {
            owner: loan_disbursement_record.lender,
            gates: 0u64,
            amount: principal_plus_interest_amount
        };

        return coins_to_lender then finalize(loan_repayment_record.id, state, principal_plus_interest_amount);
    }
    // Update the state of the loan and take the coins.
    finalize settle(id: field, state: u8, principal_plus_interest_amount: u64) {
        // Prohibit the execution of replays to avoid overwriting and refreshing the loan state.
        let loan_state: u8 = Mapping::get(loan_states, id);
        // If the current loan state is not “Loan repaid”, roll back the transaction.
        assert_eq(loan_state, 3u8);

        let coins_amount: u64 = Mapping::get(coins_for_repayment, id);
        // If the repayment amount does not meet the principal plus interest, the transaction will be rolled back.
        assert(coins_amount >= principal_plus_interest_amount);

        // Set the loan state to “Loan settled”.
        Mapping::set(loan_states, id, 4u8);
        // Deduct the corresponding repayment amount.
        Mapping::set(coins_for_repayment, id, coins_amount - principal_plus_interest_amount);
    }
}