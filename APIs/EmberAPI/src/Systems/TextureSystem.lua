local Texture = {}

function Texture.NewTexture(key,val)
    UnloadTex(key)
    if val:sub(-4) == ".png" then
        val = val:sub(1,-5)
    end
	local t = {}
	tex[key] = t
	local f = function()
		local path = ""
		if love.filesystem.getInfo(texpath..val..".png") then path = texpath end
		if love.filesystem.getInfo("textures/"..val..".png") then path = "textures/" end
        if not love.filesystem.getInfo(path..val..".png") then
			DEBUG(path..val..".png not found!")
			tex[key] = nil
			return
		end
		t.normal = love.graphics.newImage(path..val..".png")
		t.size = {w=t.normal:getWidth(),h=t.normal:getHeight(),w2=t.normal:getWidth()*.5,h2=t.normal:getHeight()*.5}
		t.path = val
		--[[local data = love.image.newImageData(path..val..".png")
		t.greyscale = love.graphics.newImage(GreyscaleData(data))
		t.greyscaleinverted = love.graphics.newImage(InvertData(data))
		data:release()
		data = love.image.newImageData(path..val..".png")
		t.inverted = love.graphics.newImage(InvertData(data))
		data:release()]]
	end
	if postloading then f()
	else table.insert(truequeue, f) end
end

function Texture.GetTex(key)
    if key then
        return GetTex(key)
    else
        return tex
    end
end

function Texture.GetTexture(key)
    return GetTex(key).normal
end

function Texture.GetTextureSize(key)
    return GetTex(key).size
end

function Texture.TextureExists(key)
    return tex[key] ~= nil
end

function Texture.SetTexture(key,val)
    tex[key] = val
end

---@param y number
function Texture.DrawTexture(key,x,y,r,w,h,ox,oy,om)
    local size = GetTex(key).size
    if om == true then ox, oy = ox*size.w, oy*size.h end
    love.graphics.draw(GetTex(key).normal, math.floor(x or 0), math.floor(y or 0), r, w/size.w, h/size.h, ox, oy)
end

return Texture