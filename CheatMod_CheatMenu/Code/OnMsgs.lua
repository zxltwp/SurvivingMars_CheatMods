--[[
g_Classes

--retrieve list of building/vehicle names
local templates = DataInstances.BuildingTemplate
for i = 1, #templates do
  local building = templates[i]
	print(building.name)
  building.dome_forbidden = false
  building.dome_required = false
end

--loop through stuff
#UICity.labels.Colonist
People: Colonist,Homeless,Residence,Unemployed
bld: Building (all),BuildingNoDomes (skips domes, still includes bld inside)
drones/rc: Unit (all),Drone,Rover,RCRover

for _,object in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
  if IsKindOf(object,"Sanatorium") then
    for i = 1, #traits do
      object:SetTrait(i, traits[i])
    end
  end
end

for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
  print(object.encyclopedia_id)
end

for i = 1, #ChoGGi.PositiveTraits do
  colonist:RemoveTrait(ChoGGi.PositiveTraits[i])
end

GetXDialog(
function OnMsg.SelectionChange()
  local dome_to_select = IsKindOf(SelectedObj, "Dome") and SelectedObj or IsObjInDome(SelectedObj)
  UICity:SelectDome(dome_to_select, SelectedObj)
end

function OnMsg.ClassesPreprocess()
end --OnMsg
--]]

function OnMsg.ClassesGenerate()

  --change some building template settings
  for _,building in ipairs(DataInstances.BuildingTemplate) do
    if ChoGGi.CheatMenuSettings.Building_dome_spot then
      building.dome_spot = nil
    end
    if ChoGGi.CheatMenuSettings.Building_dome_forbidden then
      building.dome_spot = nil
    end
    if ChoGGi.CheatMenuSettings.Building_dome_required then
      building.dome_spot = nil
    end
    if ChoGGi.CheatMenuSettings.Building_is_tall then
      building.is_tall = nil
    end
    if ChoGGi.CheatMenuSettings.Building_instant_build then
      --needed else missing textures on domes
      if not (building.build_category == "Domes" or building.template_class == "GeoscapeDome") then
        building.instant_build = true
      end
    end

    if ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id] then
      if building.air then
        building.air.production = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      elseif building.water then
        building.water.production = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      elseif building.electricity then
        building.electricity.production = ChoGGi.CheatMenuSettings.BuildingsProduction[building.encyclopedia_id]
      end
    end

  end

end --OnMsg

function OnMsg.ClassesBuilt()

  --add HiddenX cat for Hidden items
  if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
    table.insert(BuildCategories,{id = "HiddenX",name = T({1000155, "Hidden"}),img = "UI/Icons/bmc_placeholder.tga",highlight_img = "UI/Icons/bmc_placeholder_shine.tga",})
  end
  --build "Cheats/Start Mystery" menu
  --MysteryBase = { AIUprisingMystery, BlackCubeMystery, DiggersMystery, DreamMystery, MarsgateMystery, MirrorSphereMystery, TheMarsBug, UnitedEarthMystery, WorldWar3 }
  --type(g_Classes.DreamMystery.scenario_name)
  ClassDescendantsList("MysteryBase", function(class)
    ChoGGi.AddAction(
      "Cheats/[05]Start Mystery/" .. g_Classes[class].scenario_name .. " " .. _InternalTranslate(T({ChoGGi.MysteryDifficulty[class]})) or "Missing Name",
      function()
        return ChoGGi.StartMystery(class)
      end,
      nil,
      _InternalTranslate(T({ChoGGi.MysteryDescription[class]})) or "Missing Description",
      "DarkSideOfTheMoon.tga"
    )
  end)

  --add preset menu items
  ClassDescendantsList("Preset", function(name, class)
    local preset_class = class.PresetClass or name
    Presets[preset_class] = Presets[preset_class] or {}
    local map = class.GlobalMap
    if map then
      rawset(_G, map, rawget(_G, map) or {})
    end
    UserActions.AddActions({
      [name] = {
        menu = "Presets/" .. name,
        key = class.EditorShortcut or nil,
        icon = class.EditorIcon or nil,
        action = function()
          OpenGedApp(g_Classes[name].GedEditor, Presets[name], {
            PresetClass = name,
            SingleFile = class.SingleFile
          })
        end
      }
    })
  end)

end --OnMsg

