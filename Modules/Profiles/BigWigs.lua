local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local _G = _G
local GetRealmName = GetRealmName
local UnitName = UnitName

function PF:BigWigs()
    local TXUI_BigWigs3DB = {}
    local profileName = I.ProfileNames[E.db.TXUI.installer.layout]

    if E.db.TXUI.installer.layout == I.Enum.Layouts.HEALER then
        -- LuaFormatter off
        TXUI_BigWigs3DB["namespaces"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName]["disabled"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName]["exitCombat"] = 4
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName]["mode"] = 4
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_height"] = 19.999946594238
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_width"] = 240.00003051758
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_x"] = 1173
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_y"] = 155
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_height"] = 21.999941253662
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_width"] = 264.00003356934
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_x"] = 1172.437317544
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_y"] = 125.53357141286
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["alignText"] = "RIGHT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["alignTime"] = "LEFT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["barStyle"] = "ElvUI"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["emphasizeMove"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["emphasizeTime"] = 10
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fill"] = true
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontSize"] = 16
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontSizeEmph"] = 16
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontSizeNameplate"] = 12
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["growup"] = true
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["iconPosition"] = "RIGHT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["spacing"] = 4
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["texture"] = "- Tx Left"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["visibleBarLimit"] = 8
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["visibleBarLimitEmph"] = 8
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"][1] = 0
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"][2] = 0.57647058823529
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"][3] = 0.83921568627451
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"]["default"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"]["default"][1] = 0.8
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"]["default"][3] = 0.54509803921569
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][1] = 0.70196078431373
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][2] = 0.14117647058824
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][3] = 0.14117647058824
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][4] = 1
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"][1] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"][2] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"][4] = 100
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName]["posx"] = 290
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName]["posy"] = 220
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["align"] = "RIGHT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphFontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphFontSize"] = 40
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][1] = "TOP"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][2] = "TOP"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][3] = 20
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][4] = -215
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphUppercase"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["fontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["fontSize"] = 24
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][1] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][2] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][3] = -329.99960327148
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][4] = 40
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["outline"] = "OUTLINE"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["fontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["height"] = 119.99997711182
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"]["ability"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"]["close"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"]["sound"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["posx"] = 1015
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["posy"] = 225
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["width"] = 140.00016784668
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"]["profiles"][profileName]["voice"] = "English: Jim"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"]["profiles"][profileName]["wipeSound"] = "Awww Crap"
        -- LuaFormatter on
    else
        -- LuaFormatter off
        TXUI_BigWigs3DB["namespaces"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName]["disabled"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName]["exitCombat"] = 4
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_AutoReply"]["profiles"][profileName]["mode"] = 4
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_height"] = 19.999946594238
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_width"] = 260.99996948242
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_x"] = 1173
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsAnchor_y"] = 155
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_height"] = 20.000003814697
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_width"] = 229.99995422363
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_x"] = 810
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["BigWigsEmphasizeAnchor_y"] = 300
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["alignText"] = "RIGHT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["alignTime"] = "LEFT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["barStyle"] = "ElvUI"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["emphasizeGrowup"] = true
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["emphasizeTime"] = 10
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fill"] = true
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontSize"] = 16
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontSizeEmph"] = 16
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["fontSizeNameplate"] = 12
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["growup"] = true
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["iconPosition"] = "RIGHT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["spacing"] = 4
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["texture"] = "- Tx Left"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["visibleBarLimit"] = 8
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"][profileName]["visibleBarLimitEmph"] = 8
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"][1] = 0
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"][2] = 0.52156862745098
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barColor"]["BigWigs_Plugins_Colors"]["default"][3] = 0.85098039215686
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"]["default"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"]["default"][1] = 0.65882352941176
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["barEmphasized"]["BigWigs_Plugins_Colors"]["default"][3] = 0.71372549019608
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][1] = 0.70196078431373
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][2] = 0.14117647058824
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][3] = 0.14117647058824
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Colors"]["profiles"][profileName]["red"]["BigWigs_Plugins_Colors"]["default"][4] = 1
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"][1] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"][2] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Countdown"]["profiles"][profileName]["position"][4] = 100
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName]["posx"] = 465
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_InfoBox"]["profiles"][profileName]["posy"] = 140
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["align"] = "RIGHT"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphFontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphFontSize"] = 40
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][1] = "TOP"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][2] = "TOP"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphPosition"][4] = -215
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["emphUppercase"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["fontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["fontSize"] = 24
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][1] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][2] = "CENTER"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][3] = -300
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["normalPosition"][4] = -140
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"][profileName]["outline"] = "OUTLINE"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["fontName"] = "- Big Noodle Titling"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"]["ability"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"]["close"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["objects"]["sound"] = false
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["posx"] = 845
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"][profileName]["posy"] = 155
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Pull"]["profiles"][profileName]["voice"] = "English: Jim"
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"]["profiles"] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"]["profiles"][profileName] = {}
        TXUI_BigWigs3DB["namespaces"]["BigWigs_Plugins_Wipe"]["profiles"][profileName]["wipeSound"] = "Awww Crap"
        -- LuaFormatter on
    end

    _G.BigWigsIconDB = { ["hide"] = true }

    -- The are not included in the export, change manually if needed
    TXUI_BigWigs3DB["profiles"] = {}
    TXUI_BigWigs3DB["profiles"][profileName] = {}
    TXUI_BigWigs3DB["profiles"][profileName]["showZoneMessages"] = true
    TXUI_BigWigs3DB["profiles"][profileName]["flash"] = true
    TXUI_BigWigs3DB["profiles"][profileName]["fakeDBMVersion"] = true

    -- Create global db is it dosent exist
    _G.BigWigs3DB = _G.BigWigs3DB and _G.BigWigs3DB or {}

    -- Copy to global big wigs table
    E:CopyTable(_G.BigWigs3DB, TXUI_BigWigs3DB)

    -- Create key for character
    self:BigWigs_Private()
end

function PF:BigWigs_Private()
    if not _G.BigWigs3DB then return end

    -- Create a profile key for the current player
    local name = UnitName("player")
    local realm = GetRealmName()

    -- Set our profile as preffered
    _G.BigWigs3DB.profileKeys = _G.BigWigs3DB.profileKeys and _G.BigWigs3DB.profileKeys or {}
    _G.BigWigs3DB.profileKeys[name .. " - " .. realm] = I.ProfileNames[E.db.TXUI.installer.layout]
end
