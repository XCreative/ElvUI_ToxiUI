local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["4.2.0"] = {
    -- LuaFormatter off
    CHANGES = {
        "* General",
        " Fixed Details not properly applying profile",
        " Changelog now features several versions for comparing",
        " Changes to Plater import logic (similar to Details)",
        " Added warning to installer if you have |cff00e4f5SharedMedia: ToxiUI|r",
        " Added ToxiUI + version to the top of ElvUI panel",
        " Removed the 1px border from ToxiUI texture",
        " Changed login message link",

        "* ElvUI",
        " Made Player castbar shorter",
        " Moved Player castbar 1px to right",
        " Pet and ToT frames now position correctly on all resolutions",

        "* Details",
        " Slight positioning/size adjustments",

        "* XIV Databar:",
        " Bar color now has Gradient fade (need to change alpha to see the change)"
    }
    -- LuaFormatter on
}
