// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SingleVoteFlawDAO
/// @notice Toy DAO where the same address can vote many times
contract SingleVoteFlawDAO {
    mapping(address => bool) public isMember;

    struct Proposal {
        uint256 yes;
        uint256 no;
        mapping(address => bool) voted; 
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    function register() external {                  
        isMember[msg.sender] = true;
    }

    function createProposal() external returns (uint256) {
        return proposalCount++;
    }

    // Intended functionality is this function should only succeed if the user has not voted yet
    // Flawed logic in not checking for previous votes
    /// #if_succeeds {:msg "single-vote"} proposals[id].voted[msg.sender];
    function vote(uint256 id, bool support) external {
        require(isMember[msg.sender], "not a member");
        Proposal storage p = proposals[id];

        if (support) {
            p.yes += 1;
        } else {
            p.no += 1;
        }
    }
} 