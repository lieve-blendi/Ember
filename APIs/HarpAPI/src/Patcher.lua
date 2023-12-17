local Patcher = {}

Patcher.code = love.filesystem.read("main.lua")

function Patcher:PatchMainLine(matchLine, code)
    return
end

---Patch the main.lua file, injecting the code before require("harp.main")
---@param code string
function Patcher:PatchMain(code)
    return
end

---Patch the main.lua file, injecting the code AFTER main.lua
---@param code string
function Patcher:PatchMainAfter(code)
    return
end

---Patch the main.lua file, injecting the code BEFORE main.lua
---@param code string
function Patcher:PatchMainBefore(code)
    return
end

---Replace code, only replaces first occourence
---@param search string
---@param code string
function Patcher:PatchMainReplace(search, code)
    return
end


---Replace code, replaces ALL occourences
---@param search string
---@param code string
function Patcher:PatchMainReplaceALL(search, code)
    return
end

---comment
---@param search string
---@param code string
function Patcher:PatchMainAdd(search, code)
    return
end

---comment
---@param search string
---@param code string
function Patcher:PatchMainAddALL(search, code)
    return
end

return Patcher