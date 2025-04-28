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
    /// #if_succeeds {:msg "Only members can vote"} isMember[msg.sender];
    /// #if_succeeds {:msg "Vote count increases by at most 1"} 
    ///     let oldYes := old(proposals[id].yes) in
    ///     let oldNo := old(proposals[id].no) in
    ///     let newYes := proposals[id].yes in
    ///     let newNo := proposals[id].no in
    ///     (support && newYes <= oldYes + 1 && newNo == oldNo) ||
    ///     (!support && newNo <= oldNo + 1 && newYes == oldYes);
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