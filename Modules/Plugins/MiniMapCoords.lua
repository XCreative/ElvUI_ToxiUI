local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local MC = TXUI:NewModule("MiniMapCoords", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Globals
local format = string.format
local mapInfo = E.MapInfo
local miniMap = _G.Minimap

-- Vars
local M

function MC:OnEvent()
    if (mapInfo.x) and (mapInfo.y) then
        self.restrictedArea = false
        self.coordsHolder.playerCoords:SetText(format(self.displayFormat, mapInfo.xText, mapInfo.yText))
    else
        self.restrictedArea = true
        self.coordsHolder.playerCoords:SetText("N/A")
    end
end

function MC:UpdateCoords(elapsed)
    if (self.restrictedArea) or (not mapInfo.coordsWatching) then return end

    self.elapsed = (self.elapsed or 0) + elapsed
    if (self.elapsed < 0.33) then return end

    if (mapInfo.x) and (mapInfo.y) then
        self.coordsHolder.playerCoords:SetText(format(self.displayFormat, mapInfo.xText, mapInfo.yText))
    else
        self.coordsHolder.playerCoords:SetText("N/A")
    end

    self.elapsed = 0
end

function MC:UpdateCoordinatesPosition()
    self.coordsHolder.playerCoords:ClearAllPoints()
    self.coordsHolder.playerCoords:Point("CENTER", miniMap, "CENTER", self.db.xOffset, self.db.yOffset)
end

function MC:CreateCoordsFrame()
    self.coordsHolder = CreateFrame("Frame", "TXCoordsHolder", miniMap)
    self.coordsHolder:SetFrameLevel(miniMap:GetFrameLevel() + 10)
    self.coordsHolder:SetFrameStrata(miniMap:GetFrameStrata())
    self.coordsHolder:SetScript("OnUpdate", function(_, e)
        self:UpdateCoords(e)
    end)

    self.coordsHolder.playerCoords = self.coordsHolder:CreateFontString(nil, "OVERLAY")

    self:UpdateCoordinatesPosition()
end

function MC:UpdateSettings()
    if not self.coordsHolder then self:CreateCoordsFrame() end

    F.SetFontFromDB(self.db, "coord", self.coordsHolder.playerCoords)

    self.displayFormat = format("%s, %s", self.db.format, self.db.format)
    self:UpdateCoordinatesPosition()
    self:OnEvent()
end

function MC:PLAYER_ENTERING_WORLD()
    self:ScheduleTimer(function()
        if InCombatLockdown() then
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:ProfileUpdate()
        end
    end, 3)
end

function MC:PLAYER_REGEN_ENABLED()
    self:ProfileUpdate()
end

function MC:Disable()
    self:CancelAllTimers()
    self:UnregisterAllEvents()
    self:UnhookAll()

    if self.coordsHolder then self.coordsHolder:Hide() end
end

function MC:Enable()
    self:UpdateSettings()

    if self.coordsHolder then self.coordsHolder:Show() end

    self:UnregisterAllEvents()
    self:RegisterEvent("LOADING_SCREEN_DISABLED", "OnEvent")
    self:RegisterEvent("ZONE_CHANGED", "OnEvent")
    self:RegisterEvent("ZONE_CHANGED_INDOORS", "OnEvent")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnEvent")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    M = E:GetModule("Minimap")

    self:SecureHook(M, "UpdateSettings", function()
        self:UpdateSettings()
    end)
end

function MC:ProfileUpdate()
    self:Disable()

    self.db = E.db.TXUI.miniMapCoords

    if TXUI:HasRequirements(I.Requirements.MiniMapCoords) and (self.db and self.db.enabled) then
        if self.Initialized then
            self:Enable()
        else
            self:Initialize(true)
        end
    end
end

function MC:Initialize(worldInit)
    -- Set db
    self.db = E.db.TXUI.miniMapCoords

    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not TXUI:HasRequirements(I.Requirements.MiniMapCoords)) then return end

    -- Don't do anything if disabled
    if (not self.db) or (not self.db.enabled) then return end

    -- Wait for construction after combat
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return

        -- Register start events
    elseif (not worldInit) then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        return
    end

    -- Enable!
    self:Enable()

    -- We are done, hooray!
    self.Initialized = true
end

TXUI:RegisterModule(MC:GetName())
