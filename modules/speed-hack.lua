local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local speedValue = 50
local originalSpeed = 16

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    originalSpeed = humanoid.WalkSpeed
    
    connection = RunService.Heartbeat:Connect(function()
        if character and humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        originalSpeed = humanoid.WalkSpeed
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
            humanoid.WalkSpeed = originalSpeed
        end
    end
end

function Module.setSpeed(speed)
    speedValue = speed
end

return Module