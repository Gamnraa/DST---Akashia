local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.AKASHIA_HEALTH = 150
TUNING.AKASHIA_HUNGER = 150
TUNING.AKASHIA_SANITY = 200

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.AKASHIA = {
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.AKASHIA
end
local prefabs = FlattenTree(start_inv, true)

local function ontemperaturechange(inst, data)
	inst.components.combat.damagemultiplier = 1
	inst.components.sanity.dapperness = 0
	
	local sanitydelta = (TUNING.STARTING_TEMP - data.new)
	if not (sanitydelta > -4 and sanitydelta < 4) then
		sanitydelta = sanitydelta / 100
		local combatmod = 1 + (sanitydelta * -1)
		
		
		--print("sanitydelta", sanitydelta, "combatmod", combatmod)
		inst.components.combat.damagemultiplier = combatmod > 0 and combatmod or .25
		inst.components.sanity.dapperness = sanitydelta
	end
end

local function setcustomrate(inst)
	local delta = 0
	ontemperaturechange(inst, {new = inst.components.temperature.current})
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED)
	
	if inst.components.freezable:IsFrozen() then delta = .5 
	elseif inst.components.burnable:IsBurning() then
		delta = -.5
		inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + 1
		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.75)
		inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.75)
	end
	return delta
end	

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "akashia_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "akashia_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst:AddTag("akashia")
	inst.MiniMapEntity:SetIcon( "akashia.tex" )
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.AKASHIA_HEALTH)
	inst.components.health.fire_damage_scale = TUNING.WILLOW_FIRE_DAMAGE
    
	inst.components.hunger:SetMax(TUNING.AKASHIA_HUNGER)
	inst.components.sanity:SetMax(TUNING.AKASHIA_SANITY)
	inst.components.sanity.custom_rate_fn = setcustomrate
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	inst.components.temperature.inherentinsulation = 75
	inst.components.temperature.inherentsummerinsulation = 75
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("akashia", prefabs, assets, common_postinit, master_postinit, prefabs)
