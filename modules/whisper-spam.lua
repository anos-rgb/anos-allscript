local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local playerLeftConnection
local running = false
local targetPlayer = nil
local whisperMessage = "ANOS EXPLOIT ON TOP"
local whisperDelay = 2
local lastSent = 0

local function getRandomPlayer()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player)
        end
    end
    
    if #players > 0 then
        return players[math.random(1, #players)]
    end
    return nil
end

function Module.start()
    Module.stop()
    
    targetPlayer = getRandomPlayer()
    
    if not targetPlayer then
        warn("No player to whisper to")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Whisper Spam";
            Text = "No players available!";
            Duration = 3;
        })
        return
    end
    
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
        if currentTime - lastSent < whisperDelay then
            return
        end
        
        if not targetPlayer or not targetPlayer.Parent then
            targetPlayer = getRandomPlayer()
            if not targetPlayer then
                return
            end
        end
        
        local success = false
        
        pcall(function()
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local channel = TextChatService:FindFirstChild("TextChannels")
                if channel then
                    local generalChannel = channel:FindFirstChild("RBXGeneral")
                    if generalChannel then
                        generalChannel:SendAsync("/whisper " .. targetPlayer.Name .. " " .. whisperMessage)
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
                        sayMessageRequest:FireServer("/w " .. targetPlayer.Name .. " " .. whisperMessage, "All")
                        success = true
                    end
                end
            end)
        end
        
        if not success then
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w " .. targetPlayer.Name .. " " .. whisperMessage, "All")
                success = true
            end)
        end
        
        if success then
            lastSent = currentTime
        end
    end)
    
    playerLeftConnection = Players.PlayerRemoving:Connect(function(player)
        if player == targetPlayer then
            targetPlayer = getRandomPlayer()
        end
    end)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Whisper Spam";
        Text = "Whispering to: " .. targetPlayer.Name;
        Duration = 3;
    })
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
    
    if playerLeftConnection then
        pcall(function()
            playerLeftConnection:Disconnect()
        end)
        playerLeftConnection = nil
    end
    
    for i = 1, 5 do
        pcall(function()
            for _, conn in pairs(getconnections(RunService.Heartbeat)) do
                if conn.Function then
                    local info = debug.getinfo(conn.Function)
                    if info and info.source and (info.source:find("whisper%-spam") or info.source:find("whisper")) then
                        conn:Disable()
                    end
                end
            end
        end)
        task.wait(0.05)
    end
    
    targetPlayer = nil
end

function Module.setMessage(message)
    if type(message) == "string" and #message > 0 then
        whisperMessage = message
    end
end

function Module.setDelay(delay)
    if type(delay) == "number" and delay > 0 then
        whisperDelay = delay
    end
end

function Module.setTarget(playerName)
    if type(playerName) == "string" then
        local player = Players:FindFirstChild(playerName)
        if player and player ~= LocalPlayer then
            targetPlayer = player
            return true
        end
    end
    return false
end

function Module.randomTarget()
    targetPlayer = getRandomPlayer()
    if targetPlayer then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Whisper Spam";
            Text = "New target: " .. targetPlayer.Name;
            Duration = 3;
        })
        return true
    end
    return false
end

return Module
