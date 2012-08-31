-- greatWorks
-- Author: Moriboe
--------------------------------------------------------------

include("CiVUP_Core.lua")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

function CreateGreatWork(unit, city)
	if not unit or not city then
		return
	end

	if GameInfo.Units[unit:GetUnitType()].Class ~= "UNITCLASS_ARTIST" then
		return
	end

	log:Info("CreateGreatWork %s %s", unit:GetName(), city:GetName())

	local playerID	= unit:GetOwner()
	local player	= Players[playerID]
	local culture	= GetMissionYield(player, "MISSION_HURRY")

	--player:ChangeYieldStored(YieldTypes.YIELD_CULTURE, culture)
	City_ChangeYieldStored(city, YieldTypes.YIELD_CULTURE, culture)
	--Plot_ChangeYield(city:Plot(), YieldTypes.YIELD_CULTURE, culture)

	if unit:GetOwner() ~= Game.GetActivePlayer() then
		return
	end

	local uName	= unit:GetName()
	local name	= string.sub(uName, 1, string.len(uName) - string.len(string.format( " (%s)", Locale.ConvertTextKey("TXT_KEY_UNIT_GREAT_ARTIST") )))
	local work	= Locale.ConvertTextKey("TXT_KEY_GREAT_WORK_DEFAULT")
	for row in GameInfo.GreatWorks() do
		if name == Locale.ConvertTextKey(row.ArtistName) then
			work = Locale.ConvertTextKey(row.WorkName)
			break
		end
	end

	Events.GameplayAlertMessage(Locale.ConvertTextKey("TXT_KEY_MISSION_GREAT_WORK_ALERT", name, work, culture, city:GetName()))
	unit:Kill()
end
LuaEvents.GreatWork.Add(CreateGreatWork)


function GetMissionYield(player, missionType)
	local yieldMod = 100
	for city in player:Cities() do
		for row in GameInfo.Building_MissionYieldMod() do
			local buildingID = GameInfo.Buildings[row.BuildingType].ID
			if city:IsHasBuilding(buildingID) then
				yieldMod = yieldMod + row.YieldMod
			end
		end
	end

	local eraID				= 1 + (player:IsHuman() and player:GetCurrentEra() or Game.GetAverageHumanEra())
	local yieldID			= -1
	local yieldConstant		= 0
	local yieldLinear		= 0
	local yieldPowerBase	= 0
	local yieldPowerExp		= 1
	local yieldExponential	= 0
	for info in GameInfo.Mission_Yield(string.format("MissionType = '%s'", missionType)) do
		yieldID				= GameInfo.Yields[info.YieldType].ID
		yieldConstant		= info.YieldConstant
		yieldLinear			= info.YieldLinear
		yieldPowerBase		= info.YieldPowerBase
		yieldPowerExp		= info.YieldPowerExp
		yieldExponential	= info.YieldExponential
	end

	local yield = yieldConstant + yieldLinear*eraID + (yieldPowerBase*eraID)^yieldPowerExp + yieldExponential^eraID

	return Game.Round(yield * yieldMod/100), yieldID
end


function CheckForGreatWorkAI(iPlayer)
	if uuVerbose then print("Checking for AI great work... ") end
	local player = Players[iPlayer]
	if iPlayer ~= Game.GetActivePlayer() and not player:IsMinorCiv() and player:GetCultureBombTimer() == 9 then
		local culture = GetMissionYield(player, "MISSION_HURRY")
		if uuVerbose then print("found!") end
		-- set only global we don't know where it was created
		player:ChangeJONSCulture(culture)
	end
end
GameEvents.PlayerDoTurn.Add(CheckForGreatWorkAI)