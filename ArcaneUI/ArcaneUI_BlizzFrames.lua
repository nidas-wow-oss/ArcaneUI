local A = ArcaneUI

function A:SkinBlizzardFrames()
    A:SkinDropDownMenus()
    A:SkinGameMenu()
    A:SkinInterfaceOptions()
    A:SkinStaticPopups()
    A:SkinCharacterFrame()
    A:SkinSpellBookFrame()
    A:SkinFriendsFrame()
    A:SkinLFDFrame()
    A:SkinPVPFrame()
    A:SkinContainerFrames()
    A:SkinBankFrame()
    A:SkinMailFrame()
    A:SkinTradeFrame()
    A:SkinGossipFrame()
    A:SkinQuestFrame()
    A:SkinMerchantFrame()
    A:SkinTaxiFrame()
    A:SkinArenaFrame()
    A:SkinArenaRegistrar()
    A:SkinGuildRegistrar()
    A:SkinPetitionFrame()
    A:SkinTabardFrame()
    A:SkinWorldMap()
    A:SkinColorPicker()
    A:SkinHelpFrame()
    A:SkinReadyCheck()
    A:SkinWatchFrame()
    A:SkinDressUpFrame()
    A:SkinStackSplit()
    A:SkinLootFrame()
    A:SkinGuildFrame()
    A:SkinSocialFrame()
    A:SkinPetStableFrame()
    A:SkinGroupLoot()
    A:SkinAlertFrames()
    A:SkinCompanionFrame()
end

function A:SkinGameMenu()
    if not GameMenuFrame or A.done.gameMenu then return end
    A.done.gameMenu = true
    A:KillTextures(GameMenuFrame)
    A:AddSkinFrame(GameMenuFrame)

    for ri = 1, GameMenuFrame:GetNumRegions() do
        local reg = select(ri, GameMenuFrame:GetRegions())
        if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
            pcall(function() reg:SetTextColor(1, 0.82, 0, 1) end)
            break
        end
    end

    for i = 1, GameMenuFrame:GetNumChildren() do
        local child = select(i, GameMenuFrame:GetChildren())
        if child and child:GetObjectType() == "Button" and not child._abSkinned then
            child._abSkinned = true
            A:SkinButton(child)

            local fs = child.GetFontString and child:GetFontString()
            if fs then fs:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
        end
    end
end

function A:SkinStaticPopups()
    if A.done.staticPopups then return end
    A.done.staticPopups = true
    for i = 1, 4 do
        local popup = _G["StaticPopup"..i]
        if popup then
            A:KillTextures(popup)
            A:AddSkinFrame(popup)
            A:SkinEditBox(_G["StaticPopup"..i.."EditBox"])
            for j = 1, 4 do
                A:SkinButton(_G["StaticPopup"..i.."Button"..j])
            end
        end
    end
end

function A:SkinWorldMap()
    if not WorldMapFrame or A.done.worldMap then return end
    A.done.worldMap = true
    A:KillTextures(WorldMapFrame)
    A:AddSkinFrame(WorldMapFrame, 4, -4, -4, 4)
    if WorldMapTitleButton then
        A:KillTextures(WorldMapTitleButton)
        A:AddSubSkinFrame(WorldMapTitleButton)
    end
    A:SkinButton(WorldMapZoomOutButton)
    A:SkinButton(WorldMapFrameCloseButton)
end

function A:SkinColorPicker()
    if not ColorPickerFrame or A.done.colorPicker then return end
    A.done.colorPicker = true
    A:KillTextures(ColorPickerFrame)
    A:AddSkinFrame(ColorPickerFrame, 4, -4, -4, 4)
    if OpacitySliderFrame then
        A:KillTextures(OpacitySliderFrame)
        A:AddSubSkinFrame(OpacitySliderFrame)
    end
    A:SkinButton(ColorPickerOkayButton)
    A:SkinButton(ColorPickerCancelButton)
end

