-- WWGD - Events
-- Author: Thalassicus
-- DateCreated: 6/6/2011 2:11:50 PM
--------------------------------------------------------------

include("CiVUP_Core.lua")
include("FLuaVector");

local log = Events.LuaLogger:New();
log:SetLevel("INFO");

--
-- Spend AI gold more intelligently
--

function SpendExcessAIGold(player)
	local speedMod = GameInfo.GameSpeeds[Game.GetGameSpeedType()].VictoryDelayPercent / 100
	if (player:IsHuman()
		or (Game.GetGameTurn() < 10 * speedMod)
		or not player:GetCapitalCity() 
		) then
		return
	end

	if player:IsMinorCiv() then
		return UpgradeSomeUnit(player, player:GetYieldStored(YieldTypes.YIELD_GOLD))
	end

	local capital = player:GetCapitalCity()
	if not capital then
		return
	end
	
	local playerID		= player:GetID()
	local eraID			= Game.GetAverageHumanEra()
	local isWarHuman	= player:IsAtWarWithHuman()
	local isWarAny		= player:IsAtWarWithAny()
	local activePlayer	= Players[Game.GetActivePlayer()]
	local goldStored	= player:GetYieldStored(YieldTypes.YIELD_GOLD)
	local cities		= {}
	local citiesReverse	= {}
	local numMilitary	= 0
	local numWorkers	= 0
	local numScouts		= 0
	local targetGold	= 0
	local MIN_GOLD		= 100
	local scoutID		= player:GetUniqueUnitID("UNITCLASS_SCOUT")

	if goldStored < MIN_GOLD or player:GetYieldRate(YieldTypes.YIELD_GOLD) < 0 then
		return
	end
	
	if not isWarHuman then
		targetGold = 1.5 * GameInfo.Eras[eraID].ResearchAgreementCost * GameInfo.GameSpeeds[Game.GetGameSpeedType()].GoldPercent / 100
	end
	
	if not player:IsMinorCiv() then
		--log:Info("%-15s %20s %3s/%-4s budgeted", "AIPurchase", player:GetName(), goldStored-targetGold, player:GetYieldStored(YieldTypes.YIELD_GOLD))
	end

	--
	-- High priorities
	--
	
	-- Diplomatic victory
	if MapModData.VEM.DiploVictoryUnlocked then
		PurchaseAllInfluence(player, targetGold)
		goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
		if goldStored < MIN_GOLD then return end
	end
	
	-- Upgrades
	local upgradesPerformed = 0
	if player:IsMilitaristicLeader() or isWarHuman then
		while UpgradeSomeUnit(player, goldStored-targetGold) and upgradesPerformed < 10 do
			upgradesPerformed = upgradesPerformed + 1
			goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
			if goldStored < MIN_GOLD then return end
		end
	end
	
	-- Create lists
	for city in player:Cities() do
		if not city:IsResistance() and not city:IsRazing() and not city:IsCapital() then
			table.insert(cities, {id=City_GetID(city), pop=city:GetPopulation()})
		end
	end
	table.sort(cities, function(a, b) return a.pop < b.pop end)
	citiesReverse = Game.Reverse(cities)
	-- capital gets first priority
	table.insert(cities, 1, {id=City_GetID(capital), pop=capital:GetPopulation()})
	table.insert(citiesReverse, 1, {id=City_GetID(capital), pop=capital:GetPopulation()})
	
	for unit in player:Units() do
		if Unit_IsWorker(unit) then
			numWorkers = numWorkers + 1
		elseif unit:GetUnitType() == scoutID then
			numScouts = numScouts + 1
		elseif Unit_IsCombatDomain(unit, "DOMAIN_LAND") then
			numMilitary = numMilitary + 1
		end
	end
	
	-- City garrisons
	local unitsToBuy = 0
	if isWarAny or player:IsMilitaristicLeader() then
		unitsToBuy = player:GetNumCities() - numMilitary
		if not isWarHuman then
			unitsToBuy = math.min(1, unitsToBuy)
		end
	end
	while unitsToBuy > 0 do
		unitsToBuy = unitsToBuy - 1
		if not PurchaseUnitOfFlavor(player, cities, goldStored, "FLAVOR_DEFENSE") then break end
		goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
		if goldStored < MIN_GOLD then return end
	end
	
	-- Found pantheon or religion
	if player:IsReligiousLeader() and player:CanFoundFaith() then
		PurchaseBuildingOfFlavor(player, cities, goldStored, "FLAVOR_RELIGION")
		goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
		if goldStored < MIN_GOLD then return end
	end

	-- Workers
	unitsToBuy = 1 + player:GetNumCities() - numWorkers
	while unitsToBuy > 0 do
		unitsToBuy = unitsToBuy - 1
		if not PurchaseUnitOfFlavor(player, cities, goldStored, "FLAVOR_TILE_IMPROVEMENT") then break end
		goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
		if goldStored < MIN_GOLD then return end
	end

	-- Scouts
	--if not player:HasTech(GameInfo.Units[player:GetUniqueUnitID("UNITCLASS_LEVY")].PrereqTech) then
		unitsToBuy = 2 - numScouts
		while unitsToBuy > 0 do
			unitsToBuy = unitsToBuy - 1		
			
			local cost = City_GetPurchaseCost(capital, YieldTypes.YIELD_GOLD, GameInfo.Units, scoutID)
			if goldStored < cost then return end
			
			player:InitUnitType(scoutID, capital:Plot(), City_GetUnitExperience(capital, scoutID))				
			log:Info("%-15s %20s %3s/%-4s spent for %s", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), GameInfo.Units[scoutID].Type)
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)

			goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
			if goldStored < MIN_GOLD then return end
		end
	--end
	
	goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
	--log:Debug("goldStored=%s targetGold=%s minimum=%s", goldStored, targetGold, Civup.AI_PURCHASE_BUDGET_MINIMUM)
	if (goldStored-targetGold) < Civup.AI_PURCHASE_BUDGET_MINIMUM then return end
	
	
	--
	-- Leader priorities
	--	
	
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local unitMod		= 0
	local doUnits		= (GetCurrentUnitSupply(player) < GetMaxUnitSupply(player))
	local attempt		= 1
	local flavorWeights	= {}
	local flavorMod		= {
		FLAVOR_DIPLOMACY			= GetCitystateMod(player),
		FLAVOR_NAVAL				= player:HasTech("TECH_SAILING") and 1 or 0,
		FLAVOR_AIR					= player:HasTech("TECH_FLIGHT") and 1 or 0,
		FLAVOR_EXPANSION			= isWarAny and 0 or 5 / player:GetNumCities(),
		FLAVOR_TILE_IMPROVEMENT		= 0, --numWorkers - player:GetNumCities() and 1 or 0,
		FLAVOR_GROWTH				= 1.1 ^ (10 - citiesReverse[1].pop),
		FLAVOR_HAPPINESS			= 1.1 ^ (10 - player:GetYieldRate(YieldTypes.YIELD_HAPPINESS)),
		FLAVOR_RELIGION				= player:CanFoundFaith() and 2 or 0.5
	}

	if isWarHuman then
		unitMod = 2
	elseif Game.GetGameTurn() > 25 * speedMod then
		unitMod = Game.GetValue("Flavor", {LeaderType=leaderInfo.Type, FlavorType="FLAVOR_MILITARY_TRAINING"}, GameInfo.Leader_Flavors) / 4
	end
	
	for row in GameInfo.Leader_Flavors{LeaderType = leaderInfo.Type} do
		local flavorType = row.FlavorType
		local flavorValue = row.Flavor
		local priority = GameInfo.Flavors[flavorType].PurchasePriority * (flavorMod[flavorType] or 1)
		if DoFlavorFunction[flavorType] == PurchaseUnitOfFlavor then
			priority = priority * unitMod
		end
		if flavorValue > 0 and priority > 0 then
			if doUnits or DoFlavorFunction[flavorType] ~= PurchaseUnitOfFlavor then
				--log:Info("%-15s %20s %3s/%-4s %-20s priority=%-3s", "AIPurchase", player:GetName(), " ", string.gsub(flavorType, "FLAVOR_", ""), flavorValue)
				flavorWeights[flavorType] = flavorValue * priority
			end
		end
	end
	
	local attempt = 0
	while attempt <= Civup.AI_PURCHASE_FLAVOR_MAX_ATTEMPTS do		
		attempt = attempt + 1

		local flavorType = Game.GetRandomWeighted(flavorWeights)
		if flavorType == -1 then
			log:Warn("%15s %20s %3s %-4s no valid flavors for purchase", "AIPurchase", player:GetName(), " ", " ")
			break
		end
		
		local success = false
		if flavorType == "FLAVOR_EXPANSION" then
			success = DoFlavorFunction[flavorType](player, cities, goldStored, flavorType)
		elseif flavorType == "FLAVOR_GROWTH" or flavorType == "FLAVOR_PRODUCTION" then
			success = DoFlavorFunction[flavorType](player, citiesReverse, goldStored-targetGold, flavorType)
		else
			if not flavorType or not DoFlavorFunction[flavorType] then
				log:Error("DoFlavorFunction[%s] == nil", flavorType)
			else
				success = DoFlavorFunction[flavorType](player, cities, goldStored-targetGold, flavorType)
			end
		end
		
		if flavorType == "FLAVOR_DIPLOMACY" or not success then
			flavorWeights[flavorType] = 0
		else
			flavorWeights[flavorType] = 0.5 * flavorWeights[flavorType]
		end
		
		goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
		if (goldStored-targetGold) < Civup.AI_PURCHASE_BUDGET_MINIMUM then return end
	end

	-- No affordable purchase
	log:Info("%-15s %20s %3s/%-4s saved", "AIPurchase", player:GetName(), goldStored-targetGold, player:GetYieldStored(YieldTypes.YIELD_GOLD))
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(SpendExcessAIGold)

