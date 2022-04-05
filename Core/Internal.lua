local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

-- General settings
I.General = {
    AddOnPath = "Interface\\AddOns\\ElvUI_ToxiUI\\",
    MediaPath = "Interface\\AddOns\\ElvUI_ToxiUI\\Media\\",

    ChatFontSize = 16,

    -- Default font, this is not used inside profiles but is meant as fallback if settings are invalid
    DefaultFont = "- Futura",
    DefaultFontSize = 18,
    DefaultFontShadow = false,
    DefaultFontOutline = "NONE",
    DefaultFontColor = "CUSTOM", -- CLASS, VALUE (ElvUI), CUSTOM
    DefaultFontCustomColor = { ["r"] = 1, ["g"] = 0, ["b"] = 0, ["a"] = 1 }
}

I.MediaKeys = {
    font = "Fonts",
    texture = "Textures",
    chaticon = "ChatIcons",
    icon = "Icons",
    role = "RoleIcons",
    state = "StateIcons",
    theme = "Themes",
    logo = "Logos",
    armory = "Armory"
}

I.MediaPaths = {
    font = [[Interface\AddOns\ElvUI_ToxiUI\Media\Fonts\]],
    texture = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\]],
    chaticon = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\ChatIcons\]],
    icon = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\Icons\]],
    role = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\Role\]],
    state = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\State\]],
    theme = [[Interface\AddOns\ElvUI_ToxiUI\Media\Textures\Themes\]],
    logo = [[Interface\AddOns\ElvUI_ToxiUI\Media\Backgrounds\Logos\]],
    armory = [[Interface\AddOns\ElvUI_ToxiUI\Media\Backgrounds\Armory\]]
}

-- Media
-- Look inside Media/Core.lua for all media files
I.Media = {
    Fonts = {},
    Textures = {},
    ChatIcons = {},
    Icons = {},
    RoleIcons = {},
    StateIcons = {},
    Themes = {},
    Logos = {},
    Armory = {}
}

-- Profile names to be used
-- This only affects DBM/BigWigs
I.ProfileNames = {
    ["Default"] = "ToxiUI", -- Plater, Details
    [I.Enum.Layouts.DPS] = "ToxiUI-DPS", -- DBM/BigWigs
    [I.Enum.Layouts.HEALER] = "ToxiUI-Healer" -- DBM/BigWigs
}

I.Requirements = {
    ["WeakAurasIcons"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.WEAK_AURAS_ENABLED, -- 2
        I.Enum.Requirements.WT_WA_SKIN_DISABLED, -- 3
        I.Enum.Requirements.MASQUE_DISABLED -- 4
    },
    ["WeakAurasBars"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.WEAK_AURAS_ENABLED, -- 2
        I.Enum.Requirements.WT_WA_SKIN_DISABLED -- 3
    },
    ["DarkMode"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.GRADIENT_MODE_DISABLED -- 2
    },
    ["DarkModeTransparency"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.DARK_MODE_ENABLED, -- 2
        I.Enum.Requirements.GRADIENT_MODE_DISABLED -- 3
    },
    ["GradientMode"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.DARK_MODE_DISABLED -- 2
    },
    ["WunderBar"] = {
        I.Enum.Requirements.PROFILE_ON_470 -- 1
    },
    ["VehicleBar"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.SL_VEHICLE_BAR_DISABLED -- 2
    },
    ["MiniMapCoords"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.SL_MINIMAP_COORDS_DISABLED -- 2
    },
    ["FadePersist"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.OLD_FADE_PERSIST_DISABLED -- 2
    },
    ["GameMenuButton"] = {
        I.Enum.Requirements.PROFILE_ON_470 -- 1
    },
    ["BlizzardFonts"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.SL_MEDIA_DISABLED -- 2
    },
    ["RoleIcons"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.SL_DISABLED -- 2
    },
    ["DetailsGradientMode"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.DARK_MODE_DISABLED, -- 2
        I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE -- 3
    },
    ["DetailsDarkMode"] = {
        I.Enum.Requirements.PROFILE_ON_460, -- 1
        I.Enum.Requirements.GRADIENT_MODE_DISABLED, -- 2
        I.Enum.Requirements.DETAILS_LOADED_AND_TXPROFILE -- 3
    },
    ["Armory"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.SL_ARMORY_DISABLED -- 2
    },
    ["Deconstruct"] = {
        I.Enum.Requirements.PROFILE_ON_470, -- 1
        I.Enum.Requirements.SL_DECONSTRUCT_DISABLED, -- 2
        I.Enum.Requirements.ELVUI_BAGS_ENABLED -- 3
    }
}

