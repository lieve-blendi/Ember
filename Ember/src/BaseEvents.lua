love.update = Ember.Needle.InjectFunc(love.update, function (func,dt)
    Ember.Event.CallEvent("Update",dt)
    func(dt)
    Ember.Event.CallEvent("PostUpdate",dt)
end)

love.draw = Ember.Needle.InjectFunc(love.draw, function (func)
    Ember.Event.CallEvent("Draw")
    func()
    Ember.Event.CallEvent("PostDraw")
end)

love.keypressed = Ember.Needle.InjectFunc(love.keypressed, function (func,key,scancode,isrepeat)
    Ember.Event.CallEvent("KeyPressed",key,scancode,isrepeat)
    func(key,scancode,isrepeat)
end)

love.keyreleased = Ember.Needle.InjectFunc(love.keyreleased, function (func,key,scancode)
    Ember.Event.CallEvent("KeyReleased",key,scancode)
    func(key,scancode)
end)

love.mousepressed = Ember.Needle.InjectFunc(love.mousepressed, function (func,x,y,button,istouch,presses)
    Ember.Event.CallEvent("MousePressed",x,y,button,istouch,presses)
    func(x,y,button,istouch,presses)
end)

love.mousereleased = Ember.Needle.InjectFunc(love.mousereleased, function (func,x,y,button,istouch,presses)
    Ember.Event.CallEvent("MouseReleased",x,y,button,istouch,presses)
    func(x,y,button,istouch,presses)
end)

AfterDraw = Ember.Needle.InjectFunc(AfterDraw, function (func,cell,cx,cy,crot,fancy,scale)
    local ret = func(cell,cx,cy,crot,fancy,scale)
    Ember.Event.CallEvent("AfterCellDraw",cell,cx,cy,crot,fancy,scale)
    return ret
end)