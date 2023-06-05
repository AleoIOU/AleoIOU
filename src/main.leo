// The 'iou' program.
program iou_v3.aleo {
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
        // The loan ID.
        id: field,
        // The address of the borrower's account.
        borrower: address,
        // The borrower’s name.
        borrower_name: field,
        borrower_name_length: u64,
        // The borrower’s address.
        borrower_addr_00: field,
        borrower_addr_01: field,
        borrower_addr_02: field,
        borrower_addr_03: field,
        borrower_addr_length: u64,
        // The address of the lender's account.
        lender: address,
        lender_name: field,
        lender_name_length: u64
        lender_addr_00: field,
        lender_addr_01: field,
        lender_addr_02: field,
        lender_addr_03: field,
        lender_addr_length: u64,
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

    // Part one.
    struct SigInfoPartOne {
        sig_01: field,
        sig_02: field,
        sig_03: field,
        sig_04: field,
        sig_05: field,
        sig_06: field,
        sig_07: field,
        sig_08: field,
        sig_09: field,
        sig_10: field,
        sig_11: field,
        sig_12: field,
        sig_13: field,
        sig_14: field,
        sig_15: field,
        sig_16: field,
        sig_17: field,
        sig_18: field,
        sig_19: field,
        sig_20: field,
        sig_21: field,
        sig_22: field,
        sig_23: field,
        sig_24: field,
        sig_25: field,
        sig_26: field,
        sig_27: field,
        sig_28: field
    }

    // Part two.
    struct SigInfoPartTwo {
        sig_01: field,
        sig_02: field,
        sig_03: field,
        sig_04: field,
        sig_05: field,
        sig_06: field,
        sig_07: field,
        sig_08: field,
        sig_09: field,
        sig_10: field,
        sig_11: field,
        sig_12: field,
        sig_13: field,
        sig_14: field,
        sig_15: field,
        sig_16: field,
        sig_17: field,
        sig_18: field,
        sig_19: field,
        sig_20: field,
        sig_21: field,
        sig_22: field,
        sig_23: field,
        sig_24: field,
        sig_25: field,
        sig_26: field,
        sig_27: field,
        sig_28: field
    }

    // Part three.
    struct SigInfoPartThree {
        sig_length: u64,
        sig_01: field,
        sig_02: field,
        sig_03: field,
        sig_04: field,
        sig_05: field,
        sig_06: field,
        sig_07: field,
        sig_08: field,
        sig_09: field,
        sig_10: field,
        sig_11: field,
        sig_12: field,
        sig_13: field,
        sig_14: field,
        sig_15: field,
        sig_16: field,
        sig_17: field,
        sig_18: field,
        sig_19: field,
        sig_20: field,
        sig_21: field,
        sig_22: field,
        sig_23: field,
        sig_24: field,
        sig_25: field,
        sig_26: field,
        sig_27: field
    }

    // Part one.
    record SigPartOne {
        owner: address,
        gates: u64,
        loan_id: field,
        the_undersigned: address,
        sig_01: field,
        sig_02: field,
        sig_03: field,
        sig_04: field,
        sig_05: field,
        sig_06: field,
        sig_07: field,
        sig_08: field,
        sig_09: field,
        sig_10: field,
        sig_11: field,
        sig_12: field,
        sig_13: field,
        sig_14: field,
        sig_15: field,
        sig_16: field,
        sig_17: field,
        sig_18: field,
        sig_19: field,
        sig_20: field,
        sig_21: field,
        sig_22: field,
        sig_23: field,
        sig_24: field,
        sig_25: field,
        sig_26: field,
        sig_27: field,
        sig_28: field
    }

    // Part two.
    record SigPartTwo {
        owner: address,
        gates: u64,
        loan_id: field,
        the_undersigned: address,
        sig_01: field,
        sig_02: field,
        sig_03: field,
        sig_04: field,
        sig_05: field,
        sig_06: field,
        sig_07: field,
        sig_08: field,
        sig_09: field,
        sig_10: field,
        sig_11: field,
        sig_12: field,
        sig_13: field,
        sig_14: field,
        sig_15: field,
        sig_16: field,
        sig_17: field,
        sig_18: field,
        sig_19: field,
        sig_20: field,
        sig_21: field,
        sig_22: field,
        sig_23: field,
        sig_24: field,
        sig_25: field,
        sig_26: field,
        sig_27: field,
        sig_28: field
    }

    // Part three.
    record SigPartThree {
        owner: address,
        gates: u64,
        loan_id: field,
        the_undersigned: address,
        sig_length: u64,
        sig_01: field,
        sig_02: field,
        sig_03: field,
        sig_04: field,
        sig_05: field,
        sig_06: field,
        sig_07: field,
        sig_08: field,
        sig_09: field,
        sig_10: field,
        sig_11: field,
        sig_12: field,
        sig_13: field,
        sig_14: field,
        sig_15: field,
        sig_16: field,
        sig_17: field,
        sig_18: field,
        sig_19: field,
        sig_20: field,
        sig_21: field,
        sig_22: field,
        sig_23: field,
        sig_24: field,
        sig_25: field,
        sig_26: field,
        sig_27: field
    }

    // A loan record.
    record Loan {
        owner: address,
        // Always zero.
        gates: u64,
        // The ID of a loan.
        id: field,
        // Using numbers to represent the state of a loan:
        // 1. Number 1 represents “Applied for loan”
        // 2. Number 2 represents “Loan disbursed”
        // 3. Number 3 represents “Loan repaid”
        state: u8,
        borrower: address,
        borrower_name: field,
        borrower_name_length: u64,
        borrower_addr_00: field,
        borrower_addr_01: field,
        borrower_addr_02: field,
        borrower_addr_03: field,
        borrower_addr_length: u64,
        lender: address,
        lender_name: field,
        lender_name_length: u64
        lender_addr_00: field,
        lender_addr_01: field,
        lender_addr_02: field,
        lender_addr_03: field,
        lender_addr_length: u64,
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
    transition apply(
        info: LoanInfo,
        sig_info_part_one: SigInfoPartOne,
        sig_info_part_two: SigInfoPartTwo,
        sig_info_part_three: SigInfoPartThree
    ) -> (
        Loan,
        SigPartOne, SigPartTwo, SigPartThree,
        Loan,
        SigPartOne, SigPartTwo, SigPartThree,
    ) {
        // Authenticate borrower.
        assert_eq(self.caller, info.borrower);

        assert(info.interest_rate >= 2u64);
        assert(info.amount >= 25000u64);

        // Set the loan state to “Applied for loan”.
        let state: u8 = 1u8;

        // The borrower applies for a loan from the lender.
        let loan_application_record_for_lender: Loan = Loan {
            owner: info.lender,
            gates: 0u64,
            id: info.id,
            state,
            borrower: info.borrower,
            borrower_name: info.borrower_name,
            borrower_name_length: info.borrower_name_length,
            borrower_addr_00: info.borrower_addr_00,
            borrower_addr_01: info.borrower_addr_01,
            borrower_addr_02: info.borrower_addr_02,
            borrower_addr_03: info.borrower_addr_03,
            borrower_addr_length: info.borrower_addr_length,
            lender: info.lender,
            lender_name: info.lender_name,
            lender_name_length: info.lender_name_length,
            lender_addr_00: info.lender_addr_00,
            lender_addr_01: info.lender_addr_01,
            lender_addr_02: info.lender_addr_02,
            lender_addr_03: info.lender_addr_03,
            lender_addr_length: info.lender_addr_length,
            amount: info.amount,
            currency: info.currency,
            date: info.date,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        // Part one.
        let borrower_sig_part_one_for_lender: SigPartOne = SigPartOne {
            owner: info.lender,
            gates: 0u64,
            loan_id: info.id,
            the_undersigned: info.borrower,
            sig_01: sig_info_part_one.sig_01,
            sig_02: sig_info_part_one.sig_02,
            sig_03: sig_info_part_one.sig_03,
            sig_04: sig_info_part_one.sig_04,
            sig_05: sig_info_part_one.sig_05,
            sig_06: sig_info_part_one.sig_06,
            sig_07: sig_info_part_one.sig_07,
            sig_08: sig_info_part_one.sig_08,
            sig_09: sig_info_part_one.sig_09,
            sig_10: sig_info_part_one.sig_10,
            sig_11: sig_info_part_one.sig_11,
            sig_12: sig_info_part_one.sig_12,
            sig_13: sig_info_part_one.sig_13,
            sig_14: sig_info_part_one.sig_14,
            sig_15: sig_info_part_one.sig_15,
            sig_16: sig_info_part_one.sig_16,
            sig_17: sig_info_part_one.sig_17,
            sig_18: sig_info_part_one.sig_18,
            sig_19: sig_info_part_one.sig_19,
            sig_20: sig_info_part_one.sig_20,
            sig_21: sig_info_part_one.sig_21,
            sig_22: sig_info_part_one.sig_22,
            sig_23: sig_info_part_one.sig_23,
            sig_24: sig_info_part_one.sig_24,
            sig_25: sig_info_part_one.sig_25,
            sig_26: sig_info_part_one.sig_26,
            sig_27: sig_info_part_one.sig_27,
            sig_28: sig_info_part_one.sig_28
        };

        // Part two.
        let borrower_sig_part_two_for_lender: SigPartTwo = SigPartTwo {
            owner: info.lender,
            gates: 0u64,
            loan_id: info.id,
            the_undersigned: info.borrower,
            sig_01: sig_info_part_two.sig_01,
            sig_02: sig_info_part_two.sig_02,
            sig_03: sig_info_part_two.sig_03,
            sig_04: sig_info_part_two.sig_04,
            sig_05: sig_info_part_two.sig_05,
            sig_06: sig_info_part_two.sig_06,
            sig_07: sig_info_part_two.sig_07,
            sig_08: sig_info_part_two.sig_08,
            sig_09: sig_info_part_two.sig_09,
            sig_10: sig_info_part_two.sig_10,
            sig_11: sig_info_part_two.sig_11,
            sig_12: sig_info_part_two.sig_12,
            sig_13: sig_info_part_two.sig_13,
            sig_14: sig_info_part_two.sig_14,
            sig_15: sig_info_part_two.sig_15,
            sig_16: sig_info_part_two.sig_16,
            sig_17: sig_info_part_two.sig_17,
            sig_18: sig_info_part_two.sig_18,
            sig_19: sig_info_part_two.sig_19,
            sig_20: sig_info_part_two.sig_20,
            sig_21: sig_info_part_two.sig_21,
            sig_22: sig_info_part_two.sig_22,
            sig_23: sig_info_part_two.sig_23,
            sig_24: sig_info_part_two.sig_24,
            sig_25: sig_info_part_two.sig_25,
            sig_26: sig_info_part_two.sig_26,
            sig_27: sig_info_part_two.sig_27,
            sig_28: sig_info_part_two.sig_28
        };

        // Part three.
        let borrower_sig_part_three_for_lender: SigPartThree = SigPartThree {
            owner: info.lender,
            gates: 0u64,
            loan_id: info.id,
            the_undersigned: info.borrower,
            sig_length: sig_info_part_three.sig_length,
            sig_01: sig_info_part_three.sig_01,
            sig_02: sig_info_part_three.sig_02,
            sig_03: sig_info_part_three.sig_03,
            sig_04: sig_info_part_three.sig_04,
            sig_05: sig_info_part_three.sig_05,
            sig_06: sig_info_part_three.sig_06,
            sig_07: sig_info_part_three.sig_07,
            sig_08: sig_info_part_three.sig_08,
            sig_09: sig_info_part_three.sig_09,
            sig_10: sig_info_part_three.sig_10,
            sig_11: sig_info_part_three.sig_11,
            sig_12: sig_info_part_three.sig_12,
            sig_13: sig_info_part_three.sig_13,
            sig_14: sig_info_part_three.sig_14,
            sig_15: sig_info_part_three.sig_15,
            sig_16: sig_info_part_three.sig_16,
            sig_17: sig_info_part_three.sig_17,
            sig_18: sig_info_part_three.sig_18,
            sig_19: sig_info_part_three.sig_19,
            sig_20: sig_info_part_three.sig_20,
            sig_21: sig_info_part_three.sig_21,
            sig_22: sig_info_part_three.sig_22,
            sig_23: sig_info_part_three.sig_23,
            sig_24: sig_info_part_three.sig_24,
            sig_25: sig_info_part_three.sig_25,
            sig_26: sig_info_part_three.sig_26,
            sig_27: sig_info_part_three.sig_27
        };

        // Create a loan application record for the borrower to provide evidence of the loan details.
        let loan_application_record_for_borrower: Loan = Loan {
            owner: info.borrower,
            gates: 0u64,
            id: info.id,
            state,
            borrower: info.borrower,
            borrower_name: info.borrower_name,
            borrower_name_length: info.borrower_name_length,
            borrower_addr_00: info.borrower_addr_00,
            borrower_addr_01: info.borrower_addr_01,
            borrower_addr_02: info.borrower_addr_02,
            borrower_addr_03: info.borrower_addr_03,
            borrower_addr_length: info.borrower_addr_length,
            lender: info.lender,
            lender_name: info.lender_name,
            lender_name_length: info.lender_name_length,
            lender_addr_00: info.lender_addr_00,
            lender_addr_01: info.lender_addr_01,
            lender_addr_02: info.lender_addr_02,
            lender_addr_03: info.lender_addr_03,
            lender_addr_length: info.lender_addr_length,
            amount: info.amount,
            currency: info.currency,
            date: info.date,
            repayment_deadline: info.repayment_deadline,
            interest_rate: info.interest_rate
        };

        // Part one.
        let borrower_sig_part_one_for_borrower: SigPartOne = SigPartOne {
            owner: info.borrower,
            gates: 0u64,
            loan_id: info.id,
            the_undersigned: info.borrower,
            sig_01: sig_info_part_one.sig_01,
            sig_02: sig_info_part_one.sig_02,
            sig_03: sig_info_part_one.sig_03,
            sig_04: sig_info_part_one.sig_04,
            sig_05: sig_info_part_one.sig_05,
            sig_06: sig_info_part_one.sig_06,
            sig_07: sig_info_part_one.sig_07,
            sig_08: sig_info_part_one.sig_08,
            sig_09: sig_info_part_one.sig_09,
            sig_10: sig_info_part_one.sig_10,
            sig_11: sig_info_part_one.sig_11,
            sig_12: sig_info_part_one.sig_12,
            sig_13: sig_info_part_one.sig_13,
            sig_14: sig_info_part_one.sig_14,
            sig_15: sig_info_part_one.sig_15,
            sig_16: sig_info_part_one.sig_16,
            sig_17: sig_info_part_one.sig_17,
            sig_18: sig_info_part_one.sig_18,
            sig_19: sig_info_part_one.sig_19,
            sig_20: sig_info_part_one.sig_20,
            sig_21: sig_info_part_one.sig_21,
            sig_22: sig_info_part_one.sig_22,
            sig_23: sig_info_part_one.sig_23,
            sig_24: sig_info_part_one.sig_24,
            sig_25: sig_info_part_one.sig_25,
            sig_26: sig_info_part_one.sig_26,
            sig_27: sig_info_part_one.sig_27,
            sig_28: sig_info_part_one.sig_28
        };

        // Part two.
        let borrower_sig_part_two_for_borrower: SigPartTwo = SigPartTwo {
            owner: info.borrower,
            gates: 0u64,
            loan_id: info.id,
            the_undersigned: info.borrower,
            sig_01: sig_info_part_two.sig_01,
            sig_02: sig_info_part_two.sig_02,
            sig_03: sig_info_part_two.sig_03,
            sig_04: sig_info_part_two.sig_04,
            sig_05: sig_info_part_two.sig_05,
            sig_06: sig_info_part_two.sig_06,
            sig_07: sig_info_part_two.sig_07,
            sig_08: sig_info_part_two.sig_08,
            sig_09: sig_info_part_two.sig_09,
            sig_10: sig_info_part_two.sig_10,
            sig_11: sig_info_part_two.sig_11,
            sig_12: sig_info_part_two.sig_12,
            sig_13: sig_info_part_two.sig_13,
            sig_14: sig_info_part_two.sig_14,
            sig_15: sig_info_part_two.sig_15,
            sig_16: sig_info_part_two.sig_16,
            sig_17: sig_info_part_two.sig_17,
            sig_18: sig_info_part_two.sig_18,
            sig_19: sig_info_part_two.sig_19,
            sig_20: sig_info_part_two.sig_20,
            sig_21: sig_info_part_two.sig_21,
            sig_22: sig_info_part_two.sig_22,
            sig_23: sig_info_part_two.sig_23,
            sig_24: sig_info_part_two.sig_24,
            sig_25: sig_info_part_two.sig_25,
            sig_26: sig_info_part_two.sig_26,
            sig_27: sig_info_part_two.sig_27,
            sig_28: sig_info_part_two.sig_28
        };

        // Part three.
        let borrower_sig_part_three_for_borrower: SigPartThree = SigPartThree {
            owner: info.borrower,
            gates: 0u64,
            loan_id: info.id,
            the_undersigned: info.borrower,
            sig_length: sig_info_part_three.sig_length,
            sig_01: sig_info_part_three.sig_01,
            sig_02: sig_info_part_three.sig_02,
            sig_03: sig_info_part_three.sig_03,
            sig_04: sig_info_part_three.sig_04,
            sig_05: sig_info_part_three.sig_05,
            sig_06: sig_info_part_three.sig_06,
            sig_07: sig_info_part_three.sig_07,
            sig_08: sig_info_part_three.sig_08,
            sig_09: sig_info_part_three.sig_09,
            sig_10: sig_info_part_three.sig_10,
            sig_11: sig_info_part_three.sig_11,
            sig_12: sig_info_part_three.sig_12,
            sig_13: sig_info_part_three.sig_13,
            sig_14: sig_info_part_three.sig_14,
            sig_15: sig_info_part_three.sig_15,
            sig_16: sig_info_part_three.sig_16,
            sig_17: sig_info_part_three.sig_17,
            sig_18: sig_info_part_three.sig_18,
            sig_19: sig_info_part_three.sig_19,
            sig_20: sig_info_part_three.sig_20,
            sig_21: sig_info_part_three.sig_21,
            sig_22: sig_info_part_three.sig_22,
            sig_23: sig_info_part_three.sig_23,
            sig_24: sig_info_part_three.sig_24,
            sig_25: sig_info_part_three.sig_25,
            sig_26: sig_info_part_three.sig_26,
            sig_27: sig_info_part_three.sig_27
        };

        return (
            loan_application_record_for_borrower,
            borrower_sig_part_one_for_borrower,
            borrower_sig_part_two_for_borrower,
            borrower_sig_part_three_for_borrower,
            loan_application_record_for_lender,
            borrower_sig_part_one_for_lender,
            borrower_sig_part_two_for_lender,
            borrower_sig_part_three_for_lender
        ) then finalize(info.id, state, info.amount);
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
        sig_info_part_one: SigInfoPartOne,
        sig_info_part_two: SigInfoPartTwo,
        sig_info_part_three: SigInfoPartThree
    ) -> (
        Loan,
        MockCredits,
        SigPartOne, SigPartTwo, SigPartThree,
        Loan,
        MockCredits,
        SigPartOne, SigPartTwo, SigPartThree,
    ) {
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

        // Create loan disbursement record for the borrower to prove that the borrower has received the loan.
        let loan_disbursement_record_for_borrower: Loan = Loan {
            owner: loan_application_record.borrower,
            gates: 0u64,
            id: id,
            state: new_state,
            borrower: loan_application_record.borrower,
            borrower_name: loan_application_record.borrower_name,
            borrower_name_length: loan_application_record.borrower_name_length,
            borrower_addr_00: loan_application_record.borrower_addr_00,
            borrower_addr_01: loan_application_record.borrower_addr_01,
            borrower_addr_02: loan_application_record.borrower_addr_02,
            borrower_addr_03: loan_application_record.borrower_addr_03,
            borrower_addr_length: loan_application_record.borrower_addr_length,
            lender: loan_application_record.lender,
            lender_name: loan_application_record.lender_name,
            lender_name_length: loan_application_record.lender_name_length,
            lender_addr_00: loan_application_record.lender_addr_00,
            lender_addr_01: loan_application_record.lender_addr_01,
            lender_addr_02: loan_application_record.lender_addr_02,
            lender_addr_03: loan_application_record.lender_addr_03,
            lender_addr_length: loan_application_record.lender_addr_length,
            amount: loan_application_record.amount,
            currency: loan_application_record.currency,
            date: loan_application_record.date,
            repayment_deadline: loan_application_record.repayment_deadline,
            interest_rate: loan_application_record.interest_rate
        };

        // Part one.
        let lender_sig_part_one_for_borrower: SigPartOne = SigPartOne {
            owner: loan_application_record.borrower,
            gates: 0u64,
            loan_id: id,
            the_undersigned: loan_application_record.lender,
            sig_01: sig_info_part_one.sig_01,
            sig_02: sig_info_part_one.sig_02,
            sig_03: sig_info_part_one.sig_03,
            sig_04: sig_info_part_one.sig_04,
            sig_05: sig_info_part_one.sig_05,
            sig_06: sig_info_part_one.sig_06,
            sig_07: sig_info_part_one.sig_07,
            sig_08: sig_info_part_one.sig_08,
            sig_09: sig_info_part_one.sig_09,
            sig_10: sig_info_part_one.sig_10,
            sig_11: sig_info_part_one.sig_11,
            sig_12: sig_info_part_one.sig_12,
            sig_13: sig_info_part_one.sig_13,
            sig_14: sig_info_part_one.sig_14,
            sig_15: sig_info_part_one.sig_15,
            sig_16: sig_info_part_one.sig_16,
            sig_17: sig_info_part_one.sig_17,
            sig_18: sig_info_part_one.sig_18,
            sig_19: sig_info_part_one.sig_19,
            sig_20: sig_info_part_one.sig_20,
            sig_21: sig_info_part_one.sig_21,
            sig_22: sig_info_part_one.sig_22,
            sig_23: sig_info_part_one.sig_23,
            sig_24: sig_info_part_one.sig_24,
            sig_25: sig_info_part_one.sig_25,
            sig_26: sig_info_part_one.sig_26,
            sig_27: sig_info_part_one.sig_27,
            sig_28: sig_info_part_one.sig_28
        };

        // Part two.
        let lender_sig_part_two_for_borrower: SigPartTwo = SigPartTwo {
            owner: loan_application_record.borrower,
            gates: 0u64,
            loan_id: id,
            the_undersigned: loan_application_record.lender,
            sig_01: sig_info_part_two.sig_01,
            sig_02: sig_info_part_two.sig_02,
            sig_03: sig_info_part_two.sig_03,
            sig_04: sig_info_part_two.sig_04,
            sig_05: sig_info_part_two.sig_05,
            sig_06: sig_info_part_two.sig_06,
            sig_07: sig_info_part_two.sig_07,
            sig_08: sig_info_part_two.sig_08,
            sig_09: sig_info_part_two.sig_09,
            sig_10: sig_info_part_two.sig_10,
            sig_11: sig_info_part_two.sig_11,
            sig_12: sig_info_part_two.sig_12,
            sig_13: sig_info_part_two.sig_13,
            sig_14: sig_info_part_two.sig_14,
            sig_15: sig_info_part_two.sig_15,
            sig_16: sig_info_part_two.sig_16,
            sig_17: sig_info_part_two.sig_17,
            sig_18: sig_info_part_two.sig_18,
            sig_19: sig_info_part_two.sig_19,
            sig_20: sig_info_part_two.sig_20,
            sig_21: sig_info_part_two.sig_21,
            sig_22: sig_info_part_two.sig_22,
            sig_23: sig_info_part_two.sig_23,
            sig_24: sig_info_part_two.sig_24,
            sig_25: sig_info_part_two.sig_25,
            sig_26: sig_info_part_two.sig_26,
            sig_27: sig_info_part_two.sig_27,
            sig_28: sig_info_part_two.sig_28
        };

        // Part three.
        let lender_sig_part_three_for_borrower: SigPartThree = SigPartThree {
            owner: loan_application_record.borrower,
            gates: 0u64,
            loan_id: id,
            the_undersigned: loan_application_record.lender,
            sig_length: sig_info_part_three.sig_length,
            sig_01: sig_info_part_three.sig_01,
            sig_02: sig_info_part_three.sig_02,
            sig_03: sig_info_part_three.sig_03,
            sig_04: sig_info_part_three.sig_04,
            sig_05: sig_info_part_three.sig_05,
            sig_06: sig_info_part_three.sig_06,
            sig_07: sig_info_part_three.sig_07,
            sig_08: sig_info_part_three.sig_08,
            sig_09: sig_info_part_three.sig_09,
            sig_10: sig_info_part_three.sig_10,
            sig_11: sig_info_part_three.sig_11,
            sig_12: sig_info_part_three.sig_12,
            sig_13: sig_info_part_three.sig_13,
            sig_14: sig_info_part_three.sig_14,
            sig_15: sig_info_part_three.sig_15,
            sig_16: sig_info_part_three.sig_16,
            sig_17: sig_info_part_three.sig_17,
            sig_18: sig_info_part_three.sig_18,
            sig_19: sig_info_part_three.sig_19,
            sig_20: sig_info_part_three.sig_20,
            sig_21: sig_info_part_three.sig_21,
            sig_22: sig_info_part_three.sig_22,
            sig_23: sig_info_part_three.sig_23,
            sig_24: sig_info_part_three.sig_24,
            sig_25: sig_info_part_three.sig_25,
            sig_26: sig_info_part_three.sig_26,
            sig_27: sig_info_part_three.sig_27
        };

        // Create loan disbursement record for the lender to prove that the lender has disbursed the loan.
        let loan_disbursement_record_for_lender: Loan = Loan {
            owner: loan_application_record.lender,
            gates: 0u64,
            id: id,
            state: new_state,
            borrower: loan_application_record.borrower,
            borrower_name: loan_application_record.borrower_name,
            borrower_name_length: loan_application_record.borrower_name_length,
            borrower_addr_00: loan_application_record.borrower_addr_00,
            borrower_addr_01: loan_application_record.borrower_addr_01,
            borrower_addr_02: loan_application_record.borrower_addr_02,
            borrower_addr_03: loan_application_record.borrower_addr_03,
            borrower_addr_length: loan_application_record.borrower_addr_length,
            lender: loan_application_record.lender,
            lender_name: loan_application_record.lender_name,
            lender_name_length: loan_application_record.lender_name_length,
            lender_addr_00: loan_application_record.lender_addr_00,
            lender_addr_01: loan_application_record.lender_addr_01,
            lender_addr_02: loan_application_record.lender_addr_02,
            lender_addr_03: loan_application_record.lender_addr_03,
            lender_addr_length: loan_application_record.lender_addr_length,
            amount: loan_application_record.amount,
            currency: loan_application_record.currency,
            date: loan_application_record.date,
            repayment_deadline: loan_application_record.repayment_deadline,
            interest_rate: loan_application_record.interest_rate
        };

        // Part one.
        let lender_sig_part_one_for_lender: SigPartOne = SigPartOne {
            owner: loan_application_record.lender,
            gates: 0u64,
            loan_id: id,
            the_undersigned: loan_application_record.lender,
            sig_01: sig_info_part_one.sig_01,
            sig_02: sig_info_part_one.sig_02,
            sig_03: sig_info_part_one.sig_03,
            sig_04: sig_info_part_one.sig_04,
            sig_05: sig_info_part_one.sig_05,
            sig_06: sig_info_part_one.sig_06,
            sig_07: sig_info_part_one.sig_07,
            sig_08: sig_info_part_one.sig_08,
            sig_09: sig_info_part_one.sig_09,
            sig_10: sig_info_part_one.sig_10,
            sig_11: sig_info_part_one.sig_11,
            sig_12: sig_info_part_one.sig_12,
            sig_13: sig_info_part_one.sig_13,
            sig_14: sig_info_part_one.sig_14,
            sig_15: sig_info_part_one.sig_15,
            sig_16: sig_info_part_one.sig_16,
            sig_17: sig_info_part_one.sig_17,
            sig_18: sig_info_part_one.sig_18,
            sig_19: sig_info_part_one.sig_19,
            sig_20: sig_info_part_one.sig_20,
            sig_21: sig_info_part_one.sig_21,
            sig_22: sig_info_part_one.sig_22,
            sig_23: sig_info_part_one.sig_23,
            sig_24: sig_info_part_one.sig_24,
            sig_25: sig_info_part_one.sig_25,
            sig_26: sig_info_part_one.sig_26,
            sig_27: sig_info_part_one.sig_27,
            sig_28: sig_info_part_one.sig_28
        };

        // Part two.
        let lender_sig_part_two_for_lender: SigPartTwo = SigPartTwo {
            owner: loan_application_record.lender,
            gates: 0u64,
            loan_id: id,
            the_undersigned: loan_application_record.lender,
            sig_01: sig_info_part_two.sig_01,
            sig_02: sig_info_part_two.sig_02,
            sig_03: sig_info_part_two.sig_03,
            sig_04: sig_info_part_two.sig_04,
            sig_05: sig_info_part_two.sig_05,
            sig_06: sig_info_part_two.sig_06,
            sig_07: sig_info_part_two.sig_07,
            sig_08: sig_info_part_two.sig_08,
            sig_09: sig_info_part_two.sig_09,
            sig_10: sig_info_part_two.sig_10,
            sig_11: sig_info_part_two.sig_11,
            sig_12: sig_info_part_two.sig_12,
            sig_13: sig_info_part_two.sig_13,
            sig_14: sig_info_part_two.sig_14,
            sig_15: sig_info_part_two.sig_15,
            sig_16: sig_info_part_two.sig_16,
            sig_17: sig_info_part_two.sig_17,
            sig_18: sig_info_part_two.sig_18,
            sig_19: sig_info_part_two.sig_19,
            sig_20: sig_info_part_two.sig_20,
            sig_21: sig_info_part_two.sig_21,
            sig_22: sig_info_part_two.sig_22,
            sig_23: sig_info_part_two.sig_23,
            sig_24: sig_info_part_two.sig_24,
            sig_25: sig_info_part_two.sig_25,
            sig_26: sig_info_part_two.sig_26,
            sig_27: sig_info_part_two.sig_27,
            sig_28: sig_info_part_two.sig_28
        };

        // Part three.
        let lender_sig_part_three_for_lender: SigPartThree = SigPartThree {
            owner: loan_application_record.lender,
            gates: 0u64,
            loan_id: id,
            the_undersigned: loan_application_record.lender,
            sig_length: sig_info_part_three.sig_length,
            sig_01: sig_info_part_three.sig_01,
            sig_02: sig_info_part_three.sig_02,
            sig_03: sig_info_part_three.sig_03,
            sig_04: sig_info_part_three.sig_04,
            sig_05: sig_info_part_three.sig_05,
            sig_06: sig_info_part_three.sig_06,
            sig_07: sig_info_part_three.sig_07,
            sig_08: sig_info_part_three.sig_08,
            sig_09: sig_info_part_three.sig_09,
            sig_10: sig_info_part_three.sig_10,
            sig_11: sig_info_part_three.sig_11,
            sig_12: sig_info_part_three.sig_12,
            sig_13: sig_info_part_three.sig_13,
            sig_14: sig_info_part_three.sig_14,
            sig_15: sig_info_part_three.sig_15,
            sig_16: sig_info_part_three.sig_16,
            sig_17: sig_info_part_three.sig_17,
            sig_18: sig_info_part_three.sig_18,
            sig_19: sig_info_part_three.sig_19,
            sig_20: sig_info_part_three.sig_20,
            sig_21: sig_info_part_three.sig_21,
            sig_22: sig_info_part_three.sig_22,
            sig_23: sig_info_part_three.sig_23,
            sig_24: sig_info_part_three.sig_24,
            sig_25: sig_info_part_three.sig_25,
            sig_26: sig_info_part_three.sig_26,
            sig_27: sig_info_part_three.sig_27
        };

        return (
            loan_disbursement_record_for_borrower,
            mock_credits_to_borrower,
            lender_sig_part_one_for_borrower, lender_sig_part_two_for_borrower, lender_sig_part_three_for_borrower,
            loan_disbursement_record_for_lender,
            mock_credits_to_lender,
            lender_sig_part_one_for_lender, lender_sig_part_two_for_lender, lender_sig_part_three_for_lender
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
        current_date: u64,
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
        let start_date: u64 = loan_disbursement_record.date;
        assert(current_date >= start_date);

        let interest_rate: u64 = loan_disbursement_record.interest_rate;
        let principal_amount: u64 = loan_disbursement_record.amount;

        let days: u64 = elapsed_days(current_date, start_date);
        let interest_amount: u64 = days * interest_rate * principal_amount * 1000u64 / 365u64 / 100000u64;

        let principal_plus_interest_amount: u64 = principal_amount + interest_amount;
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
            owner: loan_disbursement_record.borrower,
            gates: 0u64,
            id: id,
            state: new_state,
            borrower: loan_disbursement_record.borrower,
            borrower_name: loan_disbursement_record.borrower_name,
            borrower_name_length: loan_disbursement_record.borrower_name_length,
            borrower_addr_00: loan_disbursement_record.borrower_addr_00,
            borrower_addr_01: loan_disbursement_record.borrower_addr_01,
            borrower_addr_02: loan_disbursement_record.borrower_addr_02,
            borrower_addr_03: loan_disbursement_record.borrower_addr_03,
            borrower_addr_length: loan_disbursement_record.borrower_addr_length,
            lender: loan_disbursement_record.lender,
            lender_name: loan_disbursement_record.lender_name,
            lender_name_length: loan_disbursement_record.lender_name_length,
            lender_addr_00: loan_disbursement_record.lender_addr_00,
            lender_addr_01: loan_disbursement_record.lender_addr_01,
            lender_addr_02: loan_disbursement_record.lender_addr_02,
            lender_addr_03: loan_disbursement_record.lender_addr_03,
            lender_addr_length: loan_disbursement_record.lender_addr_length,
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
            id: id,
            state: new_state,
            borrower: loan_disbursement_record.borrower,
            borrower_name: loan_disbursement_record.borrower_name,
            borrower_name_length: loan_disbursement_record.borrower_name_length,
            borrower_addr_00: loan_disbursement_record.borrower_addr_00,
            borrower_addr_01: loan_disbursement_record.borrower_addr_01,
            borrower_addr_02: loan_disbursement_record.borrower_addr_02,
            borrower_addr_03: loan_disbursement_record.borrower_addr_03,
            borrower_addr_length: loan_disbursement_record.borrower_addr_length,
            lender: loan_disbursement_record.lender,
            lender_name: loan_disbursement_record.lender_name,
            lender_name_length: loan_disbursement_record.lender_name_length,
            lender_addr_00: loan_disbursement_record.lender_addr_00,
            lender_addr_01: loan_disbursement_record.lender_addr_01,
            lender_addr_02: loan_disbursement_record.lender_addr_02,
            lender_addr_03: loan_disbursement_record.lender_addr_03,
            lender_addr_length: loan_disbursement_record.lender_addr_length,
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

    inline elapsed_days(current_date: u64, loan_start_date: u64) -> u64 {
        let one_day: u64 = 24u64 * 60u64 * 60u64;
        let elapsed_time: u64 = current_date - loan_start_date;
        return elapsed_time / one_day + (elapsed_time % one_day > 0u64 ? 1u64 : 0u64);
    }
}