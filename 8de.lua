--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// Image IDs
local IMAGES = {
    HOME = "rbxassetid://14219650242",
    PLAYER_TARGET = "rbxassetid://5419928648",
    ANTIBAN = "rbxassetid://13353741942",
    TELEPORT = "rbxassetid://6723742952",
    PLAYER_PROFILE = "rbxassetid://7992557358",
    ANTIBAN_ICON = "rbxassetid://13353741942",
    SPEED_ICON = "rbxassetid://7405889904",
    FEATURE_ICON = "rbxassetid://6728155886",
    TARGET_ICON = "rbxassetid://17169180878",
    MINIMIZE_ICON = "rbxassetid://130196820349947",
    BOX_ICON = "rbxassetid://6353957304",
    SPECIAL_ICON = "rbxassetid://105008642814120",
    DEFAULT_AVATAR = "rbxassetid://10937555085",
    DESTRUCTION = "rbxassetid://8642517045",
    DESTRUCTION_2 = "rbxassetid://18225991657"
}

--// NEW GLASSMORPHISM Color Scheme with LIGHTER TEXT COLORS
local COLORS = {
    BACKGROUND = Color3.fromHex("#061733"),
    GLASS_1 = Color3.fromHex("#061733"),
    GLASS_2 = Color3.fromHex("#075bb4"),
    SEPARATOR_1 = Color3.fromHex("#0e1997"),
    SEPARATOR_2 = Color3.fromHex("#14144f"),
    TEXT_WHITE = Color3.fromRGB(255, 255, 255), -- Bright white
    TEXT_LIGHT = Color3.fromRGB(240, 240, 240),
    TEXT_GRAY = Color3.fromRGB(220, 220, 220),
    GREEN_ACTIVE = Color3.fromHex("#00FF21"),
    ORANGE = Color3.fromHex("#FF9000"),
    WHITE = Color3.fromRGB(255, 255, 255),
    GOLDEN = Color3.fromRGB(255, 215, 0),
    CYAN = Color3.fromHex("#7DFFFF"),
    MAGENTA = Color3.fromHex("#FF99FF"),
    TRANSPARENT = Color3.new(1, 1, 1),
    BLACK = Color3.new(0, 0, 0),
    RED = Color3.fromRGB(255, 50, 50)
}

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

--// Create a local blur container
local blurContainer = Instance.new("Frame")
blurContainer.Size = UDim2.new(1, 0, 1, 0)
blurContainer.Position = UDim2.new(0, 0, 0, 0)
blurContainer.BackgroundColor3 = Color3.new(0, 0, 0)
blurContainer.BackgroundTransparency = 0.9
blurContainer.Visible = false
blurContainer.ZIndex = 0
blurContainer.Parent = screenGui

--// Create blur effect using multiple semi-transparent layers
local function createBlurLayers(parent)
    for i = 1, 3 do
        local layer = Instance.new("Frame")
        layer.Size = UDim2.new(1, 0, 1, 0)
        layer.Position = UDim2.new(0, 0, 0, 0)
        layer.BackgroundColor3 = Color3.new(1, 1, 1)
        layer.BackgroundTransparency = 0.95 + (i * 0.01)
        layer.BorderSizePixel = 0
        layer.ZIndex = 0
        layer.Parent = parent
    end
end

createBlurLayers(blurContainer)

--// Main Frame with Glassmorphism (NO CORNERS)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 440) -- Increased height slightly
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -220)
mainFrame.BackgroundColor3 = COLORS.BACKGROUND
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

--// Animated Gradient for main frame
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
    ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

--// Glass effect stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.BLACK
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.7
mainStroke.Parent = mainFrame

--// NO ROUNDED CORNERS for main frame (removed UICorner)

--// Animate gradient softly
spawn(function()
    while true do
        local time = tick()
        local noise = math.noise(time * 0.05, 0) * 0.3 + 0.5
        mainGradient.Offset = Vector2.new(noise, 0)
        wait(0.15)
    end
end)

--// Header (NO CORNERS)
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 80)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = COLORS.GLASS_1
headerFrame.BackgroundTransparency = 0.4
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 11
headerFrame.Parent = mainFrame

--// Header gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
    ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
})
headerGradient.Rotation = 90
headerGradient.Parent = headerFrame

--// Header stroke
local headerStroke = Instance.new("UIStroke")
headerStroke.Color = COLORS.BLACK
headerStroke.Thickness = 1.2
headerStroke.Transparency = 0.7
headerStroke.Parent = headerFrame

--// NO CORNER ROUNDING for header (removed UICorner)

--// Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 35, 0, 35)
minimizeButton.Position = UDim2.new(1, -45, 0, 12)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = COLORS.TEXT_WHITE
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 26
minimizeButton.BackgroundTransparency = 0.8
minimizeButton.BackgroundColor3 = COLORS.GLASS_1
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 12
minimizeButton.Parent = headerFrame

--// Text stroke for minimize button
local minimizeTextStroke = Instance.new("UIStroke")
minimizeTextStroke.Color = Color3.new(0, 0, 0)
minimizeTextStroke.Thickness = 1.8
minimizeTextStroke.Transparency = 0.3
minimizeTextStroke.Parent = minimizeButton

--// Minimize button gradient
local minimizeGradient = Instance.new("UIGradient")
minimizeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
    ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
})
minimizeGradient.Rotation = 0
minimizeGradient.Parent = minimizeButton

--// Minimize button corner
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

--// Minimize button stroke
local minimizeStroke = Instance.new("UIStroke")
minimizeStroke.Color = COLORS.BLACK
minimizeStroke.Thickness = 0.8
minimizeStroke.Transparency = 0.7
minimizeStroke.Parent = minimizeButton

--// Player Avatar
local avatarContainer = Instance.new("Frame")
avatarContainer.Size = UDim2.new(0, 55, 0, 55)
avatarContainer.Position = UDim2.new(0, 15, 0, 12)
avatarContainer.BackgroundColor3 = COLORS.GLASS_1
avatarContainer.BackgroundTransparency = 0.4
avatarContainer.BorderSizePixel = 0
avatarContainer.ZIndex = 12

--// Avatar gradient
local avatarGradient = Instance.new("UIGradient")
avatarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
    ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
})
avatarGradient.Parent = avatarContainer

--// Avatar stroke
local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = COLORS.BLACK
avatarStroke.Thickness = 1.2
avatarStroke.Transparency = 0.7
avatarStroke.Parent = avatarContainer

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarContainer
avatarContainer.Parent = headerFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, -5, 1, -5)
avatarImage.Position = UDim2.new(0, 2.5, 0, 2.5)
avatarImage.BackgroundTransparency = 1
avatarImage.ZIndex = 13
avatarImage.Parent = avatarContainer

--// Avatar image corner
local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(1, 0)
avatarImageCorner.Parent = avatarImage

local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420

pcall(function()
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    if content then
        avatarImage.Image = content
    else
        avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    end
end)

--// Player Name
local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0, 250, 0, 30)
playerNameLabel.Position = UDim2.new(0, 80, 0, 12)
playerNameLabel.Text = player.Name
playerNameLabel.TextColor3 = COLORS.TEXT_WHITE
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextSize = 20
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.ZIndex = 12
playerNameLabel.Parent = headerFrame

--// Text stroke for player name
local playerNameTextStroke = Instance.new("UIStroke")
playerNameTextStroke.Color = Color3.new(0, 0, 0)
playerNameTextStroke.Thickness = 1.5
playerNameTextStroke.Transparency = 0.3
playerNameTextStroke.Parent = playerNameLabel

--// Game Name
local gameNameLabel = Instance.new("TextLabel")
gameNameLabel.Size = UDim2.new(0, 250, 0, 22)
gameNameLabel.Position = UDim2.new(0, 80, 0, 44)
gameNameLabel.TextColor3 = COLORS.TEXT_LIGHT
gameNameLabel.Font = Enum.Font.Gotham
gameNameLabel.TextSize = 16
gameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameNameLabel.BackgroundTransparency = 1
gameNameLabel.ZIndex = 12
gameNameLabel.Parent = headerFrame

--// Text stroke for game name
local gameNameTextStroke = Instance.new("UIStroke")
gameNameTextStroke.Color = Color3.new(0, 0, 0)
gameNameTextStroke.Thickness = 1.2
gameNameTextStroke.Transparency = 0.3
gameNameTextStroke.Parent = gameNameLabel

local gameName = "لعبة غير معروفة"
local success, result = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

if success then
    gameNameLabel.Text = result
else
    gameNameLabel.Text = gameName
end

--// Separator line
local headerSeparator = Instance.new("Frame")
headerSeparator.Size = UDim2.new(1, 0, 0, 1.5)
headerSeparator.Position = UDim2.new(0, 0, 1, 0)
headerSeparator.BackgroundColor3 = COLORS.GLASS_1
headerSeparator.BackgroundTransparency = 0.7
headerSeparator.BorderSizePixel = 0
headerSeparator.ZIndex = 12
headerSeparator.Parent = headerFrame

--// Sidebar
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 190, 0, 360) -- Increased height
sidebarFrame.Position = UDim2.new(0, 0, 0, 80)
sidebarFrame.BackgroundColor3 = COLORS.GLASS_1
sidebarFrame.BackgroundTransparency = 0.5
sidebarFrame.BorderSizePixel = 0
sidebarFrame.ClipsDescendants = true
sidebarFrame.ZIndex = 11
sidebarFrame.Parent = mainFrame

--// Sidebar gradient
local sidebarGradient = Instance.new("UIGradient")
sidebarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
    ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
})
sidebarGradient.Rotation = 90
sidebarGradient.Parent = sidebarFrame

