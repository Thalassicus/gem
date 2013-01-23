-- 

UPDATE CitySpecialization_TargetYields
SET Yield = 50
WHERE YieldType = 'YIELD_FOOD';


--
-- Availability: Builds
--

-- Common like farms
UPDATE Builds SET AIAvailability = 8
WHERE Type IN (SELECT build.Type FROM Improvements improve, Builds build
WHERE ( build.PrereqTech IS NOT NULL
	AND build.ImprovementType = improve.Type
	AND improve.SpecificCivRequired = 0
	AND improve.Type IN (SELECT ImprovementType FROM Improvement_ValidTerrains)
) OR  ( build.PrereqTech IS NOT NULL
	AND build.RouteType IS NOT NULL
));

-- Resource-specific
UPDATE Builds SET AIAvailability = 4
WHERE Type IN (SELECT build.Type FROM Improvements improve, Builds build
WHERE ( build.PrereqTech IS NOT NULL
	AND build.ImprovementType = improve.Type
	AND improve.SpecificCivRequired = 0
	AND improve.Type NOT IN (SELECT ImprovementType FROM Improvement_ValidTerrains)
));

-- Great improvements
UPDATE Builds SET AIAvailability = 2
WHERE Type IN (SELECT build.Type FROM Improvements improve, Builds build
WHERE ( build.ImprovementType = improve.Type
	AND improve.CreatedByGreatPerson = 1
));

-- Double
UPDATE Builds SET AIAvailability = 2
WHERE Type IN ('BUILD_WELL', 'BUILD_OFFSHORE_PLATFORM');


--
-- Availability: Buildings
--

UPDATE Buildings SET AIAvailability = 8;

UPDATE Buildings SET AIAvailability = 4
WHERE (Water = 1
	OR River = 1
	OR FreshWater = 1
	OR Hill = 1
	OR Flat = 1
	OR Mountain = 1
	OR NearbyMountainRequired = 1
	OR MutuallyExclusiveGroup = 1
	OR NoOccupiedUnhappiness = 1
	OR NearbyTerrainRequired IS NOT NULL
);

UPDATE Buildings SET AIAvailability = 4
WHERE (Type IN (SELECT BuildingType FROM Building_ResourceQuantityRequirements)
	OR Type IN (SELECT BuildingType FROM Building_LocalResourceOrs)
	OR Type IN (SELECT BuildingType FROM Building_LocalResourceAnds)
	--OR Type IN (SELECT BuildingType FROM Building_ResourceYieldModifiers)
);

UPDATE Buildings SET AIAvailability = 2
WHERE Type IN (SELECT building.Type
FROM Buildings building, BuildingClasses class
WHERE (building.BuildingClass = class.Type AND (
	   class.MaxGlobalInstances = 1
	OR class.MaxPlayerInstances = 1
	OR class.MaxTeamInstances = 1
)));


--
-- Building Priorities
--

INSERT OR IGNORE INTO Building_Flavors(BuildingType, FlavorType, Flavor)
SELECT building.Type, flavor.FlavorType, 2 * flavor.Flavor
FROM Buildings building, Buildings buildingDefault, BuildingClasses class, Building_Flavors flavor
WHERE ( buildingDefault.BuildingClass	= building.BuildingClass
	AND buildingDefault.Type			<> building.Type
	AND buildingDefault.BuildingClass	= class.Type
	AND buildingDefault.Type			= class.DefaultBuilding
	AND buildingDefault.Type			= flavor.BuildingType
);


--
-- Unit Flavors: update flavor types
--

DELETE FROM Unit_Flavors WHERE FlavorType = 'FLAVOR_RECON'	AND UnitType = 'UNIT_WARRIOR';
DELETE FROM Unit_Flavors WHERE FlavorType = 'FLAVOR_GOLD'	AND UnitType = 'UNIT_PRIVATEER';
DELETE FROM Unit_Flavors WHERE FlavorType = 'FLAVOR_AIR'	AND UnitType = 'UNIT_PARATROOPER';
DELETE FROM Unit_Flavors WHERE FlavorType IN ('FLAVOR_NAVAL', 'FLAVOR_NAVAL_RECON');

