local A = ArcaneUI

function A:SkinCompanionFrame()

    local CF = _G["PetPaperDollFrameCompanionFrame"] or _G["CompanionFrame"]
    if not CF or A.done.companion then return end
    A.done.companion = true

    A:KeepFontStrings(_G["PetPaperDollFrame"])
    A:KeepFontStrings(CF)
    A:KeepFontStrings(_G["CompanionModelFrame"])
    A:KeepFontStrings(_G["PetModelFrame"])
    A:KeepFontStrings(_G["PetAttributesFrame"])
    A:StripBackdrops(CF)

    local function cleanCompanion()
        A:KeepFontStrings(CF)
        A:KeepFontStrings(_G["CompanionModelFrame"])
        A:StripBackdrops(CF)
    end
    A:WatchClean(CF, cleanCompanion, 0.4)

    local model = _G["CompanionModelFrame"]
    if model and not model._abPanel then
        local mp = CreateFrame("Frame", nil, CF)
        mp._abSkinFrame = true
        mp:SetFrameLevel(math.max((CF:GetFrameLevel() or 1) - 1, 0))
        mp:EnableMouse(false)
        mp:SetPoint("TOPLEFT",     model, "TOPLEFT",     -4,  4)
        mp:SetPoint("BOTTOMRIGHT", model, "BOTTOMRIGHT",  4, -4)
        mp:SetBackdrop({
            bgFile = A.TT_BG, edgeFile = A.TT_BD,
            tile = true, tileSize = 16, edgeSize = 12,
            insets = {left = 3, right = 3, top = 3, bottom = 3},
        })
        mp:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.95)
        mp:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.70)
        model._abPanel = mp
    end

    A:SkinPanelButton(_G["CompanionSummonButton"] or _G["CompanionFrameSummonButton"])
    for _, n in ipairs({
        "CompanionPrevPageButton", "CompanionNextPageButton",
        "CompanionModelFrameRotateLeftButton", "CompanionModelFrameRotateRightButton",
        "PetPaperDollFrameCompanionFramePrevPageButton",
        "PetPaperDollFrameCompanionFrameNextPageButton",
    }) do
        local b = _G[n]
        if b then A:SkinScrollArrow(b) end
    end

    local function skinCompanionSlots()
        for i = 1, NUM_COMPANIONS_PER_PAGE or 12 do
            A:SkinCompanionSlot(_G["CompanionButton"..i])
        end
    end
    skinCompanionSlots()

    if PetPaperDollFrame_UpdateCompanions and not A._companionHooked then
        A._companionHooked = true
        hooksecurefunc("PetPaperDollFrame_UpdateCompanions", skinCompanionSlots)
    end

    pcall(function() A:SkinFrameTabs(_G["PetPaperDollFrame"]) end)
    for i = 1, 4 do
        local t = _G["PetPaperDollFrameTab"..i]
        if t then A:SkinTab(t) end
    end

    A:RecolorText(CF, A.textHi[1], A.textHi[2], A.textHi[3])
end

