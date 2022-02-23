local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

function PF:ElvUILayout()
    if E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER then
        -- Player
        E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-325,380"
        E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-280,377"
        E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-325,350"
        E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-280,347"
        E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 250
        -- Target
        E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,325,350"
        E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,325,380"
        -- E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-515,395"
        E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,280,377"
        -- Party
        E.db["movers"]["ElvUF_PartyMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,220"
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["size"] = 32
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["yOffset"] = 0
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["xOffset"] = 7
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["yOffset"] = 0
        E.db["unitframe"]["units"]["party"]["height"] = 60
        E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 5
        E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 5
        E.db["unitframe"]["units"]["party"]["showPlayer"] = true
        E.db["unitframe"]["units"]["party"]["growthDirection"] = "RIGHT_DOWN"
        E.db["unitframe"]["units"]["party"]["width"] = 150
        E.db["unitframe"]["units"]["party"]["power"]["height"] = 15
        E.db["unitframe"]["units"]["party"]["power"]["width"] = "filled"
        E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = true
        E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "TOPLEFT"
        E.db["unitframe"]["units"]["party"]["rdebuffs"]["enable"] = true
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["text_format"] = "[name:short]"
        E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "TOPLEFT"
        E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 22
        E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -10
        E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 10
        E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = false
        -- Raid
        E.db["movers"]["ElvUF_RaidMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,120"
        E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_DOWN"
        -- Raid40
        E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOM,ElvUIParent,BOTTOM,0,120"
        E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_DOWN"
        -- Pet
        -- E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,515,395"
        E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,-330,360"
        -- Focus
        E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,325,543"
        E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,325,570"
        E.db["movers"]["FocusPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,280,566"
        -- Action Bars
        E.db["movers"]["ShiftAB"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-646,122"
        -- Misc
        E.db["movers"]["AltPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,326,518"
        E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,565,235"
        E.db["movers"]["ZoneAbility"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,565,235"
        -- ToxiUI WA Anchor
        E.db["movers"]["ToxiUIWAAnchorMover"] = "CENTER,ElvUIParent,CENTER,0,-140"
    else
        -- Player
        E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-325,350"
        E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-280,347"
        E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,1,300"
        E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-280,317"
        E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 298
        -- Target
        E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,325,320"
        E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,325,350"
        -- E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-515,365"
        E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,280,347"
        -- Party
        E.db["movers"]["ElvUF_PartyMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,250,-460"
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["size"] = 24
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Health"]["yOffset"] = 25
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["xOffset"] = 10
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["yOffset"] = 25
        E.db["unitframe"]["units"]["party"]["height"] = 30
        E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 30
        E.db["unitframe"]["units"]["party"]["horizontalSpacing"] = 5
        E.db["unitframe"]["units"]["party"]["showPlayer"] = false
        E.db["unitframe"]["units"]["party"]["growthDirection"] = "DOWN_LEFT"
        E.db["unitframe"]["units"]["party"]["width"] = 200
        E.db["unitframe"]["units"]["party"]["power"]["height"] = 10
        E.db["unitframe"]["units"]["party"]["power"]["width"] = "spaced"
        E.db["unitframe"]["units"]["party"]["buffs"]["enable"] = false
        E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "RIGHT"
        E.db["unitframe"]["units"]["party"]["rdebuffs"]["enable"] = false
        E.db["unitframe"]["units"]["party"]["customTexts"]["!Name"]["text_format"] = "[name:medium]"
        E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "LEFT"
        E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 32
        E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -35
        E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
        E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = true
        -- Raid
        E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,60,335"
        E.db["unitframe"]["units"]["raid"]["growthDirection"] = "RIGHT_UP"
        -- Raid40
        E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,60,335"
        E.db["unitframe"]["units"]["raid40"]["growthDirection"] = "RIGHT_UP"
        -- Pet
        -- E.db["movers"]["ElvUF_PetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,515,365"
        E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,-330,330"
        -- Focus
        E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,110"
        E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,135"
        E.db["movers"]["FocusPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,132"
        -- Action Bars
        E.db["movers"]["ShiftAB"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,778,110"
        -- Misc
        E.db["movers"]["AltPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,180"
        E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,-300,200"
        E.db["movers"]["ZoneAbility"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,630,200"
        E.db["movers"]["LossControlMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,505"
        -- ToxiUI WA Anchor
        E.db["movers"]["ToxiUIWAAnchorMover"] = "CENTER,ElvUIParent,CENTER,0,-200"
    end
end
