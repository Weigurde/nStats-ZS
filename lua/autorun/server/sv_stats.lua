local meta = FindMetaTable("Player")

function meta:UpdateStat(id, num)
    self:SetNWInt(id, self:GetNWInt(id) + (num or 1))
end

function SaveStatistics(pl)
    if not IsValid(pl) or pl:IsBot() then return end

    local function Stat(name)
        pl:SetPData(name, pl:GetNWInt(name))
    end

    Stat("HStats.ZombiesKilled")
    Stat("HStats.ZombiesKilledAssists")
    Stat("HStats.ZombiesKilledHeadshot")
    Stat("HStats.CrowsKilled")
    Stat("HStats.BarricadeRepairPoints")
    Stat("HStats.DamageToZombies")

    Stat("ZStats.HumansKilled")
    Stat("ZStats.BarricadeDamage")
    Stat("ZStats.DamageToHumans")
end

function LoadStatistics(pl)
    if not IsValid(pl) or pl:IsBot() then return end

    local function Stat(name)
        pl:SetNWInt(name, pl:GetPData(name, 0))
    end

    Stat("HStats.ZombiesKilled")
    Stat("HStats.ZombiesKilledAssists")
    Stat("HStats.ZombiesKilledHeadshot")
    Stat("HStats.CrowsKilled")
    Stat("HStats.BarricadeRepairPoints")
    Stat("HStats.DamageToZombies")

    Stat("ZStats.HumansKilled")
    Stat("ZStats.BarricadeDamage")
    Stat("ZStats.DamageToHumans")
end


------------------
-- SAVING STATS --
------------------

hook.Add("PlayerAuthed", "Stats.PlayerAuthed", LoadStatistics)
hook.Add("PlayerInitialSpawnRound", "Stats.PlayerInitialSpawnRound", LoadStatistics)
hook.Add("PlayerDisconnected", "Stats.PlayerDisconnected", SaveStatistics)

hook.Add("EndRound", "Stats.EndRound", function(winner)
    for _, pl in pairs(player.GetHumans()) do
        SaveStatistics(pl)
	end	
end)

-----------------
-- HUMAN STATS --
-----------------

hook.Add("HumanKilledZombie", "Stats.HumanKilledZombie", function(pl, attacker, inflictor, dmginfo, headshot, suicide)
	if (pl:GetZombieClassTable().Points or 0) == 0 or GAMEMODE.RoundEnded then
        if pl:GetZombieClassTable().Name == "Crow" then
            attacker:UpdateStat("HStats.CrowsKilled")
        end
        return
    end

	attacker:UpdateStat("HStats.ZombiesKilled")

    -- Temp fix
    if nStats.ZS.NoxZS then
        if pl:WasHitInHead() then
            attacker:UpdateStat("HStats.ZombiesKilledHeadshot")
        end
    end
end)

hook.Add("PostHumanKilledZombie", "Stats.PostHumanKilledZombie", function(pl, attacker, inflictor, dmginfo, assistpl, assistamount, headshot)
    if IsValid(assistpl) then
	    assistpl:UpdateStat("HStats.ZombiesKilledAssists")
    end
end)

hook.Add("PlayerRepairedObject", "Stats.PlayerRepairedObject", function(pl, other, health, wep)
	if GAMEMODE:GetWave() == 0 or health <= 0 then return end

	pl:UpdateStat("HStats.BarricadeRepairPoints", health)
end)

------------------
-- ZOMBIE STATS --
------------------

hook.Add("ZombieKilledHuman", "Stats.ZombieKilledHuman", function(pl, attacker, inflictor, dmginfo, headshot, suicide)
	if GAMEMODE.RoundEnded then return end

	attacker:UpdateStat("ZStats.HumansKilled")
end)

hook.Add("OnNailDamaged", "ZStats.OnNailDamaged", function(attacker, inflictor, damage, dmginfo)
    attacker:UpdateStat("ZStats.BarricadeDamage", damage)
end)

--------------------------
-- ZOMBIE & HUMAN STATS --
--------------------------

hook.Add("PostEntityTakeDamage", "Stats.PostEntityTakeDamage", function(ent, dmgInfo, took)
    local attacker = dmgInfo:GetAttacker()
    local damage = dmgInfo:GetDamage()

    if not ent:IsPlayer() or not attacker:IsPlayer() or GAMEMODE.RoundEnded then return end

    if ent:Team() == TEAM_UNDEAD then
        attacker:UpdateStat("HStats.DamageToZombies", damage)
    elseif ent:Team() == TEAM_HUMAN then
        attacker:UpdateStat("ZStats.DamageToHumans", damage)
    end
end)