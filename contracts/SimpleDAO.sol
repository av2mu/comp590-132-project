// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title SimpleDAO
/// @notice A simple DAO voting mechanism with token-weighted voting
/// @dev Uses Scribble annotations for formal verification
contract SimpleDAO {
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

    /// #if_succeeds msg.sender == admin;
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    /// #if_succeeds tokenBalances[msg.sender] > 0;
    modifier onlyTokenHolder() {
        require(tokenBalances[msg.sender] > 0, "Must be a token holder");
        _;
    }

    /// #if_succeeds admin == msg.sender;
    constructor() {
        admin = msg.sender;
    }

    /// #if_succeeds msg.sender == admin;
    /// #if_succeeds _votingPeriod > 0 && _votingPeriod <= 7 days;
    /// #if_succeeds proposals[proposalCount].startTime == block.timestamp;
    /// #if_succeeds proposals[proposalCount].endTime == block.timestamp + _votingPeriod;
    /// #if_succeeds proposalCount == old(proposalCount) + 1;
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

    /// #if_succeeds tokenBalances[msg.sender] > 0;
    /// #if_succeeds block.timestamp >= proposals[_proposalId].startTime;
    /// #if_succeeds block.timestamp <= proposals[_proposalId].endTime;
    /// #if_succeeds !proposals[_proposalId].hasVoted[msg.sender];
    /// #if_succeeds proposals[_proposalId].hasVoted[msg.sender];
    /// #if_succeeds _support ? proposals[_proposalId].yesVotes == old(proposals[_proposalId].yesVotes) + tokenBalances[msg.sender] : 
    ///                  proposals[_proposalId].noVotes == old(proposals[_proposalId].noVotes) + tokenBalances[msg.sender];
    function vote(uint256 _proposalId, bool _support) external onlyTokenHolder {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.startTime, "Voting not started");
        require(block.timestamp <= proposal.endTime, "Voting ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");
        proposal.hasVoted[msg.sender] = true;
        if (_support) {
            proposal.yesVotes += tokenBalances[msg.sender];
        } else {
            proposal.noVotes += tokenBalances[msg.sender];
        }
        emit VoteCast(_proposalId, msg.sender, _support);
    }

    /// #if_succeeds block.timestamp > proposals[_proposalId].endTime;
    /// #if_succeeds !proposals[_proposalId].executed;
    /// #if_succeeds proposals[_proposalId].executed;
    function finalize(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp > proposal.endTime, "Voting still in progress");
        require(!proposal.executed, "Proposal already executed");
        proposal.executed = true;
        bool passed = proposal.yesVotes > proposal.noVotes;
        emit ProposalExecuted(_proposalId, passed);
    }

    /// #if_succeeds msg.sender == admin;
    /// #if_succeeds tokenBalances[_account] == _amount;
    function setTokenBalance(address _account, uint256 _amount) external onlyAdmin {
        tokenBalances[_account] = _amount;
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