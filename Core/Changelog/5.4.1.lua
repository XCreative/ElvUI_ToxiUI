local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["5.4.1"] = {
    -- LuaFormatter off
    HOTFIX = true,
    CHANGES = {
        "* Misc",
        " Fix " .. F.StringElvUI("ElvUI WindTools") .. " LUA error during installer",
    }
    -- LuaFormatter on
}
