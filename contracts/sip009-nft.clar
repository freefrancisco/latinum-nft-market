
;; sip009-nft
;; Contract that specifies the NFT to be sold in tiny market

(impl-trait .sip009-nft-trait.sip009-nft-trait)

(define-non-fungible-token beach-bum uint)

(define-read-only (get-last-token-id)
    (ok u0) ;;TODO implement
)

(define-read-only (get-owner (nft uint))
    (ok (some tx-sender)) ;; TODO implement
)

(define-read-only (get-token-uri (nft uint)) (ok none))

(define-public (transfer (nft uint) (from principal) (to principal))
    (ok true) ;; TODO implement
)
