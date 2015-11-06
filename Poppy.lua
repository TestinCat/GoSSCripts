if GetObjectName(GetMyHero()) ~= "Poppy" then return end

require ('Inspired')

PoppyMenu = Menu("Poopy", "Poppy")
PoppyMenu:SubMenu("Combo", "Combo")
PoppyMenu.Combo:Boolean("Q", "Use Q", true)
PoppyMenu.Combo:Boolean("W", "Use W", true)
PoppyMenu.Combo:Boolean("E", "Use E", true)
PoppyMenu.Combo:Boolean("R", "Use R", true)
 
PoppyMenu:SubMenu("JungeClear", "JungleClear")
PoppyMenu.Lasthit:Boolean("Q", "Use Q", true)
PoppyMenu.Lasthit:Boolean("W", "Use W", true)
PoppyMenu.Lasthit:Boolean("E", "Use E", true)

PoppyMenu:SubMenu("Laneclear", "LaneClear")
PoppyMenu.Laneclear:Boolean("Q", "Use Q", true)
PoppyMenu.Laneclear:Boolean("W", "Use W", true)
PoppyMenu.Laneclear:Boolean("E", "Use E", true)

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
    if PoppyMenu.Combo.E:Value() then
         if CanUseSpell(myHero, _E) == READY and ValidTarget(target,GetCastRange(myHero,_E)) then
           CastTargetSpell(target,_E)
        end
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
		
	    if CanUseSpell(myHero, _E) == READY and PoppyMenu.JungleClear.E:Value() and ValidTarget(mob, 200) then
			CastSpell(_E)
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

PrintChat("Poppy Script Loaded!")
PrintChat("Poopy by TestinCat")
PrintChat("v.beta")
