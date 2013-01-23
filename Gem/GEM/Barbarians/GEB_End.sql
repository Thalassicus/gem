--

UPDATE Worlds SET FogTilesPerBarbarianCamp = FogTilesPerBarbarianCamp * 0.25;

/*
This GEB_End.sql data automatically created by:
Barbarians tab of GEM_Details.xls spreadsheet in mod folder.
*/
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn = 100, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   5, BarbarianSeaTargetRange =  10 WHERE Type = 'HANDICAP_SETTLER';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =  75, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   5, BarbarianSeaTargetRange =  10 WHERE Type = 'HANDICAP_CHIEFTAIN';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =  50, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   5, BarbarianSeaTargetRange =  10 WHERE Type = 'HANDICAP_WARLORD';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =  20, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   5, BarbarianSeaTargetRange =  12 WHERE Type = 'HANDICAP_PRINCE';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =  15, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   6, BarbarianSeaTargetRange =  15 WHERE Type = 'HANDICAP_KING';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =  10, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   7, BarbarianSeaTargetRange =  18 WHERE Type = 'HANDICAP_EMPEROR';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =   5, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =   8, BarbarianSeaTargetRange =  20 WHERE Type = 'HANDICAP_IMMORTAL';
UPDATE HandicapInfos SET EarliestBarbarianReleaseTurn =   0, BarbCampGold = 100, BarbSpawnMod =   0, AIBarbarianBonus =  20, BarbarianLandTargetRange =  10, BarbarianSeaTargetRange =  22 WHERE Type = 'HANDICAP_DEITY';


/*
INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT DISTINCT Type, 'PROMOTION_RANGE'
FROM Units WHERE Domain IN (
	'DOMAIN_SEA'
) AND Type IN (
	SELECT UnitType
	FROM Civilization_UnitClassOverrides
	WHERE CivilizationType = 'CIVILIZATION_BARBARIAN'
);
*/

UPDATE Units
SET RangedCombat = RangedCombat - 1
WHERE Type IN (
	'UNIT_BARBARIAN_ARCHER'
);

INSERT INTO Civilization_UnitClassOverrides (UnitClassType, CivilizationType)
SELECT Type, 'CIVILIZATION_BARBARIAN'
FROM UnitClasses WHERE Type IN (
	'UNITCLASS_SENTINAL',
	'UNITCLASS_LEVY',
	'UNITCLASS_SKIRMISHER',
	'UNITCLASS_CONSCRIPT',
	'UNITCLASS_PARATROOPER',
	'UNITCLASS_SHIP_OF_THE_LINE',
	'UNITCLASS_DESTROYER',
	'UNITCLASS_MISSILE_DESTROYER'
);

INSERT INTO Unit_AITypes (UnitType, UnitAIType)
SELECT Type, 'UNITAI_ATTACK'
FROM Units WHERE Type IN (
	'UNIT_BARBARIAN_PIKEMAN',
	'UNIT_BARBARIAN_CROSSBOWMAN',
	'UNIT_BARBARIAN_LONGSWORDSMAN',
	'UNIT_BARBARIAN_HORSEMAN',
	'UNIT_BARBARIAN_KNIGHT'
);

INSERT INTO Unit_AITypes (UnitType, UnitAIType)
SELECT Type, 'UNITAI_FAST_ATTACK'
FROM Units WHERE Type IN (
	'UNIT_BARBARIAN_HORSEMAN',
	'UNIT_BARBARIAN_KNIGHT'
);

INSERT INTO Unit_AITypes (UnitType, UnitAIType)
SELECT Type, 'UNITAI_DEFENSE'
FROM Units WHERE Type IN (
	'UNIT_BARBARIAN_PIKEMAN',
	'UNIT_BARBARIAN_CROSSBOWMAN',
	'UNIT_BARBARIAN_LONGSWORDSMAN',
	'UNIT_BARBARIAN_HORSEMAN',
	'UNIT_BARBARIAN_KNIGHT'
);

INSERT INTO Unit_AITypes (UnitType, UnitAIType)
SELECT Type, 'UNITAI_COUNTER'
FROM Units WHERE Type IN (
	'UNIT_BARBARIAN_PIKEMAN'
);

INSERT INTO Unit_AITypes (UnitType, UnitAIType)
SELECT Type, 'UNITAI_RANGED'
FROM Units WHERE Type IN (
	'UNIT_BARBARIAN_CROSSBOWMAN',
	'UNIT_BARBARIAN_CHARIOT_ARCHER'
);

INSERT INTO Unit_AITypes (UnitType, UnitAIType)
SELECT Type, 'UNITAI_ATTACK_SEA'
FROM Units WHERE Type IN (
	'UNIT_BARBARIAN_TRIREME'
);

INSERT INTO Unit_ClassUpgrades (UnitType, UnitClassType)
SELECT 'UNIT_BARBARIAN_'||SUBSTR(UnitType, 6), UnitClassType
FROM Unit_ClassUpgrades
WHERE UnitType IN (
	'UNIT_PIKEMAN',
	'UNIT_CROSSBOWMAN',
	'UNIT_LONGSWORDSMAN',
	'UNIT_HORSEMAN',
	'UNIT_KNIGHT',
	'UNIT_TRIREME'
);

/*
INSERT INTO Unit_Flavors (UnitType, FlavorType, Flavor)
SELECT 'UNIT_BARBARIAN_'||SUBSTR(UnitType, 6), FlavorType, Flavor
FROM Unit_Flavors
WHERE UnitType IN (
	'UNIT_PIKEMAN',
	'UNIT_CROSSBOWMAN',
	'UNIT_LONGSWORDSMAN',
	'UNIT_MUSKETMAN',
	'UNIT_HORSEMAN',
	'UNIT_KNIGHT',
	'UNIT_TRIREME',
	'UNIT_GALLEASS'
);
*/

INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT 'UNIT_BARBARIAN_'||SUBSTR(UnitType, 6), PromotionType
FROM Unit_FreePromotions
WHERE UnitType IN (
	'UNIT_PIKEMAN',
	'UNIT_CROSSBOWMAN',
	'UNIT_LONGSWORDSMAN',
	'UNIT_MUSKETMAN',
	'UNIT_HORSEMAN',
	'UNIT_KNIGHT',
	'UNIT_TRIREME'
);

INSERT INTO Unit_ResourceQuantityRequirements (UnitType, ResourceType)
SELECT 'UNIT_BARBARIAN_'||SUBSTR(UnitType, 6), ResourceType
FROM Unit_ResourceQuantityRequirements
WHERE UnitType IN (
	'UNIT_PIKEMAN',
	'UNIT_CROSSBOWMAN',
	'UNIT_LONGSWORDSMAN',
	'UNIT_MUSKETMAN',
	'UNIT_HORSEMAN',
	'UNIT_KNIGHT',
	'UNIT_TRIREME'
);


UPDATE LoadedFile SET Value=1 WHERE Type='GEB_End.sql';