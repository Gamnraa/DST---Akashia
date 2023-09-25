local assets =
{
	Asset( "ANIM", "anim/akashia.zip" ),
	Asset( "ANIM", "anim/ghost_akashia_build.zip" ),
}

local skins =
{
	normal_skin = "akashia",
	ghost_skin = "ghost_akashia_build",
}

return CreatePrefabSkin("akashia_none",
{
	base_prefab = "akashia",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"AKASHIA", "CHARACTER", "BASE"},
	build_name_override = "akashia",
	rarity = "Character",
})