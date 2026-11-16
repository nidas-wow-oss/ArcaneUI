local A = ArcaneUI

function A:SkinFriendsFrame()
    if not FriendsFrame or A.done.friends then return end
    A.done.friends = true
    A:SkinStdBlizzFrame(FriendsFrame, 12, -11, -33, 71)
    A:SkinFrameTabs(FriendsFrame)
    A:SkinScrollBar(FriendsFrameScrollFrame)
    A:SkinEditBox(AddFriendNameEditBox)
    A:SkinEditBox(WhoFrameEditBox)
    A:SkinScrollBar(WhoListScrollFrame)
    A:SkinScrollBar(IgnoreListScrollFrame)

    for _, name in ipairs({"FriendsListFrame", "WhoFrame", "ChannelFrame", "RaidFrame"}) do
        local panel = _G[name]
        if panel then A:KillTextures(panel) end
    end

    A:RecolorText(FriendsFrame, A.textHi[1], A.textHi[2], A.textHi[3])

    A:SkinChannelFrame()
    A:HookStatusMenuFont()
end

function A:SkinChannelFrame()
    if not ChannelFrame or A.done.channel then return end
    A.done.channel = true

    A:KeepFontStrings(ChannelFrame)
    A.kill(ChannelFrameVerticalBar)
    A:SkinScrollBar(ChannelListScrollFrame)
    A:SkinScrollBar(ChannelRosterScrollFrame)
    A:SkinPanelButton(ChannelFrameNewButton)
    A:SkinDropDown(ChannelListDropDown)
    A:SkinDropDown(ChannelRosterDropDown)

    local function skinChannelButtons()
        for i = 1, MAX_CHANNEL_BUTTONS or 20 do
            local btn = _G["ChannelButton"..i]
            if btn then
                local nt = _G["ChannelButton"..i.."NormalTexture"] or btn:GetNormalTexture()
                if nt then nt:SetAlpha(0) end
                if not btn._abChanBD then
                    btn._abChanBD = A:AddSubSkinFrame(btn, 0, 0, 0, 0)
                    local h = btn:GetHighlightTexture()
                    if h then
                        h:SetTexture(A.FLAT)
                        h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.18)
                        h:SetAllPoints(btn)
                    end
                end

                local col = _G["ChannelButton"..i.."Collapsed"]
                local isHeader = btn.header or (col and col:IsShown())
                if btn._abChanBD then
                    if isHeader then btn._abChanBD:Show() else btn._abChanBD:Hide() end
                end
                local txt = _G["ChannelButton"..i.."Text"]
                if txt and isHeader then
                    txt:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3])
                end
                if col then col:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
            end
        end
    end
    if ChannelList_Update then hooksecurefunc("ChannelList_Update", skinChannelButtons) end
    skinChannelButtons()

    if ChannelFrameDaughterFrame then
        A:KeepFontStrings(ChannelFrameDaughterFrame)
        pcall(function() ChannelFrameDaughterFrame:SetBackdrop(nil) end)
        A:AddSkinFrame(ChannelFrameDaughterFrame, 2, -6, -5, 0)
        A:SkinEditBox(ChannelFrameDaughterFrameChannelName)
        A:SkinEditBox(ChannelFrameDaughterFrameChannelPassword)
        A:SkinPanelButton(ChannelFrameDaughterFrameOkayButton)
        A:SkinPanelButton(ChannelFrameDaughterFrameCancelButton)
    end
end

function A:HookStatusMenuFont()
    if A._statusFontHooked or not ToggleDropDownMenu then return end
    A._statusFontHooked = true

    hooksecurefunc("ToggleDropDownMenu", function(level)
        level = level or 1
        local list = _G["DropDownList"..level]
        if not list or not list:IsShown() then return end
        local maxBtn = UIDROPDOWNMENU_MAXBUTTONS or 32

        local widest = 0
        for i = 1, maxBtn do
            local b = _G["DropDownList"..level.."Button"..i]
            if b and b:IsShown() then
                pcall(function()
                    b:SetNormalFontObject(GameFontHighlightLeft)
                    b:SetHighlightFontObject(GameFontHighlightLeft)
                end)
                local fs = b:GetFontString()
                local w = fs and fs:GetStringWidth() or 0
                if w > widest then widest = w end
            end
        end

        local need = widest + 50
        if need > (list:GetWidth() or 0) then
            list:SetWidth(need)
            for i = 1, maxBtn do
                local b = _G["DropDownList"..level.."Button"..i]
                if b and b:IsShown() then b:SetWidth(need - 25) end
            end
        end
    end)
