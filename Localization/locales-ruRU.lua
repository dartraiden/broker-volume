-- ********************************************************************************
-- Data Broker Volume Control (Broker_Volume)
-- A volume control for Data Broker.
-- By: Shenton
--
-- Locales-ruRU.lua
-- ********************************************************************************

local L = LibStub("AceLocale-3.0"):NewLocale("BrokerVolume", "ruRU");

if L then
L["    |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, will set the volume for the given category."] = " |cffc79c6e<master||effects||music||ambience||dialog> <0-100>|r, чтобы установить уровень громкости звука для выбранной категории."
L["    |cffc79c6elevels|r, display volume levels."] = " |cffc79c6elevels|r, чтобы увидеть уровни громкости звука."
L["    |cffc79c6eshow|r, show the minimap icon."] = " |cffc79c6eshow|r, чтобы показать значок на миникарте."
L[ [=[|cffc79c6eLeft-Click: |cff33ff99Mute sound
|cffc79c6eRight-Click: |cff33ff99Display the volume sliders
|cffc79c6eShift+Right-Click: |cff33ff99Display the configuration menu]=] ] = [=[|cffc79c6eЛевая кнопка: |cff33ff99 заглушить звук
|cffc79c6eПравая кнопка: |cff33ff99ползунки
|cffc79c6eShift+правая кнопка: |cff33ff99настройки]=]
L[ [=[|cffffffff%s|r
Use mouse wheel to change value.]=] ] = [=[|cffffffff%s|r
Меняйте значение колесом мыши.]=]
L["Ambience volume"] = "Окружающий мир"
L["Ambience volume set to"] = "Громкость звуков окружающего мира составляет"
L["Ambient Sounds"] = "Фоновые звуки"
L["Background Sound"] = "Фоновый режим"
L["Blizlike mute"] = "Заглушая звук, оставлять музыку"
L["Broker Volume"] = "Модуль громкости"
L["Close"] = "Закрыть"
L["Combat Volume"] = "Особая громкость во время боя"
L["Command usage: /bv, /brokervolume"] = "Использование: /bv, /brokervolume"
L["Death Knight Voices"] = "Голоса рыцарей смерти"
L["Dialog"] = "Диалоги"
L["Dialog volume"] = "Диалоги"
L["Dialog volume set to"] = "Громкость звука в диалогах составляет"
L["Disable Sound"] = "Звук заглушен"
L["Distance Filtering"] = "Фильтрация на расстоянии"
L["Effects volume"] = "Звуковые эффекты"
L["Effects volume set to"] = "Громкость звуковых эффектов составляет"
L["Emote Sounds"] = "Звуки эмоций"
L["Enable Pet Sounds"] = "Звуки питомцев"
L["Enable Reverb"] = "Эффекты эха"
L["Enable Sound"] = "Звук включён"
L["Enabled"] = "Включить"
L["Error Speech"] = "Сообщения об ошибках"
L["Loop Music"] = "Повтор музыки"
L["Master volume"] = "Общая громкость"
L["Master volume set to"] = "Общая громкость звука составляет"
L["Master: |cffc79c6e%s|r%% - Effects: |cffc79c6e%s|r%% - Music: |cffc79c6e%s|r%% - Ambience: |cffc79c6e%s|r%% - Dialog: |cffc79c6e%s|r%%"] = "Общая: |cffc79c6e%s|r%% - Эффекты: |cffc79c6e%s|r%% - Музыка: |cffc79c6e%s|r%% - Окружающий мир: |cffc79c6e%s|r%% - Диалоги: |cffc79c6e%s|r%%"
L["Minimap icon is hidden if you want to show it back use: /bv show or /brokervolume show"] = "Значок на миникарте скрыт. Чтобы показать его, введите /bv show или /brokervolume show"
L["Music"] = "Музыка"
L["Music volume"] = "Музыка"
L["Music volume set to"] = "Громкость музыки составляет"
L["Mute"] = "Заглушить"
L["No tooltip mode"] = "Без всплывающей подсказки"
L["Options"] = "Настройки"
L["Other options"] = "Прочие настройки"
L["Pet Battle Music"] = "Музыка битв питомцев"
L["Playback"] = "Воспроизведение звука"
L["Queued volume boost"] = "Увеличить громкость призыва"
L["Queued volume is enabled but all sound is currently disabled."] = "Громкость призыва увеличена, но все звуки в настоящий момент отключены."
L["Show/Hide minimap icon"] = "Показать значок на миникарте"
L["Sound Effects"] = "Звуковые эффекты"
L["Sound options"] = "Настройки звука"
L["Sound output"] = "Звуковое устройство"
L["Volume"] = "Громкость"
L["Volume step"] = "Шаг изменения громкости"
L["You must provide a number between 0 and 100."] = "Допускаются значения между 0 и 100"

end
