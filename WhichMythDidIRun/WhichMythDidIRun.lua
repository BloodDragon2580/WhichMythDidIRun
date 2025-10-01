local addonName = ...
local frame = CreateFrame("Frame")

-- Accountweite SavedVariable initialisieren
if not WhichMythDidIRunDB then
    WhichMythDidIRunDB = { pos = nil, scale = 1.0, debugMode = false }
end

-- 🌍 Lokalisierungstabelle
local L = {}
local locale = GetLocale()

local translations = {
    ["enUS"] = { 
        title = "Myth+ Runs", moveHint = "Shift + Left Click to move", bestTime = "Best Time: ",
        scaleText = "Frame Size", settingsHint = "Open Settings", refreshHint = "Refresh Data",
        debugText = "Debug Mode", debugTooltip = "Show debug messages in chat",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Debug mode enabled", debugDisabled = "Debug mode disabled",
        -- Debug Strings
        debug_event_received = "Event received: %s",
        debug_update_start = "Starting UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Update already active, skipping...",
        debug_no_maps = "No map table available!",
        debug_found_maps = "%d maps found",
        debug_found_dungeons = "%d dungeons with data",
        debug_dungeon_entry = "%s -> Level %d",
        debug_no_changes = "No changes detected, skipping UI update",
        debug_manual_refresh = "Manual refresh triggered",
        debug_polling_start = "Starting aggressive polling...",
        debug_polling_try = "Polling attempt %d",
        debug_polling_end = "Polling ended after %d attempts",
        debug_login_update = "Login update after %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Login: %s Reload: %s",
        debug_challenge_completed = "Myth+ dungeon completed!",
        debug_standard_update = "Standard update for event: %s"
    },
    ["deDE"] = { 
        title = "Myth+ Läufe", moveHint = "Shift + Linksklick zum Verschieben", bestTime = "Beste Zeit: ",
        scaleText = "Fenstergröße", settingsHint = "Einstellungen öffnen", refreshHint = "Daten aktualisieren",
        debugText = "Debug-Modus", debugTooltip = "Debug-Nachrichten im Chat anzeigen",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Debug-Modus aktiviert", debugDisabled = "Debug-Modus deaktiviert",
        -- Debug Strings
        debug_event_received = "Event empfangen: %s",
        debug_update_start = "Starte UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Update bereits aktiv, überspringe...",
        debug_no_maps = "Keine Map-Tabelle verfügbar!",
        debug_found_maps = "%d Karten gefunden",
        debug_found_dungeons = "%d Dungeons mit Daten gefunden",
        debug_dungeon_entry = "%s -> Stufe %d",
        debug_no_changes = "Keine Änderungen gefunden, überspringe UI-Update",
        debug_manual_refresh = "Manueller Refresh-Button gedrückt!",
        debug_polling_start = "Starte aggressives Polling...",
        debug_polling_try = "Polling Versuch %d",
        debug_polling_end = "Polling beendet nach %d Versuchen",
        debug_login_update = "Login-Update nach %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Login: %s Reload: %s",
        debug_challenge_completed = "Myth+ Dungeon abgeschlossen!",
        debug_standard_update = "Standard-Update für Event: %s"
    },
    ["frFR"] = { 
        title = "Courses Myth+", moveHint = "Maj + Clic gauche pour déplacer", bestTime = "Meilleur temps : ",
        scaleText = "Taille de la fenêtre", settingsHint = "Ouvrir les paramètres", refreshHint = "Actualiser les données",
        debugText = "Mode Débogage", debugTooltip = "Afficher les messages de débogage dans le chat",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Mode débogage activé", debugDisabled = "Mode débogage désactivé",
        -- Debug Strings
        debug_event_received = "Événement reçu : %s",
        debug_update_start = "Démarrage de UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Mise à jour déjà active, ignorer...",
        debug_no_maps = "Aucune table de cartes disponible !",
        debug_found_maps = "%d cartes trouvées",
        debug_found_dungeons = "%d donjons avec données",
        debug_dungeon_entry = "%s -> Niveau %d",
        debug_no_changes = "Aucun changement détecté, ignorer la mise à jour de l'interface",
        debug_manual_refresh = "Actualisation manuelle déclenchée",
        debug_polling_start = "Démarrage du sondage agressif...",
        debug_polling_try = "Tentative de sondage %d",
        debug_polling_end = "Sondage terminé après %d tentatives",
        debug_login_update = "Mise à jour de connexion après %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Connexion : %s Rechargement : %s",
        debug_challenge_completed = "Donjon Myth+ terminé !",
        debug_standard_update = "Mise à jour standard pour l'événement : %s"
    },
    ["esES"] = { 
        title = "Carreras de Mítico+", moveHint = "Mayús + Clic izquierdo para mover", bestTime = "Mejor tiempo: ",
        scaleText = "Tamaño del marco", settingsHint = "Abrir ajustes", refreshHint = "Actualizar datos",
        debugText = "Modo Depuración", debugTooltip = "Mostrar mensajes de depuración en el chat",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Modo depuración activado", debugDisabled = "Modo depuración desactivado",
        -- Debug Strings
        debug_event_received = "Evento recibido: %s",
        debug_update_start = "Iniciando UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Actualización ya activa, saltando...",
        debug_no_maps = "¡No hay tabla de mapas disponible!",
        debug_found_maps = "%d mapas encontrados",
        debug_found_dungeons = "%d mazmorras con datos",
        debug_dungeon_entry = "%s -> Nivel %d",
        debug_no_changes = "No se detectaron cambios, saltando actualización de interfaz",
        debug_manual_refresh = "Actualización manual activada",
        debug_polling_start = "Iniciando sondeo agresivo...",
        debug_polling_try = "Intento de sondeo %d",
        debug_polling_end = "Sondeo finalizado después de %d intentos",
        debug_login_update = "Actualización de inicio de sesión después de %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Inicio de sesión: %s Recarga: %s",
        debug_challenge_completed = "¡Mazmorra Mítico+ completada!",
        debug_standard_update = "Actualización estándar para el evento: %s"
    },
    ["esMX"] = { 
        title = "Carreras de Mítico+", moveHint = "Mayús + Clic izquierdo para mover", bestTime = "Mejor tiempo: ",
        scaleText = "Tamaño del marco", settingsHint = "Abrir ajustes", refreshHint = "Actualizar datos",
        debugText = "Modo Depuración", debugTooltip = "Mostrar mensajes de depuración en el chat",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Modo depuración activado", debugDisabled = "Modo depuración desactivado",
        -- Debug Strings
        debug_event_received = "Evento recibido: %s",
        debug_update_start = "Iniciando UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Actualización ya activa, saltando...",
        debug_no_maps = "¡No hay tabla de mapas disponible!",
        debug_found_maps = "%d mapas encontrados",
        debug_found_dungeons = "%d mazmorras con datos",
        debug_dungeon_entry = "%s -> Nivel %d",
        debug_no_changes = "No se detectaron cambios, saltando actualización de interfaz",
        debug_manual_refresh = "Actualización manual activada",
        debug_polling_start = "Iniciando sondeo agresivo...",
        debug_polling_try = "Intento de sondeo %d",
        debug_polling_end = "Sondeo finalizado después de %d intentos",
        debug_login_update = "Actualización de inicio de sesión después de %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Inicio de sesión: %s Recarga: %s",
        debug_challenge_completed = "¡Mazmorra Mítico+ completada!",
        debug_standard_update = "Actualización estándar para el evento: %s"
    },
    ["ruRU"] = { 
        title = "Рейды Миф+", moveHint = "Shift + Левый клик для перемещения", bestTime = "Лучшее время: ",
        scaleText = "Размер окна", settingsHint = "Открыть настройки", refreshHint = "Обновить данные",
        debugText = "Режим отладки", debugTooltip = "Показывать отладочные сообщения в чате",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Режим отладки включен", debugDisabled = "Режим отладки выключен",
        -- Debug Strings
        debug_event_received = "Получено событие: %s",
        debug_update_start = "Запуск UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Обновление уже активно, пропуск...",
        debug_no_maps = "Нет доступной таблицы карт!",
        debug_found_maps = "Найдено %d карт",
        debug_found_dungeons = "%d подземелий с данными",
        debug_dungeon_entry = "%s -> Уровень %d",
        debug_no_changes = "Изменения не обнаружены, пропуск обновления UI",
        debug_manual_refresh = "Запущено ручное обновление",
        debug_polling_start = "Запуск агрессивного опроса...",
        debug_polling_try = "Попытка опроса %d",
        debug_polling_end = "Опрос завершен после %d попыток",
        debug_login_update = "Обновление при входе через %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Вход: %s Перезагрузка: %s",
        debug_challenge_completed = "Подземелье Миф+ завершено!",
        debug_standard_update = "Стандартное обновление для события: %s"
    },
    ["ptBR"] = {
        title = "Runs Mítica+", moveHint = "Shift + Clique Esquerdo para mover", bestTime = "Melhor Tempo: ",
        scaleText = "Tamanho da Moldura", settingsHint = "Abrir Configurações", refreshHint = "Atualizar Dados",
        debugText = "Modo Depuração", debugTooltip = "Mostrar mensagens de depuração no chat",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Modo depuração ativado", debugDisabled = "Modo depuração desativado",
        -- Debug Strings
        debug_event_received = "Evento recebido: %s",
        debug_update_start = "Iniciando UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Atualização já ativa, pulando...",
        debug_no_maps = "Nenhuma tabela de mapa disponível!",
        debug_found_maps = "%d mapas encontrados",
        debug_found_dungeons = "%d masmorras com dados",
        debug_dungeon_entry = "%s -> Nível %d",
        debug_no_changes = "Nenhuma alteração detectada, pulando atualização de UI",
        debug_manual_refresh = "Atualização manual acionada",
        debug_polling_start = "Iniciando sondagem agressiva...",
        debug_polling_try = "Tentativa de sondagem %d",
        debug_polling_end = "Sondagem encerrada após %d tentativas",
        debug_login_update = "Atualização de login após %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Login: %s Recarregar: %s",
        debug_challenge_completed = "Masmorra Mítica+ concluída!",
        debug_standard_update = "Atualização padrão para o evento: %s"
    },
    ["itIT"] = {
        title = "Run Mitiche+", moveHint = "Shift + Clic Sinistro per spostare", bestTime = "Miglior Tempo: ",
        scaleText = "Dimensione Finestra", settingsHint = "Apri Impostazioni", refreshHint = "Aggiorna Dati",
        debugText = "Modalità Debug", debugTooltip = "Mostra messaggi di debug in chat",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "Modalità debug abilitata", debugDisabled = "Modalità debug disabilitata",
        -- Debug Strings
        debug_event_received = "Evento ricevuto: %s",
        debug_update_start = "Avvio UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "Aggiornamento già attivo, salto...",
        debug_no_maps = "Nessuna tabella delle mappe disponibile!",
        debug_found_maps = "%d mappe trovate",
        debug_found_dungeons = "%d dungeon con dati",
        debug_dungeon_entry = "%s -> Livello %d",
        debug_no_changes = "Nessuna modifica rilevata, salto aggiornamento UI",
        debug_manual_refresh = "Aggiornamento manuale attivato",
        debug_polling_start = "Avvio polling aggressivo...",
        debug_polling_try = "Tentativo di polling %d",
        debug_polling_end = "Polling terminato dopo %d tentativi",
        debug_login_update = "Aggiornamento login dopo %ds",
        debug_login_state = "PLAYER_ENTERING_WORLD - Login: %s Ricarica: %s",
        debug_challenge_completed = "Dungeon Mitico+ completato!",
        debug_standard_update = "Aggiornamento standard per evento: %s"
    },
    ["koKR"] = {
        title = "신화+ 던전", moveHint = "Shift + 좌클릭으로 이동", bestTime = "최고 시간: ",
        scaleText = "창 크기", settingsHint = "설정 열기", refreshHint = "데이터 새로고침",
        debugText = "디버그 모드", debugTooltip = "채팅에 디버그 메시지 표시",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "디버그 모드 활성화", debugDisabled = "디버그 모드 비활성화",
        -- Debug Strings
        debug_event_received = "이벤트 수신: %s",
        debug_update_start = "UpdateDungeonList 시작 (forceUpdate=%s)",
        debug_update_skip = "업데이트 이미 활성화, 건너뛰기...",
        debug_no_maps = "사용 가능한 지도 테이블 없음!",
        debug_found_maps = "지도 %d개 발견",
        debug_found_dungeons = "데이터 있는 던전 %d개",
        debug_dungeon_entry = "%s -> 레벨 %d",
        debug_no_changes = "변경 사항 없음, UI 업데이트 건너뛰기",
        debug_manual_refresh = "수동 새로고침 실행",
        debug_polling_start = "공격적인 폴링 시작...",
        debug_polling_try = "폴링 시도 %d",
        debug_polling_end = "폴링 %d번 시도 후 종료",
        debug_login_update = "%d초 후 로그인 업데이트",
        debug_login_state = "PLAYER_ENTERING_WORLD - 로그인: %s 재시작: %s",
        debug_challenge_completed = "신화+ 던전 완료!",
        debug_standard_update = "이벤트에 대한 표준 업데이트: %s"
    },
    ["zhCN"] = {
        title = "大秘境记录", moveHint = "按住 Shift + 鼠标左键移动", bestTime = "最佳时间: ",
        scaleText = "框架大小", settingsHint = "打开设置", refreshHint = "刷新数据",
        debugText = "调试模式", debugTooltip = "在聊天中显示调试消息",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "调试模式已启用", debugDisabled = "调试模式已禁用",
        -- Debug Strings
        debug_event_received = "接收到事件: %s",
        debug_update_start = "开始 UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "更新已激活, 跳过...",
        debug_no_maps = "没有地图表可用!",
        debug_found_maps = "找到 %d 个地图",
        debug_found_dungeons = "有数据的副本 %d 个",
        debug_dungeon_entry = "%s -> 等级 %d",
        debug_no_changes = "未检测到更改, 跳过 UI 更新",
        debug_manual_refresh = "手动刷新已触发",
        debug_polling_start = "开始侵略性轮询...",
        debug_polling_try = "轮询尝试 %d 次",
        debug_polling_end = "轮询在 %d 次尝试后结束",
        debug_login_update = "登录更新在 %d 秒后",
        debug_login_state = "PLAYER_ENTERING_WORLD - 登录: %s 重载: %s",
        debug_challenge_completed = "大秘境已完成!",
        debug_standard_update = "事件的标准更新: %s"
    },
    ["zhTW"] = {
        title = "傳奇鑰石紀錄", moveHint = "按住 Shift + 滑鼠左鍵移動", bestTime = "最佳時間: ",
        scaleText = "框架大小", settingsHint = "開啟設定", refreshHint = "重新整理資料",
        debugText = "除錯模式", debugTooltip = "在聊天中顯示除錯訊息",
        debugPrefix = "[WhichMythDidIRun]", debugEnabled = "除錯模式已啟用", debugDisabled = "除錯模式已禁用",
        -- Debug Strings
        debug_event_received = "接收到事件: %s",
        debug_update_start = "開始 UpdateDungeonList (forceUpdate=%s)",
        debug_update_skip = "更新已啟用, 跳過...",
        debug_no_maps = "沒有地圖表可用!",
        debug_found_maps = "找到 %d 個地圖",
        debug_found_dungeons = "有資料的副本 %d 個",
        debug_dungeon_entry = "%s -> 等級 %d",
        debug_no_changes = "未偵測到變更, 跳過 UI 更新",
        debug_manual_refresh = "手動重新整理已觸發",
        debug_polling_start = "開始積極輪詢...",
        debug_polling_try = "輪詢嘗試 %d 次",
        debug_polling_end = "輪詢在 %d 次嘗試後結束",
        debug_login_update = "登入更新在 %d 秒後",
        debug_login_state = "PLAYER_ENTERING_WORLD - 登入: %s 重載: %s",
        debug_challenge_completed = "傳奇鑰石副本已完成!",
        debug_standard_update = "事件的標準更新: %s"
    },
}

