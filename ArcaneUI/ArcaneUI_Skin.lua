local A = ArcaneUI

local function kill(obj)
    if not obj or obj._abKeep then return end
    pcall(function()
        if obj.SetTexture then obj:SetTexture(nil) end
        if obj.SetAlpha   then obj:SetAlpha(0) end
    end)
end
A.kill = kill

function A:KillTextures(frame)
    if not frame or not frame.GetNumRegions then return end
    for i = 1, frame:GetNumRegions() do
        local r = select(i, frame:GetRegions())
        if r and r.GetObjectType and r:GetObjectType() == "Texture" then
            kill(r)
        end
    end
end

function A:KeepRegions(frame, ...)
    if not frame or not frame.GetNumRegions then return end
    local keep = {}
    for i = 1, select("#", ...) do keep[select(i, ...)] = true end
    for i = 1, frame:GetNumRegions() do
        if not keep[i] then
            local r = select(i, frame:GetRegions())
            if r and r.GetObjectType and r:GetObjectType() == "Texture" then
                kill(r)
            end
        end
    end
end

function A:KeepFontStrings(frame)
    if not frame or not frame.GetNumRegions then return end
    for i = 1, frame:GetNumRegions() do
        local r = select(i, frame:GetRegions())
        if r and not r._abKeep and r.GetObjectType and r:GetObjectType() ~= "FontString" then
            pcall(function() r:SetAlpha(0) end)
        end
    end
end

function A:RecolorBackdrops(frame, depth)
    if not frame then return end
    depth = depth or 0
    if depth > 4 then return end
    if not frame._abSkinFrame then
        pcall(function()
            if frame.GetBackdrop and frame:GetBackdrop() then
                frame:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.95)
                frame:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.85)
            end
        end)
    end
    if frame.GetNumChildren then
        for i = 1, frame:GetNumChildren() do
            local c = select(i, frame:GetChildren())
            if c then A:RecolorBackdrops(c, depth + 1) end
        end
    end
end

function A:StripBackdrops(frame, depth)
    if not frame then return end
    depth = depth or 0
    if depth > 4 then return end
    if not frame._abSkinFrame then
        pcall(function()
            if frame.GetBackdrop and frame:GetBackdrop() then frame:SetBackdrop(nil) end
        end)
    end
    if frame.GetNumChildren then
        for i = 1, frame:GetNumChildren() do
            local c = select(i, frame:GetChildren())
            if c then A:StripBackdrops(c, depth + 1) end
        end
    end
end

function A:AddSkinFrame(frame, x1, y1, x2, y2)
    if not frame or not frame.GetFrameLevel then return end
    if A.done[frame] then return A.done[frame] end

    local sf = CreateFrame("Frame", nil, frame)
    sf._abSkinFrame = true

    local lvl = frame:GetFrameLevel()
    sf:SetFrameLevel(lvl > 1 and lvl - 1 or 0)
    sf:EnableMouse(false)

    x1 = x1 or 0; y1 = y1 or 0; x2 = x2 or 0; y2 = y2 or 0
    sf:SetPoint("TOPLEFT",     frame, "TOPLEFT",      x1,  y1)
    sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",  x2,  y2)

    sf:SetBackdrop({
        bgFile   = A.TT_BG,
        edgeFile = A.TT_BD,
        tile     = true, tileSize = 16, edgeSize = 16,
        insets   = {left=4, right=4, top=4, bottom=4},
    })
    sf:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], A.bg[4])
    sf:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], A.border[4])

    A.done[frame] = sf
    return sf
end

function A:AddSubSkinFrame(frame, x1, y1, x2, y2)
    if not frame or not frame.GetFrameLevel then return end
    if A.done[frame] then return A.done[frame] end

    local sf = CreateFrame("Frame", nil, frame)
    sf._abSkinFrame = true
    local lvl = frame:GetFrameLevel()
    sf:SetFrameLevel(lvl > 1 and lvl - 1 or 0)
    sf:EnableMouse(false)
    x1=x1 or 0; y1=y1 or 0; x2=x2 or 0; y2=y2 or 0
    sf:SetPoint("TOPLEFT",     frame, "TOPLEFT",      x1,  y1)
    sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT",  x2,  y2)
    sf:SetBackdrop({
        bgFile   = A.TT_BG,
        edgeFile = A.TT_BD,
        tile     = true, tileSize = 16, edgeSize = 16,
        insets   = {left=3, right=3, top=3, bottom=3},
    })
    sf:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], A.bgMid[4])
    sf:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], A.borderDim[4])

    A.done[frame] = sf
    return sf
