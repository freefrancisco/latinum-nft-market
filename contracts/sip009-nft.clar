
;; sip009-nft
;; Contract that specifies the NFT to be sold in tiny market

;; here I tell the contract that it must implement the nft trait
(impl-trait .sip009-nft-trait.sip009-nft-trait)

;; the name of the nft and the unit of the id
(define-non-fungible-token beach-bum-nft uint)

;; constants
(define-constant not-owner-error (err u100))

;; variables
(define-data-var last-token-id uint u0)

;; functions that implement the nft trait
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-owner (nft-id uint))
    (ok (nft-get-owner? beach-bum-nft nft-id))
)

(define-read-only (get-token-uri (nft-id uint)) (ok none)) ;; not implemented

(define-public (transfer (nft-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) not-owner-error)
        (nft-transfer? beach-bum-nft nft-id sender recipient)
    )
)
