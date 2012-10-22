--

--
-- Cost
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
					AND YieldType = 'YIELD_HAPPINESS';
*/


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
SET GreatPeopleRateChange = 2
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