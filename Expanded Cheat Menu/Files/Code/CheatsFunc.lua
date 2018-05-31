--See LICENSE for terms

local UsualIcon = "UI/Icons/Notifications/research.tga"

function ChoGGi.MenuFuncs.OpenModEditor()
  local CallBackFunc = function()
    ModEditorOpen()
  end
  ChoGGi.ComFuncs.QuestionBox(
    "Warning!\nSave your game.\nThis will switch to a new map.",
    CallBackFunc,
    "Warning: Mod Editor",
    "Okay (change map)"
  )
end

function ChoGGi.MenuFuncs.ResetAllResearch()
  local CallBackFunc = function()
    UICity:InitResearch()
  end
  ChoGGi.ComFuncs.QuestionBox(
    "Warning!\nAre you sure you want to reset all research (includes breakthrough tech)?\n\nBuildings are still unlocked.",
    CallBackFunc,
    "Warning!"
  )
end

function ChoGGi.MenuFuncs.DisasterTriggerMissle(Amount)
  Amount = Amount or 1
  --(obj, radius, count, delay_min, delay_max)
  StartBombard(
    ChoGGi.CodeFuncs.SelObject() or GetTerrainCursor(),
    0,
    Amount
  )
end
function ChoGGi.MenuFuncs.DisasterTriggerColdWave()
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_ColdWave
    local descr = data[mapdata.MapSettings_ColdWave] or data.ColdWave_VeryLow
    StartColdWave(descr)
  end)
end
function ChoGGi.MenuFuncs.DisasterTriggerDustStorm(storm_type)
  CreateGameTimeThread(function()
    local data = DataInstances.MapSettings_DustStorm
    local descr = data[mapdata.MapSettings_DustStorm] or data.DustStorm_VeryLow
    StartDustStorm(storm_type,descr)
  end)
end
function ChoGGi.MenuFuncs.DisasterTriggerDustDevils(major)
  local data = DataInstances.MapSettings_DustDevils
  local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  GenerateDustDevil(GetTerrainCursor(), descr, nil, major):Start()
end
function ChoGGi.MenuFuncs.DisasterTriggerMeteor(meteors_type)
  local data = DataInstances.MapSettings_Meteor
  local descr = data[mapdata.MapSettings_Meteor] or data.Meteor_VeryLow
  CreateGameTimeThread(function()
    MeteorsDisaster(descr, meteors_type, GetTerrainCursor())
  end)
end
function ChoGGi.MenuFuncs.DisastersStop()
  for Key,_ in pairs(g_IncomingMissiles or empty_table) do
    Key:ExplodeInAir()
  end
  if g_DustStorm then
    StopDustStorm()
  end
  if g_ColdWave then
    StopColdWave()
  end
end

function ChoGGi.MenuFuncs.MeteorsDestroy()
  --causes error msgs for next ones (seems to work fine, but still)
  local mp = g_MeteorsPredicted
  while #mp > 0 do
    for i = 1, #mp do
      pcall(function()
        --Msg("MeteorIntercepted", mp[i], MeteorInterceptRocket.shooter)
        Msg("MeteorIntercepted", mp[i])
        mp[i]:ExplodeInAir()
      end)
    end
  end
end

