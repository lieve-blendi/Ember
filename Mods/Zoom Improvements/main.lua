local zoomatmouse = (love._os ~= "Android" and love._os ~= "iOS")

function ChangeZoom(y)
	if not mainmenu then
		cam.amountzoom = (cam.amountzoom or cam.zoom) * (2 ^ y)
		if zoomatmouse then
			if y > 0 then
				cam.tarx = (cam.tarx * (cam.amountzoom / cam.tarzoom)) + (love.mouse.getX() - (love.graphics.getWidth() / 2)) * y
				cam.tary = (cam.tary * (cam.amountzoom / cam.tarzoom)) + (love.mouse.getY() - (love.graphics.getHeight() / 2)) * y
			elseif y < 0 then
				cam.tarx = (cam.tarx * (cam.amountzoom / cam.tarzoom)) + (love.mouse.getX() - (love.graphics.getWidth() / 2)) * y / 2
				cam.tary = (cam.tary * (cam.amountzoom / cam.tarzoom)) +
					(love.mouse.getY() - (love.graphics.getHeight() / 2)) * y / 2
			end
		else
			cam.tarx = (cam.tarx * (cam.amountzoom / cam.tarzoom))
			cam.tary = (cam.tary * (cam.amountzoom / cam.tarzoom))
		end
		cam.tarzoom = cam.amountzoom
	end
end

function ResetCam()
	cam.x, cam.y, cam.tarx, cam.tary, cam.zoom, cam.tarzoom, cam.amountzoom = 0, 0, 0, 0, 20, 20, 20
end

love.keypressed = Ember.Needle.InjectFunc(love.keypressed, function (func, key,scancode,rep)
	if not mainmenu then
		if (not rep) and (not typing) then
			if key == "c" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("lgui")) and love.keyboard.isDown("lshift") then
				zoomatmouse = not zoomatmouse
				Play("beep")
			end
		end
	
		if key == "=" then
			ChangeZoom(1)
		end
		if key == "-" then
			ChangeZoom(-1)
		end
	end

	func(key,scancode,rep)
end)