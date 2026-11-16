local A = ArcaneUI

function A:SkinContainerFrames()
    if A.done.bags then return end
    A.done.bags = true

    for i = 1, NUM_CONTAINER_FRAMES or 13 do
        local cf = _G["ContainerFrame"..i]
        if cf then

            local portrait = _G["ContainerFrame"..i.."Portrait"]
                          or _G["ContainerFrame"..i.."PortraitButton"]
            for ri = 1, cf:GetNumRegions() do
                local r = select(ri, cf:GetRegions())
                if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                    if r ~= portrait then
                        A.kill(r)
                    end
                end
            end

            local sf = CreateFrame("Frame", nil, cf)
            sf:SetFrameLevel(math.max((cf:GetFrameLevel() or 1) - 1, 0))
            sf:EnableMouse(false)
            sf:SetPoint("TOPLEFT",     cf, "TOPLEFT",      8,  -4)
            sf:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", -3,   0)
            sf:SetBackdrop({
                bgFile=A.TT_BG, edgeFile=A.TT_BD,
                tile=true, tileSize=16, edgeSize=16,
                insets={left=4, right=4, top=4, bottom=4},
            })
            sf:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 0.95)
            sf:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.80)

            local cfName = cf:GetName()

            for j = 1, MAX_CONTAINER_ITEMS or 36 do
                local btn = _G[cfName.."Item"..j]
                if btn then

                    local n = btn:GetNormalTexture()
                    if n then n:SetAlpha(0) end
                    if not btn._abNHooked then
                        btn._abNHooked = true
                        hooksecurefunc(btn, "SetNormalTexture", function(self, tex)
                            if tex and tex ~= "" then
                                local nt = self:GetNormalTexture()
                                if nt then nt:SetAlpha(0) end
                            end
                        end)
                    end

                    if not btn._abSlotBG then
                        local slotBG = btn:CreateTexture(nil, "BACKGROUND")
                        slotBG:SetAllPoints()
                        slotBG:SetTexture(A.FLAT)
                        slotBG:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.10)
                        btn._abSlotBG = slotBG

                        local slotBorder = btn:CreateTexture(nil, "OVERLAY", nil, -1)
                        slotBorder:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
                        slotBorder:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
                        slotBorder:SetTexture(A.FLAT)
                        slotBorder:SetVertexColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.30)

                        local t = btn:CreateTexture(nil, "OVERLAY", nil, -1)
                        t:SetTexture(A.FLAT); t:SetHeight(1)
                        t:SetVertexColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.35)
                        t:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
                        t:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 0, 0)

                        local b = btn:CreateTexture(nil, "OVERLAY", nil, -1)
                        b:SetTexture(A.FLAT); b:SetHeight(1)
                        b:SetVertexColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.35)
                        b:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 0, 0)
                        b:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)

                        local l = btn:CreateTexture(nil, "OVERLAY", nil, -1)
                        l:SetTexture(A.FLAT); l:SetWidth(1)
                        l:SetVertexColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.35)
                        l:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
                        l:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 0, 0)

                        local r = btn:CreateTexture(nil, "OVERLAY", nil, -1)
                        r:SetTexture(A.FLAT); r:SetWidth(1)
                        r:SetVertexColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.35)
                        r:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 0, 0)
                        r:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)

                        slotBorder:SetAlpha(0)
                    end
                end
            end

            local cb = _G[cfName.."CloseButton"]
            if cb then A:SkinCloseButton(cb) end

            local title = _G[cfName.."Name"]
            if title then title:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
        end
    end
end

function A:SkinBankFrame()
    if not BankFrame or A.done.bank then return end
    A.done.bank = true
    A:SkinStdBlizzFrame(BankFrame, 10, -12, -32, 72)

    for i = 1, NUM_BANKGENERIC_SLOTS or 28 do
        local btn = _G["BankFrameItem"..i]
        if btn then
            local n = btn:GetNormalTexture()
            if n then n:SetTexture("Interface\\Buttons\\UI-Quickslot2") end
        end
    end

    for i = 1, NUM_BANKBAGSLOTS or 7 do
        local btn = _G["BankFrameBag"..i]
        if btn then
            local n = btn:GetNormalTexture()
            if n then n:SetTexture("Interface\\Buttons\\UI-Quickslot2") end
        end
    end
end

