--


--
-- Cost: Buildings
--

-- Set maintenance for buildings not included in the table
UPDATE Buildings SET GoldMaintenance = Cost / 100 WHERE GoldMaintenance <> 0;


-- This GEC_End.sql data from:
-- Buildings tab of GEM_Details.xls spreadsheet (in mod folder).
UPDATE Buildings SET Cost = Cost * 1.056, GoldMaintenance = 7  WHERE BuildingClass = 'BUILDINGCLASS_STADIUM';
UPDATE Buildings SET Cost = Cost * 1.806, GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_THEATRE';
UPDATE Buildings SET Cost = Cost * 2.5  , GoldMaintenance = 4  WHERE BuildingClass = 'BUILDINGCLASS_COLOSSEUM';
UPDATE Buildings SET Cost = 50          , GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_GEM_PALACE';
UPDATE Buildings SET Cost = Cost * 1.667, GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_COURTHOUSE';
UPDATE Buildings SET Cost = Cost * 2.431, GoldMaintenance = 3  WHERE BuildingClass = 'BUILDINGCLASS_CIRCUS';
UPDATE Buildings SET Cost = Cost * 1.333, GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_SEAPORT';
UPDATE Buildings SET Cost = 400         , GoldMaintenance = 3  WHERE BuildingClass = 'BUILDINGCLASS_WAREHOUSE';
UPDATE Buildings SET Cost = Cost * 1.481, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_LIGHTHOUSE';
UPDATE Buildings SET Cost = Cost * 0.926, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_HARBOR';
UPDATE Buildings SET Cost = Cost * 0.889, GoldMaintenance = 6  WHERE BuildingClass = 'BUILDINGCLASS_MEDICAL_LAB';
UPDATE Buildings SET Cost = Cost * 0.926, GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_HOSPITAL';
UPDATE Buildings SET Cost = Cost * 1.944, GoldMaintenance = 3  WHERE BuildingClass = 'BUILDINGCLASS_AQUEDUCT';
UPDATE Buildings SET Cost = Cost * 1.389, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_GRANARY';
UPDATE Buildings SET Cost = 150         , GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_CITY_HALL';
UPDATE Buildings SET Cost = Cost * 1.466, GoldMaintenance = 7  WHERE BuildingClass = 'BUILDINGCLASS_STOCK_EXCHANGE';
UPDATE Buildings SET Cost = Cost * 1.389, GoldMaintenance = 4  WHERE BuildingClass = 'BUILDINGCLASS_BANK';
UPDATE Buildings SET Cost = Cost * 1.389, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_MINT';
UPDATE Buildings SET Cost = Cost * 0.833, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_MARKET';
UPDATE Buildings SET Cost = Cost * 1.056, GoldMaintenance = 7  WHERE BuildingClass = 'BUILDINGCLASS_SPACESHIP_FACTORY';
UPDATE Buildings SET Cost = Cost * 0.944, GoldMaintenance = 6  WHERE BuildingClass = 'BUILDINGCLASS_NUCLEAR_PLANT';
UPDATE Buildings SET Cost = Cost * 0.722, GoldMaintenance = 4  WHERE BuildingClass = 'BUILDINGCLASS_SOLAR_PLANT';
UPDATE Buildings SET Cost = Cost * 1.08 , GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_FACTORY';
UPDATE Buildings SET Cost = Cost * 0.926, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_WORKSHOP';
UPDATE Buildings SET Cost = Cost * 0.694, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_HYDRO_PLANT';
UPDATE Buildings SET Cost = Cost * 0.667, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_WINDMILL';
UPDATE Buildings SET Cost = Cost * 0.926, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_FORGE';
UPDATE Buildings SET Cost = Cost * 1.111, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_STONEWORKS';
UPDATE Buildings SET Cost = Cost * 1.481, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_WATERMILL';
UPDATE Buildings SET Cost = Cost * 0.833, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_STABLE';
UPDATE Buildings SET Cost = Cost * 0.833, GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_BROADCAST_TOWER';
UPDATE Buildings SET Cost = Cost * 1.296, GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_MUSEUM';
UPDATE Buildings SET Cost = Cost * 0.972, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_OPERA_HOUSE';
UPDATE Buildings SET Cost = Cost * 1.111, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_AMPHITHEATER';
UPDATE Buildings SET Cost = Cost * 1.389, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_MONUMENT';
UPDATE Buildings SET Cost = Cost * 0.944, GoldMaintenance = 6  WHERE BuildingClass = 'BUILDINGCLASS_LABORATORY';
UPDATE Buildings SET Cost = Cost * 1.204, GoldMaintenance = 3  WHERE BuildingClass = 'BUILDINGCLASS_PUBLIC_SCHOOL';
UPDATE Buildings SET Cost = Cost * 1.215, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_UNIVERSITY';
UPDATE Buildings SET Cost = Cost * 1.111, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_LIBRARY';
UPDATE Buildings SET Cost = 100         , GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_MENTORS_HALL';
UPDATE Buildings SET Cost = 700         , GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_INTELLIGENCE_AGENCY';
UPDATE Buildings SET Cost = 700         , GoldMaintenance = 5  WHERE BuildingClass = 'BUILDINGCLASS_POLICE_STATION';
UPDATE Buildings SET Cost = Cost * 1.042, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_CONSTABLE';
UPDATE Buildings SET Cost = Cost * 0.926, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_GARDEN';
UPDATE Buildings SET Cost = Cost * 1.111, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_TEMPLE';
UPDATE Buildings SET Cost = Cost * 0.694, GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_SHRINE';
UPDATE Buildings SET Cost = Cost * 0.611, GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_MILITARY_BASE';
UPDATE Buildings SET Cost = Cost * 0.741, GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_ARSENAL';
UPDATE Buildings SET Cost = Cost * 1.042, GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_CASTLE';
UPDATE Buildings SET Cost = Cost * 1.111, GoldMaintenance = 0  WHERE BuildingClass = 'BUILDINGCLASS_WALLS';
UPDATE Buildings SET Cost = Cost * 0.833, GoldMaintenance = 3  WHERE BuildingClass = 'BUILDINGCLASS_MILITARY_ACADEMY';
UPDATE Buildings SET Cost = Cost * 1.042, GoldMaintenance = 2  WHERE BuildingClass = 'BUILDINGCLASS_ARMORY';
UPDATE Buildings SET Cost = Cost * 0.741, GoldMaintenance = 1  WHERE BuildingClass = 'BUILDINGCLASS_BARRACKS';


