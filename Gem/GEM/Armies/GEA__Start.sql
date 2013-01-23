--
-- Set unique unit classes
--

UPDATE Units SET Class = 'UNITCLASS_LIBURNA',		CombatClass = 'UNITCOMBAT_NAVALMELEE',		GoodyHutUpgradeUnitClass = 'UNITCLASS_CARAVEL',		PrereqTech = 'TECH_OPTICS'
Where Type = 'UNIT_BYZANTINE_DROMON';

UPDATE Units SET Class = 'UNITCLASS_SKIRMISHER',	CombatClass = 'UNITCOMBAT_RECON',			GoodyHutUpgradeUnitClass = 'UNITCLASS_CONSCRIPT',	PrereqTech = 'TECH_BANKING'
Where Type = 'UNIT_AMERICAN_MINUTEMAN';

UPDATE Units SET Class = 'UNITCLASS_HORSEMAN',		CombatClass = 'UNITCOMBAT_MOUNTED_ARCHER',	GoodyHutUpgradeUnitClass = 'UNITCLASS_KNIGHT',		PrereqTech = 'TECH_HORSEBACK_RIDING'
Where Type = 'UNIT_INDIAN_WARELEPHANT';

UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_CARAVEL'		Where UnitType = 'UNIT_BYZANTINE_DROMON';
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_CONSCRIPT'		Where UnitType = 'UNIT_AMERICAN_MINUTEMAN';
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_KNIGHT'		Where UnitType = 'UNIT_INDIAN_WARELEPHANT';
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_SPEARMAN'		Where UnitType = 'UNIT_AZTEC_JAGUAR';
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_SPEARMAN'		Where UnitType = 'UNIT_POLYNESIAN_MAORI_WARRIOR';
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_SPEARMAN'		Where UnitType = 'UNIT_BARBARIAN_WARRIOR';
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_HORSEMAN'		Where UnitType IN (SELECT Type FROM Units WHERE Class = 'UNITCLASS_CHARIOT_ARCHER');
UPDATE Unit_ClassUpgrades SET UnitClassType = 'UNITCLASS_RIFLEMAN'		Where UnitType IN (SELECT Type FROM Units WHERE Class = 'UNITCLASS_LONGSWORDSMAN');

UPDATE Civilization_UnitClassOverrides SET UnitClassType = 'UNITCLASS_LIBURNA'		Where UnitType = 'UNIT_BYZANTINE_DROMON';
UPDATE Civilization_UnitClassOverrides SET UnitClassType = 'UNITCLASS_SKIRMISHER'	Where UnitType = 'UNIT_AMERICAN_MINUTEMAN';
UPDATE Civilization_UnitClassOverrides SET UnitClassType = 'UNITCLASS_HORSEMAN'		Where UnitType = 'UNIT_INDIAN_WARELEPHANT';


UPDATE Unit_ClassUpgrades
Set UnitClassType = 'UNITCLASS_MUSKETMAN'
WHERE UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_PIKEMAN'
));

UPDATE Unit_ClassUpgrades
Set UnitClassType = 'UNITCLASS_MECHANIZED_INFANTRY'
WHERE UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_MACHINE_GUN'
));

UPDATE Unit_ClassUpgrades
Set UnitClassType = 'UNITCLASS_WWI_TANK'
WHERE UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_LANCER'
));

--
-- Unit Details
--

