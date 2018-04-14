--ChoGGi.AddAction(Menu,Action,Key,Des,Icon)

ChoGGi.AddAction(
  "Gameplay/Buildings/Farm Shifts All On",
  ChoGGi.FarmShiftsAllOn,
  nil,
  "Turns on all the farm shifts.",
  "DisableAOMaps.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Buildings/Production Amount Refresh",
  ChoGGi.SetProductionToSavedAmt,
  nil,
  "Loops through all buildings and checks that production is set to saved amounts.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Production Amount Increase",
  function()
    ChoGGi.SetProduction(true)
  end,
  "Ctrl-Shift-P",
  "Set production of buildings of selected type + 25, also applies to newly placed ones.\nWorks on any building that produces.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Production Amount Default",
  ChoGGi.SetProduction,
  nil,
  function()
    local name
    if SelectedObj then
      name = SelectedObj.encyclopedia_id
    else
      name = "buildings of selected type"
    end
    return "Set production of all " .. tostring(name) .. " to default value."
  end,
  "DisableAOMaps.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Capacity Increase",
  function()
    ChoGGi.SetCapacity(true)
  end,
  "Ctrl-Shift-C",
  "Set capacity of buildings of selected type + 500 (+ 16 for residences), also applies to newly placed ones.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Capacity Default",
  ChoGGi.SetCapacity,
  nil,
  function()
    local name
    if SelectedObj then
      name = SelectedObj.encyclopedia_id
    else
      name = "buildings of selected type"
    end
    return "Set capacity of all " .. tostring(name) .. " to default value."
  end,
  "DisableAOMaps.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Capacity Visitor Increase",
  function()
    ChoGGi.VisitorCapacitySet(true)
  end,
  "Ctrl-Shift-V",
  "Set visitors capacity of all buildings of selected type + 16, also applies to newly placed ones.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Capacity Visitor Default",
  ChoGGi.VisitorCapacitySet,
  nil,
  function()
    local amt
    local name
    if SelectedObj and SelectedObj.base_max_visitors then
      amt = SelectedObj.base_max_visitors
      name = SelectedObj.encyclopedia_id
    else
      amt = "default value"
      name = "buildings of selected type"
    end
    return "Set visitor capacity of all " .. tostring(name) .. " to " .. tostring(amt)
  end,
  "DisableAOMaps.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Universal Depot Increase",
  function()
    ChoGGi.SetStorageDepotSize(true,"StorageUniversalDepot")
  end,
  "Ctrl-Alt-Numpad 1",
  "Set universal depot capacity +1000 (only applies after restarting).",
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Universal Depot Default",
  function()
    ChoGGi.SetStorageDepotSize(nil,"StorageUniversalDepot")
  end,
  nil,
  function()
    return "Set Depot capacity to " .. ChoGGi.Consts.StorageUniversalDepot / ChoGGi.Consts.ResourceScale
  end,
  "ToggleTerrainHeight.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Other Depot Increase",
  function()
    ChoGGi.SetStorageDepotSize(true,"StorageOtherDepot")
  end,
  "Ctrl-Alt-Numpad 2",
  "Set other depot capacity +1000 (only applies after restarting).",
  "ToggleTerrainHeight.tga"
)

ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Other Depot Default",
  function()
    ChoGGi.SetStorageDepotSize(nil,"StorageOtherDepot")
  end,
  nil,
  function()
    return "Set Depot capacity to " .. ChoGGi.Consts.StorageOtherDepot / ChoGGi.Consts.ResourceScale
  end,
  "ToggleTerrainHeight.tga"
)
---------------------
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Waste Depot Increase",
  function()
    ChoGGi.SetStorageDepotSize(true,"StorageWasteDepot")
  end,
  "Ctrl-Alt-Numpad 3",
  "Set waste depot capacity +1000 (only applies after restarting).",
  "ToggleTerrainHeight.tga"
)
ChoGGi.AddAction(
  "Gameplay/Capacity/Storage Waste Depot Default",
  function()
    ChoGGi.SetStorageDepotSize(nil,"StorageWasteDepot")
  end,
  nil,
  function()
    return "Set Depot capacity to " .. ChoGGi.Consts.StorageWasteDepot / ChoGGi.Consts.ResourceScale
  end,
  "ToggleTerrainHeight.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Buildings/Fully Automated Buildings",
  ChoGGi.FullyAutomatedBuildings_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and "(Enabled)" or "(Disabled)"
    return des  .. " No more colonists needed.\nThanks to BoehserOnkel for the idea."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Add Mystery & Breakthrough Buildings",
  ChoGGi.AddMysteryBreakthroughBuildings,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings and "(Enabled)" or "(Disabled)"
    return des .. " Show all the Mystery and Breakthrough buildings in the build menu."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Sanatoriums Cure All",
  ChoGGi.SanatoriumCureAll_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SanatoriumCureAll and "(Enabled)" or "(Disabled)"
    return des .. " Sanatoriums can cure all bad traits."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Schools Train All",
  ChoGGi.SchoolTrainAll_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SchoolTrainAll and "(Enabled)" or "(Disabled)"
    return des .. " Schools can train all good traits."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Sanatoriums & Schools Show Full List",
  ChoGGi.SanatoriumSchoolShowAll,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll and "(Enabled)" or "(Disabled)"
    return des .. " Toggle showing all traits in side pane."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Maintenance Free",
  ChoGGi.MaintenanceBuildingsFree_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp and "(Enabled)" or "(Disabled)"
    return des .. " Buildings don't build up maintenance points."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Moisture Vaporator Penalty",
  ChoGGi.MoistureVaporatorPenalty_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(const.MoistureVaporatorRange,"(Disabled)","(Enabled)")
    return des .. " Disable penalty when Moisture Vaporators are close to each other."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Crop Fail Threshold",
  ChoGGi.CropFailThreshold_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.CropFailThreshold,"(Disabled)","(Enabled)")
    return des .. " Remove Threshold for failing crops."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Cheap Construction",
  ChoGGi.CheapConstruction_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.rebuild_cost_modifier,"(Disabled)","(Enabled)")
    return des .. " Build with minimal resources."
  end,
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Building Damage Crime",
  ChoGGi.BuildingDamageCrime_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.CrimeEventSabotageBuildingsCount,"(Disabled)","(Enabled)")
    return des .. " Disable damage from renegedes to buildings."
  end,
  "DisableAOMaps.tga"
)

