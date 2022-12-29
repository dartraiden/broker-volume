-- ********************************************************************************
-- Data Broker Volume Control (Broker_Volume)
-- A volume control for Data Broker.
-- By: Shenton
--
-- Locales-koKR.lua
-- ********************************************************************************

local L = LibStub("AceLocale-3.0"):NewLocale("BrokerVolume", "koKR");

if L then
L["    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, will set the volume for the given category."] = "    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, 해당 음량의 수치를 설정합니다."
L["    |cffc79c6elevels|r, display volume levels."] = "    |cffc79c6elevels|r, 음량 수치를 표시합니다."
L["    |cffc79c6eshow|r, show the minimap icon."] = "    |cffc79c6eshow|r, 미니맵 아이콘을 표시합니다."
L[ [=[|cffc79c6eLeft-Click: |cff33ff99Mute sound
|cffc79c6eRight-Click: |cff33ff99Display the volume sliders
|cffc79c6eShift+Right-Click: |cff33ff99Display the configuration menu]=] ] = [=[|cffc79c6e왼쪽 버튼: |cff33ff99음소거
|cffc79c6e오른쪽 버튼: |cff33ff99음량 슬라이드 바 표시
|cffc79c6e쉬프트+오른쪽 버튼: |cff33ff99설정 메뉴 표시]=]
L[ [=[|cffffffff%s|r
Use mouse wheel to change value.]=] ] = [=[|cffffffff%s|r
마우스 휠을 사용해서 음량 수치를 변경할 수 있습니다.]=]
L["Ambience volume"] = "환경 소리 음량"
L["Ambience volume set to"] = "환경 소리 음량 설정:"
L["Ambient Sounds"] = "환경 소리"
L["Background Sound"] = "백그라운드 시 소리 듣기"
L["Blizlike mute"] = "Blizlike 음소거"
L["Broker Volume"] = "Broker Volume"
L["Close"] = "닫기"
--[[Translation missing --]]
--[[ L["Combat Volume"] = ""--]] 
L["Command usage: /bv, /brokervolume"] = "명령어 사용법: /bv, /brokervolume"
L["Death Knight Voices"] = "죽음의 기사 음성"
L["Dialog"] = "대화"
L["Dialog volume"] = "대화 음량"
L["Dialog volume set to"] = "대화 음량 설정:"
L["Disable Sound"] = "효과음 끄기"
--[[Translation missing --]]
--[[ L["Distance Filtering"] = ""--]] 
L["Effects volume"] = "효과음 음량"
L["Effects volume set to"] = "효과음 음량 설정:"
L["Emote Sounds"] = "감정 표현 음성"
L["Enable Pet Sounds"] = "소환수 소리 사용"
L["Enable Reverb"] = "울림 효과 사용"
--[[Translation missing --]]
--[[ L["Enable Sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Enabled"] = ""--]] 
L["Error Speech"] = "오류 음성"
L["Loop Music"] = "배경음악 반복"
L["Master volume"] = "주 음량"
L["Master volume set to"] = "주 음량 설정:"
L["Master: |cffc79c6e%s|r%% - Effects: |cffc79c6e%s|r%% - Music: |cffc79c6e%s|r%% - Ambience: |cffc79c6e%s|r%% - Dialog: |cffc79c6e%s|r%%"] = "주 음량: |cffc79c6e%s|r%% - 효과음: |cffc79c6e%s|r%% - 배경음악: |cffc79c6e%s|r%% - 환경 소리: |cffc79c6e%s|r%% - 대화: |cffc79c6e%s|r%%"
L["Minimap icon is hidden if you want to show it back use: /bv show or /brokervolume show"] = "미니맵 아이콘이 숨겨졌습니다. 다시 사용하고 싶다면: /bv show 또는 /brokervolume show"
L["Music"] = "배경음악"
L["Music volume"] = "배경음악 음량"
L["Music volume set to"] = "배경음악 음량 설정:"
L["Mute"] = "음소거"
L["No tooltip mode"] = "툴팁 끄기 모드"
L["Options"] = "옵션"
--[[Translation missing --]]
--[[ L["Other options"] = ""--]] 
L["Pet Battle Music"] = "애완동물 대전 음악"
--[[Translation missing --]]
--[[ L["PLayback"] = ""--]] 
--[[Translation missing --]]
--[[ L["Playback"] = ""--]] 
L["Queued volume boost"] = "대기열 종료시 음량 키움"
L["Queued volume is enabled but all sound is currently disabled."] = "대기열 음량 키움 옵션이 켜졌지만 모든 효과음이 꺼져있는 상태입니다."
L["Show/Hide minimap icon"] = "미니맵 아이콘 표시/숨김"
L["Sound Effects"] = "음향 효과"
L["Sound options"] = "소리 옵션"
--[[Translation missing --]]
--[[ L["Sound output"] = ""--]] 
--[[Translation missing --]]
--[[ L["Volume"] = ""--]] 
L["Volume step"] = "음량 조절 단계"
L["You must provide a number between 0 and 100."] = "0과 100 사이의 숫자만 입력해야 합니다."

end