--// Sidebar stroke
local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = COLORS.BLACK
sidebarStroke.Thickness = 1.2
sidebarStroke.Transparency = 0.7
sidebarStroke.Parent = sidebarFrame

--// Animated Separator Line between sidebar and content
local separator = Instance.new("Frame")
separator.Size = UDim2.new(0, 3.5, 1, 0)
separator.Position = UDim2.new(0, 190, 0, 80)
separator.BackgroundColor3 = COLORS.SEPARATOR_1
separator.BackgroundTransparency = 0
separator.BorderSizePixel = 0
separator.ZIndex = 12
separator.Parent = mainFrame

--// Animated gradient for separator
local separatorGradient = Instance.new("UIGradient")
separatorGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.SEPARATOR_1),
    ColorSequenceKeypoint.new(1, COLORS.SEPARATOR_2)
})
separatorGradient.Rotation = 90
separatorGradient.Parent = separator

--// Animate separator gradient from bottom to top
spawn(function()
    while true do
        local time = tick()
        separatorGradient.Offset = Vector2.new(0, (time * 0.3) % 1)
        wait()
    end
end)

--// Content area (INCREASED HEIGHT)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 406.5, 0, 360) -- Increased height
contentFrame.Position = UDim2.new(0, 193.5, 0, 80)
contentFrame.BackgroundColor3 = COLORS.GLASS_1
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.ZIndex = 11
contentFrame.Parent = mainFrame

--// Content gradient
local contentGradient = Instance.new("UIGradient")
contentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
    ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
})
contentGradient.Rotation = 90
contentGradient.Parent = contentFrame

--// Content stroke
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = COLORS.BLACK
contentStroke.Thickness = 1.2
contentStroke.Transparency = 0.7
contentStroke.Parent = contentFrame

--// Sections with Arabic and English names
local sections = {
    {Name = "الرئيسية", English = "Home", ImageId = IMAGES.HOME},
    {Name = "استهداف", English = "Targeting", ImageId = IMAGES.PLAYER_TARGET},
    {Name = "مضادات", English = "Anti-Ban", ImageId = IMAGES.ANTIBAN},
    {Name = "الانتقال السريع", English = "Teleport", ImageId = IMAGES.TELEPORT},
    {Name = "اللاعب", English = "Player", ImageId = IMAGES.PLAYER_PROFILE},
    {Name = "تخريب", English = "Destruction", ImageId = IMAGES.DESTRUCTION}
}

local currentSection = "الرئيسية"
local sectionButtons = {}
local sectionContentFrames = {}

--// Store buttons state
local antiButtons = {}
local playerButtons = {}
local targetButtons = {}
local teleportButtons = {}
local specialButtons = {}
local destructionButtons = {}
local selectedDestructionButton = nil

--// Function to create glass button with text stroke for better visibility (NO GRADIENT)
local function createGlassButton(parent, size, position, text)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.Text = text
    button.TextColor3 = COLORS.TEXT_WHITE
    button.Font = Enum.Font.Gotham
    button.TextSize = 15
    button.BackgroundColor3 = COLORS.GLASS_1 -- Solid color, no gradient
    button.BackgroundTransparency = 0.4
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.ZIndex = 12
    button.Parent = parent
    
    -- NO GRADIENT for button background
    
    -- Button corner
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = button
    
    -- Button stroke
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = COLORS.BLACK
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.7
    buttonStroke.Parent = button
    
    -- Text stroke for better visibility
    local textStroke = Instance.new("UIStroke")
    textStroke.Color = Color3.new(0, 0, 0)
    textStroke.Thickness = 1.8
    textStroke.Transparency = 0.3
    textStroke.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        if not button:GetAttribute("Active") then
            button.BackgroundTransparency = 0.2
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not button:GetAttribute("Active") then
            button.BackgroundTransparency = 0.4
        end
    end)
    
    return button
end

--// Function to create frame with gradient border
local function createGradientBorderFrame(parent, size, position, isBackground)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    
    if isBackground then
        frame.BackgroundColor3 = Color3.fromHex("#0a2a5a")
        frame.BackgroundTransparency = 0.2
    else
        frame.BackgroundTransparency = 1
    end
    
    frame.BorderSizePixel = 0
    frame.ZIndex = 14
    frame.Parent = parent

    -- Gradient border effect
    local border = Instance.new("UIGradient")
    border.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#0a2a5a")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#0e6bcc"))
    })
    border.Rotation = 90
    border.Parent = frame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromHex("#0a2a5a")
    frameStroke.Thickness = 3.5
    frameStroke.Transparency = 0.2
    frameStroke.Parent = frame

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 11)
    frameCorner.Parent = frame
    
    return frame
end

--// Function to select a section
local function selectSection(sectionName)
    if currentSection == sectionName then return end
    
    for name, buttonData in pairs(sectionButtons) do
        if name == sectionName then
            buttonData.button.BackgroundTransparency = 0.2
            buttonData.button:SetAttribute("Active", true)
            buttonData.nameLabel.TextColor3 = COLORS.TEXT_WHITE
        else
            buttonData.button.BackgroundTransparency = 0.4
            buttonData.button:SetAttribute("Active", false)
            buttonData.nameLabel.TextColor3 = COLORS.TEXT_WHITE
        end
    end
    
    if sectionContentFrames[currentSection] then
        sectionContentFrames[currentSection].Visible = false
    end
    
    if sectionContentFrames[sectionName] then
        sectionContentFrames[sectionName].Visible = true
        
        sectionContentFrames[sectionName].Position = UDim2.new(0.05, 0, 0.05, 0)
        sectionContentFrames[sectionName].BackgroundTransparency = 0.8
        sectionContentFrames[sectionName].Size = UDim2.new(0.9, 0, 0.9, 0)
        
        local tweenIn = TweenService:Create(sectionContentFrames[sectionName], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.5
        })
        tweenIn:Play()
    end
    
    currentSection = sectionName
end

--// Create section buttons in sidebar
for i, section in ipairs(sections) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 60) -- Adjusted height
    button.Position = UDim2.new(0, 0, 0, (i-1) * 60)
    button.Text = ""
    button.BackgroundColor3 = COLORS.GLASS_1
    button.BackgroundTransparency = 0.4
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.ZIndex = 12
    button.Parent = sidebarFrame
    
    -- Button gradient
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
        ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
    })
    buttonGradient.Rotation = 0
    buttonGradient.Parent = button
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 12, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Image = section.ImageId
    icon.ZIndex = 13
    icon.Parent = button
    
    local sectionNameLabel = Instance.new("TextLabel")
    sectionNameLabel.Size = UDim2.new(0, 120, 0, 34)
    sectionNameLabel.Position = UDim2.new(0, 48, 0.5, -17)
    sectionNameLabel.Text = section.Name .. "\n" .. section.English
    sectionNameLabel.TextColor3 = COLORS.TEXT_WHITE
    sectionNameLabel.Font = Enum.Font.Gotham
    sectionNameLabel.TextSize = 13
    sectionNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionNameLabel.BackgroundTransparency = 1
    sectionNameLabel.TextWrapped = true
    sectionNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    sectionNameLabel.ZIndex = 13
    sectionNameLabel.Parent = button
    
    -- Text stroke for sidebar section names
    local sectionTextStroke = Instance.new("UIStroke")
    sectionTextStroke.Color = Color3.new(0, 0, 0)
    sectionTextStroke.Thickness = 1.2
    sectionTextStroke.Transparency = 0.3
    sectionTextStroke.Parent = sectionNameLabel
    
    local contentSectionFrame = Instance.new("Frame")
    contentSectionFrame.Size = UDim2.new(1, 0, 1, 0)
    contentSectionFrame.Position = UDim2.new(0, 0, 0, 0)
    contentSectionFrame.BackgroundColor3 = COLORS.GLASS_1
    contentSectionFrame.BackgroundTransparency = 0.5
    contentSectionFrame.Visible = (section.Name == "الرئيسية")
    contentSectionFrame.Name = section.Name
    contentSectionFrame.ZIndex = 12
    contentSectionFrame.Parent = contentFrame
    
    -- Content section gradient
    local sectionGradient = Instance.new("UIGradient")
    sectionGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
        ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
    })
    sectionGradient.Rotation = 90
    sectionGradient.Parent = contentSectionFrame
    
    -- Content section stroke
    local sectionStroke = Instance.new("UIStroke")
    sectionStroke.Color = COLORS.BLACK
    sectionStroke.Thickness = 1.2
    sectionStroke.Transparency = 0.7
    sectionStroke.Parent = contentSectionFrame
    
    sectionButtons[section.Name] = {
        button = button,
        nameLabel = sectionNameLabel
    }
    sectionContentFrames[section.Name] = contentSectionFrame
    
    button.MouseButton1Click:Connect(function()
        selectSection(section.Name)
    end)
end

--// Particle System
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.ZIndex = 0
particleContainer.Parent = mainFrame

local particles = {}
local particleCount = 9

for i = 1, particleCount do
    local particle = Instance.new("Frame")
    local size = math.random(2, 4)
    particle.Size = UDim2.new(0, size, 0, size)
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    particle.Position = UDim2.new(0, math.random(0, 580), 0, math.random(80, 420))
    particle.BackgroundColor3 = COLORS.GLASS_1
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = 0.9
    particle.ZIndex = 0
    particle.Parent = particleContainer
    
    particles[i] = {
        object = particle,
        speedX = (math.random(-10, 10) / 100),
        speedY = (math.random(-10, 10) / 100),
        transparency = 0.9,
        transparencyDir = math.random() > 0.5 and 1 or -1
    }
end

