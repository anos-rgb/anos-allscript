local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local targetPlayer = nil
local offset = Vector3.new(0, 5, 0)

function Module.start()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        warn("No player to attach to")
        return
    end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    connection = RunService.Heartbeat:Connect(function()
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot and rootPart then
                rootPart.CFrame = targetRoot.CFrame * CFrame.new(offset)
                rootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    targetPlayer = nil
end

return Module