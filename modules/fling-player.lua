local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local bodyAngularVelocity
local spinPower = 5000

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, spinPower, 0)
    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyAngularVelocity.P = math.huge
    bodyAngularVelocity.Parent = rootPart
    
    connection = RunService.Heartbeat:Connect(function()
        if bodyAngularVelocity and rootPart then
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, spinPower, 0)
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local distance = (rootPart.Position - targetRoot.Position).Magnitude
                        if distance < 15 then
                            rootPart.CFrame = CFrame.new(targetRoot.Position)
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
    
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
                part.Massless = false
            end
        end
    end
end

return Module


