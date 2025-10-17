local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local characterAddedConnection
local blockPart
local bodyVelocity
local bodyGyro
local running = false

function Module.start()
    Module.stop()
    
    running = true
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    
    if blockPart then
        blockPart:Destroy()
    end
    
    blockPart = Instance.new("Part")
    blockPart.Name = "BodyBlockPart"
    blockPart.Size = Vector3.new(15, 15, 15)
    blockPart.Transparency = 0.7
    blockPart.Anchored = false
    blockPart.CanCollide = true
    blockPart.Massless = true
    blockPart.BrickColor = BrickColor.new("Really red")
    blockPart.Material = Enum.Material.ForceField
    blockPart.CFrame = rootPart.CFrame
    blockPart.Parent = workspace
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.Parent = rootPart
    
    local weld = Instance.new("WeldConstraint")
    weld.Name = "BodyBlockWeld"
    weld.Part0 = blockPart
    weld.Part1 = rootPart
    weld.Parent = blockPart
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if not running then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end
        
        if character and character.Parent and rootPart and rootPart.Parent then
            if blockPart and blockPart.Parent then
                blockPart.CFrame = rootPart.CFrame
                blockPart.Velocity = Vector3.new(0, 0, 0)
                blockPart.RotVelocity = Vector3.new(0, 0, 0)
            end
            
            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
            
            if bodyVelocity then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            
            if bodyGyro then
                bodyGyro.CFrame = rootPart.CFrame
            end
        else
            if blockPart then
                blockPart:Destroy()
                blockPart = nil
            end
        end
    end)
    
    characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if not running then
            return
        end
        
        task.wait(0.5)
        
        character = newChar
        rootPart = newChar:WaitForChild("HumanoidRootPart")
        humanoid = newChar:WaitForChild("Humanoid")
        
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        
        if blockPart then
            blockPart:Destroy()
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        
        if bodyGyro then
            bodyGyro:Destroy()
        end
        
        blockPart = Instance.new("Part")
        blockPart.Name = "BodyBlockPart"
        blockPart.Size = Vector3.new(15, 15, 15)
        blockPart.Transparency = 0.7
        blockPart.Anchored = false
        blockPart.CanCollide = true
        blockPart.Massless = true
        blockPart.BrickColor = BrickColor.new("Really red")
        blockPart.Material = Enum.Material.ForceField
        blockPart.CFrame = rootPart.CFrame
        blockPart.Parent = workspace
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.P = 10000
        bodyVelocity.Parent = rootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.P = 10000
        bodyGyro.D = 500
        bodyGyro.Parent = rootPart
        
        local weld = Instance.new("WeldConstraint")
        weld.Name = "BodyBlockWeld"
        weld.Part0 = blockPart
        weld.Part1 = rootPart
        weld.Parent = blockPart
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
            end
        end
    end)
end

function Module.stop()
    running = false
    
    task.wait(0.1)
    
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
        connection = nil
    end
    
    if characterAddedConnection then
        pcall(function()
            characterAddedConnection:Disconnect()
        end)
        characterAddedConnection = nil
    end
    
    if bodyVelocity then
        pcall(function()
            bodyVelocity:Destroy()
        end)
        bodyVelocity = nil
    end
    
    if bodyGyro then
        pcall(function()
            bodyGyro:Destroy()
        end)
        bodyGyro = nil
    end
    
    if blockPart then
        pcall(function()
            blockPart:Destroy()
        end)
        blockPart = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end
        
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
                part.Massless = false
            end
        end
    end
    
    for i = 1, 3 do
        pcall(function()
            local oldBlock = workspace:FindFirstChild("BodyBlockPart")
            if oldBlock then
                oldBlock:Destroy()
            end
        end)
        task.wait(0.05)
    end
end

function Module.setSize(size)
    if type(size) == "number" and size > 0 then
        if blockPart then
            blockPart.Size = Vector3.new(size, size, size)
        end
    end
end

function Module.setTransparency(transparency)
    if type(transparency) == "number" and transparency >= 0 and transparency <= 1 then
        if blockPart then
            blockPart.Transparency = transparency
        end
    end
end

function Module.setColor(color)
    if typeof(color) == "Color3" then
        if blockPart then
            blockPart.BrickColor = BrickColor.new(color)
        end
    elseif type(color) == "string" then
        if blockPart then
            blockPart.BrickColor = BrickColor.new(color)
        end
    end
end

return Module
