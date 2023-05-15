// The 'iou' program.
program iou.aleo {
    // This contract is a loan contract, which includes the transfer of microcredits
    // in the logic of the creditor disbursing the loan to the debtor and the debtor
    // repaying the loan to the creditor. 
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
        // The address of the debtor's account.
        debtor: address,
        // The debtor’s name.
        // Currently there is no String type in Leo language, temporarily use u64 instead.
        debtor_name: u64,
        // The debtor’s address.
        // Currently there is no String type in Leo language, temporarily use u64 instead.
        debtor_address: u64,
        // The debtor’s signature.
        // We want to encode the user's signature photo as input, but it seems that 
        // there is no way to do this at the moment, temporarily use u64 instead.
        debtor_signature: u64,
        // The address of the creditor's account.
        creditor: address,
        creditor_name: u64,
        creditor_address: u64,
        creditor_signature: u64,
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
        debtor: address,
        debtor_name: u64,
        debtor_address: u64,
        debtor_signature: u64,
        creditor: address,
        creditor_name: u64,
        creditor_address: u64,
        creditor_signature: u64,
        amount: u64,
        currency: u64,
        date: u64,
        repayment_deadline: u64,
        interest_rate: u64
    }

    // Save loan state in the smart contract.
    mapping loan_states: field => u8;

    // Store the repayment from debtor in the smart contract.
    mapping coins_for_repayment: field => u64;

    // Apply a loan.
    transition apply(info: LoanInfo) -> (Loan, Loan) {
        // Authenticate debtor.
        assert_eq(self.caller, info.debtor);

        // Generate a new loan id.
        let id: field = BHP256::hash(info);
        // Set the loan state to “Applied for loan”.
        let state: u8 = 1u8;

        // Similar to real-life scenarios, after both parties sign the contract, two copies
        // of the contract are made and each party retains one for subsequent loan verification.
        // Loan application record for debtor.
        let loan_application_record_for_debtor: Loan = Loan {
            owner: info.debtor,
            gates: 0u64,
            id,
            state,
            debtor: info.debtor,
            debtor_name: info.debtor_name,
            debtor_address: info.debtor_address,
            debtor_signature: info.debtor_signature,
            creditor: info.creditor,
            creditor_name: info.creditor_name,
            creditor_address: info.creditor_address,
            creditor_signature: 0u64,
            amount: info.amount,
            currency: info.currency,
            date: info.date,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        // Loan application record for creditor.
        let loan_application_record_for_creditor: Loan = Loan {
            owner: info.creditor,
            gates: 0u64,
            id,
            state,
            debtor: info.debtor,
            debtor_name: info.debtor_name,
            debtor_address: info.debtor_address,
            debtor_signature: info.debtor_signature,
            creditor: info.creditor,
            creditor_name: info.creditor_name,
            creditor_address: info.creditor_address,
            creditor_signature: 0u64,
            amount: info.amount,
            currency: info.currency,
            date: info.date,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        return (
            loan_application_record_for_debtor,
            loan_application_record_for_creditor
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
        coins_from_creditor: Coins,
        signature_from_creditor: u64
    ) -> (Loan, Coins, Loan, Coins) {
        // Check if the coin quantity meets the amount.
        assert(coins_from_creditor.amount >= loan_application_record.amount);

        // Check the loan state
        assert_eq(loan_application_record.state, 1u8);
        // Set the loan state to “Loan disbursed”.
        let state: u8 = 2u8;

        // Create loan disbursement records for the debtor to prove that the creditor has disbursed the loan.
        let loan_disbursement_record_for_debtor: Loan = Loan {
            owner: loan_application_record.debtor,
            gates: 0u64,
            id: loan_application_record.id,
            state,
            debtor: loan_application_record.debtor,
            debtor_name: loan_application_record.debtor_name,
            debtor_address: loan_application_record.debtor_address,
            debtor_signature: loan_application_record.debtor_signature,
            creditor: loan_application_record.creditor,
            creditor_name: loan_application_record.creditor_name,
            creditor_address: loan_application_record.creditor_address,
            creditor_signature: signature_from_creditor,
            amount: loan_application_record.amount,
            currency: loan_application_record.currency,
            date: loan_application_record.date,
            repayment_deadline: loan_application_record.repayment_deadline,
            interest_rate: loan_application_record.interest_rate
        };

        // Loan disbursement record for creditor.
        let loan_disbursement_record_for_creditor: Loan = Loan {
            owner: loan_application_record.creditor,
            gates: 0u64,
            id: loan_application_record.id,
            state,
            debtor: loan_application_record.debtor,
            debtor_name: loan_application_record.debtor_name,
            debtor_address: loan_application_record.debtor_address,
            debtor_signature: loan_application_record.debtor_signature,
            creditor: loan_application_record.creditor,
            creditor_name: loan_application_record.creditor_name,
            creditor_address: loan_application_record.creditor_address,
            creditor_signature: signature_from_creditor,
            amount: loan_application_record.amount,
            currency: loan_application_record.currency,
            date: loan_application_record.date,
            repayment_deadline: loan_application_record.repayment_deadline,
            interest_rate: loan_application_record.interest_rate
        };

        // The creditor disburses the loan to the debtor.
        let coins_to_debtor: Coins = Coins {
            owner: loan_application_record.debtor,
            gates: 0u64,
            amount: loan_application_record.amount
        };
        let coins_to_creditor: Coins = Coins {
            owner: loan_application_record.creditor,
            gates: 0u64,
            amount: coins_from_creditor.amount - loan_application_record.amount
        };

        return (
            loan_disbursement_record_for_debtor,
            coins_to_debtor,
            loan_disbursement_record_for_creditor,
            coins_to_creditor
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
        coins_from_debtor: Coins
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
        let remain_coins_amount: u64 = coins_from_debtor.amount - principal_plus_interest_amount;
        assert(coins_from_debtor.amount >= principal_plus_interest_amount);

        // Create a loan repayment record for the creditor to prove that the debtor has repaid the loan.
        let loan_repayment_record: Loan = Loan {
            owner: loan_disbursement_record.creditor,
            gates: 0u64,
            id: loan_disbursement_record.id,
            state,
            debtor: loan_disbursement_record.debtor,
            debtor_name: loan_disbursement_record.debtor_name,
            debtor_address: loan_disbursement_record.debtor_address,
            debtor_signature: loan_disbursement_record.debtor_signature,
            creditor: loan_disbursement_record.creditor,
            creditor_name: loan_disbursement_record.creditor_name,
            creditor_address: loan_disbursement_record.creditor_address,
            creditor_signature: loan_disbursement_record.creditor_signature,
            amount: loan_disbursement_record.amount,
            currency: loan_disbursement_record.currency,
            date: loan_disbursement_record.date,
            repayment_deadline: loan_disbursement_record.repayment_deadline,
            interest_rate: loan_disbursement_record.interest_rate
        };
        // The remaining coins after deducting the repayment amount.
        let coins_to_debtor: Coins = Coins {
            owner: loan_disbursement_record.debtor,
            gates: 0u64,
            amount: remain_coins_amount
        };

        return (
            loan_repayment_record,
            coins_to_debtor
        ) then finalize(loan_repayment_record.id, principal_plus_interest_amount);
    }
    // Update the state of the loan and store coins onto the chain.
    finalize repay(id: field, principal_plus_interest_amount: u64) {
        let loan_state: u8 = Mapping::get(loan_states, id);
        // If the current loan state is not “Loan disbursed”, roll back the transaction.
        assert_eq(loan_state, 2u8);
        // Set the loan state to “Loan repaid”.
        Mapping::set(loan_states, id, 3u8);
        // Store the repayment from debtor in the smart contract.
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

        // The creditor withdraws the debtor's repayment.
        let interest_amount: u64 = loan_disbursement_record.amount / 100u64 * loan_disbursement_record.interest_rate;
        let principal_plus_interest_amount: u64 = loan_disbursement_record.amount + interest_amount;
        let coins_to_creditor: Coins = Coins {
            owner: loan_disbursement_record.creditor,
            gates: 0u64,
            amount: principal_plus_interest_amount
        };

        return coins_to_creditor then finalize(loan_repayment_record.id, state, principal_plus_interest_amount);
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