if GetObjectName(GetMyHero()) ~= "Vayne" then return end

(require "Inspired")
(require "MapPositionGOS")
(require "Interrupter")
(require "DLib")
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetDistance = d.GetDistance
local GetTarget = d.GetTarget

TcMenu= Menu("CAT", "Poppy")
TcMenu:SubMenu("Combo", "Combo")
TcMenu.Combo:Boolean("Q", "Use Q", true)
TcMenu.Combo:Boolean("W", "Use W", true)
TcMenu.Combo:Boolean("E", "Use E", true)
TcMenu.Combo:Boolean("R", "Use R", true)

TcMenu:SubMenu("Lasthit "Lasthit")
TcMenu.Lasthit:Boolean("Q", "Use Q", true)

TcMenu:SubMenu("Laneclear", "LaneClear")
TcMenu.Laneclear:Boolean("Q", "Use Q", true)

local key = submenu.addItem(MenuKeyBind.new("auto stun key", string.byte(" ")))
local autoStun = submenu.addItem(MenuBool.new("auto stun when possible", true))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

local function AutoEiAC(target)
	if ValidTarget(target,eRange) and CanUseSpell(myHero,_E) == READY then
		local pos = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target), 2000, 250, 1000, 1, false, true).PredPos
		local vPos = Vector(pos)
		for length = 0, 450, GetHitBox(target) do
	    local tPos = vPos + Vector(vPos - Vector(myHero)):normalized() * length
	    if MapPosition:inWall(tPos) then
	      CastTargetSpell(target, _E)
	      break
	    end
	  end
	end
end

addInterrupterCallback(function(target, spellType, spell)
	-- PrintChat(spell.name.." "..GetObjectName(target))
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
		if spellType == CHANELLING_SPELLS or (spellType == GAPCLOSER_SPELLS and GetDistance(spell.startPos) > GetDistance(spell.endPos)) then
			CastTargetSpell(target, _E)
		end
	end
end)

OnTick(function(myHero)
	if Combo() or autoStun.getValue() then
		AutoEiAC(GetTarget(eRange, DAMAGE_PHYSICAL))
	end

--Combo--
    if TcMenu.Combo.Q:Value() then
        if CanUseSpell(myHero, _Q) == READY and ValidTarget(target, 200) then
            CastSpell(_Q)
        end
    end
    
    if TcMenuMenu.Combo.W:Value() then
        if CanUseSpell(myHero, _W) == READY and ValidTarget(target, 200) then
           CastSpell(_W)
        end
    end
    if IsReady(_E) and TcMenu.Combo.E.Enabled:Value() and ValidTarget(target, 710) then
        StunThisPleb(target)
    end
	if 	TcMenu.Combo.R:Value() then
         if CanUseSpell(myHero, _R) == READY and ValidTarget(target,GetCastRange(myHero,_R)) then
           CastTargetSpell(target,_R)
        end
    end
end

--Lasthit--
		if CanUseSpell(myHero, _Q) == READY and TCMenu.LaneClear.Q:Value() and ValidTarget(minion, 200) then
		   CastTargetSpell(minion, _Q)
		end
		
	end
end

--Laneclear--

       if CanUseSpell(myHero, _Q) == READY and PoppyMenu.JungleClear.W:Value() and ValidTarget(mob, 200) then
			CastSpell(_W)
		end
end)

