--funcs under Gameplay menu without a separate file

function ChoGGi.SetDisasterOccurrence(sType,tList)
  local ItemList = {}
  for i = 1, #tList do
    table.insert(ItemList,{
      text = tList[i],
      value = tList[i]
    })
  end

  local CallBackFunc = function(choice)
    mapdata["MapSettings_" .. sType] = sType .. "_" .. choice[1].value
    --apply it?
    UICity:ApplyModificationsFromProperties()

    ChoGGi.MsgPopup(sType .. " occurrence is now: " .. choice[1].value,
      "Disaster","UI/Icons/Sections/attention.tga"
    )
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. " Disaster Occurrences","Current: " .. mapdata["MapSettings_" .. sType])
end

function ChoGGi.MeteorHealthDamage_Toggle()
  ChoGGi.SetConstsG("MeteorHealthDamage",ChoGGi.NumRetBool(Consts.MeteorHealthDamage,0,ChoGGi.Consts.MeteorHealthDamage))
  ChoGGi.SetSavedSetting("MeteorHealthDamage",Consts.MeteorHealthDamage)

  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.MeteorHealthDamage) .. "\nDamage? Total, sir.\nIt's what we call a global killer.\nThe end of mankind. Doesn't matter where it hits. Nothing would survive, not even bacteria.",
   "Colonists","UI/Icons/Notifications/meteor_storm.tga",true
  )
end

