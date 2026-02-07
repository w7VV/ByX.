--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// الانتظار حتى يتم تحميل الشخصية
if not player.Character then
    player.CharacterAdded:Wait()
end
wait(0.5)

--// Glassmorphism Theme
local COLORS = {
    BACKGROUND = Color3.fromHex("#061733"),
    GLASS_1 = Color3.fromHex("#061733"),
    GLASS_2 = Color3.fromHex("#075bb4"),
    BUTTON_BASE = Color3.fromHex("#0a2a5a"),
    TEXT_WHITE = Color3.fromRGB(255, 255, 255),
    TEXT_LIGHT = Color3.fromRGB(240, 240, 240),
    BLACK = Color3.new(0, 0, 0),
    RED = Color3.fromRGB(255, 50, 50),
    DARK_RED = Color3.fromRGB(200, 30, 30),
    GREEN = Color3.fromRGB(50, 200, 50),
    GRAY = Color3.fromRGB(150, 150, 150)
}

--// إعدادات افتراضية
local settings = {
    killOnStop = false,
    returnToOldPosition = true,
    excludedPlayers = {}
}

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

--// زر الإعدادات (صورة) في الزاوية اليمين - حجم أصغر
local settingsButton = Instance.new("ImageButton")
settingsButton.Name = "SettingsButton"
settingsButton.Size = UDim2.new(0, 35, 0, 35) -- حجم أصغر
settingsButton.Position = UDim2.new(1, -45, 0, 15) -- تعديل الموقع
settingsButton.AnchorPoint = Vector2.new(1, 0)
settingsButton.BackgroundColor3 = COLORS.BACKGROUND
settingsButton.BackgroundTransparency = 0.3
settingsButton.BorderSizePixel = 0
settingsButton.ZIndex = 100
settingsButton.Image = "rbxassetid://9405931578"
settingsButton.ScaleType = Enum.ScaleType.Fit
settingsButton.Parent = screenGui

local settingsButtonCorner = Instance.new("UICorner")
settingsButtonCorner.CornerRadius = UDim.new(0, 8)
settingsButtonCorner.Parent = settingsButton

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 40)
mainFrame.Position = UDim2.new(0.01, 0, 0.05, 0)
mainFrame.BackgroundColor3 = COLORS.BACKGROUND
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.GLASS_1), ColorSequenceKeypoint.new(1, COLORS.GLASS_2)})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

--// Header
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 40)
headerFrame.BackgroundColor3 = COLORS.GLASS_1
headerFrame.BackgroundTransparency = 0.4
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 11
headerFrame.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.GLASS_1), ColorSequenceKeypoint.new(1, COLORS.GLASS_2)})
headerGradient.Rotation = 90
headerGradient.Parent = headerFrame

--// Avatar
local avatarContainer = Instance.new("Frame")
avatarContainer.Size = UDim2.new(0, 30, 0, 30)
avatarContainer.Position = UDim2.new(0, 8, 0.5, -15)
avatarContainer.BackgroundColor3 = COLORS.GLASS_1
avatarContainer.BackgroundTransparency = 0.4
avatarContainer.BorderSizePixel = 0
avatarContainer.ZIndex = 12
avatarContainer.Parent = headerFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarContainer

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundTransparency = 1
avatarImage.ZIndex = 13
avatarImage.Parent = avatarContainer

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(1, 0)
avatarImageCorner.Parent = avatarImage

pcall(function()
    local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    if content then
        avatarImage.Image = content
    end
end)

--// Player Name
local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0, 140, 0, 18)
playerNameLabel.Position = UDim2.new(0, 48, 0, 6)
playerNameLabel.Text = player.Name
playerNameLabel.TextColor3 = COLORS.TEXT_WHITE
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextSize = 15
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.ZIndex = 12
playerNameLabel.Parent = headerFrame

--// Map Name
local mapNameLabel = Instance.new("TextLabel")
mapNameLabel.Size = UDim2.new(0, 140, 0, 14)
mapNameLabel.Position = UDim2.new(0, 48, 0, 22)
mapNameLabel.TextColor3 = COLORS.TEXT_LIGHT
mapNameLabel.Font = Enum.Font.Gotham
mapNameLabel.TextSize = 11
mapNameLabel.TextXAlignment = Enum.TextXAlignment.Left
mapNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
mapNameLabel.BackgroundTransparency = 1
mapNameLabel.ZIndex = 12
mapNameLabel.Parent = headerFrame

local success, productInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and productInfo then
    mapNameLabel.Text = productInfo.Name
else
    mapNameLabel.Text = game:GetService("Workspace").Name or "Unknown Place"
end

