-- Rx Sona Version 1.0 by Rudo.
-- Updated Sona for Inspired Ver26 and IOW
-- Rx Sona Don't require deLibrary
--------------------------------------------

require('Inspired')
---- Create a Menu ----
if GetObjectName(myHero) ~= "Sona" then return end
Sona = Menu("Rx Sona", "Sona")

---- Combo ----
Sona:SubMenu("cb", "Sona Combo")
Sona.cb:Boolean("QCB", "Use Q", true)
Sona.cb:Boolean("WCB", "Use W", true)
Sona.cb:Boolean("ECB", "Use E", true)
Sona.cb:Boolean("RCB", "Use R", true)
Sona.cb:Boolean("FQCCB", "Use Frost Queen's Claim", true)

---- Harass Menu ----
Sona:SubMenu("hr", "Harass")
Sona.hr:Boolean("HrQ", "Use Q", true)

---- Auto Spell Menu ----
Sona:SubMenu("AtSpell", "Auto Spell")
Sona.AtSpell:Boolean("ASEb", "Enable Aut Spell", true)
Sona.AtSpell:Boolean("ASQ", "Use Q", true)
Sona.AtSpell:Boolean("ASW", "Use W", true)
Sona.AtSpell:Boolean("ASE", "Use E", true)
Sona.AtSpell:Slider("ASMana", "Auto Spell if My %MP >", 10, 0, 80, 1)

---- Drawings Menu ----
Sona:SubMenu("Draws", "Drawings")
Sona.Draws:Boolean("DrawsEb", "Enable Drawings", true)
Sona.Draws:Boolean("DrawQ", "Range Q", true)
Sona.Draws:Boolean("DrawW", "Range W", true)
Sona.Draws:Boolean("DrawE", "Range E", true)
Sona.Draws:Boolean("DrawR", "Range R", true)
Sona.Draws:Boolean("DrawText", "Draw Test", true)

---- Misc Menu ----
Sona:SubMenu("Miscset", "Misc")
Sona.Miscset:SubMenu("KS", "Kill Steal")
Sona.Miscset.KS:Boolean("KSEb", "Enable KillSteal", true)
Sona.Miscset.KS:Boolean("QKS", "KS with Q", true)
Sona.Miscset.KS:Boolean("RKS", "KS with R", true)
Sona.Miscset:SubMenu("AntiSkill", "Stop Skill Enemy")
Sona.Miscset.AntiSkill:Boolean("RAnti", "Stop Skil Enemy with R",true)
Sona.Miscset:SubMenu("AutoLvlUp", "Auto Level Up")
Sona.Miscset.AutoLvlUp:Boolean("AutoSkillUpQ", "Auto Lvl Up Q", true)   ------ Full Q First.
Sona.Miscset.AutoLvlUp:Boolean("AutoSkillUpW", "Auto Lvl Up W", true)   ------ Full W First.

Sona.Miscset.KS:Boolean("IgniteKS", "KS with Ignite", true )
   
---- Use Items Menu ----
Sona:SubMenu("Items", "Auto Use Items")
Sona.Items:SubMenu("PotionHP", "Use Potion HP")
Sona.Items.PotionHP:Boolean("PotHP", "Enable Use Potion HP", true)
Sona.Items.PotionHP:Slider("CheckHP", "Auto Use if %HP <", 50, 5, 80, 1)
Sona.Items:SubMenu("PotionMP", "Use Potion MP")
Sona.Items.PotionMP:Boolean("PotMP", "Enable Use Potion MP", true)
Sona.Items.PotionMP:Slider("CheckMP", "Auto Use if %MP <", 45, 5, 80, 1)
Sona.Items:SubMenu("FrostQC", "Auto Use Frost Queen's Claim")
Sona.Items.FrostQC:Boolean("FQC", "Enable", true)

---------- End Menu ----------


local info = "Rx Sona Loaded."
local upv = "Upvote if you like it >3"
local sig = "Made by Rudo"
local ver = "Version: 1.0"
textTable = {info,upv,sig,ver}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])
PrintChat(textTable[4])

PrintChat(string.format("<font color='#FF0000'>Rx Sona by Rudo </font><font color='#FFFF00'>Loaded Success </font><font color='#08F7F3'>Enjoy it and Good Luck :3</font>")) 

----- End Print -----

-------------------------------------------------------require('DLib')-------------------------------------------------------

-------------------------------------------------------Starting--------------------------------------------------------------


global_ticks = 0
currentTicks = GetTickCount()