--------------------
ChoGGi.AddAction(
  "Gameplay/Buildings/Cables & Pipes: No Chance Of Break",
  ChoGGi.CablesAndPipesNoBreak_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.BreakChanceCablePipe and "(Enabled)" or "(Disabled)"
    return des .. " Cables & pipes will never break."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Cables & Pipes: Instant Repair",
  ChoGGi.CablesAndPipesRepair,
  nil,
  "Instantly repair all broken pipes and cables.",
  "DisableAOMaps.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Cables & Pipes: Instant Build",
  ChoGGi.CablesAndPipesInstant_Toggle,
  nil,
  function()
    local des = ChoGGi.NumRetBool(Consts.InstantCables,"(Enabled)","(Disabled)")
    return des .. " Cables and pipes are built instantly."
  end,
  "DisableAOMaps.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Buildings/Unlimited Wonders",
  ChoGGi.Building_wonder_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_wonder and "(Enabled)" or "(Disabled)"
    return des .. " Unlimited wonder build limit (restart game to toggle)."
  end,
  "toggle_post.tga"
)
ChoGGi.AddAction(
  "Gameplay/Buildings/Build Spires Outside of Spire Point",
  ChoGGi.Building_dome_spot_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_dome_spot and "(Enabled)" or "(Disabled)"
    return des .. " Wonder build limit (restart game to toggle).\nUse with Remove Building Limits to fill up a dome with spires."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Show Hidden Buildings",
  ChoGGi.Building_hide_from_build_menu_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_hide_from_build_menu and "(Enabled)" or "(Disabled)"
    return des .. " Show hidden buildings (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Unlock Dome Forbidden Buildings",
  ChoGGi.Building_dome_forbidden_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_dome_forbidden and "(Enabled)" or "(Disabled)"
    return des .. " Allow buildings forbidden to be placed in dome (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Unlock Dome Required Buildings",
  ChoGGi.Building_dome_required_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_dome_required and "(Enabled)" or "(Disabled)"
    return des .. " Allow buildings required to be placed in dome not to be (restart game to toggle)."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Unlock Tall Buildings Under Pipes",
  ChoGGi.Building_is_tall_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_is_tall and "(Enabled)" or "(Disabled)"
    return des .. " Allow tall buildings to be placed under pipes (restart game to toggle).\nMay also need Remove Building Limits."
  end,
  "toggle_post.tga"
)

ChoGGi.AddAction(
  "Gameplay/Buildings/Instant Build",
  ChoGGi.Building_instant_build_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.Building_instant_build and "(Enabled)" or "(Disabled)"
    return des .. " Allow buildings to be built instantly (restart game to toggle).\nDoesn't work with domes."
  end,
  "toggle_post.tga"
)
--------------------
ChoGGi.AddAction(
  "Gameplay/Buildings/Remove Building Limits",
  ChoGGi.RemoveBuildingLimits_Toggle,
  nil,
  function()
    local des = ChoGGi.CheatMenuSettings.RemoveBuildingLimits and "(Enabled)" or "(Disabled)"
    return des .. " Buildings can be placed almost anywhere (I left uneven terrain blocked, and pipes don't like domes).\nRestart to toggle."
  end,
  "toggle_post.tga"
)
