-- Rx Karthus Version 0.3 by Rudo.
-- Updated Karthus for Inspired Ver28 and IOW
-- Go to http://gamingonsteroids.com   To Download more script.
-- Thanks Deftsu for some Code <3  . Thank Cloud for Karthus Plugin. ^.^
----------------------------------------------------
if GetObjectName(myHero) ~= "Karthus" then return end
PrintChat(string.format("<font color='#FF0000'>Rx Karthus by Rudo </font><font color='#FFFF00'>Version 0.3 Loaded Success </font><font color='#08F7F3'>Enjoy it and Good Luck :3</font>")) 
---- Create a Menu ----
Karthus = Menu("Rx Karthus", "Karthus")

---- Combo ----
Karthus:SubMenu("cb", "Karthus Combo")
Karthus.cb:Boolean("QCB", "Use Q", true)
Karthus.cb:Boolean("WCB", "Use W", true)
Karthus.cb:Boolean("ECB", "Use E", true)

---- Harass Menu ----
Karthus:SubMenu("hr", "Harass")
Karthus.hr:Boolean("HrQ", "Use Q", true)
Karthus.hr:Slider("HrMana", "Enable Harass if My %MP >", 30, 0, 100, 0)

---- Lane Clear Menu ----
Karthus:SubMenu("FreezeLane", "Lane Clear")
Karthus.FreezeLane:Boolean("WLC", "Use Q LaneClear", true)
Karthus.FreezeLane:Boolean("ELC", "Use E LaneClear", true)
Karthus.FreezeLane:Slider("LCMana", "Enable LaneClear if My %MP >", 30, 0, 100, 0)

---- Last Hit Menu ----
Karthus:SubMenu("LHMinion", "Last Hit Minion")
Karthus.LHMinion:Boolean("QLH", "Use Q Last Hit", true)
Karthus.LHMinion:Slider("LHMana", "Enable LastHit if %My MP >", 30, 0, 100, 0)

---- Jungle Clear Menu ----
Karthus:SubMenu("JungleClear", "Jungle Clear")
Karthus.JungleClear:Boolean("QJC", "Use Q LaneClear", true)
Karthus.JungleClear:Boolean("EJC", "Use E LaneClear", true)

---- Kill Steal Menu ----
Karthus:SubMenu("KS", "Kill Steal")
Karthus.KS:Boolean("KSEb", "Enable KillSteal", true)
Karthus.KS:Boolean("QKS", "KS with Q", true)
Karthus.KS:Boolean("IgniteKS", "KS with Ignite", true)

---- Draw Enemy can KS with R Menu ----
Karthus:SubMenu("InfoR", "Draw Enemy can KS with R")
Karthus.InfoR:Info("infoR1", "If you can see Enemy can KS with R")
Karthus.InfoR:Info("infoR2", "Press R to Killable enemy")
Karthus.InfoR:Boolean("EninfoR", "Enable Draw Enemy can KS with R", true)

---- Drawings Menu ----
Karthus:SubMenu("Draws", "Drawings")
Karthus.Draws:Boolean("DrawsEb", "Enable Drawings", true)
Karthus.Draws:Boolean("DrawQ", "Range Q", true)
Karthus.Draws:Boolean("DrawW", "Range W", true)
Karthus.Draws:Boolean("DrawE", "Range E", true)
Karthus.Draws:Boolean("DrawR", "Range R", true)
Karthus.Draws:Boolean("DrawText", "Draw Text", true)

---- Misc Menu ----
Karthus:SubMenu("Miscset", "Misc")
Karthus.Miscset:Boolean("AutoSkillUpQ", "Auto Lvl Up Q", true)  

---- Use Items Menu ----
Karthus:SubMenu("Items", "Auto Use Items")
Karthus.Items:SubMenu("PotionHP", "Use Potion HP")
Karthus.Items.PotionHP:Boolean("PotHP", "Enable Use Potion HP", true)
Karthus.Items.PotionHP:Slider("CheckHP", "Auto Use if %HP <", 50, 3, 80, 1)
Karthus.Items:SubMenu("PotionMP", "Use Potion MP")
Karthus.Items.PotionMP:Boolean("PotMP", "Enable Use Potion MP", true)
Karthus.Items.PotionMP:Slider("CheckMP", "Auto Use if %MP <", 45, 3, 80, 1)
Karthus.Items:SubMenu("ChUZhonya", "Use Zhonya")
Karthus.Items.ChUZhonya:Boolean("UseZhonya", "Enable Use Zhonya", true)
Karthus.Items.ChUZhonya:Slider("CheckZhoHP", "Auto Use if %HP <", 15, 3, 99, 1)

---------- End Menu ----------

