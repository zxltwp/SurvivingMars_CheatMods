-- See LICENSE for terms
--stuff only loaded when ChoGGi.Testing = true

local Concat = ChoGGi.ComFuncs.Concat

--stuff that never happens, fuck comments (like this one)
if type(ChoGGi.Testing) == "function" then

  --for ingame editor

  OpenExamine(ChoGGi.ComFuncs.ReturnAllNearby(1000))
  ChoGGi.CurObj:SetPos(GetTerrainCursor())

  local Attaches = type(s.GetAttaches) == "function" and s:GetAttaches("Colonist") or empty_table
  for i = #Attaches, 1, -1 do
      Attaches[i]:Detach()
      Attaches[i]:SetState("idle")
      Attaches[i].city:AddToLabel("Arrivals", Attaches[i])
      Attaches[i].arriving = nil
      Attaches[i]:OnArrival()

      --Attaches[i]:Arrive()
    --end
  end


  function ChoGGi.Temp.ReplaceDome(dome)
    if not dome then
      return
    end
    local olddome = empty_table
    for Key,Value in pairs(dome) do
      olddome[Key] = Value
    end
    local pos = dome:GetPos()
    dome:delete()

    local newdome = PlaceObj('GeoscapeDome', {
      'template_name', "GeoscapeDome",
      'Pos', pos,
    })
    for Key,Value in pairs(olddome) do
      if Key ~= "entity" and Key ~= "dome_enterances" and Key ~= "encyclopedia_id" and Key ~= "my_interior" and Key ~= "waypoint_chains" and Key ~= "handle" then
        newdome[Key] = Value
      end
    end
    newdome:Init()
    newdome:GameInit()
    newdome:InitResourceSpots()
    newdome:InitPassageTables()

    newdome:Rebuild()
    newdome:ApplyToGrids()
    newdome:AddOutskirtBuildings()
    newdome:GenerateWalkablePoints()
    newdome:InitAttaches()
  end

  local Table1 = GetObjects({class="Destlock"})
  for i = 1, #Table1 do

  local wp = PlaceObject("WayPoint")
  wp:SetPos(Table[i]:GetPos())

  end

  local Table2 = GetObjects({class="ParSystem"})
  for i = 1, #Table2 do
    Table2[i]:delete()
  end



  dofolder_files("CommonLua/UI/UIDesignerData")
--[[
  ChoGGi.ComFuncs.SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
  print(self.command)
    if self.ChoGGi_FollowMouseShuttle and self.command == "Home" or self.command == "Idle" then
      self:SetCommand("ChoGGi_FollowMouse")
    end
    return ChoGGi.OrigFuncs.CargoShuttle_Idle(self)
  end
--]]
  for message, threads in pairs(ThreadsMessageToThreads) do
    --print(message)
    --print(threads)
    if message.action and message.action.class == "SA_WaitMsg" then
    print(message.ip)
    end
  end
  for thread in pairs(ThreadsRegister) do
    print(thread)
  end
end

if ChoGGi.Testing then

  -----------------------------missing workplaces
  local table = table
  local DoneObject = DoneObject

  local function MissingWorkplaces(workplaces)
    local sum_ui_on = 0
    local sum_ui_off = 0
  --~ 	for i = 1, #workplaces do
    for i = #workplaces, 1, -1 do
      local b = workplaces[i]
      --neither func checks if the class is UnpersistedMissingClass, so easy enough fix
      if b.class == "UnpersistedMissingClass" then
        DoneObject(b)
        table.remove(workplaces,i)
      elseif not b.destroyed and not b.demolishing then
        if b.ui_working then
          sum_ui_on = sum_ui_on + b:GetFreeWorkSlots()
        end
        sum_ui_off = sum_ui_off + b:GetClosedSlots()
      end
    end
    return sum_ui_on, sum_ui_off
  end

  function GetFreeWorkplacesAround(dome)
    local city = dome.city or UICity
    return MissingWorkplaces(city.labels.Workplace or empty_table)
  end

  function GetFreeWorkplaces(city)
    return MissingWorkplaces(city.labels.Workplace or empty_table)
  end
  -----------------------------missing workplaces


  --tell me if traits are different
  local ChoGGi = ChoGGi
  local const = const
  local textstart = "<color 255 0 0>"
  local textend = " is different length</color>"
  if #const.SchoolTraits ~= 5 then
    ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat(textstart,"SchoolTraits",textend)
  end
  if #const.SanatoriumTraits ~= 7 then
    ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat(textstart,"SanatoriumTraits",textend)
  end
  local fulllist = TraitsCombo()
  if #fulllist ~= 55 then
    ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat(textstart,"TraitsCombo",textend)
  end

---------
  print("ChoGGi.Testing")
end --Testing

