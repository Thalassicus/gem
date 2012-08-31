-- VET_Events
-- Author: Thalassicus
-- DateCreated: 3/20/2012 1:12:12 AM
--------------------------------------------------------------

include("CiVUP_Core.lua")
include("FLuaVector")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

function TestOceanRifts()
	if UI.IsLoadedGame() then
		return
	end
	print("TestOceanRifts")
	local iW, iH			= Map.GetGridSize();
	local weights			= {}
	local maxWeight			= 0
	local iMax				= math.max(iW, iH)
	local oceanPlots		= {}
	local numPlotsToScan	= 0
	local attempts			= 0
	for plotID, plot in Plots() do
		if (plot:GetPlotType() ~= PlotTypes.PLOT_OCEAN) and (plot:Area():GetNumTiles() > 15 ) then-- 0.05 * Map.GetNumPlots()) then
			weights[plotID] = 0
		else
			oceanPlots[plotID] = plot
			numPlotsToScan = numPlotsToScan + 1
		end
	end
	while numPlotsToScan > 0 and attempts < iMax do
		local newWeights = {}
		for plotID, plot in pairs(oceanPlots) do
			for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
				local id = Plot_GetID(adjPlot)
				if weights[id] then
					newWeights[plotID] = weights[id] + 1 --(newWeights[plotID] or 0) + weights[id]
					break
				end
			end
		end
		for plotID, weight in pairs(newWeights) do
			--log:Warn("%5s %5s = %5s", attempts, plotID, weight)
			oceanPlots[plotID] = nil
			weights[plotID] = weight
			numPlotsToScan = numPlotsToScan - 1
			if maxWeight < weight then
				maxWeight = weight
			end
		end
		attempts = attempts + 1
	end
	maxWeight = math.max(maxWeight, 1)
	for plotID, plot in Plots() do
		--local hex = ToHexFromGrid(Vector2(plot:GetX(), plot:GetY()))
		--local color = Vector4(math.random(), 0.0, 0.0, 1.0) --weights[plotID] / maxWeight
		--Events.SerialEventHexHighlight(hex, true, color);
	end
	
	local iW, iH = Map.GetGridSize();
	for y = iH - 1, 0, -1 do
		local string = ""
		for x = 0, iW - 1 do
			local plotID = y * iW + x
			if weights[plotID] then
				weight = weights[plotID]
				--weight = shadeMap[math.ceil(4 * weights[plotID] / maxWeight) + 1]
			else
				weight = "X"
			end
			string = string.format("%s %s", string, weight)
		end
		print("DEPTH: "..string)
	end
	print("TestOceanRifts Done")
end
--Events.SequenceGameInitComplete.Add(TestOceanRifts)

--[[
function RevealMap()
	local teamID = Players[Game.GetActivePlayer()]:GetTeam()
	for plotID, plot in Plots() do
		plot:SetRevealed(teamID, true)
	end	
end
Events.SequenceGameInitComplete.Add(RevealMap)

--]]


function UpdatePlotYields()
	print("UpdatePlotYields Start")
	--
	if UI:IsLoadedGame() then
		return
	end
	--]]
	for plotID, plot in Plots() do
		local terrainID		= plot:GetPlotType()
		local featureID		= plot:GetFeatureType()
		local resourceID	= plot:GetResourceType()

		if featureID ~= -1 then
			local query = string.format("FeatureType='%s' AND YieldType='YIELD_CULTURE'", GameInfo.Features[featureID].Type)
			--[[
			for featureInfo in GameInfo.Feature_YieldChanges(query) do
				log:Debug("%s culture = %s", GameInfo.Features[featureID].Type, featureInfo.Yield)
				Plot_SetYield(plot, YieldTypes.YIELD_CULTURE, featureInfo.Yield)
			end
			--]]
			if featureID == GameInfo.Features.FEATURE_OASIS.ID then
				local gold = 1
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1, 1)) do
					if Plot_IsFlatDesert(adjPlot) then
						gold = gold + 0.5
					end
				end
				Plot_ChangeYield(plot, YieldTypes.YIELD_GOLD, Game.Round(gold))
			end
		end

		if Plot_IsFlatDesert(plot) then
			if plot:IsFreshWater() then
				Plot_ChangeYield(plot, YieldTypes.YIELD_FOOD, 1)
			end
			if resourceID ~= -1 and not GameInfo.Resources[resourceID].TechReveal then
				Plot_ChangeYield(plot, YieldTypes.YIELD_GOLD, 1)
			end
		elseif terrainID == TerrainTypes.TERRAIN_SNOW and resourceID ~= -1 then
			if plot:IsHills() then
				Plot_ChangeYield(plot, YieldTypes.YIELD_PRODUCTION, 2)
			else
				Plot_ChangeYield(plot, YieldTypes.YIELD_GOLD, 2)
			end
		end
	end
	print("UpdatePlotYields Done")
