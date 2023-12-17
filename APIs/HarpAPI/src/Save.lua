local Save = {}

function Save:CreateSavingFormat(signature, encoder, decoder)
    EmberAPI.Save.CreateFormat(signature, encoder, decoder)
    EmberAPI.Save.SetCurrentFormat(signature)
end

return Save