function UpgradeSomeUnit(player, budget)
	local playerID = player:GetID()
	for unit in player:Units() do
		local newID = unit:GetUpgradeUnitType()
		if Unit_CanUpgrade(unit, newID, budget) then
			if player:IsMinorCiv() then
				log:Info("%-15s %20s %3s/%-4s spent upgrading %s (#%s)", "AIPurchase", player:GetName(), unit:UpgradePrice(newID), player:GetYieldStored(YieldTypes.YIELD_GOLD), unit:GetName(), unit:GetID())
			else
				log:Info("%-15s %20s %3s/%-4s spent upgrading %s (#%s)", "AIPurchase", player:GetName(), unit:UpgradePrice(newID), player:GetYieldStored(YieldTypes.YIELD_GOLD), unit:GetName(), unit:GetID())
			end
			Unit_Replace(unit, GameInfo.Units[newID].Class)
			return true
		end
	end
	return false
end

function GetCitystateMod(player)
	local playerID		= player:GetID()
	local csWeight		= 0
	local csTotal		= 0
	local breakpoint	= 15 --GameDefines.FRIENDSHIP_THRESHOLD_FRIENDS
	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and player:IsAtPeace(minorCiv) then
			if not minorCiv:IsAllies(playerID) then
				local influence = minorCiv:GetMinorCivFriendshipWithMajor(playerID)
				if influence < breakpoint then
					csWeight = csWeight + 1
				else
					csWeight = csWeight + breakpoint / influence
				end
			end
			csTotal = csTotal + 1
		end
	end
	if csTotal == 0 then
		-- no known citystates
		return 0
	end
	return (csWeight / csTotal)