function OnMsg.OptionsApply()
  --earliest we can call Consts:GetProperties()
  ChoGGi.ReadSettingsInGame()
end --OnMsg

function OnMsg.ModsLoaded()
  --create logo menu items (needs to be loaded here, so we get logos from other mods)
  local templates = DataInstances.MissionLogo
  for i = 1, #templates do
    ChoGGi.AddAction(
      "Gameplay/QoL/[4]Logo/[" .. i .. "]" .. _InternalTranslate(templates[i].display_name),
      function()
        ChoGGi.SetNewLogo(templates[i].name,_InternalTranslate(templates[i].display_name))
      end,
      nil,
      "Change the logo to ".. _InternalTranslate(templates[i].display_name) .. " for anything that uses the logo.",
      "ViewArea.tga"
    )
  end

  --create Sponsor menus
  local templates = DataInstances.MissionSponsor
  for i = 1, #templates do
    if templates[i].name ~= "random" then
      ChoGGi.AddAction(
        "Gameplay/Sponsors/" .. _InternalTranslate(templates[i].display_name),
        function()
          ChoGGi.SetNewSponsor(templates[i].name,_InternalTranslate(templates[i].display_name))
        end,
        nil,
        _InternalTranslate(templates[i].effect),
        "SelectByClassName.tga"
      )
    end
  end

  --create Commander menus
  local templates = DataInstances.CommanderProfile
  for i = 1, #templates do
    if templates[i].name ~= "random" then
      ChoGGi.AddAction(
        "Gameplay/Commanders/" .. _InternalTranslate(templates[i].display_name),
        function()
          ChoGGi.SetNewCommander(templates[i].name,_InternalTranslate(templates[i].display_name))
        end,
        nil,
        _InternalTranslate(templates[i].effect),
        "SetCamPos&Loockat.tga"
      )
    end
  end

  --number keys to activate build menu
  local skipped = false
  for i = 1, #BuildCategories do
    if i < 10 then
      ChoGGi.AddAction(nil,
        function()
          ChoGGi.ShowBuildMenu(i)
        end,
        tostring(i) --the key has to be a string
      )
    elseif i == 10 then
      ChoGGi.AddAction(nil,
        function()
          ChoGGi.ShowBuildMenu(i)
        end,
        "0"
      )
    else
      --skip Hidden as it'll have the Rocket Landing Site (hard to remove).
      if BuildCategories[i].id == "Hidden" then
        skipped = true
      else
        if skipped then
          ChoGGi.AddAction(nil,
            function()
              ChoGGi.ShowBuildMenu(i)
            end,
            "Shift-" .. i - 11 -- -1 more for skipping Hidden
          )
        else
          ChoGGi.AddAction(nil,
            function()
              ChoGGi.ShowBuildMenu(i)
            end,
            "Shift-" .. i - 10 -- -10 since we're doing Shift-*
          )
        end
      end
    end
  end

end --OnMsg

--saved game is loaded
--function OnMsg.LoadGame(metadata)

