PrefabFiles = {
	"akashia",
	"akashia_none",
    "akashia_staff",
    "altar_akashia"
}

Assets = {
    --[[Asset( "IMAGE", "images/saveslot_portraits/akashia.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/akashia.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/akashia.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/akashia.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/akashia_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/akashia_silho.xml" ),]]
	
	Asset( "IMAGE", "bigportraits/akashia.tex" ),
    Asset( "ATLAS", "bigportraits/akashia.xml" ),
	
    Asset( "IMAGE", "bigportraits/akashia_none.tex" ),
    Asset( "ATLAS", "bigportraits/akashia_none.xml" ),
	
	Asset( "IMAGE", "images/map_icons/akashia.tex" ),
	Asset( "ATLAS", "images/map_icons/akashia.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_akashia.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_akashia.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_akashia.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_akashia.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_akashia.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_akashia.xml" ),
	
	Asset( "IMAGE", "images/names_akashia.tex" ),
    Asset( "ATLAS", "images/names_akashia.xml" ),
	
	Asset( "IMAGE", "images/names_gold_akashia.tex" ),
    Asset( "ATLAS", "images/names_gold_akashia.xml" ),

    Asset( "IMAGE", "images/inventoryimages/akashia_staff1.tex"),
    Asset( "ATLAS", "images/inventoryimages/akashia_staff1.xml"),

    Asset( "IMAGE", "images/inventoryimages/akashia_staff2.tex"),
    Asset( "ATLAS", "images/inventoryimages/akashia_staff2.xml"),

    Asset( "IMAGE", "images/inventoryimages/akashia_staff3.tex"),
    Asset( "ATLAS", "images/inventoryimages/akashia_staff3.xml"),

    Asset( "IMAGE", "images/inventoryimages/altar_akashia.tex"),
    Asset( "ATLAS", "images/inventoryimages/altar_akashia.xml"),

    Asset( "IMAGE", "images/map_icons/altar_akashia.tex"),
    Asset( "ATLAS", "images/map_icons/altar_akashia.xml"),


}

