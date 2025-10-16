local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

function Module.start()
    connection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo")
                local maxAmmo = tool:FindFirstChild("MaxAmmo")
                
                if ammo and maxAmmo then
                    ammo.Value = maxAmmo.Value
                end
                
                for _, obj in pairs(tool:GetDescendants()) do
                    if obj.Name:lower():find("ammo") or obj.Name:lower():find("magazine") then
                        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                            local max = tool:FindFirstChild("Max" .. obj.Name)
                            if max then
                                obj.Value = max.Value
                            else
                                obj.Value = 999
                            end
                        end
                    end
                end
            end
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return Module