-- 

--
-- Obsoletes
--

UPDATE Units
SET ObsoleteTech = (
	SELECT unitNew.PrereqTech
	FROM Unit_ClassUpgrades upgrade, Units unitOld, Units unitNew, UnitClasses unitClass
	WHERE (	unitOld.Type	= Units.Type
		AND unitOld.Type	= upgrade.UnitType
		AND unitClass.Type	= upgrade.UnitClassType
		AND unitNew.Type	= unitClass.DefaultUnit
	)
) WHERE Type IN (SELECT UnitType FROM Unit_ClassUpgrades);

UPDATE Technologies SET Cost = 999 WHERE Type = 'TECH_AGRICULTURE';