-------------------------------------------------------Starting--------------------------------------------------------------
require('Inspired')
require('IOW')

local BonusAP = GetBonusAP(myHero)
local CheckQDmg = (GetCastLevel(myHero, _Q)*20) + 20 + (0.30*BonusAP)
local CheckEDmg = (GetCastLevel(myHero, _E)*20) + 10 + (0.20*BonusAP)
local CheckRDmg = (GetCastLevel(myHero, _R)*150) + 100 + (0.60*BonusAP)


OnLoop(function(myHero)
	------ Start Combo ------
    if IOW:Mode() == "Combo" then
		local target = GetCurrentTarget()
		
		if CanUseSpell(myHero,_W) == READY and GoS:ValidTarget(target, 900) and Karthus.cb.WCB:Value() then
		CastTargetSpell(myHero, _W)
		end
		
	   local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,900,GetCastRange(myHero,_Q),100,false,true)
	    if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) and QPred.HitChance == 1 and Karthus.cb.QCB:Value() then
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end		
		
		if CanUseSpell(myHero,_E) == READY and GoS:IsInDistance(target, GetCastRange(myHero,_E)) and GotBuff(myHero, "KarthusDefile") <= 0 and Karthus.cb.ECB:Value() then
		CastTargetSpell(myHero, _E)
	    end

		if Karthus.cb.ECB:Value() and not GoS:IsInDistance(target, GetCastRange(myHero,_E)) and GotBuff(myHero, "KarthusDefile") > 0 then
		CastTargetSpell(myHero, _E)
		end
		
	end
	
	------ Start Harass ------
    if IOW:Mode() == "Harass" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= Karthus.hr.HrMana:Value() then
		local target = GetCurrentTarget()			
			
	   local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,900,GetCastRange(myHero,_Q),100,false,true)
	    if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, GetCastRange(myHero,_Q)) and QPred.HitChance == 1 and Karthus.cb.QCB:Value() then
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end
	
	------ Start LaneClear ------
   if IOW:Mode() == "LaneClear" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= Karthus.FreezeLane.LCMana:Value() then
	for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
                        -- if GoS:IsInDistance(minion, 1500) then
		local minionPoS = GetOrigin(minion)
		
		if CanUseSpell(myHero,_Q) == READY and Karthus.FreezeLane.WLC:Value() and GoS:ValidTarget(minion, GetCastRange(myHero,_Q)) then
		CastSkillShot(_Q,minionPoS.x, minionPoS.y, minionPoS.z)	
		end
		
		if CanUseSpell(myHero,_E) == READY and GoS:IsInDistance(minion, GetCastRange(myHero,_E)) and GotBuff(myHero, "KarthusDefile") <= 0 and Karthus.FreezeLane.ELC:Value() then
		CastSkillShot(_E,minionPoS.x, minionPoS.y, minionPoS.z)	
	    end
		if Karthus.FreezeLane.ELC:Value() and not GoS:IsInDistance(minion, GetCastRange(myHero,_E)) and GotBuff(myHero, "KarthusDefile") > 0 then
        CastSkillShot(_E,minionPoS.x, minionPoS.y, minionPoS.z)	
		end
		
	end
   end 

	------ Start JungleClear ------  
   if IOW:Mode() == "LaneClear" then
    for _,mob in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do	
		local mobPoS = GetOrigin(mob)
		
		if CanUseSpell(myHero,Q) == READY and Karthus.JungleClear.QJC:Value() and GoS:ValidTarget(mob, GetCastRange(myHero,_Q)) then
		CastSkillShot(_Q,mobPoS.x, mobPoS.y, mobPoS.z)	
		end
		
		if CanUseSpell(myHero,_E) == READY and GoS:IsInDistance(mob, GetCastRange(myHero,_E)) and GotBuff(myHero,"KarthusDefile") <= 0 and Karthus.JungleClear.EJC:Value() then
		CastSkillShot(_E,mobPoS.x, mobPoS.y, mobPoS.z)	
	    end
		if  Karthus.JungleClear.EJC:Value() and not GoS:IsInDistance(mob, GetCastRange(myHero,_E)) and GotBuff(myHero,"KarthusDefile") > 0 then
        CastSkillShot(_E,mobPoS.x, mobPoS.y, mobPoS.z)	
		end
		
	end
   end
	------ Start LastHit ------
   if IOW:Mode() == "LastHit" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= Karthus.LHMinion.LHMana:Value() then
	for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
		local minionPoS = GetOrigin(minion)
                        if GoS:IsInDistance(minion, 875) and Karthus.LHMinion.QLH:Value() then
			local hpMinions = GetCurrentHP(minion)
			local CheckKillMinions = GoS:CalcDamage(myHero, minion, 0, CheckQDmg)	
		if CheckKillMinions > hpMinions then
		if CanUseSpell(myHero,Q) == READY and GoS:IsInDistance(minion, 875) then
		CastSkillShot(_Q,minionPoS.x, minionPoS.y, minionPoS.z)
		end
		end
                        end
	end
   end
	
  if Karthus.KS.KSEb:Value() then
	KillSteal()
	end
	
  if Karthus.Draws.DrawsEb:Value() then
	Drawings()
	end
	
  if Karthus.Miscset.AutoSkillUpQ:Value() then --- Menu Full Q First
	AutoLvlUpQ()
	end
	
  if Karthus.Items.PotionHP.PotHP:Value() then --- Menu Auto PotionHP
	AutoPotHP()
	end
	
  if Karthus.Items.PotionMP.PotMP:Value() then --- Menu Auto PotionMP
	AutoPotMP()
	end
  if Karthus.Items.ChUZhonya.UseZhonya:Value() then --- Menu Auto Zhonya
	AutoZhonya()
	end
  if Karthus.InfoR.EninfoR:Value() then
	RKillableInfo()
	end 
	
