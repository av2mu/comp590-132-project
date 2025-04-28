// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title QuorumFlawDAO
/// @notice A simple DAO where proposals can be finalized without meeting quorum
contract QuorumFlawDAO {
    uint256 public constant QUORUM = 2;
    uint256 public totalVotes = 0;
    bool public isFinalized;

    constructor() {
        // Explicit initialization in constructor
        totalVotes = 0;
        isFinalized = false;
    }
    // Intended functionality is this function should only succeed if totalVotes >= QUORUM
    // Flawed logic in not checking quorum is reached
    /// #if_succeeds {:msg "quorum"} totalVotes >= QUORUM;
    function finalise() external {
        isFinalized = true;
    }

    function vote() external {
        totalVotes += 1;
    }

    // Helper to demonstrate the violation
    function attack() external {
        // This creates a clear violation path:
        // 1. Reset votes to 0
        // 2. Call finalise immediately
        totalVotes = 0;
        this.finalise();
    }

    // Helper function to reset state for testing
    function reset() external {
        totalVotes = 0;
        isFinalized = false;
    }
}
