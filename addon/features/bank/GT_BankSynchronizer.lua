local bankCharSynchronizer
local bankContentSynchronizer

GT_EventManager:AddEventListener("ADDON_READY", function()
    bankCharSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_BankChars",
        GT_BankService.GetUsefullCharData,
        function(historyEntry)
            if not IsInTable(GT_Data.bankCharsHistory, historyEntry) then
                table.insert(GT_Data.bankCharsHistory, historyEntry)
                GT_EventManager:PublishEvent("BANKCHAR_UPDATED_FROM_GUILD", historyEntry)
            end
        end,
        {"ADD_BANKCHAR", "REMOVE_BANKCHAR"})

   bankContentSynchronizer = GT_SynchronizerFactory:CreateSynchronizer("GT_BankContent",
       GT_BankService.GetBankContentUsefullData,
       function(historyEntry)
           if not IsInTable(GT_Data.bankContentHistory, historyEntry) then
               table.insert(GT_Data.bankContentHistory, historyEntry)
               GT_EventManager:PublishEvent("BANKCONTENT_UPDATED_FROM_GUILD", historyEntry)
           end
       end,
       {"ADD_BANKCONTENT", "REMOVE_BANKCONTENT"})
end)