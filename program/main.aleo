import credits.aleo;
program aleo_iou_v1.aleo;


struct LoanInfo:
    id as field;
    borrower as address;
    borrower_name as field;
    borrower_address as field;
    borrower_signature as field;
    lender as address;
    lender_name as field;
    lender_address as field;
    amount as u64;
    repayment_deadline as u64;
    interest_rate as u64;

record Application:
    owner as address.private;
    gates as u64.private;
    id as field.private;
    borrower as address.private;
    borrower_name as field.private;
    borrower_address as field.private;
    borrower_signature as field.private;
    lender as address.private;
    lender_name as field.private;
    lender_address as field.private;
    amount as u64.private;
    repayment_deadline as u64.private;
    interest_rate as u64.private;

record Disbursement:
    owner as address.private;
    gates as u64.private;
    id as field.private;
    lender_signature as field.private;
    start_block_height as field.private;

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

function apply:
    input r0 as LoanInfo.private;
    assert.eq self.caller r0.borrower;
    gte r0.interest_rate 2u64 into r1;
    assert.eq r1 true;
    gte r0.amount 25000u64 into r2;
    assert.eq r2 true;
    cast r0.lender 0u64 r0.id r0.borrower r0.borrower_name r0.borrower_address r0.borrower_signature r0.lender r0.lender_name r0.lender_address r0.amount r0.repayment_deadline r0.interest_rate into r3 as Application.record;
    cast r0.borrower 0u64 r0.id r0.borrower r0.borrower_name r0.borrower_address r0.borrower_signature r0.lender r0.lender_name r0.lender_address r0.amount r0.repayment_deadline r0.interest_rate into r4 as Application.record;
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
    input r2 as field.private;
    input r3 as field.private;
    gte r1.microcredits r0.amount into r4;
    assert.eq r4 true;
    cast r2 into r5 as u32;
    call credits.aleo/transfer_private r1 r0.borrower r0.amount into r6 r7;
    cast r0.borrower 0u64 r0.id r3 r2 into r8 as Disbursement.record;
    cast r0.lender 0u64 r0.id r3 r2 into r9 as Disbursement.record;
    output r8 as Disbursement.record;
    output r7 as credits.aleo/credits.record;
    output r9 as Disbursement.record;
    output r6 as credits.aleo/credits.record;

    finalize r0.id 2u8 r5;

finalize disburse:
    input r0 as field.public;
    input r1 as u8.public;
    input r2 as u32.public;
    get loan_states[r0] into r3;
    assert.eq r3 1u8;
    gte r2 block.height into r4;
    assert.eq r4 true;
    set r1 into loan_states[r0];




function repay:
    input r0 as Application.record;
    input r1 as Disbursement.record;
    input r2 as credits.aleo/credits.record;
    input r3 as field.private;
    assert.eq r0.id r1.id;
    cast r1.start_block_height into r4 as u64;
    cast r3 into r5 as u64;
    cast r3 into r6 as u32;
    gte r5 r4 into r7;
    assert.eq r7 true;
    sub r5 r4 into r8;
    mul r8 15u64 into r9;
    mul 24u64 60u64 into r10;
    mul r10 60u64 into r11;
    div r9 r11 into r12;
    rem r9 r11 into r13;
    gt r13 0u64 into r14;
    ternary r14 1u64 0u64 into r15;
    add r12 r15 into r16;
    mul r16 r0.interest_rate into r17;
    mul r17 r0.amount into r18;
    mul r18 1000u64 into r19;
    div r19 365u64 into r20;
    div r20 100000u64 into r21;
    add r0.amount r21 into r22;
    sub r2.microcredits r22 into r23;
    gte r23 0u64 into r24;
    assert.eq r24 true;
    call credits.aleo/transfer_private r2 r0.lender r22 into r25 r26;
    cast r0.borrower 0u64 r0.id r3 into r27 as Repayment.record;
    cast r0.lender 0u64 r0.id r3 into r28 as Repayment.record;
    output r27 as Repayment.record;
    output r25 as credits.aleo/credits.record;
    output r28 as Repayment.record;
    output r26 as credits.aleo/credits.record;

    finalize r0.id 3u8 r6;

finalize repay:
    input r0 as field.public;
    input r1 as u8.public;
    input r2 as u32.public;
    get loan_states[r0] into r3;
    assert.eq r3 2u8;
    gte r2 block.height into r4;
    assert.eq r4 true;
    set r1 into loan_states[r0];