function A:SkinCharacterFrame()
    if not CharacterFrame or A.done.charFrame then return end
    A.done.charFrame = true

    A:SkinStdBlizzFrame(CharacterFrame, 10, -12, -31, 71)

    A:SkinFrameTabs(CharacterFrame)
    A:RecolorText(CharacterFrame, A.textHi[1], A.textHi[2], A.textHi[3])

    for _, name in ipairs({"PaperDollFrame","PetPaperDollFrame","ReputationFrame","SkillFrame","TokenFrame"}) do
        local p = _G[name]
        if p then
            A:KillTextures(p)
        end
    end

    local slots = {
        "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","ShirtSlot",
        "TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot","FeetSlot",
        "Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
        "MainHandSlot","SecondaryHandSlot","RangedSlot","AmmoSlot",
    }
    for _, s in ipairs(slots) do
        local slot = _G["Character"..s]
        if slot then
            local n = slot:GetNormalTexture()
            if n then n:SetTexture("Interface\\Buttons\\UI-Quickslot2") end
        end
    end

    for i = 1, SKILLS_TO_DISPLAY or 22 do
        local bar = _G["SkillRankFrame"..i]
        if bar then
            A.kill(_G["SkillRankFrame"..i.."BorderNormal"])
            A.kill(_G["SkillRankFrame"..i.."Background"])
            A:SkinBar(bar, A.accent[1], A.accent[2], A.accent[3])
        end
    end
    for i = 1, NUM_FACTIONS_DISPLAYED or 16 do
        local lTex = _G["ReputationBar"..i.."ReputationBarLeftTexture"]
        local rTex = _G["ReputationBar"..i.."ReputationBarRightTexture"]
        local bg   = _G["ReputationBar"..i.."Background"]
        local bar  = _G["ReputationBar"..i.."ReputationBar"]
        if lTex then lTex:SetAlpha(0) end
        if rTex then rTex:SetAlpha(0) end
        if bg   then bg:SetAlpha(0) end
        if bar  then A:SkinBar(bar, A.borderHi[1], A.borderHi[2], A.borderHi[3]) end
    end

    if PlayerTitleFrame then
        A:SkinDropDown(PlayerTitleFrame)
        pcall(function() UIDropDownMenu_SetWidth(PlayerTitleFrame, 115) end)
        local titleText = _G["PlayerTitleFrameText"]
        if titleText then
            titleText:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3])
            titleText:SetWidth(110)
        end
    end

    if PlayerTitlePickerFrame then
        A:KillTextures(PlayerTitlePickerFrame)
        pcall(function()
            PlayerTitlePickerFrame:SetBackdrop({
                bgFile=A.TT_BG, edgeFile=A.TT_BD,
                tile=true, tileSize=16, edgeSize=16,
                insets={left=4, right=4, top=4, bottom=4},
            })
            PlayerTitlePickerFrame:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], 0.97)
            PlayerTitlePickerFrame:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.90)
        end)
        A:SkinScrollBar(PlayerTitlePickerScrollFrame)
    end
    A:SkinDropDown(PlayerStatFrameLeftDropDown)
    A:SkinDropDown(PlayerStatFrameRightDropDown)
end

