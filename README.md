# Stacks NFT Gaming Platform Smart Contract

## Overview

The **Stacks NFT Gaming Platform** is a decentralized gaming ecosystem built on the Stacks blockchain, leveraging the security and transparency of Bitcoin. This smart contract facilitates the creation, management, and trading of in-game assets as NFTs, tracks player performance, and distributes Bitcoin rewards based on leaderboard rankings. It is designed to be secure, efficient, and compliant with Stacks Layer 2 and Bitcoin standards.

This README provides a comprehensive guide to the smart contract, including its features, functionality, error handling, and usage instructions.

## Features

1. **NFT Management**:

   - Mint unique in-game assets as NFTs.
   - Transfer NFTs between players securely.
   - Store metadata for each NFT (name, description, rarity, power level).

2. **Player Management**:

   - Register players with a registration fee.
   - Track player scores and games played.
   - Maintain a leaderboard to rank players.

3. **Bitcoin Rewards**:

   - Distribute Bitcoin rewards to top-performing players.
   - Calculate rewards based on player scores.

4. **Administration**:

   - Whitelist game administrators for secure operations.
   - Update game configuration (entry fee, leaderboard size).

5. **Validation and Security**:
   - Validate inputs and operations to ensure data integrity.
   - Restrict unauthorized access to critical functions.

## Smart Contract Components

### Error Constants

The contract defines a set of error constants to handle various failure scenarios:

- `ERR-NOT-AUTHORIZED`: Unauthorized access.
- `ERR-INVALID-GAME-ASSET`: Invalid game asset.
- `ERR-INSUFFICIENT-FUNDS`: Insufficient funds for transactions.
- `ERR-TRANSFER-FAILED`: Failed transfer operation.
- `ERR-LEADERBOARD-FULL`: Leaderboard is full.
- `ERR-ALREADY-REGISTERED`: Player is already registered.
- `ERR-INVALID-REWARD`: Invalid reward calculation.
- `ERR-INVALID-INPUT`: Invalid input data.
- `ERR-INVALID-SCORE`: Invalid player score.
- `ERR-INVALID-FEE`: Invalid fee amount.
- `ERR-INVALID-ENTRIES`: Invalid number of leaderboard entries.
- `ERR-PLAYER-NOT-FOUND`: Player not found.

### Storage Variables

- `game-fee`: Registration fee for players.
- `max-leaderboard-entries`: Maximum number of entries in the leaderboard.
- `total-prize-pool`: Total Bitcoin rewards pool.
- `total-game-assets`: Total number of minted game assets.

### Data Structures

- **NFT Definition**: `game-asset` (non-fungible token with a unique ID).
- **Game Asset Metadata**: Stores metadata for each NFT (name, description, rarity, power level).
- **Leaderboard**: Tracks player scores, games played, and total rewards.
- **Whitelist**: Stores authorized game administrators.

## Functions

### Public Functions

1. **`add-game-admin`**:

   - Adds a new game administrator to the whitelist.
   - Only existing admins can call this function.

2. **`mint-game-asset`**:

   - Mints a new game asset NFT with metadata.
   - Only admins can call this function.

3. **`transfer-game-asset`**:

   - Transfers a game asset NFT to another player.
   - Only the NFT owner can call this function.

4. **`register-player`**:

   - Registers a new player with a registration fee.
   - Players must have sufficient funds to register.

5. **`update-player-score`**:

   - Updates a player's score and games played.
   - Only admins can call this function.

6. **`distribute-bitcoin-rewards`**:

   - Distributes Bitcoin rewards to top players on the leaderboard.
   - Only admins can call this function.

7. **`initialize-game`**:
   - Initializes game configuration (entry fee, leaderboard size).
   - Only admins can call this function.

### Private Functions

1. **`is-valid-reward-candidate`**:

   - Validates if a player is eligible for rewards.

2. **`distribute-reward`**:

   - Distributes rewards to a single player.

3. **`calculate-reward`**:
   - Calculates the reward amount based on a player's score.

### Read-Only Functions

1. **`is-game-admin`**:

   - Checks if a principal is a game admin.

2. **`is-valid-string`**:

   - Validates input strings.

3. **`is-valid-principal`**:

   - Validates principal addresses.

4. **`is-safe-principal`**:

   - Ensures a principal is safe for operations.

5. **`get-top-players`**:
   - Retrieves the top players from the leaderboard (placeholder implementation).

## Usage

### Prerequisites

- A Stacks-compatible wallet (e.g., Hiro Wallet).
- STX tokens for transaction fees and registration.

### Steps

1. **Deploy the Contract**:

   - Deploy the contract to the Stacks blockchain using Clarinet or another deployment tool.

2. **Initialize the Game**:

   - Call `initialize-game` to set the entry fee and leaderboard size.

3. **Register Players**:

   - Players call `register-player` to join the platform.

4. **Mint Game Assets**:

   - Admins call `mint-game-asset` to create NFTs.

5. **Update Scores**:

   - Admins call `update-player-score` to update player performance.

6. **Distribute Rewards**:
   - Admins call `distribute-bitcoin-rewards` to distribute Bitcoin rewards.

## Error Handling

The contract includes robust error handling to ensure secure and reliable operations. Each function validates inputs and permissions before execution, reverting with appropriate error codes if conditions are not met.

## Compliance

This contract is designed to comply with:

- Stacks Layer 2 standards.
- Bitcoin security and transparency requirements.

## Future Enhancements

- Integrate with Bitcoin wallets for seamless reward distribution.
- Add support for additional game types and asset categories.
- Implement dynamic reward calculations based on player activity.
