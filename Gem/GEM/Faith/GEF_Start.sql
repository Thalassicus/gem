--

/*
UPDATE Beliefs
SET GoldPerFirstCityConversion = 2 * GoldPerFirstCityConversion
WHERE GoldPerFirstCityConversion > 0;
*/

UPDATE Beliefs
SET Follower = 1
WHERE Type IN (
	'BELIEF_PEACE_GARDENS',
	'BELIEF_ASCETISM',
	'BELIEF_RELIGIOUS_CENTER'
);