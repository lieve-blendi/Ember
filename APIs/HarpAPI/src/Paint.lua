local Paint = {}

---@type function[]
Paint.customPaints = {}

---Make a new custom paint
---@param func function
function Paint:NewPaint(func)
    table.insert(self.customPaints, func)
end

function Paint:ApplyPaint(ctex, ctexsize, cell)
    for i = 1, #self.customPaints do
        local A, B = self.customPaints[i](ctex, ctexsize, cell)

        if A ~= false then
            return A, B
        end
    end

    return ctex, ctexsize
end

return Paint