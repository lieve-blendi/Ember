local CategorySystem = {}

CategorySystem.lists = lists

-- Amethyst > Gems
-- Storing > Storage
-- Coins > Collectables
-- Movers > Pushers

local renamedSubcats = {
    ["Amethyst"] = "Gems",
    ["Storing"] = "Storage",
    ["Coins"] = "Collectable",
    ["Movers"] = "Pushers",
}

local function PatchFixedCategory(fixedcat)
    fixedcat.oldGet = fixedcat.Get

    fixedcat.Get = function (slf,name)
        if renamedSubcats[name] then
            name = renamedSubcats[name]
        end
        return fixedcat.oldGet(slf, name)
    end


    return fixedcat
end

function CategorySystem:FixCategory(cat,index) -- keeping the index parameter even tho it's unused in even EmberAPI, and infact, even deleted in EmberAPI
    local fixed = EmberAPI.Category.FixCategory(cat)

    fixed = PatchFixedCategory(fixed)

    return fixed
end

function CategorySystem:FixSubcategory(cat)
    return EmberAPI.Category.FixSubcategory(cat)
end

function CategorySystem:CreateCategory(name, description, icon, startingCells, max)
    return EmberAPI.Category.CreateCategory(name, description, icon, startingCells, max)    
end

function CategorySystem:CreateSubcategory(name, max, desc, icon)
    return EmberAPI.Category.CreateSubcategory(name, max, desc, icon)
end

function CategorySystem:AddToRoot(category, index)
    EmberAPI.Category.AddToRoot(category, index)
end

function CategorySystem:ClearOldCellbarButtons()
    EmberAPI.Category.ClearCellbar()
end

function CategorySystem:RebuildCellbar()
    return EmberAPI.Category.RebuildCellbar()
end

function CategorySystem:GetCategory(name)
    local cat = EmberAPI.Category.GetRootCategory(name)
    cat = PatchFixedCategory(cat)
    return cat
end

function CategorySystem:Get(path)
    return EmberAPI.Category.Get(path)
end

return CategorySystem