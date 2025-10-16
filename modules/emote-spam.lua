local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

local emotes = {
    "wave",
    "point",
    "dance",
    "dance2",
    "dance3",
    "laugh",
    "cheer"
}

function Module.start()
    connection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                local randomEmote = emotes[math.random(1, #emotes)]
                humanoid:PlayEmote(randomEmote)
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