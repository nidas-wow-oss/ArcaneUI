local A = ArcaneUI

function A:SkinActionBars()
    if A.done.actionBars then return end
    A.done.actionBars = true

    if MainMenuBarLeftEndCap  then MainMenuBarLeftEndCap:SetAlpha(0)  end
    if MainMenuBarRightEndCap then MainMenuBarRightEndCap:SetAlpha(0) end

    if MainMenuBarArtFrame then
        for i = 1, MainMenuBarArtFrame:GetNumRegions() do
            local r = select(i, MainMenuBarArtFrame:GetRegions())
            if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                r:SetAlpha(0)
            end
        end
    end

    for i = 0, 3 do
        local t = _G["MainMenuXPBarTexture"..i]
        if t and t.SetAlpha then t:SetAlpha(0) end
    end
    if MainMenuExpBar    then A:SkinBar(MainMenuExpBar,    A.accent[1],    A.accent[2],    A.accent[3])    end
    if ReputationWatchBar then A:SkinBar(ReputationWatchBar, A.borderDim[1], A.borderDim[2], A.borderDim[3]) end

    local buttonGroups = {
        {"ActionButton",              12},
        {"BonusActionButton",         12},
        {"MultiBarBottomLeftButton",  12},
        {"MultiBarBottomRightButton", 12},
        {"MultiBarRightButton",       12},
        {"MultiBarLeftButton",        12},
        {"ShapeshiftButton",          10},
        {"PetActionButton",           10},
    }
    for _, g in ipairs(buttonGroups) do
        for i = 1, g[2] do A:SkinActionButton(_G[g[1]..i]) end
    end

    if not A._actionBarBG and MainMenuBar then
        local abBG = CreateFrame("Frame", "ArcaneUI_ActionBarBG", UIParent)
        A._actionBarBG = abBG

        pcall(function()
            local mainLvl = MainMenuBar:GetFrameLevel() or 1
            abBG:SetFrameLevel(math.max(mainLvl - 2, 0))
        end)

        abBG:SetPoint("BOTTOMLEFT",  MainMenuBar, "BOTTOMLEFT",  -10, -2)
        abBG:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMRIGHT",  10, -2)

        abBG:SetBackdrop({
            bgFile   = A.TT_BG,
            edgeFile = A.TT_BD,
            tile=true, tileSize=16, edgeSize=16,
            insets={left=4, right=4, top=4, bottom=4},
        })
        abBG:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 0.88)
        abBG:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.72)

        local function adjustHeight()

            local topRowH  = 0
            local mainBarH = (MainMenuBar:GetHeight() or 38) + 4

            if (MultiBarBottomLeft  and MultiBarBottomLeft:IsShown()) or
               (MultiBarBottomRight and MultiBarBottomRight:IsShown()) then
                topRowH = (MultiBarBottomLeft and MultiBarBottomLeft:GetHeight() or 37) + 4
            end

            abBG:SetHeight(mainBarH + topRowH)

            abBG:ClearAllPoints()
            if topRowH > 0 then

                abBG:SetPoint("BOTTOMLEFT",  MainMenuBar, "BOTTOMLEFT",  -10, -2)
                abBG:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMRIGHT",  10, -2)
            else
                abBG:SetPoint("BOTTOMLEFT",  MainMenuBar, "BOTTOMLEFT",  -10, -2)
                abBG:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMRIGHT",  10, -2)
            end
        end

        local function hookBarFrame(f)
            if f and f.HookScript then
                pcall(function()
                    f:HookScript("OnShow", adjustHeight)
                    f:HookScript("OnHide", adjustHeight)
                end)
            end
        end
        hookBarFrame(MultiBarBottomLeft)
        hookBarFrame(MultiBarBottomRight)

        adjustHeight()
    end
end

function A:SkinMinimap()

end

