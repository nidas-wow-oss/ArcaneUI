local A = ArcaneUI

local function isIconPath(tex)
    if type(tex) ~= "string" then return false end
    local low = tex:lower()
    if low:find("interface\\icons", 1, true) then return true end
    if low:find("interface/icons", 1, true)  then return true end
    return false
end
A.isIconPath = isIconPath

function A:SkinItemSlot(btn, keepNormal)
    if not btn or btn._abSlotSkinned then return end
    btn._abSlotSkinned = true

    pcall(function()

        if not keepNormal then
            local function applyNormal(self)
                local nt = self.GetNormalTexture and self:GetNormalTexture()
                if not nt then return end
                if isIconPath(nt:GetTexture()) then
                    nt:SetAlpha(1)
                    nt:SetAllPoints(self)
                else
                    nt:SetAlpha(0)
                end
            end
            applyNormal(btn)
            if not btn._abSlotNHooked then
                btn._abSlotNHooked = true
                hooksecurefunc(btn, "SetNormalTexture", applyNormal)
            end
        end

        local function line(p1, p2, w, h)
            local t = btn:CreateTexture(nil, "BORDER")
            t:SetTexture(A.FLAT)
            t:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.55)
            if w then t:SetWidth(w) end
            if h then t:SetHeight(h) end
            t:SetPoint(p1, btn, p1, 0, 0)
            t:SetPoint(p2, btn, p2, 0, 0)
            return t
        end
        btn._abSlotLines = {
            line("TOPLEFT",     "TOPRIGHT",    nil, 1),
            line("BOTTOMLEFT",  "BOTTOMRIGHT", nil, 1),
            line("TOPLEFT",     "BOTTOMLEFT",  1,   nil),
            line("TOPRIGHT",    "BOTTOMRIGHT", 1,   nil),
        }

        local h = btn.GetHighlightTexture and btn:GetHighlightTexture()
        if h then
            h:SetTexture(A.FLAT)
            h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.18)
            h:SetAllPoints(btn)
        end
    end)
end

function A:SkinCompanionSlot(btn)
    if not btn then return end
    A:SkinItemSlot(btn)
    if btn._abCompanionSkinned then return end
    btn._abCompanionSkinned = true
    pcall(function()
        if not btn.SetCheckedTexture then return end
        btn:SetCheckedTexture(A.FLAT)
        local ct = btn.GetCheckedTexture and btn:GetCheckedTexture()
        if ct then
            ct:SetBlendMode("BLEND")
            ct:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.28)
            ct:SetAllPoints(btn)
        end
    end)
end

function A:SkinItemSlots(names)
    for _, n in ipairs(names) do
        local b = _G[n]
        if b then A:SkinItemSlot(b) end
    end
end

local EQUIP_SLOTS = {
    "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","ShirtSlot",
    "TabardSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot","FeetSlot",
    "Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot",
    "MainHandSlot","SecondaryHandSlot","RangedSlot","AmmoSlot",
}
A.EQUIP_SLOTS = EQUIP_SLOTS

function A:SkinEquipmentSlots()
    for _, s in ipairs(EQUIP_SLOTS) do
        A:SkinItemSlot(_G["Character"..s])
        A:SkinItemSlot(_G["Inspect"..s])
    end

    for i = 1, NUM_BANKGENERIC_SLOTS or 28 do
        A:SkinItemSlot(_G["BankFrameItem"..i])
    end
    for i = 1, NUM_BANKBAGSLOTS or 7 do
        A:SkinItemSlot(_G["BankFrameBag"..i])
    end

    for i = 0, 3 do
        A:SkinItemSlot(_G["CharacterBag"..i.."Slot"])
    end

    for i = 1, NUM_COMPANIONS_PER_PAGE or 12 do
        A:SkinCompanionSlot(_G["CompanionButton"..i])
    end

    for i = 1, 3 do
        A:SkinItemSlot(_G["PetPaperDollFrameCompanionFrame"..i])
    end
end

