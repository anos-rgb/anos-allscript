local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local blockPart

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    blockPart = Instance.new("Part")
    blockPart.Size = Vector3.new(15, 15, 15)
    blockPart.Transparency = 0.8
    blockPart.Anchored = false
    blockPart.CanCollide = true
    blockPart.BrickColor = BrickColor.new("Really red")
    blockPart.Material = Enum.Material.ForceField
    blockPart.Parent = workspace
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = blockPart
    weld.Part1 = rootPart
    weld.Parent = blockPart
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if blockPart and rootPart then
            blockPart.CFrame = rootPart.CFrame
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if blockPart then
        blockPart:Destroy()
        blockPart = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

return Module