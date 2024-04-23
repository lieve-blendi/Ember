local Cell = {}

function Cell.GetInfo(id)
    return cellinfo[id]
end

function Cell.SetInfo(id, info)
    cellinfo[id] = info
end

function Cell.RandomCellID()
    local ids = {}

    for key, value in pairs(cellinfo) do
        if value.desc ~= "Cell info was not set for this id." then table.insert(ids, key) end
    end

    return ids[love.math.random(1, #ids)] 
end

function Cell.RandomCellInfo()
    local ids = {}

    for key, value in pairs(cellinfo) do
        if value.desc ~= "Cell info was not set for this id." then table.insert(ids, value) end
    end

    return ids[love.math.random(1, #ids)]
end

function Cell.GetGridSize()
    return width,height
end

function Cell.enemyDestroyer(cell,dir,x,y,vars)
    return ((vars.forcetype == "push" or vars.forcetype == "nudge") and vars.forcetype ~= "swap") and (cell.protected ~= true and vars.lastcell.protected ~= true)
end

Cell.destroyers = {}
Cell.idMaps = {}
Cell.stopOptimization = {}
Cell.nextCells = {}
Cell.toGenerates = {}
Cell.transparent = {}
Cell.unbreakable = {}
Cell.onPlace = {}
Cell.whenSelected = {}
Cell.idConversion = {}
Cell.flipmode = {}
Cell.nonexistant = {}
Cell.custompush = {}
Cell.onSetCell = {}
Cell.onCellDraw = {}
Cell.whenRotated = {}
Cell.acidic = {}
Cell.customprepush = {}
Cell.whenClicked = {}
Cell.specialTypes = {}
Cell.defaultVars = {}
Cell.copyVars = {}
Cell.dynamicTexture = {}
Cell.layer = {}


---Probably the most important thing in modding
---@param title string
---@param description string
---@param texture any
---@param options table
---@return any
function Cell.CreateCell(title, description, texture, options)
    local id = options.id or (#tex + 1)
    options = options or {}

    EmberAPI.Texture.NewTexture(id, texture)

    Cell.SetInfo(id, {
        name = title or "Unnamed",
        desc = description or "No description available",
    })

    -- just realized how much is unimplemented here, will update later

    -- Cell.destroyers[id] = options.isDestroyer
    MergeIntoInfo("isdestroyer", {[id] = options.isDestroyer})
    Cell.idMaps[id] = options.maptoID -- unimplemented
    Cell.stopOptimization[id] = options.shouldStopOptimization
    Cell.nextCells[id] = options.bendNextCells -- unimplemented
    -- Cell.toGenerates[id] = options.transformWhenGenerated
    MergeIntoInfo("togenerate",{[id]=options.transformWhenGenerated}) -- NEEDS TO BE A FUNCTION!!!
    -- Cell.transparent[id] = options.isTransparent -- unneeded since vanilla checks transparency by doing isnonexistant or isdestroyer
    Cell.unbreakable[id] = options.unbreakability
    Cell.onPlace[id] = options.whenPlaced -- unimplemented
    Cell.whenSelected[id] = options.whenSelected
    Cell.nonexistant[id] = options.isNonexistant
    -- Cell.idConversion[id] = options.ChunkId
    MergeIntoInfo("chunkid", {[id] = options.ChunkId})
    Cell.custompush[id] = options.push
    Cell.onSetCell[id] = options.whenSet
    Cell.onCellDraw[id] = options.whenRendered -- unimplemented
    Cell.whenRotated[id] = options.whenRotated -- unimplemented
    Cell.acidic[id] = options.isAcidic -- unimplemented
    Cell.whenClicked[id] = options.whenClicked -- unimplemented
    Cell.specialTypes[id] = options.specialType -- kinda implemented
    Cell.layer[id] = options.layer
    Cell.customprepush[id] = options.prepush -- unimplemented
    Cell.defaultVars[id] = options.defaultVars -- unimplemented
    Cell.copyVars[id] = options.copyVars -- unimplemented
    Cell.dynamicTexture[id] = options.dynamicTexture -- unimplemented

    if options.specialType == "tool" then
        MergeIntoInfo("istool",{[id]=true})
    end

    if options.isDestroyer then
        MergeIntoInfo("isdestroyer", {[id] = options.isDestroyer})
    end

    if options.ChunkId ~= nil then
        Cell.flipmode[id] = "none"
    else
        Cell.flipmode[id] = options.flipmode or "none"
    end

    if type(options.update) == "function" then
        local updatemode = options.updatemode or "normal"
        local updateindex = options.updateindex
        if type(updatemode) == "table" then
            for i, func in ipairs(updatemode) do
                if type(updateindex) == "number" then
                    table.insert(subticks, updateindex + i - 1, func)
                else
                    table.insert(subticks, func)
                end
            end
        elseif updatemode == "normal" then
            if type(updateindex) == "number" then
                table.insert(subticks, updateindex,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 0 end, options.update, "upleft", ChunkId(id)) end)
                table.insert(subticks, updateindex + 1,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 2 end, options.update, "upright", ChunkId(id)) end)
                table.insert(subticks, updateindex + 2,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 3 end, options.update, "rightdown", ChunkId(id)) end)
                table.insert(subticks, updateindex + 3,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 1 end, options.update, "rightup", ChunkId(id)) end)
            else
                table.insert(subticks,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 0 end, options.update, "upleft", ChunkId(id)) end)
                table.insert(subticks,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 2 end, options.update, "upright", ChunkId(id)) end)
                table.insert(subticks,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 3 end, options.update, "rightdown", ChunkId(id)) end)
                table.insert(subticks,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) and
                        c.rot == 1 end, options.update, "rightup", ChunkId(id)) end)
            end
        elseif updatemode == "static" then
            if type(updateindex) == "number" then
                table.insert(subticks, updateindex,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) end,
                        options.update, "rightup", ChunkId(id)) end)
            else
                table.insert(subticks,
                    function() return RunOn(function(c) return not c.updated and ChunkId(c.id) == ChunkId(id) end,
                        options.update, "rightup", ChunkId(id)) end)
            end
        end
    end
    
    -- DONE: add category system and make options.category work

    options.catIndex = options.catIndex or options.meowIndex -- < HarpAPI name for the same thing
    if options.category then
        if type(options.category) == "table" and not (options.category.cat or options.category.subcat) then
            for i = 1, #options.category do
                local value = options.category[i]
                local category = type(value) == "string" and EmberAPI.Category.Get(value) or value

                category:Add(id, (options.catIndex or {})[i])
            end
        else
            local category = type(options.category) == "string" and EmberAPI.Category.Get(options.category) or options.category

            category:Add(id, options.catIndex)
        end
    end

    return id