DELETE FROM Unit_Flavors WHERE UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_LIBURNA'				,
	'UNITCLASS_SHIP_OF_THE_LINE'	,
	'UNITCLASS_SCOUT'				,
	'UNITCLASS_SENTINEL'			,
	'UNITCLASS_LEVY'				,
	'UNITCLASS_SKIRMISHER'			,
	'UNITCLASS_CONSCRIPT'			,
	'UNITCLASS_PARATROOPER'			
));

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT unit.Type, 'FLAVOR_ANTI_MOBILE', 1
FROM Units unit, Unit_FreePromotions promo, UnitPromotions_UnitCombatMods modifier
WHERE (unit.Type = promo.UnitType AND promo.PromotionType = modifier.PromotionType)
	AND modifier.UnitCombatType IN ('UNITCOMBAT_MOUNTED', 'UNITCOMBAT_MOUNTED_ARCHER', 'UNITCOMBAT_ARMOR')
;

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_SOLDIER', 1
FROM Units WHERE Class IN (
	'UNITCLASS_WARRIOR'				,
	'UNITCLASS_SWORDSMAN'			,
	'UNITCLASS_LONGSWORDSMAN'		,
	'UNITCLASS_MUSKETMAN'			,
	'UNITCLASS_RIFLEMAN'			,
	'UNITCLASS_GREAT_WAR_INFANTRY'	,
	'UNITCLASS_INFANTRY'			,
	'UNITCLASS_MECHANIZED_INFANTRY'	
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_SIEGE', 1
FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_SIEGE'				
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_DEFENSE', 1
FROM Units WHERE Class IN (
	'UNITCLASS_BATTLESHIP'			,
	'UNITCLASS_CHARIOT_ARCHER'		,
	'UNITCLASS_IRONCLAD'			,
	'UNITCLASS_MISSILE_CRUISER'		,
	'UNITCLASS_SHIP_OF_THE_LINE'	
) OR Type IN (
	'UNIT_ARABIAN_CAMELARCHER'
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_NAVAL', 1
FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_NAVALMELEE'				
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_NAVAL_BOMBARDMENT', 1
FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_NAVALRANGED'				
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_NAVAL_RECON', 1
FROM Units WHERE Class IN (
	'UNITCLASS_TRIREME'				,
	'UNITCLASS_LIBURNA'				,
	'UNITCLASS_CARAVEL'				,
	'UNITCLASS_PRIVATEER'			,
	'UNITCLASS_DESTROYER'			,
	'UNITCLASS_MISSILE_DESTROYER'	
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_OFFENSE', 1
FROM Units WHERE Class IN (
	'UNITCLASS_ANTI_AIRCRAFT_GUN'	,
	'UNITCLASS_BATTLESHIP'			,
	'UNITCLASS_IRONCLAD'			,
	'UNITCLASS_MISSILE_CRUISER'		,
	'UNITCLASS_SHIP_OF_THE_LINE'	
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_RANGED', 1
FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_BOMBER'				
) OR Class IN (
	'UNITCLASS_GUIDED_MISSILE'
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT Type, 'FLAVOR_CITY_DEFENSE', 1
FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_ARCHER',
	'UNITCOMBAT_MOUNTED_ARCHER',
	'UNITCOMBAT_BOMBER'
) OR Class IN (
	'UNITCLASS_GATLINGGUN',
	'UNITCLASS_MACHINE_GUN'
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT unit.Type, flavor.Type, 1
FROM Units unit, Flavors flavor
WHERE unit.CombatClass IN (
	'UNITCOMBAT_RECON'			
) AND flavor.Type IN (
	'FLAVOR_HEALING'				,
	'FLAVOR_VANGUARD'				
);

INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT unit.Type, flavor.Type, 1
FROM Units unit, Flavors flavor
WHERE unit.Class IN (
	'UNITCLASS_SCOUT'				,
	'UNITCLASS_SENTINEL'			,
	'UNITCLASS_LEVY'				,
	'UNITCLASS_SKIRMISHER'			
) AND flavor.Type IN (
	'FLAVOR_RECON'					,
	'FLAVOR_DEFENSE'				,
	'FLAVOR_CONQUEST'				,
	'FLAVOR_CITY_DEFENSE'			
);


--
-- Unit Flavors: update flavor values
--

UPDATE Unit_Flavors SET Flavor = 8;

UPDATE Unit_Flavors SET Flavor = Flavor * 2
WHERE FlavorType IN ('FLAVOR_NAVAL', 'FLAVOR_NAVAL_RECON');


-- The "mobile" role involves flanking, which ranged units do not get a bonus for
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE (FlavorType = 'FLAVOR_MOBILE')
AND UnitType IN (SELECT Type FROM Units WHERE Range > 0);


-- Unique Units
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE UnitType IN (SELECT unit.Type FROM Units unit, UnitClasses class WHERE (
		unit.Class = class.Type
	AND unit.Type <> class.DefaultUnit
));

-- Vanguard
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE FlavorType IN ('FLAVOR_HEALING', 'FLAVOR_RECON', 'FLAVOR_DEFENSE')
AND UnitType IN (SELECT Type FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_RECON'
));

-- Naval Exploration
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE FlavorType = 'FLAVOR_NAVAL_RECON'
AND UnitType IN (SELECT Type FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_NAVALRANGED'
));

-- Naval Bombardment
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'
AND UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_GALLEY'				,
	'UNITCLASS_TRIREME'				,
	'UNITCLASS_GALLEASS'			
));

