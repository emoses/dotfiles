local mod1 = {"cmd", "ctrl"}
local mod1shift = {"cmd", "ctrl", "shift"}

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

local work_display_table = {
   Emacs = {2, {x = 0, y = 0, w = 7, h = 5}},
   IntelliJ = {2, {x = 0, y = 0, w = 7, h = 5}},
   ["Google Chrome"] = {1, {x = 0, y = 0, w = 4, h = 5}},
   Slack = {1, {x = 4, y = 0, w = 3, h = 3}},
   Terminal = {1, {x = 4, y = 3, w = 3, h = 2}}
}

hs.grid.GRIDWIDTH = 7
hs.grid.GRIDHEIGHT = 5
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0


local work_display = function()
   for appName, place in pairs(work_display_table) do
      local app = hs.appfinder.appFromName(appName)
      if (app) then
         for i, win in ipairs(app:allWindows()) do
            local scrs = hs.screen:allScreens()
            local src = scrs[place[1]]
            hs.grid.set(win, place[2], src)
         end
      end
   end
end

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
                     hs.window['focusWindow'..dir](nil, filterUnknownWindows(hs.window['windowsTo'..dir]()), true)
                     highlightWin(hs.window.focusedWindow())
   end)

   hs.hotkey.bind(mod1shift, key, function()
                     hs.hints.windowHints(hs.window['windowsTo'..dir]())
   end)
end

hs.hotkey.bind(mod1shift, "R", hs.reload)

hs.hotkey.bind(mod1, ";", hs.hints.windowHints)

hs.hotkey.bind(mod1, "a", function()
                  hs.window.focusedWindow():moveOneScreenWest()
end)

hs.hotkey.bind(mod1, "d", function()
                  hs.window.focusedWindow():moveOneScreenEast()
end)

hs.hotkey.bind(mod1, "g", work_display)




local screenHandler = function()
   local screens = hs.screen.allScreens()
   if (#screens == 2) then
      if screens[1].frame().w > 2000 and screens[2].frame().w > 2000 then
         work_display()
         --hs.layout.apply(work_display)
      end
   end
end

--TODO: add layout. start screenwatcher