end

-- TODO: injection for handling functions and IsX/GetLayer

StopsOptimize = Ember.Needle.InjectFunc(StopsOptimize, function(fn, cell,dir,x,y,vars)
    return fn(cell,dir,x,y,vars) or Cell.stopOptimization[cell.id]
end)

SetCell = Ember.Needle.InjectFunc(SetCell, function(fn, x,y,cell,z)
    fn(x,y,cell,z)
    if type(Cell.onSetCell[cell.id]) == "function" then
        Cell.onSetCell[cell.id](x,y,cell,z)
    end
end)

HandlePush = Ember.Needle.InjectFunc(HandlePush, function (fn, force,cell,dir,x,y,vars)
    local id = cell.id
	local rot = cell.rot
	local side = ToSide(rot,dir)
	local gfactor = cell.vars.gravdir and (cell.vars.gravdir%4 == dir and 1 or cell.vars.gravdir%4 == (dir+2)%4 and -1 or 0) or 0
	local lid = vars.lastcell.id
	local lrot = vars.lastcell.rot
	if not vars.skipfirst or vars.repeats > 0 then
        if type(Cell.custompush[id]) == "function" then
            local p = Cell.custompush[id](cell,dir,x,y,vars,side,force+gfactor, "push")
            if p == true then return force + gfactor end
            if p == false then return 0 end
            if type(p) == "number" then return p end
        end
    end

    return fn(force,cell,dir,x,y,vars)
end)

