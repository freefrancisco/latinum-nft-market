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

### More manual testing, fulfillment with STX
* `(contract-call? .sip009-nft mint tx-sender)`
* `(contract-call? .tiny-market set-whitelisted .sip009-nft true)`
* `(contract-call? .tiny-market list-asset .sip009-nft {taker: none, token-id: u1, expiry: u500, price: u150, payment-asset-contract: none})`
* `(contract-call? .tiny-market fulfil-listing-stx u0 .sip009-nft)` This should fail, you can't buy from yourself
* `::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5` so this address can buy the nft
* `(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.tiny-market fulfil-listing-stx u0 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip009-nft)` now because we have a new transaction sender we need to specify the full address for the contract
Output:
```
Events emitted
{"type":"nft_transfer_event","nft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip009-nft::federation-starship","sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.tiny-market","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","value":"u1"}}
{"type":"stx_transfer_event","stx_transfer_event":{"sender":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"150"}}
```
### Testing fulfillment with sip010 fungible token
```
(contract-call? .sip009-nft mint tx-sender)
(contract-call? .sip010-token mint u1000 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5)
(contract-call? .tiny-market set-whitelisted .sip009-nft true)
(contract-call? .tiny-market set-whitelisted .sip010-token true)
(contract-call? .tiny-market list-asset .sip009-nft {taker: none, token-id: u1, expiry: u500, price: u800, payment-asset-contract: (some .sip010-token)})
::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5

(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.tiny-market fulfil-listing-stx u0 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip009-nft) ;; should be error, stx payment is wrong payment asset
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.tiny-market fulfil-listing-ft u0 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip009-nft 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip010-token)
;; output:
Events emitted
{"type":"nft_transfer_event","nft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip009-nft::federation-starship","sender":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.tiny-market","recipient":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","value":"u1"}}
{"type":"contract_event","contract_event":{"contract_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip010-token","topic":"print","value":"none"}}
{"type":"ft_transfer_event","ft_transfer_event":{"asset_identifier":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.sip010-token::gold-pressed-latinum","sender":"ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5","recipient":"ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM","amount":"800"}}
(ok u0)
```
