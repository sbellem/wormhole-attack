The (hot)fix for the attack was to validate the input `accs` (in the `if` statement) to
the `verify_signatures` function:

```rust
// solana/bridge/program/src/api/verify_signature.rs

pub fn verify_signatures(
    ctx: &ExecutionContext,
    accs: &mut VerifySignatures,
    data: VerifySignaturesData,
) -> Result<()> {
    if *accs.instruction_acc.key != solana_program::sysvar::instructions::id() {
        return Err(SolitaireError::InvalidSysvar(*accs.instruction_acc.key));
    }
```

What is `accs`? It's a `VerifySignatures` struct:

```rust

#[derive(FromAccounts)]
// solana/bridge/program/src/api/verify_signature.rs

pub struct VerifySignatures<'b> {
    /// Payer for account creation
    pub payer: Mut<Signer<Info<'b>>>,

    /// Guardian set of the signatures
    pub guardian_set: GuardianSet<'b, { AccountState::Initialized }>,

    /// Signature Account
    pub signature_set: Mut<Signer<SignatureSet<'b, { AccountState::MaybeInitialized }>>>,

    /// Instruction reflection account (special sysvar)
    pub instruction_acc: Info<'b>,
}
```

We're interested in the field `instruction_acc`, which is an `Info` type, which is
an alias for `AccountInfo`:

```rust
// solana/solitaire/program/src/types/accounts.rs

/// A short alias for AccountInfo.
pub type Info<'r> = AccountInfo<'r>;
```

What is [`AccountInfo`](https://docs.rs/solana-program/latest/solana_program/account_info/struct.AccountInfo.html)?

It's a struct ([`solana_program::account_info::AccountInfo`](https://docs.rs/solana-program/latest/solana_program/account_info/struct.AccountInfo.html#)):

```rust
pub struct AccountInfo<'a> {
    pub key: &'a Pubkey,
    pub is_signer: bool,
    pub is_writable: bool,
    pub lamports: Rc<RefCell<&'a mut u64>>,
    pub data: Rc<RefCell<&'a mut [u8]>>,
    pub owner: &'a Pubkey,
    pub executable: bool,
    pub rent_epoch: Epoch,
}
```

_to be continued_