end
Events.SequenceGameInitComplete.Add(UpdatePlotYields)

function DoResourceDiscovered(playerID, techID)
	local player = Players[playerID]
	local techInfo = GameInfo.Technologies[techID]
	--log:Debug("player=%s tech=%s", player:GetName(), techInfo.Type)
	for resourceInfo in GameInfo.Resources(string.format("TechReveal = '%s'", techInfo.Type)) do
		for plotID, plot in Plots() do
			if Plot_IsFlatDesert(plot) and plot:GetResourceType() == resourceInfo.ID and plot:GetOwner() == playerID then
				Plot_ChangeYield(plot, YieldTypes.YIELD_GOLD, 1)
			end
		end
	end
end
--Events.TechAcquired.Add(DoResourceDiscovered)

function CreateWorkboats(player, techID, changeID)
	local playerID = player:GetID()
	if player:IsHuman() then
		return
	end
	local techType = GameInfo.Technologies[techID].Type
	for buildInfo in GameInfo.Builds(string.format("ImprovementType IS NOT NULL AND PrereqTech = '%s'", techType)) do
		local improveInfo = GameInfo.Improvements[buildInfo.ImprovementType]
		if improveInfo.Water then
			log:Info("Checking for workboats %s %s %s", player:GetName(), techType, improveInfo.Type)
			for city in player:Cities() do
				if city:IsCoastal() then
					for _, plot in pairs(Plot_GetPlotsInCircle(city:Plot(), 1, 3)) do
						local resInfo = GameInfo.Resources[plot:GetResourceType()]
						if resInfo and plot:GetPlotType() == PlotTypes.PLOT_OCEAN and plot:GetImprovementType() == -1 then
							if Game.HasValue( {ImprovementType=improveInfo.Type, ResourceType=resInfo.Type}, GameInfo.Improvement_ResourceTypes ) then
								log:Info("  %s spawned for %s", city:GetName(), resInfo.Type)
								player:InitUnitClass("UNITCLASS_WORKBOAT", city:Plot())
							end
						end
					end
				end
			end
		end
	end
end
LuaEvents.NewTech.Add(CreateWorkboats)

---------------------------------------------------------------------
---------------------------------------------------------------------

function FloodplainCity(hexPos, playerID, cityID, newPlayerID)
	local plot = Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	if plot:GetTerrainType() == TerrainTypes.TERRAIN_DESERT and plot:IsRiver() then
		plot:SetFeatureType(FeatureTypes.FEATURE_FLOOD_PLAINS, -1)
	end
end
LuaEvents.NewCity.Add(FloodplainCity)

---------------------------------------------------------------------
---------------------------------------------------------------------

function GreatImprovementEraBonus(hexX, hexY, cultureArtID, continentArtID, playerID, engineImprovementTypeDoNotUse, improvementID, engineResourceTypeDoNotUse, resourceID, eraID, improvementState)
	--print("OnImprovementCreated");
	--print("hexX: " .. hexX);
	--print("hexY: " .. hexY);
	--print("cultureArtID: " .. cultureArtID);
	--print("playerID: " .. playerID);
	--print("improvementID: " .. improvementID);
	--print("resourceID: " .. resourceID);
	--print("eraID: " .. eraID);
	--print("improvementState: " .. improvementState);
	--print("------------------");

	local impInfo	= GameInfo.Improvements[improvementID]
	local player	= Players[playerID]
	local plot		= Map.GetPlot(ToGridFromHex(hexX, hexY))
	if not impInfo.CreatedByGreatPerson or eraID == 0 then
		return
	end

	for yieldInfo in GameInfo.Yields() do
		local extraYield = GetImprovementExtraYield(impInfo.ID, yieldInfo.ID, player)

		if extraYield > 0 then
			log:Info("%s + %s %s", impInfo.Type, extraYield, yieldInfo.Type)
			Plot_ChangeYield(plot, yieldInfo.ID, extraYield)
		end
	end
end
--Events.SerialEventImprovementCreated.Add(GreatImprovementEraBonus)