function ChoGGi.MenuFuncs.DisastersTrigger()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = " Stop Most Disasters",value = "Stop",hint = "Can't stop meteors."},
    {text = " Remove Broken Meteors",value = "MeteorsDestroy",hint = "If you have some continuous spinning meteors. It might put some error msgs in console, but I didn't notice any other issues."},
    {text = "Cold Wave",value = "ColdWave"},
    {text = "Dust Devil Major",value = "DustDevilsMajor"},
    {text = "Dust Devil",value = "DustDevils"},
    {text = "Dust Storm Electrostatic",value = "DustStormElectrostatic"},
    {text = "Dust Storm Great",value = "DustStormGreat"},
    {text = "Dust Storm",value = "DustStorm"},
    {text = "Meteor Storm",value = "MeteorStorm"},
    {text = "Meteor Multi-Spawn",value = "MeteorMultiSpawn"},
    {text = "Meteor",value = "Meteor"},
    {text = "Missle 1",value = "Missle1"},
    {text = "Missle 10",value = "Missle10"},
    {text = "Missle 100",value = "Missle100"},
    {text = "Missle 500",value = "Missle500",hint = "Might be a little laggy"},
  }

  local CallBackFunc = function(choice)
    for i = 1, #choice do
      local value = choice[i].value
      if value == "Stop" then
        ChoGGi.MenuFuncs.DisastersStop()
      elseif value == "MeteorsDestroy" then
        ChoGGi.MenuFuncs.MeteorsDestroy()
      elseif value == "ColdWave" then
        ChoGGi.MenuFuncs.DisasterTriggerColdWave()

      elseif value == "DustDevilsMajor" then
        ChoGGi.MenuFuncs.DisasterTriggerDustDevils("major")
      elseif value == "DustDevils" then
        ChoGGi.MenuFuncs.DisasterTriggerDustDevils()

      elseif value == "DustStormElectrostatic" then
        ChoGGi.MenuFuncs.DisasterTriggerDustStorm("electrostatic")
      elseif value == "DustStormGreat" then
        ChoGGi.MenuFuncs.DisasterTriggerDustStorm("great")
      elseif value == "DustStorm" then
        ChoGGi.MenuFuncs.DisasterTriggerDustStorm("normal")

      elseif value == "MeteorStorm" then
        ChoGGi.MenuFuncs.DisasterTriggerMeteor("storm")
      elseif value == "MeteorMultiSpawn" then
        ChoGGi.MenuFuncs.DisasterTriggerMeteor("multispawn")
      elseif value == "Meteor" then
        ChoGGi.MenuFuncs.DisasterTriggerMeteor("single")

      elseif value == "Missle1" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(1)
      elseif value == "Missle10" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(10)
      elseif value == "Missle100" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(100)
      elseif value == "Missle500" then
        ChoGGi.MenuFuncs.DisasterTriggerMissle(500)
      end
      ChoGGi.ComFuncs.MsgPopup(choice[i].text,"Disasters")
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Trigger Disaster",
    hint = "Targeted to mouse cursor (use arrow keys to select and enter to start, Ctrl/Shift to multi-select).",
    multisel = true,
  })
end

function ChoGGi.MenuFuncs.ShowScanAndMapOptions()
  local ChoGGi = ChoGGi
  local Msg = Msg
  local UICity = UICity
  local hint_core = "Core: Repeatable, exploit core resources."
  local hint_deep = "Deep: Toggleable, exploit deep resources."
  local ItemList = {
    {text = " All",value = 1,hint = hint_core .. "\n" .. hint_deep},
    {text = " Deep",value = 2,hint = hint_deep},
    {text = " Core",value = 3,hint = hint_core},
    {text = "Deep Scan",value = 4,hint = hint_deep .. "\nEnabled: " .. Consts.DeepScanAvailable},
    {text = "Deep Water",value = 5,hint = hint_deep .. "\nEnabled: " .. Consts.IsDeepWaterExploitable},
    {text = "Deep Metals",value = 6,hint = hint_deep .. "\nEnabled: " .. Consts.IsDeepMetalsExploitable},
    {text = "Deep Precious Metals",value = 7,hint = hint_deep .. "\nEnabled: " .. Consts.IsDeepPreciousMetalsExploitable},
    {text = "Core Water",value = 8,hint = hint_core},
    {text = "Core Metals",value = 9,hint = hint_core},
    {text = "Core Precious Metals",value = 10,hint = hint_core},
    {text = "Alien Imprints",value = 11,hint = hint_core},
    {text = "Reveal Map",value = 12,hint = "Reveals the map squares"},
    {text = "Reveal Map (Deep)",value = 13,hint = "Reveals the map and \"Deep\" resources"},
  }

  local CallBackFunc = function(choice)
    local function deep()
      ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
    end
    local function core()
      Msg("TechResearched","CoreWater", UICity)
      Msg("TechResearched","CoreMetals", UICity)
      Msg("TechResearched","CoreRareMetals", UICity)
      Msg("TechResearched","AlienImprints", UICity)
    end

    local value
    for i=1,#choice do
      value = choice[i].value
      print(value)
      if value == 1 then
        CheatMapExplore("deep scanned")
        deep()
        core()
      elseif value == 2 then
        deep()
      elseif value == 3 then
        core()
      elseif value == 4 then
        ChoGGi.ComFuncs.SetConstsG("DeepScanAvailable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.DeepScanAvailable))
      elseif value == 5 then
        ChoGGi.ComFuncs.SetConstsG("IsDeepWaterExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepWaterExploitable))
      elseif value == 6 then
        ChoGGi.ComFuncs.SetConstsG("IsDeepMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepMetalsExploitable))
      elseif value == 7 then
        ChoGGi.ComFuncs.SetConstsG("IsDeepPreciousMetalsExploitable",ChoGGi.ComFuncs.ToggleBoolNum(Consts.IsDeepPreciousMetalsExploitable))
      elseif value == 8 then
        Msg("TechResearched","CoreWater", UICity)
      elseif value == 9 then
        Msg("TechResearched","CoreMetals", UICity)
      elseif value == 10 then
        Msg("TechResearched","CoreRareMetals", UICity)
      elseif value == 11 then
        Msg("TechResearched","AlienImprints", UICity)
      elseif value == 12 then
        CheatMapExplore("scanned")
      elseif value == 13 then
        CheatMapExplore("deep scanned")
      end
    end
    ChoGGi.ComFuncs.SetSavedSetting("DeepScanAvailable",Consts.DeepScanAvailable)
    ChoGGi.ComFuncs.SetSavedSetting("IsDeepWaterExploitable",Consts.IsDeepWaterExploitable)
    ChoGGi.ComFuncs.SetSavedSetting("IsDeepMetalsExploitable",Consts.IsDeepMetalsExploitable)
    ChoGGi.ComFuncs.SetSavedSetting("IsDeepPreciousMetalsExploitable",Consts.IsDeepPreciousMetalsExploitable)

    ChoGGi.SettingFuncs.WriteSettings()
    ChoGGi.ComFuncs.MsgPopup("Alice thought to herself \"Now you will see a film... made for children... perhaps... \" But, I nearly forgot... you must... close your eyes... otherwise... you won't see anything.",
      "Scanner","UI/Achievements/TheRabbitHole.tga",true
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Scan Map",
    hint = "You can select multiple items.",
    multisel = true,
  })
end

function ChoGGi.MenuFuncs.SpawnColonists()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = 1,value = 1},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 75,value = 75},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      CheatSpawnNColonists(value)
      ChoGGi.ComFuncs.MsgPopup("Spawned: " .. choice[1].text,
        "Colonists","UI/Icons/Sections/colonist.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Spawn Colonists",
    hint = "Colonist placing priority: Selected dome, Evenly between domes, or centre of map if no domes.",
  })
