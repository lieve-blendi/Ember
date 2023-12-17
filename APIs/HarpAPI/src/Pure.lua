-- Pure is synonm for Native


-- Backwards Compat makes this just interact with _G since y'know, it's all global now :)
local Pure = {}

Pure.code = "\n"
Pure.values = {}

function Pure:Get(name)
    return _G[name]
end

function Pure:GetALL(name)
    return _G[name]
end

function Pure:Set(name, value)
    _G[name] = value
end

function Pure:SetALL(name, value)
    _G[name] = value
end

function Pure:SetKey(name, key, value)
    _G[name][key] = value
end

function Pure:Add(name)
    return
end

function Pure:Unsafe(varname)
    return _G[varname]
end

return Pure