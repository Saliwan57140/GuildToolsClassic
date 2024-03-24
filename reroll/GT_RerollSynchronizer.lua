GT_SynchronizerFactory:CreateSynchronizer("GT_Reroll",
    function() return GT_SavedData.rerollHistory end,
    function(historyEntry)
        if not IsInTable(GT_SavedData.rerollHistory, historyEntry) then
            table.insert(GT_SavedData.rerollHistory, historyEntry)
            GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
        end
    end,
    {"ADD_REROLL", "REMOVE_REROLL"})

--GT_RerollSynchronizer = {}
--
---- HASH
--
--local hashCache = nil
--
--local function GetRerollhistoryHash()
--    if hashCache ~= nil then
--        return hashCache
--    end
--
--    local m = md5.new()
--
--    local stringToHash = ""
--
--    for index, savedEntry in ipairs(GT_SavedData.rerollHistory) do
--        stringToHash = stringToHash..savedEntry
--    end
--
--    local hashAsInt = 0
--    for char = 0, string.len(stringToHash) do
--        hashAsInt = hashAsInt + string.byte(stringToHash)
--    end
--
--    -- hashCache = md5.sumhexa(stringToHash)
--
--    -- hashCache = ""
--
--    -- for index, savedEntry in ipairs(GT_SavedData.rerollHistory) do
--    --     hashCache = sha1.hex(hashCache..savedEntry)
--    -- end
--
--    hashCache = tostring(hashAsInt)
--
--    return hashCache
--end
--
--local function InvalidateHash()
--    hashCache = nil
--end
--
---- SEND
--
--GT_EventManager:AddEventListener("ADD_REROLL", function(historyEntry)
--    InvalidateHash()
--    ChatThrottleLib:SendAddonMessage("NORMAL", "GT_Reroll", "NEW_EVENT:"..historyEntry, "GUILD")
--end)
--
--GT_EventManager:AddEventListener("REMOVE_REROLL", function(historyEntry)
--    InvalidateHash()
--    ChatThrottleLib:SendAddonMessage("NORMAL", "GT_Reroll", "NEW_EVENT:"..historyEntry, "GUILD")
--end)
--
--local function SendAllData()
--    for index, historyEntry in ipairs(GT_SavedData.rerollHistory) do
--        ChatThrottleLib:SendAddonMessage("BULK", "GT_Reroll", "NEW_EVENT:"..historyEntry, "GUILD")
--    end
--end
--
---- RECEIVE
--
--local playerNameByHash = {}
--local syncNeeded = false
--
--local eventHandler = CreateFrame("Frame")
--eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
--eventHandler:RegisterEvent("CHAT_MSG_ADDON")
--eventHandler:SetScript("OnEvent", function(self, event, ...)
--    if event == "CHAT_MSG_ADDON" then
--        local prefix, message = ...
--        if prefix ~= "GT_Reroll" then
--            return
--        end
--
--        print("[GT]".."["..prefix.."]"..message)
--
--        if StartWith(message, "NEW_EVENT") then
--            local messageType, time, eventType, fromPlayer, mainName, rerollName = unpack(StringSplit(message, ":"))
--            local historyEntry = time..":"..eventType..":"..fromPlayer..":"..mainName..":"..rerollName
--
--            if not IsInTable(GT_SavedData.rerollHistory, historyEntry) then
--                InvalidateHash()
--                table.insert(GT_SavedData.rerollHistory, historyEntry)
--                GT_EventManager:PublishEvent("REROLL_UPDATED_FROM_GUILD")
--            end
--        end
--
--        if StartWith(message, "CHECK_SYNC") then
--            ChatThrottleLib:SendAddonMessage("NORMAL", "GT_Reroll", "MY_HASH:"..UnitName("player")..":"..GetRerollhistoryHash(), "GUILD")
--            playerNameByHash = {}
--            syncNeeded = false
--        end
--
--        if StartWith(message, "MY_HASH") then
--            local messageType, playerName, hash = unpack(StringSplit(message, ":"))
--
--            if playerNameByHash[hash] == nil then
--                playerNameByHash[hash] = {}
--            end
--
--            table.insert(playerNameByHash[hash], playerName)
--
--            if syncNeeded == false and hash ~= GetRerollhistoryHash() then
--                syncNeeded = true
--                C_Timer.After(5, function()
--                    table.sort(playerNameByHash[GetRerollhistoryHash()])
--                    if playerNameByHash[GetRerollhistoryHash()][1] == UnitName("player") then
--                        SendAllData()
--                    end
--                end)
--            end
--        end
--
--    elseif event == "PLAYER_ENTERING_WORLD" then
--        local isLogin, isReload = ...
--        if isLogin or isReload then
--            C_ChatInfo.RegisterAddonMessagePrefix("GT_Reroll")
--        end
--
--        ChatThrottleLib:SendAddonMessage("BULK", "GT_Reroll", "CHECK_SYNC", "GUILD")
--    end
--end)