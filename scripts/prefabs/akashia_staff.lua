local assets =
{
    Asset("ANIM", "anim/staffs_akashia.zip")
}

local castLines = {
  "PSI Shield!"
}
	
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "staffs_akashia", "swap_" .. inst.build)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function AttemptSpell(inst, target)
	local caster = inst.components.inventoryitem.owner	
    if caster.components.health.currenthealth >= inst.power / 2 and target ~= caster then
		caster.components.health:DoDelta(-inst.power / 2)
		caster.components.talker:Say(castLines[math.random(#castLines)])
        target.components.health:DoDelta(inst.power)
        local fx = SpawnPrefab("wortox_soul_heal_fx")
        local colourfn = fx:DoPeriodicTask(.167, function() fx.AnimState:SetAddColour(math.random(256) / 255, math.random(256) / 255, math.random(256) / 255, 0) end)
        fx:DoTaskInTime(1.5, function() colourfn:Cancel() end)
        fx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, -50, 0)
        fx:Setup(target)
        if inst.level == 3 then
            target:AddDebuff("buff_akashia_staff", "buff_akashia_staff")
        end
	elseif target == caster and caster.components.health.currenthealth >= TUNING.AKASHIA_MAX_HEALING / 2 then
        caster.components.health:DoDelta(-TUNING.AKASHIA_MAX_HEALING / 2)
        local pos = caster:GetPosition()
        for _, v in pairs(TheSim:FindEntities(pos.x, pos.y, pos.z, 9, {"_combat"}, {"monster", "epic", "playerghost"}, {"player", "companion"})) do
            print(v)
            if v.components.health then 
                v.components.health:DoDelta(TUNING.AKASHIA_MAX_HEALING)
                local fx = SpawnPrefab("wortox_soul_heal_fx")
                local colourfn = fx:DoPeriodicTask(.167, function() fx.AnimState:SetAddColour(math.random(256) / 255, math.random(256) / 255, math.random(256) / 255, 0) end)
                fx:DoTaskInTime(1.5, function() colourfn:Cancel() end)
                fx.entity:AddFollower():FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, -50, 0)
                fx:Setup(v) 
            end
        end
        
    else
		caster.components.talker:Say("I can't concentrate!")	  
    end
 
end 

 local function CreateStaff(name, build, level)
	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
        --Bank name is the entity name, build name is the name of the compiled zip file
		inst.AnimState:SetBank("staffs_akashia")
		inst.AnimState:SetBuild("staffs_akashia")
		inst.AnimState:PlayAnimation("idle" .. level)
		if not TheWorld.ismastersim then
			return inst
		end
		inst.entity:SetPristine()
		
		inst:AddComponent("spellcaster")	
		inst.components.spellcaster:SetSpellFn(AttemptSpell)
		inst.components.spellcaster.canuseontargets = true	
		if level == 3 then inst.components.spellcaster.canonlyuseonlocomotors = true end
		inst.components.spellcaster.canonlyuseoncombat = true

		inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(20)

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem") 
		--inst.inventory.imagename = name
		--inst.inventory.atlasname = "images/inventoryimages/" .. name .. ".xml"
		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip( onequip )
		inst.components.equippable:SetOnUnequip( onunequip )

        inst.power = 30 * level
        inst.level = level
        inst.build = build
		
		inst.components.inventoryitem.onputininventoryfn = function(inst, player)
			if player.components.inventory then
				local gowner = inst.components.inventoryitem:GetGrandOwner()
				if gowner.components.inventory and not (gowner:HasTag("akashia")) then
					inst:DoTaskInTime(0.1, function()
						gowner.components.inventory:DropItem(inst)
						if gowner:HasTag("player") then
							gowner.components.talker:Say("I can't use this!")
						end
					end)
				end
			end
		end
		MakeHauntableLaunch(inst)

		return inst
	end


    return Prefab(name, fn, assets)
end

local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        target.components.health:DoDelta(6, nil, "akashia_staff")
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(3, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", TUNING.JELLYBEAN_DURATION)
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(3, OnTick, nil, target)
end

local function CreateBuff(name)
	local function fn()
		local inst = CreateEntity()
	
		if not TheWorld.ismastersim then
			--Not meant for client!
			inst:DoTaskInTime(0, inst.Remove)
	
			return inst
		end
	
		inst.entity:AddTransform()
	
		--[[Non-networked entity]]
		--inst.entity:SetCanSleep(false)
		inst.entity:Hide()
		inst.persists = false
	
		inst:AddTag("CLASSIFIED")
	
		inst:AddComponent("debuff")
		inst.components.debuff:SetAttachedFn(OnAttached)
		inst.components.debuff:SetDetachedFn(inst.Remove)
		inst.components.debuff:SetExtendedFn(OnExtended)
		inst.components.debuff.keepondespawn = true
	
		inst:AddComponent("timer")
		inst.components.timer:StartTimer("regenover", 15)
		inst:ListenForEvent("timerdone", OnTimerDone)
	
		return inst
	end
	return Prefab(name, fn, assets)
end

STRINGS.NAMES.AKASHIA_STAFF1 = "Waning Caregiver's Staff"
STRINGS.NAMES.AKASHIA_STAFF2 = "Waxing Caregiver's Staff"
STRINGS.NAMES.AKASHIA_STAFF3 = "Staff of the Full Moon"
return CreateStaff("akashia_staff1", "staff01", 1),
	   CreateStaff("akashia_staff2", "staff02", 2),
       CreateStaff("akashia_staff3", "staff03", 3),
	   CreateBuff("buff_akashia_staff")


