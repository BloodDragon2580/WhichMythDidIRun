local addonName = ...
local frame = CreateFrame("Frame")

-- Accountweite SavedVariable initialisieren
if not WhichMythDidIRunDB then
    WhichMythDidIRunDB = { pos = nil, scale = 1.0 }
end

-- 🌍 Lokalisierungstabelle
local L = {}
local locale = GetLocale()

local translations = {
    ["enUS"] = { title = "Myth+ Runs", moveHint = "Shift + Left Click to move", bestTime = "Best Time: ", scaleText = "Frame Size", settingsHint = "Open Settings" },
    ["deDE"] = { title = "Myth+ Läufe", moveHint = "Shift + Linksklick zum Verschieben", bestTime = "Beste Zeit: ", scaleText = "Fenstergröße", settingsHint = "Einstellungen öffnen" },
    ["frFR"] = { title = "Donjons Myth+", moveHint = "Shift + Clic gauche pour déplacer", bestTime = "Meilleur temps : ", scaleText = "Taille du cadre", settingsHint = "Ouvrir les paramètres" },
    ["esES"] = { title = "Mazmorras Myth+", moveHint = "Shift + Clic izquierdo para mover", bestTime = "Mejor tiempo: ", scaleText = "Tamaño del marco", settingsHint = "Abrir configuración" },
    ["esMX"] = { title = "Mazmorras Myth+", moveHint = "Shift + Clic izquierdo para mover", bestTime = "Mejor tiempo: ", scaleText = "Tamaño del marco", settingsHint = "Abrir configuración" },
    ["ruRU"] = { title = "Подземелья M+", moveHint = "Shift + ЛКМ, чтобы переместить", bestTime = "Лучшее время: ", scaleText = "Размер окна", settingsHint = "Открыть настройки" },
    ["ptBR"] = { title = "Masmorras Myth+", moveHint = "Shift + Clique esquerdo para mover", bestTime = "Melhor tempo: ", scaleText = "Tamanho da janela", settingsHint = "Abrir configurações" },
    ["itIT"] = { title = "Dungeon Myth+", moveHint = "Shift + Click sinistro per muovere", bestTime = "Miglior tempo: ", scaleText = "Dimensione finestra", settingsHint = "Apri impostazioni" },
    ["koKR"] = { title = "신화+ 던전", moveHint = "Shift + 좌클릭 이동", bestTime = "최고 기록: ", scaleText = "창 크기", settingsHint = "설정 열기" },
    ["zhCN"] = { title = "史诗+ 地城", moveHint = "Shift + 左键拖动", bestTime = "最佳时间: ", scaleText = "框体大小", settingsHint = "打开设置" },
    ["zhTW"] = { title = "史詩+ 地城", moveHint = "Shift + 左鍵拖動", bestTime = "最佳時間: ", scaleText = "框架大小", settingsHint = "打開設定" },
}

L = translations[locale] or translations["enUS"]

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

-- 🔄 Throttling für Updates
local lastUpdateTime = 0
local updateThrottle = 1 -- 1 Sekunde zwischen Updates

local function GetLevelColor(level)
    if not level then return GRAY_FONT_COLOR end
    if level >= 15 then return {r=0.7,g=0.3,b=0.9}
    elseif level >= 10 then return {r=0.2,g=0.6,b=1.0}
    else return {r=0.3,g=1.0,b=0.3}
    end
end

local function UpdateDungeonList()
    local currentTime = GetTime()
    if currentTime - lastUpdateTime < updateThrottle then
        return -- Throttle Updates
    end
    lastUpdateTime = currentTime

    for _, line in ipairs(dungeonLines) do
        line:Hide()
    end
    wipe(dungeonLines)

    local maps = C_ChallengeMode.GetMapTable()
    if not maps then return end
    
    local offsetY = -30
    local totalHeight = 40

    for _, mapID in ipairs(maps) do
        local name, _, _, texture = C_ChallengeMode.GetMapUIInfo(mapID)
        if name then
            local best = C_MythicPlus.GetSeasonBestForMap(mapID)
            local level = best and best.level or nil

            local row = CreateFrame("Frame", nil, displayFrame)
            row:SetSize(260, 30)
            row:SetPoint("TOPLEFT", 10, offsetY)

            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(30, 30)
            icon:SetTexture(texture)
            icon:SetPoint("LEFT", row, "LEFT")

            local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            text:SetPoint("LEFT", icon, "RIGHT", 5, 0)
            local levelText = level and ("+" .. level) or "–"
            local color = GetLevelColor(level)
            text:SetText(name .. " " .. levelText)
            text:SetTextColor(color.r, color.g, color.b)

            row:SetScript("OnEnter", function()
                if best and best.durationSec then
                    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
                    GameTooltip:AddLine(name, 1, 1, 1)
                    GameTooltip:AddLine(L.bestTime .. SecondsToClock(best.durationSec), 0.8, 0.8, 0.8)
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
end

-- 🎯 Verzögerte Update-Funktion für bessere Performance
local function ScheduleUpdate()
    C_Timer.After(0.5, UpdateDungeonList)
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

-- 🎯 Erweiterte Event-Registrierung für sofortige Updates
GroupFinderFrame:HookScript("OnShow", function() 
    displayFrame:Show()
    ScheduleUpdate()
end)
GroupFinderFrame:HookScript("OnHide", function() displayFrame:Hide() end)
displayFrame:Hide()

-- Alle relevanten Events registrieren
frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
frame:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
frame:RegisterEvent("CHALLENGE_MODE_LEADERS_UPDATE")
frame:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")

-- 🔥 Zusätzliche Events für Retail WoW
if C_Seasons then
    frame:RegisterEvent("MYTHIC_PLUS_SEASON_STARTED")
    frame:RegisterEvent("MYTHIC_PLUS_SEASON_ENDED")
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Verzögerung beim Login für vollständige Datenladung
        C_Timer.After(3, UpdateDungeonList)
    elseif event == "CHALLENGE_MODE_COMPLETED" then
        -- Sofortige Aktualisierung nach Dungeon-Abschluss
        C_Timer.After(1, UpdateDungeonList)
    else
        -- Für alle anderen Events verzögertes Update
        ScheduleUpdate()
    end
end)

-- 🔄 Periodic Update alle 30 Sekunden (nur wenn Frame sichtbar)
local periodicTimer
local function StartPeriodicUpdates()
    if periodicTimer then periodicTimer:Cancel() end
    periodicTimer = C_Timer.NewTicker(30, function()
        if displayFrame:IsShown() then
            UpdateDungeonList()
        end
    end)
end

local function StopPeriodicUpdates()
    if periodicTimer then
        periodicTimer:Cancel()
        periodicTimer = nil
    end
end

-- Timer starten/stoppen basierend auf Frame-Sichtbarkeit
displayFrame:HookScript("OnShow", StartPeriodicUpdates)
displayFrame:HookScript("OnHide", StopPeriodicUpdates)

-- Initialer Update beim Addon-Load
C_Timer.After(2, UpdateDungeonList)
