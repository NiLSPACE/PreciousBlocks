




g_Storage = nil





function InitStorage()
	local StorageType = g_Config.Storage:lower()
	
	if (StorageType == "sqlite") then
		g_Storage = cSQLiteStorage:new()
	end
	
	if (not g_Storage) then
		LOGWARNING("[PreciousBlocks] Unknown storage type. Using SQLite")
		g_Storage = cSQLiteStorage:new()
	end
end



