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
###############################################################################
########                                                               ########
########             Borrower applies for loan from lender.            ########
########                                                               ########
###############################################################################
"

# Swap in the private key and address of the borrower to program.json.
echo "{
  \"program\": \"iou.aleo\",
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
###############################################################################
########                                                               ########
########               Lender disburses loan to borrower.              ########
########                                                               ########
###############################################################################
"

echo "{
  \"program\": \"iou.aleo\",
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
###############################################################################
########                                                               ########
########                Borrower repays loan to lender.                ########
########                                                               ########
###############################################################################
"

echo "{
  \"program\": \"iou.aleo\",
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

echo "
###############################################################################
########                                                               ########
########    The lender confirms the repayment and settles the loan.    ########
########                                                               ########
###############################################################################
"

echo "{
  \"program\": \"iou.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK\",
      \"address\": \"aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke\"
  },
  \"license\": \"MIT\"
}" > program.json

# Run the `settle` function
(
    leo run settle || exit
)