-- ********************************************************************************
-- Data Broker Volume Control (Broker_Volume)
-- A volume control for Data Broker.
-- By: Shenton
--
-- Locales-zhCN.lua
-- ********************************************************************************

local L = LibStub("AceLocale-3.0"):NewLocale("BrokerVolume", "zhCN");

if L then
--[[Translation missing --]]
--[[ L["    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, will set the volume for the given category."] = ""--]] 
L["    |cffc79c6elevels|r, display volume levels."] = "    |cffc79c6elevels|r, 显示音量等级."
L["    |cffc79c6eshow|r, show the minimap icon."] = "    |cffc79c6eshow|r, 显示小地图图标"
L[ [=[|cffc79c6eLeft-Click: |cff33ff99Mute sound
|cffc79c6eRight-Click: |cff33ff99Display the volume sliders
|cffc79c6eShift+Right-Click: |cff33ff99Display the configuration menu]=] ] = [=[|cffc79c6e左键点击: |cff33ff99静音
|cffc79c6e右键点击: |cff33ff99显示音量滑动杆选项
|cffc79c6eShift+右键点击: |cff33ff99显示配置菜单]=]
L[ [=[|cffffffff%s|r
Use mouse wheel to change value.]=] ] = [=[|cffffffff%s|r
使用鼠标滚轮改变数值.]=]
L["Ambience volume"] = "环境音"
L["Ambience volume set to"] = "环境音设置为"
--[[Translation missing --]]
--[[ L["Ambient Sounds"] = ""--]] 
--[[Translation missing --]]
--[[ L["Background Sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Blizlike mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Broker Volume"] = ""--]] 
L["Close"] = "关闭"
--[[Translation missing --]]
--[[ L["Combat Volume"] = ""--]] 
L["Command usage: /bv, /brokervolume"] = "插件命令: /bv, /brokervolume"
--[[Translation missing --]]
--[[ L["Death Knight Voices"] = ""--]] 
--[[Translation missing --]]
--[[ L["Dialog"] = ""--]] 
--[[Translation missing --]]
--[[ L["Dialog volume"] = ""--]] 
--[[Translation missing --]]
--[[ L["Dialog volume set to"] = ""--]] 
--[[Translation missing --]]
--[[ L["Disable Sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Distance Filtering"] = ""--]] 
L["Effects volume"] = "声音"
L["Effects volume set to"] = "声音设置为"
--[[Translation missing --]]
--[[ L["Emote Sounds"] = ""--]] 
--[[Translation missing --]]
--[[ L["Enable Pet Sounds"] = ""--]] 
--[[Translation missing --]]
--[[ L["Enable Reverb"] = ""--]] 
--[[Translation missing --]]
--[[ L["Enable Sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Enabled"] = ""--]] 
--[[Translation missing --]]
--[[ L["Error Speech"] = ""--]] 
--[[Translation missing --]]
--[[ L["Loop Music"] = ""--]] 
L["Master volume"] = "主音量"
L["Master volume set to"] = "主音量设置为"
--[[Translation missing --]]
--[[ L["Master: |cffc79c6e%s|r%% - Effects: |cffc79c6e%s|r%% - Music: |cffc79c6e%s|r%% - Ambience: |cffc79c6e%s|r%% - Dialog: |cffc79c6e%s|r%%"] = ""--]] 
L["Minimap icon is hidden if you want to show it back use: /bv show or /brokervolume show"] = "小地图图标已隐藏，如要重新显示，输入命令/bv show 或者 /brokervolume show"
--[[Translation missing --]]
--[[ L["Music"] = ""--]] 
L["Music volume"] = "音乐"
L["Music volume set to"] = "音乐设置为"
L["Mute"] = "静音"
--[[Translation missing --]]
--[[ L["No tooltip mode"] = ""--]] 
L["Options"] = "选项"
--[[Translation missing --]]
--[[ L["Other options"] = ""--]] 
--[[Translation missing --]]
--[[ L["Pet Battle Music"] = ""--]] 
--[[Translation missing --]]
--[[ L["Playback"] = ""--]] 
--[[Translation missing --]]
--[[ L["Queued volume boost"] = ""--]] 
--[[Translation missing --]]
--[[ L["Queued volume is enabled but all sound is currently disabled."] = ""--]] 
L["Show/Hide minimap icon"] = "显示/隐藏小地图图标"
--[[Translation missing --]]
--[[ L["Sound Effects"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound options"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound output"] = ""--]] 
L["Volume"] = "Volume"
--[[Translation missing --]]
--[[ L["Volume step"] = ""--]] 
L["You must provide a number between 0 and 100."] = "你必须提供一个0到100的数字"

end