end

function PurchaseUnitOfFlavor(player, cities, budget, flavorType)
	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)
		local itemID = Game.GetRandomWeighted(City_GetUnitsOfFlavor(city, flavorType, budget))
		if itemID ~= -1 then
			local cost = City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Units, itemID)
			player:InitUnitType(itemID, city:Plot(), City_GetUnitExperience(city, itemID))				
			log:Info("%-15s %20s %3s/%-4s spent for %s", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), GameInfo.Units[itemID].Type)
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
			return true
		end
	end
	log:Info("%-15s %20s %3s %-4s no affordable unit of %s", "AIPurchase", player:GetName(), " ", " ", flavorType)
	return false
end

function PurchaseBuildingOfFlavor(player, cities, budget, flavorType)
	if not flavorType then
		log:Error("PurchaseBuildingOfFlavor: flavorType=nil!")
		return
	end
	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)
		local itemID = Game.GetRandomWeighted(City_GetBuildingsOfFlavor(city, flavorType, budget))
		if itemID ~= -1 then
			local cost = City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Buildings, itemID)
			city:SetNumRealBuilding(itemID, 1)	
			log:Info("%-15s %20s %3s/%-4s spent for %s", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), GameInfo.Buildings[itemID].Type)
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
			return true
		end
	end
	log:Info("%-15s %20s %3s %-4s no affordable building of %s", "AIPurchase", player:GetName(), " ", " ", flavorType)
	return false
end

