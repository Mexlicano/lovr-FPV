-- Import Lua module(s)
_G.lovr = require("lovr")
lovr.mouse = require("libraries.lovr-mouse")
lovr.player = require("player")

local grass

function lovr.load()

  -- PBR Material from ambientCG (https://ambientcg.com)
  grass = lovr.graphics.newMaterial({
    texture = lovr.graphics.newTexture('texture/floor/Grass_Color.jpg'),
    normalTexture = lovr.graphics.newTexture('texture/floor/Grass_NormalGL.jpg'),
    roughnessTexture = lovr.graphics.newTexture('texture/floor/Grass_Roughness.jpg'),
    occlusionTexture = lovr.graphics.newTexture('texture/floor/Grass_AmbientOcclusion.jpg'),
  })
  
  -- Load player's config
  lovr.player.load()
end

function lovr.update(dt)
  -- Update the player's movement
  lovr.player.update(dt)
end

function lovr.draw(pass)
  pass:push()
  lovr.graphics.setBackgroundColor(0, 255, 255, a)
  lovr.player.draw(pass)
  pass:setColor(0xff0000)
  pass:cube(0, 1.7, -3, .5, lovr.timer.getTime())
  pass:setColor(1, 1, 1, 1)
  pass:setMaterial(grass)
  pass:plane(0, 0, 0, 50, 50, math.pi / 2, 1, 0, 0)
  pass:pop()
end

function lovr.mousemoved(x, y, dx, dy)
  -- player's mouse
  lovr.player.mousemoved(x, y, dx, dy)
end

function lovr.keypressed(key, scancode, repeating)

  -- player's keyboard
  lovr.player.keypressed(key, scancode, repeating)

  if key == 'escape' then
    lovr.event.quit()
  end
end

function lovr.keyreleased(key, scancode)
  -- player's keyboard
  lovr.player.keyreleased(key, scancode)
end