function A:SkinSpellBookFrame()
    if not SpellBookFrame or A.done.spellBook then return end
    A.done.spellBook = true

    A:SkinStdBlizzFrame(SpellBookFrame, 10, -12, -31, 70)
    A:SkinFrameTabs(SpellBookFrame)

    for i = 1, 5 do
        local tabBtn = _G["SpellBookFrameTabButton"..i]
        if tabBtn and not A.done[tabBtn] then
            A.done[tabBtn] = true
            A:KillTextures(tabBtn)
            local sf = CreateFrame("Frame", nil, tabBtn)
            tabBtn._abCustomBD = sf
            local lvl = tabBtn:GetFrameLevel()
            sf:SetFrameLevel(lvl > 0 and lvl - 1 or 0)
            sf:EnableMouse(false)
            sf:SetBackdrop({
                bgFile=A.TT_BG, edgeFile=A.TT_BD,
                tile=true, tileSize=16, edgeSize=12,
                insets={left=3, right=3, top=3, bottom=3},
            })
            sf:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.85)
            sf:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.70)

            local fs = tabBtn.GetFontString and tabBtn:GetFontString()
            if fs then fs:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end

            sf:SetPoint("CENTER", tabBtn, "CENTER", 0, 0)
            sf:SetWidth(96)
            sf:SetHeight(24)
            local function fitToText()
                local f = tabBtn.GetFontString and tabBtn:GetFontString()
                if not f then return end
                local w = f:GetStringWidth() or 0
                if w <= 0 then return end
                sf:ClearAllPoints()
                sf:SetPoint("CENTER", f, "CENTER", 0, 0)
                sf:SetWidth(w + 22)
                sf:SetHeight(24)
            end
            fitToText()
            if tabBtn.HookScript then tabBtn:HookScript("OnShow", fitToText) end
        end
    end

    if SpellBookTitleText then
        SpellBookTitleText:SetTextColor(1, 0.82, 0, 1)
    end

    for _, btnName in ipairs({"SpellBookNextPageButton", "SpellBookPrevPageButton"}) do
        local btn = _G[btnName]
        if btn and not btn._abArrowSkinned then
            btn._abArrowSkinned = true

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

    for i = 1, MAX_SKILLLINE_TABS or 8 do
        local tab = _G["SpellBookSkillLineTab"..i]
        if tab and not tab._abSkinned then
            tab._abSkinned = true
            local nTex = tab.GetNormalTexture and tab:GetNormalTexture()

            for j = 1, tab:GetNumRegions() do
                local r = select(j, tab:GetRegions())
                if r and r.GetObjectType and r:GetObjectType() == "Texture" and r ~= nTex then
                    r:SetTexture(nil)
                    r:SetAlpha(0)
                end
            end

            local h = tab.GetHighlightTexture and tab:GetHighlightTexture()
            if h then
                h:SetTexture(A.FLAT)
                h:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.22)
                h:SetAllPoints(tab)
            end

            A:AddSubSkinFrame(tab, 2, -2, -2, 2)
        end
    end

    for i = 1, SPELLS_PER_PAGE or 12 do
        local btn = _G["SpellButton"..i]
        if btn and not btn._abSkinned then
            btn._abSkinned = true
            local n = btn.GetNormalTexture and btn:GetNormalTexture()
            if n then n:SetTexture(nil) end
            local d = btn.GetDisabledTexture and btn:GetDisabledTexture()
            if d then d:SetAlpha(0) end
            A:AddSubSkinFrame(btn, 1, -1, -1, 1)
        end
    end

    hooksecurefunc("SpellButton_UpdateButton", function(self)
        local name = self:GetName()
        if not name then return end

        local subText = _G[name.."SubSpellName"]
        if subText then subText:SetTextColor(1, 1, 1) end

        local n = self:GetNormalTexture()
        if n then n:SetTexture(nil) end

        pcall(function()
            for ri = 1, self:GetNumRegions() do
                local r = select(ri, self:GetRegions())
                if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                    local tex = r:GetTexture()
                    local low = type(tex) == "string" and tex:lower() or ""
                    if low:find("spellbook", 1, true) or low:find("emptyslot", 1, true) then
                        r:SetTexture(nil)
                        r:SetAlpha(0)
                    end
                end
            end
        end)

        local iconTex = _G[name.."IconTexture"]
        if iconTex then

            local isEmptySlot = not iconTex:IsShown() or not iconTex:GetTexture()
            if isEmptySlot then
                if not self._abEmptyBG then
                    self._abEmptyBG = self:CreateTexture(nil, "BACKGROUND")
                    self._abEmptyBG:SetAllPoints()
                    self._abEmptyBG:SetTexture(A.FLAT)
                    self._abEmptyBG:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.06)
                end
                self._abEmptyBG:Show()
            else
                if self._abEmptyBG then self._abEmptyBG:Hide() end
            end
        end
    end)

    A:SkinScrollBar(SpellBookFrame)
end