--fired as late as we can
function OnMsg.LoadingScreenPreClose()
--function OnMsg.Resume()

  --doubtful, but what the hell
  if not UICity then
    return
  end

  --set shuttle speed/capacity (not sure how to get an onmsg for shuttle spawning)
  for _,object in ipairs(UICity.labels.CargoShuttle or empty_table) do
    if ChoGGi.CheatMenuSettings.ShuttleStorage then
      object.max_shared_storage = ChoGGi.CheatMenuSettings.ShuttleStorage
    end
    if ChoGGi.CheatMenuSettings.ShuttleSpeed then
      object.max_speed = ChoGGi.CheatMenuSettings.ShuttleSpeed
    end
  end

  --drone gravity (not sure how to get an onmsg for drone spawning)
  for _,object in ipairs(UICity.labels.Drone or empty_table) do
    if ChoGGi.CheatMenuSettings.GravityDrone then
      object:SetGravity(ChoGGi.CheatMenuSettings.GravityDrone)
    end
  end

  --so we can change the max_amount for concrete
  for Key,_ in ipairs(TerrainDepositConcrete.properties) do
    local prop = TerrainDepositConcrete.properties[Key]
    if prop.id == "max_amount" then
      prop.read_only = nil
    end
  end

  --limit height of colonists section in info pane, so it doesn't go crazy expand with too many colonists
  XTemplates.sectionResidence[1]["MaxHeight"] = ChoGGi.Consts.ResidenceMaxHeight
  --too bad it clips the little icon in half
  XTemplates.sectionResidence[1]["Clip"] = true

  --show all Mystery Breakthrough buildings
  if ChoGGi.CheatMenuSettings.AddMysteryBreakthroughBuildings then
    UnlockBuilding("DefenceTower")
    UnlockBuilding("CloningVats")
    UnlockBuilding("BlackCubeDump")
    UnlockBuilding("BlackCubeSmallMonument")
    UnlockBuilding("BlackCubeLargeMonument")
    UnlockBuilding("PowerDecoy")
    UnlockBuilding("DomeOval")
  end

  if ChoGGi.CheatMenuSettings.ShowAllTraits then
    g_SchoolTraits = ChoGGi.PositiveTraits
    g_SanatoriumTraits = ChoGGi.NegativeTraits
  end

  --show cheat pane?
  if ChoGGi.CheatMenuSettings.ToggleInfopanelCheats then
    config.BuildingInfopanelCheats = true
    ReopenSelectionXInfopanel()
  end

  --show console log history
  if ChoGGi.CheatMenuSettings.ConsoleToggleHistory then
    ShowConsoleLog(true)
  end

  --dim that console bg
  if ChoGGi.CheatMenuSettings.ConsoleDim then
    config.ConsoleDim = 1
    --make the background hide when console not visible (instead of after a second or two)
    --function ShowConsoleLogBackground(bVisible, bImmediate)
    --ConsoleLog:ShowBackground
    function ConsoleLog.ShowBackground(self,visible, immediate)
      DeleteThread(self.background_thread)
      if visible or immediate then
        self:SetBackground(RGBA(0, 0, 0, visible and 96 or 0))
      else
        self:SetBackground(RGBA(0, 0, 0, 0))
      end
    end
  end

  --setup building template properties
  for _,building in ipairs(DataInstances.BuildingTemplate) do

    --switch hidden buildings to visible
    if ChoGGi.CheatMenuSettings.Building_hide_from_build_menu then
      BuildMenuPrerequisiteOverrides["StorageMysteryResource"] = true
      if building.name ~= "LifesupportSwitch" and building.name ~= "ElectricitySwitch" then
        building.hide_from_build_menu = nil
      end
      if building.build_category == "Hidden" and building.name ~= "RocketLandingSite" then
        building.build_category = "HiddenX"
      end
    end

    if ChoGGi.CheatMenuSettings.Building_wonder then
      building.wonder = nil
    end
  end

  --Residence
  --XTemplates.sectionResidence[1]["MaxHeight"] = 200
  --change some default menu items
  UserActions.RemoveActions({
    --useless without developer tools?
    "BuildingEditor",
    --these will switch the map without asking to save
    "G_ModsEditor",
    "G_OpenPregameMenu",
    --added to toggles
    "G_ToggleInfopanelCheats",
    --changed to refreshe build menu without having to re-open it
    "G_UnlockAllBuildings",
    --broken, I've re-added them
    "StartMysteryAIUprisingMystery",
    "StartMysteryBlackCubeMystery",
    "StartMysteryDiggersMystery",
    "StartMysteryDreamMystery",
    "StartMysteryMarsgateMystery",
    "StartMysteryMirrorSphereMystery",
    "StartMysteryTheMarsBug",
    "StartMysteryUnitedEarthMystery",
    "StartMysteryWorldWar3",
    --move them to help menu
    "DE_Screenshot",
    "UpsampledScreenshot",
    "DE_UpsampledScreenshot",
    "DE_ToggleScreenshotInterface",
    "DisableUIL",
    "G_ToggleInGameInterface",
    "FreeCamera",
    "G_ToggleSigns",
    "G_ToggleOnScreenHints",
    "G_ResetOnScreenHints",
    "DE_BugReport",
  })
  --update menu
  UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

  --always show on my computer
	if ChoGGi.Testing then
    if not dlgUAMenu then
      UAMenu.ToggleOpen()
    end
    --ShowConsole(true)
  end

  --fucking pre-orders
  g_TrailblazerSkins.Drone = "Drone_Trailblazer"
  g_TrailblazerSkins.RCRover = "Rover_Trailblazer"
  g_TrailblazerSkins.RCTransport = "RoverTransport_Trailblazer"
  g_TrailblazerSkins.ExplorerRover = "RoverExplorer_Trailblazer"
  g_TrailblazerSkins.SupplyRocket = "Rocket_Trailblazer"

  --remove some uselessish Cheats to clear up space
  if ChoGGi.CheatMenuSettings.CleanupCheatsInfoPane then
    ChoGGi.InfopanelCheatsCleanup()
  end

  if ChoGGi.CheatMenuSettings.ShowInterfaceInScreenshots then
    hr.InterfaceInScreenshot = 1
  end

  --set zoom/border scrolling
  ChoGGi.SetCameraSettings()

  --show all traits
  if ChoGGi.CheatMenuSettings.SanatoriumSchoolShowAll then
    Sanatorium.max_traits = #ChoGGi.NegativeTraits
    School.max_traits = #ChoGGi.PositiveTraits
  end

  --Commander bonuses
  if ChoGGi.CheatMenuSettings.CommanderInventor then
    ChoGGi.CommanderInventor_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderOligarch then
    ChoGGi.CommanderOligarch_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderHydroEngineer then
    ChoGGi.CommanderHydroEngineer_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderDoctor then
    ChoGGi.CommanderDoctor_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderPolitician then
    ChoGGi.CommanderPolitician_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderAuthor then
    ChoGGi.CommanderAuthor_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderEcologist then
    ChoGGi.CommanderEcologist_Enable()
  end
  if ChoGGi.CheatMenuSettings.CommanderAstrogeologist then
    ChoGGi.CommanderAstrogeologist_Enable()
  end
  --Sponsor bonuses
  if ChoGGi.CheatMenuSettings.SponsorIMM then
    ChoGGi.SponsorIMM_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorNASA then
    ChoGGi.SponsorNASA_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorBlueSun then
    ChoGGi.SponsorBlueSun_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorCNSA then
    ChoGGi.SponsorCNSA_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorISRO then
    ChoGGi.SponsorISRO_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorESA then
    ChoGGi.SponsorESA_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorSpaceY then
    ChoGGi.SponsorSpaceY_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorNewArk then
    ChoGGi.SponsorNewArk_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorRoscosmos then
    ChoGGi.SponsorRoscosmos_Enable()
  end
  if ChoGGi.CheatMenuSettings.SponsorParadox then
    ChoGGi.SponsorParadox_Enable()
  end

  --print startup msgs to console log
  for i = 1, #ChoGGi.StartupMsgs do
    --AddConsoleLog(ChoGGi.StartupMsgs[i],true)
    ConsolePrint(ChoGGi.StartupMsgs[i])
  end

  --people will likely just copy new mod over old, and I moved stuff around
  ChoGGi._VERSION = _G.Mods.ChoGGi_CheatMenu.version
  if ChoGGi._VERSION ~= ChoGGi.CheatMenuSettings._VERSION then
    --clean up
    ChoGGi.RemoveOldFiles()
    --update saved version
    ChoGGi.CheatMenuSettings._VERSION = ChoGGi._VERSION
    ChoGGi.WriteSettings()
  end

