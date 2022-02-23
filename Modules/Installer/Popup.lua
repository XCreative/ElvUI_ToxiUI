local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local IS = TXUI:GetModule("Installer")

--[[ Discord Popup Link ]] --
function IS:PopupDiscordLink()
    -- Create popup if it dosen't exist
    if not E.PopupDialogs.TXUI_DiscordLinkDisplay then
        E.PopupDialogs.TXUI_DiscordLinkDisplay = E.PopupDialogs.ELVUI_EDITBOX
        E.PopupDialogs.TXUI_DiscordLinkDisplay["text"] = "Use the following link to join us on Discord"
    end

    -- Show Popup
    E:StaticPopup_Show("TXUI_DiscordLinkDisplay", nil, nil, TXUI.Links.DiscordToxi)
end

--[[ Weakauras Popup Link ]] --
function IS:PopupWALink()
    -- Create popup if it dosen't exist
    if not E.PopupDialogs.TXUI_WALinkDisplay then
        E.PopupDialogs.TXUI_WALinkDisplay = E.PopupDialogs.ELVUI_EDITBOX
        E.PopupDialogs.TXUI_WALinkDisplay["text"] =
            "Use the following link to download " .. F.StringLuxthos("Luxthos") .. " WeakAuras!"
    end

    -- Show Popup
    E:StaticPopup_Show("TXUI_WALinkDisplay", nil, nil, TXUI.Links.WALink)
end
