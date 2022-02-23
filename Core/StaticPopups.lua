local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local YES = YES
local NO = NO

function TXUI:LoadStaticPopups()
    E.PopupDialogs.TXUI_RESET_TXUI_PROFILE = {
        text = "Are you sure you want to reset " .. TXUI.Title .. "?" .. "\n\nThis will reset all settings from " ..
            TXUI.Title .. ", but " .. F.StringError("NOT") .. " your " .. F.StringElvUI("ElvUI") .. " Profile!",
        button1 = F.StringError(YES),
        button2 = F.StringGood(NO),
        hideOnEscape = 1,
        whileDead = 1,
        OnAccept = function()
            F.ResetTXUIProfile()
        end
    }

    E.PopupDialogs.TXUI_RESET_MODULE_PROFILE = {
        text = "Are you sure you want to reset " .. F.StringError("%s") .. "?",
        button1 = F.StringError(YES),
        button2 = F.StringGood(NO),
        hideOnEscape = 1,
        whileDead = 1,
        OnAccept = function(_, profile)
            F.ResetModuleProfile(profile)
        end
    }
end
