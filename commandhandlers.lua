




-- TODO: Add the time parameter
function HandleRevertCommand(a_Split, a_Player)
	-- /pb revert <PlayerName> <Radius> (Time)
	
	if (#a_Split ~= 4) then
		a_Player:SendMessage("Usage: /pb revert <PlayerName> <Radius> (Time)")
		return true
	end
	
	local TargetPlayer = a_Split[3]
	local Radius = tonumber(a_Split[4])
	
	if (not Radius) then
		a_Player:SendMessage(cChatColor.Rose .. "Invalid radius")
		return true
	end
	
	local CurrentPos = a_Player:GetPosition():Floor()
	
	local Cuboid = cCuboid(
		CurrentPos.x - Radius, CurrentPos.y - Radius,
		CurrentPos.z - Radius, CurrentPos.x + Radius,
		CurrentPos.y + Radius, CurrentPos.z + Radius
	)
	
	
	local NumChanges = g_Storage:RevertChangesInCuboid(a_Player:GetWorld(), Cuboid, TargetPlayer, 0)
	
	a_Player:SendMessage(NumChanges .. " block(s) changed")
	return true
end





function HandleInspectCommand(a_Split, a_Player)
	local PlayerState = GetPlayerState(a_Player:GetName())
	PlayerState:SwitchInspecting()
	
	if (PlayerState:IsInspecting()) then
		a_Player:SendMessage("You are inspecting")
	else
		a_Player:SendMessage("You stopped inspecting")
	end
	return true
end




