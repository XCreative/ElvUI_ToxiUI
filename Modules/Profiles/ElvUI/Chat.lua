local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")
local CH = E:GetModule("Chat")

local _G = _G
local ipairs = ipairs
local tinsert = table.insert

local ChangeChatColor = ChangeChatColor
local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups
local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SetWindowName = FCF_SetWindowName
local GENERAL = GENERAL
local GUILD_EVENT_LOG = GUILD_EVENT_LOG
local ToggleChatColorNamesByClassGroup = ToggleChatColorNamesByClassGroup
local TRADE = TRADE

function PF:ElvUIChatFont()
    -- Set chat font size
    for _, name in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[name]
        FCF_SetChatWindowFontSize(nil, frame, I.General.ChatFontSize)
    end
end

-- copied from E:SetupChat and changed to 1 window only
function PF:ElvUIChat()
    FCF_ResetChatWindows() -- 1, 2
    FCF_OpenNewWindow() -- 3
    FCF_OpenNewWindow() -- 4

    for _, name in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[name]
        local id = frame:GetID()

        CH:FCFTab_UpdateColors(CH:GetTab(_G[name]))

        if id == 1 then
            FCF_SetWindowName(frame, GENERAL)
        elseif id == 2 then
            FCF_SetWindowName(frame, GUILD_EVENT_LOG)
        elseif id == 3 then
            FCF_SetWindowName(frame, TRADE)
        elseif id == 4 then
            FCF_SetWindowName(frame, "Social")
        end
    end

    -- General 1
    local chatGroup = {
        "SYSTEM", "CHANNEL", "SAY", "EMOTE", "YELL", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE", "MONSTER_WHISPER",
        "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER", "ERRORS", "AFK", "DND", "IGNORED", "BG_HORDE", "BG_ALLIANCE",
        "BG_NEUTRAL", "ACHIEVEMENT"
    }
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
    for _, v in ipairs(chatGroup) do ChatFrame_AddMessageGroup(_G.ChatFrame1, v) end

    -- Loot/Trade 3
    chatGroup = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY" }
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame3)
    for _, k in ipairs(chatGroup) do ChatFrame_AddMessageGroup(_G.ChatFrame3, k) end

    -- Social 4
    chatGroup = {
        "WHISPER", "BN_WHISPER", "BN_INLINE_TOAST_ALERT", "IGNORED", "GUILD", "GUILD_ACHIEVEMENT", "OFFICER", "PARTY",
        "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER"
    }
    ChatFrame_RemoveAllMessageGroups(_G.ChatFrame4)
    for _, k in ipairs(chatGroup) do ChatFrame_AddMessageGroup(_G.ChatFrame4, k) end

    -- Set the chat groups names in class color to enabled for all chat groups which players names appear
    chatGroup = {
        "SAY", "EMOTE", "YELL", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING",
        "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER", "ACHIEVEMENT", "GUILD_ACHIEVEMENT",
        "COMMUNITIES_CHANNEL"
    }

    for i = 1, _G.MAX_WOW_CHAT_CHANNELS do tinsert(chatGroup, "CHANNEL" .. i) end
    for _, v in ipairs(chatGroup) do ToggleChatColorNamesByClassGroup(true, v) end

    -- Add Trade to 3
    ChatFrame_AddChannel(_G.ChatFrame1, GENERAL)
    ChatFrame_RemoveChannel(_G.ChatFrame1, TRADE)
    ChatFrame_AddChannel(_G.ChatFrame3, TRADE)

    -- Adjust Chat Colors
    ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255) -- General
    ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255) -- Trade
    ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255) -- Local Defense

    -- Apply chat font size
    self:ElvUIChatFont()
end