-- Controls Settings about the Fancy Gradient Theme
-- if the value is "false" or it's not in one of the arrays it defaults to the mid texture
I.GradientMode = {
    -- Used when no gradient color is defined
    ["BackupMultiplier"] = 0.65,

    -- Shared Media Statusbar texture names
    ["Textures"] = { ["Left"] = "- Tx Left", ["Right"] = "- Tx Right", ["Mid"] = "- Tx Mid" },

    -- Layout specific settings
    ["Layouts"] = {
        -- Healer layout specific settings
        [I.Enum.Layouts.HEALER] = {
            -- Left Healer Gradient
            ["Left"] = {
                ["player"] = true,
                ["pet"] = true,
                ["tank"] = true,
                ["tanktarget"] = true,
                ["assist"] = true,
                ["assisttarget"] = true
            },

            -- Right Healer Gradient
            ["Right"] = {
                ["target"] = true,
                ["targettarget"] = true,
                ["arena"] = true,
                ["boss"] = true,
                ["focus"] = true
            }
        },

        -- DPS layout specific settings
        [I.Enum.Layouts.DPS] = {
            -- Left DPS Gradient
            ["Left"] = {
                ["player"] = true,
                ["pet"] = true,
                ["party"] = true,
                ["raid"] = true,
                ["raid40"] = true,
                ["tank"] = true,
                ["tanktarget"] = true,
                ["assist"] = true,
                ["assisttarget"] = true
            },

            -- Right DPS Gradient
            ["Right"] = { ["target"] = true, ["targettarget"] = true, ["arena"] = true, ["boss"] = true }
        }
    }
}

I.ElvUIIcons = {
    ["Role"] = {
        ["TXUI"] = {
            ["default"] = { TANK = "NewTank", HEALER = "NewHeal", DAMAGER = "NewDPS" },
            ["raid"] = { TANK = "NewSmallTank", HEALER = "NewSmallHeal", DAMAGER = "NewSmallDPS" },
            ["raid40"] = { TANK = "NewSmallTank", HEALER = "NewSmallHeal", DAMAGER = "NewSmallDPS" }
        },

        ["TXUI_WHITE"] = { ["default"] = { TANK = "WhiteTank", HEALER = "WhiteHeal", DAMAGER = "WhiteDPS" } }
    },

    ["Dead"] = { ["TXUI"] = "WhiteDead", ["BLIZZARD"] = "Interface\\LootFrame\\LootPanel-Icon" },

    ["Offline"] = {
        ["TXUI"] = "WhiteDC",
        ["ALERT"] = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew",
        ["ARTHAS"] = "Interface\\LFGFRAME\\UI-LFR-PORTRAIT",
        ["PASS"] = "Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent",
        ["NOTREADY"] = "Interface\\RAIDFRAME\\ReadyCheck-NotReady"
    }
}