end

function A:SkinLFDFrame()
    if not LFDParentFrame or A.done.lfd then return end
    A.done.lfd = true

    A:KillTextures(LFDParentFrame)
    pcall(function()
        LFDParentFrame:SetBackdrop({
            bgFile   = A.TT_BG,
            edgeFile = A.TT_BD,
            tile=true, tileSize=16, edgeSize=16,
            insets={left=4, right=4, top=4, bottom=4},
        })
        LFDParentFrame:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 0.96)
        LFDParentFrame:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.90)
    end)

    A:SkinFrameTabs(LFDParentFrame)

    local function killChildTextures(parent)
        if not parent then return end
        for i = 1, parent:GetNumChildren() do
            local child = select(i, parent:GetChildren())
            if child and not child._abLFDKilled then
                child._abLFDKilled = true
                if child:GetObjectType() == "Frame" then
                    A:KillTextures(child)

                    for j = 1, child:GetNumChildren() do
                        local sub = select(j, child:GetChildren())
                        if sub and not sub._abLFDKilled then
                            sub._abLFDKilled = true
                            if sub:GetObjectType() == "Frame" then
                                A:KillTextures(sub)
                            end
                        end
                    end
                end
            end
        end
    end
    killChildTextures(LFDParentFrame)

    if LFDQueueFrameRandomScrollFrame then
        A:SkinScrollBar(LFDQueueFrameRandomScrollFrame)
    end
    A:SkinScrollBar(LFDRoleCheckPopupRoleIconScrollFrame)

    A:RecolorText(LFDParentFrame, A.textHi[1], A.textHi[2], A.textHi[3])
end