function A:SkinHelpFrame()
    if not HelpFrame or A.done.help then return end
    A.done.help = true

    A:SkinStdBlizzFrame(HelpFrame, 6, 0, -45, 14)
    A:SkinFrameTabs(HelpFrame)
    A:RecolorText(HelpFrame, A.text[1], A.text[2], A.text[3])

    pcall(function() HelpFrame:SetBackdrop(nil) end)
    if A.done[HelpFrame] and A.done[HelpFrame].SetBackdropColor then
        A.done[HelpFrame]:SetBackdropColor(0, 0, 0, 0)
    end
    if not HelpFrame._abSolidBG then
        local t = HelpFrame:CreateTexture(nil, "BACKGROUND")
        t._abKeep = true
        t:SetTexture(A.TT_BG)
        t:SetVertexColor(A.bg[1], A.bg[2], A.bg[3], A.bg[4])
        t:SetPoint("TOPLEFT",     HelpFrame, "TOPLEFT",     10, -4)
        t:SetPoint("BOTTOMRIGHT", HelpFrame, "BOTTOMRIGHT", -49, 18)
        HelpFrame._abSolidBG = t
    end

    for _, n in ipairs({"KnowledgeBaseFrame", "KnowledgeBaseFrameDivider",
                        "KnowledgeBaseFrameDivider2", "HelpFrameOpenTicketDivider",
                        "HelpFrameViewResponseDivider"}) do
        local f = _G[n]
        if f then
            if f.GetNumRegions then A:KillTextures(f) else A.kill(f) end
        end
    end
    for i = 1, HelpFrame:GetNumChildren() do
        local c = select(i, HelpFrame:GetChildren())
        if c and not c._abSkinFrame and c.GetObjectType and c:GetObjectType() == "Frame" then
            A:KillTextures(c)
        end
    end

    A:SkinEditBox(KnowledgeBaseFrameEditBox)
    A:SkinDropDown(KnowledgeBaseFrameCategoryDropDown)
    A:SkinDropDown(KnowledgeBaseFrameSubCategoryDropDown)
    for _, n in ipairs({"KnowledgeBaseArticleScrollFrame", "HelpFrameOpenTicketScrollFrame",
                        "HelpFrameViewResponseIssueScrollFrame",
                        "HelpFrameViewResponseMessageScrollFrame"}) do
        A:SkinScrollBar(_G[n])
    end

    local BTNS = {
        "GMChatOpenLog", "KnowledgeBaseFrameTopIssuesButton", "KnowledgeBaseFrameSearchButton",
        "KnowledgeBaseArticleScrollChildFrameBackButton", "KnowledgeBaseFrameReportIssue",
        "KnowledgeBaseFrameGMTalk", "KnowledgeBaseFrameStuck", "KnowledgeBaseFrameLag",
        "KnowledgeBaseFrameCancel", "KnowledgeBaseFrameAbandonTicket",
        "KnowledgeBaseFrameEditTicket",
    }
    for _, s in ipairs({"GMTalkOpenTicket", "GMTalkCancel", "ReportIssueOpenTicket",
                        "ReportIssueCancel", "LagLoot", "LagAuctionHouse", "LagMail",
                        "LagChat", "LagMovement", "LagSpell", "LagCancel", "StuckStuck",
                        "StuckOpenTicket", "StuckCancel", "OpenTicketCancel",
                        "OpenTicketSubmit", "ViewResponseCancel", "ViewResponseMoreHelp",
                        "ViewResponseIssueResolved", "WelcomeGMTalk", "WelcomeReportIssue",
                        "WelcomeStuck", "WelcomeCancel"}) do
        BTNS[#BTNS + 1] = "HelpFrame"..s
    end
    for _, n in ipairs(BTNS) do
        A:SkinPanelButton(_G[n])
    end

    if KnowledgeBaseFrame and not KnowledgeBaseFrame._abTitleHook then
        KnowledgeBaseFrame._abTitleHook = true
        local hfTitle = select(11, HelpFrame:GetRegions())
        if hfTitle and hfTitle.GetObjectType and hfTitle:GetObjectType() == "FontString" then
            KnowledgeBaseFrame:HookScript("OnShow", function() hfTitle:Hide() end)
            KnowledgeBaseFrame:HookScript("OnHide", function() hfTitle:Show() end)
            if KnowledgeBaseFrame:IsShown() then hfTitle:Hide() end
        end
    end
end

function A:SkinReadyCheck()
    if not ReadyCheckFrame or A.done.readyCheck then return end
    A.done.readyCheck = true
    A:KillTextures(ReadyCheckFrame)
    A:AddSkinFrame(ReadyCheckFrame, 4, -4, -4, 4)
end

function A:SkinWatchFrame()
    if not WatchFrame or A.done.watchFrame then return end
    A.done.watchFrame = true

    A:RecolorText(WatchFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinDressUpFrame()
    if not DressUpFrame or A.done.dressUp then return end
    A.done.dressUp = true
    A:SkinStdBlizzFrame(DressUpFrame, 10, -12, -33, 73)
    A:SkinButton(DressUpFrameCancelButton)
    A:SkinButton(DressUpFrameResetButton)
end

function A:SkinStackSplit()
    if not StackSplitFrame or A.done.stackSplit then return end
    A.done.stackSplit = true
    A:KillTextures(StackSplitFrame)
    A:AddSkinFrame(StackSplitFrame, 4, -4, -4, 4)
end

function A:SkinTaxiFrame()
    if not TaxiFrame or A.done.taxi then return end
    A.done.taxi = true

    A:KeepRegions(TaxiFrame, 6, 7)
    A:AddSkinFrame(TaxiFrame, 10, -11, -32, 74)
end

function A:SkinArenaFrame()
    if not ArenaFrame or A.done.arena then return end
    A.done.arena = true
    A:SkinStdBlizzFrame(ArenaFrame, 10, -12, -32, 71)
    if ArenaFrameZoneDescription then
        ArenaFrameZoneDescription:SetTextColor(A.text[1], A.text[2], A.text[3])
    end
end

function A:SkinGuildRegistrar()
    if not GuildRegistrarFrame or A.done.guildReg then return end
    A.done.guildReg = true
    A:SkinStdBlizzFrame(GuildRegistrarFrame, 12, -17, -29, 65)
    A:SkinEditBox(GuildRegistrarFrameEditBox)
    A:RecolorText(GuildRegistrarFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinPetitionFrame()
    if not PetitionFrame or A.done.petition then return end
    A.done.petition = true
    A:SkinStdBlizzFrame(PetitionFrame, 12, -17, -29, 65)
    A:RecolorText(PetitionFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinTabardFrame()
    if not TabardFrame or A.done.tabard then return end
    A.done.tabard = true

    A:KeepRegions(TabardFrame, 6, 17, 18, 19, 20, 21, 22)
    A:AddSkinFrame(TabardFrame, 10, -12, -32, 74)
    if TabardFrameCostFrame then TabardFrameCostFrame:SetBackdrop(nil) end
    A:RecolorText(TabardFrameCustomizationFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinArenaRegistrar()
    if not ArenaRegistrarFrame or A.done.arenaReg then return end
    A.done.arenaReg = true
    A:SkinStdBlizzFrame(ArenaRegistrarFrame, 10, -17, -29, 64)
    A:SkinEditBox(ArenaRegistrarFrameEditBox)

    if PVPBannerFrame then
        A:KeepRegions(PVPBannerFrame, 6, 17, 18, 19, 20, 21, 22)
        A:AddSkinFrame(PVPBannerFrame, 10, -12, -32, 74)
    end
end

function A:SkinLootFrame()
    if not LootFrame or A.done.loot then return end
    A.done.loot = true
    A:KillTextures(LootFrame)
    A:AddSkinFrame(LootFrame, 4, -4, -4, 4)
    for i = 1, LOOTFRAME_NUMBUTTONS or 4 do
        local btn = _G["LootButton"..i]
        if btn then
            A.kill(_G["LootButton"..i.."IconTexture"])

            local n = btn:GetNormalTexture()
            if n then n:SetTexture(nil) end
        end
    end
end

function A:SkinInterfaceOptions()
    if A.done.interfaceOptions then return end
    A.done.interfaceOptions = true

    if InterfaceOptionsFrame then
        A:KillTextures(InterfaceOptionsFrame)

        pcall(function()
            InterfaceOptionsFrame:SetBackdrop({
                bgFile=A.TT_BG, edgeFile=A.TT_BD,
                tile=true, tileSize=16, edgeSize=16,
                insets={left=4, right=4, top=4, bottom=4},
            })
            InterfaceOptionsFrame:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 0.96)
            InterfaceOptionsFrame:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.90)
        end)

        for ri = 1, InterfaceOptionsFrame:GetNumRegions() do
            local reg = select(ri, InterfaceOptionsFrame:GetRegions())
            if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
                local txt = reg:GetText()
                if txt and (txt:find("nterf") or txt:find("NTERF")) then
                    pcall(function() reg:SetTextColor(1, 0.82, 0, 1) end)
                end
            end
        end

        for _, name in ipairs({"InterfaceOptionsFrameHeaderText", "InterfaceOptionsFrameTitle"}) do
            local fs = _G[name]
            if fs and fs.SetTextColor then
                pcall(function() fs:SetTextColor(1, 0.82, 0, 1) end)
            end
        end

        if not InterfaceOptionsFrame._abYellowHooked then
            InterfaceOptionsFrame._abYellowHooked = true
            InterfaceOptionsFrame:HookScript("OnShow", function()
                for ri = 1, InterfaceOptionsFrame:GetNumRegions() do
                    local reg = select(ri, InterfaceOptionsFrame:GetRegions())
                    if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
                        local txt = reg:GetText()
                        if txt and (txt:find("nterf") or txt:find("NTERF")) then
                            pcall(function() reg:SetTextColor(1, 0.82, 0, 1) end)
                        end
                    end
                end
            end)
        end

        A:RecolorText(InterfaceOptionsFrame, A.textHi[1], A.textHi[2], A.textHi[3])
    end

    if InterfaceOptionsFrameCategories then
        A:KillTextures(InterfaceOptionsFrameCategories)
        A:AddSubSkinFrame(InterfaceOptionsFrameCategories)
        A:SkinScrollBar(InterfaceOptionsFrameCategories)
    end

    local OPAQUE = {
        bgFile = A.TT_BG, edgeFile = A.TT_BD,
        tile = true, tileSize = 16, edgeSize = 14,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    }
    for _, n in ipairs({"InterfaceOptionsFramePanelContainer",
                        "InterfaceOptionsFrameCategories",
                        "InterfaceOptionsFrameAddOns"}) do
        local f = _G[n]
        if f then
            A:KillTextures(f)
            pcall(function()
                f:SetBackdrop(OPAQUE)
                f:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 1.0)
                f:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.80)
            end)
        end
    end

    if InterfaceOptionsFrame then
        pcall(function()
            InterfaceOptionsFrame:SetBackdrop(OPAQUE)
            InterfaceOptionsFrame:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 1.0)
            InterfaceOptionsFrame:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.90)
        end)
    end

    local tb = A:AddTitleBar(InterfaceOptionsFrame, _G["InterfaceOptionsFrameHeaderText"]
                                      or _G["InterfaceOptionsFrameTitle"])
                or (InterfaceOptionsFrame and InterfaceOptionsFrame._abTitleBar)

    if tb and not tb._abRaised then
        tb._abRaised = true
        tb:ClearAllPoints()
        tb:SetPoint("BOTTOM", InterfaceOptionsFrame, "TOP", 0, -6)
        tb:SetWidth(180)
    end

    for i = 1, 2 do
        local tab = _G["InterfaceOptionsFrameTab"..i]
        if tab then
            if A.done[tab] == true then A.done[tab] = nil end
            A:SkinTab(tab, 8, -2, -8, 0)
        end
    end

    A:SkinButton(InterfaceOptionsFrameOkay)
    A:SkinButton(InterfaceOptionsFrameCancel)
    A:SkinButton(InterfaceOptionsFrameDefaults)

    if InterfaceOptionsFrame and not InterfaceOptionsFrame._abHooked then
        InterfaceOptionsFrame._abHooked = true
        InterfaceOptionsFrame:HookScript("OnShow", function()
            ArcaneUI:SkinInterfaceOptionsPanels()
        end)
    end