end

function ChoGGi.MenuFuncs.ShowMysteryList()
  local ChoGGi = ChoGGi
  local ItemList = {}
  for i = 1, #ChoGGi.Tables.Mystery do
    ItemList[#ItemList+1] = {
      text = ChoGGi.Tables.Mystery[i].number .. ": " .. ChoGGi.Tables.Mystery[i].name,
      value = ChoGGi.Tables.Mystery[i].class,
      hint = ChoGGi.Tables.Mystery[i].description
    }
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if choice[1].check1 then
      --instant
      ChoGGi.MenuFuncs.StartMystery(value,true)
    else
      ChoGGi.MenuFuncs.StartMystery(value)
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Start A Mystery",
    hint = "Warning: Adding a mystery is cumulative, this will NOT replace existing mysteries.",
    check1 = "Instant Start",
    check1_hint = "May take up to one Sol to \"instantly\" activate mystery.",
  })
end

function ChoGGi.MenuFuncs.StartMystery(Mystery,Instant)
  local ChoGGi = ChoGGi
  local UICity = UICity
  --inform people of actions, so they don't add a bunch of them
  ChoGGi.UserSettings.ShowMysteryMsgs = true

  UICity.mystery_id = Mystery
  local tree = TechTree
  for i = 1, #tree do
    local field = tree[i]
    local field_id = field.id
    --local costs = field.costs or empty_table
    local list = UICity.tech_field[field_id] or {}
    UICity.tech_field[field_id] = list
    local tab = field or empty_table
    for j = 1, #tab do
      if tab[j].mystery == Mystery then
        local tech_id = tab[j].id
        list[#list+1] = tech_id
        UICity.tech_status[tech_id] = {points = 0, field = field_id}
        tab[j]:Initialize(UICity)
      end
    end
  end
  UICity:InitMystery()
  --might help
  if UICity.mystery then
    UICity.mystery_id = UICity.mystery.class
    UICity.mystery:ApplyMysteryResourceProperties()
  end

  --instant start
  if Instant then
    local seqs = UICity.mystery.seq_player.seq_list[1]
    for i = 1, #seqs do
      local seq = seqs[i]
      if seq.class == "SA_WaitExpression" then
        seq.duration = 0
        seq.expression = nil
      elseif seq.class == "SA_WaitMarsTime" then
        seq.duration = 0
        seq.rand_duration = 0
        break
      end
    end
  end

  --needed to start mystery
  UICity.mystery.seq_player:AutostartSequences()
end



--loops through all the sequence and adds the logs we've already seen
local function ShowMysteryLog(MystName)
  local ChoGGi = ChoGGi
  local msgs = {MystName .. "\n\nTo play back speech use \"Exec\" button and type in\ng_Voice:Play(ChoGGi.CurObj.speech)\n"}
  local Players = s_SeqListPlayers or empty_table
  -- 1 is some default map thing
  if #Players == 1 then
    return
  end
  for i = 1, #Players do
    if i > 1 then
      local seq_list = Players[i].seq_list
      if seq_list.name == MystName then
        for j = 1, #seq_list do
          local scenarios = seq_list[j]
          local state = Players[i].seq_states[scenarios.name]
          --have we started this seq yet?
          if state then
            local ip = state and (state.ip or state.end_ip or 10000)
            for k = 1, #scenarios do
              local seq = scenarios[k]
              if seq.class == "SA_WaitMessage" then
                --add to msg list
                msgs[#msgs+1] = {
                  [" "] = "Speech: " .. ChoGGi.CodeFuncs.Trans(seq.voiced_text) .. "\n\n\n\nMessage: " .. ChoGGi.CodeFuncs.Trans(seq.text),
                  speech = seq.voiced_text,
                  class = ChoGGi.CodeFuncs.Trans(seq.title)
                }
              end
            end
          end
        end
      end
    end
  end
  --display to user
  local ex = Examine:new()
  ex:SetPos(point(550,100))
  ex:SetObj(msgs)
end

function ChoGGi.MenuFuncs.ShowStartedMysteryList()
  local ChoGGi = ChoGGi
  local ItemList = {}
  local PlayerList = s_SeqListPlayers
  for i = 1, #PlayerList do
    --1 is always there from map loading
    if i > 1 then
      local seq_list = PlayerList[i].seq_list
      local totalparts = #seq_list[1]
      local id = seq_list.name
      local ip = PlayerList[i].seq_states[seq_list[1].name].ip

      ItemList[#ItemList+1] = {
        text = id .. ": " .. ChoGGi.Tables.Mystery[id].name,
        value = id,
        func = id,
        seed = PlayerList[i].seed,
        hint = ChoGGi.Tables.Mystery[id].description .. "\n\n<color 255 75 75>Total parts</color>: " .. totalparts .. " <color 255 75 75>Current part</color>: " .. (ip or "done?")
      }
    end
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    local seed = choice[1].seed
    if choice[1].check2 then
      --remove all
      for i = #PlayerList, 1, -1 do
        if i > 1 then
          PlayerList[i]:delete()
        end
      end
      for Thread in pairs(ThreadsMessageToThreads) do
        if Thread.player and Thread.player.seq_list.file_name then
          DeleteThread(Thread.thread)
        end
      end
      ChoGGi.ComFuncs.MsgPopup("Removed all!","Mystery")
    elseif choice[1].check1 then
      --remove mystery
      for i = #PlayerList, 1, -1 do
        if PlayerList[i].seed == seed then
          PlayerList[i]:delete()
        end
      end
      for Thread in pairs(ThreadsMessageToThreads) do
        if Thread.player and Thread.player.seed == seed then
          DeleteThread(Thread.thread)
        end
      end
      ChoGGi.ComFuncs.MsgPopup("Mystery: " .. choice[1].text .. " Removed!","Mystery")
    elseif value then
      --next step
      ChoGGi.MenuFuncs.NextMysterySeq(value,seed)
    end

  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Manage",
    hint = "Skip the timer delay, and optionally skip the requirements (applies to all mysteries that are the same type).\n\nSequence part may have more then one check, you may have to skip twice or more.\n\nDouble right-click selected mystery to review past messages.",
    check1 = "Remove",
    check1_hint = "This will remove the mystery, if you start it again; it'll be back to the start.",
    check2 = "Remove All",
    check2_hint = "Warning: This will remove all the mysteries!",
    custom_type = 6,
    custom_func = ShowMysteryLog,
  })