-- Ranged
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE FlavorType IN ('FLAVOR_DEFENSE', 'FLAVOR_CITY_DEFENSE')
AND UnitType IN (SELECT Type FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_ARCHER',
	'UNITCOMBAT_MOUNTED_ARCHER',
	'UNITCOMBAT_BOMBER'
));

-- Anti-Mobile
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE FlavorType = 'FLAVOR_ANTI_MOBILE';

-- Siege
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE (FlavorType = 'FLAVOR_OFFENSE' OR FlavorType = 'FLAVOR_SIEGE')
AND UnitType IN (SELECT Type FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_SIEGE'
));

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE (FlavorType = 'FLAVOR_DEFENSE' OR FlavorType = 'FLAVOR_RANGED')
AND UnitType IN (SELECT Type FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_SIEGE'
));

-- Strategic Default
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE UnitType IN (SELECT unit.Type FROM Units unit, UnitClasses class
WHERE (	unit.Class = class.Type AND class.DefaultUnit IN (SELECT UnitType FROM Unit_ResourceQuantityRequirements)
));

-- Strategic
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE FlavorType IN ('FLAVOR_DEFENSE', 'FLAVOR_CITY_DEFENSE')
AND UnitType IN (SELECT UnitType FROM Unit_ResourceQuantityRequirements);

-- Spaceship parts
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE FlavorType = 'FLAVOR_SPACESHIP';

-- Fighters
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE FlavorType = 'FLAVOR_AIR'
AND UnitType IN (SELECT Type FROM Units WHERE CombatClass IN (
	'UNITCOMBAT_FIGHTER'
));


-- Specific units

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 4, 0)
WHERE UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_SETTLER'				
));

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 2, 0)
WHERE UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_WORKER'				,
	'UNITCLASS_WORKBOAT'			,
	'UNITCLASS_MUSKETMAN'			,
	'UNITCLASS_ATOMIC_BOMB'			,
	'UNITCLASS_NUCLEAR_MISSILE'		,
	'UNITCLASS_MECH'
));

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE (FlavorType = 'FLAVOR_OFFENSE' OR FlavorType = 'FLAVOR_DEFENSE')
AND UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_TRIPLANE'			,
	'UNITCLASS_FIGHTER'				,
	'UNITCLASS_JET_FIGHTER'
));

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE (FlavorType = 'FLAVOR_OFFENSE')
AND UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_ANTI_TANK_GUN'		,
	'UNITCLASS_ANTI_AIRCRAFT_GUN'	,
	'UNITCLASS_MOBILE_SAM'
));

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 2, 0)
WHERE (FlavorType = 'FLAVOR_DEFENSE')
AND UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_WARRIOR'				,
	'UNITCLASS_MARINE'
));

UPDATE Unit_Flavors SET Flavor = ROUND(Flavor / 4, 0)
WHERE (FlavorType <> 'FLAVOR_HEALING')
AND UnitType IN (SELECT Type FROM Units WHERE Class IN (
	'UNITCLASS_CONSCRIPT',
	'UNITCLASS_PARATROOPER'
));

/*
UPDATE Unit_Flavors SET Flavor = ROUND(Flavor * 0.5, 0)
WHERE FlavorType = 'FLAVOR_DEFENSE' 
AND UnitType IN (SELECT UnitType FROM Unit_ResourceQuantityRequirements);
*/


UPDATE LoadedFile SET Value=1 WHERE Type='GEAI_yEnd.sql';