end

function A:SkinInterfaceOptionsPanels()

    local container = InterfaceOptionsFramePanelContainer
    if not container then return end
    for i = 1, container:GetNumChildren() do
        local child = select(i, container:GetChildren())
        if child and not child._abSkinned then
            child._abSkinned = true
            A:KillTextures(child)

            A:RecolorText(child, A.text[1], A.text[2], A.text[3])

            for j = 1, child:GetNumChildren() do
                local el = select(j, child:GetChildren())
                if el then
                    local t = el:GetObjectType()
                    if t == "EditBox" then A:SkinEditBox(el) end
                    if t == "Slider" then A:KillTextures(el) end

                    local en = el.GetName and el:GetName()
                    if t == "Frame" and en and _G[en.."Middle"] and _G[en.."Button"] then
                        A:SkinDropDown(el)
                    end
                    if t == "Button" and not el._abSkinned then
                        el._abSkinned = true
                        A:SkinButton(el)
                    end
                end
            end
        end
    end

    if InterfaceOptionsFrameCategoriesListScrollFrame then
        local sf = InterfaceOptionsFrameCategoriesListScrollFrame
        local child = sf:GetScrollChild()
        if child then
            for i = 1, child:GetNumChildren() do
                local btn = select(i, child:GetChildren())
                if btn and not btn._abSkinned then
                    btn._abSkinned = true
                    A:KillTextures(btn)
                    A:RecolorText(btn, A.text[1], A.text[2], A.text[3])

                    local hl = btn:GetHighlightTexture()
                    if hl then
                        hl:SetTexture(A.FLAT)
                        hl:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.12)
                    end
                end
            end
        end
    end