function PurchaseInfluence(player, cities, budget, flavorType)
	local playerID		= player:GetID()
	local playerTeam	= Teams[player:GetTeam()]
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local budget		= math.min(Game.Round(budget, -1), 500)
	local capitalPlot	= player:GetCapitalCity():Plot()
	local chosenMinor	= nil
	local chosenWeight	= -1

	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and player:IsAtPeace(minorCiv) then

			local minorTeamID		= minorCiv:GetTeam()
			local minorCapitalPlot	= minorCiv:GetCapitalCity():Plot()			
			local influence			= minorCiv:GetMinorCivFriendshipWithMajor(playerID)
			local influenceDiff		= influence - player:GetRivalInfluence(minorCiv)
			local distance			= Map.PlotDistance(capitalPlot:GetX(), capitalPlot:GetY(), minorCapitalPlot:GetX(), minorCapitalPlot:GetY())
			local military			= Game.GetValue("Flavor", {LeaderType=leaderInfo.Type, FlavorType="FLAVOR_MILITARY_TRAINING"}, GameInfo.Leader_Flavors) - 4
			local weight			= 1
			
			-- influence
			if influence < 50 then
				weight = 10 - 0.002 * influence ^ 2
			else
				weight = 280 / influence
			end
			
			-- rival influence difference
			if influenceDiff <= -10 then
				weight = weight * 10
			else
				weight = weight * 100 / (influenceDiff + 20)
			end
			
			-- distance
			weight = weight / math.max(0.01, distance)
			
			-- trait
			if minorCiv:GetMinorCivTrait() == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC then
				weight = weight * math.max(0.01, 1.1 ^ military)
			else
				weight = weight / math.max(0.01, 1.1 ^ military)
			end
			
			-- personality
			if minorCiv:GetPersonality() == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_HOSTILE then
				weight = weight * 0.66
			elseif minorCiv:GetPersonality() == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_NEUTRAL then
				weight = weight * 1.5
			end
			
			if weight > chosenWeight then
				chosenMinor = minorCiv
				chosenWeight = weight
			elseif weight == chosenWeight and 1 == Map.Rand(2, "InitUnitFromList") then
				chosenMinor = minorCiv
				chosenWeight = weight
			end
		end
	end
	
	if chosenMinor then
		local influence = chosenMinor:GetFriendshipFromGoldGift(playerID, budget)
		chosenMinor:ChangeMinorCivFriendshipWithMajor(playerID, influence)
		log:Info("%-15s %20s %3s/%-4s spent for %s influence with %s", "AIPurchase", player:GetName(), budget, player:GetYieldStored(YieldTypes.YIELD_GOLD), influence, chosenMinor:GetName())
		player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * budget)
		return true
	end
	
	return false
end

function PurchaseAllInfluence(player, targetGold)
	targetGold = targetGold or 100
	local attempts = 0
	local playerID = player:GetID()
	while (player:GetYieldStored(YieldTypes.YIELD_GOLD) - targetGold) > Civup.AI_PURCHASE_BUDGET_MINIMUM and attempts < 10 do
		local chosenMinor	= nil
		local chosenWeight	= -1
		local budget		= math.min(500, player:GetYieldStored(YieldTypes.YIELD_GOLD))
		for minorCivID, minorCiv in pairs(Players) do
			if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and player:IsAtPeace(minorCiv) then
				local influence		= minorCiv:GetMinorCivFriendshipWithMajor(playerID)
				local influenceDiff	= influence - player:GetRivalInfluence(minorCiv)
				local weight		= 1

				weight = weight * 10 / (influence + 200)
				weight = weight * math.max(50, 100 - math.abs(influenceDiff + 20))
				
				if weight > chosenWeight then
					chosenMinor = minorCiv
					chosenWeight = weight
				elseif weight == chosenWeight and 1 == Map.Rand(2, "InitUnitFromList") then

					chosenMinor = minorCiv
					chosenWeight = weight
				end
			end
		end
		if chosenMinor then
			local influence = chosenMinor:GetFriendshipFromGoldGift(playerID, budget)
			chosenMinor:ChangeMinorCivFriendshipWithMajor(playerID, influence)
			log:Info("%-15s %20s %3s/%-4s spent for %s influence with %s (Diplo victory unlocked!)", "AIPurchase", player:GetName(), budget, player:GetYieldStored(YieldTypes.YIELD_GOLD), influence, chosenMinor:GetName())
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * budget)
		else
			return
		end
		attempts = attempts + 1
	end
end

function CheckDiploVictoryUnlocked()	
	if MapModData.VEM.DiploVictoryUnlocked or not PreGame.IsVictory(GameInfo.Victories.VICTORY_DIPLOMATIC.ID) then
		return
	end
	for buildingInfo in GameInfo.Buildings("VictoryPrereq = 'VICTORY_DIPLOMATIC'") do
		local tech = buildingInfo.PrereqTech
		for playerID, player in pairs(Players) do
			if player:IsAliveCiv() and not player:IsMinorCiv() and player:HasTech(tech) then
				log:Info("DiploVictoryUnlocked")
				MapModData.VEM.DiploVictoryUnlocked = true
				return
			end
		end
	end
