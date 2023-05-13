// The 'iou' program.
program iou.aleo {
    record Coins {
        owner: address,
        gates: u64,
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

    // A loan.
    // - `owner`     : The address of the account that owns the record associated with this load.
    // - `gates`     : The value associated with the record (always zero).
    record Loan {
        owner: address,
        gates: u64,
        id: field,
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

    // Save loan states in public storage.
    mapping loan_states: field => u8;

    mapping coins_for_repayment: field => u64;

    // Apply a loan.
    transition apply(info: LoanInfo) -> (Loan, Loan) {
        // Authenticate debtor.
        assert_eq(self.caller, info.debtor);

        // Generate a new loan id.
        let id: field = BHP256::hash(info);
        let state: u8 = 1u8;

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
    // Store the loan state in the chain.
    finalize apply(id: field) {
        // Prohibit the execution of replays to avoid overwriting and refreshing the loan state.
        let loan_state: u8 = Mapping::get_or_init(loan_states, id, 0u8);
        assert_eq(loan_state, 0u8);
        Mapping::set(loan_states, id, 1u8);
    }

    // Disbursing the loan.
    transition disburse(
        loan_application_record: Loan,
        coins_from_creditor: Coins,
        signature_from_creditor: u64
    ) -> (Loan, Coins, Loan, Coins) {
        // Check if the coin quantity meets the amount.
        assert(coins_from_creditor.amount >= loan_application_record.amount);

        // Todo
        assert_eq(loan_application_record.state, 1u8);
        let state: u8 = 2u8;

        // Loan disbursement record for debtor.
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

        // Disburse coins to debtor.
        let coins_to_debtor: Coins = Coins {
            owner: loan_application_record.debtor,
            gates: 0u64,
            amount: loan_application_record.amount
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
        // Prohibit the execution of replays to avoid overwriting and refreshing the loan state.
        let loan_state: u8 = Mapping::get(loan_states, id);
        assert_eq(loan_state, 1u8);

        Mapping::set(loan_states, id, 2u8);
    }

    // Repaying the loan.
    transition repay(loan_application_record: Loan, loan_disbursement_record: Loan, coins_from_debtor: Coins) -> (Loan, Coins) {
        // Check
        assert_eq(loan_application_record.id, loan_disbursement_record.id);

        // Check
        assert_eq(loan_application_record.state, 1u8);
        assert_eq(loan_disbursement_record.state, 2u8);
        let state: u8 = 3u8;

        // Check if the coin quantity meets the amount of principal + interest.
        let interest_amount: u64 = loan_disbursement_record.amount / 100u64 * loan_disbursement_record.interest_rate;
        let principal_plus_interest_amount: u64 = loan_disbursement_record.amount + interest_amount;
        let remain_coins_amount: u64 = coins_from_debtor.amount - principal_plus_interest_amount;
        assert(coins_from_debtor.amount >= principal_plus_interest_amount);

        // Loan record for repayment.
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
    // Update the state of the loan and deposit coins onto the chain.
    finalize repay(id: field, principal_plus_interest_amount: u64) {
        // Prohibit the execution of replays to avoid overwriting and refreshing the loan state.
        let loan_state: u8 = Mapping::get(loan_states, id);
        assert_eq(loan_state, 2u8);
        Mapping::set(loan_states, id, 3u8);

        Mapping::set(coins_for_repayment, id, principal_plus_interest_amount);
    }

    // Settling the loan.
    transition settle(loan_disbursement_record: Loan, loan_repayment_record: Loan) -> Coins {
        // Check
        assert_eq(loan_disbursement_record.id, loan_repayment_record.id);

        // Check
        assert_eq(loan_disbursement_record.state, 2u8);
        assert_eq(loan_repayment_record.state, 3u8);
        let state: u8 = 4u8;

        // Repayment.
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
        assert_eq(loan_state, 3u8);

        let coins_amount: u64 = Mapping::get(coins_for_repayment, id);
        assert(coins_amount >= principal_plus_interest_amount);

        Mapping::set(loan_states, id, 4u8);
        Mapping::set(coins_for_repayment, id, coins_amount - principal_plus_interest_amount);
    }
}