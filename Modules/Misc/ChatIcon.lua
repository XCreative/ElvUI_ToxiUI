local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local M = TXUI:GetModule("Misc")

local find = string.find

-- Vars
local ch
local ct

do
    local shortRealmName
    function M.ChatIcon_DevIconCallback(sender)
        -- Strip colors
        local cleanName = F.StripStringColor(sender)

        -- Add realm name if the name has none
        if (not find(cleanName, "-", 1, true)) then
            if (not shortRealmName) then shortRealmName = E:ShortenRealm(E.myrealm) end
            cleanName = cleanName .. "-" .. shortRealmName
        end

        -- Lookup if developer
        for _, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.DEV]) do
            if (names[cleanName]) then return M.iconCache.chat[I.Enum.ChatIconType.DEV] end
        end

        -- Lookup if beta tester
        for _, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.BETA]) do
            if (names[cleanName]) then return M.iconCache.chat[I.Enum.ChatIconType.BETA] end
        end

        -- Lookup if vip
        for _, names in pairs(I.ChatIconNames[I.Enum.ChatIconType.VIP]) do
            if (names[cleanName]) then return M.iconCache.chat[I.Enum.ChatIconType.VIP] end
        end
    end
end

function M:ChatIcon_Check()
    if (not ct) or (not ct.db) or (not ct.db.enable) or (ct.db.roleIconStyle ~= "BLIZZARD") or -- WT Check
        (not (ct.db.removeBrackets or ct.db.roleIconStyle ~= "DEFAULT" or ct.db.roleIconSize ~= 15 or ct.db.removeRealm)) or -- WT Check
        (not E.db.TXUI.elvUIIcons.roleIcons) or (not E.db.TXUI.elvUIIcons.roleIcons.enabled) or -- TX Check
        (not TXUI:HasRequirements(I.Requirements.RoleIcons)) then return false end -- TX Check

    return true
end

function M:ChatIcon_HandleName(_, nameString)
    -- Check if dev and call original WT function
    local chatIcon = self.ChatIcon_DevIconCallback(nameString)
    local name = self.hooks[ct]["HandleName"](ct, nameString)

    -- Add icon if one was found
    if (chatIcon and chatIcon ~= "") then
        return chatIcon .. " " .. name
    else
        return name
    end
end

function M:ChatIcon_UpdateRoleIcons(_)
    if (not self:ChatIcon_Check()) then return self.hooks[ct]["UpdateRoleIcons"](ct) end

    ct.cache.blizzardRoleIcons.Tank = self.iconCache.roles.Tank
    ct.cache.blizzardRoleIcons.Healer = self.iconCache.roles.Healer
    ct.cache.blizzardRoleIcons.DPS = self.iconCache.roles.DPS

    return self.hooks[ct]["UpdateRoleIcons"](ct)
end

function M:ChatIcon_UpdateSettings()
    wipe(self.iconCache.roles)
    wipe(self.iconCache.chat)

    -- Get role icon
    local roleTexture = I.ElvUIIcons.Role[E.db.TXUI.elvUIIcons.roleIcons.theme]["default"]

    -- Cache Role Icons
    self.iconCache.roles.Tank = E:TextureString(I.Media.RoleIcons[roleTexture.TANK], ":16:16")
    self.iconCache.roles.Healer = E:TextureString(I.Media.RoleIcons[roleTexture.HEALER], ":16:16")
    self.iconCache.roles.DPS = E:TextureString(I.Media.RoleIcons[roleTexture.DAMAGER], ":16:16")

    -- Cache Chat Icons
    self.iconCache.chat[I.Enum.ChatIconType.DEV] = E:TextureString(I.Media.ChatIcons.Dev, ":10:24")
    self.iconCache.chat[I.Enum.ChatIconType.BETA] = E:TextureString(I.Media.ChatIcons.Beta, ":10:24")
    self.iconCache.chat[I.Enum.ChatIconType.VIP] = E:TextureString(I.Media.ChatIcons.Vip, ":10:24")
end

function M:ChatIcon_ForceUpdate()
    -- Update Icon Cache
    self:ChatIcon_UpdateSettings()

    -- Exit if WT Chat is not enabled
    if (not self:ChatIcon_Check()) then return end

    -- Force Update WT Chat Module
    ct:UpdateRoleIcons()
    ct:CheckLFGRoles()
end

function M:ChatIcon()
    -- Vars
    self.iconCache = {}
    self.iconCache.roles = {}
    self.iconCache.chat = {}

    -- Update Icon Cache
    self:ChatIcon_UpdateSettings()

    -- Get WindTools
    local wt = E.Libs.AceAddon:GetAddon("ElvUI_WindTools", true)

    if (wt) then
        -- Get WindTools Chat Text Module
        ct = wt:GetModule("ChatText")

        -- Hook WindTools
        if (ct) and (ct.db) then
            self:RawHook(ct, "UpdateRoleIcons", "ChatIcon_UpdateRoleIcons")

            self:ChatIcon_ForceUpdate()
        end
    end

    -- Get ElvUI Chat Module
    ch = E:GetModule("Chat")

    -- Add callback for ElvUI
    if (ch) and (E.private.chat.enable) then ch:AddPluginIcons(M.ChatIcon_DevIconCallback) end
end

M:AddCallback("ChatIcon")
