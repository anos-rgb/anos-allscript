local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ModuleStates = {}
local ModuleConnections = {}

local GitHubBase = "https://raw.githubusercontent.com/anos-rgb/anos-allscript/main/modules/"

local Modules = {
    {name = "Speed Hack", file = "speed-hack.lua", category = "Movement"},
    {name = "Jump Power", file = "jump-power.lua", category = "Movement"},
    {name = "Infinite Jump", file = "infinite-jump.lua", category = "Movement"},
    {name = "God Mode", file = "god-mode.lua", category = "Character"},
    {name = "Fly/Levitate", file = "fly.lua", category = "Movement"},
    {name = "No Clip", file = "noclip.lua", category = "Movement"},
    {name = "Teleport Spam", file = "teleport-spam.lua", category = "Movement"},
    {name = "Fling Self", file = "fling-self.lua", category = "Character"},
    {name = "Spin Character", file = "spin-character.lua", category = "Character"},
    {name = "Walk on Air", file = "walk-air.lua", category = "Movement"},
    {name = "Ice Skate", file = "ice-skate.lua", category = "Movement"},
    {name = "Moonwalk", file = "moonwalk.lua", category = "Movement"},
    {name = "Ragdoll Spam", file = "ragdoll-spam.lua", category = "Character"},
    {name = "Sit Spam", file = "sit-spam.lua", category = "Character"},
    {name = "Climb Boost", file = "climb-boost.lua", category = "Movement"},
    {name = "Anti Fall Damage", file = "anti-fall.lua", category = "Character"},
    {name = "Emote Spam", file = "emote-spam.lua", category = "Animation"},
    {name = "Animation Speed", file = "animation-speed.lua", category = "Animation"},
    {name = "Animation Glitch", file = "animation-glitch.lua", category = "Animation"},
    {name = "Pose Modes", file = "pose-modes.lua", category = "Animation"},
    {name = "Animation Freeze", file = "animation-freeze.lua", category = "Animation"},
    {name = "Rapid Fire", file = "rapid-fire.lua", category = "Combat"},
    {name = "Instant Reload", file = "instant-reload.lua", category = "Combat"},
    {name = "Chat Spam", file = "chat-spam.lua", category = "Social"},
    {name = "Chat Flood", file = "chat-flood.lua", category = "Social"},
    {name = "Whisper Spam", file = "whisper-spam.lua", category = "Social"},
    {name = "Fling Player", file = "fling-player.lua", category = "Trolling"},
    {name = "Push Player", file = "push-player.lua", category = "Trolling"},
    {name = "Attach Player", file = "attach-player.lua", category = "Trolling"},
    {name = "Spam Nearby", file = "spam-nearby.lua", category = "Trolling"},
    {name = "Body Block", file = "body-block.lua", category = "Trolling"},
    {name = "Follow Bot", file = "follow-bot.lua", category = "Trolling"},
    {name = "Anti AFK", file = "anti-afk.lua", category = "Utility"},
    {name = "Anti Cheat Bypass", file = "anti-cheat-bypass.lua", category = "Utility"}
}

local HubGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local TopBarCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local CloseBtnCorner = Instance.new("UICorner")
local MinimizeBtn = Instance.new("TextButton")
local MinimizeBtnCorner = Instance.new("UICorner")
local CategoryFrame = Instance.new("Frame")
local CategoryFrameCorner = Instance.new("UICorner")
local ScrollFrame = Instance.new("ScrollingFrame")
local ScrollFrameCorner = Instance.new("UICorner")
local SearchBox = Instance.new("TextBox")
local SearchBoxCorner = Instance.new("UICorner")
local Shadow = Instance.new("ImageLabel")

HubGui.Name = "ANOS|SCRIPT|HUB"
HubGui.Parent = PlayerGui
HubGui.ResetOnSpawn = false
HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(99, 99, 99, 99)

MainFrame.Name = "MainFrame"
MainFrame.Parent = HubGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -325)
MainFrame.Size = UDim2.new(0, 550, 0, 650)
MainFrame.Active = true
MainFrame.ZIndex = 1

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.ZIndex = 2

TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TopBarFill = Instance.new("Frame")
TopBarFill.Parent = TopBar
TopBarFill.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBarFill.BorderSizePixel = 0
TopBarFill.Position = UDim2.new(0, 0, 0.5, 0)
TopBarFill.Size = UDim2.new(1, 0, 0.5, 0)
TopBarFill.ZIndex = 2

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ ANOS SCRIPT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -45, 0, 12)
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.ZIndex = 3

CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -90, 0, 12)
MinimizeBtn.Size = UDim2.new(0, 36, 0, 36)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.ZIndex = 3

MinimizeBtnCorner.CornerRadius = UDim.new(0, 8)
MinimizeBtnCorner.Parent = MinimizeBtn

SearchBox.Name = "SearchBox"
SearchBox.Parent = MainFrame
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchBox.BorderSizePixel = 0
SearchBox.Position = UDim2.new(0, 15, 0, 75)
SearchBox.Size = UDim2.new(1, -30, 0, 40)
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "🔍 Cari script..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 15
SearchBox.ZIndex = 2

SearchBoxCorner.CornerRadius = UDim.new(0, 8)
SearchBoxCorner.Parent = SearchBox

CategoryFrame.Name = "CategoryFrame"
CategoryFrame.Parent = MainFrame
CategoryFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CategoryFrame.BorderSizePixel = 0
CategoryFrame.Position = UDim2.new(0, 15, 0, 125)
CategoryFrame.Size = UDim2.new(1, -30, 0, 45)
CategoryFrame.ZIndex = 2

