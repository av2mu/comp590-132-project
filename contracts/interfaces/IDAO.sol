// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title IDAO
/// @notice Interface for DAO implementations with property specifications
interface IDAO {
    /// @notice Creates a new proposal
    /// @param _description Description of the proposal
    /// @param _votingPeriod Duration of the voting period
    /// @return proposalId The ID of the created proposal
    /// #if_succeeds {:msg "Only admin can create proposals"} msg.sender == admin || msg.sender == owner;
    /// #if_succeeds {:msg "Proposal ID is incremented"} proposalCount == old(proposalCount) + 1;
    /// #if_succeeds {:msg "Voting period is valid"} _votingPeriod > 0 && _votingPeriod <= 7 days;
    function createProposal(string memory _description, uint256 _votingPeriod) external returns (uint256);

    /// @notice Casts a vote on a proposal
    /// @param _proposalId ID of the proposal to vote on
    /// @param _support Whether to support the proposal
    /// #if_succeeds {:msg "Only token holders can vote"} tokenBalances[msg.sender] > 0 || isMember[msg.sender] == true;
    /// #if_succeeds {:msg "Single vote per address"} proposals[_proposalId].hasVoted[msg.sender];
    /// #if_succeeds {:msg "Vote weight is correct"} 
    ///     (_support ==> proposals[_proposalId].yesVotes == old(proposals[_proposalId].yesVotes) + voteWeight) &&
    ///     (!_support ==> proposals[_proposalId].noVotes == old(proposals[_proposalId].noVotes) + voteWeight);
    /// #if_succeeds {:msg "Voting period is valid"} 
    ///     block.timestamp >= proposals[_proposalId].startTime && 
    ///     block.timestamp <= proposals[_proposalId].endTime;
    function vote(uint256 _proposalId, bool _support) external;

    /// @notice Finalizes a proposal after voting period
    /// @param _proposalId ID of the proposal to finalize
    /// #if_succeeds {:msg "Quorum is met before execution"} 
    ///     (proposals[_proposalId].yesVotes + proposals[_proposalId].noVotes) >= 
    ///     (totalTokens * QUORUM_THRESHOLD) / 100 || 
    ///     proposals[_proposalId].numberOfVotes >= minimumQuorum;
    function finalize(uint256 _proposalId) external;
} 