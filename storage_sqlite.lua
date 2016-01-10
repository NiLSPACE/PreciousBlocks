
-- storage_sqlite.lua

-- Implements the sql storage system.





-- Load all the queries
local g_Queries = {}
local Path = cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/Queries"
for _, FileName in ipairs(cFile:GetFolderContents(Path)) do
	if (FileName:match("%.sql$")) then
		g_Queries[FileName:match("^(.*)%.sql$")] = cFile:ReadWholeFile(Path .. "/" .. FileName)
	end
end





cSQLiteStorage = {}





function cSQLiteStorage:new()
	local Obj = {}
	
	setmetatable(Obj, cSQLiteStorage)
	self.__index = self
	
	local ErrorCode, ErrorMsg;
	Obj.DB, ErrorCode, ErrorMsg = sqlite3.open(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/storage.sqlite")
	if (Obj.DB == nil) then
		LOGWARNING("Database could not be opened. Aborting");
		error(ErrMsg);  -- Abort the plugin
	end
	
	-- Create a database for every world.
	cRoot:Get():ForEachWorld(
		function(a_World)
			Obj:ExecuteCommand("initialize", a_World:GetName())
		end
	)
	
	return Obj
end





--- Executes a query that was loaded before.
-- The worldname is the name of the world to execute the query in.
-- The parameters is a dictionary. The key is the name of the parameter. 
-- This can be found with a $ or : in front of it in the actual query.
-- If a callback is given it calls that for each row where the parameter is a dictionary
-- Returns true on success, while if it returns false with the error message when failing
function cSQLiteStorage:ExecuteCommand(a_QueryName, a_WorldName, a_Parameters, a_Callback)
	local Command = assert(g_Queries[a_QueryName], ("Requested Query %q doesn't exist"):format(a_QueryName))
	return self:ExecuteQuery(Command, a_WorldName, a_Parameters, a_Callback)
end	





-- Executes the given query.
-- The worldname is the name of the world to execute the query in.
-- The parameters is a dictionary. The key is the name of the parameter. 
-- This can be found with a $ or : in front of it in the actual query.
-- If a callback is given it calls that for each row where the parameter is a dictionary
-- Returns true on success, while if it returns false with the error message when failing
function cSQLiteStorage:ExecuteQuery(a_Sql, a_WorldName, a_Parameters, a_Callback)
	-- We can't give table names as a parameter. Change it in the query itself.
	a_Sql = a_Sql:gsub("@tablename", "\"" .. a_WorldName .. "\"")
	
	local Stmt, ErrCode, ErrMsg = self.DB:prepare(a_Sql)
	if (not Stmt) then
		LOGWARNING("Cannot prepare query \"" .. a_Sql .. "\": " .. (ErrCode or "<unknown>") .. " (" .. (ErrMsg or self.DB:errmsg() or "<no message>") .. ")")
		return false, ErrorMsg or "<no message>"
	end
	
	if (a_Parameters ~= nil) then
		Stmt:bind_names(a_Parameters)
	end
	
	if (a_Callback ~= nil) then
		for val in Stmt:nrows() do
			if (a_Callback(val)) then
				break
			end
		end
	else
		Stmt:step()
	end
	
	Stmt:finalize()
	return true
end





function cSQLiteStorage:InsertChange(a_WorldName, a_PlayerName, a_X, a_Y, a_Z, a_NewBlock, a_NewMeta, a_Action)
	self:ExecuteCommand("insert_change", a_WorldName,
		{
			x = a_X,
			y = a_Y,
			z = a_Z,
			blocktype = a_NewBlock,
			blockmeta = a_NewMeta,
			cause = a_PlayerName,
			action = a_Action,
			time = os.time()
		}
	)
end





function cSQLiteStorage:RevertChangesInCuboid(a_World, a_Cuboid, a_PlayerName, a_Time)
	local WorldName = a_World:GetName()
	
	local Parameters = {
		minX = a_Cuboid.p1.x,
		minY = a_Cuboid.p1.y,
		minZ = a_Cuboid.p1.z,
		maxX = a_Cuboid.p2.x,
		maxY = a_Cuboid.p2.y,
		maxZ = a_Cuboid.p2.z,
		cause = a_PlayerName,
		time = (a_Time or 0)
	},
	
	-- Make sure the cuboid is sorted
	a_Cuboid:Sort()
	
	-- Blockarea where we put all the changes first
	local BlockArea = cBlockArea()
	
	-- Read the area in
	BlockArea:Read(a_World, a_Cuboid, cBlockArea.baTypes + cBlockArea.baMetas)
	
	local NumChanges = 0
	
	self:ExecuteCommand("select_changes", WorldName, Parameters,
		function(a_Values)
			BlockArea:SetBlockTypeMeta(a_Values.x, a_Values.y, a_Values.z, a_Values.blocktype, a_Values.blockmeta)
			NumChanges = NumChanges + 1
		end
	)
	
	if (NumChanges ~= 0) then
		-- Write rollback in the world
		BlockArea:Write(a_World, a_Cuboid.p1)
		
		self:ExecuteCommand("delete_changes", WorldName, Parameters)
	end
	
	return NumChanges
end





function cSQLiteStorage:GetChangesInPos(a_World, a_X, a_Y, a_Z)
	local WorldName = a_World:GetName()
	local Changes = {}
	local NumChanges = 1
	self:ExecuteCommand("select_single_change", WorldName,
		{
			x = a_X,
			y = a_Y,
			z = a_Z
		},
		function(a_Values)
			Changes[NumChanges] = a_Values
			NumChanges = NumChanges + 1
		end
	)
	
	return Changes, NumChanges - 1
end




