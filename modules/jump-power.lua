local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local jumpValue = 100
local originalJump = 50

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    originalJump = humanoid.JumpPower
    
    connection = RunService.Heartbeat:Connect(function()
        if character and humanoid then
            humanoid.JumpPower = jumpValue
            humanoid.UseJumpPower = true
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        originalJump = humanoid.JumpPower
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
            humanoid.JumpPower = originalJump
        end
    end
end

return Module