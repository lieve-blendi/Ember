PowerList = {}

PowerList.path = Ember.ModsInfo["PowerList"].path .. "/" -- ultimate lazy

PowerList.scroll = 0
PowerList.scrollMultiplier = 50*8
PowerList.mods = {}
PowerList.apis = {}
PowerList.currentreadme = ""

local borderX = 14
local iconSize = 60

local listWidth = 475
local listHeight = 80
local listSpacing = listHeight + 5

local listXspace = 12
local listYspace = listHeight/2 - iconSize/2
local listXiconSpace = iconSize + listXspace*2
local listYdescSpace = listYspace + 8*2.5
local listYverSpace = listHeight - listYspace*2
local listXreadmeSpace = listWidth + ((600 - listWidth - listXspace)/2 - 20) - 3
local listYreadmeSpace = listHeight/2 - 20

EmberAPI.Texture.NewTexture("mod:PowerListIcon", PowerList.path .. "icon.png")
EmberAPI.Texture.NewTexture("mod:PowerListAPIIcon", PowerList.path .. "apiicon.png")
EmberAPI.Texture.NewTexture("mod:PowerListmlarrow", PowerList.path .. "arrow.png")

--------------------------------------------------------------------------------------------------

local function MouseWithin(x,y,w,h)
    local mx,my = love.mouse.getPosition()
    return (mx >= x and mx <= x+(w-1) and my >= y and my <=y+(h-1))
end

