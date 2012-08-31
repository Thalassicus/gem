--

-- 
-- Strength
-- 

UPDATE Units SET       Combat =       Combat * 1.067  WHERE Class = 'UNITCLASS_MECH';
UPDATE Units SET RangedCombat = RangedCombat * 1      WHERE Class = 'UNITCLASS_GUIDED_MISSILE';
UPDATE Units SET RangedCombat = RangedCombat * 0.82   WHERE Class = 'UNITCLASS_STEALTH_BOMBER';
UPDATE Units SET RangedCombat = RangedCombat * 0.93   WHERE Class = 'UNITCLASS_JET_FIGHTER';
UPDATE Units SET       Combat =       Combat * 1.2    WHERE Class = 'UNITCLASS_MODERN_ARMOR';
UPDATE Units SET       Combat =       Combat * 0.778  WHERE Class = 'UNITCLASS_MECHANIZED_INFANTRY';
UPDATE Units SET       Combat =       Combat * 1      WHERE Class = 'UNITCLASS_HELICOPTER_GUNSHIP';
UPDATE Units SET       Combat =       Combat * 0.923  WHERE Class = 'UNITCLASS_MOBILE_SAM';
UPDATE Units SET       Combat =       Combat * 1.333  WHERE Class = 'UNITCLASS_ROCKET_ARTILLERY';
UPDATE Units SET RangedCombat = RangedCombat * 1.33   WHERE Class = 'UNITCLASS_ROCKET_ARTILLERY';
UPDATE Units SET RangedCombat = RangedCombat * 0.77   WHERE Class = 'UNITCLASS_BOMBER';
UPDATE Units SET RangedCombat = RangedCombat * 1.11   WHERE Class = 'UNITCLASS_FIGHTER';
UPDATE Units SET       Combat =       Combat * 1.143  WHERE Class = 'UNITCLASS_TANK';
UPDATE Units SET       Combat =       Combat * 0.923  WHERE Class = 'UNITCLASS_MARINE';
UPDATE Units SET       Combat =       Combat * 0.615  WHERE Class = 'UNITCLASS_PARATROOPER';
UPDATE Units SET       Combat =       Combat * 0.714  WHERE Class = 'UNITCLASS_INFANTRY';
UPDATE Units SET       Combat =       Combat * 1      WHERE Class = 'UNITCLASS_MACHINE_GUN';
UPDATE Units SET RangedCombat = RangedCombat * 0.67   WHERE Class = 'UNITCLASS_MACHINE_GUN';
UPDATE Units SET       Combat =       Combat * 0.8    WHERE Class = 'UNITCLASS_ANTI_TANK_GUN';
UPDATE Units SET       Combat =       Combat * 0.8    WHERE Class = 'UNITCLASS_ANTI_AIRCRAFT_GUN';
UPDATE Units SET RangedCombat = RangedCombat * 0.8    WHERE Class = 'UNITCLASS_WWI_BOMBER';
UPDATE Units SET RangedCombat = RangedCombat * 1.14   WHERE Class = 'UNITCLASS_TRIPLANE';
UPDATE Units SET       Combat =       Combat * 0.917  WHERE Class = 'UNITCLASS_WWI_TANK';
UPDATE Units SET       Combat =       Combat * 0.8    WHERE Class = 'UNITCLASS_GREAT_WAR_INFANTRY';
UPDATE Units SET       Combat =       Combat * 1.607  WHERE Class = 'UNITCLASS_ARTILLERY';
UPDATE Units SET RangedCombat = RangedCombat * 1.61   WHERE Class = 'UNITCLASS_ARTILLERY';
UPDATE Units SET       Combat =       Combat * 1.111  WHERE Class = 'UNITCLASS_GATLINGGUN';
UPDATE Units SET RangedCombat = RangedCombat * 0.56   WHERE Class = 'UNITCLASS_GATLINGGUN';
UPDATE Units SET       Combat =       Combat * 1.029  WHERE Class = 'UNITCLASS_CAVALRY';
UPDATE Units SET       Combat =       Combat * 0.882  WHERE Class = 'UNITCLASS_RIFLEMAN';
UPDATE Units SET       Combat =       Combat * 1.2    WHERE Class = 'UNITCLASS_LANCER';
UPDATE Units SET       Combat =       Combat * 1.768  WHERE Class = 'UNITCLASS_CANNON';
UPDATE Units SET RangedCombat = RangedCombat * 1.65   WHERE Class = 'UNITCLASS_CANNON';
UPDATE Units SET       Combat =       Combat * 1.15   WHERE Class = 'UNITCLASS_KNIGHT';
UPDATE Units SET       Combat =       Combat * 1.095  WHERE Class = 'UNITCLASS_LONGSWORDSMAN';
UPDATE Units SET       Combat =       Combat * 0.917  WHERE Class = 'UNITCLASS_MUSKETMAN';
UPDATE Units SET       Combat =       Combat * 1      WHERE Class = 'UNITCLASS_CROSSBOWMAN';
UPDATE Units SET RangedCombat = RangedCombat * 1      WHERE Class = 'UNITCLASS_CROSSBOWMAN';
UPDATE Units SET       Combat =       Combat * 1.313  WHERE Class = 'UNITCLASS_TREBUCHET';
UPDATE Units SET RangedCombat = RangedCombat * 1.5    WHERE Class = 'UNITCLASS_TREBUCHET';
UPDATE Units SET       Combat =       Combat * 0.938  WHERE Class = 'UNITCLASS_PIKEMAN';
UPDATE Units SET       Combat =       Combat * 1.25   WHERE Class = 'UNITCLASS_HORSEMAN';
UPDATE Units SET       Combat =       Combat * 1.071  WHERE Class = 'UNITCLASS_SWORDSMAN';
UPDATE Units SET       Combat =       Combat * 1      WHERE Class = 'UNITCLASS_COMPOSITE_BOWMAN';
UPDATE Units SET RangedCombat = RangedCombat * 1.09   WHERE Class = 'UNITCLASS_COMPOSITE_BOWMAN';
UPDATE Units SET       Combat =       Combat * 1.607  WHERE Class = 'UNITCLASS_CATAPULT';
UPDATE Units SET RangedCombat = RangedCombat * 1.88   WHERE Class = 'UNITCLASS_CATAPULT';
UPDATE Units SET       Combat =       Combat * 0.833  WHERE Class = 'UNITCLASS_CHARIOT_ARCHER';
UPDATE Units SET RangedCombat = RangedCombat * 0.8    WHERE Class = 'UNITCLASS_CHARIOT_ARCHER';
UPDATE Units SET       Combat =       Combat * 0.909  WHERE Class = 'UNITCLASS_SPEARMAN';
UPDATE Units SET       Combat =       Combat * 1      WHERE Class = 'UNITCLASS_WARRIOR';
UPDATE Units SET       Combat =       Combat * 1      WHERE Class = 'UNITCLASS_ARCHER';
UPDATE Units SET RangedCombat = RangedCombat * 1.14   WHERE Class = 'UNITCLASS_ARCHER';
UPDATE Units SET       Combat =       Combat * 1.2    WHERE Class = 'UNITCLASS_SCOUT';