function A:SkinPVPFrame()

    local PVPRoot = _G["PVPParentFrame"] or _G["PVPFrameParent"] or _G["PVPFrame"]
    if not PVPRoot or A.done.pvp then return end
    A.done.pvp = true

    A:SkinStdBlizzFrame(PVPRoot, 10, -12, -32, 71)
    A:SkinFrameTabs(PVPRoot)
    if _G["PVPFrame"] and _G["PVPFrame"] ~= PVPRoot then
        A:KillTextures(_G["PVPFrame"])
    end

    A:SkinScrollBar(BattlefieldListScrollFrame)

    local bgInfo = PVPBattlegroundFrame or _G["PVPBattlegroundFrame"]
    if bgInfo then
        A:KillTextures(bgInfo)

        for i = 1, bgInfo:GetNumChildren() do
            local child = select(i, bgInfo:GetChildren())
            if child and child:GetObjectType() == "Frame" and not child._abPVPSkinned then
                child._abPVPSkinned = true
                A:KillTextures(child)
            end
        end
        A:SkinScrollBar(PVPBattlegroundFrameInfoScrollFrame)
        A:RecolorText(bgInfo, A.textHi[1], A.textHi[2], A.textHi[3])
    end

    if PVPArenaFrame then
        A:KillTextures(PVPArenaFrame)
        for i = 1, PVPArenaFrame:GetNumChildren() do
            local child = select(i, PVPArenaFrame:GetChildren())
            if child and not child._abPVPSkinned then
                child._abPVPSkinned = true
                local t = child:GetObjectType()
                if t == "Frame" then A:KillTextures(child) end
                if t == "Button" then A:SkinButton(child) end
            end
        end
        A:RecolorText(PVPArenaFrame, A.textHi[1], A.textHi[2], A.textHi[3])
    end

    local function cleanTree(f, depth)
        if not f or depth > 3 or f._abSkinFrame then return end
        pcall(function()
            if f.GetBackdrop and f:GetBackdrop() then f:SetBackdrop(nil) end
        end)
        local n = f.GetName and f:GetName() or ""
        if not n:find("Data") and not n:find("Standard") then A:KillTextures(f) end
        if f.GetNumChildren then
            for j = 1, f:GetNumChildren() do cleanTree(select(j, f:GetChildren()), depth + 1) end
        end
    end

    local function syncStandards()
        for i = 1, 3 do
            local data = _G["PVPTeam"..i.."Data"]
            local std  = _G["PVPTeam"..i.."Standard"]
            if std then
                pcall(function() std:SetAlpha((data and data:IsShown()) and 1 or 0) end)
            end
        end
    end
    for i = 1, 3 do
        local tf = _G["PVPTeam"..i]
        if tf and not tf._abPVPSkinned then
            tf._abPVPSkinned = true
            cleanTree(tf, 0)

            A:AddSubSkinFrame(tf, 9, -4, -24, 3)
            A.kill(_G["PVPTeam"..i.."Highlight"])
            A:RecolorText(tf, A.text[1], A.text[2], A.text[3])
        end
    end
    if PVPTeam_Update then hooksecurefunc("PVPTeam_Update", syncStandards) end
    if PVPFrame and PVPFrame.HookScript then PVPFrame:HookScript("OnShow", syncStandards) end
    syncStandards()

    for i = 1, 2 do A:TipBelow(_G["PVPParentFrameTab"..i]) end

    A:SkinButton(_G["PVPFrameJoinButton"])
    A:SkinButton(_G["PVPFrameLeaveButton"])
    A:SkinButton(_G["HonorFrameJoinButton"])
    A:SkinButton(_G["HonorFrameLeaveButton"])

    for _, n in ipairs({
        "PVPBattlegroundFrameJoinButton","PVPBattlegroundFrameLeaveButton",
        "PVPBattlegroundFrameGroupJoinButton",
    }) do
        if _G[n] then A:SkinButton(_G[n]) end
    end

    if HonorFrame then
        A:KillTextures(HonorFrame)
        A:RecolorText(HonorFrame, A.textHi[1], A.textHi[2], A.textHi[3])
    end

    for _, n in ipairs({
        "PVPFrame", "PVPBattlegroundFrame", "PVPTeamDetails",
        "PVPBattlegroundFrameInfoScrollFrameChildFrame",
        "PVPBattlegroundFrameInfoScrollFrameChildFrameRewardsInfo",
        "BattlefieldFrame",
    }) do
        A:KeepFontStrings(_G[n])
    end
    for i = 1, 3 do
        A:KeepFontStrings(_G["PVPTeam"..i])
    end

    local child = _G["PVPBattlegroundFrameInfoScrollFrameChildFrame"]
    if child then A:KillWideTextures(child, 180) end
    if PVPBattlegroundFrame then A:KillWideTextures(PVPBattlegroundFrame, 180) end

    A:RecolorText(PVPRoot, A.textHi[1], A.textHi[2], A.textHi[3])
    A:HookPolish(PVPRoot)

    local function brightenBGText()
        for _, n in ipairs({
            "PVPBattlegroundFrameInfoScrollFrameChildFrameDescription",
            "PVPBattlegroundFrameInfoScrollFrameChildFrameRewardsInfoDescription",
            "BattlefieldFrameInfoScrollFrameChildFrameDescription",
            "BattlefieldFrameInfoScrollFrameChildFrameRewardsInfoDescription",
        }) do
            local fs = _G[n]
            if fs then fs:SetTextColor(A.text[1], A.text[2], A.text[3]) end
        end
        local ri = _G["PVPBattlegroundFrameInfoScrollFrameChildFrameRewardsInfo"]
        if ri and ri.description then
            ri.description:SetTextColor(A.text[1], A.text[2], A.text[3])
        end
    end
    if PVPBattlegroundFrame then A:WatchClean(PVPBattlegroundFrame, brightenBGText, 0.5) end
    if BattlefieldFrame then A:WatchClean(BattlefieldFrame, brightenBGText, 0.5) end
end
