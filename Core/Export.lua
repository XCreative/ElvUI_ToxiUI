local TXUI, F, E, I, V, P, G = unpack(select(2, ...))

local _G = _G
local gsub = string.gsub
local ipairs = ipairs
local match = string.match
local next = next
local pairs = pairs
local ReloadUI = ReloadUI
local sort = table.sort
local tinsert = table.insert
local tostring = tostring
local tremove = table.remove
local type = type

local function createExportFrame(profileExport, needsReload)
    if not IsAddOnLoaded("ElvUI_OptionsUI") then
        EnableAddOn("ElvUI_OptionsUI")
        LoadAddOn("ElvUI_OptionsUI")
    end

    if not E.Libs.AceGUI then E:AddLib("AceGUI", "AceGUI-3.0") end

    local Frame = E.Libs.AceGUI:Create("Frame")
    Frame:SetTitle("Export")
    Frame:EnableResize(false)
    Frame:SetWidth(800)
    Frame:SetHeight(600)
    Frame:SetLayout("flow")
    Frame.frame:SetFrameStrata("FULLSCREEN_DIALOG")
    Frame.frame:SetScript("OnHide", function()
        if needsReload then ReloadUI() end
    end)

    local Box = E.Libs.AceGUI:Create("MultiLineEditBox-ElvUI")
    Box:SetNumLines(36)
    Box:DisableButton(true)
    Box:SetWidth(1000)
    Box:SetLabel("Export")
    Frame:AddChild(Box)

    Box.editBox:SetScript("OnCursorChanged", nil)
    Box.scrollFrame:UpdateScrollChildRect()
    Box:SetText(profileExport)
    Box.editBox:HighlightText()
    Box:SetFocus()
end

local function removeEmptySubTables(tbl)
    if type(tbl) ~= "table" then return end

    if next(tbl) == nil then
        tbl = nil
        return tbl
    end

    for _, v in pairs(tbl) do if type(v) == "table" then if next(v) ~= nil then removeEmptySubTables(v) end end end
    for k, v in pairs(tbl) do if type(v) == "table" then if next(v) == nil then tbl[k] = nil end end end
end

local function generatePluginTable(profile, databaseName)
    do
        local sameLine = false
        local lineStructureTable = {}

        local function keySort(a, b)
            local A, B = type(a), type(b)

            if A == B then
                if A == "number" or A == "string" then
                    return a < b
                elseif A == "boolean" then
                    return (a and 1 or 0) > (b and 1 or 0)
                end
            end

            return A < B
        end

        local function buildLineStructure(str)
            for _, v in ipairs(lineStructureTable) do
                if type(v) == "string" then
                    str = str .. "[\"" .. v .. "\"]"
                else
                    str = str .. "[" .. v .. "]"
                end
            end

            return str
        end

        local function buildTableStructure(tbl, ret, db, lineStructureTableCreated)
            local tkeys = {}
            for i in pairs(tbl) do tinsert(tkeys, i) end
            sort(tkeys, keySort)

            local lineStructure = buildLineStructure(db)
            for _, k in ipairs(tkeys) do
                local v = tbl[k]

                if not sameLine then ret = ret .. lineStructure end

                ret = ret .. "["

                if type(k) == "string" then
                    ret = ret .. "\"" .. k .. "\""
                else
                    ret = ret .. k
                end

                if type(v) == "table" then
                    tinsert(lineStructureTable, k)
                    sameLine = true
                    ret = ret .. "]"

                    local newLine = match(ret, "([^\n]*)$")
                    if not lineStructureTableCreated[newLine] then
                        ret = ret .. " = {}\n"
                        ret = ret .. newLine
                        lineStructureTableCreated[newLine] = true
                    end

                    ret = buildTableStructure(v, ret, db, lineStructureTableCreated)
                else
                    sameLine = false
                    ret = ret .. "] = "

                    if type(v) == "number" then
                        ret = ret .. v .. "\n"
                    elseif type(v) == "string" then
                        -- LuaFormatter off
                        ret = ret .. "\"" ..
                                  v:gsub('\\', '\\\\'):gsub('\n', '\\n'):gsub('"', '\\"'):gsub('\124', '\124\124') ..
                                  '"\n'
                        -- LuaFormatter on
                    elseif type(v) == "boolean" then
                        if v then
                            ret = ret .. "true\n"
                        else
                            ret = ret .. "false\n"
                        end
                    else
                        ret = ret .. "\"" .. tostring(v) .. "\"\n"
                    end
                end
            end

            tremove(lineStructureTable)

            return ret
        end

        return buildTableStructure(profile, "", databaseName, {})
    end
end

local function exportNames()
    local elvDB = _G.ElvDB
    if (not elvDB) then return TXUI:DebugPrint("ElvDB could not be found, this is impossible") end

    local exportTable = {}
    local printNames = {}

    for namerealm, _ in pairs(elvDB.profileKeys) do
        local name, realm = strsplit(" - ", namerealm, 2)
        if (name and realm) then
            local exportName = format("%s-%s", name, E:ShortenRealm(realm))
            exportTable[exportName] = true
            tinsert(printNames, exportName)
        else
            TXUI:DebugPrint("Could not parse name and realm", namerealm)
        end
    end

    local distributor = E:GetModule("Distributor")
    local libCompress = E.Libs.Compress
    local libBase64 = E.Libs.Base64

    local serialData = distributor:Serialize(exportTable)
    local compressedData = libCompress:Compress(serialData)
    local encodedData = libBase64:Encode(compressedData)

    -- Set export to window
    createExportFrame(encodedData)

    -- Print Names
    TXUI:Print("Exported Names include: ", F.StringGood(table.concat(printNames, ", ")))
