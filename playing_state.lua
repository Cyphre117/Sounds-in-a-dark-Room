playing_state = State()

function playing_state:init()
	self.bg = {100, 100, 100}
	-- TODO: incorporate canvas into object
	-- TODO: apply nice effects like bloom?
	self.pips = love.graphics.newCanvas(window_width, window_height)
end

function playing_state:enter()
	love.graphics.setBackgroundColor(self.bg)

	-- Clear the canvas
	love.graphics.setCanvas(self.pips)
	love.graphics.clear(0, 0, 0, 255)
	love.graphics.setCanvas()
end

function playing_state:update(dt)
	Pulse:update_all(dt)
	Sonar:update_all(dt)
	Wall:update_all(dt)
	Zombie:update_all(dt)
	Pip:update_all(dt)

	player:update(dt)

	if #Zombie.all == 0 then
		Level.finish_time = love.timer.getTime()
		Level.won = true
		Gamestate.push(pause_menu_state)
	end
end

function playing_state:draw()
	camera:attach()

    Lava:draw_all()
    Sonar:draw_all()
    Wall:draw_all()
    Zombie:draw_all()

	camera:detach()

	love.graphics.setBlendMode('alpha')
    love.graphics.setCanvas(self.pips)
    love.graphics.setColor(0, 0, 0, 20)
    love.graphics.rectangle('fill', 0, 0, self.pips:getWidth(), self.pips:getHeight())
    
    camera:attach()

    camera:lookAt(player.x, player.y)
	Pip:draw_all()
    Pulse:draw_all()

	camera:detach()

	love.graphics.setCanvas()
	love.graphics.setBlendMode('add')
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.pips, 0, 0)
	love.graphics.setBlendMode('alpha')

	camera:attach()
    camera:lookAt(player.x, player.y)
    player:draw()

    camera:detach()
end

function playing_state:keypressed( keycode, scancode, isrepeat )
	if scancode == 'space' then
		player:use_sonar()
	elseif scancode == 'escape' then
		Gamestate.switch(pause_menu_state)
	end
end

function playing_state:focus( f )
	if not f then
		Gamestate.switch(pause_menu_state)
	end
end