local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local destination = Vector3.new(-351.9, 3, -49042)
local TELEPORT_SPEED = 1000
local STOP_DISTANCE = 78
local MIN_CHAIR_DISTANCE = 1000

local function getFarChair()
    local bestChair, bestDist = nil, 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Seat") or obj:IsA("VehicleSeat")) and not obj.Occupant then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist > MIN_CHAIR_DISTANCE and dist > bestDist then
                bestChair = obj
                bestDist = dist
            end
        end
    end
    return bestChair
end

local chair = getFarChair()
if not chair then
    warn("No chair found far enough.")
    return
end

chair.Anchored = false
chair.CFrame = hrp.CFrame * CFrame.new(0, -2, 0)
local weld = Instance.new("WeldConstraint", chair)
weld.Part0 = chair
weld.Part1 = hrp

task.wait(0.2)
humanoid.Sit = true

local runService = game:GetService("RunService")
local moving = true

local function teleportLoop()
    local conn
    conn = runService.Heartbeat:Connect(function(deltaTime)
        if not moving then conn:Disconnect() return end

        local currentPos = hrp.Position
        local dist = (destination - currentPos).Magnitude

        if dist <= STOP_DISTANCE then
            moving = false
            weld:Destroy()
            humanoid.Sit = false
            char:MoveTo(destination)
            return
        end

        local direction = (destination - currentPos).Unit
        local step = direction * TELEPORT_SPEED * deltaTime
        hrp.CFrame = CFrame.new(currentPos + step)
    end)
end

teleportLoop()