function A:SkinTalentFrame()
    local TF = _G["PlayerTalentFrame"] or _G["TalentFrame"]
    if not TF or A.done.talent then return end
    A.done.talent = true
    A.TalentFrame = TF

    A:KeepRegions(TF, 2, 7)
    A:SkinStdBlizzFrame(TF, 10, -12, -31, 71)
    A:SkinFrameTabs(TF)

    local sfr = _G["PlayerTalentFrameScrollFrame"] or _G["TalentFrameScrollFrame"]
    if sfr then
        A:KeepRegions(sfr, 5, 6)
        A:SkinScrollBar(sfr)

        local bp = A:AddBackPanel(sfr, -4, 4, 4, -4)

        if bp then bp:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.45) end
    end

    for _, n in ipairs({
        "PlayerTalentFrameStatusFrame", "PlayerTalentFramePointsBar",
        "PlayerTalentFramePreviewBar",  "PlayerTalentFramePreviewBarFiller",
    }) do
        A:KeepFontStrings(_G[n])
    end

    for i = 1, 3 do
        local st = _G["PlayerSpecTab"..i]
        if st and not st._abSkinned then
            st._abSkinned = true
            A:KeepRegions(st, 2, 3)
            pcall(function()
                st:SetBackdrop({bgFile = A.TT_BG, edgeFile = A.TT_BD, tile = true, tileSize = 16,
                    edgeSize = 12, insets = {left = 3, right = 3, top = 3, bottom = 3}})
                st:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.95)
                st:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.95)
                local n = st:GetNormalTexture()
                if n then
                    n:ClearAllPoints()
                    n:SetPoint("TOPLEFT", st, "TOPLEFT", 4, -4)
                    n:SetPoint("BOTTOMRIGHT", st, "BOTTOMRIGHT", -4, 4)
                    n:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                end
                local c = st.GetCheckedTexture and st:GetCheckedTexture()
                if c then
                    c:SetTexture(A.FLAT)
                    c:SetAlpha(1)
                    c:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.25)
                    c:SetPoint("TOPLEFT", st, "TOPLEFT", 4, -4)
                    c:SetPoint("BOTTOMRIGHT", st, "BOTTOMRIGHT", -4, 4)
                end
                local h = st:GetHighlightTexture()
                if h then
                    h:SetTexture(A.FLAT)
                    h:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.22)
                    h:SetPoint("TOPLEFT", st, "TOPLEFT", 4, -4)
                    h:SetPoint("BOTTOMRIGHT", st, "BOTTOMRIGHT", -4, 4)
                end
            end)
        end
    end

    local function skinTalentBtn(btn)
        if not btn or btn._abTalentBtnSkinned then return end
        if not btn.GetObjectType or btn:GetObjectType() ~= "Button" then return end
        btn._abTalentBtnSkinned = true
        local n = btn.GetNormalTexture and btn:GetNormalTexture()
        if n then n:SetTexture(nil) end
        local h = btn.GetHighlightTexture and btn:GetHighlightTexture()
        if h then
            h:SetTexture(A.FLAT)
            h:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.22)
            h:SetAllPoints(btn)
        end

        pcall(function()
            btn:SetBackdrop({bgFile = A.TT_BG, edgeFile = A.TT_BD, tile = true, tileSize = 16,
                edgeSize = 12, insets = {left = 3, right = 3, top = 3, bottom = 3}})
            btn:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], A.bgMid[4])
            btn:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], A.borderDim[4])
        end)
    end

    local function skinAllTalentBtns()
        for i = 1, MAX_NUM_TALENTS or 40 do
            skinTalentBtn(_G["PlayerTalentFrameTalent"..i])
        end
        if sfr then
            local child = sfr.GetScrollChild and sfr:GetScrollChild()
            if child and child.GetNumChildren then
                for i = 1, child:GetNumChildren() do
                    skinTalentBtn(select(i, child:GetChildren()))
                end
            end
        end
    end

    local function updateGlyphBleed()
        local onGlyphs = _G.GlyphFrame and GlyphFrame:IsShown()
        for _, n in ipairs({
            "PlayerTalentFrameTitleText",
            "PlayerTalentFrameScrollFrame",
            "PlayerTalentFramePointsBar",
        }) do
            local o = _G[n]
            if o then
                pcall(function()
                    if onGlyphs then
                        if o:IsShown() then o._abGlyphHid = true; o:Hide() end
                    elseif o._abGlyphHid then
                        o._abGlyphHid = nil; o:Show()
                    end
                end)
            end
        end
        if onGlyphs then
            for _, n in ipairs({
                "PlayerTalentFrameStatusFrame", "PlayerTalentFrameActivateButton",
                "PlayerTalentFramePreviewBar",
            }) do
                local o = _G[n]
                if o then pcall(function() o:Hide() end) end
            end
        end
    end
    A.UpdateGlyphBleed = updateGlyphBleed

    for _, n in ipairs({"PlayerTalentFrameStatusFrame", "PlayerTalentFrameActivateButton"}) do
        local o = _G[n]
        if o and not o._abGlyphHook then
            o._abGlyphHook = true
            o:HookScript("OnShow", function(self)
                if _G.GlyphFrame and GlyphFrame:IsShown() then self:Hide() end
            end)
        end
    end

    if TalentFrame_Update then
        hooksecurefunc("TalentFrame_Update", function(this)
            if this ~= TF then return end
            skinAllTalentBtns()
            updateGlyphBleed()
        end)
    end
    if PlayerTalentFrame_Update then
        hooksecurefunc("PlayerTalentFrame_Update", function()
            skinAllTalentBtns()
            updateGlyphBleed()
        end)
    end
    TF:HookScript("OnShow", function()
        skinAllTalentBtns()
        updateGlyphBleed()
    end)

    skinAllTalentBtns()
    A:RecolorText(TF, A.textHi[1], A.textHi[2], A.textHi[3])
