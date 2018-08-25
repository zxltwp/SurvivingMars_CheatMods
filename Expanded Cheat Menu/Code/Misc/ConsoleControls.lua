-- See LICENSE for terms

-- called from OnMsgs

local Concat = ChoGGi.ComFuncs.Concat
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local S = ChoGGi.Strings
local blacklist = ChoGGi.blacklist

local rawget,table,tostring,print,select = rawget,table,tostring,print,select

--~ box(left, top, right, bottom)

local function ShowFileLog()
	if blacklist then
		print(302535920000242--[[Blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have �ber access.--]])
		return
	end
	FlushLogFile()
	print(select(2,AsyncFileToString(GetLogFile())))
end
local function ModsLog()
	print(ModMessageLog)
end
local function ConsoleLog()
	local ChoGGi = ChoGGi
	ChoGGi.UserSettings.ConsoleToggleHistory = not ChoGGi.UserSettings.ConsoleToggleHistory
	ShowConsoleLog(ChoGGi.UserSettings.ConsoleToggleHistory)
	ChoGGi.SettingFuncs.WriteSettings()
end
local function ConsoleLogWindow()
	local ChoGGi = ChoGGi
	ChoGGi.UserSettings.ConsoleHistoryWin = not ChoGGi.UserSettings.ConsoleHistoryWin
	ChoGGi.SettingFuncs.WriteSettings()
	ChoGGi.ComFuncs.ShowConsoleLogWin(ChoGGi.UserSettings.ConsoleHistoryWin)
end
local function WriteConsoleLog()
	local ChoGGi = ChoGGi
	if ChoGGi.UserSettings.WriteLogs then
		ChoGGi.UserSettings.WriteLogs = nil
		ChoGGi.ComFuncs.WriteLogs_Toggle()
	else
		ChoGGi.UserSettings.WriteLogs = true
		ChoGGi.ComFuncs.WriteLogs_Toggle(true)
	end
	ChoGGi.SettingFuncs.WriteSettings()
end

local ConsolePopupToggle_list = {
	{
		name = 302535920000040--[[Exec Code--]],
		hint = 302535920001287--[[Instead of a single line, you can enter/execute code in a textbox.--]],
		clicked = function()
			ChoGGi.ComFuncs.OpenInExecCodeDlg()
		end,
	},
	{
		name = 302535920001026--[[Show File Log--]],
		hint = 302535920001091--[[Flushes log to disk and displays in console log.--]],
		clicked = ShowFileLog,
	},
	{
		name = 302535920000071--[[Mods Log--]],
		hint = 302535920000870--[[Shows any errors from loading mods in console log.--]],
		clicked = ModsLog,
	},
	{name = " - "},
	{
		name = 302535920000734--[[Clear Log--]],
		hint = 302535920001152--[[Clear out the console log (F9 also works).--]],
		clicked = cls,
	},
	{
		name = 302535920000563--[[Copy Log Text--]],
		hint = 302535920001154--[[Displays the log text in a window you can copy sections from.--]],
		clicked = ChoGGi.ComFuncs.SelectConsoleLogText,
	},
	{
		name = 302535920000473--[[Reload ECM Menu--]],
		hint = 302535920000474--[[Fiddling around in the editor mod can break the menu / shortcuts added by ECM (use this to fix).--]],
		clicked = function()
			Msg("ShortcutsReloaded")
		end,
	},
	{name = " - "},
	{
		name = 302535920001112--[[Console Log--]],
		hint = 302535920001119--[[Toggle showing the console log on screen.--]],
		class = "ChoGGi_CheckButtonMenu",
		value = "dlgConsoleLog",
		clicked = ConsoleLog,
	},
	{
		name = 302535920001120--[[Console Log Window--]],
		hint = 302535920001133--[[Toggle showing the console log window on screen.--]],
		class = "ChoGGi_CheckButtonMenu",
		value = "dlgChoGGi_ConsoleLogWin",
		clicked = ConsoleLogWindow,
	},
	{
		name = 302535920000483--[[Write Console Log--]],
		hint = S[302535920000484--[[Write console log to %slogs/ConsoleLog.log (writes immediately).--]]]:format(ConvertToOSPath("AppData/")),
		class = "ChoGGi_CheckButtonMenu",
		value = "ChoGGi.UserSettings.WriteLogs",
		clicked = WriteConsoleLog,
	},
}

