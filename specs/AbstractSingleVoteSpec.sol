// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title AbstractSingleVoteSpec
/// @notice Abstract specification for single-vote-per-proposal
/// @dev Concrete implementations must implement hasVoted and markVoted
abstract contract AbstractSingleVoteSpec {
    /// @notice Check if an address has voted on a proposal
    /// @param proposalId The ID of the proposal
    /// @param voter The address to check
    /// @return Whether the address has voted
    function hasVoted(uint256 proposalId, address voter) internal virtual returns (bool);

    /// @notice Check if an address has voted on a proposal (pure version for specifications)
    /// @param proposalId The ID of the proposal
    /// @param voter The address to check
    /// @return Whether the address has voted
    function hasVotedPure(uint256 proposalId, address voter) internal view virtual returns (bool);

    /// @notice Mark an address as having voted on a proposal
    /// @param proposalId The ID of the proposal
    /// @param voter The address that voted
    function markVoted(uint256 proposalId, address voter) internal virtual;

    /// @notice Verify that an address hasn't voted on a proposal yet
    /// @param proposalId The ID of the proposal
    /// @param voter The address attempting to vote
    /// #if_succeeds {:msg "Single-vote"} !old(hasVotedPure(proposalId, voter));
    function verifySingleVote(uint256 proposalId, address voter) internal {
        require(!hasVoted(proposalId, voter), "Already voted");
        markVoted(proposalId, voter);
    }
} 