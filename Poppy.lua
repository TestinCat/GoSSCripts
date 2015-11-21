if GetObjectName(GetMyHero()) ~= "Poppy" then return end

require ('Inspired')
require ('MapPositionGOS')
require ('Interrupter')
require ('DLib')
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetDistance = d.GetDistance
local GetTarget = d.GetTarget

TcMenu= Menu("Cat", "Poppy")
TcMenu:SubMenu("Combo", "Combo")
TcMenu.Combo:Boolean("Q", "Use Q", true)
TcMenu.Combo:Boolean("W", "Use W", true)
TcMenu.Combo:Boolean("E", "Use E", true)
TcMenu.Combo:Boolean("R", "Use R", true)
TcMenu.Combo:Menu("E", "Condemn (E)")
TcMenu.Combo.E:Boolean("Enabled", "Enabled", true)
TcMenu.Combo.E:Slider("pushdistance", "E Push Distance", 400, 350, 490, 1)

 TcMenu:SubMenu("JungeClear", "JungleClear")
TcMenu.Lasthit:Boolean("Q", "Use Q", true)
TcMenu.Lasthit:Boolean("W", "Use W", true)

TcMenu:SubMenu("Laneclear", "LaneClear")
TcMenu.Laneclear:Boolean("Q", "Use Q", true)
TcMenu.Laneclear:Boolean("W", "Use W", true)

TcMenu:Menu("Drawings",("Drawings")
TcMenu:Drawings:Boolean("E),("Draw E range")

TcMenu:Menu("Misc", "Misc")
TcMenu.Misc:Menu("EMenu", "AutoStun")
if Ignite ~= nil then TcMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
TcMenu.Misc:Boolean("Autolvl", "Auto level", true)
TcMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"W-Q-E", "Q-W-E"})

local InterruptMenu = MenuConfig("Interrupt (E)", "Interrupt")

  for i, spell in pairs(CHANELLING_SPELLS) do
    for _,k in pairs(GetEnemyHeroes()) do
        if spell["Name"] == GetObjectName(k) then
        InterruptMenu:Boolean(GetObjectName(k).."Inter", "On "..GetObjectName(k).." "..(type(spell.Spellslot) == 'number' and str[spell.Spellslot]), true)   
        end
    end
  end

    for _,k in pairs(GetEnemyHeroes()) do
  TcMenu.Misc.EMenu:Boolean(GetObjectName(k).."Pleb", ""..GetObjectName(k).."", true)
  end
        
end, 1)
 
OnProcessSpell(function(unit, spell)
      if GetObjectType(unit) == Obj_AI_Hero and GetTeam(unit) ~= GetTeam(myHero) and IsReady(_E) then
        if CHANELLING_SPELLS[spell.name] then
          if IsInDistance(unit, 615) and GetObjectName(unit) == CHANELLING_SPELLS[spell.name].Name and InterruptMenu[GetObjectName(unit).."Inter"]:Value() then 
          CastTargetSpell(unit, _E)
          end
        end
      end
end)

  OnDraw(function(myHero)
if TcMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_E),1,0,col) end
    end
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()

--Combo--   
if IOW:Mode() == "Combo" then
    
    if PoppyMenu.Combo.Q:Value() then
        if CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 200) then
            CastSpell(_Q)
        end
    end
    
    if PoppyMenu.Combo.W:Value() then
        if CanUseSpell(myHero, _W) == READY and ValidTarget(target, 200) then
           CastSpell(_W)
        end
    end
    if IsReady(_E) and TcMenu.Combo.E.Enabled:Value() and ValidTarget(target, 710) then
        StunThisPleb(target)
    end
	if PoppyMenu.Combo.R:Value() then
         if CanUseSpell(myHero, _R) == READY and ValidTarget(target,GetCastRange(myHero,_R)) then
           CastTargetSpell(target,_R)
        end
    end
end

--JungeClear--
for _,mob in pairs(minionManager.objects) do
if GetTeam(mob) == MINION_JUNGLE then

if IOW:Mode() == "LaneClear" then

	    if CanUseSpell(myHero, _Q) == READY and PoppyMenu.JungleClear.W:Value() and ValidTarget(mob, 200) then
			CastSpell(_W)
		end
		
		if CanUseSpell(myHero, _W) == READY and PoppyMenu.JungleClear.Q:Value() and ValidTarget(mob, 200) then
			CastTargetSpell(_W)
		end
		
		end
end

--LANECLEAR--

for _, minion in pairs(minionManager.objects) do
if GetTeam(minion) == MINION_ENEMY then

if IOW:Mode() == "LaneClear" then

		if CanUseSpell(myHero, _Q) == READY and PoppyMenu.LaneClear.Q:Value() and ValidTarget(minion, 200) then
		   CastTargetSpell(minion, _Q)
		end
		
	end
end
end)

   local ElitePleb = ClosestEnemy(GetMousePos())
   if Flash and IsReady(Flash) and IsReady(_E) and TcMenu.Combo.E.cf:Value() and ValidTarget(ElitePleb, 1100) then
   StunThisPlebV2(ElitePleb)
   end
   
--Drawings--
OnDraw(function(myHero)
local col = TcMenu.Drawings.color:Value()
if TcMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_E),1,0,col) end

   for i,enemy in pairs(GetEnemyHeroes()) do
    if IOW:Mode() == "Combo" then
if IsReady(_E) and TcMenu.Misc.EMenu[GetObjectName(enemy).."Pleb"]:Value() and ValidTarget(enemy, 710) then
        StunThisPleb(enemy)
        end

        if IsReady(_E) and TcMenu.Misc.lowhp:Value() and GetPercentHP(myHero) <= 15 and EnemiesAround(myHeroPos(), 375) >= 1 then
        CastTargetSpell(enemy, _E)
        end

   end

function StunThisPleb(unit)
        local EPred = GetPredictionForPlayer(GetOrigin(myHero),unit,GetMoveSpeed(unit),2000,250,1000,1,false,true)
        local PredPos = Vector(EPred.PredPos)
        local HeroPos = Vector(myHero)
        local maxERange = PredPos - (PredPos - HeroPos) * ( - TcMenu.Combo.E.pushdistance:Value() / GetDistance(EPred.PredPos))
        local shootLine = Line(Point(PredPos.x, PredPos.y, PredPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
        for i, Pos in pairs(shootLine:__getPoints()) do
          if MapPosition:inWall(Pos) then
          CastTargetSpell(unit, _E) 
          end
        end
end

if TcMenu.Misc.Autolvl:Value() then  
   if TcMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
   elseif TcMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
   end

DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
end

end)

function StunThisPlebV2(unit)
        local EPred = GetPredictionForPlayer(GetMousePos(),unit,GetMoveSpeed(unit),2000,250,1000,1,false,true)
        local PredPos = Vector(EPred.PredPos)
        local maxERange = PredPos - (PredPos - GetMousePos()) * ( - TcMenu.Combo.E.pushdistance:Value() / GetDistance(GetMousePos(), EPred.PredPos))
        local shootLine = Line(Point(PredPos.x, PredPos.y, PredPos.z), Point(maxERange.x, maxERange.y, maxERange.z))
        for i, Pos in pairs(shootLine:__getPoints()) do
          if MapPosition:inWall(Pos) then
          CastTargetSpell(unit, _E) 
          DelayAction(function() CastSkillShot(Flash,GetMousePos()) end, 1)
          end
        end
end

PrintChat("Poppy Script Loaded!")
PrintChat("By Testin Cat :3!")
