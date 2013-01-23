-- BC - General.lua
-- Author: Thalassicus
-- DateCreated: 10/29/2010 12:44:28 AM
--------------------------------------------------------------

include("CiVUP_Core.lua")
include("CustomNotification.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

LuaEvents.NotificationAddin( { name = "Refugees", type = "CNOTIFICATION_REFUGEES" } )
LuaEvents.NotificationAddin( { name = "CapturedMaritime", type = "CNOTIFICATION_CAPTURED_MARITIME" } )
LuaEvents.NotificationAddin( { name = "CapturedCultural", type = "CNOTIFICATION_CAPTURED_CULTURAL" } )
LuaEvents.NotificationAddin( { name = "CapturedMilitaristic", type = "CNOTIFICATION_CAPTURED_MILITARISTIC" } )
LuaEvents.NotificationAddin( { name = "CapturedReligious", type = "CNOTIFICATION_CAPTURED_RELIGIOUS" } )
LuaEvents.NotificationAddin( { name = "CapturedMercantile", type = "CNOTIFICATION_CAPTURED_MERCANTILE" } )
LuaEvents.NotificationAddin( { name = "CapturedOther", type = "CNOTIFICATION_CAPTURED_OTHER" } )


---------------------------------------------------------------------
---------------------------------------------------------------------

function CheckForMinorAIBonuses(unit)
	if not unit then
		return
	end
	
	local promotionID = {
		PLOT_HILLS		= GameInfo.UnitPromotions.PROMOTION_HILL_FIGHTER.ID,
		TERRAIN_DESERT	= GameInfo.UnitPromotions.PROMOTION_DESERT_POWER.ID,
		ARCTIC			= GameInfo.UnitPromotions.PROMOTION_ARCTIC_POWER.ID,
		VEGGIE			= GameInfo.UnitPromotions.PROMOTION_WOODSMAN.ID,
		SEA				= GameInfo.UnitPromotions.PROMOTION_EMBARKATION.ID,
		IMPASSABLE		= GameInfo.UnitPromotions.PROMOTION_CAN_MOVE_IMPASSABLE.ID
	}
	
	for k,v in pairs(promotionID) do
		if unit:IsHasPromotion(v) then
			return
		end
	end
	--log:Info("CheckForMinorAIBonuses %s", unit:GetName())

	local player = Players[unit:GetOwner()]
	local plot = unit:GetPlot()
	if player:IsMinorCiv() then
		local capital = player:GetCapitalCity()
		if not capital then
			return
		end
		plot = capital:Plot()
	end
	
	local maxRadius			= GameInfo.Units[unit:GetUnitType()].Moves + Civup.BARBARIAN_CREATION_SCAN_BASE_DISTANCE
	local areaWeight		= Plot_GetAreaWeights(plot, 1, maxRadius)
	local weights			= {}
	weights.PLOT_HILLS		= areaWeight.PLOT_HILLS
	weights.TERRAIN_DESERT	= areaWeight.TERRAIN_DESERT
	weights.ARCTIC			= areaWeight.TERRAIN_SNOW
	weights.VEGGIE			= areaWeight.FEATURE_FOREST + areaWeight.FEATURE_JUNGLE
	local defaultPromo		= "VEGGIE"
	local largest			= defaultPromo

	for k, v in pairs(weights) do
		if v > weights[largest] then
			largest = k
		end
	end
	
	local iW, iH = Map.GetGridSize()

	log:Debug("New %15s %15s on %15s (total=%2.2f hill=%.2f desert=%.2f arctic=%.2f veggie=%.2f)",
		player:GetName(),
		unit:GetName(),
		largest,
		areaWeight.TOTAL,
		weights.PLOT_HILLS,
		weights.TERRAIN_DESERT,
		weights.ARCTIC,
		weights.VEGGIE
	)
	
	if unit:GetDomainType() == DomainTypes.DOMAIN_LAND then
		unit:SetHasPromotion(promotionID[largest], true)

		if areaWeight.SEA >= 0.25 then
			unit:SetHasPromotion(promotionID.SEA, true)
			unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_EMBARKATION.ID, false)
		end
	elseif player:IsBarbarian() or (unit:GetDomainType() == DomainTypes.DOMAIN_SEA and areaWeight.FEATURE_ICE >= 0.1) then
		unit:SetHasPromotion(promotionID.IMPASSABLE, true)
	end
