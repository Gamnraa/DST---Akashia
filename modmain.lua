PrefabFiles = {
	"akashia",
	"akashia_none",
    "akashia_staff"
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

    Asset( "IMAGE", "images/inventoryimages/staff01_inv_images.tex"),
    Asset( "ATLAS", "images/inventoryimages/staff01_inv_images.xml"),

    Asset( "IMAGE", "images/inventoryimages/staff02_inv_images.tex"),
    Asset( "ATLAS", "images/inventoryimages/staff02_inv_images.xml"),

    Asset( "IMAGE", "images/inventoryimages/staff03_inv_images.tex"),
    Asset( "ATLAS", "images/inventoryimages/staff03_inv_images.xml"),
}

AddMinimapAtlas("images/map_icons/akashia.xml")

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

RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/staff01_inv_images.xml"), "staff01_inv_images.tex")
RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/staff02_inv_images.xml"), "staff02_inv_images.tex")
RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/staff03_inv_images.xml"), "staff03_inv_images.tex")


TUNING.AKASHIA_MAX_HEALING = 75
