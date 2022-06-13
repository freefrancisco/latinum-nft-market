
;; sip009-nft
;; Contract that specifies the NFT to be sold in tiny market

;; here I tell the contract that it must implement the nft trait
(impl-trait .sip009-nft-trait.sip009-nft-trait)

;; the name of the nft and the unit of the id
(define-non-fungible-token federation-starship uint)

;; constants
(define-constant contract-owner tx-sender)
;; error constants
(define-constant not-nft-owner-error (err u100))
(define-constant not-contract-owner-error (err u101))

;; variables
(define-data-var last-token-id uint u0)

;; functions that implement the nft trait
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-owner (nft-id uint))
    (ok (nft-get-owner? federation-starship nft-id))
)

(define-read-only (get-token-uri (nft-id uint)) (ok none)) ;; not implemented

(define-public (transfer (nft-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) not-nft-owner-error)
        (nft-transfer? federation-starship nft-id sender recipient)
    )
)

(define-public (mint (recipient principal))
    (let
        (
            (token-id (+ u1 (var-get last-token-id)))
        )
        (var-set last-token-id token-id)
        (asserts!  (is-eq tx-sender contract-owner) not-contract-owner-error)
        (nft-mint? federation-starship token-id recipient)
    )
)