require('IOW')
CHANELLING_SPELLS = {
    ["Caitlyn"]                     = {_R},
    ["Katarina"]                    = {_R},
    ["FiddleSticks"]                = {_R},
    ["Galio"]                       = {_R},
    ["Lucian"]                      = {_R},
    ["MissFortune"]                 = {_R},
    ["VelKoz"]                      = {_R},
    ["Nunu"]                        = {_R},
    ["Shen"]                        = {_R},
    ["Karthus"]                     = {_R},
    ["Malzahar"]                    = {_R},
    ["Pantheon"]                    = {_R},
    ["Warwick"]                     = {_R},
    ["Xerath"]                      = {_R},
    ["Ezreal"]                      = {_R},
	["Kennen"]                      = {_R},
    ["Rengar"]                      = {_R},
    ["Twisted Fate"]                = {_R},
	["Tahm Kench"]                  = {_R},
    ["Ezreal"]                      = {_R},
}

local callback = nil
 
OnProcessSpell(function(unit, spell)    
        if not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == GetTeam(GetMyHero()) then return end
        local unitChanellingSpells = CHANELLING_SPELLS[GetObjectName(unit)]
 
        if unitChanellingSpells then
            for _, spellSlot in pairs(unitChanellingSpells) do
                if spell.name == GetCastName(unit, spellSlot) then callback(unit, CHANELLING_SPELLS) end
            end
	end
end)
 
function addAntiSkillCallback( callback0 )
        callback = callback0
end

addAntiSkillCallback(function(target, spellType)
  local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),2400,250,1000,150,false,true)
  if GoS:IsInDistance(target, 1000) and CanUseSpell(myHero,_R) == READY and Sona.Miscset.AntiSkill.RAnti:Value() and spellType == CHANELLING_SPELLS then
    CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
  end
end)

OnLoop(function(myHero)
		        local target = IOW:GetTarget()
	------ Start Combo ------
    if IOW:Mode() == "Combo" then
	
		if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 845) and Sona.cb.QCB:Value() then
		CastSpell(_Q)
        end
					
		if CanUseSpell(myHero, _W) == READY and GoS:ValidTarget(target, 840) and Sona.cb.WCB:Value() then
		CastSpell(_W)
		end
				
		if CanUseSpell(myHero, _E) == READY and GoS:ValidTarget(target, 1000) and Sona.cb.ECB:Value() then
		CastSpell(_E)
		end
		
		local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),2400,300,1000,150,false,true)
        if CanUseSpell(myHero, _R) == READY and RPred.HitChance == 1 and GoS:ValidTarget(target, 950) and Sona.cb.RCB:Value() then
        CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
        end
		
		if Sona.cb.FQCCB:Value() then
			local frostquc = GetItemSlot(myHero, 3096)
		if frostquc >= 0 then
			local FPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1800,200,880,270,false,true)
		if CanUseSpell(GetItemSlot(myHero, 3096)) == READY and GoS:ValidTarget(target, 880) and FPred.HitChance == 1 then  
		        CastSkillShot(GetItemSlot(myHero, 3096,FPred.PredPos.x,FPred.PredPos.y,FPred.PredPos.z));
		end
		end
		end	
					
	elseif IOW:Mode() == "Harass" then
	------ Start Harass ------
        if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 845) and Sona.hr.HrQ:Value() then
		CastSpell(_Q)
        end	
	end
	
if Sona.AtSpell.ASEb:Value() then
	AutoSpell()
	end
	
if Sona.Miscset.KS.KSEb:Value() then
	KillSteal()
	end
		
if Sona.Miscset.AutoLvlUp.AutoSkillUpQ:Value() then
	UpFullQ()
	end
	
if Sona.Miscset.AutoLvlUp.AutoSkillUpW:Value() then
	UpFullW()
	end
	
if Sona.Items.PotionHP.PotHP:Value() then	
	UsePotHP()
	end
	
if Sona.Items.PotionMP.PotMP:Value() then	
	UsePotMP()
	end
	
if Sona.Items.FrostQC.FQC:Value() then
	UseFQC()
	end
	
if Sona.Draws.DrawsEb:Value() then
	Drawings()
	end
end)
 

------------------------------------------------------- Start Function -------------------------------------------------------

	------ Start Auto Spell ------
