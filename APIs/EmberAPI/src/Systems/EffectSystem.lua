local Effect = {}

Effect.drawIcon = {}

function Effect.addEffectIcon(tex,rotate,has)
    table.insert(Effect.drawIcon,{tex,rotate,has})
end

Ember.Event.AddCallback("AfterCellDraw", function (cell,cx,cy,crot,fancy,scale)
    for i = 1, #Effect.drawIcon do
        local tex, rotate, has = table.unpack(Effect.drawIcon[i])

        if has(cell) then
            EmberAPI.Texture.DrawTexture(tex, cx, cy, rotate and crot or 0, cam.zoom,cam.zoom, 0.5, 0.5, true)
        end
    end
end)

return Effect