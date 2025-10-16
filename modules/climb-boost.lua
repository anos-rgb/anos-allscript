local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local characterAddedConnection
local climbSpeed = 200
local originalClimbSpeed = 10

function Module.start()
    Module.stop()
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    originalClimbSpeed = humanoid.ClimbSpeed or 10
    
    connection = RunService.Heartbeat:Connect(function()
        if character and character.Parent and humanoid and humanoid.Parent then
            humanoid.ClimbSpeed = climbSpeed
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
    
    characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        
        originalClimbSpeed = humanoid.ClimbSpeed or 10
        
        if connection then
            connection:Disconnect()
        end
        
        connection = RunService.Heartbeat:Connect(function()
            if character and character.Parent and humanoid and humanoid.Parent then
                humanoid.ClimbSpeed = climbSpeed
            end
        end)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
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
