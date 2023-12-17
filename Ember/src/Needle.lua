local Needle = {}

function Needle.InjectFunc(func,inj)
    func = func or function () end
    inj = inj or function () end
    return function (...)
        return inj(func,...)
    end
end

return Needle