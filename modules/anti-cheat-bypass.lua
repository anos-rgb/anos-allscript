local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connections = {}
local oldNamecall
local oldIndex
local oldNewIndex
local disabledConnections = {}

function Module.start()
    Module.stop()
    
    local success1 = pcall(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                if remote.Name:lower():find("anticheat") or 
                   remote.Name:lower():find("kick") or
                   remote.Name:lower():find("ban") or
                   remote.Name:lower():find("detect") or
                   remote.Name:lower():find("log") then
                    remote:Destroy()
                end
            end
        end
    end)
    
    connections.childAdded = ReplicatedStorage.DescendantAdded:Connect(function(obj)
        pcall(function()
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                if obj.Name:lower():find("anticheat") or 
                   obj.Name:lower():find("kick") or
                   obj.Name:lower():find("ban") or
                   obj.Name:lower():find("detect") then
                    task.wait(0.1)
                    obj:Destroy()
                end
            end
        end)
    end)
    
    local success2 = pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" or method == "InvokeServer" then
                if self.Name:lower():find("anticheat") or 
                   self.Name:lower():find("kick") or
                   self.Name:lower():find("ban") or
                   self.Name:lower():find("detect") or
                   self.Name:lower():find("log") then
                    return
                end
                
                for i, arg in pairs(args) do
                    if type(arg) == "string" then
                        if arg:lower():find("speed") or 
                           arg:lower():find("exploit") or
                           arg:lower():find("cheat") or
                           arg:lower():find("hack") then
                            return
                        end
                    end
                end
            end
            
            if method == "Kick" then
                return
            end
            
            return oldNamecall(self, ...)
        end)
    end)
    
    local success3 = pcall(function()
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if key == "WalkSpeed" or key == "JumpPower" or key == "JumpHeight" then
                if self:IsA("Humanoid") and self.Parent == LocalPlayer.Character then
                    return 16
                end
            end
            
            return oldIndex(self, key)
        end)
    end)
    
    local success4 = pcall(function()
        oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
            if key == "WalkSpeed" or key == "JumpPower" or key == "JumpHeight" then
                if self:IsA("Humanoid") and self.Parent == LocalPlayer.Character then
                    return
                end
            end
            
            return oldNewIndex(self, key, value)
        end)
    end)
    
    connections.heartbeat = RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
                if script:IsA("LocalScript") or script:IsA("ModuleScript") then
                    if script.Name:lower():find("anticheat") or 
                       script.Name:lower():find("anticlient") or
                       script.Name:lower():find("antiexploit") then
                        script.Disabled = true
                        task.wait(0.1)
                        script:Destroy()
                    end
                end
            end
        end)
    end)
    
    pcall(function()
        for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
            if conn.Disable then
                conn:Disable()
                table.insert(disabledConnections, conn)
            end
        end
    end)
    
    pcall(function()
        for _, conn in pairs(getconnections(LocalPlayer.CharacterAdded)) do
            if conn.Function and conn.Disable then
                local info = debug.getinfo(conn.Function)
                if info and info.source and info.source:find("AntiCheat") then
                    conn:Disable()
                    table.insert(disabledConnections, conn)
                end
            end
        end
    end)
    
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        
        local oldmt = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            
            if method == "FireServer" and tostring(self):lower():find("log") then
                return task.wait(9e9)
            end
            
            return oldmt(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
end

function Module.stop()
    for _, connection in pairs(connections) do
        if connection then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    connections = {}
    
    pcall(function()
        if oldNamecall then
            hookmetamethod(game, "__namecall", oldNamecall)
            oldNamecall = nil
        end
    end)
    
    pcall(function()
        if oldIndex then
            hookmetamethod(game, "__index", oldIndex)
            oldIndex = nil
        end
    end)
    
    pcall(function()
        if oldNewIndex then
            hookmetamethod(game, "__newindex", oldNewIndex)
            oldNewIndex = nil
        end
    end)
    
    pcall(function()
        for _, conn in pairs(disabledConnections) do
            if conn and conn.Enable then
                conn:Enable()
            end
        end
        disabledConnections = {}
    end)
end

return Module
