local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["5.3.7"] = {
    -- LuaFormatter off
    HOTFIX = true,
    CHANGES = {
        "* Misc",
        " Update for Patch 9.2: Eternity's End",
        " Update the required minimal " .. F.StringElvUI(" ElvUI") .. " version to 12.65",
        " Fix " .. F.StringElvUI(" Shadow & Light") .. " Vehicle Bar conflict error",
    }
    -- LuaFormatter on
}
