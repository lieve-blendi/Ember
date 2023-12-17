local ToastSystem = {}

ToastSystem.toasts = {}

Ember.Event.AddCallback("PostDraw",function ()
    local toast = ToastSystem.toasts[1]

    if toast then
        local tW, tH = love.graphics.getFont():getWidth(toast[1])*2*uiscale, love.graphics.getFont():getHeight()*2*uiscale

        love.graphics.setColor(1/12,1/12,1/12,1/2)

        love.graphics.rectangle("fill", love.graphics.getWidth()/2 - (tW + 15*uiscale)/2, love.graphics.getHeight()-(tH + 10*uiscale), tW + 15*uiscale, tH + 10*uiscale, 5, 5)

        love.graphics.setColor(1,1,1,1)
        love.graphics.print(toast[1], love.graphics.getWidth()/2 - tW/2, love.graphics.getHeight()-(tH + 5*uiscale), 0, 2*uiscale, 2*uiscale)

        local time = #toast[1] * 0.25

        love.graphics.rectangle("fill", love.graphics.getWidth()/2 - (tW + 15*uiscale)/2, love.graphics.getHeight()-uiscale,(time - (love.timer.getTime() - toast[2]))/time * (tW + 15*uiscale), uiscale)

        if love.timer.getTime() - toast[2] >= time then
            table.remove(ToastSystem.toasts, 1)
            local nexttoast = ToastSystem.toasts[1]
            if nexttoast then nexttoast[2] = love.timer.getTime() end -- Epic bug fix
        end
    end
end)

---Show a toast message
---@param str string
function ToastSystem.ShowToast(str)
    --HarpAPI.SoundSystem:Play(HarpAPI.SoundSystem.beep)
    table.insert(ToastSystem.toasts, {str, love.timer.getTime()})
end

return ToastSystem