// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./AbstractAuthorizationSpec.sol";
import "./AbstractSingleVoteSpec.sol";
import "./AbstractProposalFinalitySpec.sol";
import "../contracts/SimpleDAO.sol";

/// @title SimpleDAOSpecs
/// @notice Concrete implementation of governance specs for SimpleDAO
contract SimpleDAOSpecs is 
    SimpleDAO,
    AbstractAuthorizationSpec,
    AbstractSingleVoteSpec,
    AbstractProposalFinalitySpec {

    // Implementation of AbstractAuthorizationSpec
    function getVotingPower(address voter) internal override view returns (uint256) {
        return tokenBalances[voter];
    }

    function getVotingPowerPure(address voter) internal override view returns (uint256) {
        return tokenBalances[voter];
    }

    // Implementation of AbstractSingleVoteSpec
    function hasVoted(uint256 proposalId, address voter) internal override returns (bool) {
        return proposals[proposalId].hasVoted[voter];
    }

    function hasVotedPure(uint256 proposalId, address voter) internal override view returns (bool) {
        return proposals[proposalId].hasVoted[voter];
    }

    function markVoted(uint256 proposalId, address voter) internal override {
        proposals[proposalId].hasVoted[voter] = true;
    }

    // Implementation of AbstractProposalFinalitySpec
    function isExecuted(uint256 proposalId) internal override returns (bool) {
        return proposals[proposalId].executed;
    }

    function getYesVotes(uint256 proposalId) internal override returns (uint256) {
        return proposals[proposalId].yesVotes;
    }

    function getNoVotes(uint256 proposalId) internal override returns (uint256) {
        return proposals[proposalId].noVotes;
    }

    // Override SimpleDAO's vote function to use our specs
    function vote(uint256 _proposalId, bool _support) public override {
        // Use our authorization spec
        verifyAuthorization(msg.sender);
        
        // Use our single vote spec
        verifySingleVote(_proposalId, msg.sender);
        
        // Use our proposal finality spec
        verifyProposalFinality(_proposalId);

        // Rest of SimpleDAO's implementation
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");

        if (_support) {
            proposal.yesVotes += tokenBalances[msg.sender];
        } else {
            proposal.noVotes += tokenBalances[msg.sender];
        }
        
        emit VoteCast(_proposalId, msg.sender, _support);
    }
} 