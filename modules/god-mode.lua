local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local originalMaxHealth

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    originalMaxHealth = humanoid.MaxHealth
    
    connection = RunService.Heartbeat:Connect(function()
        if character and humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    
    for _, conn in pairs(getconnections(humanoid.HealthChanged)) do
        conn:Disable()
    end
    
    for _, conn in pairs(getconnections(humanoid.Died)) do
        conn:Disable()
    end
    
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        originalMaxHealth = humanoid.MaxHealth
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
            humanoid.MaxHealth = originalMaxHealth
        end
    end
end

return Module