end

function A:SkinStdBlizzFrame(frame, x1, y1, x2, y2)
    if not frame then return end
    A:KillTextures(frame)
    A:AddSkinFrame(frame, x1, y1, x2, y2)

end

function A:AddSolidBack(frame, x1, y1, x2, y2)
    if not frame or frame._abSolidBack or not frame.CreateTexture then return end
    local t = frame:CreateTexture(nil, "BACKGROUND")
    t._abKeep = true
    t:SetTexture(A.FLAT)
    t:SetVertexColor(A.bg[1], A.bg[2], A.bg[3], A.bg[4])
    t:SetPoint("TOPLEFT",     frame, "TOPLEFT",     (x1 or 0) + 4, (y1 or 0) - 4)
    t:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", (x2 or 0) - 4, (y2 or 0) + 4)
    frame._abSolidBack = t
    return t
end

function A:SkinBar(bar, r, g, b)
    if not bar or not bar.SetStatusBarTexture then return end
    if A.done[bar] then
        bar:SetStatusBarColor(r, g, b, 1)
        return
    end
    A.done[bar] = true

    A:KillTextures(bar)

    bar:SetStatusBarTexture(A.FLAT)
    bar:SetStatusBarColor(r, g, b, 1)

    if not bar._abBG then
        local bg = bar:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetTexture(A.FLAT)
        bg:SetVertexColor(A.barBG[1], A.barBG[2], A.barBG[3], A.barBG[4])
        bar._abBG = bg
    end

    if not bar._abLines then
        local t = bar:CreateTexture(nil, "OVERLAY")
        t:SetTexture(A.FLAT)
        t:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.28)
        t:SetHeight(1)
        t:SetPoint("TOPLEFT",  bar, "TOPLEFT",  0, 0)
        t:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)

        local b2 = bar:CreateTexture(nil, "OVERLAY")
        b2:SetTexture(A.FLAT)
        b2:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.28)
        b2:SetHeight(1)
        b2:SetPoint("BOTTOMLEFT",  bar, "BOTTOMLEFT",  0, 0)
        b2:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

        bar._abLines = {t, b2}
    end
end

function A:PowerColor(unit)
    local pt = UnitPowerType(unit) or 0
    local c   = A.powerColor[pt] or A.mp
    return c[1], c[2], c[3]
end

function A:SkinButton(btn)
    if not btn then return end
    pcall(function()
        local n = btn:GetNormalTexture()
        local p = btn:GetPushedTexture()
        local h = btn:GetHighlightTexture()
        local d = btn:GetDisabledTexture()
        if n then n:SetTexture(nil) end
        if d then d:SetTexture(nil) end
        if p then
            p:SetTexture(A.FLAT)
            p:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.22)
            p:SetAllPoints(btn)
        end
        if h then
            h:SetTexture(A.FLAT)
            h:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.12)
            h:SetAllPoints(btn)
        end
        A:AddSkinFrame(btn)
    end)
end

function A:SkinCloseButton(btn)
    if not btn then return end
    pcall(function()

        local p = btn:GetPushedTexture()
        local h = btn:GetHighlightTexture()
        local d = btn:GetDisabledTexture()
        if d then d:SetTexture(nil) end
        if p then
            p:SetTexture(A.FLAT)
            p:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.25)
            p:SetAllPoints(btn)
        end
        if h then
            h:SetTexture(A.FLAT)
            h:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.14)
            h:SetAllPoints(btn)
        end
    end)
end

function A:SkinActionButton(btn)
    if not btn or A.done[btn] then return end
    A.done[btn] = true
    pcall(function()

        local n = btn:GetNormalTexture()
        if n then n:SetAlpha(0) end
        local d = btn:GetDisabledTexture()
        if d then d:SetAlpha(0) end

        if not btn._abNHooked then
            btn._abNHooked = true
            hooksecurefunc(btn, "SetNormalTexture", function(self, tex)
                if tex and tex ~= "" then
                    local nt = self:GetNormalTexture()
                    if nt then nt:SetAlpha(0) end
                end
            end)
        end
    end)
end

