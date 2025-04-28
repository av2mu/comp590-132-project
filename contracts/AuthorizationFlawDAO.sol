// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title AuthorizationFlawDAO
/// @notice A simple flawed DAO voting mechanism with wallet-based voting
contract AuthorizationFlawDAO {
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


    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    
    modifier onlyTokenHolder() {
        require(tokenBalances[msg.sender] > 0, "Must be a token holder");
        _;
    }


    constructor() {
        admin = msg.sender;
    }

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
    // Intended functionality is that each user with tokens may vote on a proposal
    // Flawed logic in not checking if the user owns tokens
    /// #if_succeeds {:msg "Only token holders can vote"} tokenBalances[msg.sender] > 0;
    function vote(uint256 _proposalId, bool _support) external virtual {
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

    function finalize(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp > proposal.endTime, "Voting still in progress");
        require(!proposal.executed, "Proposal already executed");
        proposal.executed = true;
        bool passed = proposal.yesVotes > proposal.noVotes;
        emit ProposalExecuted(_proposalId, passed);
    }


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