UPDATE Buildings SET GoldMaintenance = MAX(0, ROUND(GoldMaintenance, 0)) WHERE GoldMaintenance <> 0;

UPDATE Buildings
SET Cost = ROUND(Cost / 50, 0) * 50
WHERE Cost > 0;

UPDATE Projects
SET Cost = ROUND(Cost / 50, 0) * 50
WHERE Cost > 0;

--
-- Cost: Wonders
--

/*
UPDATE Buildings
SET NumCityCostMod = ROUND((NumCityCostMod * 1.1) / 10) * 10
WHERE NumCityCostMod > 0;
*/

/*
UPDATE Buildings	(Type, Happiness)
SELECT				row.BuildingType, row.Yield
FROM				Building_YieldChanges row
WHERE				BuildingType = 
					AND YieldType = 'YIELD_HAPPINESS_CITY';
*/
UPDATE Buildings
SET NumCityCostMod = ROUND((NumCityCostMod * 1.1) / 10) * 10
WHERE NumCityCostMod > 0;

DROP TABLE IF EXISTS GEM_WonderTechs;
CREATE TABLE GEM_WonderTechs(BuildingClass text, GridX integer);
INSERT INTO GEM_WonderTechs (BuildingClass, GridX)
SELECT building.BuildingClass, tech.GridX
FROM Buildings building, BuildingClasses class, Technologies tech
WHERE ( building.PrereqTech = tech.Type
	AND building.BuildingClass = class.Type
	AND class.MaxGlobalInstances = 1
);

UPDATE GEM_WonderTechs
SET GridX = GridX - 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_STONEHENGE'			,
	'BUILDINGCLASS_COLOSSUS'			,
	'BUILDINGCLASS_GREAT_LIGHTHOUSE'	,
	'BUILDINGCLASS_STATUE_ZEUS'			,
	'BUILDINGCLASS_MACHU_PICCHU'		,
	'BUILDINGCLASS_TERRACOTTA_ARMY'		
);

UPDATE GEM_WonderTechs
SET GridX = GridX + 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_GREAT_LIBRARY'		,
	'BUILDINGCLASS_ORACLE'				,
	'BUILDINGCLASS_BANAUE_RICE_TERRACES'
);

