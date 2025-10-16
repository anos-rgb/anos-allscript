local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local spamMessage = "ANOS SCRIPT HUB | github.com/anos-rgb"
local spamDelay = 2
local lastSent = 0

function Module.start()
    Module.stop()
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
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
        
        if not success then
            pcall(function()
                game.StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = spamMessage,
                    Color = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.SourceSansBold,
                    FontSize = Enum.FontSize.Size24
                })
            end)
        end
        
        if success then
            lastSent = currentTime
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
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
