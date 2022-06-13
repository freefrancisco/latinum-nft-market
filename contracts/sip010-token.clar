
;; sip010-token
;; <add a description here>

(impl-trait .sip010-ft-trait.sip010-ft-trait)

(define-fungible-token gold-pressed-latinum u100000000)

;; constants
(define-constant contract-owner tx-sender)
;; error constants
(define-constant not-token-owner-error (err u100))
(define-constant not-contract-owner-error (err u101))

;; functions that implement the ft trait

(define-read-only (get-name)
    (ok "Gold Pressed Latinum"))

(define-read-only (get-symbol)
    (ok "GPL"))

(define-read-only
    (get-decimals) (ok u6))

(define-read-only (get-total-supply)
    (ok (ft-get-supply gold-pressed-latinum)))

(define-read-only (get-token-uri)
    (ok none)) ;; not implemented

(define-read-only (get-balance (farenghi principal))
    (ok (ft-get-balance gold-pressed-latinum farenghi)))

(define-public
    (transfer
        (amount uint)
        (sender principal)
        (recipient principal)
        (memo (optional (buff 34))))
    (begin
        (print memo)
        (asserts!  (is-eq tx-sender sender) not-token-owner-error)
        (ft-transfer? gold-pressed-latinum amount sender recipient)))

(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) not-contract-owner-error)
        (ft-mint? gold-pressed-latinum amount recipient)))