EmberAPI.Menu.newMenu("mod:PowerList", true, true, function()
    love.graphics.setColor(1,1,1,1)

    local UIscale = uiscale
    local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    local listX, listY = centerX - 300*UIscale, centerY - 225*UIscale

    MenuRect(centerX-300*uiscale,centerY-(450/2)*uiscale,600*uiscale,450*uiscale)

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("PowerList Mods", listX, listY - love.graphics.getFont():getHeight()*UIscale*2, 0, UIscale*2, UIscale*2)
    local text = " Mods loaded"
    if #PowerList.mods == 1 then text = " Mod loaded" end
    love.graphics.print(#PowerList.mods .. text, listX + love.graphics.getFont():getWidth("PowerList Mods ")*UIscale*2, listY - love.graphics.getFont():getHeight()*UIscale*1.5, 0, UIscale, UIscale)

    local sx = centerX-(300*UIscale)+(4*UIscale) -- calculating the starting and ending position of the menubg
    local ex = centerX+(300*UIscale)-(4*UIscale)

    local sy = centerY-(225*UIscale)+(4*UIscale)
    local ey = centerY+(225*UIscale)-(4*UIscale)

    love.graphics.setScissor(sx,sy,ex-sx,ey-sy) -- during the code below this until i reset it, it wont draw outside of the menubg

    for i,mod in ipairs(PowerList.mods) do
        local modX, modY = listX + borderX*UIscale,listY - 70*UIscale + ((i*listSpacing) * UIscale) + PowerList.scroll*UIscale
        
        if modY > (sy - listHeight*UIscale) and modY < ey then -- Don't render the list if it isnt visible
            local bottomText = mod.version or ""

            if not mod.ran then
                if bottomText ~= "" then bottomText = bottomText .. ", " end
                bottomText = bottomText .. "Disabled"
            end
    
            if not mod.iAPI then
                if bottomText ~= "" then bottomText = bottomText .. ", " end
                bottomText = bottomText .. "Required API is not installed."
            end
    
            love.graphics.setColor(1/6 + (not mod.ran and 1/6 or 0),1/6,1/6,0.5)
            love.graphics.rectangle("fill",modX, modY, listWidth*UIscale, listHeight*UIscale, 5, 5*UIscale)
    
            love.graphics.setColor(1,1,1,1)
    
            EmberAPI.Texture.DrawTexture(mod.icon, modX + listXspace*UIscale, modY + listYspace*UIscale, 0, iconSize*UIscale, iconSize*UIscale)
            
            if MouseWithin(modX + listXreadmeSpace*UIscale - 25*UIscale, modY + listYreadmeSpace*UIscale,40*UIscale, 40*UIscale) and not love.mouse.isDown(1) then
                love.graphics.setColor(1,1,1,1)
                EmberAPI.Texture.DrawTexture("popups", modX + listXreadmeSpace*UIscale - 25*uiscale, modY + listYreadmeSpace*UIscale, 0, 40*UIscale, 40*UIscale)
            else
                love.graphics.setColor(1,1,1,0.5)
                EmberAPI.Texture.DrawTexture("popups", modX + listXreadmeSpace*UIscale - 25*UIscale, modY + listYreadmeSpace*UIscale, 0, 40*UIscale, 40*UIscale)
            end

            local textouse = mod.ran and "delete" or "checkon"
            local color = mod.ran and {1,0.5,0.5} or {0.5,1,0.5}
            if MouseWithin(modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale,40*UIscale, 40*UIscale) and not love.mouse.isDown(1) then
                love.graphics.setColor(color[1],color[2],color[3],1)
                EmberAPI.Texture.DrawTexture(textouse, modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale, 0, 40*UIscale, 40*UIscale)
            else
                love.graphics.setColor(color[1],color[2],color[3],0.5)
                EmberAPI.Texture.DrawTexture(textouse, modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale, 0, 40*UIscale, 40*UIscale)
            end

            love.graphics.setColor(1,1,1,1)
    
            love.graphics.print(mod.name or "Unnamed Mod", modX + listXiconSpace*UIscale, modY + listYspace*UIscale, 0, 2*UIscale, 2*UIscale)
            love.graphics.print(mod.desc or "No Description Available", modX + listXiconSpace*UIscale, modY + listYdescSpace*UIscale, 0, UIscale, UIscale)
    
            love.graphics.setColor(1,1,1,1/2)
            love.graphics.print(bottomText, modX + listXiconSpace*UIscale, modY + listYverSpace*UIscale, 0, UIscale, UIscale)
        end
    end

    love.graphics.setScissor() -- resetting the limited drawing area (so the rest of cellua can still render after this lol)
end)


EmberAPI.Menu.newMenu("mod:PowerListAPIs", true, true, function()
    love.graphics.setColor(1,1,1,1)

    local UIscale = uiscale
    local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    local listX, listY = centerX - 300*UIscale, centerY - 225*UIscale

    MenuRect(centerX-300*uiscale,centerY-(450/2)*uiscale,600*uiscale,450*uiscale)

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("PowerList APIs", listX, listY - love.graphics.getFont():getHeight()*UIscale*2, 0, UIscale*2, UIscale*2)
    local text = " APIs loaded"
    if #PowerList.apis == 1 then text = " API loaded" end
    love.graphics.print(#PowerList.apis .. text, listX + love.graphics.getFont():getWidth("PowerList APIs ")*UIscale*2, listY - love.graphics.getFont():getHeight()*UIscale*1.5, 0, UIscale, UIscale)

    local sx = centerX-(300*UIscale)+(4*UIscale) -- calculating the starting and ending position of the menubg
    local ex = centerX+(300*UIscale)-(4*UIscale)

    local sy = centerY-(225*UIscale)+(4*UIscale)
    local ey = centerY+(225*UIscale)-(4*UIscale)

    love.graphics.setScissor(sx,sy,ex-sx,ey-sy) -- during the code below this until i reset it, it wont draw outside of the menubg

    for i,mod in ipairs(PowerList.apis) do
        local modX, modY = listX + borderX*UIscale,listY - 70*UIscale + ((i*listSpacing) * UIscale) + PowerList.scroll*UIscale
        
        if modY > (sy - listHeight*UIscale) and modY < ey then -- Don't render the list if it isnt visible
            local bottomText = mod.version or ""
    
            if not mod.iAPI then
                if bottomText ~= "" then bottomText = bottomText .. ", " end
                bottomText = bottomText .. "Required API is not installed."
            end

            love.graphics.setColor(1/6,1/6,1/6,0.5)
            love.graphics.rectangle("fill",modX, modY, listWidth*UIscale + 40*uiscale, listHeight*UIscale, 5, 5*UIscale)
    
            love.graphics.setColor(1,1,1,1)
    
            EmberAPI.Texture.DrawTexture(mod.icon, modX + listXspace*UIscale, modY + listYspace*UIscale, 0, iconSize*UIscale, iconSize*UIscale)
            
            if MouseWithin(modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale,40*UIscale, 40*UIscale) and not love.mouse.isDown(1) then
                love.graphics.setColor(1,1,1,1)
                EmberAPI.Texture.DrawTexture("popups", modX + listXreadmeSpace*UIscale + 25*uiscale, modY + listYreadmeSpace*UIscale, 0, 40*UIscale, 40*UIscale)
            else
                love.graphics.setColor(1,1,1,0.5)
                EmberAPI.Texture.DrawTexture("popups", modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale, 0, 40*UIscale, 40*UIscale)
            end

            love.graphics.setColor(1,1,1,1)
    
            love.graphics.print(mod.name or "Unnamed Mod", modX + listXiconSpace*UIscale, modY + listYspace*UIscale, 0, 2*UIscale, 2*UIscale)
            love.graphics.print(mod.desc or "No Description Available", modX + listXiconSpace*UIscale, modY + listYdescSpace*UIscale, 0, UIscale, UIscale)
    
            love.graphics.setColor(1,1,1,1/2)
            love.graphics.print(bottomText, modX + listXiconSpace*UIscale, modY + listYverSpace*UIscale, 0, UIscale, UIscale)
        end
    end

    love.graphics.setScissor() -- resetting the limited drawing area (so the rest of cellua can still render after this lol)
end)

EmberAPI.Menu.newMenu("mod:PowerListreadme", true, true, function()
    local UIscale = uiscale
    local rm = PowerList.currentreadme
    local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    local f = love.graphics.getFont()
    love.graphics.printf(rm,centerX,centerY,1/0,"left",0,1*UIscale,1*UIscale,f:getWidth(rm)/2,f:getHeight()/2)
end)

-- README click detection

Ember.Event.AddCallback("MousePressed", function (x, y, btn)
    if EmberAPI.Menu.ME("mod:PowerList") then
        if btn == 1 then
            local UIscale = uiscale
            local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
            local listX, listY = centerX - 300*UIscale, centerY - 225*UIscale

            local sx = centerX-(300*UIscale)+(4*UIscale) -- calculating the starting and ending position of the menubg
            local ex = centerX+(300*UIscale)-(4*UIscale)

            local sy = centerY-(225*UIscale)+(4*UIscale)
            local ey = centerY+(225*UIscale)-(4*UIscale)

            if MouseWithin(sx,sy,ex-sx,ey-sy) then -- Clicked inside the menu
                for i,mod in ipairs(PowerList.mods) do
                    local modX, modY = listX + borderX*UIscale,listY - 70*UIscale + ((i*listSpacing) * UIscale) + PowerList.scroll*UIscale

                    if MouseWithin(modX + listXreadmeSpace*UIscale - 25*UIscale, modY + listYreadmeSpace*UIscale,40*UIscale, 40*UIscale) then
                        -- has detected a click on a readme button
                        PowerList.currentreadme = mod.readme
                        EmberAPI.Menu.setMenu("mod:PowerListreadme")
                        EmberAPI.Sound.play("beep")
                    end

                    if MouseWithin(modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale,40*UIscale, 40*UIscale) then
                        -- has detected a click on a enable/disable button
                        
                        if mod.name == "PowerList" then
                            EmberAPI.Sound.play("destroy")
                        else
                            local path = mod.path .. "/config.json"
                            local data = love.filesystem.read(path)
                            local config = Ember.lib.dkjson.decode(data) or {}
                            config.disabled = not (config.disabled == nil and false or config.disabled)
                            local text = config.disabled and "Disabling..." or "Enabling..."
                            
                            local enc = Ember.lib.dkjson.encode(config, {indent = true})
                            if type(enc) ~= "string" then enc = "" end
                            local succ, msg = love.filesystem.write(path, enc)

                            if succ then
                                mod.name = text
                                mod.desc = text
                                mod.version = text
                                mod.icon = "placeable"

                                EmberAPI.Sound.play("beep")
                                Ember.Toast.ShowToast("Restarting in 3 seconds...")
        
                                Ember.Timer.Timeout(3, function ()
                                    love.event.quit("restart")
                                end)
                            else
                                Ember.Toast.ShowToast("Error: " .. msg)
                            end
                        end
                    end
                end
            end
        end
    elseif EmberAPI.Menu.ME("mod:PowerListAPIs") then
        if btn == 1 then
            local UIscale = uiscale
            local centerX, centerY = love.graphics.getWidth()/2, love.graphics.getHeight()/2
            local listX, listY = centerX - 300*UIscale, centerY - 225*UIscale

            local sx = centerX-(300*UIscale)+(4*UIscale) -- calculating the starting and ending position of the menubg
            local ex = centerX+(300*UIscale)-(4*UIscale)

            local sy = centerY-(225*UIscale)+(4*UIscale)
            local ey = centerY+(225*UIscale)-(4*UIscale)

            if MouseWithin(sx,sy,ex-sx,ey-sy) then -- Clicked inside the menu
                for i,api in ipairs(PowerList.apis) do
                    local modX, modY = listX + borderX*UIscale,listY - 70*UIscale + ((i*listSpacing) * UIscale) + PowerList.scroll*UIscale

                    if MouseWithin(modX + listXreadmeSpace*UIscale + 25*UIscale, modY + listYreadmeSpace*UIscale,40*UIscale, 40*UIscale) then
                        -- has detected a click on a readme button
                        PowerList.currentreadme = api.readme
                        EmberAPI.Menu.setMenu("mod:PowerListreadme")
                        EmberAPI.Sound.play("beep")
                    end
                end
            end
        end
    end
end)

-------- Add the buttons --------

local powerlistmenu = function() return EmberAPI.Menu.ME("mod:PowerList") or EmberAPI.Menu.ME("mod:PowerListAPIs") end
local powerlistmodmenu = function() return EmberAPI.Menu.ME("mod:PowerList") end
local powerlistapimenu = function() return EmberAPI.Menu.ME("mod:PowerListAPIs") end

NewButton(40,180,60,60,"mod:PowerListAPIIcon", "mod:PowerListAPIbtn", "APIs", nil, function() PowerList.scroll = 0; EmberAPI.Menu.setMenu("mod:PowerListAPIs"); EmberAPI.Sound.play("beep") end, false, function() return mainmenu == "title" end, "center",3000)
NewButton(-40,180,60,60,"mod:PowerListIcon", "mod:PowerListbtn", "Mods", nil, function() PowerList.scroll = 0; EmberAPI.Menu.setMenu("mod:PowerList"); EmberAPI.Sound.play("beep") end, false, function() return mainmenu == "title" end, "center",3000)
-- scroll buttons
NewButton(300+15,-205,10,20,"mod:PowerListmlarrow", "mod:PowerListpu", nil, nil, function() PowerList.scroll = math.min(0, PowerList.scroll + love.timer.getDelta()*PowerList.scrollMultiplier) end, true, powerlistmenu, "center",3000, -math.pi*.5, {1,1,1,0.5}, {1,1,1,1}, {1,1,1,0.5})

NewButton(300+15,200,10,20,"mod:PowerListmlarrow", "mod:PowerListpd", nil, nil, function()
    if EmberAPI.Menu.ME("mod:PowerList") then
        local UIscale = uiscale
        local centerY = love.graphics.getHeight()/2
        local listY = centerY - 225*UIscale
        local sy = (listY - 70*UIscale + ((1*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- start of the first rectangle in the list
        local my = sy-(listY - 70*UIscale + ((#PowerList.mods*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- sy - start of the last rectangle in list (max scroll)
        my = (my/UIscale)-(listSpacing-listHeight) -- divided by UIscale because UIscale gets added when scroll gets added (the minus part is for better lineup)
    
        PowerList.scroll = math.max(PowerList.scroll - love.timer.getDelta()*PowerList.scrollMultiplier,my)
    elseif EmberAPI.Menu.ME("mod:PowerListAPIs") then
        local UIscale = uiscale
        local centerY = love.graphics.getHeight()/2
        local listY = centerY - 225*UIscale
        local sy = (listY - 70*UIscale + ((1*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- start of the first rectangle in the list
        local my = sy-(listY - 70*UIscale + ((#PowerList.apis*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- sy - start of the last rectangle in list (max scroll)
        my = (my/UIscale)-(listSpacing-listHeight) -- divided by UIscale because UIscale gets added when scroll gets added (the minus part is for better lineup)
    
        PowerList.scroll = math.max(PowerList.scroll - love.timer.getDelta()*PowerList.scrollMultiplier,my)
    end

end, true, powerlistmenu, "center",3000, math.pi*.5, {1,1,1,0.5}, {1,1,1,1}, {1,1,1,0.5})

-- The buttons at the bottom


NewButton(300-120,250,40,40,11, "mod:PowerListDisableEmber", "Disable Ember", "You can re-enable it by inputting \"Ember\" into the secrets menu", function()
    EmberAPI.Sound.play("beep")
    Ember.Toast.ShowToast("Restarting in 3 seconds...")
    Ember.Timer.Timeout(3, function ()
        GetSaved("secrets")["Ember"] = nil
        love.event.quit("restart")
    end)
end, false, powerlistmenu, "center", 3000, nil, {1,0,0,0.5},{1,0,0,1},{1,0,0,0.5})
NewButton(300-70,250,40,40,"bigui", "mod:PowerListopenmodsfolder", "Open mods folder", nil, function() love.system.openURL(love.filesystem.getSaveDirectory() .. "/Mods") end, false, powerlistmodmenu, "center", 3000, nil, {1,1,1,0.5}, {1,1,1,1}, {1,1,1,0.5})
NewButton(300-70,250,40,40,"bigui", "mod:PowerListopenapisfolder", "Open APIs folder", nil, function() love.system.openURL(love.filesystem.getSaveDirectory() .. "/APIs") end, false, powerlistapimenu, "center", 3000, nil, {1,1,1,0.5}, {1,1,1,1}, {1,1,1,0.5})
NewButton(300-20,250,40,40,71, "mod:PowerListModsDiscord", "Join the CelLua modding discord", nil, function() love.system.openURL("https://discord.gg/aFAs4nM4ve") end, false, powerlistmenu, "center",3000, nil,{1,1,1,0.5},{1,1,1,1},{1,1,1,0.5})


Ember.Event.AddCallback("ModsLoaded",function ()
    for _, info in pairs(Ember.ModsInfo) do
        local config = table.copy(info)

        config.iAPI = true

        if config.ran == false then
            config.iAPI = false

            if type(config.api) == "table" then
                for _, value in pairs(config.api) do
                    if (Ember.APIs[value] == true) or (value == "any") then
                        config.iAPI = true
                    end
                end
            end
        end

        config.readme = "No README.txt found for this mod."

        if love.filesystem.getInfo(config.path .. "/README.txt", "file") then
            config.readme = love.filesystem.read(config.path .. "/README.txt")
        end

        table.insert(PowerList.mods, config)
    end

    for _, info in pairs(Ember.APIInfo) do
        local config = table.copy(info)

        config.iAPI = true

        config.readme = "No README.txt found for this mod."

        if love.filesystem.getInfo(config.path .. "/README.txt", "file") then
            config.readme = love.filesystem.read(config.path .. "/README.txt")
        end

        table.insert(PowerList.apis, config)
    end
end)

love.wheelmoved = Ember.Needle.InjectFunc(love.wheelmoved, function (old,x, y)
    -- Calculating max scroll
    if EmberAPI.Menu.ME("mod:PowerList") then
        local UIscale = uiscale
        local centerY = love.graphics.getHeight()/2
        local listY = centerY - 225*UIscale
        local sy = (listY - 70*UIscale + ((1*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- start of the first rectangle in the list
        local my = sy-(listY - 70*UIscale + ((#PowerList.mods*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- sy - start of the last rectangle in list (max scroll)
        my = (my/UIscale)-(listSpacing-listHeight) -- divided by UIscale because UIscale gets added when scroll gets added (the minus part is for better lineup)
    
        PowerList.scroll = math.max(math.min(0, PowerList.scroll + y*10),my)
    elseif EmberAPI.Menu.ME("mod:PowerListAPIs") then
        local UIscale = uiscale
        local centerY = love.graphics.getHeight()/2
        local listY = centerY - 225*UIscale
        local sy = (listY - 70*UIscale + ((1*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- start of the first rectangle in the list
        local my = sy-(listY - 70*UIscale + ((#PowerList.apis*listSpacing) * UIscale) + PowerList.scroll*UIscale); -- sy - start of the last rectangle in list (max scroll)
        my = (my/UIscale)-(listSpacing-listHeight) -- divided by UIscale because UIscale gets added when scroll gets added (the minus part is for better lineup)
    
        PowerList.scroll = math.max(math.min(0, PowerList.scroll + y*10),my)
    end

    old(x,y)
end)

-------------------------------------------------------