local function HistoryPopup(self)
	local dlgConsole = dlgConsole
	local ConsoleHistoryMenuLength = ChoGGi.UserSettings.ConsoleHistoryMenuLength or 50
	local items = {}
	if #dlgConsole.history_queue > 0 then
		local history = dlgConsole.history_queue
		for i = 1, #history do
			local text = tostring(history[i])
			items[i] = {
				-- these can get long so keep 'em short
				name = text:sub(1,ConsoleHistoryMenuLength),
				hint = Concat(S[302535920001138--[[Execute this command in the console.--]]],"\n\n",text),
				clicked = function()
					dlgConsole:Exec(text)
				end,
			}
		end
	end
	PopupToggle(self,"idHistoryMenu",items)
end

-- created when we create the controls controls the first time
local ExamineMenuToggle_list

-- build list of objects to examine
local function BuildExamineMenu()
	ExamineMenuToggle_list = {}

	local list = ChoGGi.UserSettings.ConsoleExamineList or ""

	table.sort(list,
		function(a,b)
			-- damn eunuchs
			return a:lower() < b:lower()
		end
	)

	for i = 0, #list do
		ExamineMenuToggle_list[i] = {
			name = list[i],
			hint = Concat(S[302535920000491--[[Examine Object--]]],": ",list[i]),
			clicked = function()
				local obj = ChoGGi.ComFuncs.ConvertNameToObject(list[i])
				if type(obj) == "function" then
					ChoGGi.ComFuncs.OpenInExamineDlg(obj())
				else
					ChoGGi.ComFuncs.OpenInExamineDlg(obj)
				end
			end,
		}
	end

	-- bonus addition at bottom
	ExamineMenuToggle_list[#ExamineMenuToggle_list+1] = {
		name = "XWindowInspector",
		hint = "XWindowInspector",
		clicked = function()
			OpenGedApp("XWindowInspector", terminal.desktop)
		end,
	}
end
-- rebuild list of objects to examine when user changes settings
function OnMsg.ChoGGi_SettingsUpdated()
	BuildExamineMenu()
end

function ChoGGi.Console.ConsoleControls(dlgConsole)
	local g_Classes = g_Classes

	-- stick everything in
	local container = g_Classes.XWindow:new({
		Id = "idContainer",
		Margins = box(15, 0, 0, 0),
		Dock = "bottom",
--~		 LayoutMethod = "HWrap",
		LayoutMethod = "HList",
		Image = "CommonAssets/UI/round-frame-20.tga",
	}, dlgConsole)

	--------------------------------Console popup
	dlgConsole.idConsoleMenu = g_Classes.ChoGGi_ConsoleButton:new({
		Id = "idConsoleMenu",
		RolloverText = S[302535920001089--[[Settings & Commands for the console.--]]],
		Text = S[302535920001308--[[Settings--]]],
		OnPress = function()
			PopupToggle(dlgConsole.idConsoleMenu,"idConsoleMenuPopup",ConsolePopupToggle_list)
		end,
	}, container)

	dlgConsole.idExamineMenu = g_Classes.ChoGGi_ConsoleButton:new({
		Id = "idExamineMenu",
		RolloverText = S[302535920000491--[[Examine Object--]]],
		Text = S[302535920000069--[[Examine--]]],
		OnPress = function()
			PopupToggle(dlgConsole.idExamineMenu,"idExamineMenuPopup",ExamineMenuToggle_list)
		end,
	}, container)

	if not blacklist then
		--------------------------------History popup
		dlgConsole.idHistoryMenu = g_Classes.ChoGGi_ConsoleButton:new({
			Id = "idHistoryMenu",
			RolloverText = S[302535920001080--[[Console history items (mouse-over to see code).--]]],
			Text = S[302535920000793--[[History--]]],
			OnPress = HistoryPopup,
		}, container)

		--------------------------------Scripts buttons
		dlgConsole.idScripts = g_Classes.XWindow:new({
			Id = "idScripts",
			LayoutMethod = "HList",
		}, container)
	end

	BuildExamineMenu()
