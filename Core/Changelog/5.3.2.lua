local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["5.3.2"] = {
    -- LuaFormatter off
    HOTFIX = true,
    CHANGES = {
        "* General",
        F.StringElvUI(" WindTools") .. ": Disable Blizzard and ElvUI Skins by default, since we provide our own",
        F.StringElvUI(" ElvUI") .. ": Enable transparent actionbars",
        F.StringElvUI(" ElvUI") .. ": Enable Parchment Remover",
        " Armory: Increase the default alpha % for background",
        " WunderBar: Fix LUA error",
        " AFK: Fix LUA error",
    }
    -- LuaFormatter on
}