L = translations[locale] or translations["enUS"]

-- 🐛 Debug-Funktion mit Lokalisierung
local function DebugPrint(message)
    if WhichMythDidIRunDB.debugMode then
        print(L.debugPrefix .. " " .. message)
    end
end

-- 🎯 Globale Variablen für besseres Update-Management
local currentDungeonData = {}
local updateTimer = nil
local isUpdating = false

-- Hauptframe
local displayFrame = CreateFrame("Frame", "WhichMythDidIRunFrame", UIParent, "BackdropTemplate")
displayFrame:SetSize(280, 250)
displayFrame:SetScale(WhichMythDidIRunDB.scale or 1.0)

-- Position laden oder Standard
if WhichMythDidIRunDB.pos then
    displayFrame:SetPoint(
        WhichMythDidIRunDB.pos.point,
        UIParent,
        WhichMythDidIRunDB.pos.relativePoint,
        WhichMythDidIRunDB.pos.xOfs,
        WhichMythDidIRunDB.pos.yOfs
    )
else
    displayFrame:SetPoint("TOPLEFT", GroupFinderFrame, "BOTTOMLEFT", 0, -5)
end

-- 🎨 Hintergrund + runde Ecken
displayFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
displayFrame:SetBackdropColor(0, 0, 0, 0.85)
displayFrame:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.8)