end

local function exportImportNames(dataString)
    local distributor = E:GetModule("Distributor")
    local libCompress = E.Libs.Compress
    local libBase64 = E.Libs.Base64

    if (not libBase64:IsBase64(dataString)) then
        TXUI:Print("Invalid import string provided")
        return
    end

    local decodedData = libBase64:Decode(dataString)
    local decompressedData, decompressedMessage = libCompress:Decompress(decodedData)

    if (not decompressedData) then
        TXUI:Print("Error decompressing data:", decompressedMessage)
        return
    end

    local deserializedData = E:SplitString(decompressedData, "^^::") -- '^^' indicates the end of the AceSerializer string

    deserializedData = format("%s%s", deserializedData, "^^") -- Add back the AceSerializer terminator
    local success, nameData = distributor:Deserialize(deserializedData)

    if (not success) or (not nameData) then
        TXUI:Print("Error deserializing:", nameData, decompressedData)
        return
    end

    -- Generate Table
    local nameTable = generatePluginTable(nameData, "")

    -- Set export to window
    createExportFrame(nameTable)
end

local function exportDBM(profile)
    -- Check for DBM
    if not _G.DBM_AllSavedOptions then
        TXUI:Print("DBM not found or options wasn't opened at least once")
        return
    end

    local profileExport
    local transformProfileName = gsub(profile, "%-", "%%-") -- Excape "-"" inside profile names

    --- DBM_AllSavedOptions
    do
        -- Copy DBM table
        local TXUI_DBM = E:CopyTable({}, _G.DBM_AllSavedOptions)

        -- Remove other profiles
        for k, _ in next, TXUI_DBM do if k ~= profile then TXUI_DBM[k] = nil end end

        -- Cleanup
        removeEmptySubTables(TXUI_DBM)

        -- Generate export
        profileExport = generatePluginTable(TXUI_DBM, "TXUI_DBM_AllSavedOptions")

        -- Replace hardcoded profile with dynamic one
        profileExport = gsub(profileExport, "\"" .. transformProfileName .. "\"", "profileName")
    end

    -- DBT_AllPersistentOptions
    do
        -- Copy DBM table
        local TXUI_DBM = E:CopyTable({}, _G.DBT_AllPersistentOptions)

        -- Remove other profiles
        for k, _ in next, TXUI_DBM do if k ~= profile then TXUI_DBM[k] = nil end end

        -- Cleanup
        removeEmptySubTables(TXUI_DBM)

        -- Generate export
        profileExport = profileExport .. "\n" .. generatePluginTable(TXUI_DBM, "TXUI_DBT_AllPersistentOptions")

        -- Replace hardcoded profile with dynamic one
        profileExport = gsub(profileExport, "\"" .. transformProfileName .. "\"", "profileName")
    end

    -- Set export to window
    createExportFrame(profileExport)
end

local function exportBigWigs(profile)
    -- Check for BW
    if not _G.BigWigs or not _G.BigWigs.db then
        TXUI:Print("BW not found or options wasn't opened at least once")
        return
    end

    -- BOOM
    _G.BigWigs.db:RegisterDefaults(nil)

    -- BABY BOOM
    if _G.BigWigs.db.children then for _, db in pairs(_G.BigWigs.db.children) do db.RegisterDefaults(db, nil) end end

    -- Copy BigWigs table
    local TXUI_BigWigs3DB = E:CopyTable({}, _G.BigWigs3DB)

    -- Remove unused stuff
    TXUI_BigWigs3DB.profileKeys = nil
    TXUI_BigWigs3DB.profiles = nil
    TXUI_BigWigs3DB.wipe80 = nil
    TXUI_BigWigs3DB.discord = nil
    TXUI_BigWigs3DB.namespaces["LibDualSpec-1.0"] = nil

    -- Cleanup export
    if TXUI_BigWigs3DB.namespaces then
        -- Remove all existing boss modules from the export
        for k, _ in next, TXUI_BigWigs3DB.namespaces do
            if k:find("BigWigs_Bosses_", nil, true) or k == "BigWigs_Plugins_Statistics" then
                TXUI_BigWigs3DB.namespaces[k] = nil
            end
        end

        -- Remove other profiles
        for k, _ in next, TXUI_BigWigs3DB.namespaces do
            if TXUI_BigWigs3DB.namespaces[k] and TXUI_BigWigs3DB.namespaces[k]["profiles"] then
                for pk, _ in next, TXUI_BigWigs3DB.namespaces[k]["profiles"] do
                    if pk ~= profile then TXUI_BigWigs3DB.namespaces[k]["profiles"][pk] = nil end
                end
            end
        end

        -- Cleanup namespaces
        removeEmptySubTables(TXUI_BigWigs3DB.namespaces)
    end

    -- Cleanup rest
    removeEmptySubTables(TXUI_BigWigs3DB)

    -- Generate export
    local profileExport = generatePluginTable(TXUI_BigWigs3DB, "TXUI_BigWigs3DB")

    -- Excape "-"" inside profile names
    local transformProfileName = gsub(profile, "%-", "%%-")

    -- Replace hardcoded profile with dynamic one
    profileExport = gsub(profileExport, "\"" .. transformProfileName .. "\"", "profileName")

    -- Set export to window
    createExportFrame(profileExport, true)
end

function TXUI:ExportProfile(addon, profile)
    if (addon == "bw") then
        exportBigWigs(profile)
    elseif (addon == "dbm") then
        exportDBM(profile)
    elseif (addon == "names") then
        exportNames()
    elseif (addon == "import_names") then
        exportImportNames(profile)
    end
end
