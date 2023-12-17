local Grid = {}

Grid.cells = layers[0]

function Grid:Dir(dir)
    if type(dir) == "number" then return dir % 4 end

    if type(dir) == "string" then
        if dir == "left" or dir == "back" then return 0 end
        if dir == "right" or dir == "front" then return 2 end
        if dir == "down" then return 1 end
        if dir == "up" then return 3 end
    end

    return 0
end

function Grid:Getempty()
    return getempty()
end

function Grid:SetCell(x, y, cell)
    return SetCell(x, y, cell)
end

function Grid:GetCell(x, y)
    return GetCell(x, y)
end

function Grid:GetWidth()
    return width
end

function Grid:GetHeight()
    return height
end


function Grid:PushCell(x, y, dir, lastvars)
    return PushCell(x, y, self:Dir(dir), lastvars)
end

function Grid:PullCell(x, y, dir, lastvars)
    return PullCell(x, y, self:Dir(dir), lastvars)
end

function Grid:GraspCell(x, y, dir, lastvars)
    return GrabCell(x, y, self:Dir(dir), lastvars)
end

Grid.GrabCell = Grid.GraspCell

function Grid:NudgeCell(x, y, dir, vars)
    return NudgeCell(x, y, self:Dir(dir), vars)
end

function Grid:RotateCell(x,y,rot,dir,large)
    HarpAPI.Pure:Get("RotateCell")(x,y,rot,self:Dir(dir),large)
end


function Grid:FreezeCell(x, y, dir, large)
    return FreezeCell(x, y, dir, large)
end

function Grid:ProtectCell(x, y, dir, size)
    return ProtectCell(x, y, dir, size)
end

HarpAPI.Events.channel:on("grid-clear", function ()
    Grid.cells = layers[0]
end)

return Grid