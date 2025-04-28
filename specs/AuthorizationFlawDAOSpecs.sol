// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./AbstractAuthorizationSpec.sol";
import "../contracts/AuthorizationFlawDAO.sol";

/// @title AuthorizationFlawDAOSpecs
/// @notice Concrete implementation of authorization specs for AuthorizationFlawDAO
contract AuthorizationFlawDAOSpecs is 
    AuthorizationFlawDAO,
    AbstractAuthorizationSpec {

    // Implementation of AbstractAuthorizationSpec
    function getVotingPower(address voter) internal override returns (uint256) {
        return tokenBalances[voter];
    }

    // Override AuthorizationFlawDAO's vote function to use our specs
    function vote(uint256 _proposalId, bool _support) public override {
        // Use our authorization spec
        verifyAuthorization(msg.sender);

        // Rest of AuthorizationFlawDAO's implementation
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