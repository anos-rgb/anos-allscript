local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local teleportRadius = 10
local teleportSpeed = 0.1

function Module.start()
    connection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local randomX = math.random(-teleportRadius, teleportRadius)
                local randomZ = math.random(-teleportRadius, teleportRadius)
                local currentPos = rootPart.Position
                
                rootPart.CFrame = CFrame.new(
                    currentPos.X + randomX,
                    currentPos.Y,
                    currentPos.Z + randomZ
                )
            end
        end
        wait(teleportSpeed)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return Module