end
--[[
  local idx = 0
  for Thread in pairs(ThreadsMessageToThreads) do
    if Thread.thread and IsValidThread(Thread.thread) then
      idx = idx + 1
      print("idx " .. idx)
    end
  end
--]]
--ex(s_SeqListPlayers)
function ChoGGi.MenuFuncs.NextMysterySeq(Mystery,seed)
  local ChoGGi = ChoGGi
  local UICity = UICity
  local ThreadsMessageToThreads = ThreadsMessageToThreads
  local DeleteThread = DeleteThread
  local SA_WaitMarsTime = SA_WaitMarsTime
  local Msg = Msg

  local warning = "\n\nClick \"Ok\" to skip requirements (Warning: may cause issues later on, untested)."
  local name = "Mystery: " .. ChoGGi.Tables.Mystery[Mystery].name

  for Thread in pairs(ThreadsMessageToThreads) do
    if Thread.player and Thread.player.seed == seed then

      --only remove finished waittime threads, can cause issues removing other threads
      if Thread.finished == true and (Thread.action.class == "SA_WaitMarsTime" or Thread.action.class == "SA_WaitTime" or Thread.action.class == "SA_RunSequence") then
        DeleteThread(Thread.thread)
      end

      local Player = Thread.player
      local seq_list = Thread.sequence
      local state = Player.seq_states
      local ip = state[seq_list.name].ip

      for i = 1, #seq_list do
        --skip older seqs
        if i >= ip then
          local seq = seq_list[i]
          local title = name .. " Part: " .. ip

          --seqs that add delays/tasks
          if seq.class == "SA_WaitMarsTime" or seq.class == "SA_WaitTime" then
            ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed}
            --we don't want to wait
            seq.wait_type = SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
            seq.wait_subtype = SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
            seq.loops = SA_WaitMarsTime:GetDefaultPropertyValue("loops")
            seq.duration = 1
            seq.rand_duration = 1
            local wait = Thread.action
            wait.wait_type = SA_WaitMarsTime:GetDefaultPropertyValue("wait_type")
            wait.wait_subtype = SA_WaitMarsTime:GetDefaultPropertyValue("wait_subtype")
            wait.loops = SA_WaitMarsTime:GetDefaultPropertyValue("loops")
            wait.duration = 1
            wait.rand_duration = 1

            Thread.finished = true
            --Thread.action:EndWait(Thread)
            --may not be needed
            Player:UpdateCurrentIP(seq_list)
            --let them know
            ChoGGi.ComFuncs.MsgPopup("Timer delay removed (may take upto a Sol).",title)
            break

          elseif seq.class == "SA_WaitExpression" then
            seq.duration = 0
            local CallBackFunc = function()
              seq.expression = nil
              --the first SA_WaitExpression always has a SA_WaitMarsTime, if they're skipping the first then i doubt they want this
              if i == 1 or i == 2 then
                ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed,again = true}
              else
                ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed}
              end

              Thread.finished = true
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              "Advancement requires: " .. tostring(seq.expression) .. "\n\nTime duration has been set to 0 (you still need to complete the requirements).\n\nWait for a Sol or two for it to update (should give a popup msg)." .. warning,
              CallBackFunc,
              title
            )
            break

          elseif seq.class == "SA_WaitMsg" then
            local CallBackFunc = function()
              ChoGGi.Temp.SA_WaitMarsTime_StopWait = {seed = seed,again = true}
              --send fake msg (ok it's real, but it hasn't happened)
              Msg(seq.msg)
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              "Advancement requires: " .. tostring(seq.msg) .. warning,
              CallBackFunc,
              title
            )
            break

          elseif seq.class == "SA_WaitResearch" then
            local CallBackFunc = function()
              GrantTech(seq.Research)

              Thread.finished = true
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              "Advancement requires: " .. tostring(seq.Research).. warning,
              CallBackFunc,
              title
            )

          elseif seq.class == "SA_RunSequence" then
            local CallBackFunc = function()
              seq.wait = false
              Thread.finished = true
              Player:UpdateCurrentIP(seq_list)
            end
            ChoGGi.ComFuncs.QuestionBox(
              "Waiting for " .. seq.sequence .. " to finish.\n\nSkip it?",
              CallBackFunc,
              title
            )

          end -- if seq type

        end --if i >= ip
      end --for seq_list

    end --if mystery thread
  end --for Thread