--// Collapse Button
local collapseButton = Instance.new("TextButton")
collapseButton.Size = UDim2.new(0, 35, 0, 35)
collapseButton.Position = UDim2.new(1, -40, 0.5, -17.5)
collapseButton.Text = "−"
collapseButton.TextColor3 = COLORS.TEXT_WHITE
collapseButton.Font = Enum.Font.GothamBold
collapseButton.TextSize = 28
collapseButton.BackgroundTransparency = 1
collapseButton.BorderSizePixel = 0
collapseButton.ZIndex = 12
collapseButton.Parent = headerFrame

--// Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundColor3 = COLORS.GLASS_1
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.ZIndex = 11
contentFrame.Parent = mainFrame

--// عنوان كبير
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 60)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.Text = "سحب أكاديميه ريفن"
titleLabel.TextColor3 = COLORS.TEXT_WHITE
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.ZIndex = 12
titleLabel.Parent = contentFrame

--// ScrollingFrame للأزرار فقط
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 0, 250)
scrollingFrame.Position = UDim2.new(0, 0, 0, 70)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = COLORS.GLASS_2
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ZIndex = 12
scrollingFrame.Parent = contentFrame

--// UIListLayout داخل الـ ScrollingFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 14)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollingFrame

--// تحديث CanvasSize تلقائيًا
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

--// جدول لتخزين حالة كل زر
local buttonStates = {}
local activeButton = nil -- زر واحد نشط فقط

--// متغيرات لتشغيل/إيقاف السكربتات
local runningScripts = {}
local scriptConnections = {}
local scriptThreads = {}
local playerOriginalPosition = nil

--// قائمة الأزرار مع إحداثياتها
local buttonConfigs = {
    ["ارميهم في البحر"] = {
        dropCFrame = CFrame.new(1277.34, 655.12, -2805.79)
    },
    ["احشرهم"] = {
        dropCFrame = CFrame.new(240.95, 8.92, -2962.78)
    },
    ["ارميهم في المكان السري"] = {
        dropCFrame = CFrame.new(-590.09, -319.93, -2580.29)
    },
    ["غرقهم"] = {
        dropCFrame = nil
    },
    ["اسحبهم لعندك"] = {
        dropCFrame = nil
    }
}

--// نافذة الإعدادات - نفس حجم الفارم الرئيسي
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "SettingsFrame"
settingsFrame.Size = UDim2.new(0, 220, 0, 500) -- نفس حجم الفارم الرئيسي
settingsFrame.Position = UDim2.new(1, -20, 0, 80)
settingsFrame.AnchorPoint = Vector2.new(1, 0)
settingsFrame.BackgroundColor3 = COLORS.BACKGROUND
settingsFrame.BackgroundTransparency = 0.2
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
settingsFrame.ZIndex = 101
settingsFrame.Parent = screenGui

local settingsGradient = Instance.new("UIGradient")
settingsGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.GLASS_1), ColorSequenceKeypoint.new(1, COLORS.GLASS_2)})
settingsGradient.Rotation = 90
settingsGradient.Parent = settingsFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 12)
settingsCorner.Parent = settingsFrame

local settingsHeader = Instance.new("Frame")
settingsHeader.Size = UDim2.new(1, 0, 0, 40) -- ارتفاع أقل
settingsHeader.BackgroundColor3 = COLORS.GLASS_1
settingsHeader.BackgroundTransparency = 0.4
settingsHeader.BorderSizePixel = 0
settingsHeader.ZIndex = 102
settingsHeader.Parent = settingsFrame

local settingsHeaderGradient = Instance.new("UIGradient")
settingsHeaderGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.GLASS_1), ColorSequenceKeypoint.new(1, COLORS.GLASS_2)})
settingsHeaderGradient.Rotation = 90
settingsHeaderGradient.Parent = settingsHeader

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 1, 0)
settingsTitle.Text = "الإعدادات"
settingsTitle.TextColor3 = COLORS.TEXT_WHITE
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 18 -- أصغر قليلاً
settingsTitle.BackgroundTransparency = 1
settingsTitle.ZIndex = 103
settingsTitle.Parent = settingsHeader

local settingsContent = Instance.new("ScrollingFrame")
settingsContent.Size = UDim2.new(1, -10, 1, -50) -- تعديل المساحة
settingsContent.Position = UDim2.new(0, 5, 0, 45)
settingsContent.BackgroundTransparency = 1
settingsContent.BorderSizePixel = 0
settingsContent.ScrollBarThickness = 6
settingsContent.ScrollBarImageColor3 = COLORS.GLASS_2
settingsContent.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsContent.ZIndex = 102
settingsContent.Parent = settingsFrame

local settingsList = Instance.new("UIListLayout")
settingsList.Padding = UDim.new(0, 10) -- تباعد أقل
settingsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
settingsList.SortOrder = Enum.SortOrder.LayoutOrder
settingsList.Parent = settingsContent

settingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsList.AbsoluteContentSize.Y + 10)
end)

--// خيار: موت الاعب عند إيقاف العمليه
local killOptionFrame = Instance.new("Frame")
killOptionFrame.Size = UDim2.new(1, 0, 0, 40) -- ارتفاع أقل
killOptionFrame.BackgroundColor3 = COLORS.BUTTON_BASE
killOptionFrame.BackgroundTransparency = 0.65
killOptionFrame.BorderSizePixel = 0
killOptionFrame.ZIndex = 103
killOptionFrame.LayoutOrder = 1
killOptionFrame.Parent = settingsContent

local killOptionCorner = Instance.new("UICorner")
killOptionCorner.CornerRadius = UDim.new(0, 6)
killOptionCorner.Parent = killOptionFrame

local killOptionText = Instance.new("TextLabel")
killOptionText.Size = UDim2.new(0.65, -10, 1, 0) -- مساحة أقل للنص
killOptionText.Position = UDim2.new(0, 8, 0, 0)
killOptionText.Text = "موت عند الإيقاف"
killOptionText.TextColor3 = COLORS.TEXT_WHITE
killOptionText.Font = Enum.Font.GothamBold
killOptionText.TextSize = 14 -- أصغر
killOptionText.TextXAlignment = Enum.TextXAlignment.Left
killOptionText.BackgroundTransparency = 1
killOptionText.ZIndex = 104
killOptionText.Parent = killOptionFrame

local killToggleFrame = Instance.new("Frame")
killToggleFrame.Size = UDim2.new(0, 50, 0, 25) -- أصغر
killToggleFrame.Position = UDim2.new(1, -58, 0.5, -12.5)
killToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
killToggleFrame.BackgroundColor3 = settings.killOnStop and COLORS.GREEN or COLORS.GRAY
killToggleFrame.BorderSizePixel = 0
killToggleFrame.ZIndex = 104
killToggleFrame.Parent = killOptionFrame

local killToggleCorner = Instance.new("UICorner")
killToggleCorner.CornerRadius = UDim.new(1, 0)
killToggleCorner.Parent = killToggleFrame

local killToggleButton = Instance.new("TextButton")
killToggleButton.Size = UDim2.new(1, 0, 1, 0)
killToggleButton.Text = settings.killOnStop and "ON" or "OFF"
killToggleButton.TextColor3 = COLORS.TEXT_WHITE
killToggleButton.Font = Enum.Font.GothamBold
killToggleButton.TextSize = 12
killToggleButton.BackgroundTransparency = 1
killToggleButton.ZIndex = 105
killToggleButton.Parent = killToggleFrame

killToggleButton.MouseButton1Click:Connect(function()
    settings.killOnStop = not settings.killOnStop
    killToggleFrame.BackgroundColor3 = settings.killOnStop and COLORS.GREEN or COLORS.GRAY
    killToggleButton.Text = settings.killOnStop and "ON" or "OFF"
end)

--// خيار: الانتقال إلى مكانك القديم بعد إيقاف العمليه
local returnOptionFrame = Instance.new("Frame")
returnOptionFrame.Size = UDim2.new(1, 0, 0, 40) -- ارتفاع أقل
returnOptionFrame.BackgroundColor3 = COLORS.BUTTON_BASE
returnOptionFrame.BackgroundTransparency = 0.65
returnOptionFrame.BorderSizePixel = 0
returnOptionFrame.ZIndex = 103
returnOptionFrame.LayoutOrder = 2
returnOptionFrame.Parent = settingsContent

local returnOptionCorner = Instance.new("UICorner")
returnOptionCorner.CornerRadius = UDim.new(0, 6)
returnOptionCorner.Parent = returnOptionFrame

local returnOptionText = Instance.new("TextLabel")
returnOptionText.Size = UDim2.new(0.65, -10, 1, 0)
returnOptionText.Position = UDim2.new(0, 8, 0, 0)
returnOptionText.Text = "العودة للموقع القديم"
returnOptionText.TextColor3 = COLORS.TEXT_WHITE
returnOptionText.Font = Enum.Font.GothamBold
returnOptionText.TextSize = 14
returnOptionText.TextXAlignment = Enum.TextXAlignment.Left
returnOptionText.BackgroundTransparency = 1
returnOptionText.ZIndex = 104
returnOptionText.Parent = returnOptionFrame

local returnToggleFrame = Instance.new("Frame")
returnToggleFrame.Size = UDim2.new(0, 50, 0, 25)
returnToggleFrame.Position = UDim2.new(1, -58, 0.5, -12.5)
returnToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
returnToggleFrame.BackgroundColor3 = settings.returnToOldPosition and COLORS.GREEN or COLORS.GRAY
returnToggleFrame.BorderSizePixel = 0
returnToggleFrame.ZIndex = 104
returnToggleFrame.Parent = returnOptionFrame

