HarpAPI = {}

CoreHarp = Ember

-- -1 = A test version < kept as a test version since backwards-compat isn't a full version imo
HarpAPI.numberversion = -1
HarpAPI.dayversion = -1 -- negative one since it's not really an actual version of harp
HarpAPI.stringversion = "Backwards-Compatibility"

--- @type "2.-1.5"|"2.-1.6tb3"
HarpAPI.gameversion = "2.-1.5"

-- This is the EventChannel class, use HarpAPI.Events to use the actual game events.
HarpAPI.EventChannel = nil -- i'll make this work differently (L)
HarpAPI.Syringe = require("APIs.HarpAPI.src.Syringe") -- paths for the Harp interactions changed because harp/coreharp does not exist in backwards-compat
HarpAPI.Patcher = require("APIs.HarpAPI.src.Patcher") -- < functions exist but don't do anything
HarpAPI.JSON = require("Ember.lib.dkjson") -- < this isn't the **same** json library the original used, but it should.. usually... be fine

HarpAPI.Math = require("APIs.HarpAPI.src.Math") -- < kept exactly the same
HarpAPI.Colors = require("APIs.HarpAPI.src.Colors") -- < kept exactly the same
HarpAPI.Timer = require("APIs.HarpAPI.src.Timer") -- < the same, but bugfix
HarpAPI.Internet = require("APIs.HarpAPI.src.Internet") -- < the same

if ip and getsplash and layers then
    if EncryptWithKey then
    --     HarpAPI.gameversion = "2.0.0" -- we must lie and say it's still 2.-1.6tb3, otherwise some mods will refuse to boot
    -- else
        HarpAPI.gameversion = "2.-1.6tb3"
    end
end

HarpAPI.tickcount = 0

--- @param n string
--- @return any
-- Native part removed since backwards-compat
function HarpAPI.GetLocal(n)
    return _G[n]
end

--- @param n string
--- @param v any
--- @return nil
-- Native part removed since backwards-compat
function HarpAPI.SetLocal(n, v)
    _G[n] = v
end

--- @param n any
--- @param v any
--- @return nil
-- Native part removed since backwards-compat
function HarpAPI.SetLocalKey(n, w, v)
    _G[n][w] = v
end

--- @param n string
--- @return nil
-- Everything it needs is already global.
function HarpAPI.Delocalize(n)
end

---Clears a table without changing it's pointer
---@param tab table
function HarpAPI.ClearTable(tab)
    for key, _ in pairs(tab) do
        tab[key] = nil
    end
end

HarpAPI.subtextModifiers = {}
function HarpAPI.ModifySubtex(fun)
    --versiontxt = versiontxt .. "\n" .. fun(versiontxt)
end

---------------------------------------------------------------------------------------------------------------

-- almost all of these will have changed, atleast a little
HarpAPI.Events = require("APIs.HarpAPI.src.Events") -- done
HarpAPI.Pure = require("APIs.HarpAPI.src.Pure") -- done
HarpAPI.Texture = require("APIs.HarpAPI.src.TextureSystem") -- done
HarpAPI.Button = require("APIs.HarpAPI.src.ButtonSystem") -- done
HarpAPI.Cells = require("APIs.HarpAPI.src.CellsSystem") -- done (might be semi-incompatible with complicated mods, tho)
HarpAPI.Category = require("APIs.HarpAPI.src.CategorySystem") -- done
HarpAPI.Menu = require("APIs.HarpAPI.src.MenuSystem") -- done
HarpAPI.Toast = require("APIs.HarpAPI.src.ToastSystem") -- done
HarpAPI.Sound = require("APIs.HarpAPI.src.SoundSystem") -- done (kinda shit)
HarpAPI.Grid = require("APIs.HarpAPI.src.Grid") -- done
HarpAPI.Particle = require("APIs.HarpAPI.src.ParticleSystem") -- done
HarpAPI.Effects = require("APIs.HarpAPI.src.Effects") -- done
HarpAPI.Save = require("APIs.HarpAPI.src.Save") -- done
HarpAPI.Propriety = require("APIs.HarpAPI.src.Propriety") -- done
HarpAPI.Paint = require("APIs.HarpAPI.src.Paint") -- done (this one is actually the exact same as HarpAPI version!)
HarpAPI.Typing = require("APIs.HarpAPI.src.typing") -- not ported because it's shit

--HarpAPI.SubticksCopy = table.copy(subticks)

HarpAPI.Events:OnClear(function ()
    HarpAPI.tickcount = 0
end)

table.insert(subticks, 1, function ()
    HarpAPI.tickcount = HarpAPI.tickcount + 1
end)

HarpAPI.Events:OnUpdate(function (dt)
    HarpAPI.Timer:Update(dt)
end)

-- HarpAPI.Events:OnLoad(function ()
--     if splashes then
--         require("APIs.HarpAPI.splashes")
--     end
-- end)

-- if HarpAPI.gameversion == "2.-1.6tb3" then
--     HarpAPI.Toast:ShowToast("[HarpAPI] 2.-1.6 support isn't finished yet!")
-- end

HarpAPI.ModifySubtex(function (t)
    return "#ffff00HarpAPI #ff0000[" .. HarpAPI.stringversion .. "]"
end)

HarpAPI.Events:OnUpdate(function (delta) -- Update rainbow color
    local color = HarpAPI.Colors:Rainbow(love.timer.getTime())

    HarpAPI.Colors.rainbow[1] = color[1]
    HarpAPI.Colors.rainbow[2] = color[2]
    HarpAPI.Colors.rainbow[3] = color[3]
end)