UPDATE Buildings SET Cost = 150   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX < 1);
UPDATE Buildings SET Cost = 180   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 1);
UPDATE Buildings SET Cost = 210   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 2);
UPDATE Buildings SET Cost = 240   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 3);
UPDATE Buildings SET Cost = 290   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 4);
UPDATE Buildings SET Cost = 350   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 5);
UPDATE Buildings SET Cost = 430   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 6);
UPDATE Buildings SET Cost = 520   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 7);
UPDATE Buildings SET Cost = 620   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 8);
UPDATE Buildings SET Cost = 750   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 9);
UPDATE Buildings SET Cost = 900   WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 10);
UPDATE Buildings SET Cost = 1070  WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 11);
UPDATE Buildings SET Cost = 1270  WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 12);
UPDATE Buildings SET Cost = 1270  WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 13);
UPDATE Buildings SET Cost = 1270  WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX = 14);
UPDATE Buildings SET Cost = 1270  WHERE BuildingClass IN (SELECT BuildingClass FROM GEM_WonderTechs WHERE GridX > 14);

DROP TABLE GEM_WonderTechs;

--
-- Wonders
--

INSERT INTO Civilization_BuildingClassOverrides(CivilizationType, BuildingClassType)
SELECT civ.Type, class.Type
FROM Civilizations civ, BuildingClasses class
WHERE civ.Type IN ('CIVILIZATION_BARBARIAN', 'CIVILIZATION_MINOR')
AND class.Type IN (
	'BUILDINGCLASS_BANAUE_RICE_TERRACES'	,
	'BUILDINGCLASS_HOLLYWOOD'				,
	'BUILDINGCLASS_WAT_PHRA_KAEW'			,
	'BUILDINGCLASS_LARGE_HADRON_COLLIDER'	,
	'BUILDINGCLASS_CHURCHES_LALIBELA'		,
	'BUILDINGCLASS_ITAIPU_DAM'				,
	'BUILDINGCLASS_PANAMA_CANAL'			
);



--
-- Resources
--

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_FAITH', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_TEMPLE'
						AND res.Type IN (
							'RESOURCE_WINE',
							'RESOURCE_INCENSE'
						);

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_FOOD', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_GRANARY'
						AND res.Type IN (
							'RESOURCE_SPICES',
							'RESOURCE_SUGAR',
							'RESOURCE_SALT'
						);

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_FOOD', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_AQUEDUCT'
						AND res.Type IN (
							'RESOURCE_CITRUS',
							'RESOURCE_TRUFFLES',
							'RESOURCE_BANANA'
						);

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_CULTURE', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_AMPHITHEATER'
						AND res.Type IN (
							'RESOURCE_SILK',
							'RESOURCE_COTTON',
							'RESOURCE_FUR',
							'RESOURCE_DYE'
						);

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_PRODUCTION', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_WAREHOUSE'
						AND res.Type IN (
							'RESOURCE_FISH',
							'RESOURCE_WHALE',
							'RESOURCE_PEARLS',
							'RESOURCE_CRAB'
						);

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_SCIENCE', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_UNIVERSITY'
						AND res.Type IN (
							'RESOURCE_FISH',
							'RESOURCE_WHALE',
							'RESOURCE_PEARLS',
							'RESOURCE_CRAB'
						);

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_PRODUCTION', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_FACTORY'
						AND res.Type IN (
							'RESOURCE_ALUMINUM',
							'RESOURCE_OIL',
							'RESOURCE_URANIUM'
						);

DELETE FROM Building_ResourceYieldChanges WHERE BuildingType = 'BUILDING_SEAPORT';

/*
INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield)
SELECT					'BUILDING_MARKET', Type, 'YIELD_GOLD', 1
FROM					Resources
WHERE					Happiness > 0;

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield)
SELECT					'BUILDING_BAZAAR', Type, 'YIELD_GOLD', 1
FROM					Resources
WHERE					Happiness > 0;

INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield)
SELECT					'BUILDING_SATRAPS_COURT', Type, 'YIELD_GOLD', 1
FROM					Resources
WHERE					Happiness > 0;
*/

