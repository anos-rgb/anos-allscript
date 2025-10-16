local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("Motor6D") then
            part.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
            part.C1 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
        end
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChild("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
    end
end

function Module.stop()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("Motor6D") then
                part.C0 = part.C0
                part.C1 = part.C1
            end
        end
    end
    
    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

return Module