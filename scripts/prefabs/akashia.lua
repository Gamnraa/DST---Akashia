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

local function updateentitiesinrange(inst)
	local pos = inst:GetPosition()
	for _, v in pairs(inst.entsProtecting) do
		v.akashia = nil
		v:RemoveTag("AkashiasProtection")
	end
	inst.entsProtecting = {}
	for _, v in pairs(TheSim:FindEntities(pos.x, pos.y, pos.z, 3, {"_combat", "player"}, {"playerghost"})) do
		if v ~= inst then
			v.akashia = inst
			v:AddTag("AkashiasProtection")
			table.insert(inst.entsProtecting, v)
		end
	end
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
	inst.components.hunger:SetMax(TUNING.AKASHIA_HUNGER)
	inst.components.sanity:SetMax(TUNING.AKASHIA_SANITY)
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload

	inst.entsProtecting = {}
	inst:DoPeriodicTask(1, function() updateentitiesinrange(inst) end)
	
end

return MakePlayerCharacter("akashia", prefabs, assets, common_postinit, master_postinit, prefabs)
