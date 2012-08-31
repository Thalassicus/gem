/*

You can change most options in this file at any time, unless indicated otherwise.
Changes take effect the next time you start or load a game with CiVUP/VEM.

For example, if you are using the "Citystate Diplomacy" mod change the lines that read:

	INSERT INTO Civup (Type, Value)
	VALUES ('USING_CSD', 0);

...change to...

	INSERT INTO Civup (Type, Value)
	VALUES ('USING_CSD', 1);

Then start a new game.

*/


-------------
-- Options --
-------------


/*
CityState Diplomacy Mod Compatibility
Change this ONLY before starting a game, NOT mid-game.
0 = not using CSD and VEM
1 = using CSD and VEM
*/
INSERT INTO Civup (Type, Value)
VALUES ('USING_CSD', 0);


/*
Barbarians Upgrade
1 = barbarians upgrade in camps
0 = barbarians do not upgrade 
INSERT INTO Civup (Type, Value)
VALUES ('BARBARIANS_UPGRADE', 1);
*/


/*
Barbarians Heal
1 = barbarians heal when fortified
0 = barbarians do not heal
INSERT INTO Civup (Type, Value)
VALUES ('BARBARIANS_HEAL', 1);
*/


/*
Human-vs-barbarian combat bonus.
UPDATE HandicapInfos SET BarbarianBonus = 150 WHERE Type = 'HANDICAP_SETTLER';
UPDATE HandicapInfos SET BarbarianBonus =  50 WHERE Type = 'HANDICAP_CHIEFTAIN';
UPDATE HandicapInfos SET BarbarianBonus =  20 WHERE Type = 'HANDICAP_WARLORD';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_PRINCE';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_KING';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_EMPEROR';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_IMMORTAL';
UPDATE HandicapInfos SET BarbarianBonus =  15 WHERE Type = 'HANDICAP_DEITY';
*/


/*
Minimum distance (in tiles) between cities.
*/
UPDATE Defines
SET Value = 2
WHERE Name = 'MIN_CITY_RANGE';


/*
These add information to tooltips about how important the AI considers
building specific units/buildings and choosing particular policies/techs.
1 = display priorities
0 = hide priorities
*/
UPDATE Civup SET Value = 1 WHERE Type = 'SHOW_AI_PRIORITY_UNITS';
UPDATE Civup SET Value = 1 WHERE Type = 'SHOW_AI_PRIORITY_BUILDINGS';
UPDATE Civup SET Value = 1 WHERE Type = 'SHOW_AI_PRIORITY_POLICIES';
UPDATE Civup SET Value = 1 WHERE Type = 'SHOW_AI_PRIORITY_TECHS';