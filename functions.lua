




function isArray(a_Table)
	local i = 0
	for _, t in pairs(a_Table) do
		i = i + 1
		if (not rawget(a_Table, i)) then
			return false
		end
	end
	
	return true
end





function GetUUIDFromPlayerName(a_PlayerName)
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		return cMojangAPI:GetUUIDFromPlayerName(a_PlayerName, true)
	else
		return cClientHandle:GenerateOfflineUUID(a_PlayerName)
	end
end





-- TODO: format time properly
function SendChangesAt(a_Player, a_BlockX, a_BlockY, a_BlockZ)
	local Changes, NumChanges = g_Storage:GetChangesInPos(a_Player:GetWorld(), a_BlockX, a_BlockY, a_BlockZ)
	a_Player:SendMessage("There are " .. NumChanges .. " changes:")
	
	for Idx, ChangeInfo in ipairs(Changes) do
		a_Player:SendMessage(string.format(" Cause: %q  Action: %s  Time: %s seconds ago", ChangeInfo.cause,  ChangeInfo.action, os.time() - ChangeInfo.time))
	end
end




