local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

function Module.start()
    connection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Sit = not humanoid.Sit
            end
        end
        wait(0.9)
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
            humanoid.Sit = false
        end
    end
end

return Module
