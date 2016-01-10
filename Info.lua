
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "PreciousBlocks",
	Version = 4,
	DisplayVersion = "3.1",
	Date = "2016-01-09", -- yyyy-mm-dd
	SourceLocation = "https://github.com/NiLSPACE/PreciousBlocks",
	Description = 
[[
This plugin allows admins to see who or what placed a block, and revert it if needed.
]],
	
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
					ParameterCombinations =
					{
						{
							Params = "PlayerName, RadiusAroundPlayer",
							Help = "Revert all the changes from a player in the given radius",
						},
						{
							Params = "PlayerName, RadiusAroundPlayer, TimeAgo",
							Help = "Revert changes from a player in the given radius from a certain time ago.",
						},
					},
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




