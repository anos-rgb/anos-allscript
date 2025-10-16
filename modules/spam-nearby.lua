local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

local emotes = {"wave", "point", "dance", "dance2", "dance3", "laugh", "cheer"}

function Module.start()
    connection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if rootPart and humanoid then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local distance = (rootPart.Position - targetRoot.Position).Magnitude
                            if distance < 15 then
                                local randomEmote = emotes[math.random(1, #emotes)]
                                humanoid:PlayEmote(randomEmote)
                                
                                rootPart.CFrame = CFrame.new(
                                    targetRoot.Position + Vector3.new(
                                        math.random(-5, 5),
                                        0,
                                        math.random(-5, 5)
                                    )
                                )
                            end
                        end
                    end
                end
            end
        end
        wait(0.5)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return Module