end

function A:SkinGuildFrame()
    if not GuildFrame or A.done.guild then return end
    A.done.guild = true

    A:KillTextures(GuildFrame)

    for _, sf in ipairs({GuildListScrollFrame, GuildInfoScrollFrame, GuildMotDScrollFrame}) do
        if sf then
            A:KillTextures(sf)
            local sc = sf.GetScrollChild and sf:GetScrollChild()
            if sc then A:KillTextures(sc) end
        end
    end
    A:SkinScrollBar(GuildListScrollFrame)
    A:SkinScrollBar(GuildInfoScrollFrame)
    A:SkinScrollBar(GuildMotDScrollFrame)
    A:SkinEditBox(GuildMotDEditBox)
    A:SkinEditBox(GuildInfoEditBox)
    A:RecolorText(GuildFrame, A.text[1], A.text[2], A.text[3])

    local function skinGuildPopup(f, x1, y1, x2, y2)
        if not f or f._abGuildPopup then return end
        f._abGuildPopup = true
        A:KeepFontStrings(f)
        pcall(function() f:SetBackdrop(nil) end)
        A:AddSkinFrame(f, x1, y1, x2, y2)
        A:RecolorText(f, A.text[1], A.text[2], A.text[3])
    end
    skinGuildPopup(GuildInfoFrame,         2, -6, -6,  0)
    skinGuildPopup(GuildMemberDetailFrame, 2, -6, -6,  0)
    skinGuildPopup(GuildEventLogFrame,     2, -6, -6,  5)
    skinGuildPopup(GuildControlPopupFrame, 3, -6, -28, 25)

    for _, n in ipairs({"GuildInfoTextBackground", "GuildMemberNoteBackground",
                        "GuildMemberOfficerNoteBackground", "GuildEventFrame",
                        "GuildControlPopupFrameTabPermissions"}) do
        local f = _G[n]
        if f then
            pcall(function()
                f:SetBackdrop({
                    bgFile = A.TT_BG, edgeFile = A.TT_BD,
                    tile = true, tileSize = 16, edgeSize = 12,
                    insets = {left = 3, right = 3, top = 3, bottom = 3},
                })
                f:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.95)
                f:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.85)
            end)
        end
    end

    A:SkinScrollBar(GuildInfoFrameScrollFrame)
    A:SkinScrollBar(GuildEventLogScrollFrame)
    for _, n in ipairs({"GuildInfoSaveButton", "GuildInfoCancelButton",
                        "GuildInfoGuildEventButton", "GuildMemberRemoveButton",
                        "GuildMemberGroupInviteButton", "GuildEventLogCancelButton",
                        "GuildControlPopupAcceptButton", "GuildControlPopupFrameCancelButton"}) do
        A:SkinPanelButton(_G[n])
    end
    A:SkinDropDown(GuildControlPopupFrameDropDown)
    A:SkinEditBox(GuildControlPopupFrameEditBox)
