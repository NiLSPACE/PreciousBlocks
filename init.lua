




function Initialize(a_Plugin)
	a_Plugin:SetName("PreciousBlocks")
	a_Plugin:SetVersion(3)
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	InitConfig()
	
	InitHooks()
	
	InitStorage()
	
	return true
end




