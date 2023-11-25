local assets =
{
    Asset("ANIM", "anim/staffs_akashia.zip")
}

local castLines = {
  "PSI Shield!"
}
	
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_" .. inst.build, "swap_" .. inst.prefab)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

-----------------------------------------
-- Function that calls when the player attempts to cast a spell with PSI Shield
-- inst - the object instance (The PSI Shield item)
-- target - the target the player is casting the spell on
-----------------------------------------
local function AttemptSpell(inst, target)
	local caster = inst.components.inventoryitem.owner	
    if caster.components.health.current >= inst.power / 2 then

		caster.components.health:DoDelta(-inst.power / 2)
		caster.components.talker:Say(castLines[math.random(#castLines)])
        target.components.health:DoDelta(inst.power)
        if inst.level == 3 then
            print("Heal over time")
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
		inst.AnimState:SetBank("staffs_akashia")
		inst.AnimState:SetBuild(build .. "_ground")
		inst.AnimState:PlayAnimation("idle")
		if not TheWorld.ismastersim then
			return inst
		end
		inst.entity:SetPristine()
		
		inst:AddComponent("spellcaster")	
		inst.components.spellcaster:SetSpellFn(AttemptSpell)
		--inst.components.spellcaster.canuseontargets = true	
		inst.components.spellcaster.canonlyuseonlocomotors = true
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

return CreateStaff("akashia_staff1", "staff01", 1),
	   CreateStaff("akashia_staff2", "staff02", 2),
       CreateStaff("akashia_staff3", "staff03", 3)


