local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local climbSpeed = 200
local originalClimbSpeed = 10

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    originalClimbSpeed = humanoid.ClimbSpeed or 10
    
    connection = RunService.Heartbeat:Connect(function()
        if character and humanoid then
            humanoid.ClimbSpeed = climbSpeed
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.ClimbSpeed = originalClimbSpeed
        end
    end
end

return Module