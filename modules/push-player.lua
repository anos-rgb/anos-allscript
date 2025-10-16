local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local expandedParts = {}

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            expandedParts[part] = part.Size
            part.Size = Vector3.new(8, 8, 8)
            part.Transparency = 0.7
            part.CanCollide = true
        end
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if character and rootPart then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        if distance < 20 then
                            local direction = (targetRoot.Position - rootPart.Position).Unit
                            targetRoot.Velocity = direction * 50
                        end
                    end
                end
            end
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        for part, originalSize in pairs(expandedParts) do
            if part and part.Parent then
                part.Size = originalSize
                part.Transparency = 0
            end
        end
    end
    
    expandedParts = {}
end

return Module