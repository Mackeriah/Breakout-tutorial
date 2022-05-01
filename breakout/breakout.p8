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
	paddle_x_pos = 52
	paddle_y_pos = 120
	paddle_x_speed = 0
	paddle_width = 24
	paddle_height = 3
	paddle_collision = 7	
end

function _update() -- runs every frame	
	-- variables used later
	local next_ball_x_pos, next_ball_y_pos

	-- paddle movement when player presses keys
	local button_press = false
	if btn(0) then
	paddle_x_speed = -5 --left
	button_press = true
	end
	if btn(1) then
	paddle_x_speed = 5 --right
	button_press = true
	end
	if not(button_press) then
		paddle_x_speed = paddle_x_speed /  1.7
	end
	paddle_x_pos += paddle_x_speed 
	
	-- store ball position for next frame
	next_ball_x_pos = ball_x_pos + ball_x_move
	next_ball_y_pos = ball_y_pos + ball_y_move
	
	-- screen bounce
	-- check if ball would be out of screen boundary
	if next_ball_x_pos >= 127 or next_ball_x_pos < 0 then
		-- mid function always returns the middle of the values		
		next_ball_x_pos = mid(0, next_ball_x_pos, 127)
		ball_x_move = -ball_x_move
		sfx(0)
	end	
	if next_ball_y_pos >= 127 or next_ball_y_pos <= 0 then
		next_ball_y_pos = mid(0, next_ball_y_pos, 127)
		ball_y_move = -ball_y_move
		sfx(0)
	end		

	paddle_collision = 7 -- set paddle back to default colour
	--change paddle colour on collision
	if ball_paddle_collision(next_ball_x_pos, next_ball_y_pos, paddle_x_pos, paddle_y_pos, paddle_width, paddle_height) then
		if deflx_ballbox(ball_start_x_pos,ball_start_y_pos,ball_horizontal_movement,ball_vertical_movement,box_x,box_y,box_w,box_h) then
			-- if this function returns true, we need to deflect ball horizontally
			ball_x_move = -ball_x_move	
		else
			ball_y_move = -ball_y_move	
		end
		paddle_collision = 8
		sfx(1)		
	end

	-- actually move the ball position
	ball_x_pos = next_ball_x_pos
	ball_y_pos = next_ball_y_pos

end

function _draw() -- runs every frame (after update)
	cls(0) -- not in Kristen's code for some reason! WEIRD
	-- the game area
	rectfill(0,0,127,127,1) 
	-- draw the ball
	circfill(ball_x_pos, ball_y_pos, ball_radius, 10)
	-- draw paddle
	rectfill(paddle_x_pos, paddle_y_pos, paddle_x_pos+paddle_width, paddle_y_pos+paddle_height, paddle_collision)	
end

function ball_paddle_collision(next_ball_x_pos, next_ball_y_pos, paddle_x_pos, paddle_y_pos, paddle_width, paddle_height)
	-- find top of ball and left edge of paddle	
	if next_ball_y_pos - ball_radius > paddle_y_pos + paddle_height then		
		return false -- ball has not hit left edge of paddle
	end
	-- find bottom of ball and top edge of paddle
	if next_ball_y_pos + ball_radius < paddle_y_pos then -- I think this is wrong		
		return false -- ball has not hit top edge of paddle
	end
	-- find left side of ball and right edge of paddle	
	if next_ball_x_pos - ball_radius > paddle_x_pos + paddle_width then		
		return false -- ball has not hit left edge of paddle
	end
	-- find bottm of ball and top edge of paddle
	if next_ball_x_pos + ball_radius < paddle_x_pos then -- I think this is wrong		
		return false -- ball has not hit top edge of paddle
	end
	return true
end

function deflx_ballbox(ball_start_x_pos,ball_start_y_pos,ball_horizontal_movement,ball_vertical_movement,box_x,box_y,box_w,box_h)
 -- calculate whether to deflect ball horizontally or vertically

  -- if ball moving perfectly vertically exit function
 if ball_horizontal_movement == 0 then 
  return false
 -- if ball moving perfectly horizontally exit function
 elseif ball_vertical_movement == 0 then
  return true
 else -- if it's neither of those cases, it MUST be moving diagonally
  -- calculate slope
  local slope = ball_vertical_movement / ball_horizontal_movement
  print('slope '..slope, 0, 40, 7)
  local cx, cy

  -- determine which direction ball is moving
  if slope > 0 and ball_horizontal_movement > 0 then
   -- moving down right
   debug1="q1 top left"
   cx = box_x - ball_start_x_pos
   cy = box_y - ball_start_y_pos
   print('cx '..cx, 0, 50, 7)
   print('cy '..cy, 0, 60, 7)

   if cx <= 0 then
    return false
   elseif cy / cx < slope then
    return true
   else
    return false
   end
  elseif slope < 0 and ball_horizontal_movement > 0 then
   debug1="q2 bottom left"   
   -- moving up right
   cx = box_x - ball_start_x_pos
   cy = box_y + box_h - ball_start_y_pos
   if cx <= 0 then
    return false
   elseif cy / cx < slope then
    return false
   else
    return true
   end
  elseif slope > 0 and ball_horizontal_movement < 0 then
   debug1="q3 bottom right"
   -- moving left up
   cx = box_x + box_w - ball_start_x_pos
   cy = box_y + box_h - ball_start_y_pos
   if cx >= 0 then
    return false
   elseif cy / cx > slope then
    return false
   else
    return true
   end
  else
   -- moving left down
   debug1="q4 top right"
   cx = box_x + box_w - ball_start_x_pos
   cy = box_y - ball_start_y_pos
   if cx >= 0 then
    return false
   elseif cy / cx < slope then
    return false
   else
    return true
   end
  end
 end
 return false
end

-- moved into update to match Kristen's
-- function ball_movement()
-- 	ball_x_pos += ball_x_move
-- 	ball_y_pos += ball_y_move
-- end

-- function ball_pulse()
-- 	ball_radius = ball_radius+pulse_speed
-- 	if ball_radius > 3 or ball_radius < 2 then
-- 		pulse_speed = -pulse_speed
-- 	end	
-- end

-- commented out so same as Kristen's
-- function screen_bounce()
-- 	if ball_x_pos+ball_radius >= 127 or ball_x_pos-ball_radius < 0 then
-- 		ball_x_move = -ball_x_move
-- 		sfx(0)
-- 	end	
-- 	if ball_y_pos+ball_radius >= 127 or ball_y_pos-ball_radius <= 0 then
-- 		ball_y_move = -ball_y_move
-- 		sfx(0)
-- 	end	
-- end

-- commented out as I added this
-- function screen_paddle_limit()
-- 	if paddle_x_pos+paddle_width > 127 then
-- 	 right_edge = true
-- 		paddle_x_pos = 128-paddle_width
-- 	else
-- 		right_edge = false
-- 	end
-- 	if paddle_x_pos < 1 then
-- 	 left_edge = true
-- 		paddle_x_pos = 0
-- 	else
-- 		left_edge = false	
-- 	end
-- end

-- moved into update to match Kristen's
-- function paddle_movement()
-- 	local button_press = false
-- 	if btn(0) and left_edge == false then
-- 	paddle_x_speed = -5 --left
-- 	button_press = true
-- 	end
-- 	if btn(1) and right_edge == false then
-- 	paddle_x_speed = 5 --right
-- 	button_press = true
-- 	end
-- 	if not(button_press) then
-- 		paddle_x_speed=paddle_x_speed/2
-- 	end
-- 	paddle_x_pos += paddle_x_speed 
-- end




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