




local SQLiteFolderPath = cPluginManager:GetCurrentPlugin():GetLocalFolder() .. "/SQLite"
local Folders = cFile:GetFolderContents(SQLiteFolderPath)
for Idx, FileName in ipairs(Folders) do
	if (FileName:match(".*%.lua")) then
		dofile(SQLiteFolderPath .. "/" .. FileName)
	end
end





cSQLiteStorage = {}





function cSQLiteStorage:__call()
	local Obj = {}
	
	setmetatable(Obj, cSQLiteStorage)
	Obj.__index = Obj
	
	local Table = {}
	cRoot:Get():ForEachWorld(
		function(a_World)
			table.insert(Table,
				cTable(a_World:GetName())
				:Field("x",          "INTEGER")
				:Field("y",          "INTEGER")
				:Field("z",          "INTEGER")
				:Field("blocktype",  "INTEGER")
				:Field("blockmeta",  "INTEGER")
				:Field("playeruuid", "TEXT")
				:Field("action",     "TEXT")
				:Field("time",       "INTEGER")
			)
		end
	)
	
	Obj.m_DB = cSQLiteHandler(cRoot:Get():GetPluginManager():GetCurrentPlugin():GetLocalFolder() .. "/storage.sqlite", Table)
	
	return Obj
end





function cSQLiteStorage:InsertChange(a_Player, a_X, a_Y, a_Z, a_NewBlock, a_NewMeta, a_Action)
	self.m_DB:Insert(a_Player:GetWorld():GetName(),
		cInsertList()
		:Insert("x", a_X)
		:Insert("y", a_Y)
		:Insert("z", a_Z)
		:Insert("blocktype", a_NewBlock)
		:Insert("blockmeta", a_NewMeta)
		:Insert("playeruuid", a_Player:GetUUID())
		:Insert("action", a_Action)
		:Insert("time", os.time())
	)
end





function cSQLiteStorage:RevertChangesInCuboid(a_World, a_Cuboid, a_PlayerUUID, a_Time)
	local WorldName = a_World:GetName()
	
	-- Make sure the cuboid is sorted
	a_Cuboid:Sort()
	
	local whereList = cWhereList()
	:Where("x", a_Cuboid.p1.x, ">")
	:Where("y", a_Cuboid.p1.y, ">")
	:Where("z", a_Cuboid.p1.z, ">")
	:Where("x", a_Cuboid.p2.x, "<")
	:Where("y", a_Cuboid.p2.y, "<")
	:Where("z", a_Cuboid.p2.z, "<")
	:Where("playeruuid", a_PlayerUUID)
	:Where("time", a_Time or 0, ">")
	
	-- Blockarea where we put all the changes first
	local BlockArea = cBlockArea()
	
	-- Read the area in
	BlockArea:Read(a_World, a_Cuboid, cBlockArea.baTypes + cBlockArea.baMetas)
	
	-- All the changes in the time span
	local results = self.m_DB:Select(WorldName, "*", whereList, "time")
	
	local NumChanges = 0
	
	-- Put all the reverted changes in the block handler
	for _, blockInfo in ipairs(results) do
		BlockArea:SetBlockTypeMeta(blockInfo['x'], blockInfo['y'], blockInfo['z'], blockInfo['blocktype'], blockInfo['blockmeta'])
		NumChanges = NumChanges + 1
	end
	
	-- Write rollback in the world
	BlockArea:Write(a_World, a_Cuboid.p1)
	
	-- Delete the reverted blocks from the database
	self.m_DB:Delete(WorldName, whereList)
	
	return NumChanges
end





function cSQLiteStorage:GetChangesInPos(a_World, a_X, a_Y, a_Z)
	local WorldName = a_World:GetName()
	
	local whereList = cWhereList()
	:Where("x", a_X)
	:Where("y", a_Y)
	:Where("z", a_Z)
	
	return self.m_DB:Select(WorldName, "*", whereList, "time")
end





setmetatable(cSQLiteStorage, cSQLiteStorage)
cSQLiteStorage.__index = cSQLiteStorage