function A:SkinEditBox(eb)
    if not eb or A.done[eb] then return end
    A.done[eb] = true
    pcall(function()
        A:KillTextures(eb)
        eb:SetBackdrop({
            bgFile   = A.TT_BG,
            edgeFile = A.TT_BD,
            tile     = true, tileSize = 16, edgeSize = 16,
            insets   = {left=3, right=3, top=3, bottom=3},
        })
        eb:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.92)
        eb:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.80)
        if eb.SetTextColor then
            eb:SetTextColor(A.text[1], A.text[2], A.text[3])
        end
    end)
end

function A:SkinScrollBar(scrollFrame)
    if not scrollFrame or not scrollFrame.GetName then return end
    local n = scrollFrame:GetName()
    if not n then return end
    A:SkinScrollBarObj(_G[n.."ScrollBar"], scrollFrame)
end

function A:SkinScrollBarObj(sb, scrollFrame)
    if not sb or sb._abSBDone then return end
    sb._abSBDone = true
    scrollFrame = scrollFrame or (sb.GetParent and sb:GetParent())
    pcall(function()
        local sbn = sb:GetName() or ""
        local n   = scrollFrame and scrollFrame.GetName and scrollFrame:GetName() or ""

        local up   = _G[sbn.."ScrollUpButton"]   or _G[sbn.."Up"]   or _G[sbn.."UpButton"]
        local down = _G[sbn.."ScrollDownButton"] or _G[sbn.."Down"] or _G[sbn.."DownButton"]
        if A.SkinScrollArrow then
            A:SkinScrollArrow(up)
            A:SkinScrollArrow(down)
        end
        local thumb = sb.GetThumbTexture and sb:GetThumbTexture()
        if thumb then
            thumb:SetTexture(A.FLAT)
            thumb:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.55)
        end

        local function isTex(r) return r and r.GetObjectType and r:GetObjectType() == "Texture" end
        local function killTrack(f)
            if not f or not f.GetNumRegions then return end
            for i = 1, f:GetNumRegions() do
                local r = select(i, f:GetRegions())
                if isTex(r) and r ~= thumb and not r._abKeep then
                    local tex = r:GetTexture()
                    if type(tex) == "string" and tex:lower():find("scrollbar", 1, true) then
                        kill(r)
                    end
                end
            end
        end
        killTrack(scrollFrame)
        killTrack(sb)
        for _, suf in ipairs({"Top", "Bottom", "Middle", "BG"}) do
            if n ~= "" and isTex(_G[n..suf]) then kill(_G[n..suf]) end
            if isTex(_G[sbn..suf]) then kill(_G[sbn..suf]) end
        end

        if not sb._abTrack then
            local t = sb:CreateTexture(nil, "BACKGROUND")
            t._abKeep = true
            t:SetTexture(A.FLAT)
            t:SetVertexColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 0.85)
            t:SetPoint("TOPLEFT",     sb, "TOPLEFT",     2, 0)
            t:SetPoint("BOTTOMRIGHT", sb, "BOTTOMRIGHT", -2, 0)
            sb._abTrack = t
        end
    end)
end

local TAB_ART = {"Left", "Middle", "Right", "LeftDisabled", "MiddleDisabled",
                 "RightDisabled", "HighlightTexture"}
local function killTabArt(tab)
    A:KillTextures(tab)
    local n = tab.GetName and tab:GetName()
    if n then
        for _, suf in ipairs(TAB_ART) do kill(_G[n..suf]) end
    end
    kill(tab.GetHighlightTexture and tab:GetHighlightTexture())

    if tab._abPanelBD then tab._abPanelBD:Hide() end
end
A.KillTabArt = killTabArt

