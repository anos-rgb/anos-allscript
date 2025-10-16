local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local bodyAngularVelocity
local spinSpeed = 100

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, spinSpeed, 0)
    bodyAngularVelocity.MaxTorque = Vector3.new(0, 9e9, 0)
    bodyAngularVelocity.P = 9000
    bodyAngularVelocity.Parent = rootPart
    
    connection = RunService.Heartbeat:Connect(function()
        if bodyAngularVelocity then
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, spinSpeed, 0)
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
end

return Module