AddMinimapAtlas("images/map_icons/akashia.xml")
AddMinimapAtlas("images/map_icons/altar_akashia.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.akashia = "The Elf Healer"
STRINGS.CHARACTER_NAMES.akashia = "Akashia"
STRINGS.CHARACTER_DESCRIPTIONS.akashia = "*Is a skilled sage\n*Prefers a veggie diet\n*Has empathy for all living things"
STRINGS.CHARACTER_QUOTES.akashia = "\"\""
STRINGS.CHARACTER_SURVIVABILITY.akashia = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.AKASHIA = require "speech_akashia"

-- The character's name as appears in-game 
STRINGS.NAMES.AKASHIA = "Akashia"
STRINGS.SKIN_NAMES.akashia_none = "Akashia"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

--[[RemapSoundEvent( "dontstarve/characters/akashia/death_voice", "akashia/characters/akashia/death_voice" )
RemapSoundEvent( "dontstarve/characters/akashia/hurt", "akashia/characters/akashia/hurt" )
RemapSoundEvent( "dontstarve/characters/akashia/emote", "akashia/characters/akashia/emote" )
RemapSoundEvent( "dontstarve/characters/akashia/yawn", "akashia/characters/akashia/yawn" )
RemapSoundEvent( "dontstarve/characters/akashia/pose", "akashia/characters/akashia/pose" )
RemapSoundEvent( "dontstarve/characters/akashia/ghost_LP", "akashia/characters/akashia/ghost_LP" )
RemapSoundEvent( "dontstarve/characters/akashia/talk_LP", "akashia/characters/akashia/talk_LP" )
RemapSoundEvent( "dontstarve/characters/akashia/carol", "akashia/characters/akashia/carol" )
RemapSoundEvent( "dontstarve/characters/akashia/eye_rub_vo", "akashia/characters/akashia/eye_rub_vo" )
RemapSoundEvent( "dontstarve/characters/akashia/sinking", "akashia/characters//akashia/sinking" )]]

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("akashia", "FEMALE", skin_modes)

RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/akashia_staff1.xml"), "akashia_staff1.tex")
RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/akashia_staff2.xml"), "akashia_staff2.tex")
RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/akashia_staff3.xml"), "akashia_staff3.tex")

TUNING.AKASHIA_HEALTH = 300
TUNING.AKASHIA_SANITY = 125
TUNING.AKASHIA_SANITY = 125
TUNING.AKASHIA_MAX_HEALING = 75
TUNING.ALTAR_AKASHIA_ITEMS = {
    ["petals"] = 1,
    ["seeds"] = 1,
    ["nightmarefuel"] = 25,
    ["livinglog"] = 35
}


AddComponentPostInit("combat", function(cmbt)
    local old_getattacked = cmbt.GetAttacked
    cmbt.GetAttacked = function(self, attacker, damage, weapon, stimuli, spdamage, ...)
        if self.inst:HasTag("AkashiasProtection") then
            if self.inst.akashia and not self.inst.akashia.components.health:IsDead() then
                self.inst.akashia.components.talker:Say("Protected")
                self.inst.akashia.components.health:DoDelta(-damage / 2)
                return old_getattacked(self, attacker, damage / 2, weapon, stimuli, spdamage, ...)
            end
        end
        return old_getattacked(self, attacker, damage, weapon, stimuli, spdamage, ...)
    end
end)

local ActionHandler = GLOBAL.ActionHandler
local ACCEPT_ALTAR_FUEL = AddAction("ALTAR_REFUEL", "Refuel", function(act)
    if act.doer.components.inventory and act.invobject then
        local fuel = act.doer.components.inventory:RemoveItem(act.invobject)
        if fuel and act.target.components.rechargeablealtar.accepting then
            if act.target.components.rechargeablealtar and act.target.components.rechargeablealtar:ReceiveFuel(fuel) then
                return true
            end
        else
            local line = GLOBAL.GetString(act.doer, "ANNOUNCE_AKASHIA_ALTAR_FULL", nil, true) or "It's already charged!"
            if act.doer.components.talker then act.doer.components.talker:Say(line) end
            act.doer.components.inventory:GiveItem(fuel)
            return false
        end
    end
end)

ACCEPT_ALTAR_FUEL.silent_fail = true

AddStategraphActionHandler("wilson", ActionHandler(GLOBAL.ACTIONS.ALTAR_REFUEL, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.ALTAR_REFUEL, "give"))

local function CanGiveAkashiaAltar(inst, doer, target, actions)
    if not (doer.replica.rider and doer.replica.rider:IsRiding())
    or (target.replica.inventoryitem and target.replica.inventoryitem:IsGrandOwner(doer)) then
        if target.components.rechargeablealtar and target.components.rechargeablealtar.accepteditems[inst.prefab] then
            table.insert(actions, GLOBAL.ACTIONS.ALTAR_REFUEL)
        end
    end
end
AddComponentAction("USEITEM", "inspectable", CanGiveAkashiaAltar)

local function OnRespawnFromGhost(inst, data)
    if data.source.prefab == "altar_akashia" then
        inst:DoTaskInTime(4, function() data.source:PushEvent("activateresurrection", inst) end)
    end
end

AddPlayerPostInit(function(inst)
    inst:ListenForEvent("respawnfromghost", OnRespawnFromGhost)
end)

AddPrefabPostInit("altar_akashia_placer", function(inst)
    inst.AnimState:SetScale(2, 2, 2)
end)

AddCharacterRecipe("akashia_staff1",
	{Ingredient("petals", 4),
	 Ingredient("twigs", 4),
     Ingredient("goldnugget", 2),
     Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50)},
	GLOBAL.TECH.NONE,
	{
		product = "akashia_staff1",
		builder_tag = "akashia",
		numtogive = 1,
	},
	{
		"MAGIC",
	})

AddCharacterRecipe("akashia_staff2",
	{Ingredient("akashia_staff1", 1),
     Ingredient("petals_evil", 6),
	 Ingredient("livinglog", 4),
     Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50)},
	GLOBAL.TECH.MAGIC_TWO,
	{
		product = "akashia_staff2",
		builder_tag = "akashia",
		numtogive = 1,
	},
	{
		"MAGIC",
	})

AddCharacterRecipe("akashia_staff3",
	{Ingredient("akashia_staff2", 1),
     Ingredient("greenmooneye", 1),
	 Ingredient("nightmarefuel", 3),
     Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 50)},
	GLOBAL.TECH.MAGIC_THREE,
	{
		product = "akashia_staff3",
		builder_tag = "akashia",
		numtogive = 1,
	},
	{
		"MAGIC",
	})

AddCharacterRecipe("altar_akashia",
    {Ingredient("moonrocknugget", 10),
     Ingredient("marble", 5),
     Ingredient("nightmarefuel", 10),
    },
    GLOBAL.TECH.MAGIC_TWO,
    {
        placer = "altar_akashia_placer",
        builder_tag = "akashia",
        atlas = "images/inventoryimages/altar_akashia.xml",
        image = "altar_akashia.tex"
    })
        