-- This GEA_Start.sql data automatically created by:
-- Units tab of GEM_Details.xlsspreadsheet (in mod folder).
UPDATE Units SET Cost = Cost * 1.307, Combat = Combat * 1.067                                       WHERE Class = 'UNITCLASS_MECH';
UPDATE Units SET Cost = Cost * 0.926,                          RangedCombat = RangedCombat * 1      WHERE Class = 'UNITCLASS_GUIDED_MISSILE';
UPDATE Units SET Cost = Cost * 0.915,                          RangedCombat = RangedCombat * 0.824  WHERE Class = 'UNITCLASS_STEALTH_BOMBER';
UPDATE Units SET Cost = Cost * 0.915,                          RangedCombat = RangedCombat * 0.933  WHERE Class = 'UNITCLASS_JET_FIGHTER';
UPDATE Units SET Cost = Cost * 1.307, Combat = Combat * 1.2                                         WHERE Class = 'UNITCLASS_MODERN_ARMOR';
UPDATE Units SET Cost = Cost * 1.037, Combat = Combat * 0.778                                       WHERE Class = 'UNITCLASS_MECHANIZED_INFANTRY';
UPDATE Units SET Cost = Cost * 0.784, Combat = Combat * 1                                           WHERE Class = 'UNITCLASS_HELICOPTER_GUNSHIP';
UPDATE Units SET Cost = Cost * 0.784, Combat = Combat * 0.923                                       WHERE Class = 'UNITCLASS_MOBILE_SAM';
UPDATE Units SET Cost = Cost * 1.046, Combat = Combat * 1.2  , RangedCombat = RangedCombat * 1.333  WHERE Class = 'UNITCLASS_ROCKET_ARTILLERY';
UPDATE Units SET Cost = Cost * 0.741,                          RangedCombat = RangedCombat * 0.769  WHERE Class = 'UNITCLASS_BOMBER';
UPDATE Units SET Cost = Cost * 0.741,                          RangedCombat = RangedCombat * 1.111  WHERE Class = 'UNITCLASS_FIGHTER';
UPDATE Units SET Cost = Cost * 1.185, Combat = Combat * 1.143                                       WHERE Class = 'UNITCLASS_TANK';
UPDATE Units SET Cost = Cost * 0.833, Combat = Combat * 0.923                                       WHERE Class = 'UNITCLASS_MARINE';
UPDATE Units SET Cost = Cost * 0.563, Combat = Combat * 0.585                                       WHERE Class = 'UNITCLASS_PARATROOPER';
UPDATE Units SET Cost = Cost * 0.741, Combat = Combat * 0.714                                       WHERE Class = 'UNITCLASS_INFANTRY';
UPDATE Units SET Cost = Cost * 0.794, Combat = Combat * 1.167, RangedCombat = RangedCombat * 0.833  WHERE Class = 'UNITCLASS_MACHINE_GUN';
UPDATE Units SET Cost = Cost * 0.593, Combat = Combat * 0.8                                         WHERE Class = 'UNITCLASS_ANTI_TANK_GUN';
UPDATE Units SET Cost = Cost * 0.593, Combat = Combat * 0.8                                         WHERE Class = 'UNITCLASS_ANTI_AIRCRAFT_GUN';
UPDATE Units SET Cost = Cost * 0.684,                          RangedCombat = RangedCombat * 0.8    WHERE Class = 'UNITCLASS_WWI_BOMBER';
UPDATE Units SET Cost = Cost * 0.684,                          RangedCombat = RangedCombat * 1.143  WHERE Class = 'UNITCLASS_TRIPLANE';
UPDATE Units SET Cost = Cost * 0.873, Combat = Combat * 0.917                                       WHERE Class = 'UNITCLASS_WWI_TANK';
UPDATE Units SET Cost = Cost * 0.694, Combat = Combat * 0.8                                         WHERE Class = 'UNITCLASS_GREAT_WAR_INFANTRY';
UPDATE Units SET Cost = Cost * 0.889, Combat = Combat * 1.286, RangedCombat = RangedCombat * 1.429  WHERE Class = 'UNITCLASS_ARTILLERY';
UPDATE Units SET Cost = 270         , Combat = 27                                                   WHERE Class = 'UNITCLASS_CONSCRIPT';
UPDATE Units SET Cost = Cost * 0.741, Combat = Combat * 1.333, RangedCombat = RangedCombat * 1      WHERE Class = 'UNITCLASS_GATLINGGUN';
UPDATE Units SET Cost = Cost * 0.988, Combat = Combat * 1.176                                       WHERE Class = 'UNITCLASS_CAVALRY';
UPDATE Units SET Cost = Cost * 0.741, Combat = Combat * 0.882                                       WHERE Class = 'UNITCLASS_RIFLEMAN';
UPDATE Units SET Cost = Cost * 0.901, Combat = Combat * 1.2                                         WHERE Class = 'UNITCLASS_LANCER';
UPDATE Units SET Cost = Cost * 0.901, Combat = Combat * 1.429, RangedCombat = RangedCombat * 1.5    WHERE Class = 'UNITCLASS_CANNON';
UPDATE Units SET Cost = Cost * 1.157, Combat = Combat * 1.25                                        WHERE Class = 'UNITCLASS_KNIGHT';
UPDATE Units SET Cost = Cost * 1.065, Combat = Combat * 1.095                                       WHERE Class = 'UNITCLASS_LONGSWORDSMAN';
UPDATE Units SET Cost = Cost * 0.852, Combat = Combat * 0.958                                       WHERE Class = 'UNITCLASS_MUSKETMAN';
UPDATE Units SET Cost = 170         , Combat = 17                                                   WHERE Class = 'UNITCLASS_SKIRMISHER';
UPDATE Units SET Cost = Cost * 0.741, Combat = Combat * 0.846, RangedCombat = RangedCombat * 0.889  WHERE Class = 'UNITCLASS_CROSSBOWMAN';
UPDATE Units SET Cost = Cost * 0.972, Combat = Combat * 1.167, RangedCombat = RangedCombat * 1.5    WHERE Class = 'UNITCLASS_TREBUCHET';
UPDATE Units SET Cost = Cost * 1.049, Combat = Combat * 1.063                                       WHERE Class = 'UNITCLASS_PIKEMAN';
UPDATE Units SET Cost = 140         , Combat = 14                                                   WHERE Class = 'UNITCLASS_LEVY';
UPDATE Units SET Cost = Cost * 1.259, Combat = Combat * 1.417                                       WHERE Class = 'UNITCLASS_HORSEMAN';
UPDATE Units SET Cost = Cost * 1.185, Combat = Combat * 1.143                                       WHERE Class = 'UNITCLASS_SWORDSMAN';
UPDATE Units SET Cost = Cost * 0.815, Combat = Combat * 1    , RangedCombat = RangedCombat * 1      WHERE Class = 'UNITCLASS_COMPOSITE_BOWMAN';
UPDATE Units SET Cost = Cost * 1.111, Combat = Combat * 1.429, RangedCombat = RangedCombat * 1.875  WHERE Class = 'UNITCLASS_CATAPULT';
UPDATE Units SET Cost = Cost * 1.091, Combat = Combat * 1.167, RangedCombat = RangedCombat * 1.1    WHERE Class = 'UNITCLASS_CHARIOT_ARCHER';
UPDATE Units SET Cost = Cost * 1.091, Combat = Combat * 1                                           WHERE Class = 'UNITCLASS_SPEARMAN';
UPDATE Units SET Cost = 90          , Combat = 9                                                    WHERE Class = 'UNITCLASS_SENTINEL';
UPDATE Units SET Cost = Cost * 0.972, Combat = Combat * 1.125                                       WHERE Class = 'UNITCLASS_WARRIOR';
UPDATE Units SET Cost = Cost * 1.111, Combat = Combat * 1    , RangedCombat = RangedCombat * 1      WHERE Class = 'UNITCLASS_ARCHER';
UPDATE Units SET Cost = Cost * 1.333, Combat = Combat * 1.2                                         WHERE Class = 'UNITCLASS_SCOUT';
UPDATE Units SET Cost = Cost * 0.902, Combat = 69 , RangedCombat = 86, Range = 3, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 7  WHERE Class = 'UNITCLASS_MISSILE_CRUISER';
UPDATE Units SET Cost = Cost * 0.784, Combat = 60 , RangedCombat = 0 , Range = 0, CombatClass = 'UNITCOMBAT_NAVALMELEE' , Moves = 6  WHERE Class = 'UNITCLASS_NUCLEAR_SUBMARINE';
UPDATE Units SET Cost = 600         , Combat = 45 , RangedCombat = 60, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 7  WHERE Class = 'UNITCLASS_MISSILE_DESTROYER';
UPDATE Units SET Cost = Cost * 0.874, Combat = 47 , RangedCombat = 0 , Range = 0, CombatClass = 'UNITCOMBAT_NAVALMELEE' , Moves = 6  WHERE Class = 'UNITCLASS_CARRIER';
UPDATE Units SET Cost = Cost * 0.874, Combat = 47 , RangedCombat = 59, Range = 3, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 6  WHERE Class = 'UNITCLASS_BATTLESHIP';
UPDATE Units SET Cost = Cost * 0.718, Combat = 42 , RangedCombat = 0 , Range = 0, CombatClass = 'UNITCOMBAT_NAVALMELEE' , Moves = 5  WHERE Class = 'UNITCLASS_SUBMARINE';
UPDATE Units SET Cost = Cost * 0.622, Combat = 31 , RangedCombat = 42, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 6  WHERE Class = 'UNITCLASS_DESTROYER';
UPDATE Units SET Cost = Cost * 1.022, Combat = 37 , RangedCombat = 46, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 5  WHERE Class = 'UNITCLASS_IRONCLAD';
UPDATE Units SET Cost = Cost * 1.074, Combat = 29 , RangedCombat = 0 , Range = 0, CombatClass = 'UNITCOMBAT_NAVALMELEE' , Moves = 5  WHERE Class = 'UNITCLASS_PRIVATEER';
UPDATE Units SET Cost = 370         , Combat = 29 , RangedCombat = 37, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 4  WHERE Class = 'UNITCLASS_SHIP_OF_THE_LINE';
UPDATE Units SET Cost = Cost * 0.871, Combat = 22 , RangedCombat = 29, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 4  WHERE Class = 'UNITCLASS_FRIGATE';
UPDATE Units SET Cost = Cost * 0.926, Combat = 20 , RangedCombat = 0 , Range = 0, CombatClass = 'UNITCOMBAT_NAVALMELEE' , Moves = 5  WHERE Class = 'UNITCLASS_CARAVEL';
UPDATE Units SET Cost = Cost * 1.111, Combat = 15 , RangedCombat = 20, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 3  WHERE Class = 'UNITCLASS_GALLEASS';
UPDATE Units SET Cost = 100         , Combat = 13 , RangedCombat = 0 , Range = 0, CombatClass = 'UNITCOMBAT_NAVALMELEE' , Moves = 4  WHERE Class = 'UNITCLASS_LIBURNA';
UPDATE Units SET Cost = Cost * 1.235, Combat = 9  , RangedCombat = 13, Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 3  WHERE Class = 'UNITCLASS_TRIREME';
UPDATE Units SET Cost = 100         , Combat = 9  , RangedCombat = 9 , Range = 2, CombatClass = 'UNITCOMBAT_NAVALRANGED', Moves = 3  WHERE Class = 'UNITCLASS_GALLEY';