local returnToggleCorner = Instance.new("UICorner")
returnToggleCorner.CornerRadius = UDim.new(1, 0)
returnToggleCorner.Parent = returnToggleFrame

local returnToggleButton = Instance.new("TextButton")
returnToggleButton.Size = UDim2.new(1, 0, 1, 0)
returnToggleButton.Text = settings.returnToOldPosition and "ON" or "OFF"
returnToggleButton.TextColor3 = COLORS.TEXT_WHITE
returnToggleButton.Font = Enum.Font.GothamBold
returnToggleButton.TextSize = 12
returnToggleButton.BackgroundTransparency = 1
returnToggleButton.ZIndex = 105
returnToggleButton.Parent = returnToggleFrame

returnToggleButton.MouseButton1Click:Connect(function()
    settings.returnToOldPosition = not settings.returnToOldPosition
    returnToggleFrame.BackgroundColor3 = settings.returnToOldPosition and COLORS.GREEN or COLORS.GRAY
    returnToggleButton.Text = settings.returnToOldPosition and "ON" or "OFF"
end)

--// قسم قائمة استثناء الاعبين
local exclusionSectionTitle = Instance.new("TextLabel")
exclusionSectionTitle.Size = UDim2.new(1, 0, 0, 30)
exclusionSectionTitle.Position = UDim2.new(0, 0, 0, 0)
exclusionSectionTitle.Text = "استثناء اللاعبين"
exclusionSectionTitle.TextColor3 = COLORS.TEXT_WHITE
exclusionSectionTitle.Font = Enum.Font.GothamBold
exclusionSectionTitle.TextSize = 16
exclusionSectionTitle.BackgroundTransparency = 1
exclusionSectionTitle.ZIndex = 103
exclusionSectionTitle.LayoutOrder = 3
exclusionSectionTitle.Parent = settingsContent

--// مربع البحث - مبسط
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, 0, 0, 35)
searchFrame.BackgroundColor3 = COLORS.BUTTON_BASE
searchFrame.BackgroundTransparency = 0.65
searchFrame.BorderSizePixel = 0
searchFrame.ZIndex = 103
searchFrame.LayoutOrder = 4
searchFrame.Parent = settingsContent

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 6)
searchCorner.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.7, -5, 0.8, 0)
searchBox.Position = UDim2.new(0, 5, 0.5, -12)
searchBox.AnchorPoint = Vector2.new(0, 0.5)
searchBox.PlaceholderText = "اسم اللاعب..."
searchBox.Text = ""
searchBox.TextColor3 = COLORS.TEXT_WHITE
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.BackgroundColor3 = COLORS.GLASS_1
searchBox.BackgroundTransparency = 0.7
searchBox.ZIndex = 104
searchBox.Parent = searchFrame

local searchBoxCorner = Instance.new("UICorner")
searchBoxCorner.CornerRadius = UDim.new(0, 4)
searchBoxCorner.Parent = searchBox

local addButton = Instance.new("TextButton")
addButton.Size = UDim2.new(0.25, -5, 0.8, 0)
addButton.Position = UDim2.new(0.75, 5, 0.5, -12)
addButton.AnchorPoint = Vector2.new(0, 0.5)
addButton.Text = "إضافة"
addButton.TextColor3 = COLORS.TEXT_WHITE
addButton.Font = Enum.Font.GothamBold
addButton.TextSize = 14
addButton.BackgroundColor3 = COLORS.GREEN
addButton.BackgroundTransparency = 0.3
addButton.ZIndex = 104
addButton.Parent = searchFrame

local addButtonCorner = Instance.new("UICorner")
addButtonCorner.CornerRadius = UDim.new(0, 4)
addButtonCorner.Parent = addButton

--// قائمة اللاعبين المستبعدين
local exclusionListFrame = Instance.new("Frame")
exclusionListFrame.Size = UDim2.new(1, 0, 0, 180)
exclusionListFrame.BackgroundColor3 = COLORS.BUTTON_BASE
exclusionListFrame.BackgroundTransparency = 0.65
exclusionListFrame.BorderSizePixel = 0
exclusionListFrame.ZIndex = 103
exclusionListFrame.LayoutOrder = 5
exclusionListFrame.Parent = settingsContent

local exclusionListCorner = Instance.new("UICorner")
exclusionListCorner.CornerRadius = UDim.new(0, 6)
exclusionListCorner.Parent = exclusionListFrame

