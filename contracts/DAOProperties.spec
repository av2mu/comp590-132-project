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

