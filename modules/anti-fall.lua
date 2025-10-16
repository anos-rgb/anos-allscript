local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

function Module.start()
    connection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local stateChangedConn = humanoid.StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.FallingDown or 
                       new == Enum.HumanoidStateType.Ragdoll then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end)
                
                Module.stateConn = stateChangedConn
            end
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if Module.stateConn then
        Module.stateConn:Disconnect()
        Module.stateConn = nil
    end
end

return Module