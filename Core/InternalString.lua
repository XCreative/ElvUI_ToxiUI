local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

I.Strings = {}

I.Strings.Requirements = {
    [I.Enum.Requirements.TOXIUI_PROFILE] = "NO_STRING_NEEDED",
    [I.Enum.Requirements.WEAK_AURAS_ENABLED] = "WeakAuras couldn't be detected. This could mean that the addon isn't installed or isn't enabled. Please ensure WeakAuras is installed and enabled in your AddOns menu.",
    [I.Enum.Requirements.MASQUE_DISABLED] = "Masque is currently installed and enabled. To use this option, please disable Masque, as it interferes with ToxiUI's WeakAuras skinning.",
    [I.Enum.Requirements.WT_WA_SKIN_DISABLED] = "WeakAuras skinning is currently enabled in WindTools. To use this option, please disable WeakAuras skinning in WindTools, as it interferes with ToxiUI's WeakAuras skinning.",
    [I.Enum.Requirements.SL_DISABLED] = "You can't enable this option because a similar module in Shadow & Light is currently turned on. Please disable it to unlock this option.",
    [I.Enum.Requirements.DARK_MODE_ENABLED] = "NO_STRING_NEEDED",
    [I.Enum.Requirements.DARK_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable dark mode",
    [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "NO_STRING_NEEDED",
    [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "Only one theme can be activated at the same time. Please disable gradient mode",
    [I.Enum.Requirements.PROFILE_ON_460] = "You can't enable this option because the installer was last run on an older version of ToxiUI. Please re-run the installer and perform a complete re-installation (including the Core Settings step) to unlock this option.",
    [I.Enum.Requirements.PROFILE_ON_470] = "You can't enable this option because the installer was last run on an older version of ToxiUI. Please re-run the installer and perform a complete re-installation (including the Core Settings step) to unlock this option.",
    [I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED] = "You can't enable this option because Shadow & Light's Vehicle Bar module is currently turned on. Please disable it to unlock this option.",
    [I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED] = "You can't enable this option because Shadow & Light's Minimap Coordinates module is currently turned on. Please disable it to unlock this option.",
    [I.Enum.Requirements.SL_DECONSTRUCT_DISABLED] = "You can't enable this option because Shadow & Light's Deconstruct module is currently turned on. Please disable it to unlock this option.",
    [I.Enum.Requirements.SL_ARMORY_DISABLED] = "You can't enable this option because Shadow & Light's Character Armory module is currently turned on. Please disable it to unlock this option.",
    [I.Enum.Requirements.SL_MEDIA_DISABLED] = "You can't enable this option because Shadow & Light's Media module is currently turned on. Please disable it to unlock this option.",
    [I.Enum.Requirements.WT_ENABLED] = "NO_STRING_NEEDED",
    [I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED] = "ElvUI_GlobalFadePersist is currently installed and enabled. To use this option, please disable ElvUI_GlobalFadePersist, as it interferes with ToxiUI's global fade persist.",
    [I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE] = "NO_STRING_NEEDED",
    [I.Enum.Requirements.ELVUI_BAGS_ENABLED] = "You can't enable this option because ElvUI's Bag module is currently turned off. Please enable it to unlock this option."
}

I.Strings.RequirementsDebug = {
    [I.Enum.Requirements.TOXIUI_PROFILE] = "No ToxiUI Profile",
    [I.Enum.Requirements.WEAK_AURAS_ENABLED] = "WA Disabled",
    [I.Enum.Requirements.MASQUE_DISABLED] = "MQ Enabled",
    [I.Enum.Requirements.WT_WA_SKIN_DISABLED] = "WT Skin Enabled",
    [I.Enum.Requirements.SL_DISABLED] = "SL Enabled",
    [I.Enum.Requirements.DARK_MODE_ENABLED] = "DM Disabled",
    [I.Enum.Requirements.DARK_MODE_DISABLED] = "DM Enabled",
    [I.Enum.Requirements.GRADIENT_MODE_ENABLED] = "GM Disabled",
    [I.Enum.Requirements.GRADIENT_MODE_DISABLED] = "GM Enabled",
    [I.Enum.Requirements.PROFILE_ON_460] = "Old Profile",
    [I.Enum.Requirements.PROFILE_ON_470] = "Old Profile"
}

I.Strings.ChangelogText = { [I.Enum.ChangelogType.HOTFIX] = "Hotfix - no notes." }

I.Strings.Colors = {
    [I.Enum.Colors.TXUI] = "00e4f5",
    [I.Enum.Colors.ELVUI] = "1784d1",
    [I.Enum.Colors.ERROR] = "ef5350",
    [I.Enum.Colors.GOOD] = "66bb6a",
    [I.Enum.Colors.WARNING] = "f5b041",
    [I.Enum.Colors.INSTALLER_WARNING] = "d30000",
    [I.Enum.Colors.WHITE] = "ffffff",
    [I.Enum.Colors.LUXTHOS] = "03fc9c"
}

I.Strings.Deconstruct = {
    Status = {
        Title = F.StringColor("Deconstruct", I.Enum.Colors.WHITE),
        Text = "With Deconstruct enabled, hover over your items\nto easily DISENCHANT/PROSPECT/MILL them.\n\n Current state: %s",
        Inactive = F.StringError("Inactive"),
        Active = F.StringGood("Active")
    },

    Label = {
        [I.Enum.DeconstructState.DISENCHANT] = "DE",
        [I.Enum.DeconstructState.PROSPECT] = "PROSP",
        [I.Enum.DeconstructState.MILL] = "MILL"
    },

    Color = {
        [I.Enum.DeconstructState.DISENCHANT] = { r = 0 / 255, g = 128 / 255, b = 255 / 255, a = 1 },
        [I.Enum.DeconstructState.PROSPECT] = { r = 218 / 255, g = 229 / 255, b = 71 / 255, a = 1 },
        [I.Enum.DeconstructState.MILL] = { r = 71 / 255, g = 229 / 255, b = 155 / 255, a = 1 }
    }
}
