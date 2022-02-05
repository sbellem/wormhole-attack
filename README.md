# wormhole attack analysis
Scattered notes on the wormhole attack

## UPDATE
Incident report: https://wormholecrypto.medium.com/wormhole-incident-report-02-02-22-ad9b8f21eec6

The fix: https://github.com/certusone/wormhole/commit/e8b91810a9bb35c3c139f86b4d0795432d647305

Validate the `accs` input:

```rust
pub fn verify_signatures(
    ctx: &ExecutionContext,
    accs: &mut VerifySignatures,
    data: VerifySignaturesData,
) -> Result<()> {
    if *accs.instruction_acc.key != solana_program::sysvar::instructions::id() {
        return Err(SolitaireError::InvalidSysvar(*accs.instruction_acc.key));
    }
// ...
```    

Excerpt from the [incident report](https://wormholecrypto.medium.com/wormhole-incident-report-02-02-22-ad9b8f21eec6):

> ### Vulnerability
> The root cause of the exploit was a bug in the signature verification code of the core Wormhole contract on Solana. This bug allowed the attacker to forge a message from the Guardians to mint Wormhole-wrapped Ether.
>
> On Solana, Portal’s token minting program uses the verify_signatures function to validate the source chain message before minting Wormhole-wrapped tokens. This process relies on information contained in the instruction sysvar account, which is trusted because it is populated by the Solana runtime.
>
> Users can specify arbitrary input accounts when calling a function on Solana. Each program is responsible for validating that the provided accounts are the ones they expected. The issue in the exploitable version was that the verify_signatures function did not assert that the user provided account was the special instruction sysvar.
>
> An attacker could craft an account and populate it with data to make it look like the instruction sysvar account. This fake instruction sysvar could then be passed to Wormhole’s verify_signatures function to fool it into thinking that the signatures had been successfully verified. Any arbitrary Wormhole message with Solana as the destination chain could be signed by an attacker, including messages to mint wrapped Wormhole tokens on Solana.
>
> The vulnerability was fixed by adding the missing [check](https://github.com/certusone/wormhole/commit/e8b91810a9bb35c3c139f86b4d0795432d647305):
>
> ![image](https://user-images.githubusercontent.com/125458/152638476-df202fca-f0c4-4b56-9df1-86faa03b1a1d.png)




## Using Soteria to detect the vulnerability
The Dockerfile sets a wormhole version prior to the patched version, and uses soteria
to scan the code for vulnerabilities. See
https://www.soteria.dev/post/the-wormhole-hack-how-soteria-detects-the-vulnerability-automatically
for details about the attack and soteria.

The quickest way to run the example is by using the image from dockerhub:

```console
docker run --rm sbellem/wormhole-soteria-scan
```

Alternatively, clone this repo, e.g.:

```console
git clone https://github.com/sbellem/wormhole-attack-analysis.git
```

and run:

```console
docker-compose run --rm wormhole-soteria-scan
```

You should see an output similar to:

![image](https://user-images.githubusercontent.com/125458/152494070-29558993-993a-49bf-8218-6b2a59dea54a.png)


## Questions
Which version of wormhole has been attacked? The above blog seems to imply that it was the dev.v1 branch, but that is not a release, and it does not seem to be recent. The latest release is v2.7.2 ...
