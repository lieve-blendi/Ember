-- Syringe by hd28br
local Syringe = {}

--- @param func function
--- @param inject function
--- @return function
-- Inject function takes the original function and its arguments
function Syringe.InjectFA(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        return inject(func, ...)
    end
end

--- @param func function
--- @param inject function
--- @return function
-- Injects a function before the function that has been injected starts
function Syringe.InjectInFunction(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        inject(...)
        return func(...)
    end
end

--- @param func function
--- @param inject function
--- @return function
-- Injects a function after the function that has been injected starts
function Syringe.InjectPostFunction(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        local returned = func(...)
        inject(...)
        return returned
    end
end

--- @param func function
--- @param inject function
--- @return function
--- If the inject function returns true, run the funtion that has been injected
function Syringe.InjectSwitchFunction(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        if inject(...) then return func(...) end
    end
end

--- @param func function
--- @param inject function
--- @return function
--- If the inject function returns nil, run the funtion that has been injected and return its returned value, else, return the value that the inject function returned
function Syringe.InjectSNRFunction(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        local R = inject(...)
        if R == nil then return func(...) else return R end
    end
end

--- @param func function
--- @param inject function
--- @return function
--- Inject function gets result of function that it has been injected to + its arguments
function Syringe.InjectChangeFunction(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        return inject(func(...), ...)
    end
end

--- @param func function
--- @param inject function
--- @return function
--- Idk lol - blaumeise20
function Syringe.InjectBlauFunction(func, inject)
    assert(type(func) == "function", "Attempted to inject into a non-function")
    assert(type(inject) == "function", "Attempted to inject a non-function into a function")

    return function(...)
        local res = func(...)  -- The result of the injected function
        local change, newval = inject(res, ...) -- Option to change the return value
        if change then return newval end -- If change is true, return the new value
        return res -- If false then just return the old one

        --[[
            Syringe.InjectChangeFunction(func, function (res, arg1, arg2)
                -- You can just choose to return the value on the inject change function

                return res -- Will just return the original return value
            end
        ]]
    end
end


return Syringe