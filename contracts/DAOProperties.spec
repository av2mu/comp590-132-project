/// @title DAO Properties Specification
/// @notice Abstract properties that should hold for any DAO implementation

// Authorization Properties
/// @property {:msg "Only token holders can vote"} 
///     tokenBalances[msg.sender] > 0 || isMember[msg.sender] == true;

/// @property {:msg "Only admin can create proposals"} 
///     msg.sender == admin || msg.sender == owner;

/// @property {:msg "Only admin can modify balances"} 
///     msg.sender == admin || msg.sender == owner;

// Voting Properties
/// @property {:msg "Single vote per address"} 
///     proposals[_proposalId].hasVoted[msg.sender] == true;

/// @property {:msg "Vote weight is correct"} 
///     (_support ==> proposals[_proposalId].yesVotes == old(proposals[_proposalId].yesVotes) + voteWeight) &&
///     (!_support ==> proposals[_proposalId].noVotes == old(proposals[_proposalId].noVotes) + voteWeight);

/// @property {:msg "Voting period is valid"} 
///     block.timestamp >= proposals[_proposalId].startTime && 
///     block.timestamp <= proposals[_proposalId].endTime;

// Quorum Properties
/// @property {:msg "Quorum is met before execution"} 
///     (proposals[_proposalId].yesVotes + proposals[_proposalId].noVotes) >= 
///     (totalTokens * QUORUM_THRESHOLD) / 100 || 
///     proposals[_proposalId].numberOfVotes >= minimumQuorum;

// State Transition Properties
/// @property {:msg "Proposal can only be executed after voting period"} 
///     block.timestamp > proposals[_proposalId].endTime || 
///     block.timestamp > proposals[_proposalId].minExecutionDate;

/// @property {:msg "Proposal can only be executed once"} 
///     proposals[_proposalId].executed == false;

/// @property {:msg "Proposal can only be voted on if not executed"} 
///     proposals[_proposalId].executed == false;

// Precondition Properties (to be checked before function execution)
/// @property {:msg "Pre: Proposal exists"} 
///     proposals[_proposalId].startTime > 0;

/// @property {:msg "Pre: Proposal not executed"} 
///     !proposals[_proposalId].executed;

/// @property {:msg "Pre: Voting period ended"} 
///     block.timestamp > proposals[_proposalId].endTime; 