function A:TipBelow(tab)
    if not tab or tab._abTipMoved or not tab.HookScript then return end
    tab._abTipMoved = true
    tab:HookScript("OnEnter", function(self)
        if GameTooltip:GetOwner() ~= self or not GameTooltip:IsShown() then return end
        local lines = {}
        for l = 1, GameTooltip:NumLines() do
            local fs = _G["GameTooltipTextLeft"..l]
            local txt = fs and fs:GetText()
            if txt then
                local r, g, b = fs:GetTextColor()
                lines[#lines + 1] = {txt, r, g, b}
            end
        end
        if #lines == 0 then return end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText(lines[1][1], lines[1][2], lines[1][3], lines[1][4])
        for l = 2, #lines do
            GameTooltip:AddLine(lines[l][1], lines[l][2], lines[l][3], lines[l][4], true)
        end
        GameTooltip:Show()
    end)
end

function A:SkinTab(tab, x1, y1, x2, y2)
    if not tab then return end
    if A.done[tab] then

        pcall(killTabArt, tab)
        return
    end
    pcall(function()
        killTabArt(tab)
        A:AddSkinFrame(tab, x1 or 10, y1 or 0, x2 or -10, y2 or 2)
        local fs = tab.GetFontString and tab:GetFontString()
        if fs then fs:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
    end)
    A:TipBelow(tab)

    if not A._tabArtHooked then
        A._tabArtHooked = true
        local function reKill(t)
            if t and A.done[t] then pcall(killTabArt, t) end
        end
        if PanelTemplates_SelectTab then hooksecurefunc("PanelTemplates_SelectTab", reKill) end
        if PanelTemplates_DeselectTab then hooksecurefunc("PanelTemplates_DeselectTab", reKill) end
    end
end

function A:SkinFrameTabs(frame)
    if not frame then return end
    local n = frame:GetName()
    if not n then return end

    local nTabs = frame.numTabs or 0
    if nTabs == 0 then
        for i = 1, 12 do
            local tab = _G[n.."Tab"..i]
            if not tab then break end
            A:SkinTab(tab)
        end
    else
        for i = 1, nTabs do
            local tab = _G[n.."Tab"..i]
            if tab then A:SkinTab(tab) end
        end
    end

    if not A._tabHooked then
        A._tabHooked = true
        hooksecurefunc("PanelTemplates_SetTab", function(f, id)
            local fn = f and f.GetName and f:GetName()
            if not fn then return end
            for j = 1, (f.numTabs or 12) do
                local t = _G[fn.."Tab"..j]
                if not t then break end
                local fs = t.GetFontString and t:GetFontString()
                if fs then
                    pcall(function() fs:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end)
                end
            end
        end)
    end
end

function A:SkinDropDown(frame)
    if not frame or A.done[frame] then return end
    A.done[frame] = true
    pcall(function()
        local n = frame:GetName()
        if not n then return end

        kill(_G[n.."Left"])
        kill(_G[n.."Right"])
        kill(_G[n.."Middle"])

        local btn = _G[n.."Button"]
        if btn then
            local bh = btn.GetHighlightTexture and btn:GetHighlightTexture()
            if bh then
                bh:SetTexture(A.FLAT)
                bh:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.20)
                bh:SetAllPoints(btn)
            end

        end

        A:AddSkinFrame(frame, 16, 4, -16, -4)

        local txt = _G[n.."Text"]
        if txt then txt:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
    end)
end

function A:RecolorText(frame, r, g, b)
    if not frame or not frame.GetNumRegions then return end
    r = r or A.text[1]; g = g or A.text[2]; b = b or A.text[3]
    for i = 1, frame:GetNumRegions() do
        local reg = select(i, frame:GetRegions())
        if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
            pcall(function() reg:SetTextColor(r, g, b) end)
        end
    end
end

local function applyTooltipBackdrop(tt)
    pcall(function()
        tt:SetBackdrop({
            bgFile   = ArcaneUI.TT_BG,
            edgeFile = ArcaneUI.TT_BD,
            tile = true, tileSize = 16, edgeSize = 16,
            insets = {left=4, right=4, top=4, bottom=4},
        })
        tt:SetBackdropColor(ArcaneUI.bgDark[1], ArcaneUI.bgDark[2], ArcaneUI.bgDark[3], 0.96)
        tt:SetBackdropBorderColor(ArcaneUI.border[1], ArcaneUI.border[2], ArcaneUI.border[3], 0.90)
    end)
end

function A:SkinTooltips()
    local tips = {
        "GameTooltip", "ItemRefTooltip", "ShoppingTooltip1", "ShoppingTooltip2",
        "WorldMapTooltip", "SmallTextTooltip",
    }
    for _, name in ipairs(tips) do
        local tt = _G[name]
        if tt then
            applyTooltipBackdrop(tt)

            if not tt._abHooked then
                tt._abHooked = true
                local orig = tt:GetScript("OnShow")
                tt:SetScript("OnShow", function(self)
                    if orig then orig(self) end
                    applyTooltipBackdrop(self)
                end)
            end
        end
    end

    if not A._tooltipHooked then
        A._tooltipHooked = true
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip)
            applyTooltipBackdrop(tooltip)
        end)
    end
end