function A:SkinMailFrame()
    if not MailFrame or A.done.mail then return end
    A.done.mail = true
    A:SkinStdBlizzFrame(MailFrame, 10, -12, -32, 72)
    A:SkinFrameTabs(MailFrame)

    for _, sf in ipairs({InboxScrollFrame, SendMailScrollFrame}) do
        if sf then
            A:KillTextures(sf)
            local sc = sf.GetScrollChild and sf:GetScrollChild()
            if sc then A:KillTextures(sc) end
        end
    end
    A:SkinEditBox(SendMailNameEditBox)
    A:SkinEditBox(SendMailSubjectEditBox)
    A:SkinEditBox(SendMailBodyEditBox)
    A:SkinScrollBar(InboxScrollFrame)
    A:SkinScrollBar(SendMailScrollFrame)
    A:RecolorText(MailFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinTradeFrame()
    if not TradeFrame or A.done.trade then return end
    A.done.trade = true
    A:SkinStdBlizzFrame(TradeFrame, 10, -11, -28, 48)
    if TradePlayerInputMoneyFrame then
        A:KillTextures(TradePlayerInputMoneyFrame)
        A:AddSubSkinFrame(TradePlayerInputMoneyFrame)
    end
end

function A:SkinGossipFrame()
    if not GossipFrame or A.done.gossip then return end
    A.done.gossip = true
    A:SkinStdBlizzFrame(GossipFrame, 12, -18, -29, 66)
    if GossipGreetingScrollFrame then
        A:KillTextures(GossipGreetingScrollFrame)
        local sc = GossipGreetingScrollFrame.GetScrollChild and GossipGreetingScrollFrame:GetScrollChild()
        if sc then A:KillTextures(sc) end
    end
    A:SkinScrollBar(GossipGreetingScrollFrame)
    A:RecolorText(GossipFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinQuestFrame()
    if A.done.quest then return end
    A.done.quest = true

    if QuestFrame_SetTitleTextColor then
        hooksecurefunc("QuestFrame_SetTitleTextColor", function(fontString)
            if fontString and fontString.SetTextColor then
                pcall(function() fontString:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end)
            end
        end)
    end
    if QuestFrame_SetTextColor then
        hooksecurefunc("QuestFrame_SetTextColor", function(fontString)
            if fontString and fontString.SetTextColor then
                pcall(function() fontString:SetTextColor(A.text[1], A.text[2], A.text[3]) end)
            end
        end)
    end

    if QuestInfo_Display then
        hooksecurefunc("QuestInfo_Display", function()

            for _, name in ipairs({
                "QuestInfoTitleHeader", "QuestInfoDescriptionHeader",
                "QuestInfoObjectivesHeader", "QuestInfoRewardsHeader",
            }) do
                local fs = _G[name]
                if fs and fs.SetTextColor then
                    pcall(function() fs:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end)
                end
            end

            for _, name in ipairs({
                "QuestInfoDescriptionText", "QuestInfoObjectivesText",
                "QuestInfoGroupSize", "QuestInfoRewardText",
                "QuestInfoItemChooseText", "QuestInfoItemReceiveText",
                "QuestInfoSpellLearnText", "QuestInfoHonorFrameReceiveText",
                "QuestInfoArenaPointsFrameReceiveText", "QuestInfoTalentFrameReceiveText",
                "QuestInfoXPFrameReceiveText", "QuestInfoReputationText",
            }) do
                local fs = _G[name]
                if fs and fs.SetTextColor then
                    pcall(function() fs:SetTextColor(A.text[1], A.text[2], A.text[3]) end)
                end
            end

            for i = 1, 10 do
                local obj = _G["QuestInfoObjective"..i]
                if obj and obj.SetTextColor then
                    pcall(function() obj:SetTextColor(A.text[1], A.text[2], A.text[3]) end)
                end
            end
        end)
    end

    if QuestFrame then
        A:SkinStdBlizzFrame(QuestFrame, 12, -18, -29, 66)

        for _, sf in ipairs({QuestDetailScrollFrame, QuestRewardScrollFrame,
                             QuestProgressScrollFrame, QuestGreetingScrollFrame}) do
            if sf then
                A:KillTextures(sf)
                local sc = sf.GetScrollChild and sf:GetScrollChild()
                if sc then A:KillTextures(sc) end
            end
        end
        A:SkinScrollBar(QuestDetailScrollFrame)
        A:SkinScrollBar(QuestRewardScrollFrame)
        A:SkinScrollBar(QuestProgressScrollFrame)
        A:SkinScrollBar(QuestGreetingScrollFrame)
        A:RecolorText(QuestFrame, A.text[1], A.text[2], A.text[3])
    end

    if QuestLogFrame then
        A:SkinStdBlizzFrame(QuestLogFrame, 10, -11, -1, 8)

        local qlTitle = _G["QuestLogTitleText"] or _G["QuestLogFrameTitleText"]
        if qlTitle and qlTitle.SetTextColor then
            qlTitle:SetTextColor(1, 0.82, 0, 1)
        end

        for ri = 1, QuestLogFrame:GetNumRegions() do
            local reg = select(ri, QuestLogFrame:GetRegions())
            if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
                local txt = reg:GetText()
                if txt and (txt:find("egistro") or txt:find("uest Log") or txt:find("QUEST")) then
                    pcall(function() reg:SetTextColor(1, 0.82, 0, 1) end)
                end
            end
        end

        local trackBtn = _G["QuestLogFrameTrackButton"]
                      or _G["QuestLogTrackButton"]
                      or _G["QuestLogFrameCompleteButton"]
        if trackBtn then A:SkinButton(trackBtn) end

        for _, sf in ipairs({QuestLogListScrollFrame, QuestLogDetailScrollFrame}) do
            if sf then
                A:KillTextures(sf)
                local sc = sf.GetScrollChild and sf:GetScrollChild()
                if sc then A:KillTextures(sc) end
            end
        end

        A:SkinScrollBar(QuestLogListScrollFrame)
        A:SkinScrollBar(QuestLogDetailScrollFrame)

        local function recolorQuestLog()

            for i = 1, MAX_NUM_QUESTS or 25 do
                local btn = _G["QuestLogTitle"..i]
                if btn then
                    local fs = btn:GetFontString()
                    if fs then
                        local r, g, b = fs:GetTextColor()

                        if r and g and b and (r + g + b) < 1.0 then
                            fs:SetTextColor(ArcaneUI.text[1], ArcaneUI.text[2], ArcaneUI.text[3])
                        end
                    end
                end
            end

            local function forceTextColor(frame, r, g, b)
                if not frame or not frame.GetNumRegions then return end
                for i = 1, frame:GetNumRegions() do
                    local reg = select(i, frame:GetRegions())
                    if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
                        pcall(function() reg:SetTextColor(r, g, b) end)
                    end
                end

                if frame.GetNumChildren then
                    for i = 1, frame:GetNumChildren() do
                        local child = select(i, frame:GetChildren())
                        if child then
                            forceTextColor(child, r, g, b)
                        end
                    end
                end
            end

            if QuestLogDetailScrollFrameScrollChild then
                forceTextColor(QuestLogDetailScrollFrameScrollChild, 1, 1, 1)
            end

            local sc = _G["QuestLogDetailScrollFrameScrollChild"]
            if sc then forceTextColor(sc, 1, 1, 1) end

            local namedTexts = {
                "QuestLogDescriptionText",
                "QuestLogObjectivesText",
                "QuestLogQuestTitle",
                "QuestLogRequiredMoney",
                "QuestLogRewardText",
                "QuestLogQuestDescription",
                "QuestLogTimerText",
                "QuestLogSpacerText",
                "QuestLogPlayerTitleText",
                "QuestLogSuggestedGroupText",
            }
            for _, name in ipairs(namedTexts) do
                local fs = _G[name]
                if fs and fs.SetTextColor then

                    if name == "QuestLogQuestTitle" then
                        pcall(function() fs:SetTextColor(ArcaneUI.textHi[1], ArcaneUI.textHi[2], ArcaneUI.textHi[3]) end)
                    else

                        pcall(function() fs:SetTextColor(1, 1, 1) end)
                    end
                end
            end

            for i = 1, 10 do
                local obj = _G["QuestLogObjective"..i]
                if obj and obj.SetTextColor then
                    pcall(function() obj:SetTextColor(1, 1, 1) end)
                end
            end

            local headers = {
                "QuestLogDescriptionTitle",
                "QuestLogRewardTitleText",
                "QuestLogItemChooseText",
                "QuestLogItemReceiveText",
                "QuestLogSpellLearnText",
            }
            for _, name in ipairs(headers) do
                local fs = _G[name]
                if fs and fs.SetTextColor then
                    pcall(function() fs:SetTextColor(ArcaneUI.textHi[1], ArcaneUI.textHi[2], ArcaneUI.textHi[3]) end)
                end
            end
        end

        hooksecurefunc("QuestLog_Update", recolorQuestLog)

        if QuestLog_SetSelection then
            hooksecurefunc("QuestLog_SetSelection", function(questIndex)

                recolorQuestLog()

                local delayFrame = CreateFrame("Frame")
                delayFrame:SetScript("OnUpdate", function(self)
                    self:SetScript("OnUpdate", nil)
                    recolorQuestLog()
                end)
            end)
        end

        pcall(function()
            QuestLogFrame:HookScript("OnShow", recolorQuestLog)
        end)

        recolorQuestLog()

        A:SkinButton(QuestLogFrameAbandonButton)
        A:SkinButton(QuestLogFrameShareButton)
        A:SkinButton(QuestLogFramePushQuestButton)

        A:SkinCloseButton(QuestLogFrameCloseButton)
    end
end

function A:SkinMerchantFrame()
    if not MerchantFrame or A.done.merchant then return end
    A.done.merchant = true
    A:SkinStdBlizzFrame(MerchantFrame, 10, -11, -33, 55)
    A:SkinFrameTabs(MerchantFrame)

    for i = 1, MERCHANT_ITEMS_PER_PAGE or 12 do
        A.kill(_G["MerchantItem"..i.."SlotTexture"])
        A.kill(_G["MerchantItem"..i.."NameFrame"])
    end
    A.kill(MerchantBuyBackItemSlotTexture)
    A.kill(MerchantBuyBackItemNameFrame)
    A:SkinButton(MerchantPrevPageButton)
    A:SkinButton(MerchantNextPageButton)
    A:RecolorText(MerchantFrame, A.text[1], A.text[2], A.text[3])
end
