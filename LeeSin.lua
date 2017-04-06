local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "LeeSin" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/LeeSin/master/LeeSin.lua', SCRIPT_PATH .. 'LeeSin.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/LeeSin/master/LeeSin.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local LeeSinMenu = Menu("LeeSin", "LeeSin")

LeeSinMenu:SubMenu("Combo", "Combo")

LeeSinMenu.Combo:Boolean("Q", "Use Q in combo", true)
LeeSinMenu.Combo:Boolean("W", "Use W in combo", true)
LeeSinMenu.Combo:Boolean("E", "Use E in combo", true)
LeeSinMenu.Combo:Boolean("R", "Use R in combo", true)
LeeSinMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
LeeSinMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
LeeSinMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
LeeSinMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
LeeSinMenu.Combo:Boolean("RHydra", "Use RHydra", true)
LeeSinMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
LeeSinMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
LeeSinMenu.Combo:Boolean("Randuins", "Use Randuins", true)


LeeSinMenu:SubMenu("AutoMode", "AutoMode")
LeeSinMenu.AutoMode:Boolean("Level", "Auto level spells", false)
LeeSinMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
LeeSinMenu.AutoMode:Boolean("Q", "Auto Q", false)
LeeSinMenu.AutoMode:Boolean("W", "Auto W", false)
LeeSinMenu.AutoMode:Boolean("E", "Auto E", false)
LeeSinMenu.AutoMode:Boolean("R", "Auto R", false)

LeeSinMenu:SubMenu("LaneClear", "LaneClear")
LeeSinMenu.LaneClear:Boolean("Q", "Use Q", true)
LeeSinMenu.LaneClear:Boolean("W", "Use W", true)
LeeSinMenu.LaneClear:Boolean("E", "Use E", true)
LeeSinMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
LeeSinMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

LeeSinMenu:SubMenu("Harass", "Harass")
LeeSinMenu.Harass:Boolean("Q", "Use Q", true)
LeeSinMenu.Harass:Boolean("W", "Use W", true)

LeeSinMenu:SubMenu("KillSteal", "KillSteal")
LeeSinMenu.KillSteal:Boolean("Q", "KS w Q", true)
LeeSinMenu.KillSteal:Boolean("E", "KS w E", true)

LeeSinMenu:SubMenu("AutoIgnite", "AutoIgnite")
LeeSinMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

LeeSinMenu:SubMenu("Drawings", "Drawings")
LeeSinMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

LeeSinMenu:SubMenu("SkinChanger", "SkinChanger")
LeeSinMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
LeeSinMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if LeeSinMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if LeeSinMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then
				if target ~= nil then 
                                       CastSkillShot(_Q, target)
                                end
            end

            if LeeSinMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if LeeSinMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if LeeSinMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if LeeSinMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if LeeSinMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if LeeSinMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 350) then
			 CastSpell(_E)
	    end

            if LeeSinMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1100) then
		     if target ~= nil then
                         CastSkillShot(_Q, target)
                     end
            end

            if LeeSinMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if LeeSinMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if LeeSinMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if LeeSinMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSpell(_W)
	    end
	    
	    
            if LeeSinMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 375) and (EnemiesAround(myHeroPos(), 375) >= LeeSinMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and LeeSinMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 350) and LeeSinMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if LeeSinMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 1100) then
	        	CastSkillShot(_Q, target)
                end

                if LeeSinMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastSpell(_W)
	        end

                if LeeSinMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 350) then
	        	CastSpell(_E)
	        end

                if LeeSinMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if LeeSinMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if LeeSinMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 1100) then
		      CastSkillShot(_Q, target)
          end
        end 
        if LeeSinMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastSpell(_W)
          end
        end
        if LeeSinMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 350) then
		      CastSpell(_E)
	  end
        end
        if LeeSinMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 375) then
		     CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if LeeSinMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if LeeSinMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 1100, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
                

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if LeeSinMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>LeeSin</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





