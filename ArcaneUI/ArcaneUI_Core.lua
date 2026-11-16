ArcaneUI = {}
local A = ArcaneUI

A.bg        = {0.028, 0.048, 0.095, 0.97}
A.bgDark    = {0.015, 0.025, 0.058, 1.00}
A.bgMid     = {0.038, 0.075, 0.148, 0.95}
A.border    = {0.22,  0.52,  0.92,  0.95}
A.borderHi  = {0.32,  0.72,  1.00,  1.00}
A.borderDim = {0.14,  0.32,  0.64,  0.68}
A.accent    = {0.25,  0.66,  1.00}
A.text      = {0.55,  0.80,  1.00}
A.textDim   = {0.30,  0.50,  0.75}
A.textHi    = {0.82,  0.94,  1.00}

A.hp        = {0.10,  0.62,  0.25}
A.hpLow     = {0.75,  0.14,  0.08}
A.mp        = {0.15,  0.44,  0.95}
A.rage      = {0.80,  0.12,  0.08}
A.focus     = {0.88,  0.52,  0.10}
A.energy    = {0.88,  0.80,  0.08}
A.runic     = {0.35,  0.72,  0.92}
A.barBG     = {0.02,  0.03,  0.07,  0.92}

A.powerColor = {
    [0] = A.mp,
    [1] = A.rage,
    [2] = A.focus,
    [3] = A.energy,
    [6] = A.runic,
}

A.FLAT   = "Interface\\Buttons\\WHITE8X8"

A.TT_BG  = "Interface\\Tooltips\\UI-Tooltip-Background"
A.TT_BD  = "Interface\\Tooltips\\UI-Tooltip-Border"

A.done = {}

local LOD = {
    Blizzard_TalentUI        = "SkinTalentFrame",
    Blizzard_GlyphUI         = "SkinGlyphFrame",
    Blizzard_AchievementUI   = "SkinAchievementFrame",
    Blizzard_InspectUI       = "SkinInspectFrame",
    Blizzard_GuildBankUI     = "SkinGuildBankFrame",
    Blizzard_MacroUI         = "SkinMacroFrame",
    Blizzard_BindingUI       = "SkinBindingFrame",
    Blizzard_TrainerUI       = "SkinTrainerFrame",
    Blizzard_TradeSkillUI    = "SkinTradeSkillFrame",
    Blizzard_AuctionUI       = "SkinAuctionFrame",
    Blizzard_BarbershopUI    = "SkinBarbershopFrame",
    Blizzard_ItemSocketingUI = "SkinSocketFrame",
    Blizzard_TimeManager     = "SkinTimeManagerFrame",
    Blizzard_CalendarUI      = "SkinCalendarFrame",
    Blizzard_RaidUI          = "SkinRaidFrame",
    Blizzard_CombatLog       = "SkinCombatLogFrame",
}

local initDone = false
local ef = CreateFrame("Frame")
ef:RegisterEvent("PLAYER_LOGIN")
ef:RegisterEvent("ADDON_LOADED")
ef:RegisterEvent("PLAYER_ENTERING_WORLD")

ef:SetScript("OnEvent", function(self, event, addon)
    if event == "PLAYER_LOGIN" then
        ArcaneUI:Boot()
        initDone = true
    elseif event == "PLAYER_ENTERING_WORLD" then
        if initDone then

            ArcaneUI:SkinUnitFrames()
        end
    elseif event == "ADDON_LOADED" then
        local fn = LOD[addon]
        if fn and ArcaneUI[fn] then
            pcall(ArcaneUI[fn], ArcaneUI)

            pcall(function() ArcaneUI:SkinEquipmentSlots() end)
            pcall(function() ArcaneUI:PolishAll() end)
        end
    end
end)

function A:Boot()
    self:SkinUnitFrames()
    self:SkinActionBars()
    self:SkinMinimap()
    self:SkinChatFrames()
    self:SkinTooltips()
    self:SkinBlizzardFrames()

    pcall(function() self:SkinEquipmentSlots() end)
    pcall(function() self:PolishAll() end)
end