UPDATE Units SET RangedCombat = ROUND( RangedCombat, 0) WHERE RangedCombat <> 0;
UPDATE Units SET       Combat = ROUND(       Combat, 0) WHERE       Combat <> 0;

UPDATE Units
SET CombatClass = 'UNITCOMBAT_GUN'
WHERE Class IN (
	'UNITCLASS_GATLINGGUN',
	'UNITCLASS_MACHINE_GUN'
);

--
-- Cost
--

UPDATE Units SET Cost = Cost * 1.307  WHERE Class = 'UNITCLASS_MECH';
UPDATE Units SET Cost = Cost * 0.926  WHERE Class = 'UNITCLASS_GUIDED_MISSILE';
UPDATE Units SET Cost = Cost * 1.144  WHERE Class = 'UNITCLASS_STEALTH_BOMBER';
UPDATE Units SET Cost = Cost * 1.144  WHERE Class = 'UNITCLASS_JET_FIGHTER';
UPDATE Units SET Cost = Cost * 1.307  WHERE Class = 'UNITCLASS_MODERN_ARMOR';
UPDATE Units SET Cost = Cost * 1.037  WHERE Class = 'UNITCLASS_MECHANIZED_INFANTRY';
UPDATE Units SET Cost = Cost * 0.784  WHERE Class = 'UNITCLASS_HELICOPTER_GUNSHIP';
UPDATE Units SET Cost = Cost * 0.784  WHERE Class = 'UNITCLASS_MOBILE_SAM';
UPDATE Units SET Cost = Cost * 1.046  WHERE Class = 'UNITCLASS_ROCKET_ARTILLERY';
UPDATE Units SET Cost = Cost * 0.926  WHERE Class = 'UNITCLASS_BOMBER';
UPDATE Units SET Cost = Cost * 0.926  WHERE Class = 'UNITCLASS_FIGHTER';
UPDATE Units SET Cost = Cost * 1.185  WHERE Class = 'UNITCLASS_TANK';
UPDATE Units SET Cost = Cost * 0.833  WHERE Class = 'UNITCLASS_MARINE';
UPDATE Units SET Cost = Cost * 0.63   WHERE Class = 'UNITCLASS_PARATROOPER';
UPDATE Units SET Cost = Cost * 0.741  WHERE Class = 'UNITCLASS_INFANTRY';
UPDATE Units SET Cost = Cost * 0.794  WHERE Class = 'UNITCLASS_MACHINE_GUN';
UPDATE Units SET Cost = Cost * 0.741  WHERE Class = 'UNITCLASS_ANTI_TANK_GUN';
UPDATE Units SET Cost = Cost * 0.741  WHERE Class = 'UNITCLASS_ANTI_AIRCRAFT_GUN';
UPDATE Units SET Cost = Cost * 0.855  WHERE Class = 'UNITCLASS_WWI_BOMBER';
UPDATE Units SET Cost = Cost * 0.855  WHERE Class = 'UNITCLASS_TRIPLANE';
UPDATE Units SET Cost = Cost * 0.794  WHERE Class = 'UNITCLASS_WWI_TANK';
UPDATE Units SET Cost = Cost * 0.694  WHERE Class = 'UNITCLASS_GREAT_WAR_INFANTRY';
UPDATE Units SET Cost = Cost * 1      WHERE Class = 'UNITCLASS_ARTILLERY';
UPDATE Units SET Cost = Cost * 0.741  WHERE Class = 'UNITCLASS_GATLINGGUN';
UPDATE Units SET Cost = Cost * 0.864  WHERE Class = 'UNITCLASS_CAVALRY';
UPDATE Units SET Cost = Cost * 0.741  WHERE Class = 'UNITCLASS_RIFLEMAN';
UPDATE Units SET Cost = Cost * 0.901  WHERE Class = 'UNITCLASS_LANCER';
UPDATE Units SET Cost = Cost * 0.991  WHERE Class = 'UNITCLASS_CANNON';
UPDATE Units SET Cost = Cost * 1.065  WHERE Class = 'UNITCLASS_KNIGHT';
UPDATE Units SET Cost = Cost * 1.065  WHERE Class = 'UNITCLASS_LONGSWORDSMAN';
UPDATE Units SET Cost = Cost * 0.815  WHERE Class = 'UNITCLASS_MUSKETMAN';
UPDATE Units SET Cost = Cost * 0.833  WHERE Class = 'UNITCLASS_CROSSBOWMAN';
UPDATE Units SET Cost = Cost * 0.972  WHERE Class = 'UNITCLASS_TREBUCHET';
UPDATE Units SET Cost = Cost * 0.926  WHERE Class = 'UNITCLASS_PIKEMAN';
UPDATE Units SET Cost = Cost * 1.111  WHERE Class = 'UNITCLASS_HORSEMAN';
UPDATE Units SET Cost = Cost * 1.111  WHERE Class = 'UNITCLASS_SWORDSMAN';
UPDATE Units SET Cost = Cost * 0.889  WHERE Class = 'UNITCLASS_COMPOSITE_BOWMAN';
UPDATE Units SET Cost = Cost * 1.111  WHERE Class = 'UNITCLASS_CATAPULT';
UPDATE Units SET Cost = Cost * 0.794  WHERE Class = 'UNITCLASS_CHARIOT_ARCHER';
UPDATE Units SET Cost = Cost * 0.992  WHERE Class = 'UNITCLASS_SPEARMAN';
UPDATE Units SET Cost = Cost * 1.111  WHERE Class = 'UNITCLASS_WARRIOR';
UPDATE Units SET Cost = Cost * 1.111  WHERE Class = 'UNITCLASS_ARCHER';
UPDATE Units SET Cost = Cost * 1.333  WHERE Class = 'UNITCLASS_SCOUT';

