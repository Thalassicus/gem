--

UPDATE Worlds SET FogTilesPerBarbarianCamp = FogTilesPerBarbarianCamp * 0.5;

INSERT INTO Unit_FreePromotions (UnitType, PromotionType)
SELECT DISTINCT Type, 'PROMOTION_RANGE'
FROM Units WHERE Domain IN (
	'DOMAIN_SEA'
) AND Type IN (
	SELECT UnitType
	FROM Civilization_UnitClassOverrides
	WHERE CivilizationType = 'CIVILIZATION_BARBARIAN'
);