end

function ChoGGi.MenuFuncs.UnlockAllBuildings()
  CheatUnlockAllBuildings()
  RefreshXBuildMenu()
  ChoGGi.ComFuncs.MsgPopup("Unlocked all buildings for construction.",
    "Buildings","UI/Icons/Upgrades/build_2.tga"
  )
end

function ChoGGi.MenuFuncs.AddResearchPoints()
  local ChoGGi = ChoGGi
  local ItemList = {
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
    {text = 1000,value = 1000},
    {text = 2500,value = 2500},
    {text = 5000,value = 5000},
    {text = 10000,value = 10000},
    {text = 25000,value = 25000},
    {text = 50000,value = 50000},
    {text = 100000,value = 100000},
    {text = 100000000,value = 100000000},
  }

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then
      UICity:AddResearchPoints(value)
      ChoGGi.ComFuncs.MsgPopup("Added: " .. choice[1].text,
        "Research","UI/Icons/Upgrades/eternal_fusion_04.tga"
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Add Research Points",
    hint = "If you need a little boost (or a lotta boost) in research.",
  })
end

function ChoGGi.MenuFuncs.OutsourcingFree_Toggle()
  local ChoGGi = ChoGGi
  ChoGGi.ComFuncs.SetConstsG("OutsourceResearchCost",ChoGGi.ComFuncs.NumRetBool(Consts.OutsourceResearchCost) and 0 or ChoGGi.Consts.OutsourceResearchCost)

  ChoGGi.ComFuncs.SetSavedSetting("OutsourceResearchCost",Consts.OutsourceResearchCost)
  ChoGGi.SettingFuncs.WriteSettings()
  ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.OutsourceResearchCost) .. "\nBest hope you picked India as your Mars sponsor",
    "Research","UI/Icons/Sections/research_1.tga",true
  )
