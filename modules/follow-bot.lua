local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local characterAddedConnection
local targetPlayer = nil
local followDistance = 5
local updateInterval = 0.1
local lastUpdate = 0

local function getClosestPlayer()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

local function getPositionBehindTarget(targetRoot)
    local behindOffset = targetRoot.CFrame.LookVector * -followDistance
    local behindPosition = targetRoot.Position + behindOffset
    return behindPosition
end

function Module.start()
    Module.stop()
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    
    connection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdate < updateInterval then
            return
        end
        lastUpdate = currentTime
        
        if not character or not character.Parent then
            return
        end
        
        targetPlayer = getClosestPlayer()
        
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            
            if targetRoot and rootPart and humanoid then
                local behindPosition = getPositionBehindTarget(targetRoot)
                local distance = (rootPart.Position - behindPosition).Magnitude
                
                if distance > 2 then
                    local direction = (behindPosition - rootPart.Position).Unit
                    local movePosition = rootPart.Position + (direction * humanoid.WalkSpeed * 0.1)
                    
                    local rayOrigin = movePosition + Vector3.new(0, 3, 0)
                    local rayDirection = Vector3.new(0, -10, 0)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    raycastParams.FilterDescendantsInstances = {character}
                    
                    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                    
                    if rayResult then
                        movePosition = Vector3.new(movePosition.X, rayResult.Position.Y + 3, movePosition.Z)
                    else
                        movePosition = Vector3.new(movePosition.X, behindPosition.Y, movePosition.Z)
                    end
                    
                    rootPart.CFrame = CFrame.new(movePosition, Vector3.new(targetRoot.Position.X, movePosition.Y, targetRoot.Position.Z))
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                    rootPart.RotVelocity = Vector3.new(0, 0, 0)
                else
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                    rootPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
    
    characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        rootPart = newChar:WaitForChild("HumanoidRootPart")
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        end
        
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    targetPlayer = nil
end

return Module
