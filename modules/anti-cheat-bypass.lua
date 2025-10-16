local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connections = {}
local oldNamecall
local oldIndex
local oldNewIndex

function Module.start()
    
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
    
    connections.childAdded = ReplicatedStorage.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:lower():find("anticheat") or 
               obj.Name:lower():find("kick") or
               obj.Name:lower():find("ban") or
               obj.Name:lower():find("detect") then
                wait(0.1)
                obj:Destroy()
            end
        end
    end)
    
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" or method == "InvokeServer" then
            if self.Name:lower():find("anticheat") or 
               self.Name:lower():find("kick") or
               self.Name:lower():find("ban") or
               self.Name:lower():find("detect") then
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
    
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if key == "WalkSpeed" or key == "JumpPower" or key == "JumpHeight" then
            if self:IsA("Humanoid") and self.Parent == LocalPlayer.Character then
                return 16
            end
        end
        
        return oldIndex(self, key)
    end)
    
    oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
        if key == "WalkSpeed" or key == "JumpPower" or key == "JumpHeight" then
            if self:IsA("Humanoid") and self.Parent == LocalPlayer.Character then
                return
            end
        end
        
        return oldNewIndex(self, key, value)
    end)
    
    connections.heartbeat = RunService.Heartbeat:Connect(function()
        for _, script in pairs(LocalPlayer.PlayerScripts:GetDescendants()) do
            if script:IsA("LocalScript") or script:IsA("ModuleScript") then
                if script.Name:lower():find("anticheat") or 
                   script.Name:lower():find("anticlient") or
                   script.Name:lower():find("antiexploit") then
                    script.Disabled = true
                    wait(0.1)
                    script:Destroy()
                end
            end
        end
    end)
    
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        conn:Disable()
    end
    
    for _, conn in pairs(getconnections(LocalPlayer.CharacterAdded)) do
        if conn.Function and debug.getinfo(conn.Function).source:find("AntiCheat") then
            conn:Disable()
        end
    end
    
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldmt = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        if method == "FireServer" and tostring(self):lower():find("log") then
            return wait(9e9)
        end
        
        return oldmt(self, ...)
    end)
    
    setreadonly(mt, true)
    
end

function Module.stop()
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    if oldNamecall then
        hookmetamethod(game, "__namecall", oldNamecall)
    end
    
    if oldIndex then
        hookmetamethod(game, "__index", oldIndex)
    end
    
    if oldNewIndex then
        hookmetamethod(game, "__newindex", oldNewIndex)
    end
end

return Module