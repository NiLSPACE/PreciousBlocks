




-- All the playerstates
local g_PlayerStates = {}




cPlayerState = {}





function cPlayerState:__call()
	local Obj = {}
	
	setmetatable(Obj, cPlayerState)
	Obj.__index = Obj
	
	Obj.m_IsInspecting = false
	
	return Obj
end





function cPlayerState:IsInspecting()
	return self.m_IsInspecting
end





function cPlayerState:SwitchInspecting()
	self.m_IsInspecting = not self.m_IsInspecting
	return self.m_IsInspecting
end





setmetatable(cPlayerState, cPlayerState)
cPlayerState.__index = cPlayerState





function GetPlayerState(a_PlayerName)
	if (g_PlayerStates[a_PlayerName]) then
		return g_PlayerStates[a_PlayerName]
	end
	
	local PlayerState = cPlayerState(a_PlayerName)
	g_PlayerStates[a_PlayerName] = PlayerState
	return PlayerState
end




