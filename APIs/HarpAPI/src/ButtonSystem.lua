local ButtonSystem = {}
ButtonSystem.buttons = HarpAPI.Pure:GetALL("buttons")
ButtonSystem.buttonorder = buttonorder

ButtonSystem.bactive = bactive
ButtonSystem.optionbactive = optionbactive
ButtonSystem.strictbactive = strictbactive
ButtonSystem.stricterbactive = stricterbactive
ButtonSystem.wactive = wactive
ButtonSystem.mble = mble
ButtonSystem.mbleandnopuz = mbleandnopuz
-- ButtonSystem.mmenu1 = mmenu1
-- ButtonSystem.mmenu2 = mmenu2
ButtonSystem.exitbtn = exitbtn

function ButtonSystem:GetButtons()
    return buttons
end

function ButtonSystem:SetButton(key, value)
    buttons[key] = value
end

function ButtonSystem:GetButtonorder()
    return buttonorder
end

function ButtonSystem:SetButtonorder(key, value)
    buttonorder[key] = value
end

--------------------------------------------------------------------------------------------------------------if

---Create a new button
---@param x number X position
---@param y number Y position
---@param w number Width
---@param h number Height
---@param icon any Texture of the button
---@param key any Key of the button
---@param name string|nil The name that shows when you hover over it
---@param desc string|nil The description that shows when you hover over it
---@param onclick function Is run when you click on the button
---@param ishold boolean If true, the button will run repeatedly the onclick function
---@param enabledwhen function Returns true for it to apear, false to disapear
---@param alignment "bottomleft"|"left"|"topleft"|"bottomright"|"right"|"topright"|"top"|"bottomleft"|"bottom"|"bottomright"|"center"
---@param rot number|nil The rotation in radians
---@param color table|nil Color
---@param hovercolor table|nil Color
---@param clickcolor table|nil Color
---@return table button The button
function ButtonSystem:NewButton(x,y,w,h,icon,key,name,desc,onclick,ishold,enabledwhen,alignment,rot,color,hovercolor,clickcolor)
    color = color or {1,1,1,.5}
	hovercolor = hovercolor or {1,1,1,1}
	clickcolor = clickcolor or {.5,.5,.5,1}
	local halign = (alignment == "bottomleft" or alignment == "left" or alignment == "topleft") and -1 or (alignment == "bottomright" or alignment == "right" or alignment == "topright") and 1 or 0
	local valign = (alignment == "topleft" or alignment == "top" or alignment == "topright") and -1 or (alignment == "bottomleft" or alignment == "bottom" or alignment == "bottomright") and 1 or 0
	local button = {x=x,y=y,w=w,h=h,rot=rot,icon=icon,name=name,priority=3500,desc=desc,onclick=onclick,ishold=ishold,isenabled=(enabledwhen == nil and true or enabledwhen),halign=halign,valign=valign,color=color,hovercolor=hovercolor,clickcolor=clickcolor}
    if not self.buttons[key] then table.insert(buttonorder,key) end
    self.buttons[key] = button
	return button
end

---Delete a button by key
---@param key any
function ButtonSystem:DeleteButton(key)
    EmberAPI.Button.DeleteButton(key)
end

return ButtonSystem