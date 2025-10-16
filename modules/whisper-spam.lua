local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local targetPlayer = nil
local whisperMessage = "ANOD EXPLOIT ON TOP"

function Module.start()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        warn("No player to whisper to")
        return
    end
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        
        if chatRemote and targetPlayer then
            local sayMessageRequest = chatRemote:FindFirstChild("SayMessageRequest")
            if sayMessageRequest then
                sayMessageRequest:FireServer("/w " .. targetPlayer.Name .. " " .. whisperMessage, "All")
            end
        end
        
        wait(2)
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