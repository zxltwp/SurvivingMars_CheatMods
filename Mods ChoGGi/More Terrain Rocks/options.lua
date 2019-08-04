-- max 40 chars
DefineClass("ModOptions_ChoGGi_MoreTerrainRocks", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = 10,
			max = 250,
			min = 1,
			editor = "number",
			id = "LargeRocksCost",
			name = T(302535920011435, "Cost of large rocks"),
		},
	},
})