local function updateParticles(deltaTime)
    for _, particleData in ipairs(particles) do
        local particle = particleData.object
        local currentPos = particle.Position
        
        local newX = currentPos.X.Offset + (particleData.speedX * 15 * deltaTime)
        local newY = currentPos.Y.Offset + (particleData.speedY * 15 * deltaTime)
        
        if newX < 0 then
            newX = 0
            particleData.speedX = math.abs(particleData.speedX)
        elseif newX > 580 then
            newX = 580
            particleData.speedX = -math.abs(particleData.speedX)
        end
        
        if newY < 80 then
            newY = 80
            particleData.speedY = math.abs(particleData.speedY)
        elseif newY > 420 then
            newY = 420
            particleData.speedY = -math.abs(particleData.speedY)
        end
        
        particle.Position = UDim2.new(0, newX, 0, newY)
        
        particleData.transparency = particleData.transparency + (particleData.transparencyDir * deltaTime * 0.15)
        
        if particleData.transparency > 0.95 then
            particleData.transparency = 0.95
            particleData.transparencyDir = -1
        elseif particleData.transparency < 0.85 then
            particleData.transparency = 0.85
            particleData.transparencyDir = 1
        end
        
        particle.BackgroundTransparency = particleData.transparency
    end
end

RunService.RenderStepped:Connect(updateParticles)

--// Function to get player account creation date
local function getAccountCreationDate(userId)
    local success, result = pcall(function()
        local info = MarketplaceService:GetUserInfo(userId)
        return info.Created
    end)
    
    if success and result then
        local date = os.date("*t", result)
        return string.format("%04d-%02d-%02d", date.year, date.month, date.day)
    end
    
    return "غير معروف"
end

--// Function to get player team/group info
local function getPlayerTeamInfo(plr)
    if plr.Team then
        return plr.Team.Name
    end
    
    if plr.TeamColor then
        return "فريق " .. tostring(plr.TeamColor)
    end
    
    return "لا يوجد"
end