UPDATE Units SET Cost = ROUND((Cost * 1.8) / 10, 0) * 10 WHERE Cost > 0;

--
-- Resources
--

DELETE FROM Unit_ResourceQuantityRequirements
WHERE UnitType IN (
	'UNIT_HELICOPTER_GUNSHIP',
	'UNIT_CATAPULT',
	'UNIT_ROMAN_BALLISTA',
	'UNIT_TREBUCHET',
	'UNIT_ROCKET_ARTILLERY'
);

UPDATE Unit_ResourceQuantityRequirements
SET ResourceType = 'RESOURCE_ALUMINUM'
WHERE UnitType IN (
	'UNIT_TRIPLANE',
	'UNIT_WWI_BOMBER',
	'UNIT_BOMBER',
	'UNIT_AMERICAN_B17',
	'UNIT_FIGHTER',
	'UNIT_JAPANESE_ZERO',
	'UNIT_JET_FIGHTER',
	'UNIT_STEALTH_BOMBER'
);

UPDATE Unit_ResourceQuantityRequirements
SET ResourceType = 'RESOURCE_OIL'
WHERE UnitType IN (
	'UNIT_WWI_TANK',
	'UNIT_TANK',
	'UNIT_MODERN_ARMOR',
	'UNIT_NUCLEAR_SUBMARINE',
	'UNIT_BATTLESHIP',
	'UNIT_MISSILE_CRUISER'
);

