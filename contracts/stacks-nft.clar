;; Title: Stacks NFT Gaming Platform - Revolutionizing Gaming with Blockchain
;; Summary: A cutting-edge smart contract designed to manage a decentralized gaming ecosystem on the Stacks blockchain,
;; integrating NFTs, player progression, and Bitcoin rewards.
;; Description: This smart contract establishes a robust gaming platform on the Stacks blockchain, leveraging the security and transparency of Bitcoin.
;; It enables the creation, management, and trading of in-game assets as NFTs, tracks player performance, and distributes Bitcoin rewards based on leaderboard rankings.
;; The contract ensures secure operations through a whitelist of authorized administrators and comprehensive validation mechanisms,
;; making it a compliant and efficient solution for Layer 2 gaming on Stacks.

;; Error Constants
(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-INVALID-GAME-ASSET (err u2))
(define-constant ERR-INSUFFICIENT-FUNDS (err u3))
(define-constant ERR-TRANSFER-FAILED (err u4))
(define-constant ERR-LEADERBOARD-FULL (err u5))
(define-constant ERR-ALREADY-REGISTERED (err u6))
(define-constant ERR-INVALID-REWARD (err u7))
(define-constant ERR-INVALID-INPUT (err u8))
(define-constant ERR-INVALID-SCORE (err u9))
(define-constant ERR-INVALID-FEE (err u10))
(define-constant ERR-INVALID-ENTRIES (err u11))
(define-constant ERR-PLAYER-NOT-FOUND (err u12))

;; Storage for game configuration and state
(define-data-var game-fee uint u10)
(define-data-var max-leaderboard-entries uint u50)
(define-data-var total-prize-pool uint u0)

;; NFT definition
(define-non-fungible-token game-asset uint)

;; Game Asset Metadata Map
(define-map game-asset-metadata 
  { token-id: uint }
  { 
    name: (string-ascii 50),
    description: (string-ascii 200),
    rarity: (string-ascii 20),
    power-level: uint
  }
)

;; Leaderboard Map
(define-map leaderboard 
  { player: principal }
  { 
    score: uint, 
    games-played: uint,
    total-rewards: uint 
  }
)

;; Whitelist for game creators and administrators
(define-map game-admin-whitelist principal bool)

;; Global variables
(define-data-var total-game-assets uint u0)

;; Read-only functions for validation

;; Check if sender is a game admin
(define-read-only (is-game-admin (sender principal))
  (default-to false (map-get? game-admin-whitelist sender))
)

;; Validate input string
(define-read-only (is-valid-string (input (string-ascii 200)))
  (> (len input) u0)
)

;; Validate principal
(define-read-only (is-valid-principal (input principal))
  (and 
    (not (is-eq input tx-sender))
    (not (is-eq input (as-contract tx-sender)))
  )
)

;; Enhanced principal validation
(define-read-only (is-safe-principal (input principal))
  (and 
    (is-valid-principal input)
    (or 
      (is-game-admin input)
      (is-some (map-get? leaderboard { player: input }))
    )
  )
)

;; Public Functions

;; Add game administrator
(define-public (add-game-admin (new-admin principal))
  (begin
    (asserts! (is-game-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-safe-principal new-admin) ERR-INVALID-INPUT)
    (map-set game-admin-whitelist new-admin true)
    (ok true)
  )
)

;; Mint new game asset NFT
(define-public (mint-game-asset 
  (name (string-ascii 50))
  (description (string-ascii 200))
  (rarity (string-ascii 20))
  (power-level uint)
)
  (let 
    (
      (token-id (+ (var-get total-game-assets) u1))
    )
    (asserts! (is-game-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-string name) ERR-INVALID-INPUT)
    (asserts! (is-valid-string description) ERR-INVALID-INPUT)
    (asserts! (is-valid-string rarity) ERR-INVALID-INPUT)
    (asserts! (and (>= power-level u0) (<= power-level u1000)) ERR-INVALID-INPUT)
    
    (try! (nft-mint? game-asset token-id tx-sender))
    
    (map-set game-asset-metadata 
      { token-id: token-id }
      {
        name: name,
        description: description, 
        rarity: rarity,
        power-level: power-level
      }
    )
    
    (var-set total-game-assets token-id)
    
    (ok token-id)
  )
)

;; Transfer game asset
(define-public (transfer-game-asset 
  (token-id uint) 
  (recipient principal)
)
  (begin
    (asserts! 
      (is-eq tx-sender (unwrap! (nft-get-owner? game-asset token-id) ERR-INVALID-GAME-ASSET))
      ERR-NOT-AUTHORIZED
    )
    
    (asserts! (is-safe-principal recipient) ERR-INVALID-INPUT)
    
    (nft-transfer? game-asset token-id tx-sender recipient)
  )
)

;; Player registration
(define-public (register-player)
  (let 
    (
      (registration-fee (var-get game-fee))
    )
    (asserts! 
      (>= (stx-get-balance tx-sender) registration-fee) 
      ERR-INSUFFICIENT-FUNDS
    )
    
    (asserts! 
      (is-none (map-get? leaderboard { player: tx-sender }))
      ERR-ALREADY-REGISTERED
    )
    
    (try! (stx-transfer? registration-fee tx-sender (as-contract tx-sender)))
    
    (map-set leaderboard 
      { player: tx-sender }
      {
        score: u0,
        games-played: u0,
        total-rewards: u0
      }
    )
    
    (ok true)
  )
)