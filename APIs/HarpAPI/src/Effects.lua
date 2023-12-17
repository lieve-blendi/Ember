local Effects = {}

Effects.FreezeCell = FreezeCell
Effects.ProtectCell = ProtectCell

function Effects:AddEffectIcon(tex,rotate,has)
    return EmberAPI.Effect.addEffectIcon(tex,rotate,has)
end

return Effects