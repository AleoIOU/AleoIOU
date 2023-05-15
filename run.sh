#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# The private key and address of the debtor.
# Swap these into program.json, when running transactions as the debtor.
# "private_key": "APrivateKey1zkpBg8aN5h7rsSUHNEGZetFpUn7dgoutZhorCS1veaiH4YZ"
# "address": aleo1z5eut5f5x7r45c8ut3xmt5wrsxdkpjrtksn5pu3d9af3zsr8ju8sm64tkz

# The private key and address of the creditor.
# Swap these into program.json, when running transactions as the creditor.
# "private_key": "APrivateKey1zkpG9Af9z5Ha4ejVyMCqVFXRKknSm8L1ELEwcc4htk9YhVK"
# "address": aleo1yzlta2q5h8t0fqe0v6dyh9mtv4aggd53fgzr068jvplqhvqsnvzq7pj2ke

echo "
###############################################################################
########                                                               ########
########             Debtor applies for loan from creditor.            ########
########                                                               ########
###############################################################################
"

# Swap in the private key and address of the debtor to program.json.
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
########               Creditor disburses loan to debtor.              ########
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
########                Debtor repays loan to creditor.                ########
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
########   The creditor confirms the repayment and settles the loan.   ########
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