function ChoGGi.SetRocketCargoCapacity()
  local DefaultSetting = ChoGGi.GetCargoCapacity()
  local ItemList = {
    {text = " Default: " .. DefaultSetting .. " kg",value = DefaultSetting},
    {text = "50 000 kg",value = 50000},
    {text = "100 000 kg",value = 100000},
    {text = "250 000 kg",value = 250000},
    {text = "500 000 kg",value = 500000},
    {text = "1 000 000 kg",value = 1000000},
    {text = "10 000 000 kg",value = 10000000},
    {text = "100 000 000 kg",value = 100000000},
    {text = "1 000 000 000 kg",value = 1000000000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetConstsG("CargoCapacity",value)
      ChoGGi.SetSavedSetting("CargoCapacity",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": I can still see some space",
       "Rocket","UI/Icons/Sections/spaceship.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Rocket Cargo Capacity","Current capacity: " .. Consts.CargoCapacity)
end

function ChoGGi.SetRocketTravelTime()

  local DefaultSetting = ChoGGi.GetTravelTimeEarthMars() / r
  local r = ChoGGi.Consts.ResourceScale
  local ItemList = {
    {text = " Instant",value = 0},
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = " Original: " .. 750,value = 750},
    {text = " Half of Original: " .. 375,value = 375},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 150,value = 150},
    {text = 200,value = 200},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  --other hint type
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.TravelTimeEarthMars then
    hint = ChoGGi.CheatMenuSettings.TravelTimeEarthMars / r
  end

  local CallBackFunc = function(choice)
    if type(value) == "number" then
      local value = choice[1].value * r
      ChoGGi.SetConstsG("TravelTimeEarthMars",value)
      ChoGGi.SetConstsG("TravelTimeMarsEarth",value)
      ChoGGi.SetSavedSetting("TravelTimeEarthMars",value)
      ChoGGi.SetSavedSetting("TravelTimeMarsEarth",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup("88 MPH: " .. choice[1].text,
        "Rocket","UI/Upgrades/autoregulator_04/timer.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Rocket Travel Time","Current: " .. hint)
end

function ChoGGi.SetColonistsPerRocket()
  local DefaultSetting = ChoGGi.GetMaxColonistsPerRocket()
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 10000,value = 10000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      ChoGGi.SetConstsG("MaxColonistsPerRocket",value)
      ChoGGi.SetSavedSetting("MaxColonistsPerRocket",value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(choice[1].text .. ": Long pig sardines",
        "Rocket","UI/Icons/Notifications/colonist.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set Colonist Capacity","Current capacity: " .. Consts.MaxColonistsPerRocket)
end

function ChoGGi.SetBuildingCapacity()
  if not SelectedObj or (not SelectedObj.base_water_capacity and not SelectedObj.base_air_capacity and not SelectedObj.base_capacity) then
    ChoGGi.MsgPopup("You need to select a building that has capacity.",
      "Building Capacity","UI/Icons/Sections/storage.tga"
    )
    return
  end
  local sel = SelectedObj
  local r = ChoGGi.Consts.ResourceScale
  local hinttoolarge = "Warning For Colonist Capacity: 4K is laggy (above 60K may crash)."

  --get type of capacity
  local CapType
  if sel.base_air_capacity then
    CapType = "air"
  elseif sel.base_water_capacity then
    CapType = "water"
  elseif sel.electricity and sel.electricity.storage_capacity then
    CapType = "electricity"
  elseif sel.colonists then
    CapType = "colonist"
  end

  --get default amount
  local DefaultSetting
  if CapType == "electricity" or CapType == "colonist" then
    DefaultSetting = sel.base_capacity
  else
    DefaultSetting = sel["base_" .. CapType .. "_capacity"]
  end

  if CapType ~= "colonist" then
    DefaultSetting = DefaultSetting / r
  end

  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2000,value = 2000},
    {text = 3000,value = 3000},
    {text = 4000,value = 4000,hint = hinttoolarge},
    {text = 5000,value = 5000,hint = hinttoolarge},
    {text = 10000,value = 10000,hint = hinttoolarge},
    {text = 25000,value = 25000,hint = hinttoolarge},
    {text = 50000,value = 50000,hint = hinttoolarge},
    {text = 100000,value = 100000,hint = hinttoolarge},
  }
  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] then
    hint = ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id]
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      --colonist cap doesn't use res scale
      local amount
      if CapType == "colonist" then
        amount = value
      else
        amount = value * r
      end

      --NewLabel needed to update battery/etc capacity without toggling it?
      local NewLabel
      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = nil
        NewLabel = "full"
      else
        ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = amount
        NewLabel = "charging"
      end

      --updating time
      if CapType == "electricity" then
        for _,building in ipairs(UICity.labels.Power or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building.capacity = amount
            building[CapType].storage_capacity = amount
            building[CapType].storage_mode = NewLabel
            ChoGGi.ToggleWorking(building)
          end
        end

      elseif CapType == "colonist" then
        for _,building in ipairs(UICity.labels.Residence or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building.capacity = amount
          end
        end

      else --water and air
        for _,building in ipairs(UICity.labels["Life-Support"] or empty_table) do
          if building.encyclopedia_id == sel.encyclopedia_id then
            building[CapType .. "_capacity"] = amount
            building[CapType].storage_capacity = amount
            building[CapType].storage_mode = NewLabel
            ChoGGi.ToggleWorking(building)
          end
        end
      end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(sel.encyclopedia_id .. " Capacity is now " .. choice[1].text,
        "Buildings","UI/Icons/Sections/storage.tga"
      )
    end

  end

  hint = "Current capacity: " .. hint .. "\n\n" .. hinttoolarge
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sel.encyclopedia_id .. " Capacity",hint)
end --SetBuildingCapacity

function ChoGGi.SetVisitorCapacity()
  if not SelectedObj and not SelectedObj.base_max_visitors then
    ChoGGi.MsgPopup("You need to select something that has space for visitors.",
     "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
    )
    return
  end
  local sel = SelectedObj
  local DefaultSetting = sel.base_max_visitors
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] then
    hint = ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id]
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      for _,building in ipairs(UICity.labels.BuildingNoDomes or empty_table) do
        if building.encyclopedia_id == sel.encyclopedia_id then
          building.max_visitors = value
        end
      end

      if value == DefaultSetting then
        ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = nil
      else
        ChoGGi.CheatMenuSettings.BuildingsCapacity[sel.encyclopedia_id] = value
      end

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(sel.encyclopedia_id .. " visitor capacity is now " .. choice[1].text,
       "Buildings","UI/Icons/Upgrades/home_collective_04.tga"
      )
    end
  end

  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sel.encyclopedia_id .. " Visitor Capacity","Current capacity: " .. hint)
