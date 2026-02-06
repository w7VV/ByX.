-- Map Dumper (Full Place Dump with Decompile Support)
-- يدعم معظم الاكزيكيوترز

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapDumper"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 360, 0, 220)
Frame.Position = UDim2.new(0.5, -180, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Map Dumper"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Frame

-- Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Close.Parent = Frame
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Description
local Desc = Instance.new("TextLabel")
Desc.Size = UDim2.new(1, -20, 0, 80)
Desc.Position = UDim2.new(0, 10, 0, 45)
Desc.BackgroundTransparency = 1
Desc.Text = "يدعم الدامب الكامل:\nWorkspace • Lighting • ReplicatedStorage\nServerScriptService (مع ديكمبايل إن أمكن)\nStarterGui • StarterPlayer • SoundService • Teams"
Desc.TextColor3 = Color3.new(1, 1, 1)
Desc.TextWrapped = true
Desc.TextSize = 16
Desc.Font = Enum.Font.SourceSans
Desc.Parent = Frame

-- Dump Button
local DumpButton = Instance.new("TextButton")
DumpButton.Size = UDim2.new(0, 220, 0, 50)
DumpButton.Position = UDim2.new(0.5, -110, 1, -65)
DumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
DumpButton.Text = "Dump Place"
DumpButton.TextColor3 = Color3.new(1, 1, 1)
DumpButton.Font = Enum.Font.GothamBold
DumpButton.TextSize = 20
DumpButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = DumpButton

-- Draggable
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
        updateInput(input)
    end
end)

-- Dump Function
DumpButton.MouseButton1Click:Connect(function()
    DumpButton.Text = "Dumping..."
    DumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
    
    local saveFunc = nil
    if typeof(saveinstance) == "function" then
        saveFunc = saveinstance
    elseif syn and typeof(syn.saveinstance) == "function" then
        saveFunc = syn.saveinstance
    end
    
    local success, err = pcall(function()
        if saveFunc then
            saveFunc()
        end
    end)
    
    if success and saveFunc then
        DumpButton.Text = "Dumped Successfully!"
        DumpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    else
        DumpButton.Text = "Failed / Not Supported"
        DumpButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)
