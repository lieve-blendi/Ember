local Color = {}

Color.rainbow = {}

function Color.FixColor(color)
    return {math.min(math.max(color[1] or 0, 0), 1), math.min(math.max(color[2] or 0, 0), 1), math.min(math.max(color[3] or 0, 0), 1), math.min(math.max(color[4] or 1, 0), 1)}
end

function Color.HexToRGBA(hex)
    if hex:sub(1,1) == "#" then hex = hex:sub(2) end

    return {
        tonumber(hex:sub(1,2), 16) / 255,
        tonumber(hex:sub(3,4), 16) / 255,
        tonumber(hex:sub(5,6), 16) / 255,
        (tonumber(hex:sub(7,8), 16) or 255) / 255,
    }
end

local function HexOne(val)
    local result = string.format("%x", math.floor(val * 255))
    return string.rep("0", 2 - #result) .. result
end

function Color.RGBAToHex(color)
    return HexOne(color[1] or 0) .. HexOne(color[2] or 0) .. HexOne(color[3] or 0) .. HexOne(color[4] or 0)
end

function Color.Random()
    return {love.math.random(), love.math.random(), love.math.random()}
end

function Color.Rainbow(a)
    return {(math.sin(-love.timer.getTime()))+0.75,(math.sin(-love.timer.getTime()+math.pi*2/3))+0.75,(math.sin(-love.timer.getTime()+math.pi*4/3))+0.75,a}
end

return Color