local function isPanelButton(btn)
    if not btn.GetName then return false end
    local n = btn:GetName()
    if n and (_G[n.."Left"] or _G[n.."Middle"] or _G[n.."Right"]) then return true end
    local nt = btn.GetNormalTexture and btn:GetNormalTexture()
    if nt and nt.GetTexture then
        local tex = nt:GetTexture()
        if type(tex) == "string" and tex:lower():find("ui%-panel%-button") then return true end
    end
    return false
end

function A:HasArcaneBackdrop(f)
    if not f then return false end
    if A.done[f] then return true end
    if f._abPanelBD then return true end
    if f._abCustomBD then return true end
    return false
end

function A:SkinPanelButton(btn)
    if not btn or btn._abPanelSkinned then return end
    if not btn.GetObjectType or btn:GetObjectType() ~= "Button" then return end
    btn._abPanelSkinned = true

    pcall(function()
        local n = btn:GetName()
        if n then

            for _, suf in ipairs({"Left", "Middle", "Right",
                                  "LeftDisabled", "MiddleDisabled", "RightDisabled"}) do
                A.kill(_G[n..suf])
            end
        end
        local nt = btn:GetNormalTexture()
        if nt then nt:SetTexture(nil); nt:SetAlpha(0) end
        local dt = btn:GetDisabledTexture()
        if dt then dt:SetTexture(nil); dt:SetAlpha(0) end
        local pt = btn:GetPushedTexture()
        if pt then
            pt:SetTexture(A.FLAT)
            pt:SetVertexColor(A.border[1], A.border[2], A.border[3], 0.30)
            pt:SetAllPoints(btn)
        end
        local h = btn:GetHighlightTexture()
        if h then
            h:SetTexture(A.FLAT)
            h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.16)
            h:SetAllPoints(btn)
        end

        if not A:HasArcaneBackdrop(btn) then
            local sf = CreateFrame("Frame", nil, btn)
            sf:SetFrameLevel(math.max((btn:GetFrameLevel() or 1) - 1, 0))
            sf:EnableMouse(false)
            sf:SetPoint("TOPLEFT",     btn, "TOPLEFT",      1, -1)
            sf:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -1,  1)
            sf:SetBackdrop({
                bgFile = A.TT_BG, edgeFile = A.TT_BD,
                tile = true, tileSize = 16, edgeSize = 10,
                insets = {left = 2, right = 2, top = 2, bottom = 2},
            })
            sf:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.90)
            sf:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.75)
            btn._abPanelBD = sf
        end

        local fs = btn.GetFontString and btn:GetFontString()
        if fs then fs:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
    end)
end

local function isGold(r, g, b)
    if not r then return false end
    return r > 0.85 and g > 0.62 and g < 0.92 and b < 0.30
end

function A:DeGoldText(frame)
    if not frame or not frame.GetNumRegions then return end
    for i = 1, frame:GetNumRegions() do
        local reg = select(i, frame:GetRegions())
        if reg and reg.GetObjectType and reg:GetObjectType() == "FontString" then
            pcall(function()
                local r, g, b = reg:GetTextColor()
                if isGold(r, g, b) then
                    reg:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3])
                end
            end)
        end
    end
end

function A:SkinScrollArrow(btn)
    if not btn or btn._abArrowDone then return end
    btn._abArrowDone = true
    pcall(function()
        local nTex = btn:GetNormalTexture()
        local pTex = btn:GetPushedTexture()
        local dTex = btn:GetDisabledTexture()
        for ri = 1, btn:GetNumRegions() do
            local r = select(ri, btn:GetRegions())
            if r and r.GetObjectType and r:GetObjectType() == "Texture"
               and r ~= nTex and r ~= pTex and r ~= dTex then
                A.kill(r)
            end
        end
        if nTex then nTex:SetVertexColor(A.text[1], A.text[2], A.text[3]) end
        local h = btn:GetHighlightTexture()
        if h then
            h:SetTexture(A.FLAT)
            h:SetVertexColor(A.borderHi[1], A.borderHi[2], A.borderHi[3], 0.18)
            h:SetAllPoints(btn)
        end
    end)
end