end

function A:SkinGlyphFrame()
    if not GlyphFrame or A.done.glyph then return end
    A.done.glyph = true

    A:KeepRegions(GlyphFrame, 2, 3, 4, 5, 6, 7, 8)

    if not GlyphFrame._abBGPanel then
        local bgp = CreateFrame("Frame", nil, GlyphFrame)
        bgp._abSkinFrame = true
        bgp:SetFrameLevel(math.max((GlyphFrame:GetFrameLevel() or 1) - 1, 0))
        bgp:EnableMouse(false)

        bgp:SetPoint("TOPLEFT", GlyphFrame, "TOPLEFT", 16, -55)
        bgp:SetWidth(331)
        bgp:SetHeight(357)
        bgp:SetBackdrop({
            bgFile = A.TT_BG, edgeFile = A.TT_BD,
            tile = true, tileSize = 16, edgeSize = 14,
            insets = {left = 4, right = 4, top = 4, bottom = 4},
        })

        bgp:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.45)
        bgp:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.90)
        GlyphFrame._abBGPanel = bgp

        local fill = GlyphFrame:CreateTexture(nil, "BACKGROUND")

        fill:SetTexture(A.TT_BG)
        fill:SetVertexColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.35)
        fill:SetPoint("TOPLEFT",     bgp, "TOPLEFT",      4, -4)
        fill:SetPoint("BOTTOMRIGHT", bgp, "BOTTOMRIGHT", -4,  4)
        GlyphFrame._abFill = fill
    end

    if not GlyphFrame._abBleedHooked then
        GlyphFrame._abBleedHooked = true
        local function sync() if A.UpdateGlyphBleed then A.UpdateGlyphBleed() end end
        GlyphFrame:HookScript("OnShow", sync)
        GlyphFrame:HookScript("OnHide", sync)
        sync()
    end

    if GlyphFrameSparkleFrame then GlyphFrameSparkleFrame:SetAlpha(0) end

    local function skinGlyphBtn(btn)
        if not btn or btn._abGlyphSkinned then return end
        btn._abGlyphSkinned = true

        local h = btn.GetHighlightTexture and btn:GetHighlightTexture()
        if h then
            h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.6)
        end
    end

    for i = 1, 3 do skinGlyphBtn(_G["GlyphFrameMajorGlyph"..i]) end
    for i = 1, 3 do skinGlyphBtn(_G["GlyphFrameMinorGlyph"..i]) end
    for i = 1, 9 do skinGlyphBtn(_G["GlyphFrameGlyph"..i]) end

    local function tintRings()
        pcall(function()
            local function scan(f, depth)
                if not f or depth > 3 or not f.GetNumRegions then return end
                for i = 1, f:GetNumRegions() do
                    local r = select(i, f:GetRegions())
                    if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                        local tex = r:GetTexture()
                        local low = type(tex) == "string" and tex:lower() or ""
                        if low:find("glyph", 1, true) or low:find("rune", 1, true) then
                            r:SetVertexColor(A.accent[1], A.accent[2], A.accent[3])
                        end
                    end
                end
                if f.GetNumChildren then
                    for i = 1, f:GetNumChildren() do
                        scan(select(i, f:GetChildren()), depth + 1)
                    end
                end
            end
            scan(GlyphFrame, 0)
        end)
    end

    local _ = tintRings

    for i = 1, 2 do
        local tab = _G["GlyphFrameTab"..i]
        if tab then A:SkinTab(tab) end
    end

    A:RecolorText(GlyphFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinAchievementFrame()
    if not AchievementFrame or A.done.achieve then return end
    A.done.achieve = true

    A:SkinStdBlizzFrame(AchievementFrame, 0, 12, 0, -3)
    A:SkinFrameTabs(AchievementFrame)

    if AchievementFrameHeader then
        A:KillTextures(AchievementFrameHeader)
        A:RecolorText(AchievementFrameHeader, A.textHi[1], A.textHi[2], A.textHi[3])
    end

    if AchievementFrameSummary then
        A:KillTextures(AchievementFrameSummary)
        if AchievementFrameSummaryBackground then AchievementFrameSummaryBackground:SetAlpha(0) end
        if AchievementFrameSummaryAchievementsHeaderHeader then AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0) end
    end

    if AchievementFrameCategories then
        A:KillTextures(AchievementFrameCategories)
        A:AddSubSkinFrame(AchievementFrameCategories)
    end

    if AchievementFrameAchievements then A:KillTextures(AchievementFrameAchievements) end

    if AchievementFrameStats then
        A:KillTextures(AchievementFrameStats)
        if AchievementFrameStatsBG then AchievementFrameStatsBG:SetAlpha(0) end
    end

    if AchievementFrameComparison then
        A:KillTextures(AchievementFrameComparison)
        if AchievementFrameComparisonBackground then AchievementFrameComparisonBackground:SetAlpha(0) end
        if AchievementFrameComparisonDark then AchievementFrameComparisonDark:SetAlpha(0) end
        if AchievementFrameComparisonWatermark then AchievementFrameComparisonWatermark:SetAlpha(0) end
    end
    if AchievementFrameComparisonHeader then A:KillTextures(AchievementFrameComparisonHeader) end

    A:SkinScrollBar(AchievementFrameCategories)
    A:SkinScrollBar(AchievementFrameAchievements)
    A:RecolorText(AchievementFrame, A.textHi[1], A.textHi[2], A.textHi[3])

    local CONTAINERS = {
        "AchievementFrameAchievementsContainer",
        "AchievementFrameCategoriesContainer",
        "AchievementFrameStatsContainer",
        "AchievementFrameComparisonContainer",
        "AchievementFrameComparisonStatsContainer",
    }

    local function restoreHighlight(btn, alpha)
        local h = btn.GetHighlightTexture and btn:GetHighlightTexture()
        if not h then return end
        pcall(function()
            h:SetTexture(A.FLAT)
            h:SetAlpha(1)
            h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], alpha)
            h:SetAllPoints(btn)
        end)
    end

    local function stripRow(btn, isCategory)
        if not btn or not btn.GetObjectType then return end
        if btn:GetObjectType() ~= "Button" then return end
        A:KillTextures(btn)
        for _, f in ipairs({"background", "glow", "titleBar", "tabard",
                            "rewardBackground", "bling"}) do
            if btn[f] and btn[f].SetAlpha then
                pcall(function() btn[f]:SetAlpha(0) end)
            end
        end

        if not btn:GetBackdrop() then
            pcall(function()
                btn:SetBackdrop({
                    bgFile = A.TT_BG, edgeFile = A.TT_BD,
                    tile = true, tileSize = 16, edgeSize = 12,
                    insets = {left = 3, right = 3, top = 3, bottom = 3},
                })
                if isCategory then
                    btn:SetBackdropColor(A.bgMid[1] * 1.6, A.bgMid[2] * 1.6, A.bgMid[3] * 1.6, 0.95)
                    btn:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.85)
                else
                    btn:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], A.bgMid[4])
                    btn:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], A.borderDim[4])
                end
            end)
        end

        if A.done[btn] and type(A.done[btn]) == "table" and A.done[btn].Hide then A.done[btn]:Hide() end
        A.done[btn] = A.done[btn] or true
        if isCategory then

            local lbl = btn.label or _G[(btn:GetName() or "").."Label"]
            if lbl then
                pcall(function()
                    lbl:SetAlpha(1)
                    lbl:SetVertexColor(1, 1, 1, 1)
                    lbl:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3], 1)
                    lbl:SetDrawLayer("OVERLAY")
                end)
            end
            restoreHighlight(btn, 0.30)
        else
            restoreHighlight(btn, 0.12)

            local desc = btn.description or _G[(btn:GetName() or "").."Description"]
            if desc then pcall(function() desc:SetTextColor(A.text[1], A.text[2], A.text[3]) end) end
        end
    end

    local function stripRows()

        for _, cn in ipairs(CONTAINERS) do
            local c = _G[cn]
            local isCat = (cn == "AchievementFrameCategoriesContainer")
            if c then
                if c.GetNumChildren then
                    for i = 1, c:GetNumChildren() do
                        stripRow(select(i, c:GetChildren()), isCat)
                    end
                end
                local sc = c.GetScrollChild and c:GetScrollChild()
                if sc and sc.GetNumChildren then
                    for i = 1, sc:GetNumChildren() do
                        stripRow(select(i, sc:GetChildren()), isCat)
                    end
                end
            end
        end

        for _, cn in ipairs(CONTAINERS) do
            local c = _G[cn]
            if c and c.buttons then
                for _, btn in ipairs(c.buttons) do

                    A:KillTextures(btn)
                    if btn.background then pcall(function() btn.background:SetAlpha(0) end) end
                    if btn.glow       then pcall(function() btn.glow:SetAlpha(0) end) end
                    for _, f in ipairs({"left", "middle", "right"}) do
                        if btn[f] then pcall(function() btn[f]:SetAlpha(0) end) end
                    end

                    restoreHighlight(btn, cn == "AchievementFrameCategoriesContainer" and 0.30 or 0.12)

                    if cn == "AchievementFrameCategoriesContainer"
                       or cn == "AchievementFrameStatsContainer"
                       or cn == "AchievementFrameComparisonStatsContainer" then
                        A:RecolorText(btn, A.textHi[1], A.textHi[2], A.textHi[3])
                        if btn.label then
                            pcall(function() btn.label:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end)
                        end
                    end
                end
            end
        end

        for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS or 4 do
            stripRow(_G["AchievementFrameSummaryAchievement"..i], false)
        end

        for _, n in ipairs({"AchievementFrameSummaryCategoriesHeader",
                            "AchievementFrameSummaryAchievementsHeader"}) do
            local h = _G[n]
            if h then
                if h.GetNumRegions then A:KeepFontStrings(h) else A.kill(h) end
            end
        end
        for _, n in ipairs({"AchievementFrameSummaryCategoriesHeaderTexture",
                            "AchievementFrameSummaryAchievementsHeaderHeader"}) do
            A.kill(_G[n])
        end

        for i = 1, 10 do
            local pb = _G["AchievementFrameProgressBar"..i]
            if pb then
                for _, suf in ipairs({"BorderLeft", "BorderRight", "BorderCenter"}) do
                    local t = _G["AchievementFrameProgressBar"..i..suf]
                    if t then pcall(function() t:SetAlpha(0) end) end
                end
                A:SkinBar(pb, A.accent[1], A.accent[2], A.accent[3])
            end
        end

        for i = 1, 8 do
            local base = "AchievementFrameSummaryCategoriesCategory"..i
            for _, suf in ipairs({"Left", "Right", "Middle"}) do
                local t = _G[base..suf]
                if t then pcall(function() t:SetAlpha(0) end) end
            end
            local bar = _G[base]
            if bar and bar.SetStatusBarTexture then
                A:SkinBar(bar, A.accent[1], A.accent[2], A.accent[3])
            end
        end
        local total = _G["AchievementFrameSummaryCategoriesStatusBar"]
        if total then
            for _, suf in ipairs({"Left", "Right", "Middle"}) do
                local t = _G["AchievementFrameSummaryCategoriesStatusBar"..suf]
                if t then pcall(function() t:SetAlpha(0) end) end
            end
            A:SkinBar(total, A.accent[1], A.accent[2], A.accent[3])
        end

        for _, n in ipairs({
            "AchievementFrameAchievements", "AchievementFrameStats",
            "AchievementFrameSummary", "AchievementFrameComparison",
        }) do

            local function borderOnly(f, depth)
                if not f or depth > 4 or f._abSkinFrame then return end
                pcall(function()
                    if f.GetBackdrop and f:GetBackdrop() then
                        f:SetBackdropColor(0, 0, 0, 0)
                        f:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.85)
                    end
                end)
                if f.GetNumChildren then
                    for j = 1, f:GetNumChildren() do borderOnly(select(j, f:GetChildren()), depth + 1) end
                end
            end
            borderOnly(_G[n], 0)
        end

        A:DeGoldText(AchievementFrame)
    end

    A:WatchClean(AchievementFrame, stripRows, 0.4)

    local function now() pcall(stripRows) end
    AchievementFrame:HookScript("OnShow", now)
    for _, fn in ipairs({"AchievementFrame_UpdateTabs", "AchievementFrameBaseTab_OnClick",
                         "AchievementFrameAchievements_Update", "AchievementFrameCategories_Update",
                         "AchievementFrameStats_Update", "AchievementFrameSummary_Update",
                         "AchievementFrameComparison_Update"}) do
        if type(_G[fn]) == "function" then hooksecurefunc(fn, now) end
    end
    for _, n in ipairs({"AchievementFrameAchievements", "AchievementFrameStats",
                        "AchievementFrameSummary", "AchievementFrameComparison"}) do
        local f = _G[n]
        if f and f.HookScript then f:HookScript("OnShow", now) end
    end

    local title = _G["AchievementFrameHeaderTitle"] or _G["AchievementFrameTitle"]
    local tb = A:AddTitleBar(AchievementFrame, title) or AchievementFrame._abTitleBar

    if tb then
        tb:SetHeight(28)
        tb:ClearAllPoints()
        tb:SetPoint("TOPLEFT",  AchievementFrame, "TOPLEFT",  12, 6)
        tb:SetPoint("TOPRIGHT", AchievementFrame, "TOPRIGHT", -40, 6)
    end

    local pts = _G["AchievementFrameHeaderPoints"]
    if pts and title then
        pcall(function()
            pts:ClearAllPoints()
            pts:SetPoint("LEFT", title, "RIGHT", 8, 0)
            pts:SetDrawLayer("OVERLAY")
            pts:SetTextColor(A.borderHi[1], A.borderHi[2], A.borderHi[3])
        end)

        if tb and not pts._abBox then
            local box = CreateFrame("Frame", nil, tb)
            box._abSkinFrame = true
            box:SetFrameLevel(tb:GetFrameLevel())
            box:EnableMouse(false)
            box:SetPoint("TOPLEFT",     pts, "TOPLEFT",     -8,  4)
            box:SetPoint("BOTTOMRIGHT", pts, "BOTTOMRIGHT",  8, -4)
            box:SetBackdrop({
                bgFile = A.TT_BG, edgeFile = A.TT_BD,
                tile = true, tileSize = 16, edgeSize = 10,
                insets = {left = 2, right = 2, top = 2, bottom = 2},
            })
            box:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.95)
            box:SetBackdropBorderColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.95)
            pts._abBox = box
        end
    end

    local dd = _G["AchievementFrameFilterDropDown"]
    if dd and tb and not dd._abMoved then
        dd._abMoved = true
        pcall(function()
            dd:ClearAllPoints()

            dd:SetPoint("LEFT", tb, "LEFT", 12, -1)
            local n = dd:GetName()
            A.kill(_G[n.."Left"]); A.kill(_G[n.."Middle"]); A.kill(_G[n.."Right"])
            local txt = _G[n.."Text"]
            if txt then txt:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
        end)
    end