end
LuaEvents.ActivePlayerTurnStart_Turn.Add(CheckDiploVictoryUnlocked)

DoFlavorFunction = {
	FLAVOR_DIPLOMACY			= PurchaseInfluence,
	FLAVOR_OFFENSE				= PurchaseUnitOfFlavor,
	FLAVOR_DEFENSE				= PurchaseUnitOfFlavor,
	FLAVOR_RECON				= PurchaseUnitOfFlavor,
	FLAVOR_RANGED				= PurchaseUnitOfFlavor,
	FLAVOR_MOBILE				= PurchaseUnitOfFlavor,
	FLAVOR_NAVAL				= PurchaseUnitOfFlavor,
	FLAVOR_AIR					= PurchaseUnitOfFlavor,
	FLAVOR_EXPANSION			= PurchaseUnitOfFlavor,
	FLAVOR_TILE_IMPROVEMENT		= PurchaseUnitOfFlavor,
	FLAVOR_GREAT_PEOPLE			= PurchaseBuildingOfFlavor,
	FLAVOR_CITY_DEFENSE			= PurchaseBuildingOfFlavor,
	FLAVOR_MILITARY_TRAINING	= PurchaseBuildingOfFlavor,
	FLAVOR_GROWTH				= PurchaseBuildingOfFlavor,
	FLAVOR_PRODUCTION			= PurchaseBuildingOfFlavor,
	FLAVOR_GOLD					= PurchaseBuildingOfFlavor,
	FLAVOR_SCIENCE				= PurchaseBuildingOfFlavor,
	FLAVOR_CULTURE				= PurchaseBuildingOfFlavor,
	FLAVOR_HAPPINESS			= PurchaseBuildingOfFlavor,
	FLAVOR_GREAT_PEOPLE			= PurchaseBuildingOfFlavor,
	FLAVOR_RELIGION				= PurchaseBuildingOfFlavor
}

if Civup.USING_CSD == 1 then
	DoFlavorFunction.FLAVOR_DIPLOMACY = PurchaseUnitOfFlavor
end





--
-- Start Bonuses
--

function PlayerStartBonuses(player)
	--print("PlayerStartBonuses "..player:GetName())
	local activePlayer	= Players[Game.GetActivePlayer()]
	local worldInfo		= GameInfo.Worlds[Map.GetWorldSize()]
	local speedInfo		= GameInfo.GameSpeeds[Game.GetGameSpeedType()]
	local handicapInfo	= GameInfo.HandicapInfos[Game.GetAverageHumanHandicap()]
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local handicapID	= 1 + handicapInfo.ID
	local trait			= player:GetTraitInfo()
	local teamID		= player:GetTeam()
	local capitalCity	= player:GetCapitalCity()
	local startPlot		= capitalCity and capitalCity:Plot()
	local isCoastal		= false	
	local settlerID		= player:GetUniqueUnitID("UNITCLASS_SETTLER")
	local warriorID		= player:GetUniqueUnitID("UNITCLASS_WARRIOR")
	
	if trait.NoWarrior then
		for unit in player:Units() do
			if unit:GetUnitType() == warriorID then
				unit:Kill()
				break
			end
		end
	end
	if not startPlot then
		for unit in player:Units() do
			if unit:GetUnitType() == settlerID then
				startPlot = unit:GetPlot()
				if player:IsHuman() then-- and trait.NoWarrior and trait.FreeUnit == "UNITCLASS_WORKER" then
					for _, adjPlot in pairs(Plot_GetPlotsInCircle(startPlot, 2, 3)) do
						adjPlot:SetRevealed(teamID, true)
					end
					UI.SelectUnit(unit)
				end
				break
			end
		end
	end	
	if not startPlot then
		log:Warn("PlayerStartBonuses: %s has no capital or settler!", player:GetName())
		return
	end
	
	--log:Info("PlayerStartBonuses %s", player:GetName())

	local oceanPlot	= Plot_GetNearestOceanPlot(startPlot, worldInfo.AICapitalRevealRadius, 0.1 * Map.GetNumPlots())
	if not oceanPlot then
		oceanPlot	= Plot_GetNearestOceanPlot(startPlot, worldInfo.AICapitalRevealRadius)
	end
	if oceanPlot then
		isCoastal	= (Plot_GetAreaWeights(startPlot, 1, 8).SEA >= 0.5)
	end
	
	if trait.FreeShip and oceanPlot then
		player:InitUnitClass(trait.FreeShip, oceanPlot)
	end
	
	--
	-- AI Bonuses
	--
	
	if player:IsMinorCiv() or player:IsHuman() then
		return
	end
	
	local modMilitaristic	= player:IsMilitaristicLeader() and 1 or 0.5
	local numUnits			= 0.25 * handicapID * modMilitaristic * speedInfo.TrainPercent/100
	local handicapYields	= {	YieldTypes.YIELD_GOLD,
								YieldTypes.YIELD_SCIENCE,
								YieldTypes.YIELD_CULTURE }
	
	--Plot_ChangeYield(startPlot, YieldTypes.YIELD_GOLD, modMilitaristic * handicapID)
	
	if isCoastal then
		for i=1, Game.Round(numUnits/2) do
			player:InitUnitClass("UNITCLASS_TRIREME", oceanPlot)
			player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
			--player:InitUnitClass("UNITCLASS_WORKER", startPlot)
		end
	else
		for i=1, Game.Round(numUnits) do
			player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
			--player:InitUnitClass("UNITCLASS_WORKER", startPlot)
		end
	end

	if leaderInfo.AIBonus then
		--player:InitUnitClass("UNITCLASS_WARRIOR", startPlot)
	end

	if leaderInfo.Type == "LEADER_GENGHIS_KHAN" then
		startPlot:SetResourceType(GameInfo.Resources.RESOURCE_HORSE.ID, 1)
		player:SetHasTech(GameInfo.Technologies.TECH_ANIMAL_HUSBANDRY.ID, true)
	end
	
	for _, adjPlot in pairs(Plot_GetPlotsInCircle(startPlot, 2, worldInfo.AICapitalRevealRadius)) do
		adjPlot:SetRevealed(teamID, true)
		local improvementID = adjPlot:GetImprovementType()
		if improvementID ~= -1 and not adjPlot:IsVisible(Game.GetActiveTeam()) then
			for impInfo in GameInfo.Improvements(string.format("Goody = 1 AND TilesPerGoody > 0")) do
				if improvementID == impInfo.ID then
					adjPlot:SetImprovementType(-1)
					--[[
					for _, yieldType in pairs(handicapYields) do
						player:ChangeYieldStored(yieldType, 10)
					end
					--]]
					break
				end
			end
		end
	end
	--print("PlayerStartBonuses "..player:GetName().." Done")
