local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local targetPlayer = nil
local followDistance = 5

function Module.start()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        warn("No player to follow")
        return
    end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    connection = RunService.Heartbeat:Connect(function()
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetRoot and rootPart then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                
                if distance > followDistance then
                    local path = PathfindingService:CreatePath({
                        AgentRadius = 2,
                        AgentHeight = 5,
                        AgentCanJump = true,
                        AgentJumpHeight = 50,
                        AgentMaxSlope = 45
                    })
                    
                    local success, errorMsg = pcall(function()
                        path:ComputeAsync(rootPart.Position, targetRoot.Position)
                    end)
                    
                    if success and path.Status == Enum.PathStatus.Success then
                        local waypoints = path:GetWaypoints()
                        
                        for _, waypoint in pairs(waypoints) do
                            if waypoint.Action == Enum.PathWaypointAction.Jump then
                                humanoid.Jump = true
                            end
                            
                            humanoid:MoveTo(waypoint.Position)
                            humanoid.MoveToFinished:Wait(0.5)
                            
                            if not targetPlayer or not targetPlayer.Character then
                                break
                            end
                        end
                    else
                        humanoid:MoveTo(targetRoot.Position)
                    end
                else
                    humanoid:MoveTo(rootPart.Position)
                end
            end
        end
        wait(0.1)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                humanoid:MoveTo(rootPart.Position)
            end
        end
    end
    
    targetPlayer = nil
end

return Module