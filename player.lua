---@TODO Give a player a body
---@TODO Add an animation for a player's body

-- Variables
local Player = {}

local camera
local gravity
local jump
local maxFallSpeed
local maxJumpSpeed
local velocity

local function Clamp(input, min, max)
  return math.min(math.max(min, input), max)
end

function Player.load()

  -- Disable mouse pointer
  lovr.mouse.setRelativeMode(true)

  -- Configure variables
  camera = {
    transform = lovr.math.newMat4(),
    position = lovr.math.newVec3(),
    movespeed = 7,
    pitch_max = 1.5,
    pitch = 0,
    yaw = 0,
    movement = {
      forward = false,
      backward = false,
      left = false,
      right = false
    },
    crouch = false,
    sprint = false,
    jump = false,
    onGround = true,
    height = 1.7,
  }
  gravity = 5
  jump = 2
  maxFallSpeed = 1.7
  maxJumpSpeed = 1.5
end

function Player.update(dt)

  -- Crouching script
  if camera.crouch then
    camera.height = 1.35
  else
    camera.height = 1.7
  end
  
  -- Sprinting script
  if camera.sprint then
    camera.movespeed = 15
  else
    camera.movespeed = 7
  end

  -- Jumping script
  if camera.jump and camera.onGround and camera.position.y == 0 then
    camera.onGround = false
  end

  if not camera.onGround then
    camera.position.y = math.min(camera.position.y + (gravity * maxJumpSpeed * dt), jump)
    if camera.position.y >= jump then
      camera.onGround = true
    end
  elseif camera.onGround then
    camera.position.y = math.max(camera.position.y - (gravity * maxFallSpeed * dt), 0)
  end

  -- Movement script

  velocity = lovr.math.newVec4()

  if camera.movement.forward then
    velocity.z = -1
  elseif camera.movement.backward then
    velocity.z = 1
  else
    velocity.z = 0
  end
  
  if camera.movement.left then
    velocity.x = -1
  elseif camera.movement.right then
    velocity.x = 1
  else
    velocity.x = 0
  end

  if #velocity > 0 then
    velocity = camera.transform * velocity
    velocity = lovr.math.vec3(velocity.x, 0, velocity.z):normalize()
    velocity = velocity * camera.movespeed * dt
    camera.position:add(velocity.xyz)
  end

  -- Update player's view
  camera.transform:identity()
  camera.transform:translate(0, camera.height, 0)
  camera.transform:translate(camera.position)
  camera.transform:rotate(camera.yaw, 0, 1, 0)
  camera.transform:rotate(camera.pitch, 1, 0, 0)
end

function Player.draw(pass)
    -- Set the player's view
    pass:setViewPose(1, camera.transform)
end

function Player.mousemoved(x, y, dx, dy)
    -- Update x-rotation
    camera.pitch = camera.pitch - dy * .004
    camera.pitch = Clamp(camera.pitch, -camera.pitch_max, camera.pitch_max)
    
    -- Update y-rotation
    camera.yaw = camera.yaw - dx * .004
  end
  
  function Player.keypressed(key, scancode, repeating)
    
    -- Moving foward
    if key == "w" then
      camera.movement.forward = true
    end
    
    -- Moving backward
    if key == "s" then
      camera.movement.backward = true
    end
  
    -- Moving left
    if key == "a" then
      camera.movement.left = true
    end
    
    -- Moving right
    if key == "d" then
      camera.movement.right = true
    end
  
    -- Sprinting
    if key =="lshift" then
      camera.sprint = true
    end
    
    -- Crouching
    if key == "lctrl" then
      camera.crouch = true
    end
    
    -- Jumping
    if key == "space" then
      camera.jump = true
    end
  end
  
  function Player.keyreleased(key, scancode)

    -- Stop moving foward
    if key == "w" then
      camera.movement.forward = false
    end
    
    -- Stop moving backward
    if key == "s" then
      camera.movement.backward = false
    end
  
    -- Stop moving left
    if key == "a" then
      camera.movement.left = false
    end
    
    -- Stop moving right
    if key == "d" then
      camera.movement.right = false
    end
    
    -- Stop sprinting
    if key =="lshift" then
      camera.sprint = false
    end

    -- Stop crouching
    if key == "lctrl" then
      camera.crouch = false
    end
    
    -- Stop jumping
    if key == "space" then
      camera.jump = false
    end
  end

return Player