--
-- Global Mods
--

UPDATE Units SET Combat = Combat * 1.25, RangedCombat = RangedCombat * 1.25, Moves = Moves + 1 WHERE Type IN (
	'UNIT_BYZANTINE_DROMON'			,
	'UNIT_CARTHAGINIAN_QUINQUEREME'	,
	'UNIT_DUTCH_SEA_BEGGAR'			,
	'UNIT_ENGLISH_SHIPOFTHELINE'	,
	'UNIT_KOREAN_TURTLE_SHIP'		,
	'UNIT_HUN_BATTERING_RAM'
);

UPDATE Units SET       Combat = ROUND(           Combat, 0)       WHERE       Combat <> 0;
UPDATE Units SET RangedCombat = ROUND(     RangedCombat, 0)       WHERE RangedCombat <> 0;
UPDATE Units SET         Cost = ROUND((Cost * 1.8) / 10, 0) * 10  WHERE         Cost  > 0 AND NOT CLASS IN (
	'UNITCLASS_SENTINEL',
	'UNITCLASS_LEVY',
	'UNITCLASS_SKIRMISHER',
	'UNITCLASS_CONSCRIPT',
	'UNITCLASS_LIBURNA',
	'UNITCLASS_SHIP_OF_THE_LINE',
	'UNITCLASS_MISSILE_DESTROYER'
);