-- Titel
displayFrame.title = displayFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
displayFrame.title:SetPoint("TOP", 0, -5)
displayFrame.title:SetText(L.title)

-- 🔄 Refresh-Button als Icon
local refreshButton = CreateFrame("Button", nil, displayFrame)
refreshButton:SetSize(20, 20)
refreshButton:SetPoint("TOPRIGHT", displayFrame, "TOPRIGHT", -30, -5)

local refreshTexture = refreshButton:CreateTexture(nil, "ARTWORK")
refreshTexture:SetAllPoints()
refreshTexture:SetTexture("Interface\\Buttons\\UI-RefreshButton")

refreshButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(L.refreshHint, 1, 1, 1)
    GameTooltip:Show()
end)
refreshButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
-- OnClick wird später gesetzt, nachdem UpdateDungeonList definiert ist

-- ⚙️ Settings-Button als Icon
local settingsButton = CreateFrame("Button", nil, displayFrame)
settingsButton:SetSize(20, 20)
settingsButton:SetPoint("TOPRIGHT", displayFrame, "TOPRIGHT", -5, -5)

local gearTexture = settingsButton:CreateTexture(nil, "ARTWORK")
gearTexture:SetAllPoints()
gearTexture:SetTexture("Interface\\Buttons\\UI-OptionsButton")

settingsButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(L.settingsHint, 1, 1, 1)
    GameTooltip:Show()
end)
settingsButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- Frame verschiebbar
displayFrame:SetMovable(true)
displayFrame:EnableMouse(true)
displayFrame:RegisterForDrag("LeftButton")
displayFrame:SetScript("OnDragStart", function(self)
    if IsShiftKeyDown() then
        self:StartMoving()
    end
end)
displayFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
    WhichMythDidIRunDB.pos = {
        point = point,
        relativePoint = relativePoint,
        xOfs = xOfs,
        yOfs = yOfs,
    }
end)

-- Hinweistext
local hint = displayFrame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
hint:SetPoint("BOTTOM", displayFrame, "BOTTOM", 0, 5)
hint:SetText(L.moveHint)

-- Speicher für Dungeon-Zeilen
local dungeonLines = {}

local function GetLevelColor(level)
    if not level then return GRAY_FONT_COLOR end
    if level >= 15 then return {r=0.7,g=0.3,b=0.9}
    elseif level >= 10 then return {r=0.2,g=0.6,b=1.0}
    else return {r=0.3,g=1.0,b=0.3}
    end
end

-- 🔥 Verbesserte Update-Funktion mit Debug-Ausgaben
local function UpdateDungeonList(forceUpdate)
    if isUpdating and not forceUpdate then 
        DebugPrint("Update bereits aktiv, überspringe...")
        return 
    end
    isUpdating = true

    DebugPrint("Starte UpdateDungeonList (forceUpdate=" .. tostring(forceUpdate) .. ")")

    -- Neue Daten sammeln
    local newData = {}
    local maps = C_ChallengeMode.GetMapTable()
    if not maps then 
        DebugPrint("Keine Map-Tabelle verfügbar!")
        isUpdating = false
        return 
    end

    DebugPrint("Gefunden " .. #maps .. " Maps")

    local hasChanges = false
    local foundData = 0
    
    for _, mapID in ipairs(maps) do
        local name, _, _, texture = C_ChallengeMode.GetMapUIInfo(mapID)
        if name then
            local best = C_MythicPlus.GetSeasonBestForMap(mapID)
            local level = best and best.level or nil
            local time = best and best.durationSec or nil
            
            if level then
                foundData = foundData + 1
                DebugPrint(name .. " -> Level " .. level)
            end
            
            newData[mapID] = {
                name = name,
                texture = texture,
                level = level,
                time = time
            }
            
            -- Prüfen auf Änderungen
            if not currentDungeonData[mapID] or 
               currentDungeonData[mapID].level ~= level or 
               currentDungeonData[mapID].time ~= time then
                hasChanges = true
            end
        end
    end

    DebugPrint("Gefunden " .. foundData .. " Dungeons mit Daten")

    -- Nur Update wenn sich etwas geändert hat oder Force-Update
    if not hasChanges and not forceUpdate then
        DebugPrint("Keine Änderungen gefunden, überspringe UI-Update")
        isUpdating = false
        return
    end

    currentDungeonData = newData

    -- UI aktualisieren
    for _, line in ipairs(dungeonLines) do
        line:Hide()
    end
    wipe(dungeonLines)

    local offsetY = -30
    local totalHeight = 40

    for _, mapID in ipairs(maps) do
        local data = newData[mapID]
        if data then
            local row = CreateFrame("Frame", nil, displayFrame)
            row:SetSize(260, 30)
            row:SetPoint("TOPLEFT", 10, offsetY)

            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(30, 30)
            icon:SetTexture(data.texture)
            icon:SetPoint("LEFT", row, "LEFT")

            local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            text:SetPoint("LEFT", icon, "RIGHT", 5, 0)
            local levelText = data.level and ("+" .. data.level) or "–"
            local color = GetLevelColor(data.level)
            text:SetText(data.name .. " " .. levelText)
            text:SetTextColor(color.r, color.g, color.b)

            row:SetScript("OnEnter", function()
                if data.time then
                    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
                    GameTooltip:AddLine(data.name, 1, 1, 1)
                    GameTooltip:AddLine(L.bestTime .. SecondsToClock(data.time), 0.8, 0.8, 0.8)
                    GameTooltip:Show()
                end
            end)
            row:SetScript("OnLeave", function() GameTooltip:Hide() end)

            table.insert(dungeonLines, row)
            offsetY = offsetY - 35
            totalHeight = totalHeight + 35
        end
    end

    displayFrame:SetHeight(totalHeight + 20)
    isUpdating = false
end

-- 🔄 Refresh-Button OnClick Handler jetzt setzen (nach UpdateDungeonList Definition)
refreshButton:SetScript("OnClick", function()
    DebugPrint("Manueller Refresh-Button gedrückt!")
    -- Daten-Cache zurücksetzen für echtes Force-Update
    wipe(currentDungeonData)
    UpdateDungeonList(true)
    print("Myth+ Daten manuell aktualisiert!")
end)

-- 🚀 Aggressives Polling nach Dungeon-Completion
local pollingTimer = nil
local pollCount = 0

local function StartAggressivePolling()
    DebugPrint("Starte aggressives Polling...")
    if pollingTimer then pollingTimer:Cancel() end
    pollCount = 0
    
    -- Cache leeren für echte Updates
    wipe(currentDungeonData)
    
    -- Alle 3 Sekunden für 3 Minuten prüfen
    pollingTimer = C_Timer.NewTicker(3, function()
        DebugPrint("Polling Versuch " .. (pollCount + 1))
        UpdateDungeonList(true)
        pollCount = pollCount + 1
        
        -- Nach 60 Versuchen (3 Minuten) aufhören
        if pollCount >= 60 then
            DebugPrint("Polling beendet nach " .. pollCount .. " Versuchen")
            pollingTimer:Cancel()
            pollingTimer = nil
        end
    end)
end

-- Interface Options Panel mit Slider
local optionsPanel = CreateFrame("Frame", addonName.."Options", UIParent)
optionsPanel.name = "Which Myth+ Did I Run"

local title = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Which Myth+ Did I Run")

-- 🔧 Slider + Prozentanzeige
local scaleSlider = CreateFrame("Slider", addonName.."ScaleSlider", optionsPanel, "OptionsSliderTemplate")
scaleSlider:SetOrientation("HORIZONTAL")
scaleSlider:SetSize(200, 20)
scaleSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -30)
scaleSlider:SetMinMaxValues(0.5, 2.0)
scaleSlider:SetValueStep(0.05)
scaleSlider:SetObeyStepOnDrag(true)
scaleSlider:SetValue(WhichMythDidIRunDB.scale or 1.0)

