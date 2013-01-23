-- 

INSERT INTO Building_ResourceYieldChanges (BuildingType, ResourceType, YieldType, Yield)
SELECT 'BUILDING_ENGLISH_STEAM_MILL', res.Type, yield.Type, 1
FROM Resources res, Yields yield
WHERE res.Happiness <> 0 AND yield.Type IN ('YIELD_GOLD', 'YIELD_PRODUCTION');

INSERT INTO Trait_FreeResourceFirstXCities (TraitType, ResourceType, ResourceQuantity, NumCities)
SELECT Type, 'RESOURCE_IRON', 2, 1
FROM Traits WHERE Type IN (
	'TRAIT_CAPITAL_BUILDINGS_CHEAPER'	,
	'TRAIT_VIKING_FURY'					,
	'TRAIT_FIGHT_WELL_DAMAGED'			
);

INSERT INTO Trait_FreeResourceFirstXCities (TraitType, ResourceType, ResourceQuantity, NumCities)
SELECT Type, 'RESOURCE_HORSE', 2, 1
FROM Traits WHERE Type IN (
	'TRAIT_TERROR'						,
	'TRAIT_AMPHIB_WARLORD'				,
	'TRAIT_WONDER_BUILDER'				,
	'TRAIT_EXTRA_BELIEF'				,
	'TRAIT_CITY_STATE_FRIENDSHIP'		
);

UPDATE Units SET GoodyHutUpgradeUnitClass = NULL WHERE Type IN (
	'UNIT_PERSIAN_IMMORTAL'			,
	'UNIT_HUN_HORSE_ARCHER'			,
	'UNIT_IROQUOIAN_MOHAWKWARRIOR'	,
	'UNIT_BABYLONIAN_BOWMAN'		,
	'UNIT_MAYAN_ATLATLIST'			
);