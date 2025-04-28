// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title AbstractProposalFinalitySpec
/// @notice Abstract specification for proposal finality
/// @dev Concrete implementations must implement proposal state tracking
/// #invariant {:msg "Proposal finality"} 
///     forall (uint256 proposalId in [0..getProposalCount()))
///         isExecuted(proposalId) ==> 
///             (getYesVotes(proposalId) == old(getYesVotes(proposalId)) && 
///              getNoVotes(proposalId) == old(getNoVotes(proposalId)));
abstract contract AbstractProposalFinalitySpec {
    /// @notice Get the total number of proposals
    /// @return The number of proposals
    function getProposalCount() internal virtual view returns (uint256);

    /// @notice Check if a proposal is executed
    /// @param proposalId The ID of the proposal
    /// @return Whether the proposal is executed
    function isExecuted(uint256 proposalId) internal virtual returns (bool);

    /// @notice Get the yes votes for a proposal
    /// @param proposalId The ID of the proposal
    /// @return The number of yes votes
    function getYesVotes(uint256 proposalId) internal virtual returns (uint256);

    /// @notice Get the no votes for a proposal
    /// @param proposalId The ID of the proposal
    /// @return The number of no votes
    function getNoVotes(uint256 proposalId) internal virtual returns (uint256);

    /// @notice Verify that executed proposals' votes cannot change
    /// @param proposalId The ID of the proposal
    function verifyProposalFinality(uint256 proposalId) internal {
        require(!isExecuted(proposalId), "Proposal already executed");
    }
} 