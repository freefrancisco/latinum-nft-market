# A Market For NFTs Using Stacks Protocol
This is a minimum viable market for NFTs, including an NFT contract and a contract for a fungible token.
All of this is implemented in the Clarity language.

### Manual Testing
To test it works manually, first run `clarity console`, and try the following commands:

* Mint an NFT: `(contract-call? .sip009-nft mint tx-sender)`
* Check you own it: `(contract-call? .sip009-nft get-owner u1)`
* List your NFT for sale (this should fail) `(contract-call? .tiny-market list-asset .sip009-nft {taker: none, token-id: u1, expiry: u500, price: u1000, payment-asset-contract: none})`
* Whitelist your nft contract so you can list your NFT for sale in the market `(contract-call? .tiny-market set-whitelisted .sip009-nft true)`
* List your NFT for sale (this should succeed now thaat the contract is whitelisted) `(contract-call? .tiny-market list-asset .sip009-nft {taker: none, token-id: u1, expiry: u500, price: u1000, payment-asset-contract: none})`
* Check the listing for the sale of your NFT `(contract-call? .tiny-market get-listing u0)`
* Check the NFT owner (should be the contract now) `(contract-call? .sip009-nft get-owner u1)`
* List an NFT you don't own (this should fail) `(contract-call? .tiny-market list-asset .sip009-nft {taker: none, token-id: u555, expiry: u500, price: u1000, payment-asset-contract: none})`
* cancel your listing `(contract-call? .tiny-market cancel-listing u0 .sip009-nft)`
* Check ownership (should have reverted from contract to you) `(contract-call? .sip009-nft get-owner u1)`

# Other