function A:KillTexturePath(frame, patterns, depth)
    if not frame or not frame.GetNumRegions then return end
    depth = depth or 0
    if depth > 4 then return end

    for i = 1, frame:GetNumRegions() do
        local r = select(i, frame:GetRegions())
        if r and not r._abKeep and r.GetObjectType and r:GetObjectType() == "Texture" then
            pcall(function()
                local tex = r:GetTexture()
                if type(tex) == "string" then
                    local low = tex:lower()
                    if not low:find("interface\\icons") and not low:find("interface/icons") then
                        for _, p in ipairs(patterns) do
                            if low:find(p, 1, true) then
                                r:SetTexture(nil)
                                r:SetAlpha(0)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end

    if frame.GetNumChildren then
        for i = 1, frame:GetNumChildren() do
            local c = select(i, frame:GetChildren())
            if c then A:KillTexturePath(c, patterns, depth + 1) end
        end
    end
end

function A:KillBigTextures(frame, minSize, depth)
    if not frame or not frame.GetNumRegions then return end
    minSize = minSize or 90
    depth = depth or 0
    if depth > 5 then return end

    local hasBackdrop = false
    pcall(function() hasBackdrop = frame._abSkinFrame or (frame.GetBackdrop and frame:GetBackdrop() ~= nil) end)

    for i = 1, (hasBackdrop and 0 or frame:GetNumRegions()) do
        local r = select(i, frame:GetRegions())
        if r and not r._abKeep and r.GetObjectType and r:GetObjectType() == "Texture" then
            pcall(function()
                local w, h = r:GetWidth() or 0, r:GetHeight() or 0
                if w >= minSize and h >= minSize then
                    local tex = r:GetTexture()
                    local low = type(tex) == "string" and tex:lower() or ""
                    if not low:find("interface\\icons") and not low:find("interface/icons") then
                        r:SetTexture(nil)
                        r:SetAlpha(0)
                    end
                end
            end)
        end
    end

    if frame.GetNumChildren then
        for i = 1, frame:GetNumChildren() do
            local c = select(i, frame:GetChildren())
            if c then A:KillBigTextures(c, minSize, depth + 1) end
        end
    end
end

function A:KillWideTextures(frame, minW, depth)
    if not frame or not frame.GetNumRegions then return end
    minW = minW or 200
    depth = depth or 0
    if depth > 4 then return end
    if frame._abSkinFrame then return end

    for i = 1, frame:GetNumRegions() do
        local r = select(i, frame:GetRegions())
        if r and not r._abKeep and r.GetObjectType and r:GetObjectType() == "Texture" then
            pcall(function()
                local w = r:GetWidth() or 0
                local tex = r:GetTexture()
                local low = type(tex) == "string" and tex:lower() or ""
                if w >= minW and not low:find("interface\\icons")
                   and not low:find("interface/icons") then
                    r:SetTexture(nil)
                    r:SetAlpha(0)
                end
            end)
        end
    end
    if frame.GetNumChildren then
        for i = 1, frame:GetNumChildren() do
            local c = select(i, frame:GetChildren())
            if c then A:KillWideTextures(c, minW, depth + 1) end
        end
    end
end

function A:AddBackPanel(frame, x1, y1, x2, y2)
    if not frame or frame._abBackPanel then return end
    local bp = CreateFrame("Frame", nil, frame)
    bp._abSkinFrame = true
    bp:SetFrameLevel(math.max((frame:GetFrameLevel() or 1) - 1, 0))
    bp:EnableMouse(false)
    bp:SetPoint("TOPLEFT",     frame, "TOPLEFT",     x1 or 0, y1 or 0)
    bp:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", x2 or 0, y2 or 0)
    bp:SetBackdrop({
        bgFile = A.TT_BG, edgeFile = A.TT_BD,
        tile = true, tileSize = 16, edgeSize = 14,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    })
    bp:SetBackdropColor(A.bgDark[1], A.bgDark[2], A.bgDark[3], 1.0)
    bp:SetBackdropBorderColor(A.borderDim[1], A.borderDim[2], A.borderDim[3], 0.75)
    frame._abBackPanel = bp
    return bp
end

function A:WatchClean(frame, fn, interval)
    if not frame or frame._abWatcher then return end
    interval = interval or 0.3

    local w = CreateFrame("Frame", nil, frame)
    w._elapsed = 0
    w:SetScript("OnUpdate", function(self, e)
        self._elapsed = self._elapsed + e
        if self._elapsed < interval then return end
        self._elapsed = 0
        if frame:IsVisible() then
            pcall(fn)
        end
    end)
    frame._abWatcher = w
    pcall(fn)
end

function A:HideBottomTexts(frame, band)
    if not frame or not frame.GetNumRegions then return end
    band = band or 50
    pcall(function()
        local fb = frame:GetBottom()
        if not fb then return end
        for i = 1, frame:GetNumRegions() do
            local r = select(i, frame:GetRegions())
            if r and r.GetObjectType and r:GetObjectType() == "FontString" and r:IsShown() then
                local rb = r:GetBottom()
                if rb and rb <= fb + band then
                    r._abWasShown = true
                    r:Hide()
                end
            end
        end
    end)
end

function A:RestoreBottomTexts(frame)
    if not frame or not frame.GetNumRegions then return end
    pcall(function()
        for i = 1, frame:GetNumRegions() do
            local r = select(i, frame:GetRegions())
            if r and r._abWasShown then
                r._abWasShown = nil
                r:Show()
            end
        end
    end)
end

function A:AddTitleBar(frame, fontString, height)
    if not frame or frame._abTitleBar then return end
    height = height or 22

    local tb = CreateFrame("Frame", nil, frame)
    tb._abSkinFrame = true
    tb:SetFrameLevel(math.max((frame:GetFrameLevel() or 1), 0))
    tb:EnableMouse(false)
    tb:SetHeight(height)
    tb:SetPoint("TOPLEFT",  frame, "TOPLEFT",  12, -6)
    tb:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -6)
    tb:SetBackdrop({
        bgFile = A.TT_BG, edgeFile = A.TT_BD,
        tile = true, tileSize = 16, edgeSize = 12,
        insets = {left = 3, right = 3, top = 3, bottom = 3},
    })
    tb:SetBackdropColor(A.bgMid[1], A.bgMid[2], A.bgMid[3], 0.95)
    tb:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.80)
    frame._abTitleBar = tb

    if fontString then
        pcall(function()
            fontString:ClearAllPoints()
            fontString:SetPoint("CENTER", tb, "CENTER", 0, 0)
            fontString:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3])
            fontString:SetDrawLayer("OVERLAY")
        end)
    end
    return tb