UPDATE Units
SET CombatClass = 'UNITCOMBAT_GUN'
WHERE Class IN (
	'UNITCLASS_GATLINGGUN',
	'UNITCLASS_MACHINE_GUN'
);

--
-- Upgrades
--

DELETE FROM Unit_ClassUpgrades WHERE UnitType IN (SELECT Type FROM Units WHERE Domain = 'DOMAIN_SEA');

INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_GALLEASS'             FROM Units WHERE Class = 'UNITCLASS_TRIREME';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_FRIGATE'              FROM Units WHERE Class = 'UNITCLASS_GALLEASS';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_DESTROYER'            FROM Units WHERE Class = 'UNITCLASS_FRIGATE';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_MISSILE_DESTROYER'    FROM Units WHERE Class = 'UNITCLASS_DESTROYER';
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_IRONCLAD'             FROM Units WHERE Class = 'UNITCLASS_SHIP_OF_THE_LINE';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_BATTLESHIP'           FROM Units WHERE Class = 'UNITCLASS_IRONCLAD';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_MISSILE_CRUISER'      FROM Units WHERE Class = 'UNITCLASS_BATTLESHIP';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_CARAVEL'              FROM Units WHERE Class = 'UNITCLASS_LIBURNA';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_PRIVATEER'            FROM Units WHERE Class = 'UNITCLASS_CARAVEL';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_SUBMARINE'            FROM Units WHERE Class = 'UNITCLASS_PRIVATEER';	
INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType) SELECT DISTINCT Type, 'UNITCLASS_NUCLEAR_SUBMARINE'    FROM Units WHERE Class = 'UNITCLASS_SUBMARINE';

