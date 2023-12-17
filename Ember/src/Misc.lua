local APIWait = {}
local APIsdone = false

function Ember.WaitForAPI(api,callback)
    if APIsdone then
        callback()
        return
    end
    Ember.APIWait[api] = Ember.APIWait[api] or {}
    table.insert(Ember.APIWait[api],callback)
end

function Ember.RunAPIWaits(api)
    if APIWait[api] then
        for i,v in pairs(Ember.APIWait[api]) do
            v()
        end
        Ember.APIWait[api] = nil
    end
end

function Ember.AllAPIsLoaded()
    for i,v in pairs(APIWait) do
        if #v > 0 then
            for j,w in pairs(v) do
                w()
            end
        end
        Ember.APIWait[i] = nil
    end
    APIsdone = true
end