_G[scaleSlider:GetName().."Low"]:SetText("50%")
_G[scaleSlider:GetName().."High"]:SetText("200%")
_G[scaleSlider:GetName().."Text"]:SetText(L.scaleText)

-- Prozentanzeige rechts vom Slider
local scaleValueText = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
scaleValueText:SetPoint("LEFT", scaleSlider, "RIGHT", 10, 0)
scaleValueText:SetText(string.format("%d%%", (WhichMythDidIRunDB.scale or 1.0) * 100))

scaleSlider:SetScript("OnValueChanged", function(self, value)
    WhichMythDidIRunDB.scale = value
    displayFrame:SetScale(value)
    scaleValueText:SetText(string.format("%d%%", value * 100))
end)

-- Debug-Checkbox (im Optionspanel)
local debugCheckbox = CreateFrame("CheckButton", addonName.."DebugCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
debugCheckbox:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -30)
debugCheckbox:SetChecked(WhichMythDidIRunDB.debugMode)
_G[debugCheckbox:GetName().."Text"]:SetText(L.debugText)

debugCheckbox:SetScript("OnClick", function(self)
    WhichMythDidIRunDB.debugMode = self:GetChecked()
    if WhichMythDidIRunDB.debugMode then
        print(L.debugPrefix .. " " .. L.debugEnabled)
    else
        print(L.debugPrefix .. " " .. L.debugDisabled)
    end
end)

