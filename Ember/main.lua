table.insert(truequeue,function() LoadEmber() end)

function LoadEmber()
    if Ember then return end
    
    Ember = {}
    
    Ember.GameVersion = "2.0.0tb1"
    
    Ember.version = "0.0.4"
    
    versiontxt = (versiontxt or "") .. "\n#ffffffEmber Version #ff7b00_e81f00" .. Ember.version
    
    Ember.Needle = require("Ember.src.Needle")
    Ember.Event = require("Ember.src.Event")
    Ember.Timer = require("Ember.src.Timer")
    Ember.Toast = require("Ember.src.Toast")
    require("Ember.src.BaseEvents")
    Ember.lib = {}
    Ember.lib.dkjson = require("Ember.lib.dkjson")
    
    require("Ember.src.Misc")
    
    print("[Ember] Loaded internal Ember libraries")
    
    Ember.APIs = {}
    Ember.APIInfo = {}

    Ember.CustomModLoader = {}
    
    local APIs = love.filesystem.getDirectoryItems("APIs")
    for i, v in ipairs(APIs) do
        Ember.APIs[v] = true
        if love.filesystem.getInfo("APIs/" .. v, "directory") then
            local apip = "APIs"
            local apipath = v
            if love.filesystem.getInfo("APIs/" .. v .. "/config.json", "file") then
                local confdata = love.filesystem.read(apip .. "/" .. apipath .. "/config.json")
                local modinfo = Ember.lib.dkjson.decode(confdata)
                if type(modinfo) ~= "table" then modinfo = {} end
    
                modinfo.path = apip .. "/" .. apipath
                modinfo.pathDot = apip .. "." .. apipath
    
                Ember.APIInfo[apipath] = modinfo
            else
                print("[Ember] API " .. v .. " has no config.json, loading anyway")
            end
            if love.filesystem.getInfo("APIs/" .. v .. "/main.lua", "file") then
                require("APIs." .. v .. ".main")
            end
            print("[Ember] API " .. v .. " loaded")
            Ember.RunAPIWaits(v)
        end
    end
    
    Ember.AllAPIsLoaded()
    
    Ember.Mods = {}
    Ember.ModsInfo = {}
    
    local Mods = love.filesystem.getDirectoryItems("Mods")
    for i, v in ipairs(Mods) do
        if love.filesystem.getInfo("Mods/" .. v, "directory") then
            local modp = "Mods"
            local modpath = v
    
            if love.filesystem.getInfo("Mods/" .. v .. "/config.json", "file") then
                local confdata = love.filesystem.read(modp .. "/" .. modpath .. "/config.json")
                local modinfo = Ember.lib.dkjson.decode(confdata)
                if type(modinfo) ~= "table" then modinfo = {} end
    
                modinfo.path = modp .. "/" .. modpath
                modinfo.pathDot = modp .. "." .. modpath
    
                modinfo.ran = false
    
                Ember.ModsInfo[modpath] = modinfo
    
                if type(modinfo.api) == "table" and (modinfo.disabled ~= true) then
    
                    local run = false

                    local apiToUse

                    for _, value in pairs(modinfo.api) do
                        if (Ember.APIs[value] == true) or (value == "any") then run = true apiToUse = value end
                    end
                    
                    if run then
                        if Ember.CustomModLoader[apiToUse] then
                            Ember.CustomModLoader[apiToUse]("Mods/" .. v, modinfo)
                        else
                            if love.filesystem.getInfo("Mods/" .. v .. "/main.lua", "file") then
                                modinfo.ran = true
                                require("Mods." .. v .. ".main")
                            elseif love.filesystem.getInfo("Mods/" .. v .. "/mod.lua", "file") then
                                modinfo.ran = true
                                require("Mods." .. v .. ".mod")
                            else
                                print("[Ember] Mod " .. v .. " has no main.lua or mod.lua")
                            end
                        end
                    else
                        print("[Ember] Mod " .. v .. " couldn't find a compatible API")
                    end
                else
                    print("[Ember] Mod " .. v .. " has no API table, or is disabled")
                end
                if modinfo.ran then
                    Ember.Event.CallEvent("LoadedMod", v)
                    print("[Ember] Mod " .. v .. " loaded")
                else
                    print("[Ember] Mod " .. v .. " failed to load")
                end
                
                -- check for "file:" icon (this literally only exists because of creative13 wanting his icon while the mod was disabled)
                if modinfo.icon:sub(1,5) == "file:" then
                    local path = modinfo.icon:sub(6)
                    local icon = love.graphics.newImage("Mods/" .. modpath .. "/" .. path)
                    local texid = "modicon:" .. modinfo.name
                    tex[texid] = {normal = icon, size = {w=icon:getWidth(),h=icon:getHeight(),w2=icon:getWidth()*.5,h2=icon:getHeight()*.5}}
                    modinfo.icon = texid
                end
            else
                print("[Ember] Mod " .. v .. " has no config.json")
                print("[Ember] Mod " .. v .. " failed to load")
            end
        end
    end
    
    Ember.Event.CallEvent("ModsLoaded")
end