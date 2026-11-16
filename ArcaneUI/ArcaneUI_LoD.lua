local A = ArcaneUI

function A:SkinGuildBankFrame()
    if not GuildBankFrame or A.done.guildBank then return end
    A.done.guildBank = true
    A:SkinStdBlizzFrame(GuildBankFrame)
    A:SkinFrameTabs(GuildBankFrame)

    if GuildBankListScrollFrame then A:KillTextures(GuildBankListScrollFrame) end
    if GuildBankLogScrollFrame  then A:KillTextures(GuildBankLogScrollFrame)  end
    A:SkinScrollBar(GuildBankListScrollFrame)
    A:SkinScrollBar(GuildBankLogScrollFrame)
    A:RecolorText(GuildBankFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinMacroFrame()
    if not MacroFrame or A.done.macro then return end
    A.done.macro = true
    A:SkinStdBlizzFrame(MacroFrame)
    A:SkinFrameTabs(MacroFrame)
    A:SkinEditBox(MacroEditBox)
    A:SkinScrollBar(MacroFrameScrollFrame)
    A.kill(MacroFrameTextBackground)
    A:SkinButton(MacroDeleteButton)
    A:SkinButton(MacroSaveButton)
    A:SkinButton(MacroNewButton)
    A:RecolorText(MacroFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinBindingFrame()
    if not KeyBindingFrame or A.done.binding then return end
    A.done.binding = true
    A:SkinStdBlizzFrame(KeyBindingFrame)
    if KeyBindingFrameScrollFrame then
        A:KillTextures(KeyBindingFrameScrollFrame)
        local sc = KeyBindingFrameScrollFrame.GetScrollChild and KeyBindingFrameScrollFrame:GetScrollChild()
        if sc then A:KillTextures(sc) end
    end
    A:SkinScrollBar(KeyBindingFrameScrollFrame)
    A:RecolorText(KeyBindingFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinTrainerFrame()
    if not ClassTrainerFrame or A.done.trainer then return end
    A.done.trainer = true
    A:SkinStdBlizzFrame(ClassTrainerFrame, 10, -11, -32, 74)

    for _, sf in ipairs({ClassTrainerListScrollFrame, ClassTrainerDetailScrollFrame}) do
        if sf then
            A:KillTextures(sf)
            local sc = sf.GetScrollChild and sf:GetScrollChild()
            if sc then A:KillTextures(sc) end
        end
    end
    A:SkinScrollBar(ClassTrainerListScrollFrame)
    A:SkinScrollBar(ClassTrainerDetailScrollFrame)
    A:SkinDropDown(ClassTrainerFrameFilterDropDown)
    A:SkinButton(ClassTrainerCollapseAllButton)
    for i = 1, CLASS_TRAINER_SKILLS_DISPLAYED or 12 do
        A:SkinButton(_G["ClassTrainerSkill"..i])
    end
    A:RecolorText(ClassTrainerFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinTradeSkillFrame()
    if not TradeSkillFrame or A.done.tradeskill then return end
    A.done.tradeskill = true
    A:SkinStdBlizzFrame(TradeSkillFrame, 10, -11, -32, 71)

    for _, sf in ipairs({TradeSkillListScrollFrame, TradeSkillDetailScrollFrame}) do
        if sf then
            A:KillTextures(sf)
            local sc = sf.GetScrollChild and sf:GetScrollChild()
            if sc then A:KillTextures(sc) end
        end
    end
    A:SkinScrollBar(TradeSkillListScrollFrame)
    A:SkinScrollBar(TradeSkillDetailScrollFrame)
    A:SkinDropDown(TradeSkillFrameFilterDropDown)
    A:SkinEditBox(TradeSkillInputBox)
    A:RecolorText(TradeSkillFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinAuctionFrame()
    if not AuctionFrame or A.done.auction then return end
    A.done.auction = true
    A:SkinStdBlizzFrame(AuctionFrame)
    A:SkinFrameTabs(AuctionFrame)

    for _, sf in ipairs({BrowseScrollFrame, BidScrollFrame, AuctionsScrollFrame}) do
        if sf then
            A:KillTextures(sf)
            local sc = sf.GetScrollChild and sf:GetScrollChild()
            if sc then A:KillTextures(sc) end
        end
    end
    A:SkinScrollBar(BrowseScrollFrame)
    A:SkinScrollBar(BidScrollFrame)
    A:SkinScrollBar(AuctionsScrollFrame)
    A:SkinEditBox(BrowseName)
    A:SkinEditBox(StartPrice)
    A:SkinEditBox(BuyoutPrice)
    A:RecolorText(AuctionFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinBarbershopFrame()
    if not BarberShopFrame or A.done.barber then return end
    A.done.barber = true
    A:SkinStdBlizzFrame(BarberShopFrame, 35, -32, -32, 42)
    if BarberShopBannerFrame then A:KillTextures(BarberShopBannerFrame) end
    A:RecolorText(BarberShopFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinSocketFrame()
    if not ItemSocketingFrame or A.done.socket then return end
    A.done.socket = true
    A:SkinStdBlizzFrame(ItemSocketingFrame)
    A:RecolorText(ItemSocketingFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinTimeManagerFrame()
    if not TimeManagerFrame or A.done.timemgr then return end
    A.done.timemgr = true
    A:KillTextures(TimeManagerFrame)
    A:AddSkinFrame(TimeManagerFrame, 4, -4, -4, 4)
end

function A:SkinCalendarFrame()
    if not CalendarFrame or A.done.calendar then return end
    A.done.calendar = true
    A:SkinStdBlizzFrame(CalendarFrame)
    A:RecolorText(CalendarFrame, A.text[1], A.text[2], A.text[3])
end

function A:SkinRaidFrame()
    if not RaidFrame or A.done.raid then return end
    A.done.raid = true

    A:KillTextures(RaidFrame)

    for i = 1, 8 do
        local grp = _G["RaidGroup"..i]
        if grp then
            A:KillTextures(grp)

            A:AddSubSkinFrame(grp)
        end
    end

    for i = 1, 40 do
        local btn = _G["RaidGroupButton"..i]
        if btn then
            A:KillTextures(btn)
        end
    end

    A:AddSkinFrame(RaidFrame, 4, -4, -4, 4)

    A:RecolorText(RaidFrame, A.textHi[1], A.textHi[2], A.textHi[3])

    A:SkinButton(_G["RaidFrameReadyCheckButton"])
    A:SkinButton(_G["RaidFrameRaidInfoButton"])
end

function A:SkinCombatLogFrame()
    if not CombatLogFrame or A.done.combatLog then return end
    A.done.combatLog = true
    A:KillTextures(CombatLogFrame)
    A:AddSkinFrame(CombatLogFrame, 4, -4, -4, 4)
end
