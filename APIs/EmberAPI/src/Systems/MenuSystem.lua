local Menu = {}

Menu.Menus = {}
Menu.MenuRenders = {}

function Menu.newMenu(id,bgparticles,exitbutton,renderfunc)
    Menu.Menus[id] = {part=bgparticles,exitbutton=exitbutton}
    if renderfunc then
        Menu.RenderOnMenu(id,renderfunc)
    end
end

function Menu.setMenu(id)
    ToMenu(id)
end

function Menu.getMenu()
    return mainmenu
end

function Menu.RenderOnMenu(id,func)
    Menu.MenuRenders[id] = Menu.MenuRenders[id] or {}
    table.insert(Menu.MenuRenders[id],func)
end

function Menu.ME(value) -- Menu Equals
    return mainmenu == value
end

exitbtn = Ember.Needle.InjectFunc(exitbtn, function (func)
    if Menu.Menus[mainmenu] then
        return Menu.Menus[mainmenu].exitbutton
    end
    return func()
end)

buttons["backtomain"].isenabled = exitbtn

DrawMainMenu = Ember.Needle.InjectFunc(DrawMainMenu, function (func)
    func()
    Ember.Event.CallEvent("MenuRender",mainmenu)
    if Menu.MenuRenders[mainmenu] then
        for i, v in ipairs(Menu.MenuRenders[mainmenu]) do
            v()
        end
    end
end)

return Menu