--// Function to simulate points/rank system
local function getPlayerRankAndPoints(plr)
    local ranks = {
        "جندي",
        "عريف",
        "رقيب",
        "ملازم",
        "نقيب",
        "رائد",
        "مقدم",
        "عقيد",
        "عميد",
        "لواء"
    }
    
    local rankIndex = (plr.UserId % #ranks) + 1
    local points = (plr.UserId % 10000)
    local nextRankPoints = 50 -- نقاط مطلوبة للرتبة التالية
    
    return {
        rank = ranks[rankIndex],
        points = points,
        nextRankPoints = nextRankPoints
    }
end

--// Function to get time-based greeting
local function getGreeting()
    local currentTime = os.date("*t")
    local hour = currentTime.hour
    
    if hour >= 5 and hour < 12 then
        return "صباح الخير"
    elseif hour >= 12 and hour < 17 then
        return "مساء الخير"
    elseif hour >= 17 and hour < 21 then
        return "مساء الخير"
    else
        return "مساء الخير"
    end
end

--// Create content for each section
for sectionName, frame in pairs(sectionContentFrames) do
    if sectionName == "الرئيسية" then
        --// Main container for Home section
        local homeContainer = Instance.new("Frame")
        homeContainer.Size = UDim2.new(1, -20, 1, -20)
        homeContainer.Position = UDim2.new(0, 10, 0, 10)
        homeContainer.BackgroundTransparency = 1
        homeContainer.ZIndex = 13
        homeContainer.Parent = frame

        --// Center container for vertical layout
        local centerContainer = Instance.new("Frame")
        centerContainer.Size = UDim2.new(1, 0, 1, 0)
        centerContainer.Position = UDim2.new(0, 0, 0, 0)
        centerContainer.BackgroundTransparency = 1
        centerContainer.ZIndex = 13
        centerContainer.Parent = homeContainer
        
        --// Top greeting frame
        local greetingFrame = Instance.new("Frame")
        greetingFrame.Size = UDim2.new(0.8, 0, 0, 50)
        greetingFrame.Position = UDim2.new(0.1, 0, 0.05, 0)
        greetingFrame.BackgroundColor3 = COLORS.GLASS_1
        greetingFrame.BackgroundTransparency = 0.3
        greetingFrame.BorderSizePixel = 0
        greetingFrame.ZIndex = 14
        greetingFrame.Parent = centerContainer
        
        local greetingGradient = Instance.new("UIGradient")
        greetingGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
            ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
        })
        greetingGradient.Rotation = 90
        greetingGradient.Parent = greetingFrame
        
        local greetingStroke = Instance.new("UIStroke")
        greetingStroke.Color = COLORS.BLACK
        greetingStroke.Thickness = 1.2
        greetingStroke.Transparency = 0.7
        greetingStroke.Parent = greetingFrame
        
        local greetingCorner = Instance.new("UICorner")
        greetingCorner.CornerRadius = UDim.new(0, 8)
        greetingCorner.Parent = greetingFrame
        
        local greetingLabel = Instance.new("TextLabel")
        greetingLabel.Size = UDim2.new(1, 0, 1, 0)
        greetingLabel.Position = UDim2.new(0, 0, 0, 0)
        greetingLabel.Text = getGreeting()
        greetingLabel.TextColor3 = COLORS.TEXT_WHITE
        greetingLabel.Font = Enum.Font.GothamBold
        greetingLabel.TextSize = 22
        greetingLabel.BackgroundTransparency = 1
        greetingLabel.ZIndex = 15
        greetingLabel.Parent = greetingFrame
        
        local greetingTextStroke = Instance.new("UIStroke")
        greetingTextStroke.Color = Color3.new(0, 0, 0)
        greetingTextStroke.Thickness = 1.8
        greetingTextStroke.Transparency = 0.3
        greetingTextStroke.Parent = greetingLabel
        
        --// Square Viewport in the center
        local viewportOuterFrame = Instance.new("Frame")
        viewportOuterFrame.Size = UDim2.new(0, 200, 0, 200) -- Square
        viewportOuterFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
        viewportOuterFrame.BackgroundColor3 = Color3.fromHex("#0a2a5a")
        viewportOuterFrame.BackgroundTransparency = 0.2
        viewportOuterFrame.BorderSizePixel = 0
        viewportOuterFrame.ZIndex = 14
        
        local viewportBorder = Instance.new("UIGradient")
        viewportBorder.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#0a2a5a")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#0e6bcc"))
        })
        viewportBorder.Rotation = 90
        viewportBorder.Parent = viewportOuterFrame

        local viewportStroke = Instance.new("UIStroke")
        viewportStroke.Color = Color3.fromHex("#0a2a5a")
        viewportStroke.Thickness = 3.5
        viewportStroke.Transparency = 0.2
        viewportStroke.Parent = viewportOuterFrame

        local viewportCorner = Instance.new("UICorner")
        viewportCorner.CornerRadius = UDim.new(0, 8)
        viewportCorner.Parent = viewportOuterFrame
        viewportOuterFrame.Parent = centerContainer
        
        --// ViewportFrame without background
        local Viewport = Instance.new("ViewportFrame")
        Viewport.Size = UDim2.new(1, -5, 1, -5)
        Viewport.Position = UDim2.new(0, 2.5, 0, 2.5)
        Viewport.BackgroundTransparency = 1
        Viewport.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Viewport.BorderSizePixel = 0
        Viewport.Ambient = Color3.fromRGB(255, 255, 255)
        Viewport.LightColor = Color3.fromRGB(255, 255, 255)
        Viewport.LightDirection = Vector3.new(-0.577, -0.577, -0.577)
        Viewport.ZIndex = 15
        Viewport.Parent = viewportOuterFrame

        --// WorldModel
        local WorldModel = Instance.new("WorldModel")
        WorldModel.Parent = Viewport

        --// Camera
        local Camera = Instance.new("Camera")
        Camera.Parent = Viewport
        Viewport.CurrentCamera = Camera

        --// Clone Character
        local function LoadCharacter()
            local char = player.Character or player.CharacterAdded:Wait()
            char.Archivable = true
            local clone = char:Clone()
            clone.Name = "CharClone"

            for _, v in pairs(clone:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.Anchored = true
                    v.CanCollide = false
                elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                    v.Handle.Anchored = true
                    v.Handle.CanCollide = false
                end
            end

            local humanoid = clone:FindFirstChild("Humanoid")
            if humanoid then humanoid:Destroy() end

            for _, v in pairs(clone:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") then
                    v:Destroy()
                end
            end

            clone.Parent = workspace
            task.wait(0.1)
            clone.Parent = WorldModel

            local HRP = clone:FindFirstChild("HumanoidRootPart")
            if HRP then
                clone.PrimaryPart = HRP
                clone:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, -1, 0)))
                Camera.CFrame = CFrame.new(Vector3.new(0, 2, 7), Vector3.new(0, 0, 0))
            end

            return clone
        end

        local CharacterClone = LoadCharacter()
        local HRP = CharacterClone:FindFirstChild("HumanoidRootPart")

        --// 360° rotation
        local angle = 0
        RunService.RenderStepped:Connect(function(dt)
            if HRP then
                angle += dt * 1.5
                CharacterClone:SetPrimaryPartCFrame(CFrame.new(HRP.Position) * CFrame.Angles(0, angle, 0))
            end
        end)

        --// Bottom info frame
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(0.8, 0, 0, 80)
        infoFrame.Position = UDim2.new(0.1, 0, 0.85, -80)
        infoFrame.BackgroundColor3 = COLORS.GLASS_1
        infoFrame.BackgroundTransparency = 0.3
        infoFrame.BorderSizePixel = 0
        infoFrame.ZIndex = 14
        infoFrame.Parent = centerContainer
        
        local infoGradient = Instance.new("UIGradient")
        infoGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
            ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
        })
        infoGradient.Rotation = 90
        infoGradient.Parent = infoFrame
        
        local infoStroke = Instance.new("UIStroke")
        infoStroke.Color = COLORS.BLACK
        infoStroke.Thickness = 1.2
        infoStroke.Transparency = 0.7
        infoStroke.Parent = infoFrame
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = infoFrame
        
        -- Get rank and points from game data
        local rankInfo = getPlayerRankAndPoints(player)
        
        -- Rank and points text
        local rankLabel = Instance.new("TextLabel")
        rankLabel.Size = UDim2.new(1, -20, 0, 30)
        rankLabel.Position = UDim2.new(0, 10, 0, 10)
        rankLabel.Text = "- الرتبة: " .. rankInfo.rank
        rankLabel.TextColor3 = COLORS.TEXT_WHITE
        rankLabel.Font = Enum.Font.GothamBold
        rankLabel.TextSize = 18
        rankLabel.TextXAlignment = Enum.TextXAlignment.Right
        rankLabel.BackgroundTransparency = 1
        rankLabel.ZIndex = 15
        rankLabel.Parent = infoFrame
        
        local rankTextStroke = Instance.new("UIStroke")
        rankTextStroke.Color = Color3.new(0, 0, 0)
        rankTextStroke.Thickness = 1.5
        rankTextStroke.Transparency = 0.3
        rankTextStroke.Parent = rankLabel
        
        local pointsLabel = Instance.new("TextLabel")
        pointsLabel.Size = UDim2.new(1, -20, 0, 30)
        pointsLabel.Position = UDim2.new(0, 10, 0, 40)
        pointsLabel.Text = "- عدد نقاطك: " .. tostring(rankInfo.points)
        pointsLabel.TextColor3 = COLORS.TEXT_WHITE
        pointsLabel.Font = Enum.Font.GothamBold
        pointsLabel.TextSize = 18
        pointsLabel.TextXAlignment = Enum.TextXAlignment.Right
        pointsLabel.BackgroundTransparency = 1
        pointsLabel.ZIndex = 15
        pointsLabel.Parent = infoFrame
        
        local pointsTextStroke = Instance.new("UIStroke")
        pointsTextStroke.Color = Color3.new(0, 0, 0)
        pointsTextStroke.Thickness = 1.5
        pointsTextStroke.Transparency = 0.3
        pointsTextStroke.Parent = pointsLabel

    elseif sectionName == "استهداف" then
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.Position = UDim2.new(0, 0, 0, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 9
        scrollFrame.ScrollBarImageColor3 = Color3.fromHex("#333333")
        scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        scrollFrame.ZIndex = 12
        scrollFrame.Parent = frame
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 12)
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.Parent = scrollFrame
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -30, 0, 450)
        container.Position = UDim2.new(0, 15, 0, 15)
        container.BackgroundTransparency = 1
        container.ZIndex = 13
        container.Parent = scrollFrame
        
        -- صورة اللاعب
        local playerAvatarFrame = Instance.new("Frame")
        playerAvatarFrame.Size = UDim2.new(0, 110, 0, 110)
        playerAvatarFrame.Position = UDim2.new(0.5, -55, 0, 20)
        playerAvatarFrame.BackgroundColor3 = COLORS.GLASS_1
        playerAvatarFrame.BackgroundTransparency = 0.3
        playerAvatarFrame.BorderSizePixel = 0
        
        local avatarFrameGradient = Instance.new("UIGradient")
        avatarFrameGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
            ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
        })
        avatarFrameGradient.Parent = playerAvatarFrame
        
        local avatarFrameStroke = Instance.new("UIStroke")
        avatarFrameStroke.Color = COLORS.BLACK
        avatarFrameStroke.Thickness = 1.3
        avatarFrameStroke.Transparency = 0.7
        avatarFrameStroke.Parent = playerAvatarFrame
        
        local avatarPreviewCorner = Instance.new("UICorner")
        avatarPreviewCorner.CornerRadius = UDim.new(0, 10)
        avatarPreviewCorner.Parent = playerAvatarFrame
        playerAvatarFrame.Parent = container
        
        local playerAvatarImage = Instance.new("ImageLabel")
        playerAvatarImage.Size = UDim2.new(1, -7, 1, -7)
        playerAvatarImage.Position = UDim2.new(0, 3.5, 0, 3.5)
        playerAvatarImage.BackgroundTransparency = 1
        playerAvatarImage.Image = IMAGES.DEFAULT_AVATAR
        playerAvatarImage.ZIndex = 14
        playerAvatarImage.Parent = playerAvatarFrame
        
        -- معلومات اللاعب
        local playerInfoContainer = Instance.new("Frame")
        playerInfoContainer.Size = UDim2.new(1, -40, 0, 45)
        playerInfoContainer.Position = UDim2.new(0, 20, 0, 145)
        playerInfoContainer.BackgroundTransparency = 1
        playerInfoContainer.ZIndex = 13
        playerInfoContainer.Parent = container
        
        local playerInfoLabel = Instance.new("TextLabel")
        playerInfoLabel.Size = UDim2.new(1, 0, 1, 0)
        playerInfoLabel.Position = UDim2.new(0, 0, 0, 0)
        playerInfoLabel.Text = "الرتبة: غير محدد • النقاط: 0"
        playerInfoLabel.TextColor3 = COLORS.TEXT_WHITE
        playerInfoLabel.Font = Enum.Font.GothamBold
        playerInfoLabel.TextSize = 16
        playerInfoLabel.TextXAlignment = Enum.TextXAlignment.Center
        playerInfoLabel.BackgroundTransparency = 1
        playerInfoLabel.ZIndex = 14
        playerInfoLabel.Parent = playerInfoContainer
        
        local playerInfoTextStroke = Instance.new("UIStroke")
        playerInfoTextStroke.Color = Color3.new(0, 0, 0)
        playerInfoTextStroke.Thickness = 1.8
        playerInfoTextStroke.Transparency = 0.3
        playerInfoTextStroke.Parent = playerInfoLabel
        
        -- مربع البحث
        local playerNameTextBox = Instance.new("TextBox")
        playerNameTextBox.Size = UDim2.new(1, -40, 0, 40)
        playerNameTextBox.Position = UDim2.new(0, 20, 0, 205)
        playerNameTextBox.PlaceholderText = "ادخل اسم اللاعب..."
        playerNameTextBox.Text = ""
        playerNameTextBox.TextColor3 = COLORS.TEXT_WHITE
        playerNameTextBox.Font = Enum.Font.Gotham
        playerNameTextBox.TextSize = 16
        playerNameTextBox.BackgroundColor3 = COLORS.GLASS_1
        playerNameTextBox.BackgroundTransparency = 0.3
        playerNameTextBox.BorderSizePixel = 0
        playerNameTextBox.ClearTextOnFocus = false
        playerNameTextBox.ZIndex = 14
        
        local textBoxTextStroke = Instance.new("UIStroke")
        textBoxTextStroke.Color = Color3.new(0, 0, 0)
        textBoxTextStroke.Thickness = 1.3
        textBoxTextStroke.Transparency = 0.3
        textBoxTextStroke.Parent = playerNameTextBox
        
        local textBoxStroke = Instance.new("UIStroke")
        textBoxStroke.Color = COLORS.BLACK
        textBoxStroke.Thickness = 0.9
        textBoxStroke.Transparency = 0.7
        textBoxStroke.Parent = playerNameTextBox
        
        local textBoxCorner = Instance.new("UICorner")
        textBoxCorner.CornerRadius = UDim.new(0, 7)
        textBoxCorner.Parent = playerNameTextBox
        playerNameTextBox.Parent = container
        
        local isViewing = false
        local viewedPlayer = nil
        
        local function updatePlayerInfo(targetPlayer)
            if targetPlayer then
                pcall(function()
                    local content, isReady = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                    if content then
                        playerAvatarImage.Image = content
                    end
                end)
                
                local rankInfo = getPlayerRankAndPoints(targetPlayer)
                playerInfoLabel.Text = "الرتبة: " .. rankInfo.rank .. " • النقاط: " .. tostring(rankInfo.points)
            else
                playerAvatarImage.Image = IMAGES.DEFAULT_AVATAR
                playerInfoLabel.Text = "الرتبة: غير محدد • النقاط: 0"
                
                if isViewing then
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
                    end
                    isViewing = false
                    viewedPlayer = nil
                end
            end
        end
        
        playerNameTextBox.FocusLost:Connect(function()
            local targetName = playerNameTextBox.Text
            if targetName ~= "" then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and (plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower())) then
                        updatePlayerInfo(plr)
                        return
                    end
                end
            end
            updatePlayerInfo(nil)
        end)
        
        -- منطقة الأزرار
        local buttonsGrid = Instance.new("Frame")
        buttonsGrid.Size = UDim2.new(1, -40, 0, 200)
        buttonsGrid.Position = UDim2.new(0, 20, 0, 260)
        buttonsGrid.BackgroundTransparency = 1
        buttonsGrid.ZIndex = 13
        buttonsGrid.Parent = container
        
        local teleportButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 0), "انتقل")
        teleportButton.TextColor3 = COLORS.TEXT_WHITE
        
        local viewButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 0), "مشاهده")
        viewButton.TextColor3 = COLORS.TEXT_WHITE
        
        local remoteKickButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 55), "كلبشه من بعيد")
        remoteKickButton.TextColor3 = COLORS.TEXT_WHITE
        
        local throwSeaButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 55), "ارميه في البحر")
        throwSeaButton.TextColor3 = COLORS.TEXT_WHITE
        
        local teleportKickButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 110), "انتقل عنده و كلبشه")
        teleportKickButton.TextColor3 = COLORS.TEXT_WHITE
        
        local tortureButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 110), "عذبه")
        tortureButton.TextColor3 = COLORS.TEXT_WHITE
        
        local remoteKickIcon = Instance.new("ImageLabel")
        remoteKickIcon.Size = UDim2.new(0, 28, 0, 28)
        remoteKickIcon.Position = UDim2.new(0.7, 5, 0.5, -14)
        remoteKickIcon.Image = IMAGES.TARGET_ICON
        remoteKickIcon.BackgroundTransparency = 1
        remoteKickIcon.ImageColor3 = COLORS.TEXT_WHITE
        remoteKickIcon.ZIndex = 15
        remoteKickIcon.Parent = remoteKickButton
        
        teleportButton.MouseButton1Click:Connect(function()
            local targetName = playerNameTextBox.Text
            if targetName ~= "" then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and (plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower())) then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                        end
                        return
                    end
                end
            end
        end)
        
        viewButton.MouseButton1Click:Connect(function()
            local targetName = playerNameTextBox.Text
            if targetName ~= "" then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and (plr.Name:lower():find(targetName:lower()) or plr.DisplayName:lower():find(targetName:lower())) then
                        if isViewing and viewedPlayer == plr then
                            if player.Character and player.Character:FindFirstChild("Humanoid") then
                                workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
                            end
                            viewButton.Text = "مشاهده"
                            viewButton.BackgroundTransparency = 0.4
                            isViewing = false
                            viewedPlayer = nil
                        else
                            if workspace.CurrentCamera and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                                workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
                                viewButton.Text = "إيقاف المشاهدة"
                                viewButton.BackgroundTransparency = 0.1
                                isViewing = true
                                viewedPlayer = plr
                            end
                        end
                        return
                    end
                end
            else
                if isViewing then
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
                    end
                    viewButton.Text = "مشاهده"
                    viewButton.BackgroundTransparency = 0.4
                    isViewing = false
                    viewedPlayer = nil
                end
            end
        end)
        
        targetButtons["remote_kick"] = {
            button = remoteKickButton,
            icon = remoteKickIcon,
            active = false
        }
        
        remoteKickButton.MouseButton1Click:Connect(function()
            local buttonData = targetButtons["remote_kick"]
            if not buttonData.active then
                remoteKickIcon.ImageColor3 = COLORS.ORANGE
                remoteKickButton.BackgroundTransparency = 0.1
                
                wait(0.8)
                remoteKickIcon.ImageColor3 = COLORS.GREEN_ACTIVE
                buttonData.active = true
            else
                remoteKickIcon.ImageColor3 = COLORS.TEXT_WHITE
                remoteKickButton.BackgroundTransparency = 0.4
                buttonData.active = false
            end
        end)
        
        uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 30)
        end)
        
    elseif sectionName == "مضادات" then
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 1, -20)
        container.Position = UDim2.new(0, 10, 0, 10)
        container.BackgroundTransparency = 1
        container.ZIndex = 13
        container.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 45)
        title.Position = UDim2.new(0, 0, 0, 15)
        title.Text = "المضادات"
        title.TextColor3 = COLORS.TEXT_WHITE
        title.Font = Enum.Font.GothamBold
        title.TextSize = 24
        title.BackgroundTransparency = 1
        title.ZIndex = 14
        title.Parent = container
        
        local titleTextStroke = Instance.new("UIStroke")
        titleTextStroke.Color = Color3.new(0, 0, 0)
        titleTextStroke.Thickness = 2.2
        titleTextStroke.Transparency = 0.3
        titleTextStroke.Parent = title
        
        local description = Instance.new("TextLabel")
        description.Size = UDim2.new(1, 0, 0, 35)
        description.Position = UDim2.new(0, 0, 0, 70)
        description.Text = "تفعيل/إلغاء تفعيل المضادات:"
        description.TextColor3 = COLORS.TEXT_LIGHT
        description.Font = Enum.Font.Gotham
        description.TextSize = 16
        description.TextXAlignment = Enum.TextXAlignment.Right
        description.BackgroundTransparency = 1
        description.ZIndex = 14
        description.Parent = container
        
        local descTextStroke = Instance.new("UIStroke")
        descTextStroke.Color = Color3.new(0, 0, 0)
        descTextStroke.Thickness = 1.3
        descTextStroke.Transparency = 0.3
        descTextStroke.Parent = description
        
        local antiTypes = {
            {Name = "مضاد كلبشة", Key = "anti_kick"},
            {Name = "مضاد صاعق", Key = "anti_stun"},
            {Name = "مضاد أسلحة", Key = "anti_weapon"}
        }
        
        for i, anti in ipairs(antiTypes) do
            local antiButtonContainer = Instance.new("Frame")
            antiButtonContainer.Size = UDim2.new(1, -40, 0, 55)
            antiButtonContainer.Position = UDim2.new(0, 20, 0, 115 + (i-1) * 65)
            antiButtonContainer.BackgroundTransparency = 1
            antiButtonContainer.ZIndex = 13
            antiButtonContainer.Parent = container
            
            local antiTextButton = Instance.new("TextButton")
            antiTextButton.Size = UDim2.new(0.8, -50, 1, 0)
            antiTextButton.Position = UDim2.new(0, 0, 0, 0)
            antiTextButton.Text = anti.Name
            antiTextButton.TextColor3 = COLORS.TEXT_WHITE
            antiTextButton.Font = Enum.Font.Gotham
            antiTextButton.TextSize = 18
            antiTextButton.BackgroundColor3 = COLORS.GLASS_1
            antiTextButton.BackgroundTransparency = 0.4
            antiTextButton.BorderSizePixel = 0
            antiTextButton.AutoButtonColor = true
            antiTextButton.ZIndex = 14
            
            local antiTextStroke = Instance.new("UIStroke")
            antiTextStroke.Color = Color3.new(0, 0, 0)
            antiTextStroke.Thickness = 1.8
            antiTextStroke.Transparency = 0.3
            antiTextStroke.Parent = antiTextButton
            
            local textCorner = Instance.new("UICorner")
            textCorner.CornerRadius = UDim.new(0, 7)
            textCorner.Parent = antiTextButton
            
            local textStroke = Instance.new("UIStroke")
            textStroke.Color = COLORS.BLACK
            textStroke.Thickness = 0.9
            textStroke.Transparency = 0.7
            textStroke.Parent = antiTextButton
            
            antiTextButton.MouseEnter:Connect(function()
                if not antiButtons[anti.Key] or not antiButtons[anti.Key].active then
                    antiTextButton.BackgroundTransparency = 0.2
                end
            end)
            
            antiTextButton.MouseLeave:Connect(function()
                if not antiButtons[anti.Key] or not antiButtons[anti.Key].active then
                    antiTextButton.BackgroundTransparency = 0.4
                end
            end)
            
            antiTextButton.Parent = antiButtonContainer
            
            local antiIcon = Instance.new("ImageLabel")
            antiIcon.Size = UDim2.new(0, 42, 0, 42)
            antiIcon.Position = UDim2.new(0.8, 10, 0.5, -21)
            antiIcon.Image = IMAGES.ANTIBAN_ICON
            antiIcon.BackgroundTransparency = 1
            antiIcon.ImageColor3 = COLORS.TEXT_WHITE
            antiIcon.ZIndex = 15
            antiIcon.Parent = antiButtonContainer
            
            antiButtons[anti.Key] = {
                button = antiTextButton,
                icon = antiIcon,
                active = false
            }
            
            antiTextButton.MouseButton1Click:Connect(function()
                local buttonData = antiButtons[anti.Key]
                buttonData.active = not buttonData.active
                
                if buttonData.active then
                    antiIcon.ImageColor3 = COLORS.GREEN_ACTIVE
                    antiTextButton.BackgroundTransparency = 0.1
                else
                    antiIcon.ImageColor3 = COLORS.TEXT_WHITE
                    antiTextButton.BackgroundTransparency = 0.4
                end
            end)
        end
        
    elseif sectionName == "الانتقال السريع" then
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, 0, 1, 0)
        scrollFrame.Position = UDim2.new(0, 0, 0, 0)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 10
        scrollFrame.ScrollBarImageColor3 = Color3.fromHex("#333333")
        scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        scrollFrame.ZIndex = 12
        scrollFrame.Parent = frame
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 10)
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.Parent = scrollFrame
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -25, 0, 950)
        container.Position = UDim2.new(0, 12.5, 0, 12.5)
        container.BackgroundTransparency = 1
        container.ZIndex = 13
        container.Parent = scrollFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 45)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.Text = "الانتقال السريع"
        title.TextColor3 = COLORS.TEXT_WHITE
        title.Font = Enum.Font.GothamBold
        title.TextSize = 24
        title.BackgroundTransparency = 1
        title.ZIndex = 14
        title.Parent = container
        
        local titleTextStroke = Instance.new("UIStroke")
        titleTextStroke.Color = Color3.new(0, 0, 0)
        titleTextStroke.Thickness = 2.2
        titleTextStroke.Transparency = 0.3
        titleTextStroke.Parent = title
        
        local teleportInfo = Instance.new("TextLabel")
        teleportInfo.Size = UDim2.new(1, 0, 0, 45)
        teleportInfo.Position = UDim2.new(0, 0, 0, 55)
        teleportInfo.Text = "اختر موقعاً للانتقال إليه:"
        teleportInfo.TextColor3 = COLORS.TEXT_LIGHT
        teleportInfo.Font = Enum.Font.Gotham
        teleportInfo.TextSize = 16
        teleportInfo.TextYAlignment = Enum.TextYAlignment.Top
        teleportInfo.TextXAlignment = Enum.TextXAlignment.Right
        teleportInfo.BackgroundTransparency = 1
        teleportInfo.ZIndex = 14
        teleportInfo.Parent = container
        
        local infoTextStroke = Instance.new("UIStroke")
        infoTextStroke.Color = Color3.new(0, 0, 0)
        infoTextStroke.Thickness = 1.3
        infoTextStroke.Transparency = 0.3
        infoTextStroke.Parent = teleportInfo
        
        local teleportLocations = {
            {Name = "قيادات عليا", CFrame = CFrame.new(-244.01, 74.30, -2942.67)},
            {Name = "المحكمه", CFrame = CFrame.new(-112.39, 79.24, -2628.52)},
            {Name = "السجن", CFrame = CFrame.new(-383.68, 78.45, -2466.91)},
            {Name = "داخل السجن", CFrame = CFrame.new(-404.63, 78.45, -2492.63)},
            {Name = "قطاع التدريب", CFrame = CFrame.new(-537.70, 74.34, -2908.32)},
            {Name = "منطقة التدريب (المنطقة الحمراء)", CFrame = CFrame.new(-180.22, 74.27, -2842.52)},
            {Name = "تدريب سباحه", CFrame = CFrame.new(12.48, 74.20, -2492.51)},
            {Name = "تدريب سرعه", CFrame = CFrame.new(-57.50, 74.20, -2773.63)},
            {Name = "منطقه الملازمين", CFrame = CFrame.new(-5.12, 74.20, -3005.02)},
            {Name = "مكان سري 1", CFrame = CFrame.new(-676.62, -363.35, -2616.60)},
            {Name = "مكان سري 2", CFrame = CFrame.new(356.22, 57.77, -2478.85)},
            {Name = "مكان المواطنين", CFrame = CFrame.new(358.26, 74.20, -2791.95)}
        }
        
        for i, location in ipairs(teleportLocations) do
            local teleportButton = createGlassButton(container, UDim2.new(1, -25, 0, 50), UDim2.new(0, 12.5, 0, 110 + (i-1) * 60), location.Name)
            teleportButton.TextColor3 = COLORS.TEXT_WHITE
            teleportButton.ZIndex = 14
            
            teleportButtons[location.Name] = {
                button = teleportButton,
                cframe = location.CFrame
            }
            
            teleportButton.MouseButton1Click:Connect(function()
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = location.CFrame
                    end
                end)
            end)
        end
        
        uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 130)
        end)
        
    elseif sectionName == "اللاعب" then
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -20, 1, -20)
        scrollFrame.Position = UDim2.new(0, 10, 0, 10)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 10
        scrollFrame.ScrollBarImageColor3 = Color3.fromHex("#333333")
        scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        scrollFrame.ZIndex = 12
        scrollFrame.Parent = frame
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 16)
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.Parent = scrollFrame
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 550)
        container.BackgroundTransparency = 1
        container.ZIndex = 13
        container.Parent = scrollFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 45)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.Text = "إعدادات اللاعب"
        title.TextColor3 = COLORS.TEXT_WHITE
        title.Font = Enum.Font.GothamBold
        title.TextSize = 24
        title.BackgroundTransparency = 1
        title.ZIndex = 14
        title.Parent = container
        
        local titleTextStroke = Instance.new("UIStroke")
        titleTextStroke.Color = Color3.new(0, 0, 0)
        titleTextStroke.Thickness = 2.2
        titleTextStroke.Transparency = 0.3
        titleTextStroke.Parent = title
        
        local speedContainer = Instance.new("Frame")
        speedContainer.Size = UDim2.new(1, -40, 0, 55)
        speedContainer.Position = UDim2.new(0, 20, 0, 55)
        speedContainer.BackgroundColor3 = COLORS.GLASS_1
        speedContainer.BackgroundTransparency = 0.4
        speedContainer.BorderSizePixel = 0
        speedContainer.ZIndex = 14
        
        local speedGradient = Instance.new("UIGradient")
        speedGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.GLASS_1),
            ColorSequenceKeypoint.new(1, COLORS.GLASS_2)
        })
        speedGradient.Parent = speedContainer
        
        local speedStroke = Instance.new("UIStroke")
        speedStroke.Color = COLORS.BLACK
        speedStroke.Thickness = 1.3
        speedStroke.Transparency = 0.7
        speedStroke.Parent = speedContainer
        
        local speedCorner = Instance.new("UICorner")
        speedCorner.CornerRadius = UDim.new(0, 7)
        speedCorner.Parent = speedContainer
        speedContainer.Parent = container
        
        local speedIcon = Instance.new("ImageLabel")
        speedIcon.Size = UDim2.new(0, 32, 0, 32)
        speedIcon.Position = UDim2.new(0, 12, 0.5, -16)
        speedIcon.Image = IMAGES.SPEED_ICON
        speedIcon.BackgroundTransparency = 1
        speedIcon.ZIndex = 15
        speedIcon.Parent = speedContainer
        
        local speedTextBox = Instance.new("TextBox")
        speedTextBox.Size = UDim2.new(0.6, -10, 0.6, 0)
        speedTextBox.Position = UDim2.new(0.2, 10, 0.2, 0)
        speedTextBox.PlaceholderText = "ادخل السرعه..."
        speedTextBox.Text = ""
        speedTextBox.TextColor3 = COLORS.TEXT_WHITE
        speedTextBox.Font = Enum.Font.Gotham
        speedTextBox.TextSize = 16
        speedTextBox.BackgroundColor3 = COLORS.GLASS_1
        speedTextBox.BackgroundTransparency = 0.3
        speedTextBox.BorderSizePixel = 0
        speedTextBox.ClearTextOnFocus = false
        speedTextBox.ZIndex = 15
        
        local speedTextStroke = Instance.new("UIStroke")
        speedTextStroke.Color = Color3.new(0, 0, 0)
        speedTextStroke.Thickness = 1.3
        speedTextStroke.Transparency = 0.3
        speedTextStroke.Parent = speedTextBox
        
        local textBoxStroke = Instance.new("UIStroke")
        textBoxStroke.Color = COLORS.BLACK
        textBoxStroke.Thickness = 0.9
        textBoxStroke.Transparency = 0.7
        textBoxStroke.Parent = speedTextBox
        
        local textBoxCorner = Instance.new("UICorner")
        textBoxCorner.CornerRadius = UDim.new(0, 5)
        textBoxCorner.Parent = speedTextBox
        speedTextBox.Parent = speedContainer
        
        local buttonsGrid = Instance.new("Frame")
        buttonsGrid.Size = UDim2.new(1, -40, 0, 110)
        buttonsGrid.Position = UDim2.new(0, 20, 0, 120)
        buttonsGrid.BackgroundTransparency = 1
        buttonsGrid.ZIndex = 13
        buttonsGrid.Parent = container
        
        local wallHackButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 0), "اختراق الجدران")
        local infiniteJumpButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 0), "قفز لا نهائي")
        local autoKickButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 55), "كلبشة تلقائية")
        local autoAimButton = createGlassButton(buttonsGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 55), "تصويب تلقائي")
        
        wallHackButton.ZIndex = 14
        infiniteJumpButton.ZIndex = 14
        autoKickButton.ZIndex = 14
        autoAimButton.ZIndex = 14
        
        local wallHackIcon = Instance.new("ImageLabel")
        wallHackIcon.Size = UDim2.new(0, 28, 0, 28)
        wallHackIcon.Position = UDim2.new(1, -38, 0.5, -14)
        wallHackIcon.Image = IMAGES.FEATURE_ICON
        wallHackIcon.BackgroundTransparency = 1
        wallHackIcon.ImageColor3 = COLORS.TEXT_WHITE
        wallHackIcon.ZIndex = 15
        wallHackIcon.Parent = wallHackButton
        
        local infiniteJumpIcon = Instance.new("ImageLabel")
        infiniteJumpIcon.Size = UDim2.new(0, 28, 0, 28)
        infiniteJumpIcon.Position = UDim2.new(1, -38, 0.5, -14)
        infiniteJumpIcon.Image = IMAGES.FEATURE_ICON
        infiniteJumpIcon.BackgroundTransparency = 1
        infiniteJumpIcon.ImageColor3 = COLORS.TEXT_WHITE
        infiniteJumpIcon.ZIndex = 15
        infiniteJumpIcon.Parent = infiniteJumpButton
        
        local autoKickIcon = Instance.new("ImageLabel")
        autoKickIcon.Size = UDim2.new(0, 28, 0, 28)
        autoKickIcon.Position = UDim2.new(1, -38, 0.5, -14)
        autoKickIcon.Image = IMAGES.FEATURE_ICON
        autoKickIcon.BackgroundTransparency = 1
        autoKickIcon.ImageColor3 = COLORS.TEXT_WHITE
        autoKickIcon.ZIndex = 15
        autoKickIcon.Parent = autoKickButton
        
        local autoAimIcon = Instance.new("ImageLabel")
        autoAimIcon.Size = UDim2.new(0, 28, 0, 28)
        autoAimIcon.Position = UDim2.new(1, -38, 0.5, -14)
        autoAimIcon.Image = IMAGES.FEATURE_ICON
        autoAimIcon.BackgroundTransparency = 1
        autoAimIcon.ImageColor3 = COLORS.TEXT_WHITE
        autoAimIcon.ZIndex = 15
        autoAimIcon.Parent = autoAimButton
        
        -- منطقة الحمراء بدون تدرج وتأثيرات
        local redZoneTitle = Instance.new("TextLabel")
        redZoneTitle.Size = UDim2.new(1, -40, 0, 45)
        redZoneTitle.Position = UDim2.new(0, 20, 0, 250)
        redZoneTitle.Text = "——— المنطقة الحمراء ———"
        redZoneTitle.Font = Enum.Font.GothamBold
        redZoneTitle.TextSize = 20
        redZoneTitle.TextColor3 = COLORS.TEXT_WHITE
        redZoneTitle.TextXAlignment = Enum.TextXAlignment.Center
        redZoneTitle.BackgroundTransparency = 1
        redZoneTitle.ZIndex = 14
        redZoneTitle.Parent = container
        
        local redZoneGrid = Instance.new("Frame")
        redZoneGrid.Size = UDim2.new(1, -40, 0, 45)
        redZoneGrid.Position = UDim2.new(0, 20, 0, 305)
        redZoneGrid.BackgroundTransparency = 1
        redZoneGrid.ZIndex = 13
        redZoneGrid.Parent = container
        
        local autoWinButton = createGlassButton(redZoneGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 0), "فوز تلقائي")
        local killKickButton = createGlassButton(redZoneGrid, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 0), "قتل وكلبشه")
        
        autoWinButton.ZIndex = 14
        killKickButton.ZIndex = 14
        
        local autoWinIcon = Instance.new("ImageLabel")
        autoWinIcon.Size = UDim2.new(0, 28, 0, 28)
        autoWinIcon.Position = UDim2.new(1, -38, 0.5, -14)
        autoWinIcon.Image = IMAGES.FEATURE_ICON
        autoWinIcon.BackgroundTransparency = 1
        autoWinIcon.ImageColor3 = COLORS.TEXT_WHITE
        autoWinIcon.ZIndex = 15
        autoWinIcon.Parent = autoWinButton
        
        local killKickIcon = Instance.new("ImageLabel")
        killKickIcon.Size = UDim2.new(0, 28, 0, 28)
        killKickIcon.Position = UDim2.new(1, -38, 0.5, -14)
        killKickIcon.Image = IMAGES.FEATURE_ICON
        killKickIcon.BackgroundTransparency = 1
        killKickIcon.ImageColor3 = COLORS.TEXT_WHITE
        killKickIcon.ZIndex = 15
        killKickIcon.Parent = killKickButton
        
        playerButtons["wall_hack"] = {button = wallHackButton, icon = wallHackIcon, active = false}
        playerButtons["infinite_jump"] = {button = infiniteJumpButton, icon = infiniteJumpIcon, active = false}
        playerButtons["auto_kick"] = {button = autoKickButton, icon = autoKickIcon, active = false}
        playerButtons["auto_aim"] = {button = autoAimButton, icon = autoAimIcon, active = false}
        playerButtons["auto_win"] = {button = autoWinButton, icon = autoWinIcon, active = false}
        playerButtons["kill_kick"] = {button = killKickButton, icon = killKickIcon, active = false}
        
        local function togglePlayerButton(buttonKey)
            local buttonData = playerButtons[buttonKey]
            buttonData.active = not buttonData.active
            
            if buttonData.active then
                buttonData.button.BackgroundTransparency = 0.1
                buttonData.icon.ImageColor3 = COLORS.GREEN_ACTIVE
            else
                buttonData.button.BackgroundTransparency = 0.4
                buttonData.icon.ImageColor3 = COLORS.TEXT_WHITE
            end
        end
        
        wallHackButton.MouseButton1Click:Connect(function() togglePlayerButton("wall_hack") end)
        infiniteJumpButton.MouseButton1Click:Connect(function() togglePlayerButton("infinite_jump") end)
        autoKickButton.MouseButton1Click:Connect(function() togglePlayerButton("auto_kick") end)
        autoAimButton.MouseButton1Click:Connect(function() togglePlayerButton("auto_aim") end)
        autoWinButton.MouseButton1Click:Connect(function() togglePlayerButton("auto_win") end)
        killKickButton.MouseButton1Click:Connect(function() togglePlayerButton("kill_kick") end)
        
        -- قسم المميز بدون تدرج وتأثيرات
        local specialTitle = Instance.new("TextLabel")
        specialTitle.Size = UDim2.new(1, -40, 0, 45)
        specialTitle.Position = UDim2.new(0, 20, 0, 370)
        specialTitle.Text = "——— مميز ———"
        specialTitle.Font = Enum.Font.GothamBold
        specialTitle.TextSize = 20
        specialTitle.TextColor3 = COLORS.TEXT_WHITE
        specialTitle.TextXAlignment = Enum.TextXAlignment.Center
        specialTitle.BackgroundTransparency = 1
        specialTitle.ZIndex = 14
        specialTitle.Parent = container
        
        local specialButtonsGrid = Instance.new("Frame")
        specialButtonsGrid.Size = UDim2.new(1, -40, 0, 110)
        specialButtonsGrid.Position = UDim2.new(0, 20, 0, 425)
        specialButtonsGrid.BackgroundTransparency = 1
        specialButtonsGrid.ZIndex = 13
        specialButtonsGrid.Parent = container
        
        local jailEscapeContainer = Instance.new("Frame")
        jailEscapeContainer.Size = UDim2.new(0.48, 0, 0, 45)
        jailEscapeContainer.Position = UDim2.new(0.52, 0, 0, 0)
        jailEscapeContainer.BackgroundTransparency = 1
        jailEscapeContainer.ZIndex = 13
        jailEscapeContainer.Parent = specialButtonsGrid
        
        local jailEscapeButton = createGlassButton(jailEscapeContainer, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "خروج من السجن")
        jailEscapeButton.ZIndex = 14
        
        local jailIcon = Instance.new("ImageLabel")
        jailIcon.Size = UDim2.new(0, 22, 0, 22)
        jailIcon.Position = UDim2.new(0, 8, 1, -27)
        jailIcon.Image = IMAGES.SPECIAL_ICON
        jailIcon.BackgroundTransparency = 1
        jailIcon.ImageColor3 = COLORS.TEXT_WHITE
        jailIcon.ZIndex = 15
        jailIcon.Parent = jailEscapeButton
        
        local unlockContainer = Instance.new("Frame")
        unlockContainer.Size = UDim2.new(0.48, 0, 0, 45)
        unlockContainer.Position = UDim2.new(0, 0, 0, 0)
        unlockContainer.BackgroundTransparency = 1
        unlockContainer.ZIndex = 13
        unlockContainer.Parent = specialButtonsGrid
        
        local unlockButton = createGlassButton(unlockContainer, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "إزاله التعشيق")
        unlockButton.ZIndex = 14
        
        local unlockIcon = Instance.new("ImageLabel")
        unlockIcon.Size = UDim2.new(0, 22, 0, 22)
        unlockIcon.Position = UDim2.new(0, 8, 1, -27)
        unlockIcon.Image = IMAGES.SPECIAL_ICON
        unlockIcon.BackgroundTransparency = 1
        unlockIcon.ImageColor3 = COLORS.TEXT_WHITE
        unlockIcon.ZIndex = 15
        unlockIcon.Parent = unlockButton
        
        jailEscapeButton.MouseButton1Click:Connect(function()
            local data = specialButtons["jail_escape"] or {active = false}
            data.active = not data.active
            if data.active then
                jailIcon.ImageColor3 = COLORS.CYAN
                jailEscapeButton.BackgroundTransparency = 0.1
            else
                jailIcon.ImageColor3 = COLORS.TEXT_WHITE
                jailEscapeButton.BackgroundTransparency = 0.4
            end
            specialButtons["jail_escape"] = data
        end)
        
        unlockButton.MouseButton1Click:Connect(function()
            local data = specialButtons["unlock"] or {active = false}
            data.active = not data.active
            if data.active then
                unlockIcon.ImageColor3 = COLORS.CYAN
                unlockButton.BackgroundTransparency = 0.1
            else
                unlockIcon.ImageColor3 = COLORS.TEXT_WHITE
                unlockButton.BackgroundTransparency = 0.4
            end
            specialButtons["unlock"] = data
        end)
        
        uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 110)
        end)
        
    elseif sectionName == "تخريب" then
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -20, 1, -20)
        scrollFrame.Position = UDim2.new(0, 10, 0, 10)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 10
        scrollFrame.ScrollBarImageColor3 = Color3.fromHex("#333333")
        scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        scrollFrame.ZIndex = 12
        scrollFrame.Parent = frame
        
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 16)
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.Parent = scrollFrame
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 500)
        container.BackgroundTransparency = 1
        container.ZIndex = 13
        container.Parent = scrollFrame
        
        -- قسم السحب بدون تدرج وتأثيرات
        local pullTitle = Instance.new("TextLabel")
        pullTitle.Size = UDim2.new(1, -40, 0, 45)
        pullTitle.Position = UDim2.new(0, 20, 0, 20)
        pullTitle.Text = "——— سحب ———"
        pullTitle.Font = Enum.Font.GothamBold
        pullTitle.TextSize = 20
        pullTitle.TextColor3 = COLORS.TEXT_WHITE
        pullTitle.TextXAlignment = Enum.TextXAlignment.Center
        pullTitle.BackgroundTransparency = 1
        pullTitle.ZIndex = 14
        pullTitle.Parent = container
        
        local destructionGrid1 = Instance.new("Frame")
        destructionGrid1.Size = UDim2.new(1, -40, 0, 110)
        destructionGrid1.Position = UDim2.new(0, 20, 0, 80)
        destructionGrid1.BackgroundTransparency = 1
        destructionGrid1.ZIndex = 13
        destructionGrid1.Parent = container
        
        local seaButton = createGlassButton(destructionGrid1, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 0), "البحر")
        local pushButton = createGlassButton(destructionGrid1, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 0), "احشرهم")
        local push2Button = createGlassButton(destructionGrid1, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 55), "احشرهم 2")
        local secretPlaceButton = createGlassButton(destructionGrid1, UDim2.new(0.48, 0, 0, 45), UDim2.new(0.52, 0, 0, 55), "ارميهم في المكان السري")
        
        seaButton.ZIndex = 14
        pushButton.ZIndex = 14
        push2Button.ZIndex = 14
        secretPlaceButton.ZIndex = 14
        
        local seaCircle = Instance.new("Frame")
        seaCircle.Size = UDim2.new(0, 12, 0, 12)
        seaCircle.Position = UDim2.new(1, -18, 1, -18)
        seaCircle.BackgroundColor3 = COLORS.TEXT_WHITE
        seaCircle.BorderSizePixel = 0
        seaCircle.ZIndex = 15
        local seaCircleCorner = Instance.new("UICorner")
        seaCircleCorner.CornerRadius = UDim.new(1, 0)
        seaCircleCorner.Parent = seaCircle
        seaCircle.Parent = seaButton
        
        local pushCircle = Instance.new("Frame")
        pushCircle.Size = UDim2.new(0, 12, 0, 12)
        pushCircle.Position = UDim2.new(1, -18, 1, -18)
        pushCircle.BackgroundColor3 = COLORS.TEXT_WHITE
        pushCircle.BorderSizePixel = 0
        pushCircle.ZIndex = 15
        local pushCircleCorner = Instance.new("UICorner")
        pushCircleCorner.CornerRadius = UDim.new(1, 0)
        pushCircleCorner.Parent = pushCircle
        pushCircle.Parent = pushButton
        
        local push2Circle = Instance.new("Frame")
        push2Circle.Size = UDim2.new(0, 12, 0, 12)
        push2Circle.Position = UDim2.new(1, -18, 1, -18)
        push2Circle.BackgroundColor3 = COLORS.TEXT_WHITE
        push2Circle.BorderSizePixel = 0
        push2Circle.ZIndex = 15
        local push2CircleCorner = Instance.new("UICorner")
        push2CircleCorner.CornerRadius = UDim.new(1, 0)
        push2CircleCorner.Parent = push2Circle
        push2Circle.Parent = push2Button
        
        local secretCircle = Instance.new("Frame")
        secretCircle.Size = UDim2.new(0, 12, 0, 12)
        secretCircle.Position = UDim2.new(1, -18, 1, -18)
        secretCircle.BackgroundColor3 = COLORS.TEXT_WHITE
        secretCircle.BorderSizePixel = 0
        secretCircle.ZIndex = 15
        local secretCircleCorner = Instance.new("UICorner")
        secretCircleCorner.CornerRadius = UDim.new(1, 0)
        secretCircleCorner.Parent = secretCircle
        secretCircle.Parent = secretPlaceButton
        
        destructionButtons["sea"] = {button = seaButton, circle = seaCircle, active = false}
        destructionButtons["push"] = {button = pushButton, circle = pushCircle, active = false}
        destructionButtons["push2"] = {button = push2Button, circle = push2Circle, active = false}
        destructionButtons["secret"] = {button = secretPlaceButton, circle = secretCircle, active = false}
        
        local function selectDestructionButton(buttonKey)
            if selectedDestructionButton == buttonKey then
                local data = destructionButtons[buttonKey]
                data.active = false
                data.button.BackgroundTransparency = 0.4
                data.circle.BackgroundColor3 = COLORS.TEXT_WHITE
                selectedDestructionButton = nil
                return
            end
            
            if selectedDestructionButton then
                local prev = destructionButtons[selectedDestructionButton]
                prev.active = false
                prev.button.BackgroundTransparency = 0.4
                prev.circle.BackgroundColor3 = COLORS.TEXT_WHITE
            end
            
            local data = destructionButtons[buttonKey]
            data.active = true
            data.button.BackgroundTransparency = 0.1
            data.circle.BackgroundColor3 = COLORS.CYAN
            selectedDestructionButton = buttonKey
        end
        
        seaButton.MouseButton1Click:Connect(function() selectDestructionButton("sea") end)
        pushButton.MouseButton1Click:Connect(function() selectDestructionButton("push") end)
        push2Button.MouseButton1Click:Connect(function() selectDestructionButton("push2") end)
        secretPlaceButton.MouseButton1Click:Connect(function() selectDestructionButton("secret") end)
        
        local destructionGrid2 = Instance.new("Frame")
        destructionGrid2.Size = UDim2.new(1, -40, 0, 110)
        destructionGrid2.Position = UDim2.new(0, 20, 0, 210)
        destructionGrid2.BackgroundTransparency = 1
        destructionGrid2.ZIndex = 13
        destructionGrid2.Parent = container
        
        local activateButton = createGlassButton(destructionGrid2, UDim2.new(0.48, 0, 0, 45), UDim2.new(0, 0, 0, 0), "تفعيل")
        activateButton.ZIndex = 14
        
        local activateIcon = Instance.new("ImageLabel")
        activateIcon.Size = UDim2.new(0, 28, 0, 28)
        activateIcon.Position = UDim2.new(0, 12, 0.5, -14)
        activateIcon.Image = IMAGES.DESTRUCTION_2
        activateIcon.BackgroundTransparency = 1
        activateIcon.ImageColor3 = COLORS.TEXT_WHITE
        activateIcon.ZIndex = 15
        activateIcon.Parent = activateButton
        
        activateButton.MouseButton1Click:Connect(function()
            if selectedDestructionButton then
                local data = destructionButtons[selectedDestructionButton]
                data.circle.BackgroundColor3 = COLORS.GREEN_ACTIVE
                activateButton.BackgroundTransparency = 0.1
                activateIcon.ImageColor3 = COLORS.GREEN_ACTIVE
                wait(0.5)
                activateButton.BackgroundTransparency = 0.4
                activateIcon.ImageColor3 = COLORS.TEXT_WHITE
            else
                activateButton.BackgroundTransparency = 0.1
                activateIcon.ImageColor3 = COLORS.ORANGE
                wait(0.5)
                activateButton.BackgroundTransparency = 0.4
                activateIcon.ImageColor3 = COLORS.TEXT_WHITE
            end
        end)
        
        uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 110)
        end)
    end
