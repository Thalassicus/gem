-- BL - General
-- Author: Thalassicus
-- DateCreated: 2/17/2011 4:00:14 PM
--------------------------------------------------------------

include("CiVUP_Core.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

--
function DoEndCombatLeaderBonuses(
		attPlayerID,
		attUnitID,
		attUnitDamage,
		attFinalUnitDamage,
		attMaxHitPoints,
		defPlayerID,
		defUnitID,
		defUnitDamage,
		defFinalUnitDamage,
		defMaxHitPoints
		)
	log:Debug("DoEndCombatLeaderBonuses")

	local wonPlayer, wonUnit, wonCity, lostPlayer, lostUnit, lostCity

	if defFinalUnitDamage >= defMaxHitPoints then
		wonPlayer	= Players[attPlayerID]
		lostPlayer	= Players[defPlayerID]
		wonUnit		= wonPlayer:GetUnitByID(attUnitID)
		lostUnit	= lostPlayer:GetUnitByID(defUnitID)
	elseif attFinalUnitDamage >= attMaxHitPoints then
		wonPlayer	= Players[defPlayerID]
		lostPlayer	= Players[attPlayerID]
		wonUnit		= wonPlayer:GetUnitByID(defUnitID)
		lostUnit	= lostPlayer:GetUnitByID(attUnitID)
	end

	if not wonPlayer then
		return
	end
	
	wonCity = not wonUnit
	lostCity = not lostUnit

	--log:Trace("%20s   %3s", "attPlayerID",			attPlayerID)
	--log:Trace("%20s   %3s", "attUnitID",			attUnitID)
	--log:Trace("%20s   %3s", "attUnitDamage",		attUnitDamage)
	--log:Trace("%20s   %3s", "attFinalUnitDamage",	attFinalUnitDamage)
	--log:Trace("%20s   %3s", "attMaxHitPoints",		attMaxHitPoints)
	--log:Trace("%20s   %3s", "defPlayerID",			defPlayerID)
	--log:Trace("%20s   %3s", "defUnitID",			defUnitID)
	--log:Trace("%20s   %3s", "defUnitDamage",		defUnitDamage)
	--log:Trace("%20s   %3s", "defFinalUnitDamage",	defFinalUnitDamage)
	--log:Trace("%20s   %3s", "defMaxHitPoints",		defMaxHitPoints)
	--log:Trace("%20s   %3s", "wonPlayer",			wonPlayer:GetName())
	--log:Trace("%20s   %3s", "lostPlayer",			lostPlayer:GetName())
	--log:Trace("%20s   %3s", "wonUnit",				wonUnit and GameInfo.Units[wonUnit:GetUnitType()].Type or "City")
	--log:Trace("%20s   %3s", "lostUnit",				lostUnit and GameInfo.Units[lostUnit:GetUnitType()].Type or "City")

	local playerTrait		= wonPlayer:GetTraitInfo()
	local culturePerStr		= playerTrait.CultureFromKills / 100
	local barbCaptureLand	= playerTrait.LandBarbarianCapturePercent
	local barbCaptureSea	= playerTrait.SeaBarbarianCapturePercent
	local goldenPoints		= 0
	if wonUnit then
		for promoInfo in GameInfo.UnitPromotions("GoldenPoints <> 0") do
			if wonUnit:IsHasPromotion(promoInfo.ID) then
				goldenPoints = goldenPoints + promoInfo.GoldenPoints
			end
		end
		if goldenPoints > 0 then
			local yield = wonPlayer:GetUnitProductionNeeded(lostUnit:GetUnitType())
			yield = math.pow(yield * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION, GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT)
			yield = yield * (1 + GameInfo.Units[lostUnit:GetUnitType()].HurryCostModifier / 100)
			yield = Game.Round(yield / 100)
			wonPlayer:ChangeYieldStored(YieldTypes.YIELD_HAPPINESS, yield)
		end
	end
	if lostUnit and culturePerStr > 0 then
		local strength = GameInfo.Units[lostUnit:GetUnitType()].Combat
		local culture = culturePerStr * strength
		local leastCultureCity = wonPlayer:GetCapitalCity()
		for city in wonPlayer:Cities() do
			if not city:IsPuppet() and not city:IsRazing() then
				if city:GetJONSCultureLevel() == leastCultureCity:GetJONSCultureLevel() then
					if City_GetYieldStored(city, YieldTypes.YIELD_CULTURE) < City_GetYieldStored(leastCultureCity, YieldTypes.YIELD_CULTURE) then
						leastCultureCity = city
					end
				elseif city:GetJONSCultureLevel() < leastCultureCity:GetJONSCultureLevel() then
					leastCultureCity = city
				end
			end
		end
		leastCultureCity:ChangeJONSCultureStored(culture)
		--log:Debug(leastCultureCity:GetName().." +"..culture.." culture from killing "..lostUnit:GetName())
		cultureStored = City_GetYieldStored(leastCultureCity, YieldTypes.YIELD_CULTURE)
		cultureNext = City_GetYieldNeeded(leastCultureCity, YieldTypes.YIELD_CULTURE)
		cultureDiff = cultureNext - cultureStored
		if cultureDiff <= 0 then
			leastCultureCity:DoJONSCultureLevelIncrease()
			leastCultureCity:SetJONSCultureStored(-cultureDiff)
		end
	end
	if (lostPlayer:IsBarbarian()
		and lostUnit
		and lostUnit:IsCombatUnit()
		and ((lostUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and barbCaptureLand > 0)
			or (lostUnit:GetDomainType() == DomainTypes.DOMAIN_SEA and barbCaptureSea > 0))
		) then
		--if wonCity or (wonUnit:GetDomainType() == lostUnit:GetDomainType()) then
		local randChance = (1 + Map.Rand(99, "BL - General: DoEndCombatLeaderBonuses - barbCapture"))
		log:Debug("Barbarian dead, checking " ..barbCaptureLand.. " >= " ..randChance)
		if barbCaptureLand >= randChance or barbCaptureSea >= randChance then
			--log:Debug("%s captured barbarian %s", wonPlayer:GetName(), lostUnit:GetName())
			local plot = lostUnit:GetPlot()
			local newUnitID = GameInfo.Units[lostUnit:GetUnitType()].ID
			if newUnitID == GameInfo.Units.UNIT_SETTLER.ID then
				newUnitID = GameInfo.Units.UNIT_WORKER.ID
			end
			local newUnit = wonPlayer:InitUnit( newUnitID, plot:GetX(), plot:GetY() )
			if lostUnit:GetDomainType() == DomainTypes.DOMAIN_LAND then
				newUnit:SetDamage(0.75 * newUnit:GetMaxHitPoints(), wonPlayer)
			end
			newUnit:SetMadeAttack(true)
			newUnit:SetMoves(1)
		end
	end
end

Events.EndCombatSim.Add( DoEndCombatLeaderBonuses )
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

--[[
function DoLuxuryTradeBonus(player)
	local capital = player:GetCapitalCity()
	
	if capital then
		local playerTrait = player:GetTraitInfo()
		if playerTrait.CityGoldPerLuxuryPercent > 0 then
			log:Info("%-25s %15s", "DoLuxuryTradeBonus", player:GetName())
			local luxuryTotal = 0
			for resourceInfo in GameInfo.Resources() do
				local resourceID = resourceInfo.ID;
				if Game.GetResourceUsageType(resourceID) == ResourceUsageTypes.RESOURCEUSAGE_LUXURY then
					if player:GetNumResourceAvailable(resourceID, true) > 0 then
						luxuryTotal = luxuryTotal + 1
					end
				end
			end

			capital:SetNumRealBuilding(GameInfo.Buildings.BUILDING_DESERT_CARAVANS.ID, luxuryTotal * playerTrait.CityGoldPerLuxuryPercent)
		end
	end
end

LuaEvents.ActivePlayerTurnEnd_Player.Add( DoLuxuryTradeBonus )
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

--
function FreeUnitWithTech(player, techID, changeID)
	local playerID = player:GetID()
	log:Info("FreeUnitWithTech A player=%s tech=%s", playerID, techID)
	
	local player = Players[playerID]
	--print(tostring(player))
	--print(tostring(player.GetID))
	--print(tostring(player:GetID())) -- crashes with citystates?!
	local techInfo = GameInfo.Technologies[techID]
	local centerPlot = player:GetCapitalCity()
	
	--print(tostring(playerID), tostring(techID))
	if player:IsMinorCiv() or Game.GetGameTurn() <= 1 then
		return
	end
	
	if centerPlot then
		centerPlot = centerPlot:Plot()
	else
		-- no capital yet
		for unit in player:Units() do
			if unit:GetUnitType() == player:GetUniqueUnitID("UNITCLASS_SETTLER") then
				centerPlot = unit:GetPlot()
				break
			end
		end
	end
	
	local query = string.format("TraitType='%s' AND TechType='%s'", player:GetTraitInfo().Type, techInfo.Type)
	for row in GameInfo.Trait_FreeUnitAtTech(query) do
		local unitInfo = GameInfo.Units[player:GetUniqueUnitID(row.UnitClassType)]		
		local plot = centerPlot
		if unitInfo.Domain == "DOMAIN_SEA" then		
			plot = Plot_GetNearestOceanPlot(centerPlot, 10, 0.1 * Map.GetNumPlots())
			if not plot then
				log:Warn("Could not find large ocean near %s for free ship. Searching smaller bodies of water...", player:GetName())
				plot = Plot_GetNearestOceanPlot(centerPlot, 10)
			end
			if plot then
				log:Info("FreeUnitWithTech %s %s", player:GetName(), techInfo.Type)
				player:InitUnitType(unitInfo.Type, plot)
			else
				log:Warn("No coastal plot near %s for free ship!", player:GetName())
				plot = centerPlot
				if plot:IsCoastalLand() then
					player:InitUnitType(unitInfo.Type, plot)
				end
			end
		else
			player:InitUnitType(unitInfo.Type, plot)
		end
	end
end
LuaEvents.NewTech.Add(FreeUnitWithTech)
--]]

--[[
MapModData.Civup.HasFreeShip = {}
for playerID, player in pairs(Players) do
	if player:IsAliveCiv() and not player:IsMinorCiv() then
		MapModData.Civup.HasFreeShip[playerID] = player:HasTech("TECH_COMPASS")
	end
end

function DoSpainCaravelHack(player)
	if player:GetTraitInfo().Type ~= "TRAIT_SEVEN_CITIES" or MapModData.Civup.HasFreeShip[player:GetID()] then
		return
	end
	
	local capital = player:GetCapitalCity()
	if capital and player:HasTech("TECH_COMPASS") then
		MapModData.Civup.HasFreeShip[playerID] = true
		local centerPlot = capital:Plot()

		local plot = Plot_GetNearestOceanPlot(centerPlot, 10, 0.1 * Map.GetNumPlots())
		if not plot then
			log:Warn("Could not find large ocean near %s for free ship. Searching smaller bodies of water...", player:GetName())
			plot = Plot_GetNearestOceanPlot(centerPlot, 10)
		end
		if plot then
			player:InitUnitType("UNIT_CARAVEL", plot)
		else
			log:Warn("No coastal plot near %s for free ship!", player:GetName())
			plot = centerPlot
			if plot:IsCoastalLand() then
				player:InitUnitType("UNIT_CARAVEL", plot)
			end
		end
	end
end
LuaEvents.ActivePlayerTurnStart_Player.Add(DoSpainCaravelHack)
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

function NationalWonderDiscoveryBonus(...)
	for index,value in ipairs(arg) do
		log:Warn("arg=%s type=%s value=%s", index, type(value), value)
	end
end

--Events.NaturalWonderRevealed.Add(NationalWonderDiscoveryBonus)