local exclusionScrolling = Instance.new("ScrollingFrame")
exclusionScrolling.Size = UDim2.new(1, -10, 1, -10)
exclusionScrolling.Position = UDim2.new(0, 5, 0, 5)
exclusionScrolling.BackgroundTransparency = 1
exclusionScrolling.BorderSizePixel = 0
exclusionScrolling.ScrollBarThickness = 6
exclusionScrolling.ScrollBarImageColor3 = COLORS.GLASS_2
exclusionScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
exclusionScrolling.ZIndex = 104
exclusionScrolling.Parent = exclusionListFrame

local exclusionListLayout = Instance.new("UIListLayout")
exclusionListLayout.Padding = UDim.new(0, 6)
exclusionListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
exclusionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
exclusionListLayout.Parent = exclusionScrolling

exclusionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    exclusionScrolling.CanvasSize = UDim2.new(0, 0, 0, exclusionListLayout.AbsoluteContentSize.Y + 10)
end)

--// دالة لعرض اللاعبين المستبعدين
local function updateExclusionList()
    for _, child in pairs(exclusionScrolling:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for _, excludedPlayer in pairs(settings.excludedPlayers) do
        local playerFrame = Instance.new("Frame")
        playerFrame.Size = UDim2.new(1, -10, 0, 45) -- أصغر
        playerFrame.BackgroundColor3 = COLORS.GLASS_1
        playerFrame.BackgroundTransparency = 0.7
        playerFrame.BorderSizePixel = 0
        playerFrame.ZIndex = 105
        playerFrame.Parent = exclusionScrolling
        
        local playerCorner = Instance.new("UICorner")
        playerCorner.CornerRadius = UDim.new(0, 4)
        playerCorner.Parent = playerFrame
        
        -- اسم اللاعب
        local playerNameLabel = Instance.new("TextLabel")
        playerNameLabel.Size = UDim2.new(0.6, -5, 1, 0)
        playerNameLabel.Position = UDim2.new(0, 5, 0, 0)
        playerNameLabel.Text = excludedPlayer
        playerNameLabel.TextColor3 = COLORS.TEXT_WHITE
        playerNameLabel.Font = Enum.Font.Gotham
        playerNameLabel.TextSize = 12
        playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        playerNameLabel.BackgroundTransparency = 1
        playerNameLabel.ZIndex = 106
        playerNameLabel.Parent = playerFrame
        
        -- زر الإزالة
        local removeButton = Instance.new("TextButton")
        removeButton.Size = UDim2.new(0, 60, 0, 25)
        removeButton.Position = UDim2.new(1, -65, 0.5, -12.5)
        removeButton.AnchorPoint = Vector2.new(1, 0.5)
        removeButton.Text = "إزالة"
        removeButton.TextColor3 = COLORS.TEXT_WHITE
        removeButton.Font = Enum.Font.GothamBold
        removeButton.TextSize = 12
        removeButton.BackgroundColor3 = COLORS.RED
        removeButton.BackgroundTransparency = 0.3
        removeButton.ZIndex = 106
        removeButton.Parent = playerFrame
        
        local removeCorner = Instance.new("UICorner")
        removeCorner.CornerRadius = UDim.new(0, 4)
        removeCorner.Parent = removeButton
        
        removeButton.MouseButton1Click:Connect(function()
            for i, name in pairs(settings.excludedPlayers) do
                if name == excludedPlayer then
                    table.remove(settings.excludedPlayers, i)
                    break
                end
            end
            updateExclusionList()
        end)
    end
end

--// زر الإضافة - مبسط بدون بحث تلقائي
addButton.MouseButton1Click:Connect(function()
    local playerName = searchBox.Text
    if playerName == "" then return end
    
    -- التحقق إذا كان اللاعب مضافاً بالفعل
    for _, excluded in pairs(settings.excludedPlayers) do
        if excluded == playerName then
            searchBox.Text = ""
            return
        end
    end
    
    -- إضافة اللاعب إلى القائمة
    table.insert(settings.excludedPlayers, playerName)
    updateExclusionList()
    searchBox.Text = ""
end)

--// تحميل القائمة الأولية
updateExclusionList()

--// دالة التحقق من اللاعب المستبعد
local function isPlayerExcluded(playerName)
    for _, excluded in pairs(settings.excludedPlayers) do
        if excluded == playerName then
            return true
        end
    end
    return false
end

--// دالة لإنشاء حركة التلاشي للدائرة الحمراء
local function createFadeAnimation(circle)
    local tweenInfo = TweenInfo.new(
        0.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true,
        0
    )
    
    local tween = TweenService:Create(circle, tweenInfo, {
        BackgroundTransparency = 0.5
    })
    
    return tween
end

--// دالة لتغيير لون نص التحذير
local function flashWarningText()
    warningLabel.TextColor3 = COLORS.DARK_RED
    wait(2)
    warningLabel.TextColor3 = COLORS.TEXT_LIGHT
end

--// دالة لإيقاف السكربت النشط
local function stopActiveScript(buttonName)
    if runningScripts[buttonName] then
        runningScripts[buttonName] = false
    end
    
    -- إيقاف جميع التردات
    if scriptConnections[buttonName] then
        for _, connection in pairs(scriptConnections[buttonName]) do
            if connection then
                connection:Disconnect()
            end
        end
        scriptConnections[buttonName] = nil
    end
    
    -- إيقاف جميع المهام
    if scriptThreads[buttonName] then
        for _, thread in pairs(scriptThreads[buttonName]) do
            task.cancel(thread)
        end
        scriptThreads[buttonName] = nil
    end
    
    -- تطبيق إعداد موت اللاعب إذا كان مفعلاً
    if settings.killOnStop and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
    
    -- إرجاع الشخصية للموضع الأصلي إذا كان مفعلاً
    if settings.returnToOldPosition and playerOriginalPosition and player.Character then
        local HRP = player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            HRP.CFrame = playerOriginalPosition
        end
    end
    
    playerOriginalPosition = nil
end

--// دالة سكربت عامة مع إحداثيات متغيرة
local function startGeneralScript(dropCFrame, buttonName)
    local Character = player.Character or player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HRP = Character:WaitForChild("HumanoidRootPart")
    local Backpack = player:WaitForChild("Backpack")

    local CUFFS_TOOL_NAME = "كلبشة"
    local GROUND_THRESHOLD = 8
    local UNDERGROUND_OFFSET = 12
    local BEHIND_DISTANCE = 4
    local SKIP_DISTANCE = 6

    local Camera = Workspace.CurrentCamera
    local camPos = Vector3.new(-203.92, 75.72, -2721.70)
    local camLook = Vector3.new(0.99, 0.11, -0.01)
    Camera.CFrame = CFrame.new(camPos, camPos + camLook)

    local CuffsTool = Backpack:FindFirstChild(CUFFS_TOOL_NAME)
    if not CuffsTool then
        return
    end

    Humanoid:EquipTool(CuffsTool)

    local myStats = player:FindFirstChild("leaderstats")
    if not myStats then
        return
    end
    local myPoints = myStats:FindFirstChild("نقاط")
    if not myPoints then
        return
    end

    local function getPlayerPoints(targetPlayer)
        local stats = targetPlayer:FindFirstChild("leaderstats")
        if stats then
            local points = stats:FindFirstChild("نقاط")
            if points then
                return points.Value
            end
        end
        return math.huge
    end

    local Running = true

    -- حفظ الموضع الأصلي للبلاير
    if buttonName == "اسحبهم لعندك" then
        playerOriginalPosition = HRP.CFrame
    else
        playerOriginalPosition = nil
    end

    -- مفتاح F للإيقاف
    local fConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F then
            Running = false
            Humanoid.PlatformStand = false
        end
    end)

    -- تحديث مستمر للتأكد من تجهيز الكلبشة
    local equipThread = task.spawn(function()
        while Running do
            if not Character:FindFirstChild(CUFFS_TOOL_NAME) then
                if CuffsTool.Parent == Backpack then
                    Humanoid:EquipTool(CuffsTool)
                end
            end
            task.wait(0.2)
        end
    end)

    -- حفظ المهام والروابط
    if activeButton then
        if not scriptConnections[activeButton] then
            scriptConnections[activeButton] = {}
        end
        if not scriptThreads[activeButton] then
            scriptThreads[activeButton] = {}
        end
        
        table.insert(scriptConnections[activeButton], fConnection)
        table.insert(scriptThreads[activeButton], equipThread)
    end

    -- Loop الرئيسي
    local mainThread = task.spawn(function()
        while Running and task.wait(1.2) do
            local validTargets = {}
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- التحقق من الاستثناء
                    if isPlayerExcluded(otherPlayer.Name) then
                        continue
                    end
                    
                    if getPlayerPoints(otherPlayer) >= myPoints.Value then
                        continue
                    end
                    
                    local TargetRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local distance = (HRP.Position - TargetRoot.Position).Magnitude
                    
                    if distance >= SKIP_DISTANCE then
                        table.insert(validTargets, {Player = otherPlayer, Distance = distance})
                    end
                end
            end
            
            if #validTargets == 0 then
                break
            end
            
            table.sort(validTargets, function(a, b)
                return a.Distance > b.Distance
            end)
            
            for _, targetData in pairs(validTargets) do
                if not Running then break end
                
                local otherPlayer = targetData.Player
                local TargetCharacter = otherPlayer.Character
                local TargetRoot = TargetCharacter:WaitForChild("HumanoidRootPart")
                
                local rayOrigin = TargetRoot.Position + Vector3.new(0, 5, 0)
                local rayDirection = Vector3.new(0, -1000, 0)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {TargetCharacter}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                local rayResult = Workspace:Raycast(rayOrigin, rayDirection, rayParams)
                
                local groundY = rayResult and rayResult.Position.Y or TargetRoot.Position.Y - 100
                local heightAboveGround = TargetRoot.Position.Y - groundY
                
                local targetCFrame
                
                if heightAboveGround < GROUND_THRESHOLD then
                    local behindVector = -TargetRoot.CFrame.LookVector
                    local stealthPos = TargetRoot.Position + (behindVector * BEHIND_DISTANCE)
                    targetCFrame = CFrame.new(stealthPos.X, TargetRoot.Position.Y - UNDERGROUND_OFFSET, stealthPos.Z)
                else
                    targetCFrame = TargetRoot.CFrame
                end
                
                local lockConnection
                lockConnection = RunService.RenderStepped:Connect(function()
                    if TargetRoot and TargetRoot.Parent then
                        HRP.CFrame = targetCFrame
                    else
                        lockConnection:Disconnect()
                    end
                end)
                
                task.wait(0.5)
                
                local success = pcall(function()
                    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Cuffs"):InvokeServer(TargetCharacter, true)
                end)
                
                lockConnection:Disconnect()
                
                -- تحديد موقع الدروب
                local actualDropCFrame = dropCFrame
                if buttonName == "اسحبهم لعندك" then
                    -- استخدم إحداثياتي الأصلية المحفوظة
                    actualDropCFrame = playerOriginalPosition
                end
                
                if success then
                    HRP.CFrame = actualDropCFrame
                    task.wait(1.5)
                    
                    if Character:FindFirstChild(CUFFS_TOOL_NAME) then
                        Humanoid:UnequipTools()
                        task.wait(0.1)
                        Humanoid:EquipTool(CuffsTool)
                    end
                    
                    task.wait(0.5)
                end
            end
        end
        
        -- إكمال السكربت
        Running = false
    end)

    -- حفظ المهام
    if activeButton then
        table.insert(scriptThreads[activeButton], mainThread)
    end

    local stabilityConnection = RunService.RenderStepped:Connect(function()
        if Running then
            local actualDropCFrame = dropCFrame
            if buttonName == "اسحبهم لعندك" then
                actualDropCFrame = playerOriginalPosition
            end
            
            if actualDropCFrame and (HRP.Position - actualDropCFrame.Position).Magnitude < 20 then
                Humanoid.PlatformStand = true
                HRP.CFrame = actualDropCFrame
                HRP.Velocity = Vector3.new(0, 0, 0)
                HRP.RotVelocity = Vector3.new(0, 0, 0)
            else
                Humanoid.PlatformStand = false
            end
        end
    end)

    -- حفظ الروابط
    if activeButton then
        table.insert(scriptConnections[activeButton], stabilityConnection)
    end

    -- انتظار إنهاء السكربت
    repeat task.wait() until not Running
    
    -- تنظيف جميع الروابط
    fConnection:Disconnect()
    stabilityConnection:Disconnect()
    task.cancel(equipThread)
    task.cancel(mainThread)
    
    Humanoid.PlatformStand = false
    
    -- إرجاع الشخصية للموضع الأصلي حسب الإعدادات
    if settings.returnToOldPosition and buttonName == "اسحبهم لعندك" and playerOriginalPosition then
        HRP.CFrame = playerOriginalPosition
    end
    
    -- تحديث حالة الزر
    if activeButton then
        runningScripts[activeButton] = false
        
        -- إخفاء الدائرة الحمراء من الواجهة
        for _, frame in pairs(scrollingFrame:GetChildren()) do
            if frame:IsA("Frame") and frame:FindFirstChild("TextButton") then
                local btn = frame.TextButton
                if btn.Text == activeButton then
                    local indicatorCircle = frame:FindFirstChildOfClass("Frame")
                    if indicatorCircle then
                        indicatorCircle.BackgroundTransparency = 1
                    end
                    
                    -- إعادة لون الزر الأصلي
                    frame.BackgroundColor3 = COLORS.BUTTON_BASE
                    frame.BackgroundTransparency = 0.65
                    break
                end
            end
        end
        
        activeButton = nil
        playerOriginalPosition = nil
    end