end

function ChoGGi.SetStorageDepotSize(sType)
  local r = ChoGGi.Consts.ResourceScale
  local DefaultSetting = ChoGGi.Consts[sType] / r
  local hintmax = "Max capacity limited to:\nUniversal: 2,500\nOther: 20,000\nWaste: 1,000,000"
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500,hint = hintmax},
    {text = 5000,value = 5000,hint = hintmax},
    {text = 10000,value = 10000,hint = hintmax},
    {text = 20000,value = 20000,hint = hintmax},
    {text = 100000,value = 100000,hint = hintmax},
  }

  local hint = DefaultSetting
  if ChoGGi.CheatMenuSettings[sType] then
    hint = ChoGGi.CheatMenuSettings[sType] / r
  end

  local CallBackFunc = function(choice)
    if type(choice[1].value) == "number" then

      local value = choice[1].value * r
      --limit amounts so saving with a full load doesn't delete your game
      if sType == "StorageWasteDepot" and value > 1000000000 then
        value = 1000000000 --might be safe above a million, but I figured I'd stop somewhere
      elseif sType == "StorageOtherDepot" and value > 20000000 then
        value = 20000000
      elseif sType == "StorageUniversalDepot" and value > 2500000 then
        value = 2500000 --can go to 2900, but I got a crash; which may have been something else, but it's only 400
      end
      ChoGGi.SetSavedSetting(sType,value)

      ChoGGi.WriteSettings()
      ChoGGi.MsgPopup(sType .. ": " ..  choice[1].text,
        "Storage","UI/Icons/Sections/basic.tga"
      )
    end
  end
  ChoGGi.FireFuncAfterChoice(CallBackFunc,ItemList,"Set " .. sType .. " Size","Current capacity: " .. hint .. "\n\n" .. hintmax)
end

---------all the fixes funcs

function ChoGGi.AttachBuildingsToNearestWorkingDome()
  for _,building in ipairs(UICity.labels.Residence or empty_table) do
    ChoGGi.AttachToNearestDome(building)
  end
  for _,building in ipairs(UICity.labels.Workplace or empty_table) do
    ChoGGi.AttachToNearestDome(building)
  end
  ChoGGi.MsgPopup("Buildings attached.",
    "Buildings","UI/Icons/Sections/basic.tga"
  )
end

function ChoGGi.ColonistsFixBlackCube()
  for _,colonist in ipairs(UICity.labels.Colonist or empty_table) do
    if colonist.entity:find("Child",1,true) then
      colonist.specialist = "none"

      colonist.traits.Youth = nil
      colonist.traits.Adult = nil
      colonist.traits["Middle Aged"] = nil
      colonist.traits.Senior = nil
      colonist.traits.Retiree = nil

      colonist.traits.Child = true
      colonist.age_trait = "Child"
      colonist.age = 0
      colonist:ChooseEntity()
      colonist:SetResidence(false)
      colonist:UpdateResidence()
    end
  end
  ChoGGi.MsgPopup("Fixed black cubes",
   "Colonists","UI/Icons/Upgrades/home_collective_04.tga"
  )
end

function ChoGGi.RepairBrokenShit(BrokenShit)
  local JustInCase = 0
  while #BrokenShit > 0 do

    for i = 1, #BrokenShit do
      pcall(function()
        BrokenShit[i]:Repair()
      end)
    end

    if JustInCase == 10000 then
      break
    end
    JustInCase = JustInCase + 1

  end
end

