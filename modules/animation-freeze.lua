local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local frozenTracks = {}

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")
    
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        frozenTracks[track] = track.TimePosition
        track:AdjustSpeed(0)
    end
    
    connection = RunService.Heartbeat:Connect(function()
        for track, timePos in pairs(frozenTracks) do
            if track.IsPlaying then
                track.TimePosition = timePos
                track:AdjustSpeed(0)
            end
        end
    end)
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    for track, _ in pairs(frozenTracks) do
        if track.IsPlaying then
            track:AdjustSpeed(1)
        end
    end
    
    frozenTracks = {}
end

return Module