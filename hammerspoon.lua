local mod1 = {"cmd", "ctrl"}
local mod1shift = {"cmd", "ctrl", "shift"}
-- local spaces = require("hs._asm.undocumented.spaces")

local vimDirs = {
   h='West',
   j='South',
   k='North',
   l='East'
}

function highlightWin(win)
   local rect = hs.drawing.rectangle(win:frame())
   local alpha = 0.8
   rect:setStrokeColor({red=0.9, blue=0, green=0, alpha=alpha})
   rect:setFill(false)
   rect:setStrokeWidth(4)
   rect:show()

   timer = hs.timer.doUntil(function() return alpha <= 0 end,
      function()
         alpha = alpha - 0.1
         if (alpha <= 0) then
            rect:delete()
         else
            rect:setAlpha(alpha)
         end
      end,
      0.05)

end

------------------------------
-- Grid and layout stuff
------------------------------

function focusWithMouse(win)
   print(win)
   win:focus()
   local center = hs.geometry.rectMidPoint(win:frame())
   hs.mouse.setAbsolutePosition(center)
end

--Name -> {screenIndex, {grid spec}}
local work_h = 9
local work_browser = {x = 0, y = 0, w = 7, h = work_h}
local work_display_table = {
   Emacs = {2, {x = 0, y = 0, w = 7, h = work_h}},
   ["IntelliJ IDEA"] = {2, {x = 0, y = 0, w = 7, h = work_h}},
   ["Google Chrome"] = {1, work_browser},
   Firefox = {1, work_browser},
   Slack = {3, {x = 0, y = 4, w = 7, h = 5}},
   Terminal = {3, {x = 0, y = 0, w = 7, h = 4}},
   iTerm2 = {3, {x = 0, y = 0, w = 7, h = 4}},
   ["Microsoft Outlook"] = {1, work_browser}
}

local ultrawide_display_table = {
   Emacs = {1, {x = 0, y = 0, w = 4, h = work_h}},
   Firefox = {1, {x = 4, y = 0, w = 3, h = work_h}},
   Slack = {2, {x = 0, y = 0, w = 7, h = work_h}},
}

local home_display_table = {
   Emacs = {2, {x = 0, y = 0, w = 7, h = 9}},
   ["IntelliJ IDEA"] = {2, {x = 0, y = 0, w = 7, h = 9}},
   ["Google Chrome"] = {1, {x = 0, y = 0, w = 7, h = 9}},
   Firefox = {1, {x = 0, y = 0, w = 7, h = 9}},
   Slack = {1, {x = 1, y = 0, w = 6, h = 9}},
   Terminal = {2, {x = 4, y = 3, w = 3, h = 2}},
   iTerm2 = {2, {x = 4, y = 3, w = 3, h = 2}}
}

-- a function to filter out any windows you don't want moved by apply_layout
local filterWindows = function(window)
   if (window:application():title() == "Emacs" and window:title() == '*eshell*') then
      return false
   else
      return true
   end
end

hs.grid.GRIDWIDTH = 7
hs.grid.GRIDHEIGHT = work_h
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.hints.showTitleThresh = 100

-- Return all screens sorted by x position
local screens_sorted = function()
   local screens = hs.screen.allScreens()
   table.sort(screens, function(a, b) return a:frame().x < b:frame().x end)
   return screens
end

local apply_layout = function(layout)
   local scrs = screens_sorted()
   for appName, place in pairs(layout) do
      local app = hs.appfinder.appFromName(appName)
      if (app) then
         local scr = scrs[place[1]]
         for i, win in ipairs(app:allWindows()) do
            if (filterWindows(win)) then
               hs.grid.set(win, place[2], scr)
            end
         end
      end
   end
end
local work_display = function() apply_layout(work_display_table) end
local home_display = function() apply_layout(home_display_table) end
local ultrawide_display = function() apply_layout(ultrawide_display_table) end



local screenHandler = function()
   local screens = screens_sorted()
   print(string.format("screenHandler: %d screens", #screens))
   if (#screens == 3) then
      if screens[2]:frame().w > 1900 and screens[3]:frame().h > 1800 then
         print("Using work_display")
         work_display()
      end
   elseif (#screens == 2 and (screens[1]:frame().w > 3000 or screens[2]:frame().w > 3000)) then
      print("Using ultrawide display")
      ultrawide_display()
   elseif (#screens == 2) then
      print("Using home_display")
      home_display()
   else
      print("Unknown screen format")
   end
end
--hs.screen.watcher.new(screenHandler):start()

--We sometimes get windows with a role of AXUnknown that get in the way of this working at the edge of the screen
--Keep focusing in th proper direction until we focus the same window twice or we end up on a window with a role
--that's not AXUnknown
local filterUnknownWindows = function(winList)
   local out = {}
   local outIdx = 1
   for k, v in pairs(winList) do
      if v:role() ~= "AXUnknown" and v:isVisible() then
         out[outIdx] = v
         outIdx = outIdx + 1
      end
   end
   return out
end

for key,dir in pairs(vimDirs) do
   hs.hotkey.bind(mod1, key, function()
                     hs.window['focusWindow'..dir](nil, filterUnknownWindows(hs.window['windowsTo'..dir]()), true, true)
                     highlightWin(hs.window.focusedWindow())
   end)

   hs.hotkey.bind(mod1shift, key, function()
                     hs.hints.windowHints(hs.window['windowsTo'..dir]())
   end)
end

hs.hotkey.bind(mod1shift, "R", hs.reload)

hs.hotkey.bind(mod1, ";", function()
    --Disable showing titles temporarily, then re-enable
    local oldThresh = hs.hints.showTitleThresh
    hs.hints.showTitleThresh = 0
    hs.hints.windowHints(nil, nil, true)
    hs.hints.showTitleThresh = oldThresh
end)
hs.hotkey.bind(mod1shift, ";", function()
                  hs.hints.windowHints(hs.window.focusedWindow():application():allWindows(), nil, true)
end)

-- hs.hotkey.bind(mod1, "a", function()
--                   hs.window.focusedWindow():moveOneScreenWest()
-- end)

-- hs.hotkey.bind(mod1, "d", function()
--                   hs.window.focusedWindow():moveOneScreenEast()
-- end)

hs.hotkey.bind(mod1, "g", screenHandler)
hs.hotkey.bind(mod1shift, "g", function()
                  hs.execute(os.getenv("HOME") .. "/bin/placedisplays", true)
end)
hs.hotkey.bind(mod1shift, "space", hs.caffeinate.startScreensaver) --

local chooserWindow = function(info)
   if info then
      for k,v in pairs(info) do print(k, v) end
--      if info.spaceId ~= spaces.activeSpace() then
--         spaces.changeToSpace(info.spaceId)
--      end
      focusWithMouse(hs.window.get(winId))
   end
end

local wf = hs.window.filter
hs.hotkey.bind(mod1, "/", function()
                  local c = hs.chooser.new(chooserWindow)
                  local windowInfo = {}
                  for k, v in pairs(wf.default:getWindows()) do
                     table.insert(windowInfo, {
                                     ["text"] = v:application():title(),
                                     ["subText"] = v:title(),
                                     ["winId"] = v:id(),
                                     ["spaceId"] = v:spaces()[1]
                     })
                  end
                  c:choices(windowInfo)
                  c:show()
end)
