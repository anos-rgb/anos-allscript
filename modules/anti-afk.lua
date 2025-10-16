local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Module = {}

local connection
local disabledConnections = {}

function Module.start()
    Module.stop()
    
    connection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    local success, err = pcall(function()
        for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
            if conn.Function and conn ~= connection then
                conn:Disable()
                table.insert(disabledConnections, conn)
            end
        end
    end)
    
    if not success then
        warn("Failed to disable idle connections:", err)
    end
end

function Module.stop()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    local success, err = pcall(function()
        for _, conn in pairs(disabledConnections) do
            if conn and conn.Enable then
                conn:Enable()
            end
        end
    end)
    
    if not success then
        warn("Failed to re-enable idle connections:", err)
    end
    
    disabledConnections = {}
end

return Module
