import credits.aleo;
program aleo_iou_v2.aleo;


struct LoanInfo:
    id as field;
    borrower as address;
    borrower_name as field;
    borrower_name_len as u32;
    borrower_addr_01 as field;
    borrower_addr_02 as field;
    borrower_addr_len as u32;
    lender as address;
    lender_name as field;
    lender_name_len as u32;
    lender_addr_01 as field;
    lender_addr_02 as field;
    lender_addr_len as u32;
    amount as u64;
    repayment_deadline as u64;
    interest_rate as u64;

record Application:
    owner as address.private;
    gates as u64.private;
    id as field.private;
    borrower as address.private;
    borrower_name as field.private;
    borrower_name_len as u32.private;
    borrower_addr_01 as field.private;
    borrower_addr_02 as field.private;
    borrower_addr_len as u32.private;
    lender as address.private;
    lender_name as field.private;
    lender_name_len as u32.private;
    lender_addr_01 as field.private;
    lender_addr_02 as field.private;
    lender_addr_len as u32.private;
    amount as u64.private;
    repayment_deadline as u64.private;
    interest_rate as u64.private;

record Disbursement:
    owner as address.private;
    gates as u64.private;
    id as field.private;

record Repayment:
    owner as address.private;
    gates as u64.private;
    id as field.private;
    end_block_height as field.private;


mapping loan_states:
	key left as field.public;
	value right as u8.public;


mapping loan_amounts:
	key left as field.public;
	value right as u64.public;


mapping loan_start_heights:
	key left as field.public;
	value right as u32.public;

function apply:
    input r0 as LoanInfo.private;
    assert.eq self.caller r0.borrower;
    gte r0.interest_rate 2u64 into r1;
    assert.eq r1 true;
    gte r0.amount 25000u64 into r2;
    assert.eq r2 true;
    cast r0.lender 0u64 r0.id r0.borrower r0.borrower_name r0.borrower_name_len r0.borrower_addr_01 r0.borrower_addr_02 r0.borrower_addr_len r0.lender r0.lender_name r0.lender_name_len r0.lender_addr_01 r0.lender_addr_02 r0.lender_addr_len r0.amount r0.repayment_deadline r0.interest_rate into r3 as Application.record;
    cast r0.borrower 0u64 r0.id r0.borrower r0.borrower_name r0.borrower_name_len r0.borrower_addr_01 r0.borrower_addr_02 r0.borrower_addr_len r0.lender r0.lender_name r0.lender_name_len r0.lender_addr_01 r0.lender_addr_02 r0.lender_addr_len r0.amount r0.repayment_deadline r0.interest_rate into r4 as Application.record;
    output r4 as Application.record;
    output r3 as Application.record;

    finalize r0.id 1u8 r0.amount;

finalize apply:
    input r0 as field.public;
    input r1 as u8.public;
    input r2 as u64.public;
    get.or_use loan_states[r0] 0u8 into r3;
    assert.eq r3 0u8;
    set r1 into loan_states[r0];
    set r2 into loan_amounts[r0];


function disburse:
    input r0 as Application.record;
    input r1 as credits.aleo/credits.record;
    gte r1.microcredits r0.amount into r2;
    assert.eq r2 true;
    call credits.aleo/transfer_private r1 r0.borrower r0.amount into r3 r4;
    cast r0.borrower 0u64 r0.id into r5 as Disbursement.record;
    cast r0.lender 0u64 r0.id into r6 as Disbursement.record;
    output r5 as Disbursement.record;
    output r4 as credits.aleo/credits.record;
    output r6 as Disbursement.record;
    output r3 as credits.aleo/credits.record;

    finalize r0.id 2u8;

finalize disburse:
    input r0 as field.public;
    input r1 as u8.public;
    get loan_states[r0] into r2;
    assert.eq r2 1u8;
    set r1 into loan_states[r0];
    set block.height into loan_start_heights[r0];




function repay:
    input r0 as Application.record;
    input r1 as Disbursement.record;
    input r2 as credits.aleo/credits.record;
    input r3 as field.private;
    input r4 as field.private;
    assert.eq r0.id r1.id;
    cast r3 into r5 as u64;
    cast r4 into r6 as u64;
    cast r4 into r7 as u32;
    gte r6 r5 into r8;
    assert.eq r8 true;
    sub r6 r5 into r9;
    mul r9 15u64 into r10;
    mul 24u64 60u64 into r11;
    mul r11 60u64 into r12;
    div r10 r12 into r13;
    rem r10 r12 into r14;
    gt r14 0u64 into r15;
    ternary r15 1u64 0u64 into r16;
    add r13 r16 into r17;
    mul r17 r0.interest_rate into r18;
    mul r18 r0.amount into r19;
    mul r19 1000u64 into r20;
    div r20 365u64 into r21;
    div r21 100000u64 into r22;
    add r0.amount r22 into r23;
    sub r2.microcredits r23 into r24;
    gte r24 0u64 into r25;
    assert.eq r25 true;
    call credits.aleo/transfer_private r2 r0.lender r23 into r26 r27;
    cast r0.borrower 0u64 r0.id r4 into r28 as Repayment.record;
    cast r0.lender 0u64 r0.id r4 into r29 as Repayment.record;
    output r28 as Repayment.record;
    output r26 as credits.aleo/credits.record;
    output r29 as Repayment.record;
    output r27 as credits.aleo/credits.record;

    finalize r0.id 3u8 r7;

finalize repay:
    input r0 as field.public;
    input r1 as u8.public;
    input r2 as u32.public;
    get loan_states[r0] into r3;
    assert.eq r3 2u8;
    gte r2 block.height into r4;
    assert.eq r4 true;
    set r1 into loan_states[r0];
