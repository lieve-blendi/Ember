local Save = {}

Save.formats = {}
Save.currentFormat = "K3;"
---@type string
local text = buttons["savelvl"].desc -- "Save Level","Saves to clipboard.\nNote: Saves the#ffff80 initial#x state, not the current state.\nFormat: K3"
local location = text:find("Format: [A-Z][0-9]") -- lua pattern so KyYay can make F6 or whatever and it still works
text = text:gsub("Format: [A-Z][0-9]", "")

function Save.CreateFormat(signature, encoder, decoder)
    Save.formats[signature] = {
        encoder = encoder,
        decoder = decoder
    }
end

function Save.SetCurrentFormat(signature)
    Save.currentFormat = signature
    buttons["savelvl"].desc = text:sub(1,location-1) .. "Format: " .. signature:sub(1,#signature-1) .. text:sub(location-1)
end

-- Injections:

SaveWorld = Ember.Needle.InjectFunc(SaveWorld, function(fn)
    if Save.currentFormat ~= "K3;" then
        Save.formats[Save.currentFormat].encode()
        return
    end

    return fn()
end)

LoadWorld = Ember.Needle.InjectFunc(LoadWorld, function(fn)
    local txt = love.system.getClipboardText()

    for sig, format in pairs(Save.formats) do
        if string.sub(txt, 1, #sig) == sig then
            format.decode()
            EmberAPI.Sound.play("beep")
            return
        end
    end

    return fn()
end)

-- this is the only one that needs to be overwritten since it's the only one that's directly equal to the function, and not a function that calls it
-- (yes that means HarpAPI did too much button stuff, or atleast, it wasn't very important)
buttons["savelvl"].onclick = SaveWorld

return Save