end --OnMsg

--if instant_build is on
function OnMsg.BuildingPlaced(building)
  ChoGGi.LastPlacedObj = building
--print(building.encyclopedia_id)
end --OnMsg
function OnMsg.ConstructionSitePlaced(site)
  ChoGGi.LastPlacedObj = site
--print(building.encyclopedia_id)
end --OnMsg

function OnMsg.ConstructionComplete(building)
--print(building.encyclopedia_id)

  if IsKindOf(building,"Arcology") then
    building.capacity = ChoGGi.CheatMenuSettings.ArcologyCapacity

--[[
  elseif IsKindOf(building,"UniversalStorageDepot") then
    if building.encyclopedia_id ~= "UniversalStorageDepot" then
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageOtherDepot
    else
      building.max_storage_per_resource = ChoGGi.CheatMenuSettings.StorageUniversalDepot
    end

  elseif IsKindOf(building,"WasteRockDumpSite") then
    building.max_amount_WasteRock = ChoGGi.CheatMenuSettings.StorageWasteDepot
--]]

  elseif IsKindOf(building,"RCTransportBuilding") then
    if ChoGGi.CheatMenuSettings.RCTransportStorage > 45 then
      building.max_shared_storage = ChoGGi.CheatMenuSettings.RCTransportStorage
    end
    if ChoGGi.CheatMenuSettings.GravityRC then
      building:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
    end

  elseif IsKindOf(building,"RCRoverBuilding") then
    if ChoGGi.CheatMenuSettings.GravityRC then
      building:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
    end

  elseif IsKindOf(building,"RCExplorerBuilding") then
    if ChoGGi.CheatMenuSettings.GravityRC then
      building:SetGravity(ChoGGi.CheatMenuSettings.GravityRC)
    end

  elseif IsKindOf(building,"School") and ChoGGi.CheatMenuSettings.SchoolTrainAll then
    for i = 1, #ChoGGi.PositiveTraits do
      building:SetTrait(i,ChoGGi.PositiveTraits[i])
    end

  elseif IsKindOf(building,"Sanatorium") and ChoGGi.CheatMenuSettings.SanatoriumCureAll then
    for i = 1, #ChoGGi.NegativeTraits do
      building:SetTrait(i,ChoGGi.NegativeTraits[i])
    end
  end

  if ChoGGi.CheatMenuSettings.RemoveMaintenanceBuildUp and building.base_maintenance_build_up_per_hr then
    building.maintenance_build_up_per_hr = -10000
  end

  if ChoGGi.CheatMenuSettings.FullyAutomatedBuildings and building.base_max_workers then
    building.max_workers = 0
    building.automation = 1
    building.auto_performance = 150
  end

  building.can_change_skin = true

  --saved settings for residence capacity
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id] then
    if building.base_capacity then
      building.capacity = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_max_visitors then
      building.max_visitors = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_air_capacity then
      building.air_capacity = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_water_capacity then
      building.water_capacity = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    elseif building.base_max_shuttles then
      building.max_shuttles = ChoGGi.CheatMenuSettings.BuildingsCapacity[building.encyclopedia_id]
    end
  end