-- Optionen-Panel registrieren + Category speichern
local category
if Settings and Settings.RegisterCanvasLayoutCategory then
    category = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name)
    Settings.RegisterAddOnCategory(category)
else
    optionsPanel.okay = function() end
    optionsPanel.cancel = function() end
    InterfaceOptions_AddCategory(optionsPanel)
end

-- ⚙️ Button öffnet direkt unser Panel
settingsButton:SetScript("OnClick", function()
    if Settings and Settings.OpenToCategory and category then
        Settings.OpenToCategory(category:GetID())
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
    end
end)

-- Frame Visibility Handling
GroupFinderFrame:HookScript("OnShow", function() 
    displayFrame:Show()
    UpdateDungeonList(true)
end)
GroupFinderFrame:HookScript("OnHide", function() displayFrame:Hide() end)
displayFrame:Hide()

-- 🎯 Event Handling mit aggressiverem Polling
frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
frame:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
frame:RegisterEvent("CHALLENGE_MODE_LEADERS_UPDATE")

-- Zusätzliche Events für verschiedene WoW-Versionen
local additionalEvents = {
    "MYTHIC_PLUS_NEW_WEEKLY_RECORD",
    "MYTHIC_PLUS_SEASON_STARTED", 
    "MYTHIC_PLUS_SEASON_ENDED",
    "CHALLENGE_MODE_RESET",
    "WEEKLY_REWARDS_UPDATE",
    "PLAYER_LOGOUT",
    "PLAYER_ENTERING_BATTLEGROUND",
    "ZONE_CHANGED_NEW_AREA"
}

