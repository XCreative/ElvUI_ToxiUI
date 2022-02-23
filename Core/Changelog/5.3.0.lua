local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

TXUI.Changelog["5.3.0"] = {
    -- LuaFormatter off
    CHANGES = {
        "* Features",
        " Custom Theme for " .. F.StringElvUI(" ElvUI") .. F.StringError(" [BETA]"),
        "* General",
        F.StringElvUI(" WindTools") .. ": Enabled Raid Marker bar",
        " Plater: Cast Bar colors for Interrupt",
        " Armory: Option to abbreviate enchant strings",
        " Armory: Option to change colors",
        " Armory: Options to position Header text",
        " VehicleBar: Added mover anchor",
        " Icon Skin: Option to change the shape for WeakAuras",
        "* WunderBar",
        " General: Now auto-hides during Pet Battles",
        " Time: Format options added",
        " MicroMenu: Retail-only filter for Social button",
    }
    -- LuaFormatter on
}