end

function CheckForMinorAIBonusesLoop()
	--log:Info("CheckForMinorAIBonusesLoop")
	for playerID,player in pairs(Players) do
		if player:IsAlive() and (player:IsBarbarian() or player:IsMinorCiv()) then
			for unit in player:Units() do
				if unit then
					CheckForMinorAIBonuses(unit)
				end
			end
		end
	end
end

Events.ActivePlayerTurnStart.Add( CheckForMinorAIBonusesLoop )

---------------------------------------------------------------------
---------------------------------------------------------------------

LuaEvents.CityCaptureBonuses = LuaEvents.CityCaptureBonuses or function(city) end

function City_DoRefugees(lostCityPlot, lostCity, lostCityName, lostPlayer, wonPlayer)
	log:Info("City_DoRefugees %s", lostCity:GetName())
	local capitalCity	= lostPlayer:GetCapitalCity()
	local refugees		= false	
	local lostCityPop	= lostCity:GetPopulation()
	local popLost		= 0
	local popDead		= 0
	local popFlee		= 0
	local resistMod		= 1.0
	
	for policyInfo in GameInfo.Policies("CityResistTimeMod <> 0") do
		if wonPlayer:HasPolicy(policyInfo.ID) then
			resistMod = resistMod + policyInfo.CityResistTimeMod / 100
		end
	end
	
	if lostCityPop >= 2 then
		popLost = Game.Round(0.1 * lostCityPop) + 1
		lostCity:ChangePopulation(-popLost, true)
	end
	if lostCityPop >= 3 then
		popFlee = math.max(0, popLost - 1)
	end
	lostCityPop = lostCity:GetPopulation()

	local heldTime		= (Game.GetGameTurn() - lostPlayer:GetTurnAcquired(lostCity))
	local heldMinTime	= Civup.PARTISANS_MIN_CITY_OWNERSHIP_TURNS * GameInfo.GameSpeeds[Game.GetGameSpeedType()].TrainPercent / 100
	local resistMaxTime	= math.max(1, math.min(heldTime, lostCityPop))
	local resistTime	= (lostCityPop - 0.1*lostCityPop^1.5) * resistMod
		  resistTime	= Game.Constrain(1, Game.Round(resistTime), resistMaxTime)

	City_SetResistanceTurns(lostCity, resistTime)
	
	if not capitalCity then
		return
	end

	if popFlee > 0 then
		capitalCity:ChangePopulation(popFlee, true)
	end
	--[[
	log:Info("%s captured: heldMinTime=%s MinTurns=%s TrainPercent=%s turn=%s acquired=%s resistMaxTime=%s resistTime=%s",
		heldMinTime,
		Civup.PARTISANS_MIN_CITY_OWNERSHIP_TURNS,
		GameInfo.GameSpeeds[Game.GetGameSpeedType()].TrainPercent / 100,
		Game.GetGameTurn(),
		lostPlayer:GetTurnAcquired(lostCity),
		resistMaxTime,
		resistTime
	)
	--]]
	if not wonPlayer:IsHuman() and not lostPlayer:IsHuman() then
		return
	end
	if heldTime < heldMinTime then
		return
	end
	
	-- Create partisans
	
	if lostPlayer:IsHuman() then
		local itemID = Game.GetRandomWeighted(City_GetUnitsOfFlavor(capitalCity, "FLAVOR_DEFENSE"))
		if itemID ~= -1 then
			lostPlayer:InitUnit(itemID, capitalCity:GetX(), capitalCity:GetY())
		end
	end
	if wonPlayer:IsHuman() and not lostPlayer:IsHuman() then
		-- AIs get a bonus unit defending against the human
		local itemID = Game.GetRandomWeighted(City_GetUnitsOfFlavor(capitalCity, "FLAVOR_OFFENSE"))
		if itemID ~= -1 then
			lostPlayer:InitUnit(itemID, capitalCity:GetX(), capitalCity:GetY())
		end
	end
	
	if lostCityPlot:IsRevealed(Game.GetActiveTeam()) then
		if refugees then
			CustomNotification(
				"Refugees",
				"War refugees flee "..lostCityName,
				string.format("Refugees from %s flee to %s and rally as partisan fighters!", lostCityName, capitalCity:GetName()),
				lostCityPlot,
				0,
				"Red",
				0
			)
		else
			CustomNotification(
				"Refugees",
				"Partisans rally at "..capitalCity:GetName(),
				string.format("Partisans from %s rally at %s!", lostCityName, capitalCity:GetName()),
				lostCityPlot,
				0,
				"Red",
				0
			)
		end
	end
