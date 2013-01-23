--
-- Remove buildings
--

DELETE FROM Buildings							WHERE Type IN ('BUILDING_RECYCLING_CENTER', 'BUILDING_BOMB_SHELTER', 'BUILDING_LOUVRE', 'BUILDING_NOTRE_DAME', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_GREAT_FIREWALL');
DELETE FROM Building_BuildingClassHappiness		WHERE BuildingType IN ('BUILDING_RECYCLING_CENTER', 'BUILDING_BOMB_SHELTER', 'BUILDING_LOUVRE', 'BUILDING_NOTRE_DAME', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_GREAT_FIREWALL');
DELETE FROM Building_BuildingClassYieldChanges	WHERE BuildingType IN ('BUILDING_RECYCLING_CENTER', 'BUILDING_BOMB_SHELTER', 'BUILDING_LOUVRE', 'BUILDING_NOTRE_DAME', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_GREAT_FIREWALL');
DELETE FROM Building_FreeUnits					WHERE BuildingType IN ('BUILDING_RECYCLING_CENTER', 'BUILDING_BOMB_SHELTER', 'BUILDING_LOUVRE', 'BUILDING_NOTRE_DAME', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_GREAT_FIREWALL');
DELETE FROM Building_ResourceQuantity			WHERE BuildingType IN ('BUILDING_RECYCLING_CENTER', 'BUILDING_BOMB_SHELTER', 'BUILDING_LOUVRE', 'BUILDING_NOTRE_DAME', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_GREAT_FIREWALL');
DELETE FROM Building_YieldChanges 				WHERE BuildingType IN ('BUILDING_RECYCLING_CENTER', 'BUILDING_BOMB_SHELTER', 'BUILDING_LOUVRE', 'BUILDING_NOTRE_DAME', 'BUILDING_NEUSCHWANSTEIN', 'BUILDING_GREAT_FIREWALL');

-- remap IDs
CREATE TABLE IF NOT EXISTS IDRemapper ( id INTEGER PRIMARY KEY AUTOINCREMENT, Type TEXT );
DROP TABLE IDRemapper;
CREATE TABLE IDRemapper ( id INTEGER PRIMARY KEY AUTOINCREMENT, Type TEXT );
INSERT INTO IDRemapper (Type) SELECT Type FROM Buildings;
UPDATE Buildings SET ID = ( SELECT IDRemapper.id-1 FROM IDRemapper WHERE Buildings.Type = IDRemapper.Type);
UPDATE sqlite_sequence SET seq = (SELECT COUNT(ID) FROM Buildings)-1 WHERE name = 'Buildings';


--
-- Global Mods
--

UPDATE Buildings
SET Cost = ROUND(Cost * 1.8 / 10, 0) * 10
WHERE Cost > 0 AND NOT BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (
		MaxGlobalInstances = 1
		OR MaxTeamInstances = 1
		OR MaxPlayerInstances = 1
	)
);

UPDATE Buildings
SET Cost = ROUND(Cost * 1.2 / 10, 0) * 10
WHERE Cost > 0 AND BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (
		MaxGlobalInstances = 1
		OR MaxTeamInstances = 1
		OR MaxPlayerInstances = 1
	)
);

UPDATE Projects
SET Cost = ROUND(Cost * 1.2 / 10, 0) * 10
WHERE Cost > 0;

UPDATE Buildings
SET Cost = 100, NumCityCostMod = 25
WHERE NumCityCostMod > 0;

UPDATE Buildings
SET HurryCostModifier = 0
WHERE HurryCostModifier > 0;

UPDATE Buildings
SET HurryCostModifier = 50
WHERE BuildingClass IN (
	'BUILDINGCLASS_WALLS',
	'BUILDINGCLASS_CASTLE',
	'BUILDINGCLASS_ARSENAL',
	'BUILDINGCLASS_MILITARY_BASE'
);

/*
UPDATE Buildings
SET Cost = -1
WHERE Type IN (
	'BUILDING_RECYCLING_CENTER',
	'BUILDING_BOMB_SHELTER',
	'BUILDING_LOUVRE',
	'BUILDING_NOTRE_DAME',
	'BUILDING_NEUSCHWANSTEIN'
);

UPDATE Buildings
SET PrereqTech = NULL
WHERE Type IN (
	'BUILDING_RECYCLING_CENTER',
	'BUILDING_BOMB_SHELTER',
	'BUILDING_LOUVRE',
	'BUILDING_NOTRE_DAME',
	'BUILDING_NEUSCHWANSTEIN'
);

UPDATE BuildingClasses
SET MaxGlobalInstances = -1
WHERE Type IN (
	'BUILDINGCLASS_LOUVRE',
	'BUILDINGCLASS_NOTRE_DAME',
	'BUILDINGCLASS_NEUSCHWANSTEIN'
);
*/

--
-- Happiness
--

/*
-- todo: finish this conversion
INSERT OR REPLACE INTO	Building_YieldChanges
						(BuildingType, YieldType, Yield)
SELECT DISTINCT			Type, 'YIELD_HAPPINESS', Happiness + UnmoddedHappiness
FROM Buildings			WHERE (Happiness + UnmoddedHappiness) <> 0;
*/

UPDATE Buildings SET Happiness = Happiness + UnmoddedHappiness
WHERE BuildingClass IN (
	'BUILDINGCLASS_HAGIA_SOPHIA'		,
	'BUILDINGCLASS_HANGING_GARDEN'		,
	'BUILDINGCLASS_EIFFEL_TOWER'		
);

UPDATE Buildings SET UnmoddedHappiness = 0
WHERE BuildingClass IN (
	'BUILDINGCLASS_HAGIA_SOPHIA'		,
	'BUILDINGCLASS_HANGING_GARDEN'		,
	'BUILDINGCLASS_EIFFEL_TOWER'		
);

UPDATE Buildings
SET Happiness = Happiness + 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_COLOSSEUM'
);

UPDATE Buildings
SET UnmoddedHappiness = UnmoddedHappiness + 1
WHERE BuildingClass IN (
	'BUILDINGCLASS_THEATRE',
	'BUILDINGCLASS_STADIUM'
);

--
-- Specific Buildings
--

--*/

UPDATE Building_YieldChanges
SET Yield = Yield * 2
WHERE YieldType = 'YIELD_SCIENCE';

UPDATE Belief_ResourceYieldChanges
SET Yield = Yield * 2
WHERE YieldType = 'YIELD_SCIENCE';

UPDATE Belief_BuildingClassYieldChanges
SET YieldChange = YieldChange * 2
WHERE YieldType = 'YIELD_SCIENCE';

UPDATE Belief_FeatureYieldChanges
SET Yield = Yield * 2
WHERE YieldType = 'YIELD_SCIENCE';

/*
UPDATE Belief_ImprovementYieldChanges
SET Yield = Yield * 2
WHERE YieldType = 'YIELD_CULTURE' OR YieldType = 'YIELD_SCIENCE';
*/

UPDATE Belief_YieldChangePerXForeignFollowers
SET ForeignFollowers = ROUND(ForeignFollowers * 0.4, 0)
WHERE YieldType = 'YIELD_SCIENCE';

UPDATE Buildings
SET Defense = Defense - 300
WHERE Defense > 0;

UPDATE Building_SpecialistYieldChanges
SET Yield = 2
WHERE BuildingType = 'BUILDING_STATUE_OF_LIBERTY';

UPDATE Project_Flavors
SET Flavor = 256
WHERE FlavorType IN (
	'FLAVOR_CULTURE',
	'FLAVOR_NUKE',
	'FLAVOR_SPACESHIP'
);

UPDATE Project_Flavors
SET Flavor = 32
WHERE FlavorType NOT IN (
	'FLAVOR_CULTURE',
	'FLAVOR_NUKE',
	'FLAVOR_SPACESHIP'
);


INSERT OR REPLACE INTO	Building_YieldModifiers
						(BuildingType, YieldType, Yield)
SELECT DISTINCT			Type, 'YIELD_CULTURE', 50
FROM Buildings			WHERE BuildingClass = 'BUILDINGCLASS_OPERA_HOUSE';

DELETE FROM				Building_YieldChanges
WHERE BuildingType IN	(SELECT Type FROM Buildings
						WHERE YieldType = 'YIELD_CULTURE'
						AND BuildingClass = 'BUILDINGCLASS_OPERA_HOUSE');


INSERT OR REPLACE INTO	Building_YieldChangesPerPop
						(BuildingType, YieldType, Yield)
SELECT DISTINCT			Type, 'YIELD_CULTURE', 50
FROM Buildings			WHERE BuildingClass = 'BUILDINGCLASS_MUSEUM';

DELETE FROM				Building_YieldChanges
WHERE BuildingType IN	(SELECT Type FROM Buildings
						WHERE YieldType = 'YIELD_CULTURE'
						AND BuildingClass = 'BUILDINGCLASS_MUSEUM');


/*
INSERT OR REPLACE INTO Building_PrereqBuildingClassesPercentage
	(BuildingType, BuildingClassType, PercentBuildingNeeded)
SELECT
	BuildingType, BuildingClassType, '75'
FROM Building_PrereqBuildingClasses
WHERE NumBuildingNeeded = -1;
*/

UPDATE Building_PrereqBuildingClasses
SET BuildingClassType = 'BUILDINGCLASS_AMPHITHEATER'
WHERE BuildingType = 'BUILDING_NATIONAL_EPIC';

/*
DELETE
FROM Building_PrereqBuildingClasses
WHERE NumBuildingNeeded = -1;
*/

/*
UPDATE Building_YieldChanges
SET Yield = Yield + 1
WHERE YieldType = 'YIELD_HAPPINESS'
AND BuildingClass IN (
	'BUILDINGCLASS_COLOSSEUM',
	'BUILDINGCLASS_THEATRE',
	'BUILDINGCLASS_STADIUM'
);
*/

DELETE FROM Building_UnitCombatProductionModifiers
WHERE BuildingType = 'BUILDING_TEMPLE_ARTEMIS';

INSERT INTO Building_UnitCombatFreeExperiences
	(BuildingType, UnitCombatType, Experience)
SELECT 'BUILDING_TEMPLE_ARTEMIS', 'UNITCOMBAT_ARCHER', '20'
WHERE EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_TEMPLE_ARTEMIS' );

INSERT INTO Building_UnitCombatFreeExperiences
	(BuildingType, UnitCombatType, Experience)
SELECT 'BUILDING_TEMPLE_ARTEMIS', 'UNITCOMBAT_MOUNTED_ARCHER', '20'
WHERE EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_TEMPLE_ARTEMIS' );

INSERT INTO Building_FreeUnits
	(BuildingType, UnitType, NumUnits)
SELECT 'BUILDING_MAUSOLEUM_HALICARNASSUS', 'UNIT_MERCHANT', '1'
WHERE EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_MAUSOLEUM_HALICARNASSUS' );


UPDATE LoadedFile SET Value=1 WHERE Type='GEC_Start.sql';