CategoryFrameCorner.CornerRadius = UDim.new(0, 8)
CategoryFrameCorner.Parent = CategoryFrame

local categories = {"All", "Movement", "Character", "Animation", "Combat", "Social", "Trolling", "Utility"}
local selectedCategory = "All"

for i, category in ipairs(categories) do
    local catBtn = Instance.new("TextButton")
    local catBtnCorner = Instance.new("UICorner")
    
    catBtn.Name = category
    catBtn.Parent = CategoryFrame
    catBtn.BackgroundColor3 = category == "All" and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(40, 40, 40)
    catBtn.BorderSizePixel = 0
    catBtn.Position = UDim2.new((i-1) * 0.125, 3, 0, 6)
    catBtn.Size = UDim2.new(0.122, -6, 1, -12)
    catBtn.Font = Enum.Font.GothamSemibold
    catBtn.Text = category
    catBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    catBtn.TextSize = 12
    catBtn.TextScaled = true
    catBtn.ZIndex = 3
    
    catBtnCorner.CornerRadius = UDim.new(0, 6)
    catBtnCorner.Parent = catBtn
    
    catBtn.MouseEnter:Connect(function()
        if selectedCategory ~= category then
            TweenService:Create(catBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end
    end)
    
    catBtn.MouseLeave:Connect(function()
        if selectedCategory ~= category then
            TweenService:Create(catBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end
    end)
    
    catBtn.MouseButton1Click:Connect(function()
        selectedCategory = category
        for _, btn in pairs(CategoryFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end
        end
        TweenService:Create(catBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}):Play()
        updateModuleList()
    end)
end

ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 15, 0, 180)
ScrollFrame.Size = UDim2.new(1, -30, 1, -195)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
ScrollFrame.ZIndex = 2

ScrollFrameCorner.CornerRadius = UDim.new(0, 8)
ScrollFrameCorner.Parent = ScrollFrame

local function createModuleButton(moduleName, fileName, yPos)
    local btn = Instance.new("TextButton")
    local btnCorner = Instance.new("UICorner")
    local statusLabel = Instance.new("TextLabel")
    
    btn.Name = fileName
    btn.Parent = ScrollFrame
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 8, 0, yPos)
    btn.Size = UDim2.new(1, -24, 0, 55)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = moduleName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextXOffset = 15
    btn.ZIndex = 3
    
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    statusLabel.Name = "Status"
    statusLabel.Parent = btn
    statusLabel.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    statusLabel.BorderSizePixel = 0
    statusLabel.Position = UDim2.new(1, -65, 0.5, -12)
    statusLabel.Size = UDim2.new(0, 55, 0, 24)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 12
    statusLabel.ZIndex = 4
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusLabel
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        if ModuleStates[fileName] then
            stopModule(fileName, btn)
        else
            loadModule(fileName, btn, moduleName)
        end
    end)
    
    return btn
end

function loadModule(fileName, button, moduleName)
    local statusLabel = button:FindFirstChild("Status")
    
    local success, result = pcall(function()
        local url = GitHubBase .. fileName
        local scriptContent = game:HttpGet(url)
        
        local moduleFunc = loadstring(scriptContent)
        if moduleFunc then
            local moduleReturn = moduleFunc()
            
            if type(moduleReturn) == "table" and moduleReturn.start then
                ModuleStates[fileName] = true
                ModuleConnections[fileName] = moduleReturn
                moduleReturn.start()
                
                statusLabel.Text = "ON"
                TweenService:Create(statusLabel, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Module Loaded";
                    Text = moduleName .. " activated!";
                    Duration = 3;
                })
            end
        end
    end)
    
    if not success then
        warn("Failed to load module: " .. fileName)
        statusLabel.Text = "ERR"
        TweenService:Create(statusLabel, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}):Play()
    end
end

function stopModule(fileName, button)
    local statusLabel = button:FindFirstChild("Status")
    
    if ModuleConnections[fileName] and ModuleConnections[fileName].stop then
        ModuleConnections[fileName].stop()
    end
    
    ModuleStates[fileName] = false
    ModuleConnections[fileName] = nil
    
    statusLabel.Text = "OFF"
    TweenService:Create(statusLabel, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Module Stopped";
        Text = button.Text .. " deactivated!";
        Duration = 3;
    })
end

function updateModuleList()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yPos = 8
    local searchText = SearchBox.Text:lower()
    
    for _, module in ipairs(Modules) do
        local matchesCategory = selectedCategory == "All" or module.category == selectedCategory
        local matchesSearch = searchText == "" or module.name:lower():find(searchText)
        
        if matchesCategory and matchesSearch then
            createModuleButton(module.name, module.file, yPos)
            yPos = yPos + 63
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 8)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(updateModuleList)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    for fileName, _ in pairs(ModuleStates) do
        if ModuleConnections[fileName] and ModuleConnections[fileName].stop then
            pcall(function()
                ModuleConnections[fileName].stop()
            end)
        end
    end
    
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    HubGui:Destroy()
end)

MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
end)

MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 550, 0, 650)}):Play()
        MinimizeBtn.Text = "−"
        minimized = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 550, 0, 60)}):Play()
        MinimizeBtn.Text = "+"
        minimized = true
    end
end)

local dragToggle = nil
local dragSpeed = 0.25
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInput(input)
        end
    end
end)

MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 550, 0, 650)}):Play()

updateModuleList()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ANOS SCRIPT HUB";
    Text = "Hub loaded! Choose your modules!";
    Duration = 5;
})

print("🔥========================================🔥")
print("     ANOS SCRIPT HUB - Main Loader")
print("     GitHub: anos-rgb/anos-allscript")
print("     34 Modules Available")
print("🔥========================================🔥")