end

local hint_maxa = "Max amount in UICity.tech_field list, you could make the amount larger if you want (an update/mod can add more)."
function ChoGGi.MenuFuncs.SetBreakThroughsOmegaTelescope()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.OmegaTelescopeBreakthroughsCount
  local MaxAmount = #UICity.tech_field.Breakthroughs
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 6,value = 6},
    {text = 12,value = 12},
    {text = 24,value = 24},
    {text = MaxAmount,value = MaxAmount,hint = hint_maxa},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount then
    hint = ChoGGi.UserSettings.OmegaTelescopeBreakthroughsCount
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      const.OmegaTelescopeBreakthroughsCount = value
      ChoGGi.ComFuncs.SetSavedSetting("OmegaTelescopeBreakthroughsCount",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": Research is what I'm doing when I don't know what I'm doing.",
        "Omega",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "BreakThroughs From Omega",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetBreakThroughsAllowed()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.BreakThroughTechsPerGame
  local MaxAmount = #UICity.tech_field.Breakthroughs
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 26,value = 26,hint = "Doubled the base amount."},
    {text = MaxAmount,value = MaxAmount,hint = hint_maxa},
  }

  local hint = DefaultSetting
  if ChoGGi.UserSettings.BreakThroughTechsPerGame then
    hint = ChoGGi.UserSettings.BreakThroughTechsPerGame
  end

  local CallBackFunc = function(choice)

    local value = choice[1].value
    if type(value) == "number" then
      const.BreakThroughTechsPerGame = value
      ChoGGi.ComFuncs.SetSavedSetting("BreakThroughTechsPerGame",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(choice[1].text .. ": S M R T",
        "Research",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "BreakThroughs Allowed",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.SetResearchQueueSize()
  local ChoGGi = ChoGGi
  local DefaultSetting = ChoGGi.Consts.ResearchQueueSize
  local ItemList = {
    {text = " Default: " .. DefaultSetting,value = DefaultSetting},
    {text = 5,value = 5},
    {text = 10,value = 10},
    {text = 25,value = 25},
    {text = 50,value = 50},
    {text = 100,value = 100},
    {text = 250,value = 250},
    {text = 500,value = 500},
  }

  --other hint type
  local hint = DefaultSetting
  local ResearchQueueSize = ChoGGi.UserSettings.ResearchQueueSize
  if ResearchQueueSize then
    hint = ResearchQueueSize
  end

  local CallBackFunc = function(choice)
    local value = choice[1].value
    if type(value) == "number" then

      const.ResearchQueueSize = value
      ChoGGi.ComFuncs.SetSavedSetting("ResearchQueueSize",value)

      ChoGGi.SettingFuncs.WriteSettings()
      ChoGGi.ComFuncs.MsgPopup(tostring(ChoGGi.UserSettings.ResearchQueueSize) .. ": Nerdgasm",
        "Research",UsualIcon
      )
    end
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Research Queue Size",
    hint = "Current: " .. hint,
  })