I.ChatIconNames = {
    [I.Enum.ChatIconType.DEV] = {
        [I.Enum.Developers.NAWUKO] = {
            -- Ravencrest
            ["Nawuko-Ravencrest"] = true,
            ["Koshia-Ravencrest"] = true,
            ["Huntes-Ravencrest"] = true,
            ["Elysai-Ravencrest"] = true,
            ["Wunderpriest-Ravencrest"] = true,
            ["Wunderlock-Ravencrest"] = true,
            ["Wunderfurry-Ravencrest"] = true,
            ["Wareborne-Ravencrest"] = true
        },

        [I.Enum.Developers.TOXI] = {
            -- Ravencrest
            ["Calistrø-Ravencrest"] = true,
            ["Calìstro-Ravencrest"] = true,
            ["Melissandei-Ravencrest"] = true,
            ["Toxí-Ravencrest"] = true,
            ["Toxicom-Ravencrest"] = true,
            ["Toxicòm-Ravencrest"] = true,
            ["Toxicøm-Ravencrest"] = true,
            ["Tòxicom-Ravencrest"] = true,
            ["Tøxicom-Ravencrest"] = true,
            ["Tøxii-Ravencrest"] = true,
            ["Toxilich-Ravencrest"] = true,

            -- TarrenMill
            ["Toxiholy-TarrenMill"] = true,
            ["Toxicom-TarrenMill"] = true,
            ["Toxirage-TarrenMill"] = true,
            ["Toxiglide-TarrenMill"] = true,
            ["Toxiquiver-TarrenMill"] = true,
            ["Toxilock-TarrenMill"] = true,
            ["Toxisin-TarrenMill"] = true,
            ["Toximoon-TarrenMill"] = true,
            ["Toxifurry-TarrenMill"] = true,
            ["Toxiwiz-TarrenMill"] = true
        },

        [I.Enum.Developers.RHAP] = {
            -- Illidan
            ["Rhapsodicoli-Illidan"] = true,
            ["Rhapsodicola-Illidan"] = true,
            ["Pointyhorn-Illidan"] = true,
            ["Monksody-Illidan"] = true,
            ["Shamansody-Ilidan"] = true,
            ["Roguesody-Illidan"] = true,
            ["Magesody-Illidan"] = true,
            ["Deathsody-Illidan"] = true,
            ["Rhapsoditank-Illidan"] = true,

            -- Sargeras
            ["Forthéhorde-Sargeras"] = true
        },

        [I.Enum.Developers.JAKE] = {
            -- Arathor
            ["Getafix-Arathor"] = true, -- best bear ever btw
            ["Kari-Arathor"] = true,
            ["Kiasi-Arathor"] = true,
            ["Lexza-Arathor"] = true,
            ["Rai-Arathor"] = true,
            ["Raifel-Arathor"] = true,
            ["Raih-Arathor"] = true,
            ["Raivas-Arathor"] = true,

            -- Daggerspine
            ["Aurrius-Daggerspine"] = true,
            ["Raovasbank-Daggerspine"] = true
        }
    },

    [I.Enum.ChatIconType.BETA] = {
        Jeor = {
            ["Beefsteak-Korgath"] = true,
            ["Groham-Korgath"] = true,
            ["Imacat-Korgath"] = true,
            ["Terrafin-Korgath"] = true,
            ["Terrafina-Korgath"] = true
        },

        librarifran = {
            ["Besmara-Mal'Ganis"] = true,
            ["Cavtha-Mal'Ganis"] = true,
            ["Cavtha-SilverHand"] = true,
            ["Lethns-SilverHand"] = true
        }
    },

    [I.Enum.ChatIconType.VIP] = {
        vOdKa = {
            ["Bakul-Antonidas"] = true -- Yes, only 1 Char, 1 Main, He is insane!
        },

        Nalar = {
            ["Julka-BurningBlade"] = true,
            ["Lamaxx-BurningBlade"] = true,
            ["Maxentius-Drak'thul"] = true,
            ["Morgenstein-BurningBlade"] = true,
            ["Morgrim-BurningBlade"] = true,
            ["Praxila-Drak'thul"] = true,
            ["Ressil-BurningBlade"] = true,
            ["Sarity-BurningBlade"] = true,
            ["Vesso-Drak'thul"] = true
        },

        eaglegoboom = {
            ["Boomtassels-Alleria"] = true,
            ["Cure-Alleria"] = true,
            ["Disctassels-Alleria"] = true,
            ["Portmeround-Alleria"] = true
        }
    }
}