function ChoGGi.MsgFuncs.Testing_ClassesGenerate()

  config.TraceEnable = true
  Platform.editor = true
  config.LuaDebugger = true
  GlobalVar("outputSocket", false)
  dofile("CommonLua/Core/luasocket.lua")
  dofile("CommonLua/Core/luadebugger.lua")
  dofile("CommonLua/Core/luaDebuggerOutput.lua")
  dofile("CommonLua/Core/ProjectSync.lua")

 ------
  print("Testing_ClassesGenerate")
end

function ChoGGi.MsgFuncs.Testing_ClassesPreprocess()
  --fix the arcology dome spot
  --[[
  SaveOrigFunc("SpireBase","GameInit")
  function SpireBase:GameInit()
    local dome = IsObjInDome(self)
    if self.spire_frame_entity ~= "none" and IsValidEntity(self.spire_frame_entity) then
      local frame = PlaceObject("Shapeshifter")
      frame:ChangeEntity(self.spire_frame_entity)
      local spot = dome:GetNearestSpot("idle", "Spireframe", self)

      local pos = self:GetSpotPos(spot or 1)

      frame:SetAttachOffset(pos - self:GetPos())
      self:Attach(frame, self:GetSpotBeginIndex("Origin"))
    end
  end
  --]]
  ------
  print("Testing_ClassesPreprocess")
end --ClassesPreprocess

--where we add new BuildingTemplates
function ChoGGi.MsgFuncs.Testing_ClassesPostprocess()
  ------
  print("Testing_ClassesPostprocess")
end

function ChoGGi.MsgFuncs.Testing_ClassesBuilt()

  --add an overlay for dead rover
  --[[
  SaveOrigFunc("PinsDlg","GetPinConditionImage")
  function PinsDlg:GetPinConditionImage(obj)
    local ret = ChoGGi.OrigFuncs.PinsDlg_GetPinConditionImage(self,obj)
    if obj.command == "Dead" and not obj.working then
      print(obj.class)
      return "UI/Icons/pin_not_working.tga"
    else
      return ret
    end
  end
  --]]

  --don't expect much, unless you've got a copy of Haerald around
  function luadebugger:Start()
  if self.started then
    print("Already started")
    return
  end
  print("Starting the Lua debugger...")
  DebuggerInit()
  DebuggerClearBreakpoints()
  self.started = true
  local server = self.server
  local debugger_port = controller_port + 2
  controller_host = not Platform.pc and config.Haerald and config.Haerald.ip or "localhost"
  server:connect(controller_host, debugger_port)
  server:update()
  if not server:isconnected() then
    if Platform.pc then
      local processes = os.enumprocesses()
      local running = false
      for i = 1, #processes do
        if string.find(processes[i], "Haerald.exe") then
          running = true
          break
        end
      end
      if not running then
        local os_path = ConvertToOSPath(config.LuaDebuggerPath)
        local exit_code, std_out, std_error = os.exec(os_path)
        if exit_code ~= 0 then
          print("Could not launch Haerald Debugger from:", os_path, [[

Exec error:]], std_error)
          self:Stop()
          return
        end
      end
    end
    local total_timeout = 6000
    local retry_timeout = Platform.pc and 100 or 2000
    local steps_before_reset = Platform.pc and 10 or 1
    local num_retries = total_timeout / retry_timeout
    for i = 1, num_retries do
      server:update()
      if not server:isconnected() then
        if not server:isconnecting() or i % steps_before_reset == 0 then
          server:close()
          server:connect(controller_host, debugger_port, retry_timeout)
        end
        os.sleep(retry_timeout)
      end
    end
    if not server:isconnected() then
      print("Could not connect to debugger at " .. controller_host .. ":" .. debugger_port)
      self:Stop()
      return
    end
  end
  server.timeout = 5000
  self.watches = {}
  self.handle_to_obj = {}
  self.obj_to_handle = {}
  local PathRemapping
  if not Platform.pc then
    PathRemapping = config.Haerald and config.Haerald.PathRemapping or {}
  else
    PathRemapping = config.Haerald and config.Haerald.PathRemapping or {
      CommonLua = "CommonLua",
      Lua = Platform.cmdline and "" or "Lua",
      Data = Platform.cmdline and "" or "Data",
      Dlc = Platform.cmdline and "" or "Data/../Dlc",
      HGO = "HGO",
      Build = "CommonLua/../Tools/Build",
      Server = "Lua/../Tools/Server/Project",
      Shaders = "Shaders",
      ProjectShaders = "ProjectShaders"
    }
    for key, value in pairs(PathRemapping) do
      if value ~= "" then
        local game_path = value .. "/."
        local os_path, failed = ConvertToOSPath(game_path)
        if failed or not io.exists(os_path) then
          os_path = ""
        end
        PathRemapping[key] = os_path
      end
    end
  end
--~   if not config.Haerald or not config.Haerald.FileDictionaryPath then
    local FileDictionaryPath = {
      "CommonLua",
      "Lua",
      "Dlc",
      "HGO",
      "Server",
      "Build"
    }