/*
UPDATE Units SET ObsoleteTech = 'TECH_COMPASS'              WHERE Class = 'UNITCLASS_TRIREME';
UPDATE Units SET ObsoleteTech = 'TECH_NAVIGATION'           WHERE Class = 'UNITCLASS_GALLEASS';
UPDATE Units SET ObsoleteTech = 'TECH_REFRIGERATION'        WHERE Class = 'UNITCLASS_FRIGATE';
UPDATE Units SET ObsoleteTech = 'TECH_NUCLEAR_FISSION'      WHERE Class = 'UNITCLASS_DESTROYER';
UPDATE Units SET ObsoleteTech = 'TECH_STEAM_POWER'          WHERE Class = 'UNITCLASS_SHIP_OF_THE_LINE';
UPDATE Units SET ObsoleteTech = 'TECH_COMBUSTION'           WHERE Class = 'UNITCLASS_IRONCLAD';
UPDATE Units SET ObsoleteTech = 'TECH_ROBOTICS'             WHERE Class = 'UNITCLASS_BATTLESHIP';
UPDATE Units SET ObsoleteTech = 'TECH_CARVEL_HULLS'         WHERE Class = 'UNITCLASS_LIBURNA';
UPDATE Units SET ObsoleteTech = 'TECH_NAVIGATION'           WHERE Class = 'UNITCLASS_CARAVEL';
UPDATE Units SET ObsoleteTech = 'TECH_REPLACEABLE_PARTS'    WHERE Class = 'UNITCLASS_PRIVATEER';
UPDATE Units SET ObsoleteTech = 'TECH_COMPUTERS'            WHERE Class = 'UNITCLASS_SUBMARINE';
*/

--
-- Resources
--

DELETE FROM Unit_ResourceQuantityRequirements
WHERE UnitType IN (
	'UNIT_CATAPULT',
	'UNIT_ROMAN_BALLISTA',
	'UNIT_TREBUCHET',
	'UNIT_ROCKET_ARTILLERY',
	'UNIT_HELICOPTER_GUNSHIP',
	'UNIT_FRIGATE'
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
	'UNIT_BATTLESHIP'
);

INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType)
SELECT DISTINCT Type, 'RESOURCE_OIL'
FROM Units WHERE Class IN (
	'UNITCLASS_MISSILE_CRUISER'
);

INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType, Cost)
SELECT DISTINCT Type, 'RESOURCE_IRON', 1
FROM Units WHERE Class IN (
	'UNITCLASS_SHIP_OF_THE_LINE'
);

UPDATE Unit_ResourceQuantityRequirements
SET ResourceType = 'RESOURCE_IRON', Cost = 1
WHERE UnitType IN (SELECT DISTINCT Type FROM Units WHERE Class IN (
	'UNITCLASS_IRONCLAD'
));

--
-- Conquest
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

--
-- Other
--

-- This GEA_Start.sql data automatically created by:
-- UnitFormulas tab of GEM_Details.xls spreadsheet in mod folder.
UPDATE Eras SET EmbarkedUnitDefense = 5 WHERE ID = 0;
UPDATE Eras SET EmbarkedUnitDefense = 8 WHERE ID = 1;
UPDATE Eras SET EmbarkedUnitDefense = 10 WHERE ID = 2;
UPDATE Eras SET EmbarkedUnitDefense = 13 WHERE ID = 3;
UPDATE Eras SET EmbarkedUnitDefense = 17 WHERE ID = 4;
UPDATE Eras SET EmbarkedUnitDefense = 21 WHERE ID = 5;
UPDATE Eras SET EmbarkedUnitDefense = 27 WHERE ID = 6;
UPDATE Eras SET EmbarkedUnitDefense = 35 WHERE ID = 7;



UPDATE LoadedFile SET Value=1 WHERE Type='GEA_Start.sql';