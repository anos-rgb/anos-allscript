local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local spamMessage = "ANOS SCRIPT HUB | github.com/anos-rgb"
local spamDelay = 2

function Module.start()
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        
        if chatRemote then
            local sayMessageRequest = chatRemote:FindFirstChild("SayMessageRequest")
            if sayMessageRequest then
                sayMessageRequest:FireServer(spamMessage, "All")
            end
        end
        
        wait(spamDelay)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

function Module.setMessage(message)
    spamMessage = message
end

function Module.setDelay(delay)
    spamDelay = delay
end

return Module