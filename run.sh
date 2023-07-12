#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# The private key and address of the borrower.
# Swap these into program.json, when running transactions as the borrower.
# "private_key": "APrivateKey1zkpBg8aN5h7rsSUHNEGZetFpUn7dgoutZhorCS1veaiH4YZ"
# "address": aleo1z5eut5f5x7r45c8ut3xmt5wrsxdkpjrtksn5pu3d9af3zsr8ju8sm64tkz

# The private key and address of the lender.
# Swap these into program.json, when running transactions as the lender.
# "private_key": "APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK"
# "address": aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke

echo "
#####################################################################################
########                                                                     ########
########        STEP 1: The borrower applies for a loan to the lender        ########
########                                                                     ########
########       -------------------------------------------------------       ########
########       |   Transition   |     Apply                          |       ########
########       |   State        |     Applied for loan               |       ########
########       -------------------------------------------------------       ########
########       |   Input  #1    |     Loan information               |       ########
########       -------------------------------------------------------       ########
########       |   Output #1    |     Loan application record        |       ########
########       |                |     (owner: borrower)              |       ########
########       |                |                                    |       ########
########       |   Output #2    |     Loan application record        |       ########
########       |                |     (owner: lender  )              |       ########
########       -------------------------------------------------------       ########
########                                                                     ########
#####################################################################################
"

# Swap in the private key and address of the borrower to program.json.
echo "{
  \"program\": \"aleo_iou_v2_2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpBg8aN5h7rsSUHNEGZetFpUn7dgoutZhorCS1veaiH4YZ\",
      \"address\": \"aleo1z5eut5f5x7r45c8ut3xmt5wrsxdkpjrtksn5pu3d9af3zsr8ju8sm64tkz\"
  },
  \"license\": \"MIT\"
}" > program.json

# Run the `apply` function
(
    leo run apply || exit
)

echo "
#####################################################################################
########                                                                     ########
########        STEP 2: The lender disburses the loan to the borrower        ########
########                                                                     ########
########       -------------------------------------------------------       ########
########       |   Transition   |     Disburse                       |       ########
########       |   State        |     Applied for loan               |       ########
########       |                |         ↓                          |       ########
########       |                |     Loan disbursed                 |       ########
########       -------------------------------------------------------       ########
########       |   Input  #1    |     Loan application record        |       ########
########       |                |     (owner: lender  )              |       ########
########       |   Input  #2    |     Lender's credits record        |       ########
########       |                |     (owner: lender  )              |       ########
########       -------------------------------------------------------       ########
########       |   Output #1    |     Loan disbursement record       |       ########
########       |                |     (owner: borrower)              |       ########
########       |   Output #2    |     Loan credits                   |       ########
########       |                |     (owner: borrower)              |       ########
########       |                |                                    |       ########
########       |   Output #3    |     Loan disbursement record       |       ########
########       |                |     (owner: lender)                |       ########
########       |   Output #4    |     Remaining credits              |       ########
########       |                |     (owner: lender)                |       ########
########       -------------------------------------------------------       ########
########                                                                     ########
#####################################################################################

"

echo "{
  \"program\": \"aleo_iou_v2_2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK\",
      \"address\": \"aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke\"
  },
  \"license\": \"MIT\"
}" > program.json

# Run the `disburse` function
(
    leo run disburse || exit
)

echo "
#####################################################################################
########                                                                     ########
########         STEP 3: The borrower repays the loan to the lender          ########
########                                                                     ########
########       -------------------------------------------------------       ########
########       |   Transition   |     Repay                          |       ########
########       |   State        |     Loan disbursed                 |       ########
########       |                |         ↓                          |       ########
########       |                |     Loan repaid                    |       ########
########       -------------------------------------------------------       ########
########       |   Input  #1    |     Loan application record        |       ########
########       |                |     (owner: borrower)              |       ########
########       |   Input  #2    |     Loan disbursement record       |       ########
########       |                |     (owner: borrower)              |       ########
########       |   Input  #3    |     Borrower's credits record      |       ########
########       |                |     (owner: borrower)              |       ########
########       |   Input  #4    |     Start block height             |       ########
########       |   Input  #5    |     End block height               |       ########
########       -------------------------------------------------------       ########
########       |   Output #1    |     Loan repayment record          |       ########
########       |                |     (owner: borrower)              |       ########
########       |   Output #2    |     Remaining credits              |       ########
########       |                |     (owner: borrower)              |       ########
########       |                |                                    |       ########
########       |   Output #3    |     Loan repayment record          |       ########
########       |                |     (owner: lender)                |       ########
########       |   Output #4    |     Repayment credits              |       ########
########       |                |     (owner: lender)                |       ########
########       -------------------------------------------------------       ########
#####################################################################################
"

echo "{
  \"program\": \"aleo_iou_v2_2.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpBg8aN5h7rsSUHNEGZetFpUn7dgoutZhorCS1veaiH4YZ\",
      \"address\": \"aleo1z5eut5f5x7r45c8ut3xmt5wrsxdkpjrtksn5pu3d9af3zsr8ju8sm64tkz\"
  },
  \"license\": \"MIT\"
}" > program.json

# Run the `repay` function
(
    leo run repay || exit
)