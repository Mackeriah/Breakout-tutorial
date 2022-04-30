pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- super breakout
-- owen fitzgerald

function _init() -- runs once at start
	cls(0)
	-- ball info
	ball_x_pos = 51
	ball_y_pos = 7
	ball_x_move = 2
	ball_y_move = 2
	ball_radius = 2
	pulse_speed = 0.5
	
	-- paddle info
	paddle_x_pos = 10
	paddle_y_pos = 110
	paddle_width = 24
	paddle_height = 3
	paddle_x_speed = 5
	paddle_collision = 7	
end

function _update() -- runs every frame	
	screen_paddle_limit()
	paddle_movement()
	screen_bounce()
	ball_movement()
	--ball_pulse()
	paddle_hit_location()	

	-- change paddle colour on collision
	-- if ball_paddle_collision(paddle_x_pos, paddle_y_pos, paddle_width, paddle_height) then
	-- 	paddle_collision = 8
	-- 	sfx(1)
	-- 	ball_y_move = -ball_y_move
	-- else
	-- 	paddle_collision = 7
	-- end
end

function _draw() -- runs every frame (after update)
	cls(0)
	rectfill(0,0,127,127,1) -- the game area
	circfill(ball_x_pos, ball_y_pos, ball_radius, 10) -- draw the ball
	draw_paddle()
	print("save me on github now!", 20, 45, 8)
	--print(location, 0, 0, 8)
	--print('Ball top '..ball_y_pos-ball_radius, 0, 10, 7)
	--print('ball_y_pos+ball_radius '..ball_y_pos+ball_radius, 0, 20, 7)
 --print('ball_x_pos+ball_radius '..ball_x_pos+ball_radius, 0, 30, 7)
	--print('paddle_y_pos+paddle_height '..paddle_y_pos+paddle_height, 0, 40, 7)
	--print('paddle_x_pos+paddle_height '..paddle_x_pos+paddle_height, 0, 50, 7)
	--print('Ball bottom '..ball_y_pos+ball_radius, 0, 20, 7)
	--print('paddle x pos '..paddle_x_pos, 0, 30, 7)
	--print('paddle x plus width '..paddle_x_pos+paddle_width, 0, 40, 7)	
	--print('paddle y pos '..paddle_y_pos, 0, 50, 7)	
	--print('paddle y pos plus height '..paddle_y_pos+paddle_height, 0, 60, 7)		
end

function draw_paddle()
	rectfill(paddle_x_pos, paddle_y_pos, paddle_x_pos+paddle_width, paddle_y_pos+paddle_height, paddle_collision)
end

function ball_movement()
	ball_x_pos += ball_x_move
	ball_y_pos += ball_y_move
end

function ball_pulse()
	ball_radius = ball_radius+pulse_speed
	if ball_radius > 3 or ball_radius < 2 then
		pulse_speed = -pulse_speed
	end	
end

function screen_bounce()
	if ball_x_pos+ball_radius >= 127 or ball_x_pos-ball_radius < 0 then
		ball_x_move = -ball_x_move
		sfx(0)
	end	
	if ball_y_pos+ball_radius >= 127 or ball_y_pos-ball_radius <= 0 then
		ball_y_move = -ball_y_move
		sfx(0)
	end	
end

function screen_paddle_limit()
	if paddle_x_pos+paddle_width > 127 then
	 right_edge = true
		paddle_x_pos = 128-paddle_width
	else
		right_edge = false
	end
	if paddle_x_pos < 1 then
	 left_edge = true
		paddle_x_pos = 0
	else
		left_edge = false	
	end
end

function paddle_movement()
	local button_press = false
	if btn(0) and left_edge == false then
	paddle_x_speed = -5 --left
	button_press = true
	end
	if btn(1) and right_edge == false then
	paddle_x_speed = 5 --right
	button_press = true
	end
	if not(button_press) then
		paddle_x_speed=paddle_x_speed/2
	end
	paddle_x_pos += paddle_x_speed 
end

-- function ball_paddle_collision(paddle_x_pos, paddle_y_pos, paddle_width, paddle_height)
-- 	-- find top of ball and left edge of paddle	
-- 	if ball_y_pos - ball_radius > paddle_y_pos + paddle_height then		
-- 		return false -- ball has not hit left edge of paddle
-- 	end
-- 	-- find bottom of ball and top edge of paddle
-- 	if ball_y_pos + ball_radius < paddle_y_pos then -- I think this is wrong		
-- 		return false -- ball has not hit top edge of paddle
-- 	end
-- 	-- find left side of ball and right edge of paddle	
-- 	if ball_x_pos - ball_radius > paddle_x_pos + paddle_width then		
-- 		return false -- ball has not hit left edge of paddle
-- 	end
-- 	-- find bottm of ball and top edge of paddle
-- 	if ball_x_pos + ball_radius < paddle_x_pos then -- I think this is wrong		
-- 		return false -- ball has not hit top edge of paddle
-- 	end
-- 	return true
-- end

function paddle_hit_location()
	-- did bottom of ball hit top of paddle?
	if (ball_y_pos + ball_radius == paddle_y_pos-1) and
	   ball_x_pos >= paddle_x_pos and
	   (ball_x_pos <= paddle_x_pos+paddle_width) then		
		ball_y_move = -ball_y_move
		sfx(1)
	end
	-- did top of ball hit bottm of paddle?
	if ball_y_pos-ball_radius == (paddle_y_pos+paddle_height+1) and
	   ball_x_pos >= paddle_x_pos and
	   (ball_x_pos <= paddle_x_pos+paddle_width) then		
		ball_y_move = -ball_y_move	
		sfx(1)
	end
	-- did right side of ball hit left side of paddle?
	if (ball_y_pos >= paddle_y_pos) and 
	   (ball_y_pos <= paddle_y_pos+paddle_height) and
	   ball_x_pos+ball_radius+1 >= paddle_x_pos and
	   ball_x_pos+ball_radius+1 <= paddle_x_pos+paddle_height then		
		ball_x_move = -ball_x_move		
		sfx(1)
	end	
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000240101e0101e01018010120100c0500b3000b3000a3000a300003000130019300063000a3001570014700117000f7000e7001d7001d700237002770032700347003670038700397003b7003c7003d700
0002000015020170201b0201d020200201e0201a02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000