end

function CitystateStartBonuses(player)
	--print("CitystateStartBonuses "..player:GetName())
	local activePlayer	= Players[Game.GetActivePlayer()]
	local worldInfo		= GameInfo.Worlds[Map.GetWorldSize()]
	local speedInfo		= GameInfo.GameSpeeds[Game.GetGameSpeedType()]
	local handicapInfo	= GameInfo.HandicapInfos[Game.GetAverageHumanHandicap()]
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local handicapID	= 1 + handicapInfo.ID
	local capitalCity	= player:GetCapitalCity()
	local startPlot		= capitalCity and capitalCity:Plot()
	local isCoastal		= false	
	local settlerID		= player:GetUniqueUnitID("UNITCLASS_SETTLER")
	
	if not startPlot then
		for unit in player:Units() do
			if unit:GetUnitType() == settlerID then
				startPlot = unit:GetPlot()
				break
			end
		end
	end	
	if not startPlot then
		log:Warn("CitystateStartBonuses: %s has no capital or settler!", player:GetName())
		return
	end
	
	--log:Info("CitystateStartBonuses %s", player:GetName())

	local oceanPlot	= Plot_GetNearestOceanPlot(startPlot, worldInfo.AICapitalRevealRadius, 0.1 * Map.GetNumPlots())
	if not oceanPlot then
		oceanPlot	= Plot_GetNearestOceanPlot(startPlot, worldInfo.AICapitalRevealRadius)
	end
	if oceanPlot then
		isCoastal	= (Plot_GetAreaWeights(startPlot, 1, 8).SEA >= 0.5)
	end

	if handicapID >= 2 then -- Chieftain
		Plot_ChangeYield(startPlot, YieldTypes.YIELD_GOLD, 2)
		player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
		if isCoastal then
			player:InitUnitClass("UNITCLASS_TRIREME", oceanPlot)
			player:InitUnitClass("UNITCLASS_WARRIOR", startPlot)
		else
			player:InitUnitClass("UNITCLASS_WARRIOR", startPlot)
			player:InitUnitClass("UNITCLASS_WARRIOR", startPlot)
		end
	end
	
	if handicapID >= 7 then -- immortal
		if isCoastal then
			player:InitUnitClass("UNITCLASS_TRIREME", oceanPlot)
		else
			player:InitUnitClass("UNITCLASS_WARRIOR", startPlot)
		end
	end
	if handicapID >= 8 then -- deity
		player:InitUnitClass("UNITCLASS_SPEARMAN", startPlot)
	end
	--print("CitystateStartBonuses "..player:GetName().." Done")
