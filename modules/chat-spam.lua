local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local running = false
local spamMessage = "ANOS SCRIPT HUB | github.com/anos-rgb"
local spamDelay = 2
local lastSent = 0

function Module.start()
    Module.stop()
    
    running = true
    lastSent = 0
    
    connection = RunService.Heartbeat:Connect(function()
        if not running then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end
        
        local currentTime = tick()
        if currentTime - lastSent < spamDelay then
            return
        end
        
        local success = false
        
        pcall(function()
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = TextChatService:FindFirstChild("TextChannels")
                if channel then
                    local generalChannel = channel:FindFirstChild("RBXGeneral")
                    if generalChannel then
                        generalChannel:SendAsync(spamMessage)
                        success = true
                    end
                end
            end
        end)
        
        if not success then
            pcall(function()
                local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chatRemote then
                    local sayMessageRequest = chatRemote:FindFirstChild("SayMessageRequest")
                    if sayMessageRequest and sayMessageRequest:IsA("RemoteEvent") then
                        sayMessageRequest:FireServer(spamMessage, "All")
                        success = true
                    end
                end
            end)
        end
        
        if not success then
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamMessage, "All")
                success = true
            end)
        end
        
        if success then
            lastSent = currentTime
        end
    end)
end

function Module.stop()
    running = false
    lastSent = 0
    
    task.wait(0.1)
    
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
        connection = nil
    end
    
    for i = 1, 5 do
        pcall(function()
            for _, conn in pairs(getconnections(RunService.Heartbeat)) do
                if conn.Function then
                    local info = debug.getinfo(conn.Function)
                    if info and info.source and (info.source:find("chat%-spam") or info.source:find("ANOS")) then
                        conn:Disable()
                    end
                end
            end
        end)
        task.wait(0.05)
    end
end

function Module.setMessage(message)
    if type(message) == "string" and #message > 0 then
        spamMessage = message
    end
end

function Module.setDelay(delay)
    if type(delay) == "number" and delay > 0 then
        spamDelay = delay
    end
end

return Module
