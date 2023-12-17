local TextureSystem = {}
TextureSystem.tex = tex
TextureSystem.Missing = love.graphics.newImage("APIs/HarpAPI/missing.png")
TextureSystem.MissingSize = {w=2,h=2,w2=1,h2=1}

---Get a texture, if key is nil it returns the *tex* table
---@param key any
---@return love.Image|table
function TextureSystem:GetTexture(key)
    return EmberAPI.Texture.GetTexture(key)
end

---Get if a texture exists
---@param key any
---@return boolean
function TextureSystem:TextureExists(key)
   return EmberAPI.Texture.TextureExists(key)
end

function TextureSystem:SetTexture(key, value)
    self.tex[key].normal = value
end

---Get a texture, if key is nil it returns the *tex* table
---@param key any
---@return table
function TextureSystem:GetTexturesize(key)
    return EmberAPI.Texture.GetTextureSize(key)
end

function TextureSystem:SetTexturesize(key, value)
    self.tex[key].size = value
end

------------------------------------------------------------------------------------------------------

--- @param val string|love.Image
--- @param key any
--- @return nil
-- Creates a new texture on the **tex** table from file **val**.
function TextureSystem:NewTex(val, key)
    EmberAPI.Texture.NewTexture(key, val)
end

--- Draws a texture, the with and height will always be the same for all textures.
---@param key any The key of the texture to draw
---@param x number X position
---@param y any Y position
---@param r any Rotation (In radians)
---@param w any Width
---@param h any Height
---@param ox any X position offset
---@param oy any Y position offset
---@param om boolean|nil Offset multiplied by texture lenght?
function TextureSystem:DrawTex(key, x, y, r, w, h, ox, oy, om)
    EmberAPI.Texture.DrawTexture(key,x,y,r,w,h,ox,oy,om)
end

return TextureSystem