function AutoSpell()
	if Sona.AtSpell.ASEb:Value() then
 if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > Sona.AtSpell.ASMana:Value() then
               for i,enemy in pairs(GoS:GetEnemyHeroes()) do				  
	local target = GetCurrentTarget()
      if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 845) and Sona.AtSpell.ASQ:Value() then
	  CastSpell(_Q)
 end

  if CanUseSpell(myHero, _W) == READY and (GetCurrentHP(myHero)/GetMaxHP(myHero))<0.55 and Sona.AtSpell.ASW:Value() then
    CastSpell(_W)
  end
               for _, ally in pairs(GetAllyHeroes()) do
		if GoS:GetDistance(enemy)<1251 then	   
  if CanUseSpell(myHero, _W) == READY and (GetCurrentHP(ally)/GetMaxHP(ally))<0.80 and Sona.AtSpell.ASW:Value() then
    CastTargetSpell(ally, _W)
  end
        end
  if CanUseSpell(myHero, _W) == READY and (GetCurrentHP(ally)/GetMaxHP(ally))<0.50 and Sona.AtSpell.ASW:Value() then
    CastTargetSpell(ally, _W)
  end		
                end 
				end
    if CanUseSpell(myHero, _E) == READY and (GetMoveSpeed(myHero))<0.6 and Sona.AtSpell.ASE:Value() then
    CastSpell(_E)
    end
 end
 end
 end
 
 	------ Start Kill Steal ------
function KillSteal()
 	if Sona.Miscset.KS.KSEb:Value() then
for i,enemy in pairs(GoS:GetEnemyHeroes()) do

        -- Kill Steal --
 	local RPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),2400,200,1000,150,false,true)
	  local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
		end

		if Ignite and Sona.Miscset.KS.IgniteKS:Value() then
                  if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetHPRegen(enemy)*2.5 and GoS:GetDistanceSqr(GetOrigin(enemy)) < 600*600 then
                  CastTargetSpell(enemy, Ignite)
                  end
                end

	if CanUseSpell(myHero, _Q) and GoS:ValidTarget(enemy, 845) and Sona.Miscset.KS.QKS:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 40*GetCastLevel(myHero,_Q) + 0.50*GetBonusAP(myHero) + ExtraDmg) then
		CastSpell(_Q)
    elseif CanUseSpell(myHero, _R) == READY and RPred.HitChance == 1 and GoS:ValidTarget(target, 950) and Sona.Miscset.KS.RKS:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 50 + 100*GetCastLevel(myHero,_R) + 0.50*GetBonusAP(myHero) + ExtraDmg) then
        CastSkillShot(_R,RPred.PredPos.x,RPred.PredPos.y,RPred.PredPos.z)
	end
end
	end
end

 	------ Start Auto Level Up _Full Q First_ ------
function UpFullQ()
  if Sona.Miscset.AutoLvlUp.AutoSkillUpQ:Value() then  
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
        LevelSpell(_W)
elseif GetLevel(myHero) >= 10 and GetLevel(myHero) < 11 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 11 and GetLevel(myHero) < 12 then
        LevelSpell(_R)
elseif GetLevel(myHero) >= 12 and GetLevel(myHero) < 13 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 13 and GetLevel(myHero) < 14 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 14 and GetLevel(myHero) < 15 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 15 and GetLevel(myHero) < 16 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 16 and GetLevel(myHero) < 17 then
        LevelSpell(_R)
elseif GetLevel(myHero) >= 17 and GetLevel(myHero) < 18 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_E)
end
  end
end
 
  	------ Start Auto Level Up _Full W First_ ------
function UpFullW()
  if Sona.Miscset.AutoLvlUp.AutoSkillUpW:Value() then  
if GetLevel(myHero) >= 1 and GetLevel(myHero) < 2 then
	LevelSpell(_W)
elseif GetLevel(myHero) >= 2 and GetLevel(myHero) < 3 then
	LevelSpell(_Q)
elseif GetLevel(myHero) >= 3 and GetLevel(myHero) < 4 then
	LevelSpell(_E)
elseif GetLevel(myHero) >= 4 and GetLevel(myHero) < 5 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 5 and GetLevel(myHero) < 6 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 6 and GetLevel(myHero) < 7 then
	LevelSpell(_R)
elseif GetLevel(myHero) >= 7 and GetLevel(myHero) < 8 then
	LevelSpell(_W)
elseif GetLevel(myHero) >= 8 and GetLevel(myHero) < 9 then
        LevelSpell(_W)
elseif GetLevel(myHero) >= 9 and GetLevel(myHero) < 10 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 10 and GetLevel(myHero) < 11 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 11 and GetLevel(myHero) < 12 then
        LevelSpell(_R)
