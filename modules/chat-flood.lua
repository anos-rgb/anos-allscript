local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

local messages = {
    "halo",
    "wkwk"
}

function Module.start()
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        
        if chatRemote then
            local sayMessageRequest = chatRemote:FindFirstChild("SayMessageRequest")
            if sayMessageRequest then
                local randomMsg = messages[math.random(1, #messages)]
                sayMessageRequest:FireServer(randomMsg, "All")
            end
        end
        
        wait(1)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return Module