end

function A:SkinInspectFrame()
    if not InspectFrame or A.done.inspect then return end
    A.done.inspect = true
    A:SkinStdBlizzFrame(InspectFrame, 10, -12, -31, 71)
    A:SkinFrameTabs(InspectFrame)

    if InspectPaperDollFrame then
        A:KillTextures(InspectPaperDollFrame)

        for i = 1, InspectPaperDollFrame:GetNumChildren() do
            local child = select(i, InspectPaperDollFrame:GetChildren())
            if child and child:GetObjectType() == "Frame" then
                A:KillTextures(child)
            end
        end
    end

    local inspectSlots = {
        "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","ShirtSlot",
        "TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot","FeetSlot",
        "Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
        "MainHandSlot","SecondaryHandSlot","RangedSlot","AmmoSlot",
    }
    for _, s in ipairs(inspectSlots) do
        local slot = _G["Inspect"..s]
        if slot then
            local n = slot:GetNormalTexture()
            if n then n:SetTexture("Interface\\Buttons\\UI-Quickslot2") end
        end
    end

    for _, n in ipairs({"InspectRotateLeftButton","InspectRotateRightButton"}) do
        if _G[n] then A:SkinButton(_G[n]) end
    end

    A:RecolorText(InspectFrame, A.textHi[1], A.textHi[2], A.textHi[3])
end