HandlePull = Ember.Needle.InjectFunc(HandlePull, function(fn, force,cell,dir,x,y,vars)
    local id = cell.id
	local rot = cell.rot
	local side = ToSide(rot,dir)
	vars.lastcell = vars.lastcell or getempty()
	vars.lastx,vars.lasty = vars.lastx or x,vars.lasty or y
	vars.firstx,vars.firsty = vars.firstx or vars.lastx,vars.firsty or vars.lasty
    if type(Cell.custompush[id]) == "function" then
        local p = Cell.custompush[cell.id](cell, dir, x, y, vars, side, force, "pull")
        if p == true then return force end
        if p == false then return 0 end
        if type(p) == "number" then return p end
    end

    return fn(force,cell,dir,x,y,vars)
end)

HandleGrab = Ember.Needle.InjectFunc(HandleGrab, function(fn, force,cell,dir,x,y,vars)
    local id = cell.id
	local rot = cell.rot
	local side = ToSide(rot,dir)
	vars.lastcell = vars.lastcell or getempty()
	vars.lastx,vars.lasty = vars.lastx or x,vars.lasty or y
	vars.firstx,vars.firsty = vars.firstx or vars.lastx,vars.firsty or vars.lasty
    if type(Cell.custompush[id]) == "function" then
        local p = Cell.custompush[id](cell, dir, x, y, vars, side, force, "grab")
        if p == true then return force end
        if p == false then return 0 end
        if type(p) == "number" then return p end
    end

    return fn(force,cell,dir,x,y,vars)
end)

HandleNudge = Ember.Needle.InjectFunc(HandleNudge, function(fn, cell,dir,x,y,vars)
    local id = cell.id
	local rot = cell.rot
	local side = ToSide(rot,dir)
	local lid = vars.lastcell.id
	local lrot = vars.lastcell.rot
    if type(Cell.custompush[id]) == "function" then
        return Cell.custompush[id](cell, dir, x, y, vars, side, 1, "nudge")
    end

    return fn(cell,dir,x,y,vars)
end)

HandleSwap = Ember.Needle.InjectFunc(HandleSwap, function(fn, cell,dir,x,y,vars)
    local id = cell.id
	local rot = cell.rot
	local side = ToSide(rot,dir)
	local above = GetCell(x,y,1)
	local aboveside = ToSide(above.rot,dir)

    if type(Cell.custompush[id]) == "function" then
        return Cell.custompush[id](cell, dir, x, y, vars, side, 1, "swap")
    end

    return fn(cell,dir,x,y,vars)
end)

SetSelectedCell = Ember.Needle.InjectFunc(SetSelectedCell, function(fn, id, b)
    if type(Cell.whenSelected[id]) == "function" then
        return Cell.whenSelected[id](b)
    else
        return fn(id, b)
    end
end)

IsNonexistant = Ember.Needle.InjectFunc(IsNonexistant, function(fn, cell,dir,x,y)
    if type(Cell.nonexistant[cell.id]) == "function" then
        return Cell.nonexistant[cell.id](cell, dir, x, y)
    end

    return fn(cell, dir, x, y)
end)

IsUnbreakable = Ember.Needle.InjectFunc(IsUnbreakable, function(fn, cell,dir,x,y,vars)
    local id = cell.id
    local rot = cell.rot
    local side = ToSide(rot,dir)
    vars = vars or {}
    if type(Cell.unbreakable[id]) == "function" then
        return Cell.unbreakable[id](id, dir, x, y, vars, side)
    end

    return fn(cell, dir, x, y, vars)
end)

GetLayer = Ember.Needle.InjectFunc(GetLayer, function(fn, id)
    if type(Cell.layer[id]) == "number" then
        return Cell.layer[id]
    elseif type(Cell.specialTypes[id]) == "string" and Cell.specialTypes[id] == "background" then
        return -1
    end 
    
    return fn(id)
end)

return Cell