-- Holds all data important to use, and will be filled with the below entries when GameBar is loaded
-- type, name, known [known is always true for items]
I.HearthstoneDataLoaded = false
I.HearthstoneData = {
    [556] = { ["type"] = "spell", ["hearthstone"] = true, ["class"] = "SHAMAN" }, -- Astral Recall
    [6948] = { ["type"] = "item", ["hearthstone"] = true }, -- Hearthstone
    [48933] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Northrend
    [50977] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DEATHKNIGHT" }, -- Death Gate
    [54452] = { ["type"] = "toy", ["hearthstone"] = true }, -- Ethereal Portal
    [64488] = { ["type"] = "toy", ["hearthstone"] = true }, -- The Innkeeper's Daughter
    [87215] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Pandaria
    [93672] = { ["type"] = "toy", ["hearthstone"] = true }, -- Dark Portal
    [110560] = { ["type"] = "item", ["hearthstone"] = false }, -- Garrison Hearthstone
    [126892] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "MONK" }, -- Zen Pilgrimage
    [132517] = { ["type"] = "toy", ["hearthstone"] = false }, -- Intra-Dalaran Wormhole Generator
    [140192] = { ["type"] = "item", ["hearthstone"] = false }, -- Dalaran Hearthstone
    [141605] = { ["type"] = "item", ["hearthstone"] = false }, -- Flight Master's Whistle
    [142542] = { ["type"] = "toy", ["hearthstone"] = true }, -- Tome of Town Portal
    [151652] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Argus
    [162973] = { ["type"] = "toy", ["hearthstone"] = true }, -- Greatfather Winter's Hearthstone
    [163045] = { ["type"] = "toy", ["hearthstone"] = true }, -- Headless Horseman's Hearthstone
    [165669] = { ["type"] = "toy", ["hearthstone"] = true }, -- Lunar Elder's Hearthstone
    [165670] = { ["type"] = "toy", ["hearthstone"] = true }, -- Peddlefeet's Lovely Hearthstone
    [165802] = { ["type"] = "toy", ["hearthstone"] = true }, -- Noble Gardener's Hearthstone
    [166746] = { ["type"] = "toy", ["hearthstone"] = true }, -- Fire Eater's Hearthstone
    [166747] = { ["type"] = "toy", ["hearthstone"] = true }, -- Brewfest Reveler's Hearthstone
    [168807] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Kul Tiras
    [168808] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Zandalar
    [168907] = { ["type"] = "toy", ["hearthstone"] = true }, -- Holographic Digitalization Hearthstone
    [172179] = { ["type"] = "toy", ["hearthstone"] = true }, -- Eternal Traveler's Hearthstone
    [172924] = { ["type"] = "toy", ["hearthstone"] = false }, -- Wormhole Generator: Shadowlands
    [180290] = { ["type"] = "toy", ["hearthstone"] = true }, -- Night Fae Hearthstone
    [180817] = { ["type"] = "toy", ["hearthstone"] = true }, -- Cypher of Relocation
    [182773] = { ["type"] = "toy", ["hearthstone"] = true }, -- Necrolord Hearthstone
    [183716] = { ["type"] = "toy", ["hearthstone"] = true }, -- Venthyr Sinstone
    [184353] = { ["type"] = "toy", ["hearthstone"] = true }, -- Kyrian Hearthstone
    [193753] = { ["type"] = "spell", ["hearthstone"] = false, ["class"] = "DRUID" }, -- Dreamwalk
    [312372] = { ["type"] = "spell", ["hearthstone"] = false }, -- Return to Camp (Vulpera Racial)
    [324547] = { ["type"] = "spell", ["hearthstone"] = false }, -- Hearth Kidneystone (Necrolord Soulbind)
    [190237] = { ["type"] = "toy", ["hearthstone"] = true }, -- Broker Translocation Matrix

    -- Mage specific
    [193759] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Hall of the Guardian

    [344597] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Oribos
    [344587] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Oribos

    [10059] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Stormwind
    [11417] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Portal: Orgrimmar

    [268969] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dazar'alor
    [281402] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dazar'alor

    [281403] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Boralus
    [281404] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Boralus

    [224871] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dalaran (Legion)
    [224869] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dalaran (Legion)

    [132620] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Vale of Eternal Blossoms - Horde
    [132626] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Vale of Eternal Blossoms - Horde

    [132621] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Vale of Eternal Blossoms - Alliance
    [132627] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Vale of Eternal Blossoms - Alliance

    [53142] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Dalaran (Northrend)
    [53140] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Dalaran (Northrend)

    [11419] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Darnassus
    [3565] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Darnassus

    [11420] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Thunder Bluff
    [3566] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Thunder Bluff

    [11418] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Undercity
    [3563] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Undercity

    [11416] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Ironforge
    [3562] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Ironforge

    [32267] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Silvermoon
    [32272] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true }, -- Teleport: Silvermoon

    [32266] = { ["type"] = "spell", ["hearthstone"] = false, ["portal"] = true }, -- Portal: Exodar
    [32271] = { ["type"] = "spell", ["hearthstone"] = false, ["teleport"] = true } -- Teleport: Exodar
}

-- Import use
I.NameImportData = ""