--~   end
--~   if not config.Haerald or not config.Haerald.FileDictionaryExclude then
    local FileDictionaryExclude = {
      ".svn",
      "__load.lua",
      ".prefab.lua",
      ".designer.lua",
      "/UIDesignerData/",
      "/Storage/"
    }
--~   end
--~   if not config.Haerald or not config.Haerald.FileDictionaryIgnore then
    local FileDictionaryIgnore = {
      "^exec$",
      "^items$",
      "^filter$",
      "^action$",
      "^state$",
      "^f$",
      "^func$",
      "^no_edit$"
    }
--~   end
--~   if not config.Haerald or not config.Haerald.SearchExclude then
    local SearchExclude = {
      ".svn",
      "/Prefabs/",
      "/Storage/",
      "/Collections/",
      "/BuildCache/"
    }
--~   end
  local TablesToKeys = {}
--~   if not config.Haerald or not config.Haerald.TableDictionary then
    local TableDictionary = {
      "const",
      "config",
      "hr",
      "Platform",
      "EntitySurfaces",
      "terrain",
      "ShadingConst",
      "table",
      "coroutine",
      "debug",
      "io",
      "os",
      "string"
    }
--~   end
  for i = 1, #TableDictionary do
    local name = TableDictionary[i]
    local t = rawget(_G, name)
    local keys = type(t) == "table" and table.keys(t) or ""
    if type(keys) == "table" then
      local vars = EnumVars(name .. ".")
      for key in pairs(vars) do
        keys[#keys + 1] = key
      end
      if #keys > 0 then
        table.sort(keys)
        TablesToKeys[name] = keys
      end
    end
  end
  local InitPacket = {
    Event = "InitPacket",
    PathRemapping = PathRemapping,
    ExeFileName = string.gsub(GetExecName(), "/", "\\"),
    ExePath = string.gsub(GetExecDirectory(), "/", "\\"),
    CurrentDirectory = Platform.pc and string.gsub(GetCWD(), "/", "\\") or "",
    FileDictionaryPath = FileDictionaryPath,
    FileDictionaryExclude = FileDictionaryExclude,
    FileDictionaryIgnore = FileDictionaryIgnore,
    SearchExclude = SearchExclude,
    TablesToKeys = TablesToKeys,
    ConsoleHistory = rawget(_G, "LocalStorage") and LocalStorage.history_log or {}
  }
  InitPacket.Platform = GetDebuggeePlatform()
--~   if Platform.console or Platform.ios then
--~     InitPacket.UploadData = "true"
--~     InitPacket.UploadPartSize = config.Haerald and config.Haerald.UploadPartSize or 2097152
--~     InitPacket.UploadFolders = config.Haerald and config.Haerald.UploadFolders or {}
--~   end
  local project_name = const.HaeraldProjectName
  if not project_name then
    local dir, filename, ext = SplitPath(GetExecName())
    project_name = filename or "unknown"
  end
  InitPacket.ProjectName = project_name
  self:Send(InitPacket)
  for i = 1, 500 do
    if self:DebuggerTick() and not self.init_packet_received then
      os.sleep(10)
    end
  end
--~   if not self.init_packet_received then
--~     print("Didn't receive initialization packages (maybe Haerald is taking too long to upload the files?)")
--~     self:Stop()
--~     return
--~   end
  SetThreadDebugHook(DebuggerSetHook)
  DebuggerSetHook()
--~   if DebuggerTracingEnabled() then
    do
      local coroutine_resume, coroutine_status = coroutine.resume, coroutine.status
--~       SetThreadResumeFunc(function(thread)
      CreateRealTimeThread(function(thread)
        collectgarbage("stop")
        DebuggerPreThreadResume(thread)
        local r1, r2 = coroutine.resume(thread)
        local time = DebuggerPostThreadYield(thread)
        collectgarbage("restart")
        if coroutine_status(thread) ~= "suspended" then
          DebuggerClearThreadHistory(thread)
        end
        return r1, r2
      end)
    end
--~   else
--~   end
  DeleteThread(self.update_thread)
  self.update_thread = CreateRealTimeThread(function()
    print("Debugger connected.")
    while self:DebuggerTick() do
      Sleep(25)
    end
    self:Stop()
  end)
--~   if Platform.console then
--~     RemoteCompileRequestShaders()
--~   end
end

  --stops confirmation dialog about missing mods (still lets you know they're missing)
  function GetMissingMods()
    return "", false
  end

  --lets you load saved games that have dlc
  function IsDlcAvailable()
    return true
  end

  ------
  print("Testing_ClassesBuilt")
end

function ChoGGi.MsgFuncs.Testing_ChoGGi_Loaded()

  ------
  print("<color 200 200 200>ECM</color><color 0 0 0>: </color><color 128 255 128>Testing Enabled</color>")

end