end

local MAX_DEPTH = 5

function A:Polish(frame, depth)
    if not frame or not frame.GetObjectType then return end
    depth = depth or 0
    if depth > MAX_DEPTH then return end

    A:DeGoldText(frame)

    if frame:GetObjectType() == "Button" then
        if isPanelButton(frame) then
            A:SkinPanelButton(frame)
        else
            local n = frame.GetName and frame:GetName()
            if n and (n:find("ScrollUpButton") or n:find("ScrollDownButton")) then
                A:SkinScrollArrow(frame)
            end
        end
    elseif frame:GetObjectType() == "Slider" then

        local n = frame.GetName and frame:GetName()
        if n and n:find("ScrollBar$") then A:SkinScrollBarObj(frame) end
    end

    if frame.GetNumChildren then
        for i = 1, frame:GetNumChildren() do
            local c = select(i, frame:GetChildren())
            if c then A:Polish(c, depth + 1) end
        end
    end
end

function A:HookPolish(frame)
    if not frame or frame._abPolishHooked then return end
    frame._abPolishHooked = true
    A:Polish(frame)
    if frame.HookScript then
        frame:HookScript("OnShow", function(self)
            if self._abPolishCount and self._abPolishCount > 4 then return end
            self._abPolishCount = (self._abPolishCount or 0) + 1
            A:Polish(self)
        end)
    end
end

