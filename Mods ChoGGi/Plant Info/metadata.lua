return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 4,
		}),
	},
	"title", "Plant Info",
	"id", "ChoGGi_PlantInfo",
	"lua_revision", 249143,
	"steam_id", "2199536533",
	"pops_any_uuid", "1b7a1351-6444-44b7-b7e3-965e351d2443",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagVegetation", true,
	"TagInterface", true,
	"description", [[Show info when selecting plants (soil quality, type of veg, seed production, seeder).


Requested by Lesandrina.]],
})