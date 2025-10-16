-- Main Hub Script by anos-rgb
-- GitHub: https://github.com/anos-rgb/anos-allscript
-- Script modular dengan toggle on/off per fitur

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
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local CategoryFrame = Instance.new("Frame")
local ScrollFrame = Instance.new("ScrollingFrame")
local SearchBox = Instance.new("TextBox")

HubGui.Name = "ANOS|SCRIPT|HUB"
HubGui.Parent = PlayerGui
HubGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = HubGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 100)
MainFrame.BorderSizePixel = 3
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 50)

Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.65, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🔥 ANOS SCRIPT HUB 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20

MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -82, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20

SearchBox.Name = "SearchBox"
SearchBox.Parent = MainFrame
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SearchBox.BorderColor3 = Color3.fromRGB(255, 50, 100)
SearchBox.BorderSizePixel = 2
SearchBox.Position = UDim2.new(0, 10, 0, 60)
SearchBox.Size = UDim2.new(1, -20, 0, 35)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.PlaceholderText = "🔍 Cari script..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 16

CategoryFrame.Name = "CategoryFrame"
CategoryFrame.Parent = MainFrame
CategoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
CategoryFrame.BorderSizePixel = 0
CategoryFrame.Position = UDim2.new(0, 10, 0, 105)
CategoryFrame.Size = UDim2.new(1, -20, 0, 40)

local categories = {"All", "Movement", "Character", "Animation", "Combat", "Social", "Trolling", "Utility"}
local selectedCategory = "All"

for i, category in ipairs(categories) do
    local catBtn = Instance.new("TextButton")
    catBtn.Name = category
    catBtn.Parent = CategoryFrame
    catBtn.BackgroundColor3 = category == "All" and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(50, 50, 55)
    catBtn.BorderSizePixel = 0
    catBtn.Position = UDim2.new((i-1) * 0.125, 2, 0, 5)
    catBtn.Size = UDim2.new(0.123, -4, 1, -10)
    catBtn.Font = Enum.Font.SourceSans
    catBtn.Text = category
    catBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    catBtn.TextSize = 13
    catBtn.TextScaled = true
    
    catBtn.MouseButton1Click:Connect(function()
        selectedCategory = category
        for _, btn in pairs(CategoryFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            end
        end
        catBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
        updateModuleList()
    end)
end

ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = MainFrame
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 10, 0, 155)
ScrollFrame.Size = UDim2.new(1, -20, 1, -165)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 8

local function createModuleButton(moduleName, fileName, yPos)
    local btn = Instance.new("TextButton")
    btn.Name = fileName
    btn.Parent = ScrollFrame
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    btn.BorderColor3 = Color3.fromRGB(100, 100, 110)
    btn.BorderSizePixel = 2
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.Size = UDim2.new(1, -25, 0, 55)
    btn.Font = Enum.Font.SourceSans
    btn.Text = moduleName .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.TextWrapped = true
    
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
                
                button.Text = moduleName .. " [ON]"
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
                
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
        button.Text = moduleName .. " [ERROR]"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end

function stopModule(fileName, button)
    if ModuleConnections[fileName] and ModuleConnections[fileName].stop then
        ModuleConnections[fileName].stop()
    end
    
    ModuleStates[fileName] = false
    ModuleConnections[fileName] = nil
    
    local moduleName = button.Text:gsub(" %[ON%]", ""):gsub(" %[OFF%]", "")
    button.Text = moduleName .. " [OFF]"
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Module Stopped";
        Text = moduleName .. " deactivated!";
        Duration = 3;
    })
end

function updateModuleList()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yPos = 5
    local searchText = SearchBox.Text:lower()
    
    for _, module in ipairs(Modules) do
        local matchesCategory = selectedCategory == "All" or module.category == selectedCategory
        local matchesSearch = searchText == "" or module.name:lower():find(searchText)
        
        if matchesCategory and matchesSearch then
            createModuleButton(module.name, module.file, yPos)
            yPos = yPos + 65
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(updateModuleList)

CloseBtn.MouseButton1Click:Connect(function()
    for fileName, _ in pairs(ModuleStates) do
        if ModuleConnections[fileName] and ModuleConnections[fileName].stop then
            ModuleConnections[fileName].stop()
        end
    end
    HubGui:Destroy()
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 500, 0, 600), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "-"
        minimized = false
    else
        MainFrame:TweenSize(UDim2.new(0, 500, 0, 50), "Out", "Quad", 0.3, true)
        MinimizeBtn.Text = "+"
        minimized = true
    end
end)

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