end --OnMsg

function OnMsg.ColonistArrived()

  if ChoGGi.CheatMenuSettings.GravityColonist then
    colonist:SetGravity(ChoGGi.CheatMenuSettings.GravityColonist)
  end
  if ChoGGi.CheatMenuSettings.NewColonistSex then
    ChoGGi.ColonistUpdateSex(colonist,ChoGGi.CheatMenuSettings.NewColonistSex)
  end
  if ChoGGi.CheatMenuSettings.NewColonistAge then
    ChoGGi.ColonistUpdateAge(colonist,ChoGGi.CheatMenuSettings.NewColonistAge)
  end

end --OnMsg

function OnMsg.ColonistBorn(colonist)
  if ChoGGi.CheatMenuSettings.GravityColonist then
    colonist:SetGravity(ChoGGi.CheatMenuSettings.GravityColonist)
  end
  if ChoGGi.CheatMenuSettings.NewColonistSex then
    ChoGGi.ColonistUpdateSex(colonist,ChoGGi.CheatMenuSettings.NewColonistSex)
  end
  if ChoGGi.CheatMenuSettings.NewColonistAge then
    ChoGGi.ColonistUpdateAge(colonist,ChoGGi.CheatMenuSettings.NewColonistAge)
  end

end --OnMsg

function OnMsg.SelectionAdded(Object)
  s = Object
end
function OnMsg.SelectedObjChange(Object)
  s = Object
end

--if you pick a mystery from the cheat menu
function OnMsg.MysteryBegin()
  if ChoGGi.CheatMenuSettings.ShowMysteryMsgs then
    ChoGGi.MsgPopup("You've started a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryChosen()
  if ChoGGi.CheatMenuSettings.ShowMysteryMsgs then
    ChoGGi.MsgPopup("You've chosen a mystery!","Mystery","UI/Icons/Logos/logo_13.tga")
  end
end
function OnMsg.MysteryEnd(Outcome)
  if ChoGGi.CheatMenuSettings.ShowMysteryMsgs then
    ChoGGi.MsgPopup(Outcome,"Mystery","UI/Icons/Logos/logo_13.tga")
  end
end

function OnMsg.ApplicationQuit()
  --save any unsaved settings on exit
  if not ChoGGi.Testing then
    ChoGGi.WriteSettings()
  end
end

if ChoGGi.Testing then
  table.insert(ChoGGi.FilesCount,"OnMsgs")
end
