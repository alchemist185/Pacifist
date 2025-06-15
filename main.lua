local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local skipRadius = 100
local targetPosition = Vector3.new(-351.9, 3, -49042)

local function findChair()
local nearestChair = nil
local shortestDistance = math.huge

for _, v in pairs(workspace:GetDescendants()) do  
    if v:IsA("Seat") or v:IsA("VehicleSeat") then  
        local distance = (v.Position - hrp.Position).Magnitude  
        if distance > skipRadius and distance < shortestDistance and not v.Occupant then  
            nearestChair = v  
            shortestDistance = distance  
        end  
    end  
end  

return nearestChair

end

local chair = findChair()

if chair then
character:MoveTo(targetPosition)

task.wait(0.5)  
hrp.CFrame = chair.CFrame + Vector3.new(0, 3, 0)  
task.wait(0.2)  
humanoid.Sit = true

else
end
