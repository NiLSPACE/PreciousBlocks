
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "PreciousBlocks",
	Version = "3",
	Date = "2015-03-02",
	SourceLocation = "https://github.com/NiLSPACE/PreciousBlocks",
	Description = [[]],
	
	Commands =
	{
		['/pb'] =
		{
			Permission = "",
			HelpString = "",
			Handler    = nil,
			Subcommands =
			{
				revert =
				{
					HelpString = "Revert an area around you",
					Permission = "preciousblocks.reverse",
					Handler = HandleRevertCommand,
				},
				
				inspect =
				{
					HelpString = "Inspect who changed certain blocks",
					Permission = "preciousblocks.inspect",
					Handler = HandleInspectCommand,
				}
			},
		},
	},
}




