-- VED_General
-- Author: Thalassicus
-- DateCreated: 4/15/2012 10:15:07 PM
--------------------------------------------------------------

include("ModTools")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

function ResetCsFriendships(lostPlayerID)
	lostPlayer = Players[lostPlayerID]
	if lostPlayer:IsAlive() or lostPlayer:IsMinorCiv() then
		return
	end
	log:Info("Reset %s friendship with minor civs", lostPlayer:GetName())
	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv:IsMinorCiv() and minorCiv:GetMinorCivFriendshipWithMajor(lostPlayerID) ~= 0 then
			log:Info("  %s", minorCiv:GetName())
			minorCiv:SetFriendship(lostPlayerID, 0)
		end
	end
end

-- The player may have opted for "complete kills"
function OnUnitKilledInCombat(wonPlayerID, lostPlayerID)
	ResetCsFriendships(lostPlayerID)
end
GameEvents.UnitKilledInCombat.Add(OnUnitKilledInCombat) 

function OnCityCaptureComplete(lostPlayerID, isCapital, x, y, wonPlayerID)
	ResetCsFriendships(lostPlayerID)
end
GameEvents.CityCaptureComplete.Add(OnCityCaptureComplete)



--
-- Conquerors vs citystates
--

function DeclareWarNearestCitystate(player)
	local turn = Game.GetGameTurn()
	if (Game.GetAdjustedTurn() <= 50
		or turn % 7 ~= 0
		or player:IsHuman()
		or player:IsMinorCiv()
		or player:GetPersonalityInfo().Type ~= "PERSONALITY_CONQUEROR"
		--or player:IsAtWarWithAny()
		) then
		return
	end
	local capital = player:GetCapitalCity()
	if not capital then
		log:Warn("DeclareWarNearestCitystate: %s has no capital", player:GetName())
		return
	end
	log:Info("DeclareWarNearestCitystate %-20s %s", player:GetName(), player:GetPersonalityInfo().Type)
	local teamID			= player:GetTeam()
	local team				= Teams[teamID]
	local closestMinorID	= nil
	local closestMinor		= nil
	local closestDistance	= math.huge
	local usPlot			= capital:Plot()
	local startX			= capital:Plot():GetX()
	local startY			= capital:Plot():GetY()
	local iW, iH			= Map.GetGridSize()

	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv and minorCiv:IsMinorCiv() and minorCiv:IsAlive() and (minorCiv:GetAlly() == -1 or player:IsAtWar(minorCiv)) then
			local minorCapital = minorCiv:GetCapitalCity()
			if minorCapital then
				if team:IsPermanentWarPeace(minorCiv:GetTeam()) then 
					return
				end
				local themPlot = minorCapital:Plot()
				local distance = Map.PlotDistance(startX, startY, themPlot:GetX(), themPlot:GetY())
				if (distance < closestDistance) and (distance < 0.25 * iW) and (usPlot:Area() == themPlot:Area()) then
					closestMinor = minorCiv
					closestDistance = distance
					log:Info("  %-15s distance = %s", closestMinor:GetName(), distance)
				end
			end
		end
	end
	if not closestMinor then
		for minorCivID, minorCiv in pairs(Players) do
			if minorCiv and minorCiv:IsMinorCiv() and minorCiv:IsAlive() and (minorCiv:GetAlly() == -1 or player:IsAtWar(minorCiv)) then
				local minorCapital = minorCiv:GetCapitalCity()
				if minorCapital then
					if team:IsPermanentWarPeace(minorCiv:GetTeam()) then 
						return
					end
					local themPlot = minorCapital:Plot()
					local distance = Map.PlotDistance(startX, startY, themPlot:GetX(), themPlot:GetY())
					if distance < closestDistance then
						closestMinor = minorCiv
						closestDistance = distance
						log:Info("  %-15s distance = %s", closestMinor:GetName(), distance)
					end
				end
			end
		end
	end
	if not closestMinor then
		return
	end
	
	local minorTeamID = closestMinor:GetTeam()

	team:SetPermanentWarPeace(minorTeamID, true)
	if not team:IsAtWar(minorTeamID) then
		team:DeclareWar(minorTeamID)
	end
	log:Info("%s declared permanent war on %s", player:GetName(), closestMinor:GetName())

	for _, adjPlot in pairs(Plot_GetPlotsInCircle(closestMinor:GetCapitalCity():Plot(), 0, 3)) do
		adjPlot:SetRevealed(teamID, true)
	end
	if Game.GetAdjustedTurn() <= 20 then
		for unit in closestMinor:Units() do
			local unitClass = GameInfo.Units[unit:GetUnitType()].Class
			if unitClass ~= "UNITCLASS_WARRIOR" then
				unit:Kill()
			end
		end
	end
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(DeclareWarNearestCitystate)
