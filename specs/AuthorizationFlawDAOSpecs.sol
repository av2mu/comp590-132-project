// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "../contracts/AuthorizationFlawDAO.sol";
import "./AbstractAuthorizationSpec.sol";

/// @title AuthorizationFlawDAOSpecs
/// @notice Concrete implementation of authorization specs for AuthorizationFlawDAO
contract AuthorizationFlawDAOSpecs is AuthorizationFlawDAO, AbstractAuthorizationSpec {
    function getVotingPower(address voter) override internal view returns (uint256) {
        return tokenBalances[voter];
    }

    function getVotingPowerPure(address voter) override internal view returns (uint256) {
        return tokenBalances[voter];
    }

    /// @notice Vote on a proposal with authorization check
    /// @param _proposalId The ID of the proposal to vote on
    /// @param _support Whether to support the proposal
    /// #if_succeeds {:msg "Authorization"} getVotingPowerPure(msg.sender) > 0;
    function vote(uint256 _proposalId, bool _support) override public {
        verifyAuthorization(msg.sender);
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");
        require(!proposal.executed, "Proposal already finalized");
        proposal.hasVoted[msg.sender] = true;
        if (_support) {
            proposal.yesVotes += 1;
        } else {
            proposal.noVotes += 1;
        }
        emit VoteCast(_proposalId, msg.sender, _support);
    }
} 