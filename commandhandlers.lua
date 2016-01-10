
-- commandhandlers.lua

-- Implements the handling of in-game commands available to players





function HandleRevertCommand(a_Split, a_Player)
	-- /pb revert <PlayerName> <Radius> (Time)
	
	if (#a_Split < 4) then
		a_Player:SendMessage("Usage: /pb revert <PlayerName> <Radius> (Time)")
		return true
	end
	
	local TargetPlayer = a_Split[3]
	local Radius = tonumber(a_Split[4])
	
	if (not Radius) then
		a_Player:SendMessage(cChatColor.Rose .. "Invalid radius")
		return true
	end
	
	-- See how old the changes may be.
	local TimeTable = os.date("*t", os.time())
	for Idx = 5, #a_Split do
		local Number, TimeType = a_Split[Idx]:match("(%d*)(%a*)")
		if ((TimeType == "m") or TimeType:match("^min")) then
			TimeTable.min = TimeTable.min - Number
		elseif ((TimeType == "d") or TimeType:match("^day")) then
			TimeTable.yday = TimeTable.yday - Number
		elseif ((TimeType == "w") or TimeType:match("^week")) then
			TimeTable.yday = TimeTable.yday - (Number * 7)
		elseif (TimeType:match("^month")) then
			TimeTable.month = TimeTable.month - Number
		elseif (TimeType:match("^year")) then
			TimeTable.year = TimeTable.year - Number
		else
			a_Player:SendMessage(cCompositeChat():AddTextPart([[Unknown time type. The usage goes like this: (number)(timetype).
The time types are:
 Minute: m or min
 Days: d or day
 Week: w or week
 Month: month
 Year: year
  Example: "15min 2day 3week" will revert for 15 minutes, 2 days and 3 weeks.]], "@c"))
			return true
		end
	end
	
	local MinimumTime = os.time(TimeTable)
	MinimumTime = (MinimumTime ~= os.time()) and MinimumTime or 0
	
	-- Create a cuboid that is the to-be-reverted area
	local CurrentPos = a_Player:GetPosition():Floor()
	local Cuboid = cCuboid(CurrentPos, CurrentPos)
	Cuboid:Expand(Radius, Radius, Radius, Radius, Radius, Radius)
	Cuboid:Sort()
	
	local NumChanges = g_Storage:RevertChangesInCuboid(a_Player:GetWorld(), Cuboid, TargetPlayer, MinimumTime)
	
	a_Player:SendMessage(NumChanges .. " block(s) changed")
	return true
end





function HandleInspectCommand(a_Split, a_Player)
	local PlayerState = GetPlayerState(a_Player:GetName())
	
	if (PlayerState:SwitchInspecting()) then
		a_Player:SendMessage("You are inspecting")
	else
		a_Player:SendMessage("You stopped inspecting")
	end
	return true
end