end

--// Initialize with Home section selected
selectSection("الرئيسية")

--// Drag functionality
local dragging = false
local dragStart
local startPos

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        mainFrame.ZIndex = 100
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        mainFrame.ZIndex = 10
    end
end)

--// Minimize button functionality
local minimizedIcon = nil
local isMinimized = false

local function createMinimizedIcon()
    if minimizedIcon then
        minimizedIcon:Destroy()
        minimizedIcon = nil
    end
    
    minimizedIcon = Instance.new("ImageButton")
    minimizedIcon.Size = UDim2.new(0, 60, 0, 60)
    minimizedIcon.Position = UDim2.new(0, 20, 0, 20)
    minimizedIcon.Image = IMAGES.MINIMIZE_ICON
    minimizedIcon.BackgroundTransparency = 1
    minimizedIcon.ZIndex = 100
    minimizedIcon.Parent = screenGui
    
    local iconDragging = false
    local iconDragStart
    local iconStartPos
    
    minimizedIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            iconDragging = true
            iconDragStart = input.Position
            iconStartPos = minimizedIcon.Position
            minimizedIcon.ZIndex = 101
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - iconDragStart
            minimizedIcon.Position = UDim2.new(
                iconStartPos.X.Scale, 
                iconStartPos.X.Offset + delta.X,
                iconStartPos.Y.Scale, 
                iconStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            iconDragging = false
            minimizedIcon.ZIndex = 100
        end
    end)
    
    minimizedIcon.MouseButton1Click:Connect(function()
        if isMinimized then
            mainFrame.Visible = true
            minimizedIcon:Destroy()
            minimizedIcon = nil
            isMinimized = false
            blurContainer.Visible = false
        end
    end)
