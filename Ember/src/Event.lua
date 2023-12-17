local Event = {}

Event.Events = {}

Event.CallEvent = function (id,...)
    if Event.Events[id] then
        for i, v in ipairs(Event.Events[id]) do
            v(...)
        end
    end
end

Event.AddCallback = function (id,func)
    if not Event.Events[id] then
        Event.Events[id] = {}
    end
    table.insert(Event.Events[id],func)
end

return Event