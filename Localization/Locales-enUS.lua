-- ********************************************************************************
-- Data Broker Volume Control (Broker_Volume)
-- A volume control for Data Broker.
-- By: Shenton
--
-- Locales-enUS.lua
-- ********************************************************************************

local L = LibStub("AceLocale-3.0"):NewLocale("BrokerVolume", "enUS", true);

if L then
L["Broker Volume"] = true;
L["Master volume"] = true;
L["Effects volume"] = true;
L["Music volume"] = true;
L["Ambience volume"] = true;
L["Dialog volume"] = true;
L["Mute"] = true;
L["Close"] = true;
L["Options"] = true;
L["Show/Hide minimap icon"] = true;
L["Blizlike mute"] = true;
L["Enable Sound"] = true;
L["Disable Sound"] = true;
L["Queued volume boost"] = true;
L["You must provide a number between 0 and 100."] = true;
L["Master volume set to"] = true;
L["Effects volume set to"] = true;
L["Music volume set to"] = true;
L["Ambience volume set to"] = true;
L["Dialog volume set to"] = true;
L["Queued volume is enabled but all sound is currently disabled."] = true;
L["Minimap icon is hidden if you want to show it back use: /bv show or /brokervolume show"] = true;
L["|cffc79c6eLeft-Click: |cff33ff99Mute sound\n|cffc79c6eRight-Click: |cff33ff99Display the volume sliders\n|cffc79c6eShift+Right-Click: |cff33ff99Display the configuration menu"] = true;
L["Command usage: /bv, /brokervolume"] = true;
L["    |cffc79c6eshow|r, show the minimap icon."] = true;
L["    |cffc79c6elevels|r, display volume levels."] = true;
L["    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, will set the volume for the given category."] = true;
L["|cffffffff%s|r\nUse mouse wheel to change value."] = true;
L["Master: |cffc79c6e%s|r%% - Effects: |cffc79c6e%s|r%% - Music: |cffc79c6e%s|r%% - Ambience: |cffc79c6e%s|r%% - Dialog: |cffc79c6e%s|r%%"] = true;
L["No tooltip mode"] = true;
L["Background Sound"] = true;
L["Volume step"] = true;
L["Sound options"] = true;
L["Sound Effects"] = true;
L["Enable Pet Sounds"] = true;
L["Emote Sounds"] = true;
L["Music"] = true;
L["Pet Battle Music"] = true;
L["Ambient Sounds"] = true;
L["Error Speech"] = true;
L["Enable Reverb"] = true;
L["Distance Filtering"] = true;
L["Death Knight Voices"] = true;
L["Dialog"] = true;
L["Loop Music"] = true;
L["Volume"] = true;
L["Enabled"] = true;
L["Playback"] = true;
L["Other options"] = true;
L["Combat Volume"] = true;
L["Sound output"] = true;
end
