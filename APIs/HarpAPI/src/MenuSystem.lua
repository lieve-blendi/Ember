local MenuSystem = {}

MenuSystem.winxm = love.graphics.getWidth()/800
MenuSystem.winym = love.graphics.getHeight()/600
MenuSystem.centerx = 400*MenuSystem.winxm
MenuSystem.centery = 300*MenuSystem.winym

MenuSystem.NOEXITBUTTON = "HarpAPI:NoEXITButton"

function MenuSystem:OnMenuDraw(value, func)
    EmberAPI.Menu.RenderOnMenu(value, func)
end

function MenuSystem:CreateMenu(name,exitbtn,draw)
    exitbtn = exitbtn == MenuSystem.NOEXITBUTTON
    EmberAPI.Menu.newMenu(name, true, exitbtn, draw)
end

function MenuSystem:ChangeMenu(value)
    ToMenu(value)
end

function MenuSystem:GetMenu()
    return mainmenu
end

function MenuSystem:GetUiscale()
    return uiscale
end

function MenuSystem:SetUiscale(value)
    uiscale = value
end

function MenuSystem:GetPuzzle()
    return puzzle
end

function MenuSystem:SetPuzzle(value)
    puzzle = value
end

---**M**enu **E**quals
function MenuSystem:ME(value)
    return EmberAPI.Menu.ME(value)
end

------------------------------------------------------------------------------------------------------------------------------------------------

love.resize = HarpAPI.Syringe.InjectPostFunction(love.resize or function () end, function (w, h)
    w = w or love.graphics.getWidth()
    h = h or love.graphics.getHeight()
    MenuSystem.winxm = w/800
    MenuSystem.winym = h/600
    MenuSystem.centerx = w/2
    MenuSystem.centery = h/2
end)

return MenuSystem