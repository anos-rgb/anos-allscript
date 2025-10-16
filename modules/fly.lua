local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Module = {}
local connection
local bodyVelocity
local bodyGyro
local flying = false
local flySpeed = 50

local keysPressed = {w = false, a = false, s = false, d = false, space = false, shift = false}

function Module.start()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    bodyGyro.P = 9000
    bodyGyro.Parent = rootPart
    
    flying = true
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    local inputBegin = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keysPressed.w = true
        elseif input.KeyCode == Enum.KeyCode.A then keysPressed.a = true
        elseif input.KeyCode == Enum.KeyCode.S then keysPressed.s = true
        elseif input.KeyCode == Enum.KeyCode.D then keysPressed.d = true
        elseif input.KeyCode == Enum.KeyCode.Space then keysPressed.space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then keysPressed.shift = true
        end
    end)
    
    local inputEnd = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keysPressed.w = false
        elseif input.KeyCode == Enum.KeyCode.A then keysPressed.a = false
        elseif input.KeyCode == Enum.KeyCode.S then keysPressed.s = false
        elseif input.KeyCode == Enum.KeyCode.D then keysPressed.d = false
        elseif input.KeyCode == Enum.KeyCode.Space then keysPressed.space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then keysPressed.shift = false
        end
    end)
    
    connection = RunService.Heartbeat:Connect(function()
        if flying and character and rootPart then
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            
            if keysPressed.w then direction = direction + camera.CFrame.LookVector end
            if keysPressed.s then direction = direction - camera.CFrame.LookVector end
            if keysPressed.a then direction = direction - camera.CFrame.RightVector end
            if keysPressed.d then direction = direction + camera.CFrame.RightVector end
            if keysPressed.space then direction = direction + Vector3.new(0, 1, 0) end
            if keysPressed.shift then direction = direction - Vector3.new(0, 1, 0) end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit
            end
            
            bodyVelocity.Velocity = direction * flySpeed
            bodyGyro.CFrame = camera.CFrame
        end
    end)
    
    Module.inputBeginConn = inputBegin
    Module.inputEndConn = inputEnd
end

function Module.stop()
    flying = false
    
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if Module.inputBeginConn then
        Module.inputBeginConn:Disconnect()
    end
    
    if Module.inputEndConn then
        Module.inputEndConn:Disconnect()
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    keysPressed = {w = false, a = false, s = false, d = false, space = false, shift = false}
end

return Module