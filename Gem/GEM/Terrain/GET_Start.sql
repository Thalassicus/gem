UPDATE Resources
SET TechCityTrade = "TECH_ANIMAL_HUSBANDRY"
WHERE TechCityTrade = "TECH_TRAPPING";

DELETE FROM Terrain_RiverYieldChanges;

DELETE FROM Feature_RiverYieldChanges;

INSERT INTO Improvement_RiverSideYields (ImprovementType, YieldType, Yield)
SELECT Type, 'YIELD_GOLD', 1 from Improvements
WHERE NOT Type IN (
	'IMPROVEMENT_CITY_RUINS',
	'IMPROVEMENT_BARBARIAN_CAMP',
	'IMPROVEMENT_GOODY_HUT',
	'IMPROVEMENT_FISHING_BOATS',
	'IMPROVEMENT_OFFSHORE_PLATFORM'
);

INSERT OR REPLACE INTO Improvement_ResourceTypes(ImprovementType, ResourceType) 
SELECT improve.Type, res.Type
FROM Improvements improve, Resources res
WHERE (
	(improve.CreatedByGreatPerson = 1 OR improve.SpecificCivRequired = 1)
	AND NOT res.TechCityTrade = 'TECH_SAILING'
	AND NOT improve.Type = 'IMPROVEMENT_POLDER'
);

INSERT OR REPLACE INTO Improvement_ResourceType_Yields(ImprovementType, ResourceType, YieldType, Yield) 
SELECT improve.Type, resTypes.ResourceType, resYields.YieldType, resYields.Yield 
FROM Improvements improve, Improvement_ResourceTypes resTypes, Improvement_ResourceType_Yields resYields, Improvements impBasic
WHERE (improve.CreatedByGreatPerson = 1 OR improve.SpecificCivRequired = 1)
AND resTypes.ImprovementType = improve.Type
AND resTypes.ResourceType = resYields.ResourceType
AND resYields.ImprovementType = impBasic.Type
AND NOT (impBasic.CreatedByGreatPerson = 1 OR impBasic.SpecificCivRequired = 1);