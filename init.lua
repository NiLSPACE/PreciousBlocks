




function Initialize(a_Plugin)
	a_Plugin:SetName("PreciousBlocks")
	a_Plugin:SetVersion(g_PluginInfo.Version)
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	InitConfig()
	
	InitHooks()
	
	InitStorage()
	
	LOG("Initialized PreciousBlocks v" .. g_PluginInfo.DisplayVersion)
	return true
end




