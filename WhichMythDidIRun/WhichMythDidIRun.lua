local addonName = ...
local frame = CreateFrame("Frame")

-- Accountweite SavedVariable initialisieren
if not WhichMythDidIRunDB then
    WhichMythDidIRunDB = { pos = nil }
end

-- 🌐 Lokalisierungstabelle
local L = {}
local locale = GetLocale()

local translations = {
    ["enUS"] = { title = "Myth+ Runs", moveHint = "Shift + Left Click to move", bestTime = "Best Time: " },
    ["deDE"] = { title = "Myth+ Läufe", moveHint = "Shift + Linksklick zum Verschieben", bestTime = "Beste Zeit: " },
    ["frFR"] = { title = "Donjons Myth+", moveHint = "Shift + Clic gauche pour déplacer", bestTime = "Meilleur temps : " },
    ["esES"] = { title = "Mazmorras Myth+", moveHint = "Shift + Clic izquierdo para mover", bestTime = "Mejor tiempo: " },
    ["esMX"] = { title = "Mazmorras Myth+", moveHint = "Shift + Clic izquierdo para mover", bestTime = "Mejor tiempo: " },
    ["ruRU"] = { title = "Подземелья Myth+", moveHint = "Shift + Левый клик для перемещения", bestTime = "Лучшее время: " },
    ["ptBR"] = { title = "Masmorras Myth+", moveHint = "Shift + Clique esquerdo para mover", bestTime = "Melhor tempo: " },
    ["itIT"] = { title = "Dungeon Myth+", moveHint = "Shift + Click sinistro per muovere", bestTime = "Miglior tempo: " },
    ["koKR"] = { title = "신화+ 던전", moveHint = "Shift + 좌클릭 이동", bestTime = "최고 기록: " },
    ["zhCN"] = { title = "史诗+ 地城", moveHint = "Shift + 左键拖动", bestTime = "最佳时间: " },
    ["zhTW"] = { title = "史詩+ 地城", moveHint = "Shift + 左鍵拖動", bestTime = "最佳時間: " },
}

L = translations[locale] or translations["enUS"] -- fallback auf Englisch

-- Hauptframe mit BackdropTemplate für runde Ecken und Schatten
local displayFrame = CreateFrame("Frame", "WhichMythDidIRunFrame", UIParent, "BackdropTemplate")
displayFrame:SetSize(280, 250)

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

-- 🎨 Dunkler Hintergrund + runde Ecken + leichter Schatten
displayFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- runde Ecken
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
displayFrame:SetBackdropColor(0, 0, 0, 0.85)
displayFrame:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.8)

-- Optional: Schatten
local shadow = CreateFrame("Frame", nil, displayFrame, "BackdropTemplate")
shadow:SetPoint("TOPLEFT", -4, 4)
shadow:SetPoint("BOTTOMRIGHT", 4, -4)
shadow:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
shadow:SetBackdropColor(0, 0, 0, 0.4)
shadow:SetFrameLevel(displayFrame:GetFrameLevel() - 1)

-- Titel
displayFrame.title = displayFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
displayFrame.title:SetPoint("TOP", 0, -5)
displayFrame.title:SetText(L.title)

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

local function UpdateDungeonList()
    for _, line in ipairs(dungeonLines) do
        line:Hide()
    end
    wipe(dungeonLines)

    local maps = C_ChallengeMode.GetMapTable()
    local offsetY = -30
    local totalHeight = 40

    for _, mapID in ipairs(maps) do
        local name, _, _, texture = C_ChallengeMode.GetMapUIInfo(mapID)
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

    displayFrame:SetHeight(totalHeight + 20)
end

GroupFinderFrame:HookScript("OnShow", function() displayFrame:Show() end)
GroupFinderFrame:HookScript("OnHide", function() displayFrame:Hide() end)
displayFrame:Hide()

frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MYTHIC_PLUS_CURRENT_AFFIX_UPDATE")
frame:SetScript("OnEvent", function() UpdateDungeonList() end)

C_Timer.After(2, UpdateDungeonList)
