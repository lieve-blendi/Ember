local Cells = {}
Cells.cells = layers[0]
Cells.initial = initiallayers[0]

function Cells:GetInfo(id)
    return EmberAPI.Cell.GetInfo(id)
end

function Cells:SetInfo(id,val)
    EmberAPI.Cell.SetInfo(id,val)
end

function Cells:GetRandomCellID()
    return EmberAPI.Cell.RandomCellID()
end

function Cells:GetRandomCellINFO()
    return EmberAPI.Cell.RandomCellInfo()
end

function Cells:GetDimensions()
    return EmberAPI.Cell.GetGridSize()
end

function Cells.enemyDestroyer(cell,dir,x,y,vars)
    return EmberAPI.Cell.enemyDestroyer(cell,dir,x,y,vars)
end

function Cells:CreateCell(title, description, texture, options)
    return EmberAPI.Cell.CreateCell(title, description, texture, options)
end

return Cells