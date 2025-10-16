local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local airPlatform

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    airPlatform = Instance.new("Part")
    airPlatform.Size = Vector3.new(10, 1, 10)
    airPlatform.Transparency = 1
    airPlatform.Anchored = true
    airPlatform.CanCollide = true
    airPlatform.Parent = workspace
    
    connection = RunService.Heartbeat:Connect(function()
        if character and rootPart and airPlatform then
            airPlatform.CFrame = rootPart.CFrame * CFrame.new(0, -3.5, 0)
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if airPlatform then
        airPlatform:Destroy()
        airPlatform = nil
    end
end

return Module