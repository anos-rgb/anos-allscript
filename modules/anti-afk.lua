local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection

function Module.start()
    connection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        if conn.Function then
            conn:Disable()
        end
    end
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return Module