end

local function BuildSciptButton(scripts,dlg,folder)
	ChoGGi_ConsoleButton:new({
		RolloverText = folder.RolloverText,
		Text = folder.Text,
		OnPress = function(self)
			-- build list of scripts to show
			local items = {}
			local scripts = ChoGGi.ComFuncs.RetFilesInFolder(folder.script_path,".lua")
			if scripts then
				for i = 1, #scripts do
					local _, script = AsyncFileToString(scripts[i].path)
					items[i] = {
						name = scripts[i].name,
						hint = Concat(S[302535920001138--[[Execute this command in the console.--]]],"\n\n",script),
						clicked = function()
							dlg:Exec(script)
						end,
					}
				end
			end

			PopupToggle(self,folder.id,items)
		end,
	}, scripts)
end

-- only check for ECM Scripts once per load
local script_files_added
-- rebuild menu toolbar buttons
function ChoGGi.Console.RebuildConsoleToolbar(dlg)
	if blacklist then
		return
	end

	dlg = dlg or dlgConsole
	local ChoGGi = ChoGGi
	local scripts = dlg.idScripts

	if not dlg.idScripts then
		-- we're in the select new map stuff screen
		return
	end

	-- add example script files if folder is missing
	if not script_files_added then
		ChoGGi.Console.BuildScriptFiles()
		script_files_added = true
	end

	-- clear out old buttons first
	for i = #scripts, 1, -1 do
		scripts[i]:delete()
		table.remove(scripts,i)
	end

	BuildSciptButton(scripts,dlg,{
		Text = S[302535920000353--[[Scripts--]]],
		RolloverText = S[302535920000881--[["Place .lua files in %s to have them show up in the ""Scripts"" list, you can then use the list to execute them (you can also create folders for sorting)."--]]]:format(ChoGGi.scripts),
		id = "idScriptsMenu",
		script_path = ChoGGi.scripts,
	})

	local folders = ChoGGi.ComFuncs.RetFoldersInFolder(ChoGGi.scripts)
	if folders then
		local hint_str = S[302535920001159--[[Any .lua files in %s.--]]]
		for i = 1, #folders do
			BuildSciptButton(scripts,dlg,{
				Text = folders[i].name,
				RolloverText = hint_str:format(folders[i].path),
				id = Concat("id",folders[i].name,"Menu"),
				script_path = folders[i].path,
			})
		end
	end
end

function ChoGGi.Console.BuildScriptFiles()
	local script_path = ChoGGi.scripts
	--create folder and some example scripts if folder doesn't exist
	local err,_ = AsyncGetFileAttribute(script_path,"size")
	if err then
		AsyncCreatePath(Concat(script_path,"/Examine"))
		AsyncCreatePath(Concat(script_path,"/Functions"))
		--print some info
		print(S[302535920000881--[["Place .lua files in %s to have them show up in the ""Scripts"" list, you can then use the list to execute them (you can also create folders for sorting)."--]]]:format(script_path))
		--add some example files and a readme
		AsyncStringToFile(Concat(script_path,"/readme.txt"),S[302535920000888--[[Any .lua files in here will be part of a list that you can execute in-game from the console menu.--]]])
		AsyncStringToFile(Concat(script_path,"/Help Me.lua"),[[ChoGGi.ComFuncs.MsgWait(ChoGGi.Strings[302535920000881]:format(ChoGGi.scripts))]])
		AsyncStringToFile(Concat(script_path,"/Functions/Amount of colonists.lua"),[[#(UICity.labels.Colonist or "")]])
		AsyncStringToFile(Concat(script_path,"/Functions/Toggle Working SelectedObj.lua"),[[SelectedObj:ToggleWorking()]])
	end
end

