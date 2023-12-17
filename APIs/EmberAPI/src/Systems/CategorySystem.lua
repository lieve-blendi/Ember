local Category = {}

function Category.FixCategory(cat) -- allows :Add and :Get to be used on a category
    if type(cat) ~= "table" then return cat end
    if cat.isFixed then return cat end
    local Result = {}

    Result.isFixed = true
    Result.cat = cat
    Result.index = nil

    function Result:Add(item,index)
        local element = (type(item) == "table" and item.isFixed) and item.subcat or item

        if index == nil then
            table.insert(self.cat.cells, element)
        else
            table.insert(self.cat.cells, index, element)
        end
    end

    function Result:Get(name)
        for _, item in ipairs(self.cat.cells) do
            if type(item) == "table" then
                if item.name == name then return Category.FixSubcategory(item) end
            end
        end
    end

    return Result
end

function Category.FixSubcategory(subcat)
    if type(subcat) ~= "table" then return subcat end
    if subcat.isFixed then return subcat end
    local Result = {}

    Result.isFixed = true
    Result.subcat = subcat

    function Result:Add(item,index)
        if item == nil then return end
        if index == nil then
            table.insert(self.subcat, item)
        else
            table.insert(self.subcat, index, item)
        end
    end

    function Result:Get(name)
        for i = 1, #self.subcat do
            local cell = self.subcat[i]
            if EmberAPI.Cell.GetInfo(cell) == name then
                return {i, cell}
            end
        end
    end

    function Result:Remove(item)
        for i = 1, #self.subcat do
            local cell = self.subcat[i]
            if cell == item then
                table.remove(self.subcat, i)
                break
            end
        end
    end

    return Result
end

function Category.CreateCategory(name, desc, icon, startCells, max)
    startCells = startCells or {}
    if not EmberAPI.Texture.TextureExists(icon) then EmberAPI.Texture.NewTexture(icon, icon) end
    
    return Category.FixCategory({
        name = name,
        desc = desc,
        icon = icon,
        max = max,
        cells = startCells,
    })
end

function Category.CreateSubcategory(name,max,desc,icon)
    if icon and not EmberAPI.Texture.TextureExists(icon) then EmberAPI.Texture.NewTexture(icon, icon) end

    return Category.FixSubcategory({
        name = name,
        desc = desc,
        icon = icon,
        max = max,
    })
end

function Category.AddToRoot(category,index)
    local cat = category
    if cat.isFixed then cat = category.cat end

    if index == nil then
        table.insert(lists, cat)
    else
        table.insert(lists, index, cat)
    end
end

function Category.GetRootCategory(name)
    for i,v in pairs(lists) do
        if v.name == name then return Category.FixCategory(v) end
    end
end

function Category.Get(path)
    local Result = nil

    for str in string.gmatch(path, "([^/]+)") do
        if Result == nil then
            Result = Category.GetRootCategory(str)
        else
            Result = Result:Get(str)
        end
    end

    return Result
end

function Category.ClearCellbar()
    -- reverse version of RebuildCellbar, kinda
    -- for i=1,50 do
    --     EmberAPI.Button.DeleteButton("propertytype"..i)
    --     EmberAPI.Button.DeleteButton("propertyadd"..i)
    --     EmberAPI.Button.DeleteButton("propertysub"..i)
    -- end
    for k,v in pairs(buttons) do
        if k:sub(1,4) == "list" then -- look, i know this isn't the cleanest way to do this, but it will work, trust me. i'm a dolphin.
            EmberAPI.Button.DeleteButton(k)
        end
    end
    lastselects = {}
end

function Category.RebuildCellbar()
    CreateCategories() -- just calls the real one :trell:
end

return Category