end

function ChoGGi.MenuFuncs.ShowResearchTechList()
  local ChoGGi = ChoGGi
  local TechTree = TechTree
  local ItemList = {}
  ItemList[#ItemList+1] = {
    text = " Everything",
    value = "Everything",
    hint = "All the tech/breakthroughs/mysteries"
  }
  ItemList[#ItemList+1] = {
    text = " All Tech",
    value = "AllTech",
    hint = "All the regular tech"
  }
  ItemList[#ItemList+1] = {
    text = " All Breakthroughs",
    value = "AllBreakthroughs",
    hint = "All the breakthroughs"
  }
  ItemList[#ItemList+1] = {
    text = " All Mysteries",
    value = "AllMysteries",
    hint = "All the mysteries"
  }
  for i = 1, #TechTree do
    for j = 1, #TechTree[i] do
      local text = ChoGGi.CodeFuncs.Trans(TechTree[i][j].display_name)
      --remove " from that one tech...
      if text:find("\"") then
        text = text:gsub("\"","")
      end
      ItemList[#ItemList+1] = {
        text = text,
        value = TechTree[i][j].id,
        hint = ChoGGi.CodeFuncs.Trans(TechTree[i][j].description)
      }
    end
  end

  local CallBackFunc = function(choice)
    local check1 = choice[1].check1
    local check2 = choice[1].check2
    --nothing checked so just return
    if not check1 and not check2 then
      ChoGGi.ComFuncs.MsgPopup("Pick a checkbox next time...","Research",UsualIcon)
      return
    elseif check1 and check2 then
      ChoGGi.ComFuncs.MsgPopup("Don't pick both checkboxes next time...","Research",UsualIcon)
      return
    end

    local sType
    local Which
    --add
    if check1 then
      sType = "DiscoverTech"
      Which = "Unlocked"
    --remove
    elseif check2 then
      sType = "GrantTech"
      Which = "Researched"
    end

    --MultiSel
    for i = 1, #choice do
      local value = choice[i].value
      if value == "Everything" then
        ChoGGi.MenuFuncs.SetTech_EveryMystery(sType)
        ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(sType)
        ChoGGi.MenuFuncs.SetTech_EveryTech(sType)
      elseif value == "AllTech" then
        ChoGGi.MenuFuncs.SetTech_EveryTech(sType)
      elseif value == "AllBreakthroughs" then
        ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(sType)
      elseif value == "AllMysteries" then
        ChoGGi.MenuFuncs.SetTech_EveryMystery(sType)
      else
        _G[sType](value)
      end
    end

    ChoGGi.ComFuncs.MsgPopup(Which .. ": Unleash your inner Black Monolith Mystery.",
      "Research",UsualIcon
    )
  end

  ChoGGi.CodeFuncs.FireFuncAfterChoice({
    callback = CallBackFunc,
    items = ItemList,
    title = "Research Unlock",
    hint = "Select Unlock or Research then select the tech you want (Ctrl/Shift to multi-select).",
    multisel = true,
    check1 = "Unlock",
    check1_hint = "Just unlocks in the research tree.",
    check2 = "Research",
    check2_hint = "Unlocks and researchs.",
  })
end

local function listfields(sType,field)
  local TechTree = TechTree
  for i = 1, #TechTree do
    if TechTree[i].id == field then
      for j = 1, #TechTree[i] do
        _G[sType](TechTree[i][j].id)
      end
    end
  end
end

function ChoGGi.MenuFuncs.SetTech_EveryMystery(sType)
  listfields(sType,"Mysteries")
end

function ChoGGi.MenuFuncs.SetTech_EveryBreakthrough(sType)
  listfields(sType,"Breakthroughs")
end

function ChoGGi.MenuFuncs.SetTech_EveryTech(sType)
  listfields(sType,"Biotech")
  listfields(sType,"Engineering")
  listfields(sType,"Physics")
  listfields(sType,"Robotics")
  listfields(sType,"Social")
end

