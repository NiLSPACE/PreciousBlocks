




g_ConfigDefaults = [[
Storage = 'sqlite',

-- This can cause huge amounts of lagg and cause the database to grow really big.
LogNature = false,
]]





g_Config = {}





function InitConfig()
	local Path = cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/config.cfg"
	if (not cFile:IsFile(Path)) then
		LOGWARNING("[PreciousBlocks] The config file doesn't exist. PreciousBlocks will write and load the default settings for now")
		WriteDefaultSettings(Path)
		LoadDefaultSettings()
		return
	end
	
	local ConfigContent = cFile:ReadWholeFile(Path)
	if (ConfigContent == "") then
		LOGWARNING("[PreciousBlocks] The config file is empty. PreciousBlocks will use the default settings for now")
		LoadDefaultSettings()
		return
	end
	
	local ConfigLoader, Error  = loadstring("return {" .. ConfigContent .. "}")
	if (not ConfigLoader) then
		LOGWARNING("[PreciousBlocks] There is a problem in the config file. PreciousBlocks will use the default settings for now.")
		LoadDefaultSettings()
		return
	end
	
	local Result, ConfigTable, Error = pcall(ConfigLoader)
	if (not Result) then
		LOGWARNING("[PreciousBlocks] There is a problem in the config file. PreciousBlocks will use the default settings for now.")
		LoadDefaultSettings()
		return
	end
	
	if (type(ConfigTable.Storage) ~= 'string') then
		LOGWARNING("[PreciousBlocks] Invalid storage type configurated. PreciousBlocks will use SQLite")
		ConfigTable.Storage = 'sqlite'
	end
	
	g_Config = ConfigTable
end





function LoadDefaultSettings()
	g_Config = loadstring("return {" .. g_ConfigDefaults .. "}")()
end





function WriteDefaultSettings(a_Path)
	local File = io.open(a_Path, "w")
	File:write(g_ConfigDefaults)
	File:close()
end




