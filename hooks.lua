




function InitHooks()
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnPlayerLeftClick);
end





function OnPlayerBreakingBlock(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_BlockType, a_BlockMeta)
	local World = a_Player:GetWorld()
	
	g_Storage:InsertChange(
		a_Player,
		a_BlockX, a_BlockY, a_BlockZ,
		World:GetBlock(a_BlockX, a_BlockY, a_BlockZ), World:GetBlockMeta(a_BlockX, a_BlockY, a_BlockZ),
		"broken"
	)
end





function OnPlayerPlacingBlock(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockType, a_BlockMeta)
	g_Storage:InsertChange(
		a_Player,
		a_BlockX, a_BlockY, a_BlockZ,
		0, 0,
		"placed"
	)
end





function OnPlayerRightClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_CursorX, a_CursorY, a_CursorZ)
	if (a_BlockFace == BLOCK_FACE_NONE) then
		return false
	end
	
	a_BlockX, a_BlockY, a_BlockZ = AddFaceDirection(a_BlockX, a_BlockY, a_BlockZ, a_BlockFace)
	local PlayerState = GetPlayerState(a_Player:GetName())

	if (not PlayerState:IsInspecting()) then
		return false
	end
	
	local Changes = g_Storage:GetChangesInPos(a_Player:GetWorld(), a_BlockX, a_BlockY, a_BlockZ)
	a_Player:SendMessage("There are " .. #Changes .. " changes:")
	
	for Idx, ChangeInfo in ipairs(Changes) do
		a_Player:SendMessage(string.format(" Player: %s  Action: %s  Time: %s", cMojangAPI:GetPlayerNameFromUUID(ChangeInfo["playeruuid"], true),  ChangeInfo["action"], ChangeInfo["time"]))
	end
	return true
end





function OnPlayerLeftClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_Action)
	local PlayerState = GetPlayerState(a_Player:GetName())

	if (not PlayerState:IsInspecting()) then
		return false
	end
	
	local Changes = g_Storage:GetChangesInPos(a_Player:GetWorld(), a_BlockX, a_BlockY, a_BlockZ)
	a_Player:SendMessage("There are " .. #Changes .. " changes:")
	
	for Idx, ChangeInfo in ipairs(Changes) do
		a_Player:SendMessage(string.format(" Player: %s  Action: %s  Time: %s", cMojangAPI:GetPlayerNameFromUUID(ChangeInfo["playeruuid"], true),  ChangeInfo["action"], ChangeInfo["time"]))
	end
	return true
end



