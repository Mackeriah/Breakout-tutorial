pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
box_x = 32
box_y = 58
box_w = 64
box_h = 30

-- relates to the line simulating the ball impact
ball_start_x_pos = 0
ball_start_y_pos = 0
ball_horizontal_movement = 2
ball_vertical_movement = 1
-- top left = 2, 2
-- top right = -2, 2
-- bottom left = 2, -2
-- bottom right = -2, -2

debug1 = "debug"

function _init()
end

function _update()
 -- this moves the line/ball starting point
 if btn(1) then
  ball_start_x_pos+=1
 end
 if btn(0) then
  ball_start_x_pos-=1
 end
 if btn(2) then
  ball_start_y_pos-=1
 end
 if btn(3) then
  ball_start_y_pos+=1
 end 
end

function _draw()
 cls()
 -- draw the box
 rect(box_x, box_y, box_x+box_w, box_y+box_h, 7)
 print('ball_start_x_pos '..ball_start_x_pos, 0, 80, 7)
 print('ball_start_y_pos '..ball_start_y_pos, 0, 90, 7)
 
 -- create local versions of ball position (needed for drawing for some reason)
 local local_ball_start_x_pos, local_ball_start_y_pos = ball_start_x_pos, ball_start_y_pos
 
 repeat
  -- draw coloured line between ball start and end points UNTIL...
  pset(local_ball_start_x_pos, local_ball_start_y_pos, 11)
  -- update local variables with actual position
  local_ball_start_x_pos+=ball_horizontal_movement         
  local_ball_start_y_pos+=ball_vertical_movement
  -- ...either end of line moves off the screen
 until local_ball_start_x_pos<0 or local_ball_start_x_pos>128 or local_ball_start_y_pos < 0 or local_ball_start_y_pos > 128

 if deflx_ballbox(ball_start_x_pos,ball_start_y_pos,ball_horizontal_movement,ball_vertical_movement,box_x,box_y,box_w,box_h) then
  print("horizontal")
 else
  print("vertical")
 end
 print(debug1)
end

function deflx_ballbox(bx,by,bdx,bdy,tx,ty,tw,th)
 -- calculate whether to deflect ball horizontally or vertically

  -- if ball moving perfectly vertically exit function
 if bdx == 0 then 
  return false
 -- if ball moving perfectly horizontally exit function
 elseif bdy == 0 then
  return true
 else -- if it's neither of those cases, it MUST be moving diagonally
  -- calculate slope
  local slp = bdy / bdx
  local cx, cy
  -- check variants
  if slp > 0 and bdx > 0 then
   -- moving down right
   debug1="q1 top left"
   cx = tx-bx
   cy = ty-by
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return true
   else
    return false
   end
  elseif slp < 0 and bdx > 0 then
   debug1="q2 bottom left"
   -- moving up right
   cx = tx-bx
   cy = ty+th-by
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  elseif slp > 0 and bdx < 0 then
   debug1="q3 bottom right"
   -- moving left up
   cx = tx+tw-bx
   cy = ty+th-by
   if cx>=0 then
    return false
   elseif cy/cx > slp then
    return false
   else
    return true
   end
  else
   -- moving left down
   debug1="q4 top right"
   cx = tx+tw-bx
   cy = ty-by
   if cx>=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  end
 end
 return false
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
