// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title FlawedDAO
/// @notice A flawed DAO voting mechanism with token-weighted voting
contract FlawedDAO {
    event ProposalCreated(uint256 indexed proposalId, string description);
    event VoteCast(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId, bool passed);

    struct Proposal {
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        uint256 startTime;
        uint256 endTime;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    address public admin;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public tokenBalances;
    uint256 public proposalCount;
    uint256 public constant QUORUM_THRESHOLD = 30; // 30% of total tokens required for quorum
    uint256 public totalTokens;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyTokenHolder() {
        require(tokenBalances[msg.sender] > 0, "Must be a token holder");
        _;
    }

    /// #if_succeeds {:msg "Admin is set in constructor"} admin == msg.sender;
    constructor() {
        admin = msg.sender;
    }

    /// #if_succeeds {:msg "Only admin can create proposals"} msg.sender == admin;
    /// #if_succeeds {:msg "Proposal ID is incremented"} proposalCount == old(proposalCount) + 1;
    /// #if_succeeds {:msg "Voting period is valid"} _votingPeriod > 0 && _votingPeriod <= 7 days;
    function createProposal(string memory _description, uint256 _votingPeriod) external onlyAdmin returns (uint256) {
        require(_votingPeriod > 0 && _votingPeriod <= 7 days, "Invalid voting period");
        uint256 proposalId = proposalCount++;
        Proposal storage proposal = proposals[proposalId];
        proposal.description = _description;
        proposal.startTime = block.timestamp;
        proposal.endTime = block.timestamp + _votingPeriod;
        emit ProposalCreated(proposalId, _description);
        return proposalId;
    }

    /// #if_succeeds {:msg "Only token holders can vote"} tokenBalances[msg.sender] > 0;
    /// #if_succeeds {:msg "Single vote per address"} proposals[_proposalId].hasVoted[msg.sender];
    function vote(uint256 _proposalId, bool _support) external virtual {
        // Fails to check if sender has owns tokens
        // Fails to check or mark if a sender has voted
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.startTime >= 0, "Proposal does not exist");
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");
        require(!proposal.executed, "Proposal already finalized");
        
        uint256 voteWeight = tokenBalances[msg.sender];
        if (_support) {
            proposal.yesVotes += voteWeight;
        } else {
            proposal.noVotes += voteWeight;
        }
        emit VoteCast(_proposalId, msg.sender, _support);
    }

    /// #if_succeeds {:msg "Quorum is met before execution"} 
    ///     (proposals[_proposalId].yesVotes + proposals[_proposalId].noVotes) >= (totalTokens * QUORUM_THRESHOLD) / 100;
    function finalize(uint256 _proposalId) external virtual {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.startTime >= 0, "Proposal does not exist");
        require(block.timestamp > proposal.endTime, "Voting still in progress");
        require(!proposal.executed, "Proposal already executed");
        
        // fails to check if quorum is reached
        uint256 totalVotes = proposal.yesVotes + proposal.noVotes;
        
        proposal.executed = true;
        bool passed = proposal.yesVotes > proposal.noVotes;
        emit ProposalExecuted(_proposalId, passed);
    }

    function setTokenBalance(address _account, uint256 _amount) external onlyAdmin {
        uint256 oldBalance = tokenBalances[_account];
        tokenBalances[_account] = _amount;
        totalTokens = totalTokens - oldBalance + _amount;
    }

    function getProposal(uint256 _proposalId) external view returns (
        string memory description,
        uint256 yesVotes,
        uint256 noVotes,
        uint256 startTime,
        uint256 endTime,
        bool executed
    ) {
        Proposal storage proposal = proposals[_proposalId];
        return (
            proposal.description,
            proposal.yesVotes,
            proposal.noVotes,
            proposal.startTime,
            proposal.endTime,
            proposal.executed
        );
    }
} 