INSERT OR REPLACE INTO	Building_ResourceYieldChanges(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_GOLD', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_MARKET'
AND						res.Happiness > 0;

/*
INSERT OR REPLACE INTO	Building_ResourceYieldChanges
						(BuildingType, ResourceType, YieldType, Yield) 
SELECT					building.Type, res.Type, 'YIELD_GOLD', 1
FROM					Buildings building, Resources res
WHERE					building.BuildingClass = 'BUILDINGCLASS_MARKET'
						AND res.Type IN (
							'RESOURCE_SALT',
							'RESOURCE_CITRUS',
							'RESOURCE_TRUFFLES',
							'RESOURCE_BANANA'
						);
*/

--
-- Specialists
--

UPDATE Specialists
SET GreatPeopleRateChange = 3
WHERE GreatPeopleRateChange > 0;

UPDATE Buildings
SET SpecialistType = 'SPECIALIST_ENGINEER', SpecialistCount = 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_BARRACKS',
	'BUILDINGCLASS_MILITARY_ACADEMY',
	'BUILDINGCLASS_FORGE',
	'BUILDINGCLASS_WORKSHOP',
	'BUILDINGCLASS_FACTORY',
	'BUILDINGCLASS_IRONWORKS',
	'BUILDINGCLASS_HEROIC_EPIC'
);

UPDATE Buildings
SET SpecialistType = 'SPECIALIST_MERCHANT', SpecialistCount = 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_MARKET',
	'BUILDINGCLASS_MINT',
	'BUILDINGCLASS_BANK',
	'BUILDINGCLASS_STOCK_EXCHANGE',
	'BUILDINGCLASS_LIGHTHOUSE',
	'BUILDINGCLASS_CIRCUS_MAXIMUS',
	'BUILDINGCLASS_NATIONAL_TREASURY'
);

UPDATE Buildings
SET SpecialistType = 'SPECIALIST_SCIENTIST', SpecialistCount = 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_LIBRARY',
	'BUILDINGCLASS_UNIVERSITY',
	'BUILDINGCLASS_PUBLIC_SCHOOL',
	'BUILDINGCLASS_LABORATORY',
	'BUILDINGCLASS_NATIONAL_COLLEGE',
	'BUILDINGCLASS_OXFORD_UNIVERSITY'
);

UPDATE Buildings
SET SpecialistType = 'SPECIALIST_ARTIST', SpecialistCount = 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_SHRINE',
	'BUILDINGCLASS_AMPHITHEATER',
	'BUILDINGCLASS_OPERA_HOUSE',
	'BUILDINGCLASS_MUSEUM',
	'BUILDINGCLASS_BROADCAST_TOWER',
	'BUILDINGCLASS_NATIONAL_EPIC',
	'BUILDINGCLASS_HERMITAGE'
);

UPDATE Buildings
SET SpecialistType = NULL, SpecialistCount = 0
WHERE BuildingClass IN (
	'BUILDINGCLASS_WINDMILL'
);


--
-- Culture
--

INSERT INTO Building_YieldChanges(BuildingType, YieldType, Yield)
SELECT Type, 'YIELD_CULTURE', 3
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MONUMENT'
);

UPDATE Building_YieldChanges
SET Yield = 1
WHERE YieldType = 'YIELD_CULTURE'
AND BuildingType IN (
	SELECT building.Type
	FROM Buildings building, BuildingClasses class
	WHERE building.BuildingClass = class.Type AND class.MaxGlobalInstances = 1
);


--
-- Science
--

INSERT INTO Building_YieldChanges(BuildingType, YieldType, Yield)
SELECT Type, 'YIELD_SCIENCE', 2
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MENTORS_HALL'	
);

INSERT INTO Building_YieldChanges(BuildingType, YieldType, Yield)
SELECT Type, 'YIELD_SCIENCE', 1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_LIBRARY'	
);

INSERT INTO Building_YieldModifiers(BuildingType, YieldType, Yield)
SELECT Type, 'YIELD_SCIENCE', 25
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MENTORS_HALL'	
);

DELETE FROM Building_YieldChanges WHERE BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_UNIVERSITY'		,
	'BUILDINGCLASS_PUBLIC_SCHOOL'	,
	'BUILDINGCLASS_LABORATORY'	
));

INSERT INTO Building_YieldChanges(BuildingType, YieldType, Yield)
SELECT 'BUILDING_FOLKSKOLA', 'YIELD_SCIENCE', 10;

UPDATE Building_YieldChangesPerPop
SET Yield = 25
WHERE YieldType = 'YIELD_SCIENCE'
AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_LIBRARY'			,
	'BUILDINGCLASS_PUBLIC_SCHOOL'	
));

