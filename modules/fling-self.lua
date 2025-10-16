local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local bodyVelocity
local characterAddedConnection
local cleanupScheduled = false

function Module.start()
    Module.stop()
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(
        math.random(-500, 500),
        math.random(200, 800),
        math.random(-500, 500)
    )
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart
    
    cleanupScheduled = true
    task.delay(0.5, function()
        if cleanupScheduled and bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
            cleanupScheduled = false
        end
    end)
    
    characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        cleanupScheduled = false
    end)
end

function Module.stop()
    cleanupScheduled = false
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
    end
end

return Module
