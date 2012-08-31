
---------------------------------------------------------------------
-- Player_GetDeals(player)
--
function Player_GetDeals(player)
	local playerID = player:GetID()
	local deal = UI.GetScratchDeal()
	local dealList = {}
	for index, name in ipairs(TradeableItems) do
		dealList[index] = {}
		for playerID, player in pairs(Players) do
			dealList[index][playerID] = {}
		end
	}

    local numDeals = UI:GetNumCurrentDeals(playerID) --works only for active player?
    if numDeals > 0 then
	    for dealID = 0, numDeals - 1 do
			UI.LoadCurrentDeal(playerID, dealID)
			deal:ResetIterator()
			local itemType, duration, finalTurn, data1, data2, fromPlayerID = deal:GetNextItem()			
			while itemType do
				table.insert(dealList[itemType][fromPlayerID], {duration=duration, finalTurn=finalTurn, data1=data1, data2=data2, fromPlayerID=fromPlayerID})
				itemType, duration, finalTurn, data1, data2, fromPlayerID = deal:GetNextItem()
			end
		end
	end
	return dealList
	
	text = dealList[TradeableItems.TRADE_ITEM_OPEN_BORDERS][fromPlayerID][1].finalTurn - Game.GetGameTurn()
end