end

function A:SkinSocialFrame()

end

function A:SkinPetStableFrame()
    if not PetStableFrame or A.done.petStable then return end
    A.done.petStable = true
    A:SkinStdBlizzFrame(PetStableFrame, 10, -11, -32, 71)

    for i = 1, 10 do
        local btn = _G["PetStableStabledPet"..i]
        if btn then
            local n = btn:GetNormalTexture()
            if n then n:SetTexture("Interface\\Buttons\\UI-Quickslot2") end
        end
    end
    A:RecolorText(PetStableFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinGroupLoot()
    if A.done.groupLoot then return end
    A.done.groupLoot = true
    for i = 1, 4 do
        local frame = _G["GroupLootFrame"..i]
        if frame then
            A:KillTextures(frame)
            A:AddSkinFrame(frame, 3, -3, -3, 3)
            A:SkinButton(_G["GroupLootFrame"..i.."NeedButton"])
            A:SkinButton(_G["GroupLootFrame"..i.."GreedButton"])
            A:SkinButton(_G["GroupLootFrame"..i.."PassButton"])
            A:SkinButton(_G["GroupLootFrame"..i.."DisenchantButton"])
        end
    end
end

function A:SkinAlertFrames()
    if A.done.alerts then return end
    A.done.alerts = true

    for i = 1, 4 do
        local f = _G["LootAlertFrame"..i]
        if f and not f._abSkinned then
            f._abSkinned = true
            A:KillTextures(f)
            A:AddSkinFrame(f, 2, -2, -2, 2)
        end
    end

    local function skinAchieve(f)
        if f and not f._abSkinned then
            f._abSkinned = true
            ArcaneUI:KillTextures(f)
            ArcaneUI:AddSkinFrame(f, 2, -2, -2, 2)
        end
    end

    for i = 1, 10 do
        skinAchieve(_G["AchievementAlertFrame"..i])
    end

    if AlertFrame and not AlertFrame._abHooked then
        AlertFrame._abHooked = true
        AlertFrame:HookScript("OnShow", function(self)
            for i = 1, 10 do skinAchieve(_G["AchievementAlertFrame"..i]) end
        end)
    end

    if LFDDungeonReadyDialog then
        A:KillTextures(LFDDungeonReadyDialog)
        A:AddSkinFrame(LFDDungeonReadyDialog, 3, -3, -3, 3)
        A:SkinButton(LFDDungeonReadyDialogEnterDungeonButton)
        A:SkinButton(LFDDungeonReadyDialogLeaveQueueButton)
    end
end