end)

------------------------------------------------------- Start Function -------------------------------------------------------

 	------ Start Kill Steal ------
function KillSteal()
 	if Karthus.KS.KSEb:Value() then
 for i,enemy in pairs(GoS:GetEnemyHeroes()) do
 
 local ExtraDmg2 = 0
	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
	ExtraDmg2 = ExtraDmg2 + 0.1*BonusAP + 100
	end
 
        -- Kill Steal --
	   local QPred = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,900,GetCastRange(myHero,_Q),100,false,true)
	   
            if Ignite and Karthus.KS.IgniteKS:Value() then
                  if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetHPRegen(enemy)*2.5 and GoS:GetDistanceSqr(GetOrigin(enemy)) < 600*600 then
                  CastTargetSpell(enemy, Ignite)
                  end
            end
		
	 if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(enemy, GetCastRange(myHero,_Q)) and QPred.HitChance == 1 and Karthus.KS.QKS:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckQDmg) then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)	
	 end
 end
 	end
end

 	------ Start Auto Level Up _Full Q First then E ------
function AutoLvlUpQ()
	if Karthus.Miscset.AutoSkillUpQ:Value() then
 if GetLevel(myHero) >= 1 and GetLevel(myHero) < 2 then
	LevelSpell(_Q)
elseif GetLevel(myHero) >= 2 and GetLevel(myHero) < 3 then
	LevelSpell(_W)
elseif GetLevel(myHero) >= 3 and GetLevel(myHero) < 4 then
	LevelSpell(_E)
elseif GetLevel(myHero) >= 4 and GetLevel(myHero) < 5 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 5 and GetLevel(myHero) < 6 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 6 and GetLevel(myHero) < 7 then
	LevelSpell(_R)
elseif GetLevel(myHero) >= 7 and GetLevel(myHero) < 8 then
	LevelSpell(_Q)
elseif GetLevel(myHero) >= 8 and GetLevel(myHero) < 9 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 9 and GetLevel(myHero) < 10 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 10 and GetLevel(myHero) < 11 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 11 and GetLevel(myHero) < 12 then
        LevelSpell(_R)
elseif GetLevel(myHero) >= 12 and GetLevel(myHero) < 13 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 13 and GetLevel(myHero) < 14 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 14 and GetLevel(myHero) < 15 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 15 and GetLevel(myHero) < 16 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 16 and GetLevel(myHero) < 17 then
        LevelSpell(_R)
elseif GetLevel(myHero) >= 17 and GetLevel(myHero) < 18 then
        LevelSpell(_W)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_W)
 end
     end
end

 	------ Start Use Items _Use Health Potion_ ------
function AutoPotHP()
global_ticks = 0
currentTicks = GetTickCount()
 if Karthus.Items.PotionHP.PotHP:Value() then
local myHero = GetMyHero()
local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)
			if (global_ticks + 15000) < currentTicks then
				local potionslot = GetItemSlot(myHero, 2003)
					if potionslot > 0 then
						if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 < Karthus.Items.PotionHP.CheckHP:Value() then  
						global_ticks = currentTicks
						CastSpell(GetItemSlot(myHero, 2003))
						end
					end
				end
			end
			
  end	
  
 	------ Start Use Items _Use Mana Potion_ ------
function AutoPotMP()
global_ticks = 0
currentTicks = GetTickCount()
 if Karthus.Items.PotionMP.PotMP:Value() then
