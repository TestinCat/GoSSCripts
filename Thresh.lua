ThreshMenu = Menu("Thresh", "Thresh")
ThreshMenu:SubMenu("Combo", "Combo")
ThreshMenu.Combo:Boolean("Q", "Use Q", true)

ThreshMenu:SubMenu("Drawings", "Drawings")
ThreshMenu.Drawings:Boolean("Q", "Draw Q Range", true)

OnTick(function(myHero)
 
        if IOW:Mode() == "Combo" then
                       
                        local target = GetCurrentTarget()
				local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1200,500,1100,60,true,false)


                       
                        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, 1100) and GoS:GetDistance(myHero, target) <= 1000 and ThreshMenu.Combo.Q:Value() then
                        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
                    end
                    end
                        
                      
        end
  if ThreshMenu.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1100,3,100,0xffffff00) end

end)

PrintChat("Thresh Q.")
PrintChat("by TestinCat") 
