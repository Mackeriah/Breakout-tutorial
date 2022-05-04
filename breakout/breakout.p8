pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- super breakout
-- owen fitzgerald

sausages = false

function _init() -- runs once at start
	cls(0)
	-- ball info
	ball_x_pos = 59
	ball_y_pos = 60
	ball_radius = 0
	ball_x_speed = 0
	ball_y_speed = 1
	
	-- paddle info
	paddle_x_pos = 60
	paddle_y_pos = 60
	paddle_width = 24
	paddle_height = 60
	paddle_speed = 0
end

function _update() -- runs every frame	
	screen_paddle_limit()
	ball_paddle_collision()
	ball_movement()
	paddle_movement()
	screen_bounce()
end

function _draw() -- runs every frame (after update)
	cls(0)
	rectfill(0,0,127,127,1) -- the game area
	circfill(ball_x_pos, ball_y_pos, ball_radius, 8) -- draw the ball
	draw_paddle()	

	print('ball_x_pos '..ball_x_pos)
	print('ball_y_pos '..ball_y_pos)
	print('ball radius '..ball_radius)
	print('ball_x + rad '..ball_x_pos+ball_radius)

	print('pad x pos (top l) '..paddle_x_pos)
	print('pad y pos (top l) '..paddle_y_pos)
	print('pad x pos (bot r) '..paddle_x_pos+paddle_height)
	print('pad y pos (bot r) '..paddle_y_pos+paddle_height)		
	print('pad xpos '..paddle_x_pos)
	print('pad xpos + pad height)'..paddle_x_pos+paddle_height)	
	print('pad xpos + pad width)'..paddle_x_pos+paddle_width)	
	print(sausages)
	
	--if (ball_y_pos >= paddle_y_pos) and (ball_y_pos <= paddle_y_pos + paddle_height) then
	if ball_x_pos == 59 then
		sausages = true		
	end	
	
end

function draw_paddle()
	rectfill(paddle_x_pos, paddle_y_pos, paddle_x_pos+paddle_width, paddle_y_pos+paddle_height, 7)
end

function ball_movement()
	ball_x_pos += ball_x_speed
	ball_y_pos += ball_y_speed
end

-- tested this works 100% unless speed > 10
function screen_bounce()
	if ball_x_pos + ball_radius >= 127 or ball_x_pos - ball_radius <= 0 then
		ball_x_speed = -ball_x_speed		
		sfx(0)
	end	
	if ball_y_pos + ball_radius >= 127 or ball_y_pos - ball_radius <= 0 then
		ball_y_speed = -ball_y_speed
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
	paddle_speed = -5 --left
	button_press = true
	end
	if btn(1) and right_edge == false then
	paddle_speed = 5 --right
	button_press = true
	end
	if not(button_press) then
		paddle_speed = flr(paddle_speed/2)
		if paddle_speed < 0 then
			paddle_speed = 0
		end
	end
	paddle_x_pos += paddle_speed
end

function ball_paddle_collision()
	-- THIS PART IS WORKING CORRECTLY
	-- did bottom of ball hit top of paddle? (-1 as that's the contact point)
	if (ball_y_pos + ball_radius == paddle_y_pos-1) and	   
	   ball_x_pos >= paddle_x_pos and -- check ball is at or beyond paddle left side
	   (ball_x_pos <= paddle_x_pos+paddle_width) then -- and right side
		ball_y_speed = -ball_y_speed -- therefore vertical bounce
		sfx(1)
	end

	-- THIS PART APPEARWS TO BE WORKING CORRECTLY!
	-- did left side of ball hit right side of paddle?	
	if (ball_y_pos >= paddle_y_pos) and (ball_y_pos <= paddle_y_pos+paddle_height) and -- ball in line with paddle
	   ball_x_pos + ball_radius - 1 <= paddle_x_pos + paddle_width and -- when ball hits paddle right side
	   ball_x_pos + ball_radius >= paddle_x_pos and
	   ball_x_pos + ball_radius <= paddle_x_pos + paddle_width then
		ball_x_speed = -ball_x_speed		
		sfx(2)
	end	

	-- if I check current x and y pos against next x and y I think I can determine which way ball is moving
	-- if current_x == next_x and current_y > next_y then ball is going DOWN
	-- if current_x == next_x and current_y < next_y then ball is going UP
	-- if current_y == next_y and current_x > next_x then ball is going RIGHT
	-- if current_y == next_y and current_x < next_x then ball is going LEFT

	-- if current_x > next_x and current_y > next_y then ball is going diaganolly down right

	-- did right side of ball hit left side of paddle? -- THIS PART IS WORKING CORRECTLY
	-- if ball is between top and bottom of paddle
	-- hmm I need to consider ball radius too, although IF I won't be changing ball radius I 
	-- can handle this with magic numbers as I'll know the radius
	-- need to consider if ball partially hits paddle, whereas the below is just from centre
	if (ball_y_pos >= paddle_y_pos) and (ball_y_pos <= paddle_y_pos+paddle_height) and
		-- if ball 
	   ball_y_pos + ball_radius +1 >= paddle_y_pos and
	   -- if ball including it's radius is equal or less than paddle x plus paddle height 
	   ball_y_pos + ball_radius +1 <= paddle_y_pos + paddle_height then		
		ball_x_speed = -ball_x_speed		
		sfx(2)
	end
	
	-- THIS PART IS NOT CHECKED YET
	-- did top of ball hit bottm of paddle?
	-- if ball_y_pos-ball_radius == (paddle_y_pos+paddle_height+1) and
	--    ball_x_pos >= paddle_x_pos and
	--    (ball_x_pos <= paddle_x_pos+paddle_width) then		
	-- 	ball_y_speed = -ball_y_speed	
	-- 	sfx(1)
	-- end
	
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
001000001d02000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
