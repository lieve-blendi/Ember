local Colors = {}

Colors.rainbow = {}

---Fixes a color
-- {1234.0, -1.0, 0.5} -> {1.0, 0.0, 0.5}
---@param color number[]
---@return number[]
function Colors:FixColor(color)
    return {math.min(math.max(color[1] or 0, 0), 1), math.min(math.max(color[2] or 0, 0), 1), math.min(math.max(color[3] or 0, 0), 1), math.min(math.max(color[4] or 1, 0), 1)}
end

---Convert a HEX color to a table color
---#ffffff -> {1,1,1}
---Works with RGB and RGBA
---@param hex string
---@return number[]
function Colors:HEXtoRGBA(hex)
    if hex:sub(1,1) == "#" then return self:HEXtoRGBA(hex:sub(2,#hex)) end

    return {
        tonumber(hex:sub(1,2), 16) / 255,
        tonumber(hex:sub(3,4), 16) / 255,
        tonumber(hex:sub(5,6), 16) / 255,
        (tonumber(hex:sub(7,8), 16) or 255) / 255,
    }
end

function Colors:RGBAtoHEX(color)
    local function HexOne(val)
        local result = string.format("%x", math.floor(val * 255))
        return string.rep("0", 2 - #result) .. result
    end

    return HexOne(color[1] or 0) .. HexOne(color[2] or 0) .. HexOne(color[3] or 0) .. HexOne(color[4] or 0)
end

---Generates a random color
---@return number[]
function Colors:Random()
    return {love.math.random(), love.math.random(), love.math.random()}
end

function Colors:Rainbow(a)
    return {(math.sin(-love.timer.getTime()))+0.75,(math.sin(-love.timer.getTime()+math.pi*2/3))+0.75,(math.sin(-love.timer.getTime()+math.pi*4/3))+0.75,a}
end

function Colors:Colorize(text)
    local Result = {{1,1,1}, ""}

    for i = 1, #text do
        local char = text:sub(i, i)

        if char == "#" then
            local nextChar = text:sub(i + 1, i + 1)

            if nextChar == "#" then
                Result[#Result] = Result[#Result] .. "#"
            else -- Colors
                if nextChar == "r" then table.insert(Result, {1,0,0}) end        -- Red
                if nextChar == "g" then table.insert(Result, {0,1,0}) end        -- Green 
                if nextChar == "b" then table.insert(Result, {0,0,1}) end        -- Blue
                if nextChar == "y" then table.insert(Result, {1,1,0}) end        -- Yellow
                if nextChar == "o" then table.insert(Result, {1,0.5,0}) end      -- Orange
                
                if nextChar == "w" then table.insert(Result, {1,1,1}) end        -- White
                if nextChar == "l" then table.insert(Result, {0,0,0}) end        -- black

                if nextChar == "R" then table.insert(Result, Colors.rainbow) end -- Rainbow

                table.insert(Result, "")
            end
        elseif text:sub(i - 1, i - 1) ~= "#" then
            Result[#Result] = Result[#Result] .. char
        end
    end

    return Result
end

function Colors:Concatenate(a, b)
    if type(a) == "string" and type(b) == "string" then return a .. b end
    
    local Result = type(a) == "table" and table.copy(a) or {}

    if type(a) == "table" then
        for i = 1, #b do
            table.insert(Result, b[i])
        end
    else
        table.insert(Result, a)

        for i = 1, #b do
            table.insert(Result, b[i])
        end
    end

    return Result
end

return Colors