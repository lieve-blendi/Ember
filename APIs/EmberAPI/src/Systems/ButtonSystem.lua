local Button = {}

function Button.NewButton(...)
    NewButton(...) -- :trell:
end

function Button.DeleteButton(key)
    buttons[key] = nil
    for i, btn in ipairs(buttonorder) do
        if btn == key then
            table.remove(buttonorder, i)
            break
        end
    end
end

return Button