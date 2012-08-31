--

/*
UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Patronage[ENDCOLOR] enhances the benefits of City-State friendship.[NEWLINE][NEWLINE][COLOR_POSITIVE_TEXT]Opener[ENDCOLOR][NEWLINE]+50% [ICON_PRODUCTION] Production for Diplomacy Units.[NEWLINE][NEWLINE][COLOR_POSITIVE_TEXT]Finisher[ENDCOLOR] [COLOR_GREY](finish all policies in this tree)[ENDCOLOR][NEWLINE]Rival [ICON_INFLUENCE] Influence with City-States decreases 10% faster.'
WHERE Tag = 'TXT_KEY_POLICY_BRANCH_PATRONAGE_HELP' AND EXISTS (SELECT * FROM Civup WHERE Type='USING_CSD' AND Value=1);

UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Aesthetics[ENDCOLOR][NEWLINE] Minimum [ICON_INFLUENCE] Influence level with all City-States is 20.[NEWLINE]+20 onetime [ICON_INFLUENCE] Influence boost.[NEWLINE]+1 [ICON_HAPPINESS_1] Happiness from [COLOR_POSITIVE_TEXT]Villas[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_POLICY_AESTHETICS_HELP' AND EXISTS (SELECT * FROM Civup WHERE Type='USING_CSD' AND Value=1);

UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Philanthropy[ENDCOLOR][NEWLINE][ICON_INFLUENCE] Influence with City-States degrades 25% slower than normal.[NEWLINE]+20% [ICON_GOLD] Gold from the [COLOR_POSITIVE_TEXT]Summer Palace[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_POLICY_PHILANTHROPY_HELP' AND EXISTS (SELECT * FROM Civup WHERE Type='USING_CSD' AND Value=1);

UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Cultural Diplomacy[ENDCOLOR][NEWLINE]+1 [ICON_HAPPINESS_1] Happiness for each City-State friend, and +2 for each ally.[NEWLINE]3 [ICON_CULTURE] Culture from the [COLOR_POSITIVE_TEXT]Foreign Office[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP' AND EXISTS (SELECT * FROM Civup WHERE Type='USING_CSD' AND Value=1);

UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Free Trade[ENDCOLOR][NEWLINE]2 Free [COLOR_POSITIVE_TEXT]Envoys[ENDCOLOR].[NEWLINE]City-state friends and allies increase [ICON_PRODUCTION] Production in your cities.'
WHERE Tag = 'TXT_KEY_POLICY_TRADE_PACT_HELP' AND EXISTS (SELECT * FROM Civup WHERE Type='USING_CSD' AND Value=1);

UPDATE Language_en_US
SET Text = '[COLOR_POSITIVE_TEXT]Scholasticism[ENDCOLOR][NEWLINE]City-State allies provide [ICON_RESEARCH] Science.[NEWLINE]+5% [ICON_RESEARCH] Science from [COLOR_POSITIVE_TEXT]Embassies[ENDCOLOR].'
WHERE Tag = 'TXT_KEY_POLICY_SCHOLASTICISM_HELP' AND EXISTS (SELECT * FROM Civup WHERE Type='USING_CSD' AND Value=1);

*/