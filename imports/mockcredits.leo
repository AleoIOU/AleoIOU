// The 'mockcredits' program.
program mockcredits.aleo {
    // On-chain storage of an `account` map, with `address` as the key,
    // and `u64` as the value.
    mapping account: address => u64;

    record mockcredits {
        // The mockcredits owner.
        owner: address,
        // The mockcredits amount.
        microcredits: u64,
    }

    /* Mint */

    // The function `mint_public` issues the specified mockcredits amount for the mockcredits receiver publicly on the network.
    transition mint_public(public receiver: address, public amount: u64) {
        // Mint the mockcredits publicly by invoking the computation on-chain.
        return then finalize(receiver, amount);
    }

    finalize mint_public(public receiver: address, public amount: u64) {
        // Increments `account[receiver]` by `amount`.
        // If `account[receiver]` does not exist, it will be created.
        // If `account[receiver] + amount` overflows, `mint_public` is reverted.
        let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

    // The function `mint_private` initializes a new record with the specified amount of mockcredits for the receiver.
    transition mint_private(receiver: address, amount: u64) -> mockcredits {
        return mockcredits {
            owner: receiver,
            microcredits: amount,
        };
    }

    /* Transfer */
    transition transfer_public(public receiver: address, public amount: u64) {
        // Transfer the mockcredits publicly, by invoking the computation on-chain.
        return then finalize(self.caller, receiver, amount);
    }

    finalize transfer_public(public sender: address, public receiver: address, public amount: u64) {
        // Decrements `account[sender]` by `amount`.
        // If `account[sender]` does not exist, it will be created.
        // If `account[sender] - amount` underflows, `transfer_public` is reverted.
        let sender_amount: u64 = Mapping::get_or_use(account, sender, 0u64);
        Mapping::set(account, sender, sender_amount - amount);
        
        // Increments `account[receiver]` by `amount`.
        // If `account[receiver]` does not exist, it will be created.
        // If `account[receiver] + amount` overflows, `transfer_public` is reverted.
        let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

    // The function `transfer_private` sends the specified mockcredits amount to the mockcredits receiver from the specified mockcredits record.
    transition transfer_private(sender: mockcredits, receiver: address, amount: u64) -> (mockcredits, mockcredits) {
        // Checks the given mockcredits record has sufficient balance.
        // This `sub` operation is safe, and the proof will fail if an overflow occurs.
        // `difference` holds the change amount to be returned to sender.
        let difference: u64 = sender.microcredits - amount;

        // Produce a mockcredits record with the change amount for the sender.
        let remaining: mockcredits = mockcredits {
            owner: sender.owner,
            microcredits: difference,
        };

        // Produce a mockcredits record for the specified receiver.
        let transferred: mockcredits = mockcredits {
            owner: receiver,
            microcredits: amount,
        };

        // Output the sender's change record and the receiver's record.
        return (remaining, transferred);
    }

    // The function `transfer_private_to_public` turns a specified mockcredits amount from a mockcredits record into public mockcredits for the specified receiver.
    // This function preserves privacy for the sender's record, however it publicly reveals the mockcredits receiver and the mockcredits amount.
    transition transfer_private_to_public(sender: mockcredits, public receiver: address, public amount: u64) -> mockcredits {
        // Checks the given mockcredits record has a sufficient mockcredits amount.
        // This `sub` operation is safe, and the proof will fail if an underflow occurs.
        // `difference` holds the change amount for the caller.
        let difference: u64 = sender.microcredits - amount;

        // Produces a mockcredits record with the change amount for the caller.
        let remaining: mockcredits = mockcredits {
            owner: sender.owner,
            microcredits: difference,
        };

        // Output the sender's change record.
        // Increment the mockcredits amount publicly for the mockcredits receiver.
        return remaining then finalize(receiver, amount);
    }

    finalize transfer_private_to_public(public receiver: address, public amount: u64) {
        // Increments `account[receiver]` by `amount`.
        // If `account[receiver]` does not exist, it will be created.
        // If `account[receiver] + amount` overflows, `transfer_private_to_public` is reverted.
        let receiver_amount: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

    // The function `transfer_public_to_private` turns a specified mockcredits amount from `account` into a mockcredits record for the specified receiver.
    // This function preserves privacy for the receiver's record, however it publicly reveals the caller and the specified mockcredits amount.
    transition transfer_public_to_private(public receiver: address, public amount: u64) -> mockcredits {
        // Produces a mockcredits record for the mockcredits receiver.
        let transferred: mockcredits = mockcredits {
            owner: receiver,
            microcredits: amount,
        };

        // Output the receiver's record.
        // Decrement the mockcredits amount of the caller publicly.
        return transferred then finalize(self.caller, amount);
    }

    finalize transfer_public_to_private(public sender: address, public amount: u64) {
        // Decrements `account[sender]` by `amount`.
        // If `account[sender]` does not exist, it will be created.
        // If `account[sender] - amount` underflows, `transfer_public_to_private` is reverted.
        let sender_amount: u64 = Mapping::get_or_use(account, sender, 0u64);
        Mapping::set(account, sender, sender_amount - amount);
    }
}