UPDATE Unit_ResourceQuantityRequirements
SET ResourceType = 'RESOURCE_IRON', Cost = 3
WHERE UnitType IN (
	SELECT DISTINCT Type FROM Units WHERE Class IN (
		'UNITCLASS_IRONCLAD'
	)
);

/*
INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT DISTINCT Type, 'PROMOTION_NAVAL_RECON_1'
FROM Units WHERE Class IN (
	'UNITCLASS_CARAVEL',
	'UNITCLASS_FRIGATE',
	'UNITCLASS_DESTROYER'
);

INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT DISTINCT Type, 'PROMOTION_EXTRA_SIGHT_NOUPGRADE_I'
FROM Units WHERE Class IN (
	'UNITCLASS_DESTROYER',
	'UNITCLASS_SUBMARINE',
	'UNITCLASS_NUCLEAR_SUBMARINE'
);

INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT DISTINCT Type, 'PROMOTION_CAPITAL_SHIP_BONUS'
FROM Units WHERE Class IN (
	'UNITCLASS_SUBMARINE',
	'UNITCLASS_NUCLEAR_SUBMARINE'
);
*/

--
-- Promotions
--

UPDATE UnitPromotions
SET LostWithUpgrade = 1
WHERE (
	   Type LIKE '%PENALTY%'
	OR Type LIKE '%NOUPGRADE%'
	OR Type IN (
		'PROMOTION_ROUGH_TERRAIN_ENDS_TURN',	-- penalty
		'PROMOTION_ONLY_DEFENSIVE', 			-- penalty
		'PROMOTION_NO_DEFENSIVE_BONUSES', 		-- penalty
		'PROMOTION_MUST_SET_UP', 				-- penalty
		'PROMOTION_CITY_ASSAULT',				-- demolish
		'PROMOTION_CITY_SIEGE', 				-- demolish
		'PROMOTION_GREAT_GENERAL', 				-- leadership
		'PROMOTION_CAN_MOVE_AFTER_ATTACKING', 	-- mobile
		'PROMOTION_ANTI_HELICOPTER',			-- fighters
		'PROMOTION_MERCENARY'					-- landsknecht
	)
);