end

for i, text in ipairs({"ارميهم في البحر", "احشرهم", "ارميهم في المكان السري", "غرقهم", "اسحبهم لعندك"}) do
    --// حالة الزر (غير مفعل في البداية)
    buttonStates[text] = false
    
    --// إطار الزر
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -10, 0, 50)
    buttonFrame.BackgroundColor3 = COLORS.BUTTON_BASE
    buttonFrame.BackgroundTransparency = 0.65
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = i
    buttonFrame.ZIndex = 13
    buttonFrame.Parent = scrollingFrame
    
    --// زر النص
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = COLORS.TEXT_WHITE
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.ZIndex = 14
    btn.Parent = buttonFrame
    
    --// الدائرة الحمراء
    local indicatorCircle = Instance.new("Frame")
    indicatorCircle.Size = UDim2.new(0, 12, 0, 12)
    indicatorCircle.Position = UDim2.new(1, -25, 0.5, -8)
    indicatorCircle.AnchorPoint = Vector2.new(1, 0.5)
    indicatorCircle.BackgroundColor3 = COLORS.RED
    indicatorCircle.BackgroundTransparency = 1
    indicatorCircle.BorderSizePixel = 0
    indicatorCircle.ZIndex = 15
    indicatorCircle.Parent = buttonFrame
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = indicatorCircle
    
    local fadeTween = nil
    
    btn.MouseEnter:Connect(function()
        if activeButton ~= text then
            buttonFrame.BackgroundTransparency = 0.45
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if activeButton ~= text then
            buttonFrame.BackgroundTransparency = 0.65
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        if activeButton ~= nil and activeButton ~= text then
            spawn(flashWarningText)
            return
        end
        
        buttonStates[text] = not buttonStates[text]
        
        if buttonStates[text] then
            activeButton = text
            
            buttonFrame.BackgroundColor3 = Color3.fromRGB(10, 80, 120)
            buttonFrame.BackgroundTransparency = 0.4
            
            indicatorCircle.BackgroundTransparency = 0.3
            fadeTween = createFadeAnimation(indicatorCircle)
            fadeTween:Play()
            
            runningScripts[text] = true
            
            if text == "ارميهم في البحر" or text == "احشرهم" or text == "ارميهم في المكان السري" then
                local config = buttonConfigs[text]
                if config and config.dropCFrame then
                    task.spawn(function()
                        startGeneralScript(config.dropCFrame, text)
                        runningScripts[text] = false
                    end)
                end
            elseif text == "اسحبهم لعندك" then
                task.spawn(function()
                    startGeneralScript(CFrame.new(0, 0, 0), text)
                    runningScripts[text] = false
                end)
            end
            
        else
            -- إيقاف السكربت النشط
            stopActiveScript(text)
            
            activeButton = nil
            
            buttonFrame.BackgroundColor3 = COLORS.BUTTON_BASE
            buttonFrame.BackgroundTransparency = 0.65
            
            if fadeTween then
                fadeTween:Cancel()
                fadeTween = nil
            end
            
            indicatorCircle.BackgroundTransparency = 1
        end
    end)
