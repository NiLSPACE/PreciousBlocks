




function InitHooks()
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnPlayerLeftClick);
	
	if (g_Config.LogNature) then
		cPluginManager:AddHook(cPluginManager.HOOK_BLOCK_SPREAD, OnBlockSpread);
	end
end





function OnBlockSpread(a_World, a_BlockX, a_BlockY, a_BlockZ, a_Source)
	local SourceName = "#" .. (
	(a_Source == ssFireSpread) and "fire" or 
	(a_Source == ssGrassSpread) and "grass" or 
	(a_Source == ssMushroomSpread) and "mushroom" or 
	(a_Source == ssMycelSpread) and "mycelium" or 
	(a_Source == ssVineSpread) and "vine")

	g_Storage:InsertChange(
		a_World:GetName(),
		SourceName,
		a_BlockX, a_BlockY, a_BlockZ,
		a_World:GetBlock(a_BlockX, a_BlockY, a_BlockZ), a_World:GetBlockMeta(a_BlockX, a_BlockY, a_BlockZ),
		"spread"
	)
end





function OnPlayerBreakingBlock(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_BlockType, a_BlockMeta)
	local World = a_Player:GetWorld()
	
	g_Storage:InsertChange(
		World:GetName(),
		a_Player:GetName(),
		a_BlockX, a_BlockY, a_BlockZ,
		World:GetBlock(a_BlockX, a_BlockY, a_BlockZ), World:GetBlockMeta(a_BlockX, a_BlockY, a_BlockZ),
		"broken"
	)
end





function OnPlayerPlacingBlock(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockType, a_BlockMeta)
	g_Storage:InsertChange(
		a_Player:GetWorld():GetName(),
		a_Player:GetName(),
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
	
	SendChangesAt(a_Player, a_BlockX, a_BlockY, a_BlockZ)
	return true
end





function OnPlayerLeftClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_Action)
	local PlayerState = GetPlayerState(a_Player:GetName())

	if (not PlayerState:IsInspecting()) then
		return false
	end
	
	SendChangesAt(a_Player, a_BlockX, a_BlockY, a_BlockZ)
	return true
end



