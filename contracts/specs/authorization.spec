/// @title Authorization Properties
/// @notice Properties related to access control and permissions in DAOs

/// @property {:msg "Only token holders can vote"} 
///     tokenBalances[msg.sender] > 0 || isMember[msg.sender] == true;

/// @property {:msg "Only admin can create proposals"} 
///     msg.sender == admin || msg.sender == owner;

/// @property {:msg "Only admin can modify balances"} 
///     msg.sender == admin || msg.sender == owner; 