UPDATE UnitPromotions
SET LostWithUpgrade = 1
WHERE PediaType = 'PEDIA_ATTRIBUTES'
AND NOT Type IN (
	'PROMOTION_INDIRECT_FIRE', 					-- earned
	'PROMOTION_CAN_MOVE_AFTER_ATTACKING',		-- not important
	'PROMOTION_IGNORE_TERRAIN_COST', 			-- minutemen
	'PROMOTION_PHALANX', 						-- hoplites
	'PROMOTION_GOLDEN', 						-- immortals	
	'PROMOTION_DESERT_POWER', 					-- barbarians
	'PROMOTION_ARCTIC_POWER', 					-- barbarians
	'PROMOTION_GUERRILLA', 						-- barbarians
	'PROMOTION_FREE_UPGRADES', 					-- citystates	
	'PROMOTION_HANDICAP', 						-- handicap
	'PROMOTION_OCEAN_MOVEMENT',					-- england
	'PROMOTION_EXTRA_MOVES_I'					-- special bonus
	)
AND NOT Type IN (
	SELECT PromotionType
	FROM Unit_FreePromotions
	WHERE UnitType IN (
		SELECT UnitType
		FROM Civilization_UnitClassOverrides
		WHERE CivilizationType != 'CIVILIZATION_BARBARIAN'
	)
);

UPDATE UnitPromotions
SET   PortraitIndex = '58'
WHERE PortraitIndex = '59'
AND   LostWithUpgrade = 1;

UPDATE UnitPromotions
SET   PortraitIndex = '59'
WHERE PortraitIndex = '58'
AND   LostWithUpgrade = 0
AND NOT Type IN (
	'PROMOTION_HANDICAP' 		-- handicap
);

--
-- Misc
--

UPDATE Buildings
SET ConquestProb = 100
WHERE HurryCostModifier != -1;

UPDATE Buildings
SET ConquestProb = 0
WHERE BuildingClass IN (
	'BUILDINGCLASS_COURTHOUSE',
	'BUILDINGCLASS_WALLS',
	'BUILDINGCLASS_CASTLE',
	'BUILDINGCLASS_ARSENAL',
	'BUILDINGCLASS_MILITARY_BASE',
	'BUILDINGCLASS_FACTORY',
	'BUILDINGCLASS_SOLAR_PLANT',
	'BUILDINGCLASS_NUCLEAR_PLANT'
);

UPDATE Buildings
SET ConquestProb = 50
WHERE BuildingClass IN (
	'BUILDINGCLASS_LIBRARY',
	'BUILDINGCLASS_COLOSSEUM',
	'BUILDINGCLASS_THEATRE',
	'BUILDINGCLASS_STADIUM',
	'BUILDINGCLASS_MARKET',
	'BUILDINGCLASS_BANK',
	'BUILDINGCLASS_STOCK_EXCHANGE',
	'BUILDINGCLASS_MINT',
	'BUILDINGCLASS_HARBOR',
	'BUILDINGCLASS_WAREHOUSE'
);