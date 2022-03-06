local uwu = uwu or {}

uwu.KillCounter = CreateClientConVar("nstatszs_killcounter", "0", true, false):GetBool()
cvars.AddChangeCallback("nstatszs_killcounter", function(cvar, oldvalue, newvalue)
	uwu.KillCounter = tonumber(newvalue) == 1
end)

-- Colors, NOT NEEDED RN!
--[[uwu.ShopColor = Color(CreateClientConVar("specshop_color_r", "30", true, false):GetInt(), CreateClientConVar("specshop_color_g", "30", true, false):GetInt(), CreateClientConVar("specshop_color_b", "30", true, false):GetInt())
cvars.AddChangeCallback("specshop_color_r", function(cvar, oldvalue, newvalue) SPECSHOP.ShopColor.r = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("specshop_color_g", function(cvar, oldvalue, newvalue) SPECSHOP.ShopColor.g = tonumber(newvalue) or 255 end)
cvars.AddChangeCallback("specshop_color_b", function(cvar, oldvalue, newvalue) SPECSHOP.ShopColor.b = tonumber(newvalue) or 255 end)]]

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

    local function nightrally(parent)
        local check = vgui.Create("DLabel", frame)
        check:SetText(plyr:Name().."'s Stats ")
        check:SetFont("ZSHUDFontSmall")
        check:SizeToContents()
        check:SetTextColor(COLOR_CYAN)
        parent:AddItem(check)
    end

    local frame = vgui.Create("DFrame")
    frame:SetSize(500 * s, 500 * s)
    frame:SetTitle("nStats ZS | Personal Statistics - "..(nStatsZS.NoxZS and "NOX Build" or "OLD Build"))
    frame:SetDraggable(false)
    frame:Center()
    frame:MakePopup()

    local sheet = vgui.Create( "DPropertySheet", frame )
    sheet:Dock( FILL )

    local panel1 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Human Stats", panel1, "icon16/user.png" )

    local panel2 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Zombie Stats", panel2, "icon16/user_red.png" )

    local panel3
    if nStatsZS.NoxZS then
        panel3 = vgui.Create( "DPanel", sheet )
        sheet:AddSheet( "ZS Stats", panel3, "icon16/user_orange.png" )
    else
        panel3 = nil
    end

    local panel4 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Player List", panel4, "icon16/group.png" )

    local panel5 = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Settings", panel5, "icon16/cog.png" )

    local wide = frame:GetWide()
    local tall = frame:GetTall()

    local list1 = vgui.Create("DPanelList", panel1) list1:EnableVerticalScrollbar() list1:EnableHorizontal(false) list1:SetSize(wide - 12, tall - 12) list1:SetPos(0, 0) list1:SetPadding(8) list1:SetSpacing(16)
    local list2 = vgui.Create("DPanelList", panel2) list2:EnableVerticalScrollbar() list2:EnableHorizontal(false) list2:SetSize(wide - 12, tall - 12) list2:SetPos(0, 0) list2:SetPadding(8) list2:SetSpacing(16)
    local list3 = vgui.Create("DPanelList", panel3) list3:EnableVerticalScrollbar() list3:EnableHorizontal(false) list3:SetSize(wide - 12, tall - 12) list3:SetPos(0, 0) list3:SetPadding(8) list3:SetSpacing(16)
    local list4 = vgui.Create("DPanelList", panel4) list4:EnableVerticalScrollbar() list4:EnableHorizontal(false) list4:SetSize(wide - 12, tall - 70) list4:SetPos(0, 0)
    local list5 = vgui.Create("DPanelList", panel5) list5:EnableVerticalScrollbar() list5:EnableHorizontal(false) list5:SetSize(wide - 12, tall - 12) list5:SetPos(0, 0) list5:SetPadding(8) list5:SetSpacing(16)
    
    -----------------
    -- HUMAN STATS --
    -----------------

    local function HumanStat(name, id)
        local check = vgui.Create("DLabel", frame)
        check:SetText(name..": "..tostring(string.CommaSeparate(math.floor(plyr:GetNWInt(id)))))
        check:SetFont("ZSHUDFontSmaller")
        check:SizeToContents()
        list1:AddItem(check)
    end

    nightrally(list1)

    HumanStat("Zombies Killed", "HStats.ZombiesKilled")
    HumanStat("Zombies Killed Assists", "HStats.ZombiesKilledAssists")
    if nStatsZS.NoxZS then
        HumanStat("Zombies Killed Headshots", "HStats.ZombiesKilledHeadshot")
    end
    HumanStat("Crows Killed", "HStats.CrowsKilled")
    HumanStat("Barricade Repair Points", "HStats.BarricadeRepairPoints")
    HumanStat("Damage To Zombies", "HStats.DamageToZombies")

    ------------------
    -- ZOMBIE STATS --
    ------------------

    local function ZombieStat(name, id)
        local check = vgui.Create("DLabel", frame)
        check:SetText(name..": "..tostring(string.CommaSeparate(math.floor(plyr:GetNWInt(id)))))
        check:SetFont("ZSHUDFontSmaller")
        check:SizeToContents()
        list2:AddItem(check)
    end
    
    nightrally(list2)

    ZombieStat("Humans Killed", "ZStats.HumansKilled")
    ZombieStat("Barricade Damage", "ZStats.BarricadeDamage")
    ZombieStat("Damage To Humans", "ZStats.DamageToHumans")

    --------------
    -- ZS STATS --
    --------------

    if nStatsZS.NoxZS then
        local check = vgui.Create("DLabel", frame) check:SetText(plyr:Name().."'s Stats ") check:SetFont("ZSHUDFontSmall") check:SizeToContents() check:SetTextColor(COLOR_CYAN) list3:AddItem(check)

        nightrally(list3)

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
            Derma_Query("View "..v:Name().."'s personal statistics?", "", "Yes", function() frame:Close() nStatsZSClient(v) end, "No")
        end
        list4:AddItem(button)
    end

    --------------
    -- SETTINGS --
    --------------

    local function CheckBox(text, cvar)
        local check = panel5:Add( "DCheckBoxLabel" )
        check:SetText(text)
        check:SetFont(checkfont)
        check:SetConVar(cvar)
        check:SizeToContents()
        list5:AddItem(check)
    end

    CheckBox("Enable kill counter", "nstatszs_killcounter")
end

net.Receive("ShowStatsRequest", function()
    local plyr = net.ReadEntity()
    
    nStatsZSClient(plyr)
end)
