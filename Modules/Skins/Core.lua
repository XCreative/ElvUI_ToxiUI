local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local S = TXUI:GetModule("Skins")

local _G = _G
local IsAddOnLoaded = IsAddOnLoaded
local next = next
local pairs = pairs
local tinsert = table.insert
local type = type
local xpcall = xpcall

S.enteredWorld = false
S.addonsToLoad = {}
S.enteredWorldCallback = {}
S.profileUpdateCallback = {}

local function errorhandler(err)
    return _G.geterrorhandler()(err)
end

function S:AddCallbackForAddon(addonName, func)
    local addon = self.addonsToLoad[addonName]

    if (not addon) then
        self.addonsToLoad[addonName] = {}
        addon = self.addonsToLoad[addonName]
    end

    if type(func) == "string" then func = self[func] end
    tinsert(addon, func or self[addonName])

    -- Call the addon if we added callback after init and addon loaded event
    if self.Initialized then
        if F.IsAddOnEnabled(addonName) then
            local _, isFinished = IsAddOnLoaded(addonName)
            if isFinished then self:CallLoadedAddon(addonName, addon) end
        end
    end
end

function S:AddCallbackForEnterWorld(name, func)
    local index = #self.enteredWorldCallback + 1
    tinsert(self.enteredWorldCallback, index, func or self[name])

    -- Call addons if we added the callback after init and world enter
    if self.Initialized and self.enteredWorld then self:CallEnteredWorld(index, func or self[name]) end
end

function S:AddCallbackForProfileUpdate(func)
    if type(func) ~= "string" then return end

    local callback = self.profileUpdateCallback[func]
    if not callback then tinsert(self.profileUpdateCallback, self[func]) end
end

function S:CallLoadedAddon(addonName, object)
    if (not self.Initialized) then return F.DebugPrint(TXUI, "CallLoadedAddon was trigger before init", addonName) end

    for _, func in next, object do xpcall(func, errorhandler, self) end
    self.addonsToLoad[addonName] = nil
end

function S:CallEnteredWorld(index, func)
    if (not self.Initialized) then return F.DebugPrint(TXUI, "CallEnteredWorld was trigger before init") end

    xpcall(func, errorhandler, self)
    self.enteredWorldCallback[index] = nil
end

function S:ADDON_LOADED(_, addonName)
    -- Don't allow changes before init
    if (not self.Initialized) then return end

    -- Call callback
    local object = self.addonsToLoad[addonName]
    if object then self:CallLoadedAddon(addonName, object) end
end

function S:PLAYER_ENTERING_WORLD()
    -- Set true to fire late callbacks
    self.enteredWorld = true

    -- Don't allow changes before init
    if (not self.Initialized) then return end

    -- Call every skin that registered a callback
    for index, func in next, self.enteredWorldCallback do self:CallEnteredWorld(index, func) end
end

function S:ProfileUpdate()
    -- Don't allow changes before init
    if (not self.Initialized) then return end

    -- Call every skin that registered a callback
    for _, func in next, self.profileUpdateCallback do xpcall(func, errorhandler, self) end
end

function S:Initialize()
    -- Don't init second time
    if self.Initialized then return end

    -- Don't init if its not a TXUI profile
    if (not F.IsTXUIProfile()) then return end

    -- We are ready to rock, hooray!
    self.Initialized = true

    -- Call all skins for addons that are already loaded (before us)
    for addonName, object in pairs(self.addonsToLoad) do
        if F.IsAddOnEnabled(addonName) then
            local _, isFinished = IsAddOnLoaded(addonName)
            if isFinished then self:CallLoadedAddon(addonName, object) end
        end
    end

    -- Call addons if we entered world already before init
    if self.enteredWorld then
        for index, func in next, self.enteredWorldCallback do self:CallEnteredWorld(index, func) end
    end
end

S:RegisterEvent("ADDON_LOADED")
S:RegisterEvent("PLAYER_ENTERING_WORLD")

TXUI:RegisterModule(S:GetName())
