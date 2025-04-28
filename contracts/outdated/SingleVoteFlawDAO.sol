// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SingleVoteFlawDAO
/// @notice Toy DAO where the same address can vote many times
contract SingleVoteFlawDAO {
    address public admin;
    mapping(address => bool) public isMember;

    struct Proposal {
        string description;
        uint256 yes;
        uint256 no;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        mapping(address => bool) voted; 
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    uint256 public constant VOTING_PERIOD = 7 days;
    uint256 public constant QUORUM_THRESHOLD = 30; // 30% of members required for quorum
    uint256 public totalMembers;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event VoteCast(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyMember() {
        require(isMember[msg.sender], "Not a member");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// #if_succeeds {:msg "Only token holders can vote"} 
    ///     isMember[msg.sender] == true;
    function register() external {                  
        isMember[msg.sender] = true;
        totalMembers++;
    }

    /// #if_succeeds {:msg "Only admin can create proposals"} 
    ///     msg.sender == admin;
    /// #if_succeeds {:msg "Proposal ID is incremented"} proposalCount == old(proposalCount) + 1;
    function createProposal(string memory _description) external onlyAdmin returns (uint256) {
        uint256 proposalId = proposalCount++;
        Proposal storage proposal = proposals[proposalId];
        proposal.description = _description;
        proposal.startTime = block.timestamp;
        proposal.endTime = block.timestamp + VOTING_PERIOD;
        emit ProposalCreated(proposalId, _description);
        return proposalId;
    }

    // Intended functionality is this function should only succeed if the user has not voted yet
    // Flawed logic in not checking for previous votes
    /// #if_succeeds {:msg "Only token holders can vote"} 
    ///     isMember[msg.sender] == true;
    /// #if_succeeds {:msg "Single vote per address"} 
    ///     proposals[id].voted[msg.sender] == true;
    /// #if_succeeds {:msg "Vote weight is correct"} 
    ///     (support ==> proposals[id].yes == old(proposals[id].yes) + 1) &&
    ///     (!support ==> proposals[id].no == old(proposals[id].no) + 1);
    /// #if_succeeds {:msg "Voting period is valid"} 
    ///     block.timestamp >= proposals[id].startTime && 
    ///     block.timestamp <= proposals[id].endTime;
    function vote(uint256 id, bool support) external onlyMember {
        Proposal storage p = proposals[id];
        require(block.timestamp >= p.startTime, "Voting not started");
        require(block.timestamp <= p.endTime, "Voting ended");
        require(!p.executed, "Proposal already executed");

        if (support) {
            p.yes += 1;
        } else {
            p.no += 1;
        }
        emit VoteCast(id, msg.sender, support);
    }

    /// #if_succeeds {:msg "Quorum is met before execution"} 
    ///     (proposals[id].yes + proposals[id].no) >= (totalMembers * QUORUM_THRESHOLD) / 100;
    /// #if_succeeds {:msg "Proposal can only be executed once"} 
    ///     !proposals[id].executed;
    function executeProposal(uint256 id) external {
        Proposal storage p = proposals[id];
        require(block.timestamp > p.endTime, "Voting still in progress");
        require(!p.executed, "Proposal already executed");
        
        // Check if quorum is met (total votes must be at least 30% of total members)
        uint256 totalVotes = p.yes + p.no;
        require(totalVotes >= (totalMembers * QUORUM_THRESHOLD) / 100, "Quorum not met");
        
        p.executed = true;
        bool passed = p.yes > p.no;
        emit ProposalExecuted(id, passed);
    }

    function getProposal(uint256 id) external view returns (
        string memory description,
        uint256 yes,
        uint256 no,
        uint256 startTime,
        uint256 endTime,
        bool executed
    ) {
        Proposal storage p = proposals[id];
        return (
            p.description,
            p.yes,
            p.no,
            p.startTime,
            p.endTime,
            p.executed
        );
    }
} 