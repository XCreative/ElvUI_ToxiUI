local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local _G = _G
local GetAddOnMetadata = GetAddOnMetadata
local ipairs = ipairs
local tonumber = tonumber

function TXUI:HasRequirements(requirements, skipProfile)
    local check = self:CheckRequirements(requirements, skipProfile)
    return (check == true) and true or false
end

function TXUI:GetRequirementString(requirement)
    local reason = ""
    local text = I.Strings.Requirements[requirement]

    if (not text) or (text == "") or (text == "NO_STRING_DEFINED") then
        self:DebugPrint("GetRequirementString > Could not find string for " .. I.Enum.Requirements[requirement])
    else
        reason = (text ~= "NO_STRING_NEEDED") and text or ""
    end

    return (reason ~= "") and reason or nil
end

function TXUI:CheckRequirements(requirements, skipProfile)
    if (not skipProfile) and (not F.IsTXUIProfile()) then return I.Enum.Requirements.TOXIUI_PROFILE end

    for _, requirement in ipairs(requirements) do

        if (requirement == I.Enum.Requirements.WEAK_AURAS_ENABLED) then -- 2
            if not F.IsAddOnEnabled("WeakAuras") then return requirement end

        elseif (requirement == I.Enum.Requirements.MASQUE_DISABLED) then -- 3
            if F.IsAddOnEnabled("Masque") then return requirement end

        elseif (requirement == I.Enum.Requirements.WT_WA_SKIN_DISABLED) then -- 4
            if F.IsAddOnEnabled("ElvUI_WindTools") and E.private.WT and E.private.WT.skins.addons.weakAuras then
                return requirement
            end

        elseif (requirement == I.Enum.Requirements.SL_DISABLED) then -- 5
            if F.IsAddOnEnabled("ElvUI_SLE") then return requirement end

        elseif (requirement == I.Enum.Requirements.DARK_MODE_ENABLED) then -- 6
            if E.db.TXUI.themes.darkMode.enabled ~= true then return requirement end

        elseif (requirement == I.Enum.Requirements.DARK_MODE_DISABLED) then -- 7
            if E.db.TXUI.themes.darkMode.enabled ~= false then return requirement end

        elseif (requirement == I.Enum.Requirements.GRADIENT_MODE_ENABLED) then -- 8
            if E.db.TXUI.themes.gradientMode.enabled ~= true then return requirement end

        elseif (requirement == I.Enum.Requirements.GRADIENT_MODE_DISABLED) then -- 9
            if E.db.TXUI.themes.gradientMode.enabled ~= false then return requirement end

        elseif (requirement == I.Enum.Requirements.PROFILE_ON_460) then -- 10
            if not self:GetModule("Changelog"):HasRequiredVersion("4.6.0") then return requirement end

        elseif (requirement == I.Enum.Requirements.PROFILE_ON_470) then -- 11
            if not self:GetModule("Changelog"):HasRequiredVersion("4.7.0") then return requirement end

        elseif (requirement == I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED) then -- 12
            if F.IsAddOnEnabled("ElvUI_SLE") and E.db.sle.actionbar.vehicle.enabled then
                return requirement
            end

        elseif (requirement == I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED) then -- 13
            if F.IsAddOnEnabled("ElvUI_SLE") and E.db.sle and E.db.sle.minimap.coords.enable then
                return requirement
            end

        elseif (requirement == I.Enum.Requirements.SL_DECONSTRUCT_DISABLED) then -- 14
            if F.IsAddOnEnabled("ElvUI_SLE") and E.private.sle and
                (E.private.sle.professions.deconButton.enable or E.private.sle.professions.enchant.enchScroll) then
                return requirement
            end

        elseif (requirement == I.Enum.Requirements.SL_ARMORY_DISABLED) then -- 15
            if F.IsAddOnEnabled("ElvUI_SLE") and E.db.sle and
                (E.db.sle.armory.character.enable or E.db.sle.armory.inspect.enable or E.db.sle.armory.stats.enable) then
                return requirement
            end

        elseif (requirement == I.Enum.Requirements.SL_MEDIA_DISABLED) then -- 16
            if F.IsAddOnEnabled("ElvUI_SLE") then
                local sleVersion = GetAddOnMetadata("ElvUI_SLE", "Version")

                -- If no version was found, default to requirement unfullfilled
                if (not sleVersion) then return requirement end

                local sleVersionNumber = tonumber(sleVersion)

                -- If version could not be converted to int, default to requirement unfullfilled
                if (not sleVersionNumber) then return requirement end

                -- If an version is installed without toggle, fail, otherwise check the option
                if (sleVersionNumber <= 4.21) or (E.private.sle and E.private.sle.media and E.private.sle.media.enable) then
                    return requirement
                end
            end

        elseif (requirement == I.Enum.Requirements.WT_ENABLED) then -- 17
            if not F.IsAddOnEnabled("ElvUI_WindTools") then return requirement end

        elseif (requirement == I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED) then -- 18
            if F.IsAddOnEnabled("ElvUI_GlobalFadePersist") then return requirement end

        elseif (requirement == I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE) then -- 19
            if (not F.IsAddOnEnabled("Details")) or (not _G.Details) or (not _G.Details.GetCurrentProfileName) or
                (_G.Details.GetCurrentProfileName() ~= I.ProfileNames.Default) then return requirement end

        elseif (requirement == I.Enum.Requirements.ELVUI_BAGS_ENABLED) then -- 20
            if E.private.bags.enable ~= true then return requirement end
        end
    end

    return true
end
