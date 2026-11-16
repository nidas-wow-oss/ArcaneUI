local A = ArcaneUI

local function applyBD(frame, bgA)
    bgA = bgA or A.bg[4]
    frame:SetBackdrop({
        bgFile   = A.TT_BG,
        edgeFile = A.TT_BD,
        tile = true, tileSize = 16, edgeSize = 16,
        insets = {left=4, right=4, top=4, bottom=4},
    })
    frame:SetBackdropColor(A.bg[1], A.bg[2], A.bg[3], bgA)
    frame:SetBackdropBorderColor(A.border[1], A.border[2], A.border[3], 0.90)
end

function A:SkinPlayerFrame()

end

function A:SkinTargetFrame()

end

function A:SkinFocusFrame()

end

function A:SkinPetFrame()
    if not PetFrame or A.done.pet then return end
    A.done.pet = true

    A.kill(PetFrameTexture)
    if PetFrameHappiness then A.kill(PetFrameHappiness) end

    applyBD(PetFrame, 0.85)

    A:SkinBar(PetFrameHealthBar, A.hp[1], A.hp[2], A.hp[3])
    if PetFrameManaBar then A:SkinBar(PetFrameManaBar, A.mp[1], A.mp[2], A.mp[3]) end
end

function A:SkinPartyFrames()

end

function A:SkinCastingBar()
    if not CastingBarFrame or A.done.castbar then return end
    A.done.castbar = true

    A.kill(CastingBarFrameBorder)
    A.kill(CastingBarFrameFlash)

    for i = 1, CastingBarFrame:GetNumRegions() do
        local r = select(i, CastingBarFrame:GetRegions())
        if r and r.GetObjectType and r:GetObjectType() == "Texture" then
            local tex = r:GetTexture()
            if tex and not tex:find("Spark") then A.kill(r) end
        end
    end

    applyBD(CastingBarFrame, 0.90)
    A:SkinBar(CastingBarFrame, A.accent[1], A.accent[2], A.accent[3])

    if CastingBarFrameText      then CastingBarFrameText:SetTextColor(A.textHi[1], A.textHi[2], A.textHi[3]) end
    if CastingBarFrameSpellText then CastingBarFrameSpellText:SetTextColor(A.text[1], A.text[2], A.text[3]) end

    if PetCastingBarFrame then
        A.kill(PetCastingBarFrameBorder)
        applyBD(PetCastingBarFrame, 0.85)
        A:SkinBar(PetCastingBarFrame, A.accent[1], A.accent[2]*0.7, A.accent[3]*0.5)
    end
end

function A:SkinBossFrames()
    for i = 1, 4 do
        local bf = _G["Boss"..i.."TargetFrame"]
        if bf and not A.done["boss"..i] then
            A.done["boss"..i] = true
            A.kill(_G["Boss"..i.."TargetFrameTexture"])
            applyBD(bf, 0.85)
            local hb = _G["Boss"..i.."TargetFrameHealthBar"]
            local mb = _G["Boss"..i.."TargetFrameManaBar"]
            if hb then A:SkinBar(hb, A.hp[1], A.hp[2], A.hp[3]) end
            if mb then A:SkinBar(mb, A.mp[1], A.mp[2], A.mp[3]) end
            A:RecolorText(bf, A.text[1], A.text[2], A.text[3])
        end
    end
end

function A:SkinMirrorTimers()
    for i = 1, MIRRORTIMER_NUMTIMERS or 3 do
        local mt  = _G["MirrorTimer"..i]
        local mts = _G["MirrorTimer"..i.."StatusBar"]
        if mt  then
            A.kill(_G["MirrorTimer"..i.."Border"])
            applyBD(mt, 0.88)
        end
        if mts then A:SkinBar(mts, A.accent[1], A.accent[2], A.accent[3]) end
    end
end

function A:SkinUnitFrames()
    self:SkinPlayerFrame()
    self:SkinTargetFrame()
    self:SkinFocusFrame()
    self:SkinPetFrame()
    self:SkinPartyFrames()
    self:SkinBossFrames()
    self:SkinCastingBar()
    self:SkinMirrorTimers()
end
