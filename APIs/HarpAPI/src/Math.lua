local Math = {}

Math.euler = 2.7182818284590452353602874713527
Math.phi = (1 + math.sqrt(5)) / 2
Math.tau = math.pi * 2
Math.sqrtPi = math.sqrt(math.pi)

------------------------------------------------------------------------------------------------------------------

---Returns if a number is an integer or not
---@param n number
---@return boolean
function Math:IsInt(n)
    return n%1 ~= 0
end

---Greatest common divisor
---@param x number
---@param y number
---@return number
function Math:GCD(x, y)
    local Result = 0

    local loop = true
    
    while loop do
        if y == 0 then
            Result = x
            loop = false
        else
            local x2 = x
            x = y
            y = x2 % y
        end
    end

    return Result
end

---Gets the sum of a table
---@param numbers number[]
---@return number
function Math:Sum(numbers)
    local Result = 0

    for i = 1, #numbers do
        local value = numbers[i]
        if value == math.huge then return math.huge end
        Result = Result + value
    end

    return Result
end

---Gets the mean number of a table
---@param numbers number[]
---@return number
function Math:Mean(numbers)
    return self:Sum(numbers) / #numbers
end

---Kinda like a binary search
---@param max number
---@param min number
---@param tries integer
---@param func fun(x: number): boolean
---@return number
function Math:Approximator(max, min, tries, func)
    local Result = (max + min) / 2
    
    for i = 1, tries do
        if func(Result) then
            min = Result
        else
            max = Result
        end

        Result = (max + min) / 2
    end

    return Result
end

---Returns the distance between two points in a 2D grid
---@param x number X₁
---@param y number Y₁
---@param a number X₂
---@param b number Y₂
---@return number
function Math:TwoDist(x,y, a,b)
    return math.sqrt((a - x)^2 + (b - y)^2)
end

---Returns if a number is prime or not
---@param n integer
---@return boolean
function Math:IsPrime(n)
    if (n < 2) then return false end
    if (n % 2 == 0) then return (n == 2) end

    local root = math.floor(math.sqrt(n) + 1) -- +1 just to make sure
    for i = 3, root, 2 do
        if (n % i == 0) then return false end
    end

    return true
end

---Returns if a number is composite or not
---@param n integer
---@return boolean
function Math:IsComposite(n)
    if n < 3 then return false end
    return not self:IsPrime(n)
end

local gamma, coeff, quad, qui, set = 0.577215664901, -0.65587807152056, -0.042002635033944, 0.16653861138228, -0.042197734555571
local function recigamma(z)
    return z + gamma * z ^ 2 + coeff * z ^ 3 + quad * z ^ 4 + qui * z ^ 5 + set * z ^ 6
end

---Taken from https://rosettacode.org/wiki/Gamma_function#Lua
---@param z number
---@return number
function Math:Gammafunc(z)
    if z == 1 then return 1
    elseif math.abs(z) <= 0.5 then return 1 / recigamma(z)
    else return (z - 1) * self:Gammafunc(z - 1)
    end
end

Math.factorialCache = {1,2,6,24,120,720,5040,40320,362880,3628800}
Math.factorialCache[-0.5] = Math.sqrtPi
Math.factorialCache[0] = 1
Math.factorialCache[0.5] = Math.sqrtPi / 2

Math.factorialCacheMAX = 1

-- Get the factorial of a number.
---@param n number
---@return number
function Math:Factorial(n)
    if n >= 171 then return math.huge end -- inf after 171!
    if self.factorialCache[n] then return self.factorialCache[n] end

    if n > -1 and n < 1 then -- n! = n * (n - 1)! This means you just need the gamma values for proper fractions
        local Result = self:Gammafunc(n + 1)
        self.factorialCache[n] = Result
        return Result
    end

    -- n! = n * (n - 1)
    -- n! = (n+1)! / (n+1)

    local Result = 0

    if n > 0 then -- Go down if positive
        Result = n * self:Factorial(n - 1)
    else -- Go up if negative
        Result = self:Factorial(n + 1) / (n + 1)
    end

    self.factorialCache[n] = Result
    if self.factorialCacheMAX > n then self.factorialCacheMAX = n end
    return Result
end

function Math:IntFact(n)
    if n >= 171 then return math.huge end -- inf after 171!
    if self.factorialCache[n] then return self.factorialCache[n] end
    
    local Result = self.factorialCache[self.factorialCacheMAX]

    for i = self.factorialCacheMAX, n do
        Result = i * Result
        
        self.factorialCache[i] = Result
        if self.factorialCacheMAX > n then self.factorialCacheMAX =  n end
    end

    return Result
end

return Math