elseif GetLevel(myHero) >= 12 and GetLevel(myHero) < 13 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 13 and GetLevel(myHero) < 14 then
        LevelSpell(_Q)
elseif GetLevel(myHero) >= 14 and GetLevel(myHero) < 15 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 15 and GetLevel(myHero) < 16 then
        LevelSpell(_E)
elseif GetLevel(myHero) >= 16 and GetLevel(myHero) < 17 then
        LevelSpell(_R)
elseif GetLevel(myHero) >= 17 and GetLevel(myHero) < 18 then
        LevelSpell(_E)
elseif GetLevel(myHero) == 18 then
        LevelSpell(_E)
end
  end
end

 	------ Start Use Items _Use Health Potion_ ------
function UsePotHP()
 if Sona.Items.PotionHP.PotHP:Value() then
local myHero = GetMyHero()
local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)
			if (global_ticks + 15000) < currentTicks then
				local potionslot = GetItemSlot(myHero, 2003)
					if potionslot > 0 then
						if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 < Sona.Items.PotionHP.CheckHP:Value() then  
						global_ticks = currentTicks
						CastSpell(GetItemSlot(myHero, 2003))
						end
					end
				end
			end
			
  end		
 	------ Start Use Items _Use Mana Potion_ ------
function UsePotMP()
 if Sona.Items.PotionMP.PotMP:Value() then
local myHero = GetMyHero()
local target = GetCurrentTarget()
local myHeroPos = GetOrigin(myHero)
			if (global_ticks + 15000) < currentTicks then
				local potionslot = GetItemSlot(myHero, 2004)
					if potionslot > 0 then
						if (GetCurrentMana(myHero)/GetMaxMana(myHero))*100 < Sona.Items.PotionMP.CheckMP:Value() then  
						global_ticks = currentTicks
						CastSpell(GetItemSlot(myHero, 2004))
						end
					end
				end
			end
			
  end			
  	------ Start Use Items _Use Frost Queen's Claim_ ------
function UseFQC()
 if Sona.Items.FrostQC.FQC:Value() then
				for i,enemy in pairs(GoS:GetEnemyHeroes()) do
              local target = GetCurrentTarget()
				local frostquc = GetItemSlot(myHero, 3096)
					if frostquc >= 0 then
		if CanUseSpell(GetItemSlot(myHero, 3096)) == READY and (GetMoveSpeed(enemy))>1.2 and GoS:ValidTarget(target, 880) then  
						CastSpell(GetItemSlot(myHero, 3049))
		end
				    end
				end

  end
end
	
	------ Start Drawings ------
function Drawings()
  if Sona.Draws.DrawsEb:Value() then
 local HeroPos = GetOrigin(myHero)
if Sona.Draws.DrawQ:Value() and CanUseSpell(myHero, _Q) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xff3366FF) end
if Sona.Draws.DrawW:Value() and CanUseSpell(myHero, _W) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_W),3,100,0xff00FF33) end
if Sona.Draws.DrawE:Value() and CanUseSpell(myHero, _E) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_E),3,100,0xff8201B2) end
if Sona.Draws.DrawR:Value() and CanUseSpell(myHero, _R) == READY then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_R),3,100,0xffFFFF33) end
 if Sona.Draws.DrawText:Value() then
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
	ExtraDmg2 = ExtraDmg2 + 0.1*GetBonusAP(myHero) + 100
	end
	
	if CanUseSpell(myHero,_Q) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 40*GetCastLevel(myHero,_Q) + 0.50*GetBonusAP(myHero) + ExtraDmg2) then
		return 'Q = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 50 + 100*GetCastLevel(myHero,_R) + 0.50*GetBonusAP(myHero) + ExtraDmg2) then
		return 'R = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 40*GetCastLevel(myHero,_Q) + 0.50*GetBonusAP(myHero) + 50 + 100*GetCastLevel(myHero,_R) + 0.50*GetBonusAP(myHero) + ExtraDmg2) then
		return 'Q + R = Kill!', ARGB(255, 200, 160, 0)
	elseif ExtraDmg > 0 and CanUseSpell(myHero,_Q) == READY and CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 40*GetCastLevel(myHero,_Q) + 0.50*GetBonusAP(myHero) + 50 + 100*GetCastLevel(myHero,_R) + 0.50*GetBonusAP(myHero) + ExtraDmg2) then
		return 'Q + R + Ignite = Kill!', ARGB(255, 200, 160, 0)
	else
		return 'Cant Kill Yet', ARGB(255, 200, 160, 0)
	end
end