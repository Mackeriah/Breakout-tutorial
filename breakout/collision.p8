pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
box_x = 32
box_y = 58
box_w = 64
box_h = 30

-- relates to the line simulating the ball impact
rayx = 0
rayy = 0
raydx = 2
raydy = 2
-- top left = 2, 2
-- top right = -2, 2
-- bottom left = 2, -2
-- bottom right = -2, -2

debug1 = "debug"

function _init()
end

function _update()
 -- this handles the keys moving the line around
 if btn(1) then
  rayx+=1
 end
 if btn(0) then
  rayx-=1
 end
 if btn(2) then
  rayy-=1
 end
 if btn(3) then
  rayy+=1
 end 
end

function _draw()
 cls()
 -- draw the box
 rect(box_x, box_y, box_x+box_w, box_y+box_h, 7)
 --print('rayx '..rayx, 0, 80, 7)
 local px, py = rayx, rayy

 repeat
  pset(px, py, 11)  -- sets the line colour
  px+=raydx         
  py+=raydy
 until px<0 or px>128 or py < 0 or py > 128  -- until off the screen

 if deflx_ballbox(rayx,rayy,raydx,raydy,box_x,box_y,box_w,box_h) then
  print("horizontal")
 else
  print("vertical")
 end
 print(debug1)
end

function deflx_ballbox(bx,by,bdx,bdy,tx,ty,tw,th)
 -- calculate wether to deflect ball horizontally or vertically

  -- if ball moving perfectly vertically we don't use function
 if bdx == 0 then 
  return false
 elseif bdy == 0 then -- and if ball horizontally we don't either  
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