for _, event in ipairs(additionalEvents) do
    pcall(function() frame:RegisterEvent(event) end)
end

frame:SetScript("OnEvent", function(self, event, ...)
    DebugPrint(string.format(L.debug_event_received, event))

    if event == "PLAYER_ENTERING_WORLD" then
        local isLogin, isReload = ...
        DebugPrint("PLAYER_ENTERING_WORLD - Login:" .. tostring(isLogin) .. " Reload:" .. tostring(isReload))

        if isLogin or isReload then
            C_Timer.After(2, function()
                DebugPrint("Login-Update nach 2s")
                UpdateDungeonList(true)
            end)
            C_Timer.After(5, function()
                DebugPrint("Login-Update nach 5s")
                UpdateDungeonList(true)
            end)
            C_Timer.After(10, function()
                DebugPrint("Login-Update nach 10s")
                UpdateDungeonList(true)
            end)
        else
            UpdateDungeonList(true)
        end
    elseif event == "CHALLENGE_MODE_COMPLETED" then
        DebugPrint("Myth+ Dungeon abgeschlossen!")
        StartAggressivePolling()
    else
        DebugPrint("Standard-Update für Event: " .. event)
        C_Timer.After(1, function() UpdateDungeonList(true) end)
    end
end)

-- 🔄 Kontinuierliches Update alle 30 Sekunden (nur wenn sichtbar)
local continuousTimer = nil

local function StartContinuousUpdates()
    if continuousTimer then continuousTimer:Cancel() end
    continuousTimer = C_Timer.NewTicker(30, function()
        if displayFrame:IsShown() then
            UpdateDungeonList()
        end
    end)
end

local function StopContinuousUpdates()
    if continuousTimer then
        continuousTimer:Cancel()
        continuousTimer = nil
    end
end

displayFrame:HookScript("OnShow", StartContinuousUpdates)
displayFrame:HookScript("OnHide", StopContinuousUpdates)

-- 🏁 Initialer Update
C_Timer.After(1, function() UpdateDungeonList(true) end)