end

function CheckPlayerStartBonuses()
	if UI:IsLoadedGame() then
		return
	end
	print("CheckPlayerStartBonuses")
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() then
			PlayerStartBonuses(player)
		end
	end
	print("CheckPlayerStartBonuses Done")
end
Events.SequenceGameInitComplete.Add(CheckPlayerStartBonuses)

function CheckCitystateStartBonuses(player)
	if player:IsMinorCiv() and Game.GetGameTurn() == Game.GetAdjustedTurn(10) then
		log:Info("CheckCitystateStartBonuses %s", player:GetName())
		CitystateStartBonuses(player)
	end
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(CheckCitystateStartBonuses)

function AIPerTurnBonuses(player)
	local capitalCity = player:GetCapitalCity()
	if capitalCity == nil or player:IsMinorCiv() or player:IsHuman() then
		return
	end
	--log:Info("%-25s %15s", "AIPerTurnBonuses", player:GetName())
	local activePlayer		= Players[Game.GetActivePlayer()]
	local handicapInfo		= GameInfo.HandicapInfos[activePlayer:GetHandicapType()]
	local yieldStored		= player:GetYieldStored(YieldTypes.YIELD_SCIENCE)
	local yieldRate			= player:GetYieldRate(YieldTypes.YIELD_SCIENCE)
	local yieldMod			= handicapInfo.AIResearchPercent/100
	local yieldModPerEra	= handicapInfo.AIResearchPercentPerEra/100 * Game.GetAverageHumanEra()
	player:ChangeYieldStored(YieldTypes.YIELD_SCIENCE, Game.Round(yieldRate * (yieldMod + yieldModPerEra)))
	--[[
	--log:Debug(Sci bonus for %-25s: %5s + %4s * (%4s + %-4s) = %5s (+%s),
		player:GetName(),
		yieldStored,
		yieldRate,
		Game.Round(yieldMod, 2),
		Game.Round(yieldModPerEra, 2),
		player:GetYieldStored(YieldTypes.YIELD_SCIENCE),
		Game.Round(yieldRate * (yieldMod + yieldModPerEra))
	)
	--]]
end

LuaEvents.ActivePlayerTurnEnd_Player.Add(AIPerTurnBonuses)


--
-- AI military bonuses
--

function AIMilitaryHandicap(  playerID,
								unitID,
								hexVec,
								unitType,
								cultureType,
								civID,
								primaryColor,
								secondaryColor,
								unitFlagIndex,
								fogState,
								selected,
								military,
								notInvisible )
	local player = Players[playerID]
	local activePlayer = Players[Game.GetActivePlayer()]
    if not player:IsAliveCiv() or player:IsHuman() then
		return
	end

	local unit = player:GetUnitByID( unitID )
	if unit == nil or unit:IsDead() then
        return
    end

	if military then
		local hostileMultiplier = 1
		if player:IsMinorCiv() then
			hostileMultiplier = 0.5
		elseif not player:IsMilitaristicLeader() then
			if player:IsAtWarWithHuman() then
				hostileMultiplier = 1
			elseif player:EverAtWarWithHuman() then
				hostileMultiplier = 0.5
			else
				hostileMultiplier = 0
			end
		end
		local freeXP = hostileMultiplier * GameInfo.HandicapInfos[Game.GetAverageHumanHandicap()].AIFreeXP
		local freeXPPerEra = hostileMultiplier * GameInfo.HandicapInfos[Game.GetAverageHumanHandicap()].AIFreeXPPerEra
		if freeXP > 0 or freeXPPerEra > 0 then
			local era = 1 + Game.GetAverageHumanEra()
			--log:Warn(player:GetName().. " " ..unit:GetName().. " " ..freeXP.. " + " ..freeXPPerEra.. "*" ..Game.GetAverageHumanHandicap().. " xp")
			unit:ChangeExperience(freeXP + freeXPPerEra * era)
		end
	end

	local handicapInfo = GameInfo.HandicapInfos[Players[Game.GetActivePlayer()]:GetHandicapType()]
	local freePromotion = handicapInfo.AIFreePromotion

	if freePromotion then
		unit:SetHasPromotion(GameInfo.UnitPromotions[freePromotion].ID, true)
	end

	if (1 + handicapInfo.ID) >= 5 then -- king
		--[[ The AI is not good at using siege units
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_CITY_PENALTY.ID, false)
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_SMALL_CITY_PENALTY.ID, false)
		--]]
	end

	if player:IsMinorCiv() then
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_FREE_UPGRADES.ID, true)
	end
	
	local capital = player:GetCapitalCity()
	if capital and Game.GetGameTurn() < 50 then
		local plot = capital:Plot()
		if plot:IsCoastalLand() and Plot_GetAreaWeights(plot, 1, 8).SEA >= 0.5 then
			unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_EMBARKATION.ID, true)
		end
	end