end

function City_DoCitystateCapture(lostCityPlot, lostCity, lostCityName, lostPlayerID, wonPlayerID, capturingUnit)
	log:Info("City_DoCitystateCapture %s", lostCityName)
	local wonPlayer			= Players[wonPlayerID]
	local lostPlayer		= Players[lostPlayerID]
	local minorTrait		= lostPlayer:GetMinorCivTrait()
	local traitCaptureBonus	= 1 + wonPlayer:GetTraitInfo().MinorCivCaptureBonus / 100
	--local captureBonusTurns	= Civup.MINOR_CIV_CAPTURE_BONUS_TURNS
	
	local captureBonusTurns = 0
	for policyInfo in GameInfo.Policies("CitystateCaptureYieldTurns > 0") do
		if wonPlayer:HasPolicy(policyInfo.ID) then
			captureBonusTurns = captureBonusTurns + policyInfo.CitystateCaptureYieldTurns
		end
	end
	
	if captureBonusTurns == 0 then
		return
	end
	
	if (minorTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MARITIME) then
		log:Debug(" Maritime")
		local yieldID = YieldTypes.YIELD_FOOD
		local yieldLoot = captureBonusTurns * traitCaptureBonus * wonPlayer:GetCitystateYields(minorTrait, 2)[yieldID]
		for city in wonPlayer:Cities() do
			City_ChangeYieldStored(city, yieldID, yieldLoot * City_GetWeight(city, yieldID)/wonPlayer:GetTotalWeight(yieldID) * (1 + City_GetBaseYieldRateModifier(city, yieldID)/100) )
		end			
		if Game.GetActivePlayer() == wonPlayerID then
			CustomNotification(
				"CapturedMaritime",
				"Looted Food",
				yieldLoot.." [ICON_FOOD] Food looted from the maritime [ICON_CITY_STATE] City-State of "..lostCityName.." distributed to your Cities.",
				lostCityPlot,
				0,
				0,
				0
			)
		end
	elseif (minorTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_CULTURED) then
		log:Debug(" Cultural")
		local yieldID = YieldTypes.YIELD_CULTURE
		local yieldLoot = captureBonusTurns * traitCaptureBonus * wonPlayer:GetCitystateYields(minorTrait, 2)[yieldID]
		local totalCulture = 0
		for targetCity in wonPlayer:Cities() do
			local cityCulture = yieldLoot * City_GetWeight(targetCity, yieldID)/wonPlayer:GetTotalWeight(yieldID) * (1 + City_GetBaseYieldRateModifier(targetCity, yieldID)/100)
			totalCulture = totalCulture + cityCulture
			City_ChangeYieldStored(targetCity, yieldID, cityCulture)
		end
			
		if Game.GetActivePlayer() == wonPlayerID then
			CustomNotification(
				"CapturedCultural",
				"Looted Cultural Artifacts",
				string.format("%i [ICON_CULTURE] Culture of valuable artifacts looted from the cultural [ICON_CITY_STATE] City-State of %s.", Game.Round(totalCulture, -1), lostCityName),
				lostCityPlot,
				0,
				0,
				0
			)
		end
	elseif (minorTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) and capturingUnit then
		log:Debug(" Militaristic")
		local quantity		= 3
		local availableIDs	= City_GetBuildableUnitIDs(lostCity)
		local newUnitID		= availableIDs[1 + Map.Rand(#availableIDs, "Militaristic CS Capture")]
		local xp			= wonPlayer:GetCitystateYields(minorTrait, 2)[YieldTypes.YIELD_EXPERIENCE]
		if newUnitID == nil then
			newUnitID = GameInfo.Units.UNIT_SCOUT.ID
		end
		if GameInfo.Units[newUnitID].Domain ~= "DOMAIN_LAND" then
			xp = xp * Civup.MINOR_CIV_MILITARISTIC_XP_NONLAND_PENALTY
		end
		
		for i=1, quantity do
			local index = 1 + Map.Rand(#availableIDs, "InitUnitFromList")
			local newUnitID = availableIDs[index]
			if #availableIDs >= 2 then
				table.remove(availableIDs, index)
			end

			--log:Debug("  Reward=%s  XP=%s", GameInfo.Units[newUnitID].Type, xp)
			wonPlayer:InitUnitType(newUnitID, lostCityPlot, xp)
			
			if Game.GetActivePlayer() == wonPlayer:GetID() then
				local newUnitIcon = {{"Unit1", newUnitID, 0, 0, 0}}
				local newUnitName = Locale.ConvertTextKey(GameInfo.Units[newUnitID].Description)
				CustomNotification(
					"CapturedMilitaristic",
					"Conscripts",
					string.format("Conscripted %s into your army from the militaristic [ICON_CITY_STATE] City-State of %s.", newUnitName, lostCityName),
					lostCityPlot,
					0,
					0,
					newUnitIcon
				)
			end
		end
	elseif (minorTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_RELIGIOUS) then
		log:Debug(" Religious")
		local yieldID = YieldTypes.YIELD_FAITH
		local yieldLoot = Game.Round(captureBonusTurns * traitCaptureBonus * wonPlayer:GetCitystateYields(minorTrait, 2)[yieldID])
		wonPlayer:ChangeYieldStored(yieldID, yieldLoot)
		if Game.GetActivePlayer() == wonPlayerID then
			CustomNotification(
				"CapturedReligious",
				"Religious Zeal",
				string.format("%s [ICON_PEACE] religious zeal gained by capturing the religious [ICON_CITY_STATE] City-State of %s.", yieldLoot, lostCityName),
				lostCityPlot,
				0,
				0,
				0
			)
		end
	elseif (minorTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MERCANTILE) then
		log:Debug(" Mercantile")
		local yieldID = YieldTypes.YIELD_GOLD
		local yieldLoot = 100 + captureBonusTurns * traitCaptureBonus * 2 ^ (wonPlayer:GetCurrentEra() + 1)
		wonPlayer:ChangeYieldStored(yieldID, yieldLoot)
		if Game.GetActivePlayer() == wonPlayerID then
			CustomNotification(
				"CapturedMercantile",
				"Looted Gold",
				yieldLoot.." [ICON_GOLD] Gold looted from the mercantile [ICON_CITY_STATE] City-State of "..lostCityName..".",
				lostCityPlot,
				0,
				0,
				0
			)
		end
	else
		log:Debug(" Other")
		local yieldID = YieldTypes.YIELD_GOLD
		local yieldLoot = 100 + captureBonusTurns * traitCaptureBonus * 2 ^ (wonPlayer:GetCurrentEra() + 1)
		wonPlayer:ChangeYieldStored(yieldID, yieldLoot)
		if Game.GetActivePlayer() == wonPlayerID then
			CustomNotification(
				"CapturedOther",
				"Looted Gold",
				yieldLoot.." [ICON_GOLD] Gold looted from the [ICON_CITY_STATE] City-State of "..lostCityName..".",
				lostCityPlot,
				0,
				0,
				0
			)
		end
	end
end

function CityCaptured (plot, lostPlayerID, cityID, wonPlayerID)
	local capturingUnit	= Plot_GetCombatUnit(plot)
	local wonPlayer		= Players[wonPlayerID]
	local lostPlayer	= Players[lostPlayerID]
    local lostCityPlot	= Map.GetPlot(ToGridFromHex( plot.x, plot.y ))
	local lostCity		= lostCityPlot:GetPlotCity()
	local lostCityName	= lostCity:GetName()
	local capitalCity	= lostPlayer:GetCapitalCity()
	
	if not (capturingUnit and capturingUnit:GetOwner() == wonPlayerID) then
		-- The new owner does not have a unit in the city.
		-- This occurs when players gift cities to other players.
		return
	end

	log:Info("%s captured %s from %s: %s capital city", wonPlayer:GetName(), lostCityName, lostPlayer:GetName(), capitalCity and capitalCity:GetName() or "no")
	
	City_DoRefugees(lostCityPlot, lostCity, lostCityName, lostPlayer, wonPlayer)

	if not capitalCity and lostPlayer:IsMinorCiv() and lostPlayer:GetNumCities() <= 0 then
		City_DoCitystateCapture(lostCityPlot, lostCity, lostCityName, lostPlayerID, wonPlayerID, capturingUnit)
	end

	LuaEvents.CityCaptureBonuses(lostCity, wonPlayer)
end

Events.SerialEventCityCaptured.Add( CityCaptured )

---------------------------------------------------------------------
---------------------------------------------------------------------


function DoEndCombatBlitzCheck(
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
	
	local attPlayer	= Players[attPlayerID]
	local attUnit	= attPlayer:GetUnitByID(attUnitID)

	local attExtraAttacks = 0
	local fullMovesAfterAttack = false --attUnit:IsHasPromotion(GameInfo.UnitPromotions.PROMOTION_CAN_MOVE_AFTER_ATTACKING.ID) 

	if attUnit and (attFinalUnitDamage < attMaxHitPoints) then
		--log:Debug("DoEndCombatBlitzCheck %15s %15s", attPlayer:GetName(), attUnit:GetName())
		for promoInfo in GameInfo.UnitPromotions("ExtraAttacks > 0 OR CanMoveAfterAttacking = 1") do
			if attUnit:IsHasPromotion(promoInfo.ID) then
				if promoInfo.ExtraAttacks > 0 and promoInfo.ExtraAttacks > attExtraAttacks then
					attExtraAttacks = promoInfo.ExtraAttacks
				end
				if promoInfo.FullMovesAfterAttack then
					fullMovesAfterAttack = true
				end
			end
		end
		attExtraAttacks = attExtraAttacks
		local movesMax = attUnit:MaxMoves() / GameDefines.MOVE_DENOMINATOR
		local movesLeft = attUnit:MovesLeft() / GameDefines.MOVE_DENOMINATOR
		local movesNew = math.min(movesLeft, attExtraAttacks)

		--log:Debug("fullMovesAfterAttack=%s,  %.2f = math.min(%.2f, %.2f)", fullMovesAfterAttack, movesNew, movesMax, movesLeft, attExtraAttacks)
		if attExtraAttacks > 0 and not fullMovesAfterAttack then
			attUnit:SetMoves(movesNew * GameDefines.MOVE_DENOMINATOR)
		end
	end
end

Events.EndCombatSim.Add( DoEndCombatBlitzCheck )

---------------------------------------------------------------------
---------------------------------------------------------------------