local myHero = GetMyHero()
local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)
			if (global_ticks + 15000) < currentTicks then
				local potionslot = GetItemSlot(myHero, 2004)
					if potionslot > 0 then
						if (GetCurrentMana(myHero)/GetMaxMana(myHero))*100 < Karthus.Items.PotionMP.CheckMP:Value() then  
						global_ticks = currentTicks
						CastSpell(GetItemSlot(myHero, 2004))
						end
					end
				end
			end
			
  end

 	------ Start Use Items _Use Zhonya_ ------
function AutoZhonya()
 if Karthus.Items.ChUZhonya.UseZhonya:Value() then
  if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 < Karthus.Items.ChUZhonya.CheckZhoHP:Value() then
   if GetItemSlot(myHero, 3157) > 0 and GoS:ValidTarget(unit, GetCastRange(myHero,_E)) then
    if CanUseSpell(myHero,_E) == READY and GetCurrentMana(myHero) > (GetCastLevel(myHero, _E)*12 + 18)*2.5 then
	 CastSpell(_E)
	  CastSpell(GetItemSlot(myHero, 3157))
	end
   end
   if GoS:ValidTarget(unit, 1000) then
    if GetItemSlot(myHero,3157) > 0 then
	  CastSpell(GetItemSlot(myHero, 3157))
	end
   end
  end
 end
end

	------ Start R Killable Info ------
function RKillableInfo()
   if Karthus.InfoR.EninfoR:Value() then
    if CanUseSpell(myHero,_R) == READY then return end
	
	local ExtraDmg2 = 0
	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
	ExtraDmg2 = ExtraDmg2 + 0.1*BonusAP + 100
	end
	
    -- info = "R dmg : "..dmgR .. "\n"
	
    info = ""
    for nID, enemy in pairs(GoS:GetEnemyHeroes()) do
        if IsObjectAlive(enemy) then
            dmgR = ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckRDmg)
            hpEnemies = GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)
			hp = GetCurrentHP(enemy)
            if dmgR > hpEnemies then
                info = info..GetObjectName(enemy)
                if not IsVisible(enemy) then
                    info = info.." Not see Enemy in map maybe"
                    HoldPosition()
                end
                    HoldPosition()
                info = info.."  killable\n"
            end
            -- info = info..GetObjectName(enemy).."    HP:"..hp.."  dmg: "..dmgR.." "..killable.."\n"
        end
  end
  DrawText(info,40,500,0,0xffff0000) 
   end
end
	
	------ Start Drawings ------
function Drawings()
  if Karthus.Draws.DrawsEb:Value() then
if Karthus.Draws.DrawQ:Value() and CanUseSpell(myHero,_Q) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xff0099FF) end
if Karthus.Draws.DrawW:Value() and CanUseSpell(myHero,_W) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_W),3,100,0xff1C1C1C) end
if Karthus.Draws.DrawE:Value() and CanUseSpell(myHero,_E) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_E),3,100,0xff7D26CD) end
if Karthus.Draws.DrawText:Value() then
	for _, enemy in pairs(Gos:GetEnemyHeroes()) do
		if GoS:ValidTarget(enemy) then
		    local enemyPos = GetOrigin(enemy)
		    local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)
		    local enemyText, color = GetDrawText(enemy)
		    DrawText(enemyText, 20, drawpos.x, drawpos.y, color)
		end
	end
end
  end
end

function GetDrawText(enemy)
	local ExtraDmg = 0
	if Ignite and CanUseSpell(myHero, Ignite) == READY then
	ExtraDmg = ExtraDmg + 20*GetLevel(myHero)+50
	end
	
	local ExtraDmg2 = 0
	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
	ExtraDmg2 = ExtraDmg2 + 0.1*BonusAP + 100
	end

 if CanUseSpell(myHero,_Q) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckQDmg) then
  return 'Killable with Q', ARGB(255, 200, 160, 0)
elseif ExtraDmg > 0 and CanUseSpell(myHero,_Q) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckQDmg + ExtraDmg) then
  return 'Q + Ignite = Killable', ARGB(255, 200, 160, 0)
elseif CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckRDmg) then
  return 'Killable with R', ARGB(255, 200, 160, 0)
elseif CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckQDmg + CheckRDmg) then
  return 'Q + R = Killable', ARGB(255, 200, 160, 0)
elseif ExtraDmg > 0 and CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckRDmg + ExtraDmg) then
  return 'R + Ignite = Killable', ARGB(255, 200, 160, 0)
elseif ExtraDmg > 0 and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy) < ExtraDmg2 + GoS:CalcDamage(myHero, enemy, 0, CheckQDmg + CheckRDmg + ExtraDmg) then
  return 'Q + R + Ignite = Killable', ARGB(255, 200, 160, 0)
else
  return 'Cant Kill this Target', ARGB(255, 200, 160, 0)
 end
end