local POLISH_FRAMES = {
    "CharacterFrame", "SpellBookFrame", "FriendsFrame", "PVPFrame",
    "PVPParentFrame", "PVPBattlegroundFrame", "LFDParentFrame", "LFDQueueFrame",
    "QuestLogFrame", "MerchantFrame", "MailFrame", "OpenMailFrame",
    "BankFrame", "TradeFrame", "GossipFrame", "QuestFrame", "TaxiFrame",
    "HelpFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "GameMenuFrame",
    "WorldMapFrame", "LootFrame", "DressUpFrame", "CompanionFrame",
    "PetStableFrame", "TabardFrame", "PetitionFrame", "ArenaRegistrarFrame",
    "GuildFrame", "RaidFrame", "WhoFrame", "GuildRegistrarFrame",
    "TalentFrame", "PlayerTalentFrame", "GlyphFrame", "AchievementFrame",
    "InspectFrame", "TradeSkillFrame", "AuctionFrame", "MacroFrame",
    "ClassTrainerFrame", "GuildBankFrame", "ItemSocketingFrame",
    "TimeManagerFrame", "CalendarFrame", "BindingFrame", "StaticPopup1",
    "StaticPopup2", "StaticPopup3", "StaticPopup4",
}

function A:PolishAll()
    for _, name in ipairs(POLISH_FRAMES) do
        local f = _G[name]
        if f then A:HookPolish(f) end
    end

    for i = 1, NUM_CONTAINER_FRAMES or 13 do
        local cf = _G["ContainerFrame"..i]
        if cf then A:HookPolish(cf) end
    end
end

local function msg(fmt, ...)
    local ok, s = pcall(string.format, fmt, ...)
    DEFAULT_CHAT_FRAME:AddMessage("|cff40A8FF[ArcaneUI]|r "..(ok and s or fmt))
end

local function inspect(f)
    if not f then msg("frame nulo") return end
    local name = (f.GetName and f:GetName()) or "<anónimo>"
    local otype = (f.GetObjectType and f:GetObjectType()) or "?"
    msg("=== %s (%s) ===", name, otype)

    if f.GetNumRegions then
        for i = 1, f:GetNumRegions() do
            local r = select(i, f:GetRegions())
            if r then
                local rt = r:GetObjectType()
                local rn = (r.GetName and r:GetName()) or "-"
                if rt == "Texture" then
                    local tex = r:GetTexture()
                    msg("  reg %d: %s %s %dx%d a=%.2f tex=%s", i, rt, rn,
                        r:GetWidth() or 0, r:GetHeight() or 0, r:GetAlpha() or 0,
                        tostring(tex))
                else

                    local cr, cg, cb = 0, 0, 0
                    if r.GetTextColor then cr, cg, cb = r:GetTextColor() end
                    msg("  reg %d: %s %s texto=%s color=%.2f,%.2f,%.2f a=%.2f", i, rt, rn,
                        tostring(r.GetText and r:GetText()), cr or 0, cg or 0, cb or 0,
                        r.GetAlpha and r:GetAlpha() or 0)
                end
            end
        end
    end

    if f.GetNumChildren then
        for i = 1, f:GetNumChildren() do
            local c = select(i, f:GetChildren())
            if c then
                msg("  hijo %d: %s %s  backdrop=%s", i,
                    c:GetObjectType(), (c.GetName and c:GetName()) or "<anónimo>",
                    tostring(c.GetBackdrop and c:GetBackdrop() ~= nil))
            end
        end
    end
end

SLASH_ARCANEUI1 = "/aui"
SlashCmdList["ARCANEUI"] = function(arg)
    arg = arg or ""
    local cmd, param = arg:match("^(%S*)%s*(.*)$")
    if cmd == "mouse" then
        inspect(GetMouseFocus())
    elseif cmd == "f" and param ~= "" then
        inspect(_G[param])
    elseif cmd == "parent" then
        local f = GetMouseFocus()
        inspect(f and f.GetParent and f:GetParent())
    else
        msg("uso: /aui mouse  |  /aui parent  |  /aui f <NombreGlobal>")
    end
end
