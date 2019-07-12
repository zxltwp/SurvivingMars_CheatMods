return PlaceObj("ModDef", {
	"title", "Stop Auto-Rovers During Storms",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_StopAutoRoversDuringStorms",
	"steam_id", "1796377313",
	"pops_any_uuid", "047b4e7f-37d7-4c89-a600-598339e2d955",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Rovers will not do automated tasks when a meteor storm is active.
They'll finish up whatever task they're on then stop moving till it's over, so you may need to move them out of the way.

Includes mod option to make them go for the nearest working laser/missile tower if they're idle (default on).]],
})