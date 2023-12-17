local Events = {}

---@param callback fun()
function Events:OnDraw(callback)             Ember.Event.AddCallback("render", callback) end
---@param callback fun(type: "press"|"release", x: number, y: number, btn: any)
function Events:OnClick(callback)            Ember.Event.AddCallback("click", callback) end
---@param callback fun(type: "press"|"release", btn: love.KeyConstant, scancode: love.Scancode, isrepeat: nil|boolean)
function Events:OnKey(callback)              Ember.Event.AddCallback("key", callback) end
---@param callback fun()
function Events:OnTick(callback)             Ember.Event.AddCallback("tick", callback) end
---@param callback fun(delta: number)
function Events:OnUpdate(callback)           Ember.Event.AddCallback("update", callback) end
---@param callback fun(delta: number)
function Events:OnPostUpdate(callback)       Ember.Event.AddCallback("postUpdate", callback) end
---love.load
---@param callback fun()
function Events:OnLoad(callback)             Ember.Event.AddCallback("load", callback) end
---love.filedropped
---@param callback fun(file: love.DroppedFile)
function Events:OnFileDrop(callback)         Ember.Event.AddCallback("filedrop", callback) end
function Events:OnWindowResize(callback)     Ember.Event.AddCallback("wr", callback) end
function Events:OnCellDraw(callback)         Ember.Event.AddCallback("cellrender", callback) end
function Events:OnSubtickCycle(callback)     Ember.Event.AddCallback("tick-cycle", callback) end
function Events:OnGridRender(callback)       Ember.Event.AddCallback("grid-render", callback) end
function Events:OnReset(callback)            Ember.Event.AddCallback("grid-reset", callback) end
function Events:OnClear(callback)            Ember.Event.AddCallback("grid-clear", callback) end
function Events:OnSetInitial(callback)       Ember.Event.AddCallback("set-initial", callback) end
function Events:OnModLoaded(callback)        Ember.Event.AddCallback("loadedmod", callback) end
function Events:OnAllModsLoaded(callback)    Ember.Event.AddCallback("modsloaded", callback) end

----------------------------------------------------------------------------
-- Inject the events.
----------------------------------------------------------------------------

Ember.Event.AddCallback("Draw", function () -- injecting into love.draw again is less efficient so intead i just make Draw call the render event
    Ember.Event.CallEvent("render")
end)

Ember.Event.AddCallback("Update", function (dt)
    Ember.Event.CallEvent("update", dt)
end)

-- OnPostUpdate
Ember.Event.AddCallback("PostUpdate", function (dt)
    Ember.Event.CallEvent("postUpdate", delta)
end)

-- OnLoad
love.load = HarpAPI.Syringe.InjectInFunction(love.load or function () end, function ()
    Ember.Event.CallEvent("load")
end)

-- OnClick (Press)
Ember.Event.AddCallback("MousePressed", function (x,y,button,istouch,presses)
    Ember.Event.CallEvent("click", "press", x, y, button, istouch, presses)
end)

-- OnClick (Release)
Ember.Event.AddCallback("MouseReleased", function (x,y,button,istouch,presses)
    Ember.Event.CallEvent("click", "release", x, y, button)
end)

Ember.Event.AddCallback("KeyPressed", function (x,y,key,scancode,isrepeat)
    Ember.Event.CallEvent("key", "press", x, y, key, scancode, isrepeat)
end)

Ember.Event.AddCallback("KeyReleased", function (x,y,key,scancode,isrepeat)
    Ember.Event.CallEvent("key", "release", x, y, key, scancode, isrepeat)
end)

-- OnFileDrop
love.filedropped = HarpAPI.Syringe.InjectInFunction(love.filedropped or function() end, function (file)
    Ember.Event.CallEvent("filedrop", file)
end)

-- OnWindowResize
love.resize = HarpAPI.Syringe.InjectPostFunction(love.resize or function () end, function (w, h)
    Ember.Event.CallEvent("wr", w, h)
end)

-- OnClear
ClearWorld = HarpAPI.Syringe.InjectInFunction(ClearWorld, function ()
    Ember.Event.CallEvent("grid-clear")
end)

Ember.Event.AddCallback("saul", function ()
    love.system.openURL("https://youtu.be/iId5WDsYxZ4")
end)

Ember.Event.AddCallback("ModsLoaded", function ()
    Ember.Event.CallEvent("modsloaded")
end)

Ember.Event.AddCallback("LoadedMod", function (v)
    Ember.Event.CallEvent("loadedmod", v)
end)

-- bw compat specific

Events.channel = {}
function Events.channel:on(name, callback)
    Ember.Event.AddCallback(name, callback)
end

return Events