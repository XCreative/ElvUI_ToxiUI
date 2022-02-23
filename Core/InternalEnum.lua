local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

I.Enum = {}

-- IDs for layouts
I.Enum.Layouts = F.Enum { "DPS", "HEALER" }

-- Internal and Option Dialog reasons for modules to be disabled
I.Enum.Requirements = F.Enum {
    "TOXIUI_PROFILE", -- 1, Checked by default
    "WEAK_AURAS_ENABLED", -- 2
    "MASQUE_DISABLED", -- 3
    "WT_WA_SKIN_DISABLED", -- 4
    "SL_DISABLED", -- 5
    "DARK_MODE_ENABLED", -- 6
    "DARK_MODE_DISABLED", -- 7
    "GRADIENT_MODE_ENABLED", -- 8
    "GRADIENT_MODE_DISABLED", -- 9
    "PROFILE_ON_460", -- 10
    "PROFILE_ON_470", -- 11
    "SL_VEHICLE_BAR_DISABLED", -- 12
    "SL_MINIMAP_COORDS_DISABLED", -- 13
    "SL_DECONSTRUCT_DISABLED", -- 14
    "SL_ARMORY_DISABLED", -- 15
    "SL_MEDIA_DISABLED", -- 16
    "WT_ENABLED", -- 17
    "OLD_FADE_PERSIST_DISABLED", -- 18
    "DETAILS_LOADED_AND_TXPROFILE", -- 19
    "ELVUI_BAGS_ENABLED" -- 20
}

-- Used for F.StringColor functions
I.Enum.Colors = F.Enum {
    "TXUI", -- AddOnColor
    "ELVUI", -- ElvUI Default Blue color
    "ELVUI_VALUE", -- Dynamic ElvUI Value Color
    "CLASS", -- Dynamic Class Color
    "GOOD", -- Bright Green
    "ERROR", -- Bright Red
    "INSTALLER_WARNING", -- Contrast Red
    "WARNING", -- Yelloish color
    "WHITE", -- White duh
    "LUXTHOS" -- Luxthos color
}

-- Used for gradient theme
I.Enum.GradientMode = {
    Direction = F.Enum { "LEFT", "RIGHT" },
    Mode = F.Enum { "HORIZONTAL", "VERTICAL" },
    Color = F.Enum { "SHIFT", "NORMAL" }
}

-- Types for Chat Icons
I.Enum.ChatIconType = F.Enum { "DEV", "BETA", "VIP" }

-- Types of modes for deconstruct
I.Enum.DeconstructState = F.Enum { "NONE", "DISENCHANT", "PROSPECT", "MILL" }

-- Types for Icon Shape
I.Enum.IconShape = F.Enum { "SQUARE", "RECTANGLE" }

-- Types for changelogs
I.Enum.ChangelogType = F.Enum { "UPDATE", "HOTFIX" }

-- ! Personal changes
I.Enum.Developers = F.Enum { "NAWUKO", "TOXI", "RHAP", "JAKE" }