function A:SkinChatFrames()
    if A.done.chat then return end
    A.done.chat = true

    for i = 1, NUM_CHAT_WINDOWS or 7 do
        local cf = _G["ChatFrame"..i]
        if cf and not cf._abChatSkinned then
            cf._abChatSkinned = true

            pcall(function() cf:SetBackdrop(nil) end)
        end

        local tab = _G["ChatFrame"..i.."Tab"]
        if tab and not tab._abSkinned then
            tab._abSkinned = true
            A:KillTextures(tab)

            local sf = CreateFrame("Frame", nil, tab)
            tab._abCustomBD = sf
            pcall(function()
                sf:SetFrameLevel(math.max((tab:GetFrameLevel() or 1) - 1, 0))
            end)
            sf:SetPoint("TOPLEFT",     tab, "TOPLEFT",      4,  0)
            sf:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -4,  2)
            sf:SetBackdrop({
                bgFile=A.TT_BG, edgeFile=A.TT_BD,
                tile=true, tileSize=16, edgeSize=10,
                insets={left=2, right=2, top=2, bottom=2},
            })
            sf:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.70)
            sf:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.50)
        end
        local txt = _G["ChatFrame"..i.."TabText"]
        if txt then

            txt:SetTextColor(1, 1, 1)

            pcall(function()
                local font, _, flags = txt:GetFont()
                if font then txt:SetFont(font, 11, flags) end
            end)
        end

        for _, suffix in ipairs({"UpButton", "DownButton", "ScrollToBottomButton"}) do
            local btn = _G["ChatFrame"..i..suffix]
            if btn and not btn._abSkinned then
                btn._abSkinned = true

                local nTex = btn:GetNormalTexture()
                local pTex = btn:GetPushedTexture()
                for ri = 1, btn:GetNumRegions() do
                    local r = select(ri, btn:GetRegions())
                    if r and r.GetObjectType and r:GetObjectType() == "Texture"
                       and r ~= nTex and r ~= pTex then
                        A.kill(r)
                    end
                end

                local h = btn:GetHighlightTexture()
                if h then
                    h:SetTexture(A.FLAT)
                    h:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.18)
                    h:SetAllPoints(btn)
                end
            end
        end
    end

    local eb = ChatFrameEditBox
    if eb and not eb._abSkinned then
        eb._abSkinned = true
        A:KillTextures(eb)
        pcall(function()
            eb:SetBackdrop({
                bgFile=A.TT_BG, edgeFile=A.TT_BD,
                tile=true, tileSize=16, edgeSize=16,
                insets={left=3, right=3, top=3, bottom=3},
            })
            eb:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.95)
            eb:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.88)
        end)
        if eb.SetTextColor then
            eb:SetTextColor(A.text[1], A.text[2], A.text[3])
        end
        local lang = _G["ChatFrameEditBoxLanguage"]
        if lang then A:KillTextures(lang) end
    end

    if GeneralDockManager and not GeneralDockManager._abSkinned then
        GeneralDockManager._abSkinned = true
        A:KillTextures(GeneralDockManager)

        if GeneralDockManagerScrollFrame then
            A:KillTextures(GeneralDockManagerScrollFrame)
        end
    end

    if ChatFrameMenuButton and not ChatFrameMenuButton._abSkinned then
        ChatFrameMenuButton._abSkinned = true
        pcall(function()
            local h = ChatFrameMenuButton:GetHighlightTexture()
            if h then
                h:SetTexture(A.FLAT)
                h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.18)
                h:SetAllPoints(ChatFrameMenuButton)
            end
        end)
    end

    local function tintChatButton(btn)
        if not btn or btn._abTinted then return end
        btn._abTinted = true
        pcall(function()
            for _, t in ipairs({btn:GetNormalTexture(), btn:GetPushedTexture(),
                                btn:GetDisabledTexture()}) do
                if t then
                    t:SetDesaturated(true)
                    t:SetVertexColor(A.text[1], A.text[2], A.text[3])
                end
            end

            local h = (not btn._abSkinned) and btn:GetHighlightTexture()
            if h then
                h:SetDesaturated(true)
                h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3])
            end
        end)
    end
    for i = 1, NUM_CHAT_WINDOWS or 7 do
        local bf = "ChatFrame"..i.."ButtonFrame"
        for _, s in ipairs({"UpButton", "DownButton", "BottomButton", "MinimizeButton"}) do
            tintChatButton(_G[bf..s])
        end
        tintChatButton(_G["ChatFrame"..i.."BottomButton"])
    end
    tintChatButton(ChatFrameMenuButton)
    tintChatButton(_G["FriendsMicroButton"])

    if not A._chatTabHooked and FCFTab_UpdateColors then
        A._chatTabHooked = true
        hooksecurefunc("FCFTab_UpdateColors", function(tab, selected)
            if not tab then return end
            pcall(function()
                local fs = tab.GetFontString and tab:GetFontString()
                if not fs then return end
                if selected then
                    fs:SetTextColor(A.borderHi[1], A.borderHi[2], A.borderHi[3])
                else
                    fs:SetTextColor(A.text[1], A.text[2], A.text[3])
                end
            end)
        end)
    end

    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA   = 1.0
    CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA     = 0.70
    CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA   = 1.0
    CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA   = 1.0
    CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1.0
end

function A:SkinDropDownMenus()
    if A.done.dropdowns then return end
    A.done.dropdowns = true

    local BACKDROP = {
        bgFile   = A.TT_BG,
        edgeFile = A.TT_BD,
        tile=true, tileSize=16, edgeSize=16,
        insets={left=4, right=4, top=4, bottom=4},
    }

    local function applyDD(obj)
        if not obj then return end
        pcall(function()
            obj:SetBackdrop(BACKDROP)
            obj:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 0.97)
            obj:SetBackdropBorderColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 1.0)
        end)
    end

    local function skinDDLevel(level)
        applyDD(_G["DropDownList"..level.."MenuBackdrop"])
        applyDD(_G["DropDownList"..level.."Backdrop"])
    end

    local function hookDDList(level)
        local list = _G["DropDownList"..level]
        if list and not list._abDDHooked then
            list._abDDHooked = true
            list:HookScript("OnShow", function()

                local d = CreateFrame("Frame")
                d:SetScript("OnUpdate", function(self)
                    self:SetScript("OnUpdate", nil)
                    skinDDLevel(level)
                end)
            end)
        end
    end

    for i = 1, 2 do hookDDList(i) end

    hooksecurefunc("UIDropDownMenu_CreateFrames", function(level)
        if level then
            hookDDList(level)
            skinDDLevel(level)
        end
    end)
end