function ChoGGi.CablesAndPipesRepair()
  ChoGGi.RepairBrokenShit(g_BrokenSupplyGridElements.electricity)
  ChoGGi.RepairBrokenShit(g_BrokenSupplyGridElements.water)
end

function ChoGGi.CablesAndPipesInstant_Toggle()
  ChoGGi.SetConstsG("InstantCables",ChoGGi.ToggleBoolNum(Consts.InstantCables))
  ChoGGi.SetConstsG("InstantPipes",ChoGGi.ToggleBoolNum(Consts.InstantPipes))

  ChoGGi.SetSavedSetting("InstantCables",Consts.InstantCables)
  ChoGGi.SetSavedSetting("InstantPipes",Consts.InstantPipes)
  ChoGGi.WriteSettings()
  ChoGGi.MsgPopup(tostring(ChoGGi.CheatMenuSettings.InstantCables) .. " Aliens? We gotta deal with aliens too?",
   "Cables & Pipes","UI/Icons/Notifications/timer.tga"
  )
end

--TESTING
--[[
function ChoGGi.RCRoverRadius(Bool)
  for _,rcvehicle in ipairs(UICity.labels.RCRover or empty_table) do
    local prop_meta = rcvehicle:GetPropertyMetadata("UIWorkRadius")
    if prop_meta then
      if Bool == true then
        local radius = rcvehicle:GetProperty(prop_meta.id)
        rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
      else
        rcvehicle:SetProperty(prop_meta.id, Max(prop_meta.max,ChoGGi.Consts.RCRoverMaxRadius))
      end
    end
  end
  ChoGGi.MsgPopup("+25 I can see for miles and miles",
   "RC","UI/Icons/Upgrades/service_bots_04.tga"
  )
end

function ChoGGi.CommandCenterRadius(Bool)
  for _,building in ipairs(UICity.labels.DroneHub) do
    local prop_meta = building:GetPropertyMetadata("UIWorkRadius")
    if prop_meta then
      if Bool == true then
        const.CommandCenterDefaultRadius = const.CommandCenterDefaultRadius + 25
        const.CommandCenterMaxRadius = const.CommandCenterMaxRadius + 25
        const.CommandCenterMinRadius = const.CommandCenterMinRadius + 25
        local radius = building:GetProperty(prop_meta.id)
        building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
        building:SetProperty(prop_meta.id, Default(prop_meta.default, radius + 25))
        building:SetProperty(prop_meta.id, Min(prop_meta.min, radius + 25))
      else
        const.CommandCenterDefaultRadius = ChoGGi.Consts.CommandCenterDefaultRadius
        const.CommandCenterMaxRadius = ChoGGi.Consts.CommandCenterMaxRadius
        const.CommandCenterMinRadius = ChoGGi.Consts.CommandCenterMinRadius
        building:SetProperty(prop_meta.id, Default(prop_meta.default, const.CommandCenterDefaultRadius))
        building:SetProperty(prop_meta.id, Max(prop_meta.max, const.CommandCenterMaxRadius))
        building:SetProperty(prop_meta.id, Min(prop_meta.min, const.CommandCenterMinRadius))
      end
    end
  end
  ChoGGi.MsgPopup("I see you there",
   "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end

function ChoGGi.TriboelectricScrubberRadius(Bool)
  for _,building in ipairs(UICity.labels.TriboelectricScrubber) do
    local prop_meta = building:GetPropertyMetadata("UIRange")
    if prop_meta then
      if Bool == true then
        local radius = building:GetProperty(prop_meta.id)
        building:SetProperty(prop_meta.id, Max(prop_meta.max, radius + 25))
      else
        building:SetProperty(prop_meta.id, Max(prop_meta.max,5)) --figure out default const to put here
      end
    end
  end
  ChoGGi.MsgPopup("I see you there",
   "Buildings","UI/Icons/Upgrades/polymer_blades_04.tga"
  )
end
--]]