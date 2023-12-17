EmberAPI = {}

-- this code ***could*** have worked, but it messed up my intellisense lol
-- for i,v in ipairs(love.filesystem.getDirectoryItems("APIs/EmberAPI/src/Systems")) do
--     if v:sub(-4) == ".lua" then
--         v = v:sub(1, -5)
--     end
--     local compName = v:sub(1, -7)
--     EmberAPI[compName] = require("APIs.EmberAPI.src.Systems." .. v)
--     --print("[EmberAPI] Loaded " .. compName .. " System")
-- end

EmberAPI.Button = require("APIs.EmberAPI.src.Systems.ButtonSystem")
EmberAPI.Category = require("APIs.EmberAPI.src.Systems.CategorySystem")
EmberAPI.Cell = require("APIs.EmberAPI.src.Systems.CellSystem")
EmberAPI.Color = require("APIs.EmberAPI.src.Systems.ColorSystem")
EmberAPI.Effect = require("APIs.EmberAPI.src.Systems.EffectSystem")
EmberAPI.Internet = require("APIs.EmberAPI.src.Systems.InternetSystem")
EmberAPI.Menu = require("APIs.EmberAPI.src.Systems.MenuSystem")
EmberAPI.Save = require("APIs.EmberAPI.src.Systems.SaveSystem")
EmberAPI.Sound = require("APIs.EmberAPI.src.Systems.SoundSystem")
EmberAPI.Texture = require("APIs.EmberAPI.src.Systems.TextureSystem")
EmberAPI.Puzzle = require("APIs.EmberAPI.src.Systems.PuzzleSystem")

print("[EmberAPI] Systems Loaded")

--print("[EmberAPI] Finished Loading")