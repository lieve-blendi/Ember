-- Based of JavaScript's timer stuff
local Timer = {}
Timer.times = {}
Timer.events = {}

function Timer:Update(dt)
    for i = 1, #self.events do
        local event = self.events[i]

        if event[1] == "timeout" then -- Timeout
            if love.timer.getTime() > event[2] then
                event[3]()

                self.events[i] = nil
            end
        else -- Interval
            if love.timer.getTime() > event[2] then
                event[4]()

                event[2] = love.timer.getTime() + event[3] -- Add more to the timer so it repeats
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------

function Timer:Cancel(timer)
    self.events[timer] = nil
end

---Executes **func** after **seconds**
---@param seconds number
---@param func function
---@return integer
function Timer:Timeout(seconds, func)
    table.insert(self.events, { "timeout", love.timer.getTime() + seconds, func })

    return #self.events
end

---Executes **func** __**REPEATED**__ after **seconds**
---@param seconds number
---@param func function
function Timer:Interval(seconds, func)
    table.insert(self.events, { "interval", love.timer.getTime() + seconds, seconds, func })

    return #self.events
end


function Timer:Str(seconds)
    local Result = math.floor(seconds*100)/100 .. "s"
    
    if (seconds < 1) then Result = math.floor(seconds*1000 *100)/100 .. "ms" end
    if (seconds < 0.005) then Result = math.floor(seconds*1000000 *100)/100 .. "μ" end
    if (seconds < 0.000002) then Result = math.floor(seconds*1000000000 *100)/100 .. "ns" end

    return Result
end

function Timer:Time(label)
    self.times[label] = love.timer.getTime()
end

---Stop a time
---@param label any
---@param silent boolean|nil
---@return number
function Timer:TimeEnd(label, silent)
    local ammount = love.timer.getTime() - self.times[label]
    self.times[label] = nil
    if not silent then print(label .. ": " .. self:Str(ammount)) end

    return ammount
end

return Timer