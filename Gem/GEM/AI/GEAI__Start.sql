-- 


UPDATE Building_Flavors SET Flavor = 8;

UPDATE Building_Flavors SET Flavor = 16
WHERE BuildingType IN (SELECT building.Type
FROM Buildings building, BuildingClasses class
WHERE (building.BuildingClass = class.Type AND (
	   class.MaxGlobalInstances = 1
	OR class.MaxPlayerInstances = 1
	OR class.MaxTeamInstances = 1
)));


UPDATE LoadedFile SET Value=1 WHERE Type='GEAI__Start.sql';