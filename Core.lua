-- ********************************************************************************
-- Data Broker Volume Control (Broker_Volume)
-- A volume control for Data Broker.
-- By: Shenton
--
-- Core.lua
-- ********************************************************************************

--[[
1.7.1 Changelog

Toc bump
]]--

local LibStub = LibStub;

-- Ace libs (<3)
local A = LibStub("AceAddon-3.0"):NewAddon("BrokerVolume", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("BrokerVolume", false);
A.L = L;

-- LibDBIcon
A.icon = LibStub("LibDBIcon-1.0");

-- Addon global
_G["BrokerVolumeGlobal"] = A;

-- Globals
local string = string;
local floor = floor;
local math = math;
-- GLOBALS: UIDropDownMenu_AddButton, UIDROPDOWNMENU_MENU_VALUE, CloseDropDownMenus, DEFAULT_CHAT_FRAME, GetCVar
-- GLOBALS: SOUND_DISABLED, GameTooltip, ToggleDropDownMenu, IsShiftKeyDown, CreateFrame, PlaySound, SetCVar
-- GLOBALS: GetLFGProposal, GetCursorPosition, UIParent, Sound_GameSystem_RestartSoundSystem, tonumber
-- GLOBALS: ENABLE_SOUND, ActionStatus:DisplayMessage, SOUND_EFFECTS_ENABLED, SOUND_EFFECTS_DISABLED
-- GLOBALS: MUSIC_ENABLED, MUSIC_DISABLED, AudioOptionsFrame_AudioRestart

-- ********************************************************************************
-- Variables
-- ********************************************************************************

-- AddOn version
A.version = GetAddOnMetadata("Broker_Volume", "Version");

-- Text colors
A.color =
{
    RED = "|cffff3333",
    YELLOW = "|cffffff33",
    ORANGE = "|cffff9933",
    GREEN = "|cff33ff99",
    WHITE = "|cffffffff",
    GRAY = "|cff999999",
    WARRIOR = "|cffc79c6e",
    RESET = "|r",
};

-- ********************************************************************************
-- Dropdown menu
-- ********************************************************************************

-- Common mixin
BrokerVolumeSliderButtonTemplateMixin = {};

function BrokerVolumeSliderButtonTemplateMixin:OnLoad()
    local function UpdateText(slider, value, isMouse)
        self.Text:SetText(value);
    end

    self.Slider:RegisterPropertyChangeHandler("OnValueChanged", UpdateText);
end

function BrokerVolumeSliderButtonTemplateMixin:OnSetOwningButton()
    self.Slider:UpdateVisibleState();
end

BrokerVolumeSliderVolumeButtonTemplateMixin = {};

function BrokerVolumeSliderVolumeButtonTemplateMixin:OnLoad()
    local function UpdateText(slider, value, isMouse)
        local color = A:ColorGradient(value);
        value = FormatPercentage(value / 100, true);
        self.Text:SetText(color..value);
    end

    self.Slider:RegisterPropertyChangeHandler("OnValueChanged", UpdateText);
end

function BrokerVolumeSliderVolumeButtonTemplateMixin:OnSetOwningButton()
    self.Slider:UpdateVisibleState();
end

-- Volume Step mixin
BrokerVolumeVolumeStepSliderMixin = {};

local function VolumeStepSliderAccessor()
    return A.db.profile.volumeStep;
end

local function VolumeStepSliderMutator(val)
    A.db.profile.volumeStep = A:Round(val);
end

function BrokerVolumeVolumeStepSliderMixin:OnLoad()
    self:SetAccessorFunction(VolumeStepSliderAccessor);
    self:SetMutatorFunction(VolumeStepSliderMutator);
end

-- Queued Volume mixin
BrokerVolumeQueuedVolumeSliderMixin = {};

local function QueuedVolumeSliderAccessor()
    return A.db.profile.queuedVolume.volumeLevel*100;
end

local function QueuedVolumeSliderMutator(val)
    A.db.profile.queuedVolume.volumeLevel = A:Round(val/100, 2);
end

function BrokerVolumeQueuedVolumeSliderMixin:OnLoad()
    self:SetAccessorFunction(QueuedVolumeSliderAccessor);
    self:SetMutatorFunction(QueuedVolumeSliderMutator);
end

-- Combat Volume mixin
BrokerVolumeCombatVolumeSliderMixin = {};

local function CombatVolumeSliderAccessor()
    return A.db.profile.combatVolumeLevel*100;
end

local function CombatVolumeSliderMutator(val)
    A.db.profile.combatVolumeLevel = A:Round(val/100, 2);
end

function BrokerVolumeCombatVolumeSliderMixin:OnLoad()
    self:SetAccessorFunction(CombatVolumeSliderAccessor);
    self:SetMutatorFunction(CombatVolumeSliderMutator);
end

--- The dropdown menu structure function
-- @usage Called by ToggleDropDownMenu()
-- @param self Frame object
-- @param level Nesting level
local function DropdownMenu(self, level)
    if ( not level ) then return; end

    local info = self.info;

    if ( level == 1 ) then
        -- Sound Options title
        info.isTitle = 1;
        info.text = L["Sound options"];
        info.notCheckable = 1;
        info.icon = nil;
        info.disabled = nil;
        info.iconOnly = nil;
        info.iconInfo = nil;
        info.hasArrow = nil;
        info.customFrame = nil;
        UIDropDownMenu_AddButton(info, level);

        -- Set options
        info.keepShownOnClick = 1;
        info.isTitle = nil;
        info.notCheckable = nil;
        info.isNotRadio = 1;
        info.disabled = nil;
        info.notClickable = nil;

        -- Blizzlike mute
        info.text = L["Blizlike mute"];
        info.checked = A.db.profile.blizlike;
        info.func = function() A.db.profile.blizlike = not A.db.profile.blizlike; end;
        UIDropDownMenu_AddButton(info, level);

        -- Step (menu)
        info.text = L["Volume step"];
        info.value = "VOLUMESTEP";
        info.hasArrow = 1;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- Sound options (menu)
        info.text = L["Playback"];
        info.value = "SOUNDOPTIONS";
        info.hasArrow = 1;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- Sound output (menu)
        info.text = L["Sound output"];
        info.value = "SOUNDOUTPUT";
        info.hasArrow = 1;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- Separator
        info.text = "";
        info.isTitle = 1;
        info.hasArrow = nil;
        info.notClickable = 1;
        info.iconOnly = 1;
        info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
        info.iconInfo =
        {
            tCoordLeft = 0,
            tCoordRight = 1,
            tCoordTop = 0,
            tCoordBottom = 1,
            tSizeX = 0,
            tSizeY = 8,
            tFitDropDownSizeX = 1,
        };
        UIDropDownMenu_AddButton(info, level);

        -- Queued volume title
        info.isTitle = 1;
        info.text = L["Queued volume boost"];
        info.notCheckable = 1;
        info.icon = nil;
        info.iconOnly = nil;
        info.iconInfo = nil;
        UIDropDownMenu_AddButton(info, level);

        -- Queued volume enabled
        info.text = L["Enabled"];
        info.checked = A.db.profile.queuedVolume.enable;
        info.notClickable = nil;
        info.notCheckable = nil;
        info.isTitle = nil;
        info.disabled = nil;
        info.func = function() A.db.profile.queuedVolume.enable = not A.db.profile.queuedVolume.enable; end;
        UIDropDownMenu_AddButton(info, level);

        -- BG sound
        info.text = L["Background Sound"];
        info.checked = A.db.profile.queuedVolume.enableBG;
        info.func = function() A.db.profile.queuedVolume.enableBG = not A.db.profile.queuedVolume.enableBG; end;
        UIDropDownMenu_AddButton(info, level);

        -- Queued volume (menu)
        info.text = L["Volume"];
        info.value = "QUEUEDVOLUME";
        info.hasArrow = 1;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- Separator
        info.text = "";
        info.isTitle = 1;
        info.notClickable = 1;
        info.iconOnly = 1;
        info.hasArrow = nil;
        info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
        info.iconInfo =
        {
            tCoordLeft = 0,
            tCoordRight = 1,
            tCoordTop = 0,
            tCoordBottom = 1,
            tSizeX = 0,
            tSizeY = 8,
            tFitDropDownSizeX = 1,
        };
        UIDropDownMenu_AddButton(info, level);

        -- Combat volume title
        info.isTitle = 1;
        info.notClickable = nil;
        info.notCheckable = nil;
        info.icon = nil;
        info.iconOnly = nil;
        info.iconInfo = nil;
        info.isTitle = 1;
        info.text = L["Combat Volume"];
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- Combat volume enabled
        info.text = L["Enabled"];
        info.checked = A.db.profile.combatVolume;
        info.notClickable = nil;
        info.notCheckable = nil;
        info.isTitle = nil;
        info.disabled = nil;
        info.func = function() A.db.profile.combatVolume = not A.db.profile.combatVolume; end;
        UIDropDownMenu_AddButton(info, level);

        -- Step (menu)
        info.text = L["Volume"];
        info.value = "COMBATVOLUME";
        info.hasArrow = 1;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- Separator
        info.text = "";
        info.isTitle = 1;
        info.notClickable = 1;
        info.iconOnly = 1;
        info.hasArrow = nil;
        info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
        info.iconInfo =
        {
            tCoordLeft = 0,
            tCoordRight = 1,
            tCoordTop = 0,
            tCoordBottom = 1,
            tSizeX = 0,
            tSizeY = 8,
            tFitDropDownSizeX = 1,
        };
        UIDropDownMenu_AddButton(info, level);

        -- Other options title
        info.isTitle = 1;
        info.notClickable = nil;
        info.notCheckable = nil;
        info.icon = nil;
        info.iconOnly = nil;
        info.iconInfo = nil;
        info.isTitle = 1;
        info.text = L["Other options"];
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);

        -- No tooltip mode
        info.text = L["No tooltip mode"];
        info.checked = A.db.profile.noTooltipMode;
        info.disabled = nil;
        info.isTitle = nil;
        info.notCheckable = nil;
        info.func = function()
            A.db.profile.noTooltipMode = not A.db.profile.noTooltipMode;
            A:SetTooltipMode();
        end;
        UIDropDownMenu_AddButton(info, level);

        -- Show/hide minimap icon
        info.text = L["Show/Hide minimap icon"];
        info.checked = not A.db.profile.minimap.hide;
        info.func = function()
            A.db.profile.minimap.hide = not A.db.profile.minimap.hide;
            A:ShowHideMinimap();
        end;
        UIDropDownMenu_AddButton(info, level);

        -- Separator
        info.text = "";
        info.isTitle = 1;
        info.notClickable = 1;
        info.iconOnly = 1;
        info.notCheckable = 1;
        info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
        info.iconInfo =
        {
            tCoordLeft = 0,
            tCoordRight = 1,
            tCoordTop = 0,
            tCoordBottom = 1,
            tSizeX = 0,
            tSizeY = 8,
            tFitDropDownSizeX = 1,
        };
        UIDropDownMenu_AddButton(info, level);

        -- Close
        info.text = L["Close"];
        info.hasArrow = nil;
        info.keepShownOnClick = nil;
        info.icon = nil;
        info.iconOnly = nil;
        info.iconInfo = nil;
        info.notCheckable = 1;
        info.isTitle = nil;
        info.notClickable = nil;
        info.disabled = nil;
        info.func = function() CloseDropDownMenus(); end;
        UIDropDownMenu_AddButton(info, level);
    elseif ( level == 2 ) then
        if ( UIDROPDOWNMENU_MENU_VALUE == "VOLUMESTEP" ) then
            info.text = nil;
            info.notCheckable = nil;
            info.isNotRadio = nil;
            info.disabled = nil;
            info.leftPadding = nil;
            info.checked = nil;
            info.func = nil;
            info.customFrame = BrokerVolumeVolumeStepSlider;
            UIDropDownMenu_AddButton(info, level);
        elseif ( UIDROPDOWNMENU_MENU_VALUE == "SOUNDOPTIONS" ) then
            -- Sound Effects
            info.leftPadding = nil;
            info.notCheckable = nil;
            info.isNotRadio = nil;
            info.customFrame = nil;
            info.text = L["Sound Effects"];
            info.checked = A:GetCVarBool("Sound_EnableSFX");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableSFX") ) then
                    SetCVar("Sound_EnableSFX", 0, "Doh!");
                else
                    SetCVar("Sound_EnableSFX", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Enable Pet Sounds
            info.leftPadding = 10;
            info.disabled = not A:GetCVarBool("Sound_EnableSFX");
            info.text = L["Enable Pet Sounds"];
            info.checked = A:GetCVarBool("Sound_EnablePetSounds");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnablePetSounds") ) then
                    SetCVar("Sound_EnablePetSounds", 0, "Doh!");
                else
                    SetCVar("Sound_EnablePetSounds", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Emote Sounds
            info.leftPadding = 10;
            info.disabled = not A:GetCVarBool("Sound_EnableSFX");
            info.text = L["Emote Sounds"];
            info.checked = A:GetCVarBool("Sound_EnableEmoteSounds");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableEmoteSounds") ) then
                    SetCVar("Sound_EnableEmoteSounds", 0, "Doh!");
                else
                    SetCVar("Sound_EnableEmoteSounds", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Music
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Music"];
            info.checked = A:GetCVarBool("Sound_EnableMusic");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableMusic") ) then
                    SetCVar("Sound_EnableMusic", 0, "Doh!");
                else
                    SetCVar("Sound_EnableMusic", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Loop Music
            info.leftPadding = 10;
            info.disabled = not A:GetCVarBool("Sound_EnableMusic");
            info.text = L["Loop Music"];
            info.checked = A:GetCVarBool("Sound_ZoneMusicNoDelay");
            info.func = function()
                if ( A:GetCVarBool("Sound_ZoneMusicNoDelay") ) then
                    SetCVar("Sound_ZoneMusicNoDelay", 0, "Doh!");
                else
                    SetCVar("Sound_ZoneMusicNoDelay", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Pet Battle Music
            info.leftPadding = 10;
            info.disabled = not A:GetCVarBool("Sound_EnableMusic");
            info.text = L["Pet Battle Music"];
            info.checked = A:GetCVarBool("Sound_EnablePetBattleMusic");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnablePetBattleMusic") ) then
                    SetCVar("Sound_EnablePetBattleMusic", 0, "Doh!");
                else
                    SetCVar("Sound_EnablePetBattleMusic", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Ambient Sounds
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Ambient Sounds"];
            info.checked = A:GetCVarBool("Sound_EnableAmbience");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableAmbience") ) then
                    SetCVar("Sound_EnableAmbience", 0, "Doh!");
                else
                    SetCVar("Sound_EnableAmbience", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Dialog
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Dialog"];
            info.checked = A:GetCVarBool("Sound_EnableDialog");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableDialog") ) then
                    SetCVar("Sound_EnableDialog", 0, "Doh!");
                else
                    SetCVar("Sound_EnableDialog", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Error Speech
            info.leftPadding = 10;
            info.disabled = not A:GetCVarBool("Sound_EnableDialog");
            info.text = L["Error Speech"];
            info.checked = A:GetCVarBool("Sound_EnableErrorSpeech");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableErrorSpeech") ) then
                    SetCVar("Sound_EnableErrorSpeech", 0, "Doh!");
                else
                    SetCVar("Sound_EnableErrorSpeech", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Background sound
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Background Sound"];
            info.checked = A:GetCVarBool("Sound_EnableSoundWhenGameIsInBG");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableSoundWhenGameIsInBG") ) then
                    SetCVar("Sound_EnableSoundWhenGameIsInBG", 0, "Doh!");
                else
                    SetCVar("Sound_EnableSoundWhenGameIsInBG", 1, "Doh!");
                end
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Enable Reverb
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Enable Reverb"];
            info.checked = A:GetCVarBool("Sound_EnableReverb");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableReverb") ) then
                    SetCVar("Sound_EnableReverb", 0, "Doh!");
                else
                    SetCVar("Sound_EnableReverb", 1, "Doh!");
                end

                AudioOptionsFrame_AudioRestart();
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Headphone Mode
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Distance Filtering"];
            info.checked = A:GetCVarBool("Sound_EnablePositionalLowPassFilter");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnablePositionalLowPassFilter") ) then
                    SetCVar("Sound_EnablePositionalLowPassFilter", 0, "Doh!");
                else
                    SetCVar("Sound_EnablePositionalLowPassFilter", 1, "Doh!");
                end

                AudioOptionsFrame_AudioRestart();
            end;
            UIDropDownMenu_AddButton(info, level);

            -- Death Knight Voices
            info.leftPadding = nil;
            info.disabled = nil;
            info.text = L["Death Knight Voices"];
            info.checked = A:GetCVarBool("Sound_EnableDSPEffects");
            info.func = function()
                if ( A:GetCVarBool("Sound_EnableDSPEffects") ) then
                    SetCVar("Sound_EnableDSPEffects", 0, "Doh!");
                else
                    SetCVar("Sound_EnableDSPEffects", 1, "Doh!");
                end

                AudioOptionsFrame_AudioRestart();
            end;
            UIDropDownMenu_AddButton(info, level);
        elseif ( UIDROPDOWNMENU_MENU_VALUE == "QUEUEDVOLUME" ) then
            info.text = nil;
            info.notCheckable = nil;
            info.isNotRadio = nil;
            info.disabled = nil;
            info.leftPadding = nil;
            info.checked = nil;
            info.func = nil;
            info.customFrame = BrokerVolumeQueuedVolumeSlider;
            UIDropDownMenu_AddButton(info, level);
        elseif ( UIDROPDOWNMENU_MENU_VALUE == "COMBATVOLUME" ) then
            info.text = nil;
            info.notCheckable = nil;
            info.isNotRadio = nil;
            info.disabled = nil;
            info.leftPadding = nil;
            info.checked = nil;
            info.func = nil;
            info.customFrame = BrokerVolumeCombatVolumeSlider;
            UIDropDownMenu_AddButton(info, level);
        elseif ( UIDROPDOWNMENU_MENU_VALUE == "SOUNDOUTPUT" ) then
            local num = Sound_GameSystem_GetNumOutputDrivers();

            for i=0,num-1 do
                info.text = Sound_GameSystem_GetOutputDriverNameByIndex(i);
                info.notCheckable = nil;
                info.isNotRadio = nil;
                info.disabled = nil;
                info.leftPadding = nil;
                info.customFrame = nil
                info.checked = function()
                    if ( tonumber(GetCVar("Sound_OutputDriverIndex")) == i ) then
                        return 1;
                    end

                    return nil;
                end;
                info.func = function()
                    if ( tonumber(GetCVar("Sound_OutputDriverIndex")) ~= i ) then
                        SetCVar("Sound_OutputDriverIndex", i, "Doh!");
                        Sound_GameSystem_RestartSoundSystem();
                    end
                end;
                UIDropDownMenu_AddButton(info, level);
            end
        end
    end
end

-- ********************************************************************************
-- Functions
-- ********************************************************************************

--- Send a message to the chat frame with the addon name colored
-- @param text The message to display
-- @param color Bool, if true will color in red
function A:Message(text, color)
    if ( color ) then
        color = A.color["RED"];
    else
        color = A.color["GREEN"]
    end

    DEFAULT_CHAT_FRAME:AddMessage(color..L["Broker Volume"]..": "..A.color["RESET"]..text);
end

--- Handle the slash command
function A:SlashCommand(input)
    local arg1, arg2 = string.match(input, "(%a*)%s?(.*)");

    if ( arg1 == "" ) then
        A:Message(L["Command usage: /bv, /brokervolume"]);
        A:Message(L["    |cffc79c6eshow|r, show the minimap icon."]);
        A:Message(L["    |cffc79c6elevels|r, display volume levels."]);
        A:Message(L["    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, will set the volume for the given category."]);
    elseif ( arg1 == "show" ) then
        A.db.profile.minimap.hide = false;
        A:ShowHideMinimap();
    elseif ( arg1 == "levels" ) then
        local master = A:GetVolumePercent("Sound_MasterVolume");
        local effects = A:GetVolumePercent("Sound_SFXVolume");
        local music = A:GetVolumePercent("Sound_MusicVolume");
        local ambience = A:GetVolumePercent("Sound_AmbienceVolume");
        local dialog = A:GetVolumePercent("Sound_DialogVolume");

        A:Message(L["Master: |cffc79c6e%s|r%% - Effects: |cffc79c6e%s|r%% - Music: |cffc79c6e%s|r%% - Ambience: |cffc79c6e%s|r%% - Dialog: |cffc79c6e%s|r%%"]:format(master, effects, music, ambience, dialog));
    elseif ( arg1 == "master" and arg2 ) then
        local volume = tonumber(arg2);

        if ( A:IsInRange(volume) ) then
            volume = A:SetVolumeNum(volume);
            SetCVar("Sound_MasterVolume", volume, "Doh!");
            A:Message(L["Master volume set to"]..": "..floor(volume * 100).."%");
        end
    elseif ( arg1 == "effects" and arg2 ) then
        local volume = tonumber(arg2);

        if ( A:IsInRange(volume) ) then
            volume = A:SetVolumeNum(volume);
            SetCVar("Sound_SFXVolume", volume, "Doh!");
            A:Message(L["Effects volume set to"]..": "..floor(volume * 100).."%");
        end
    elseif ( arg1 == "music" and arg2 ) then
        local volume = tonumber(arg2);

        if ( A:IsInRange(volume) ) then
            volume = A:SetVolumeNum(volume);
            SetCVar("Sound_MusicVolume", volume, "Doh!");
            A:Message(L["Music volume set to"]..": "..floor(volume * 100).."%");
        end
    elseif ( arg1 == "ambience" and arg2 ) then
        local volume = tonumber(arg2);

        if ( A:IsInRange(volume) ) then
            volume = A:SetVolumeNum(volume);
            SetCVar("Sound_AmbienceVolume", volume, "Doh!");
            A:Message(L["Ambience volume set to"]..": "..floor(volume * 100).."%");
        end
    elseif ( arg1 == "dialog" and arg2 ) then
        local volume = tonumber(arg2);

        if ( A:IsInRange(volume) ) then
            volume = A:SetVolumeNum(volume);
            SetCVar("Sound_DialogVolume", volume, "Doh!");
            A:Message(L["Dialog volume set to"]..": "..floor(volume * 100).."%");
        end
    else
        A:Message(L["Command usage: /bv, /brokervolume"]);
        A:Message(L["    |cffc79c6eshow|r, show the minimap icon."]);
        A:Message(L["    |cffc79c6elevels|r, display volume levels."]);
        A:Message(L["    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, will set the volume for the given category."]);
    end
end

--- Round
-- @param num The number to round
-- @param idp Number of decimal
-- @return The rounded number
function A:Round(num, idp)
    local mult = 10 ^ ( idp or 0 );

    return math.floor(num * mult + 0.5) / mult;
end

--- Set a number to match volume cvar
-- @param num The number to set
-- @return The rounded number
function A:SetVolumeNum(num)
    num = num / 100;
    num = A:Round(num, 2);

    if ( num > 1 ) then
        return 1;
    end

    if ( num < 0 ) then
        return 0;
    end

    return num;
end

--- Get the volume level in percent
-- @param cat Volume category
-- @return The volume as percent
function A:GetVolumePercent(cat)
    local volume = tonumber(GetCVar(cat));

    volume = math.floor(volume * 100);

    return volume;
end

--- Check if the number is between 0-100
-- @param num The number to test
function A:IsInRange(num)
    if ( num >= 0 and num <= 100) then
        return true;
    else
        A:Message(L["You must provide a number between 0 and 100."], true);
    end

    return false;
end

--- ColorGradient function by Tekkub (http://tekkub.net/) & http://www.wowpedia.org/RGBPercToHex)
function A:ColorGradient(perc, r1, g1, b1, r2, g2, b2, r3, g3, b3)
    local r, g, b;

    perc = perc / 100;

    if ( not r1 ) then
        r1, g1, b1, r2, g2, b2, r3, g3, b3 = 0, 1, 0, 1, 1, 0, 1, 0, 0;
    end

    if ( perc >= 1 ) then
        r, g, b = r3, g3, b3;
    elseif ( perc <= 0 ) then
        r, g, b = 0.5, 0.5, 1;
    else
        local segment, relperc = math.modf(perc*2);
        if ( segment == 1 ) then r1, g1, b1, r2, g2, b2 = r2, g2, b2, r3, g3, b3 end
        r = r1 + (r2-r1)*relperc;
        g = g1 + (g2-g1)*relperc;
        b = b1 + (b2-b1)*relperc;
    end

    r = r <= 1 and r >= 0 and r or 0;
    g = g <= 1 and g >= 0 and g or 0;
    b = b <= 1 and b >= 0 and b or 0;

    return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255);
end

--- Blizzard default function Sound_ToggleMusic()
function A:ToggleMusic()
    if ( GetCVar("Sound_EnableAllSound") == "0" ) then
        ActionStatus:DisplayMessage(SOUND_DISABLED, true);
    else
        if ( GetCVar("Sound_EnableMusic") == "0" ) then
            SetCVar("Sound_EnableMusic", 1, "Doh!");
            ActionStatus:DisplayMessage(MUSIC_ENABLED, true)
        else
            SetCVar("Sound_EnableMusic", 0, "Doh!");
            ActionStatus:DisplayMessage(MUSIC_DISABLED, true)
        end
    end
end

--- Blizzard default function Sound_ToggleSound()
function A:ToggleSound()
    if ( GetCVar("Sound_EnableAllSound") == "0" ) then
        ActionStatus:DisplayMessage(SOUND_DISABLED, true);
    else
        if ( GetCVar("Sound_EnableSFX") == "0" ) then
            SetCVar("Sound_EnableSFX", 1, "Doh!");
            SetCVar("Sound_EnableAmbience", 1, "Doh!");
            SetCVar("Sound_EnableDialog", 1, "Doh!");
            ActionStatus:DisplayMessage(SOUND_EFFECTS_ENABLED, true);
        else
            SetCVar("Sound_EnableSFX", 0, "Doh!");
            SetCVar("Sound_EnableAmbience", 0, "Doh!");
            SetCVar("Sound_EnableDialog", 0, "Doh!");
            ActionStatus:DisplayMessage(SOUND_EFFECTS_DISABLED, true);
        end
    end
end

--- Toggle all sounds
function A:ToggleAll()
    if ( GetCVar("Sound_EnableAllSound") == "0" ) then
        ActionStatus:DisplayMessage(SOUND_DISABLED, true);
    else
        if ( GetCVar("Sound_EnableSFX") == "0" ) then
            SetCVar("Sound_EnableSFX", 1, "Doh!");
            SetCVar("Sound_EnableAmbience", 1, "Doh!");
            SetCVar("Sound_EnableDialog", 1, "Doh!");
            SetCVar("Sound_EnableMusic", 1, "Doh!");
            ActionStatus:DisplayMessage(L["Enable Sound"], true);
        else
            SetCVar("Sound_EnableSFX", 0, "Doh!");
            SetCVar("Sound_EnableAmbience", 0, "Doh!");
            SetCVar("Sound_EnableDialog", 0, "Doh!");
            SetCVar("Sound_EnableMusic", 0, "Doh!");
            ActionStatus:DisplayMessage(L["Disable Sound"], true);
        end
    end
end

--- Force music
-- @param off Will disable music
function A:ForceMusic(off)
    if ( off ) then
        SetCVar("Sound_EnableMusic", 0, "Doh!");
        ActionStatus:DisplayMessage(MUSIC_DISABLED, true);
    else
        SetCVar("Sound_EnableMusic", 1, "Doh!");
        ActionStatus:DisplayMessage(MUSIC_ENABLED, true);
    end
end

--- Force effects
-- @param off Will disable all effects
function A:ForceSound(off)
    if ( off ) then
        SetCVar("Sound_EnableSFX", 0, "Doh!");
        SetCVar("Sound_EnableAmbience", 0, "Doh!");
        ActionStatus:DisplayMessage(SOUND_EFFECTS_DISABLED, true);
    else
        SetCVar("Sound_EnableSFX", 1, "Doh!");
        SetCVar("Sound_EnableAmbience", 1, "Doh!");
        ActionStatus:DisplayMessage(SOUND_EFFECTS_ENABLED, true);
    end
end

--- Force all sounds
-- @param off Will disable all sounds
function A:ForceAll(off)
    if ( off ) then
        SetCVar("Sound_EnableSFX", 0, "Doh!");
        SetCVar("Sound_EnableAmbience", 0, "Doh!");
        SetCVar("Sound_EnableDialog", 0, "Doh!");
        SetCVar("Sound_EnableMusic", 0, "Doh!");
        ActionStatus:DisplayMessage(L["Disable Sound"], true);
    else
        SetCVar("Sound_EnableSFX", 1, "Doh!");
        SetCVar("Sound_EnableAmbience", 1, "Doh!");
        SetCVar("Sound_EnableDialog", 1, "Doh!");
        SetCVar("Sound_EnableMusic", 1, "Doh!");
        ActionStatus:DisplayMessage(L["Enable Sound"], true);
    end
end

--- x% volume up or down
function A:VolumeUp(soundType)
    local volume = tonumber(GetCVar(soundType));

    volume = A:Round(volume, 2);
    volume = volume + (A.db.profile.volumeStep / 100);
    if ( volume > 1 ) then volume = 1 end
    if ( volume < 0 ) then volume = 0 end
    if ( volume ) then
        SetCVar(soundType, volume, "Doh!");
    end
end
function A:VolumeDown(soundType)
    local volume = tonumber(GetCVar(soundType));

    volume = A:Round(volume, 2);
    volume = volume - (A.db.profile.volumeStep / 100);
    if ( volume > 1 ) then volume = 1 end
    if ( volume < 0 ) then volume = 0 end
    if ( volume ) then
        SetCVar(soundType, volume, "Doh!");
    end
end

--- x% effects volume up or down
function A:EffectsVolumeUp()
    A:VolumeUp("Sound_SFXVolume");
end
function A:EffectsVolumeDown()
    A:VolumeDown("Sound_SFXVolume");
end

--- x% music volume up or down
function A:MusicVolumeUp()
    A:VolumeUp("Sound_MusicVolume");
end
function A:MusicVolumeDown()
    A:VolumeDown("Sound_MusicVolume");
end

--- x% ambience volume up or down
function A:AmbienceVolumeUp()
    A:VolumeUp("Sound_AmbienceVolume");
end
function A:AmbienceVolumeDown()
    A:VolumeDown("Sound_AmbienceVolume");
end

--- x% dialog volume up or down
function A:DialogVolumeUp()
    A:VolumeUp("Sound_DialogVolume");
end
function A:DialogVolumeDown()
    A:VolumeDown("Sound_DialogVolume");
end

--- Show or hide the minimap icon
function A:ShowHideMinimap()
    if ( A.db.profile.minimap.hide ) then
        A:Message(L["Minimap icon is hidden if you want to show it back use: /bv show or /brokervolume show"], true);
        A.icon:Hide("BrokerVolumeIcon");
    else
        A.icon:Show("BrokerVolumeIcon");
    end
end

--- Return anchor points according to the cursor position
-- frame is clamped we just need top or bottom anchors
function A:GetAnchor()
    local s = UIParent:GetEffectiveScale();
    local _, py = UIParent:GetCenter();
    local _, y = GetCursorPosition();

    py = py * s;

    if ( y > py ) then
        return "TOP", "BOTTOM";
    else
        return "BOTTOM", "TOP";
    end
end

--- Update Broker
function A:UpdateBroker()
    if ( GetCVar("Sound_EnableAllSound") == "0" ) then
        A.ldb.text = SOUND_DISABLED;
        A.ldb.icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-mute";
    elseif ( GetCVar("Sound_EnableSFX") == "0" ) then
        A.ldb.text = L["Mute"];
        A.ldb.icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-mute";
    else
        local volume = A:GetVolumePercent("Sound_MasterVolume");

        A.ldb.text = A:ColorGradient(volume)..volume.."|r%";

        if ( volume > 60 ) then
            A.ldb.icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-max";
        elseif ( volume > 30 ) then
            A.ldb.icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-medium";
        elseif ( volume > 0 ) then
            A.ldb.icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-low";
        else
            A.ldb.icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-mute";
        end
    end
A.icon:IconCallback(nil, "BrokerVolumeIcon", "icon", A.ldb.icon)
end

--- Reset sound options after LFG proposal, when needed
function A:ResetQueuedVolume()
    if ( A.db.profile.queuedVolume.isQueued ) then
        if ( A.db.profile.queuedVolume.soundState == "0" ) then
            if ( A.db.profile.blizlike ) then
                A:ForceSound(1);
            else
                A:ForceAll(1);
            end
        end

        if ( A.db.profile.queuedVolume.volume ) then SetCVar("Sound_MasterVolume", A.db.profile.queuedVolume.volume, "Doh!"); end

        if ( A.db.profile.queuedVolume.enableBG and A.db.profile.queuedVolume.bgSoundState ) then
            SetCVar("Sound_EnableSoundWhenGameIsInBG", "0");
            Sound_GameSystem_RestartSoundSystem();
        end

        A.db.profile.queuedVolume.soundState = nil;
        A.db.profile.queuedVolume.volume = nil;
        A.db.profile.queuedVolume.isQueued = nil;
        A.db.profile.queuedVolume.bgSoundState = nil;
    end
end

--- Set tooltip mode
-- This is needed as LDB will use OnEnter over OnTooltipShow
function A:SetTooltipMode()
    if ( A.db.profile.noTooltipMode ) then
        A.ldb.OnTooltipShow = nil;
        A.ldb.OnEnter = function(self)
            if ( not A.slidersFrame ) then A:CreateSlidersFrame(); end
            local point, relativePoint = A:GetAnchor();
            A.slidersFrame:ClearAllPoints();
            A.slidersFrame:SetPoint(point, self, relativePoint, 0, 0);
            CloseDropDownMenus();
            GameTooltip:Hide();
            A.slidersFrame:Show();
            --A.slidersFrame.closeTimer = A:ScheduleTimer("CloseSlidersFrame", 3);
        end
    else
        A.ldb.OnEnter = nil;
        A.ldb.OnTooltipShow = function(tooltip)
            if ( A.db.profile.noTooltipMode ) then return; end

            tooltip:AddDoubleLine(A.color["WHITE"]..L["Broker Volume"], A.color["GREEN"].." v"..A.version);
            tooltip:AddLine(" ");

            local master = A:GetVolumePercent("Sound_MasterVolume");
            local sfx = A:GetVolumePercent("Sound_SFXVolume");
            local music = A:GetVolumePercent("Sound_MusicVolume");
            local ambience = A:GetVolumePercent("Sound_AmbienceVolume");
            local dialog = A:GetVolumePercent("Sound_DialogVolume");

            if ( GetCVar("Sound_EnableAllSound") == "0" ) then
                tooltip:AddLine(SOUND_DISABLED);
                tooltip:AddLine(" ");
            end

            if ( GetCVar("Sound_EnableSFX") == "0" ) then
                tooltip:AddLine(L["Mute"]);
                tooltip:AddLine(" ");
            end

            tooltip:AddLine(L["Master volume"]..": "..A:ColorGradient(master)..master.."%");
            tooltip:AddLine(L["Effects volume"]..": "..A:ColorGradient(sfx)..sfx.."%");
            tooltip:AddLine(L["Music volume"]..": "..A:ColorGradient(music)..music.."%");
            tooltip:AddLine(L["Ambience volume"]..": "..A:ColorGradient(ambience)..ambience.."%");
            tooltip:AddLine(L["Dialog volume"]..": "..A:ColorGradient(dialog)..dialog.."%");

            tooltip:AddLine(" ");
            tooltip:AddLine(L["|cffc79c6eLeft-Click: |cff33ff99Mute sound\n|cffc79c6eRight-Click: |cff33ff99Display the volume sliders\n|cffc79c6eShift+Right-Click: |cff33ff99Display the configuration menu"]);
        end
    end
end

--- Return a boolean value from a con var
function A:GetCVarBool(cVar)
    if ( GetCVar(cVar) == "1" ) then
        return 1;
    end

    return nil;
end

-- ********************************************************************************
-- Events callbacks
-- ********************************************************************************

--- Callback function for event VARIABLES_LOADED
function A:VARIABLES_LOADED()
    A:UpdateBroker();
end

--- Callback function for event CVAR_UPDATE
function A:CVAR_UPDATE()
    A:UpdateBroker();
end

--- Callback function for event LFG_PROPOSAL_SHOW
function A:LFG_PROPOSAL_SHOW()
    if ( not A.db.profile.queuedVolume.enable ) then return; end

    local proposalExists = GetLFGProposal();

    if ( proposalExists ) then
        A.db.profile.queuedVolume.isQueued = 1;

        if ( GetCVar("Sound_EnableAllSound") == "0" ) then
            A:Message(L["Queued volume is enabled but all sound is currently disabled."], 1);
            return;
        end

        A.db.profile.queuedVolume.soundState = GetCVar("Sound_EnableSFX");
        A.db.profile.queuedVolume.volume = GetCVar("Sound_MasterVolume");

        if ( A.db.profile.queuedVolume.soundState == "0" ) then
            if ( A.db.profile.blizlike ) then
                A:ForceSound();
            else
                A:ForceAll();
            end
        end

        if ( A.db.profile.queuedVolume.enableBG and GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0" ) then
            SetCVar("Sound_EnableSoundWhenGameIsInBG", "1");
            A.db.profile.queuedVolume.bgSoundState = 1;
            Sound_GameSystem_RestartSoundSystem();
        end

        SetCVar("Sound_MasterVolume", A.db.profile.queuedVolume.volumeLevel, "Doh!");

        if ( A.db.profile.queuedVolume.soundState == "0" or A.db.profile.queuedVolume.bgSoundState ) then
            A:ScheduleTimer("PlaySound", 3);
        end
    end
end

function A:PlaySound()
    PlaySound(SOUNDKIT.READY_CHECK);
end

--- Callback function for event LFG_PROPOSAL_FAILED
function A:LFG_PROPOSAL_FAILED()
    A:ResetQueuedVolume();
end

--- Callback function for event LFG_PROPOSAL_SUCCEEDED
function A:LFG_PROPOSAL_SUCCEEDED()
    A:ResetQueuedVolume();
end

--- Callback function for event PLAYER_ENTERING_WORLD
function A:PLAYER_ENTERING_WORLD()
    A:ResetQueuedVolume();
end

function A:PLAYER_REGEN_DISABLED()
    if ( A.db.profile.combatVolume ) then
        A.storedCombatVolumeLevel = GetCVar("Sound_MasterVolume");
        SetCVar("Sound_MasterVolume", A.db.profile.combatVolumeLevel, "Doh!");
    end
end

function A:PLAYER_REGEN_ENABLED()
    if ( A.db.profile.combatVolume and A.storedCombatVolumeLevel ) then
        SetCVar("Sound_MasterVolume", A.storedCombatVolumeLevel, "Doh!");
    end
end

-- ********************************************************************************
-- Blizzard functions hooks
-- ********************************************************************************

--- Callback function for hook Sound_MasterVolumeUp()
function A:Sound_MasterVolumeUp()
    A:VolumeUp("Sound_MasterVolume");
end

--- Callback function for hook Sound_MasterVolumeDown()
function A:Sound_MasterVolumeDown()
    A:VolumeDown("Sound_MasterVolume");
end

--- Callback function for hook Sound_ToggleSound()
function A:Sound_ToggleSound()
    if ( A.db.profile.blizlike ) then
        A:ToggleSound();
    else
        A:ToggleAll();
    end
end

--- Callback function for hook Sound_ToggleMusic()
function A:Sound_ToggleMusic()
    if ( A.db.profile.blizlike ) then
        A:ToggleMusic();
    else
        A:ToggleAll();
    end
end

-- ********************************************************************************
-- Configuration DB
-- ********************************************************************************

--- Default configuration table for AceDB
local aceDefaultDB =
{
    profile =
    {
        blizlike = nil,
        noTooltipMode = nil,
        volumeStep = 10,
        combatVolume = nil,
        combatVolumeLevel = 0.1,
        queuedVolume =
        {
            enable = 1,
            isQueued = nil,
            soundState = nil,
            volume = nil,
            volumeLevel = 1,
            enableBG = nil,
            bgSoundState = nil,
        },
        minimap =
        {
            hide = 1,
        },
    },
};

-- ********************************************************************************
-- Main
-- ********************************************************************************

--- AceAddon callback
-- Called after the addon is fully loaded
function A:OnInitialize()
    -- Config db
    A.db = LibStub("AceDB-3.0"):New("BrokerVolumeDB", aceDefaultDB);

    -- LDB
    A.ldb = LibStub("LibDataBroker-1.1"):NewDataObject("Broker Volume",
    {
        type = "data source",
        text = "",
        label = L["Broker Volume"],
        icon = "Interface\\AddOns\\Broker_Volume\\Graphics\\sound-mute",
        tocname = "Broker_Volume",
        OnMouseWheel = function(self, delta)
            if ( delta > 0 ) then
                A:Sound_MasterVolumeUp();
            else
                A:Sound_MasterVolumeDown();
            end
        end,
        OnClick = function(self, button)
            if (button == "LeftButton") then
                if ( A.db.profile.blizlike ) then
                    A:ToggleSound();
                else
                    A:ToggleAll();
                end
            elseif ( button == "RightButton" ) then
                if ( A.db.profile.noTooltipMode ) then
                    if ( A.menuFrame.initialize ~= DropdownMenu ) then
                            A.menuFrame.initialize = DropdownMenu;
                    end
                    CloseDropDownMenus();
                    GameTooltip:Hide();

                    if ( A.slidersFrame and A.slidersFrame:IsShown() ) then
                        A:CloseSlidersFrame();
                    end

                    ToggleDropDownMenu(1, nil, A.menuFrame, self, 0, 0);
                else
                    if ( IsShiftKeyDown() ) then
                        if ( A.menuFrame.initialize ~= DropdownMenu ) then
                            A.menuFrame.initialize = DropdownMenu;
                        end
                        CloseDropDownMenus();
                        GameTooltip:Hide();

                        if ( A.slidersFrame and A.slidersFrame:IsShown() ) then
                            A:CloseSlidersFrame();
                        end

                        ToggleDropDownMenu(1, nil, A.menuFrame, self, 0, 0);
                    else
                        if ( not A.slidersFrame ) then A:CreateSlidersFrame(); end
                        local point, relativePoint = A:GetAnchor();
                        A.slidersFrame:ClearAllPoints();
                        A.slidersFrame:SetPoint(point, self, relativePoint, 0, 0);
                        CloseDropDownMenus();
                        GameTooltip:Hide();
                        A.slidersFrame:Show();
                    end
                end
            end
        end,
    });

    -- Set tooltip mode
    A:SetTooltipMode();

    -- LDBIcon
    A.icon:Register("BrokerVolumeIcon", A.ldb, A.db.profile.minimap);

    -- Menu frame & table
    A.menuFrame = CreateFrame("Frame", "BrokerVolumeMenuFrame");
    A.menuFrame.displayMode = "MENU";
    A.menuFrame.info = {};

    -- Events
    A:RegisterEvent("VARIABLES_LOADED");
    A:RegisterEvent("CVAR_UPDATE");
    A:RegisterEvent("LFG_PROPOSAL_SHOW");
    A:RegisterEvent("LFG_PROPOSAL_FAILED");
    A:RegisterEvent("LFG_PROPOSAL_SUCCEEDED");
    A:RegisterEvent("PLAYER_ENTERING_WORLD");
    A:RegisterEvent("PLAYER_REGEN_DISABLED");
    A:RegisterEvent("PLAYER_REGEN_ENABLED");

    -- Hooks
    A:RawHook("Sound_MasterVolumeUp", true);
    A:RawHook("Sound_MasterVolumeDown", true);
    A:RawHook("Sound_ToggleSound", true);
    A:RawHook("Sound_ToggleMusic", true);

    -- Commands
    A:RegisterChatCommand("brokervolume", "SlashCommand");
    A:RegisterChatCommand("bv", "SlashCommand");
end
