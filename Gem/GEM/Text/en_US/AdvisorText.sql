--' EN_US/AdvisorText.sql
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-03-15'), 'TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON', 'We should continue exploring the world to discover ancient ruins, natural wonders, and other civilizations! Send more units on recon missions.', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-03-15'), 'TXT_KEY_ECONOMICAISTRATEGY_NEED_RECON_SEA', 'We need to continue exploring the seas to find new continents to settle. Send more ships on recon missions.', '', '');

UPDATE LoadedFile SET Value=1 WHERE Type='GEM_AdvisorText.sql';