function nStatsZSClient(plyr)
    local s = BetterScreenScale()

    -- fix nil values if the plyr argument is missing
    if not plyr then
        plyr = LocalPlayer()
    elseif not plyr:IsPlayer() then
        plyr = LocalPlayer()
    end

    -- The code above was actually used to fix a bug if there was no player argument.
    -- It was used to fix the nil problem with the Stats being in the ZS f1 menu.
    -- Obviously it isn't needed now, but we will keep it in anyway.
    
    printClear("[nStats ZS] Currently viewing: "..tostring(plyr:Name()))

    local frame = vgui.Create("DFrame")
    frame:SetSize(500 * s, 500 * s)
    frame:SetTitle("nStats ZS | Personal Statistics - "..nStats.ZS.NoxZS and "NOX Build" or "OLD Build")
    frame:SetDraggable(false)
    frame:Center()
    frame:MakePopup()

    local sheet = vgui.Create( "DPropertySheet", frame )
    sheet:Dock( FILL )

    local panel1 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Human Stats", panel1, "icon16/user.png" )

    local panel2 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Zombie Stats", panel2, "icon16/user_red.png" )

    if nStats.ZS.NoxZS then
        local panel3 = vgui.Create( "DPanel", sheet )
        sheet:AddSheet( "ZS Stats", panel3, "icon16/user_orange.png" )
    end

    local panel4 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Player List", panel4, "icon16/group.png" )

    local panel5 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Admin Panel", panel5, "icon16/shield.png" )

    local wide = frame:GetWide()
    local tall = frame:GetTall()

    local list1 = vgui.Create("DPanelList", panel1) list1:EnableVerticalScrollbar() list1:EnableHorizontal(false) list1:SetSize(wide - 12, tall - 12) list1:SetPos(0, 0) list1:SetPadding(8) list1:SetSpacing(16)
    local list2 = vgui.Create("DPanelList", panel2) list2:EnableVerticalScrollbar() list2:EnableHorizontal(false) list2:SetSize(wide - 12, tall - 12) list2:SetPos(0, 0) list2:SetPadding(8) list2:SetSpacing(16)
    if nStats.ZS.NoxZS then
        local list3 = vgui.Create("DPanelList", panel3) list3:EnableVerticalScrollbar() list3:EnableHorizontal(false) list3:SetSize(wide - 12, tall - 12) list3:SetPos(0, 0) list3:SetPadding(8) list3:SetSpacing(16)
    end
    local list4 = vgui.Create("DPanelList", panel4) list4:EnableVerticalScrollbar() list4:EnableHorizontal(false) list4:SetSize(wide - 12, tall - 70) list4:SetPos(0, 0)
    -----------------
    -- HUMAN STATS --
    -----------------

    local function HumanStat(name, id) local check = vgui.Create("DLabel", frame) check:SetText(name..": "..tostring(string.CommaSeparate(math.floor(plyr:GetNWInt(id))))) check:SetFont("ZSHUDFontSmaller") check:SizeToContents() list1:AddItem(check) end
    local check = vgui.Create("DLabel", frame) check:SetText(plyr:Name().."'s Stats ") check:SetFont("ZSHUDFontSmall") check:SizeToContents() check:SetTextColor(COLOR_CYAN) list1:AddItem(check)

    HumanStat("Zombies Killed", "HStats.ZombiesKilled")
    HumanStat("Zombies Killed Assists", "HStats.ZombiesKilledAssists")
    if nStats.ZS.NoxZS then
        HumanStat("Zombies Killed Headshots", "HStats.ZombiesKilledHeadshot")
    end
    HumanStat("Crows Killed", "HStats.CrowsKilled")
    HumanStat("Barricade Repair Points", "HStats.BarricadeRepairPoints")
    HumanStat("Damage To Zombies", "HStats.DamageToZombies")

    ------------------
    -- ZOMBIE STATS --
    ------------------

    local function ZombieStat(name, id) local check = vgui.Create("DLabel", frame) check:SetText(name..": "..tostring(string.CommaSeparate(math.floor(plyr:GetNWInt(id))))) check:SetFont("ZSHUDFontSmaller") check:SizeToContents() list2:AddItem(check) end
    local check = vgui.Create("DLabel", frame) check:SetText(plyr:Name().."'s Stats ") check:SetFont("ZSHUDFontSmall") check:SizeToContents() check:SetTextColor(COLOR_CYAN) list2:AddItem(check)

    ZombieStat("Humans Killed", "ZStats.HumansKilled")
    ZombieStat("Barricade Damage", "ZStats.BarricadeDamage")
    ZombieStat("Damage To Humans", "ZStats.DamageToHumans")

    --------------
    -- ZS STATS --
    --------------

    if nStats.ZS.NoxZS then
        local check = vgui.Create("DLabel", frame) check:SetText(plyr:Name().."'s Stats ") check:SetFont("ZSHUDFontSmall") check:SizeToContents() check:SetTextColor(COLOR_CYAN) list3:AddItem(check)

        local check = vgui.Create("DLabel", frame)
        check:SetText("Level: "..plyr:GetZSLevel())
        check:SetFont("ZSHUDFontSmaller")
        check:SizeToContents()
        list3:AddItem(check)

        local check = vgui.Create("DLabel", frame)
        check:SetText("Remort: "..string.CommaSeparate(plyr:GetZSRemortLevel()))
        check:SetFont("ZSHUDFontSmaller")
        check:SizeToContents()
        list3:AddItem(check)

        local check = vgui.Create("DLabel", frame)
        check:SetText("XP: "..string.CommaSeparate(plyr:GetZSXP()).." / "..string.CommaSeparate(GAMEMODE:XPForLevel(plyr:GetZSLevel() + 1)))
        check:SetFont("ZSHUDFontSmaller")
        check:SizeToContents()
        list3:AddItem(check)
    end

    -----------------
    -- PLAYER LIST --
    -----------------

    for _, v in pairs(player.GetHumans()) do
        local button = vgui.Create("DButton", frame)
        button:SetText(v:Name())
        button:SetFont("ZSHUDFontSmall")
        button:SizeToContents()
        button:Dock(TOP)
        button.DoClick = function()
            Derma_Query("View "..v:Name().."'s personal statistics?", "", "Yes", function() frame:Close() nStatsClient(v) end, "No")
        end
        list4:AddItem(button)
    end
end

net.Receive("ShowStatsRequest", function()
    local plyr = net.ReadEntity()
    
    nStatsZSClient(plyr)
end)