INSERT INTO Building_YieldChangesPerPop(BuildingType, YieldType, Yield)
SELECT 'BUILDING_FOLKSKOLA', 'YIELD_SCIENCE', 25;

UPDATE Building_YieldModifiers
SET Yield = 30
WHERE YieldType = 'YIELD_SCIENCE'
AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_UNIVERSITY'		
));

INSERT INTO Building_YieldModifiers(BuildingType, YieldType, Yield)
SELECT Type, 'YIELD_SCIENCE', 10
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_PUBLIC_SCHOOL'	
);

UPDATE Building_YieldModifiers
SET Yield = 45
WHERE YieldType = 'YIELD_SCIENCE'
AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_LABORATORY'			
));

--
-- Rename Buildings
--

UPDATE Buildings SET IconAtlas='TECH_ATLAS_1',	PortraitIndex=51	WHERE Type = 'BUILDING_STADIUM';
UPDATE Buildings SET IconAtlas='TECH_ATLAS_1',	PortraitIndex=59	WHERE Type = 'BUILDING_THEATRE';
UPDATE Buildings SET							PortraitIndex=28	WHERE Type = 'BUILDING_WINDMILL';
UPDATE Buildings SET							PortraitIndex=4		WHERE Type = 'BUILDING_FACTORY';
UPDATE Buildings SET							PortraitIndex=14	WHERE Type = 'BUILDING_FORGE';
UPDATE Buildings SET							PortraitIndex=2		WHERE Type = 'BUILDING_WORKSHOP';

UPDATE Technologies SET							PortraitIndex=30	WHERE Type = 'TECH_PRINTING_PRESS';

-- This GEC__End.sql data created by:
-- Renames tab of GEM_Details.xls spreadsheet (in mod folder).
UPDATE Buildings SET Description='TXT_KEY_BUILDING_THEATRE',             Civilopedia='TXT_KEY_BUILDING_THEATRE_PEDIA'              WHERE Type = 'BUILDING_AMPHITHEATER';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_ARENA',               Civilopedia='TXT_KEY_BUILDING_ARENA_PEDIA'                WHERE Type = 'BUILDING_COLOSSEUM';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_PUBLISHING_HOUSE',    Civilopedia='TXT_KEY_BUILDING_PUBLISHING_HOUSE_PEDIA'     WHERE Type = 'BUILDING_THEATRE';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_CINEMA',              Civilopedia='TXT_KEY_BUILDING_CINEMA_PEDIA'               WHERE Type = 'BUILDING_STADIUM';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_SANITATION_SYSTEM',   Civilopedia='TXT_KEY_BUILDING_SANITATION_SYSTEM_PEDIA'    WHERE Type = 'BUILDING_AQUEDUCT';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_VACCINATIONS',        Civilopedia='TXT_KEY_BUILDING_VACCINATIONS_PEDIA'         WHERE Type = 'BUILDING_MEDICAL_LAB';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_RADIO_STATION',       Civilopedia='TXT_KEY_BUILDING_RADIO_STATION_PEDIA'        WHERE Type = 'BUILDING_BROADCAST_TOWER';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_SUPERMAX_PRISON',     Civilopedia='TXT_KEY_BUILDING_SUPERMAX_PRISON_PEDIA'      WHERE Type = 'BUILDING_POLICE_STATION';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_CAPITAL_BUILDING',    Civilopedia='TXT_KEY_BUILDING_CAPITAL_BUILDING_PEDIA'     WHERE Type = 'BUILDING_PALACE';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_BLAST_FURNACE',       Civilopedia='TXT_KEY_BUILDING_BLAST_FURNACE_PEDIA'        WHERE Type = 'BUILDING_FORGE';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_SMITHY',              Civilopedia='TXT_KEY_BUILDING_SMITHY_PEDIA'               WHERE Type = 'BUILDING_WORKSHOP';
UPDATE Buildings SET Description='TXT_KEY_BUILDING_FOUNDRY',             Civilopedia='TXT_KEY_BUILDING_FOUNDRY_PEDIA'              WHERE Type = 'BUILDING_IRONWORKS';

UPDATE BuildingClasses SET Description = (SELECT Description FROM Buildings b WHERE BuildingClasses.DefaultBuilding = b.Type);



UPDATE LoadedFile SET Value=1 WHERE Type='GEC_End.sql';