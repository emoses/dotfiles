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

for key,dir in pairs(vimDirs) do
   hs.hotkey.bind(mod1, key, function()
                     hs.window['focusWindow'..dir]()
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



local screenHandler = function()
   local screens = hs.screen.allScreens()
   if (#screens == 2) then
      if screens[1].frame().w > 2000 and screens[2].frame().w > 2000 then
         hs.layout.apply(work_display)
      end
   end
end

--TODO: add layout. start screenwatcher