end

--// خط فاصل فوق النص
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -20, 0, 2)
separator.Position = UDim2.new(0, 10, 0, 330)
separator.BackgroundColor3 = COLORS.GLASS_2
separator.BackgroundTransparency = 0.7
separator.BorderSizePixel = 0
separator.ZIndex = 12
separator.Parent = contentFrame

--// نص الشرح
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -20, 0, 100)
warningLabel.Position = UDim2.new(0, 10, 0, 340)
warningLabel.Text = "اختر عملية وحدة بس.\nما تقدر تشغّل أكثر من عملية بنفس الوقت.\nلو حاب تشغّل عملية ثانية، لازم توقف العملية اللي شغالة أولًا."
warningLabel.TextColor3 = COLORS.TEXT_LIGHT
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextSize = 18
warningLabel.BackgroundTransparency = 1
warningLabel.TextXAlignment = Enum.TextXAlignment.Center
warningLabel.TextYAlignment = Enum.TextYAlignment.Top
warningLabel.TextWrapped = true
warningLabel.ZIndex = 12
warningLabel.Parent = contentFrame

--// Collapse Logic
local isCollapsed = true
local fullHeight = 500
local collapsedHeight = 40

local function toggleCollapse()
    isCollapsed = not isCollapsed
    local targetHeight = isCollapsed and collapsedHeight or fullHeight
    TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 220, 0, targetHeight)}):Play()
    contentFrame.Visible = not isCollapsed
    collapseButton.Text = isCollapsed and "+" or "−"
end

collapseButton.MouseButton1Click:Connect(toggleCollapse)

task.delay(0.5, toggleCollapse)

--// فتح/إغلاق نافذة الإعدادات
settingsButton.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

--// Drag كامل للواجهة
local dragging = false
local dragStart, startPos

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--// Drag لنافذة الإعدادات
local settingsDragging = false
local settingsDragStart, settingsStartPos

settingsHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        settingsDragging = true
        settingsDragStart = input.Position
        settingsStartPos = settingsFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if settingsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - settingsDragStart
        settingsFrame.Position = UDim2.new(settingsStartPos.X.Scale, settingsStartPos.X.Offset + delta.X, settingsStartPos.Y.Scale, settingsStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        settingsDragging = false
    end
end)
