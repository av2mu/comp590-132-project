// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./AbstractSingleVoteSpec.sol";
import "../contracts/SingleVoteFlawDAO.sol";

/// @title SingleVoteFlawDAOSpecs
/// @notice Concrete implementation of single vote specs for SingleVoteFlawDAO
contract SingleVoteFlawDAOSpecs is 
    SingleVoteFlawDAO,
    AbstractSingleVoteSpec {

    // Implementation of AbstractSingleVoteSpec
    function hasVoted(uint256 proposalId, address voter) internal override returns (bool) {
        return proposals[proposalId].hasVoted[voter];
    }

    function markVoted(uint256 proposalId, address voter) internal override {
        proposals[proposalId].hasVoted[voter] = true;
    }

    // Override SingleVoteFlawDAO's vote function to use our specs
    function vote(uint256 _proposalId, bool _support) public override {
        // Use our single vote spec
        verifySingleVote(_proposalId, msg.sender);

        // Rest of SingleVoteFlawDAO's implementation
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");
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