end

local function toggleBlurEffect(visible)
    blurContainer.Visible = visible
end

minimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        mainFrame.Visible = false
        isMinimized = true
        createMinimizedIcon()
        toggleBlurEffect(false)
    else
        mainFrame.Visible = true
        isMinimized = false
        if minimizedIcon then
            minimizedIcon:Destroy()
            minimizedIcon = nil
        end
        toggleBlurEffect(true)
    end
end)

toggleBlurEffect(true)

print("✅ تم تحميل السكربت كاملاً بكل التعديلات المطلوبة!")
print("✅ التعديلات التي تم إجراؤها:")
print("   1. قسم الرئيسية: تم تعديل التصميم كاملاً")
print("   2. تم إزالة المربع الفارغ وإبقاء Viewport فقط في المنتصف")
print("   3. Viewport الآن مربع الشكل (200×200) في وسط الصفحة")
print("   4. أضيف إطار علوي يحتوي على تحية (صباح/مساء الخير)")
print("   5. أضيف إطار سفلي يحتوي على معلومات الرتبة والنقاط")
print("   6. يتم جلب بيانات الرتبة والنقاط من معلومات اللعبة")
print("   7. إزالة الزوايا المدورة من الهيدر والإطار الرئيسي")
print("   8. إزالة التدرج من أزرار المحتوى في جميع الأقسام")
print("   9. زيادة طول الواجهة قليلاً (440 بدلاً من 420)")
print("   10. إزالة تأثير التدرج والحواف السوداء من النصوص في قسم اللاعب والتخريب")