end
LuaEvents.NewUnit.Add( AIMilitaryHandicap )





--
-- War Handicap
--

function WarHandicap(humanPlayerID, aiPlayerID, isAtWar)
	local humanPlayer = Players[humanPlayerID]
	local aiPlayer = Players[aiPlayerID]
	if (not humanPlayer:IsHuman() 
		or aiPlayer:IsHuman()
		or (MapModData.VEM.EverAtWarWithHuman[aiPlayerID] ~= 1)
		or aiPlayer:IsMilitaristicLeader()
		) then
		return
	end
	log:Warn("War State %s %s %s", humanPlayer:GetName(), aiPlayer:GetName(), isAtWar and "War" or "Peace")
	MapModData.VEM.EverAtWarWithHuman[aiPlayerID] = 1
	SaveValue(1, "MapModData.VEM.EverAtWarWithHuman[%s]", aiPlayerID)
	
	local freeXP = GameInfo.HandicapInfos[Game.GetAverageHumanHandicap()].AIFreeXP
	local freeXPPerEra = GameInfo.HandicapInfos[Game.GetAverageHumanHandicap()].AIFreeXPPerEra
	local era = 1 + Game.GetAverageHumanEra()
	if freeXP > 0 or freeXPPerEra > 0 then
		for unit in aiPlayer:Units() do
			unit:ChangeExperience(freeXP + freeXPPerEra * era)
			log:Info("%-15s %s %20s warXP = %s + %s * %s", aiPlayer:GetName(), unit:GetName(), freeXP, freeXPPerEra, era)
		end
	end
end
Events.WarStateChanged.Add(WarHandicap)



if not MapModData.VEM.EverAtWarWithHuman then
	MapModData.VEM.EverAtWarWithHuman = {}
	startClockTime = os.clock()
	if UI:IsLoadedGame() then
		for playerID, player in pairs(Players) do
			MapModData.VEM.EverAtWarWithHuman[playerID] = LoadValue("MapModData.VEM.EverAtWarWithHuman[%s]", playerID)
		end
	end
	if UI:IsLoadedGame() then
		log:Warn("%-10s seconds loading EverAtWarWithHuman", Game.Round(os.clock() - startClockTime, 8))
	end
end





--
-- Manually place Moai Statues
--

function PlaceMoai(player)
	if player:IsHuman() or not (player:GetTraitInfo().CombatBonusImprovement == "IMPROVEMENT_MOAI") then
		return
	end
	if not player:HasTech(GameInfo.Builds.BUILD_MOAI.PrereqTech) then
		return
	end
	log:Info("PlaceMoai %s", player:GetName())

	--[[
	local cities = {}
	for city in player:Cities() do
		if not city:IsResistance() and not city:IsRazing() then
			table.insert(cities, {id=City_GetID(city), pop=city:GetPopulation()})
		end
	end
	table.sort(cities, function(a, b) return a.pop > b.pop end)

	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)		
	--]]

	local playerID = player:GetID()
	local moaiID = GameInfo.Improvements.IMPROVEMENT_MOAI.ID
	for city in player:Cities() do
		for i = 0, city:GetNumCityPlots() - 1, 1 do
			local plot = city:GetCityIndexPlot(i);
			if plot then
				local featureID = plot:GetFeatureType()
				if (plot:GetOwner() == playerID
					and plot:GetImprovementType() ~= moaiID
					and plot:GetResourceType() == -1
					and plot:IsCoastalLand()
					and (featureID == -1
						or featureID == FeatureTypes.FEATURE_JUNGLE
						or featureID == FeatureTypes.FEATURE_FOREST
						or featureID == FeatureTypes.FEATURE_MARSH)
					and not plot:IsCity()
					and not plot:IsVisibleToWatchingHuman()
					) then
					log:Info("Placed moai for %s", player:GetName())
					plot:SetImprovementType(moaiID)
					if plot:GetFeatureType() ~= -1 then
						plot:SetFeatureType(FeatureTypes.NO_FEATURE, -1)
					end
					break
				end
			end
		end
	end
end

if GameInfo.Builds.BUILD_MOAI then
	LuaEvents.ActivePlayerTurnEnd_Player.Add(PlaceMoai)
end