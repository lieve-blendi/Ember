local Sound = {}

--- @type love.Source[]
Sound.SoundCache = {}
Sound.customSFX = {}

Sound.beep = sounds["beep"].sfx
Sound.coinsound = sounds["coin"].sfx
Sound.infectsound = sounds["infect"].sfx
Sound.destroysound = sounds["destroy"].sfx

---Play an sound
---@param aud love.Source
function Sound:Play(aud)
	if aud == nil then return end
	if aud:tell() > .05 then aud:stop() end
	if self.customSFX[aud] then aud:setVolume(sfxvolume) end
	aud:play()
end

---Play an sound, with stacking audios
---@param aud love.Source
function Sound:PlayStack(aud)
	if self.customSFX[aud] then aud:setVolume(HarpAPI.Pure:Get("svolume")) end

	if aud:isPlaying() then
		for index, value in ipairs(self.SoundCache) do
			if not value:isPlaying() then
				self.SoundCache[index] = aud:clone()
				return self:Play(self.SoundCache[index])
			end
		end

		table.insert(self.SoundCache, aud:clone())
		return self:Play(self.SoundCache[#self.SoundCache])
	else
		return self:Play(aud)
	end
end

function Sound:NewSFX(aud)
	self.customSFX[aud] = true
	return aud
end

HarpAPI.Timer:Interval(1, function ()
	if #Sound.SoundCache ~= 0 and not Sound.SoundCache[#Sound.SoundCache]:isPlaying() then
		Sound.SoundCache[#Sound.SoundCache]:release()
		table.remove(Sound.SoundCache,#Sound.SoundCache)
	end
end)

return Sound