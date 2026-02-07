local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- متغيرات الحالة
local selectedLocation = nil
local isOnCooldownLocations = false
local cooldownTime = 9

-- متغيرات عملية السرقة
local isStealingGun = false
local isStealingKeycard = false
local selectedKeycardType = nil

-- متغير لتتبع إذا كان سكربت فتح الجدران قد شغل من قبل
local wallScriptActivated = false

-- إحداثيات Min
local MinArmoryPos = CFrame.new(196, 23.23, -215)
local MinSecretDropPos = CFrame.new(-3.63, 30.07, -57.13)
local MinDropCFrame = MinSecretDropPos * CFrame.Angles(math.rad(90), 0, 0)
local MinCamDropPos = CFrame.new(-4.40027905, 28.6965332, -52.30336, 0.999962628, 0.00840886775, -0.00199508853, 0, 0.230851427, 0.972989082, 0.00864230469, -0.972952724, 0.230842814)

-- إحداثيات Max
local MaxArmoryPos = CFrame.new(196, 23.23, -215)
local MaxSecretDropPos = CFrame.new(86.40, 3.72, -123.01)
local MaxDropCFrame = MaxSecretDropPos * CFrame.Angles(math.rad(90), 0, 0)
local MaxCamDropPos = CFrame.new(87.8526535, -0.884054422, -138.253372, -0.999785066, -0.0151582891, 0.0141448993, 0, 0.682245076, 0.731123507, -0.0207328703, 0.730966389, -0.682098448)

-- إحداثيات Booking
local BookingDropCFrame = CFrame.new(190.80, 19.13, -155.41) * CFrame.Angles(-1.763, -0.006, -3.108)
local BookingCamDropPos = CFrame.new(196.15538, 16.8420944, -161.746475, -0.88024509, -0.283127189, 0.380798608, 0, 0.802493393, 0.596661031, -0.474519312, 0.525207937, -0.706390858)

-- إحداثيات عامة
local FinalFarmPos = CFrame.new(-36.44, 29.60, -24.68)

-- ===================================
-- سكربت فتح جدران محددة فقط - يعمل حتى بعد الموت والريست (لا يفتح الأبواب)
-- ===================================
getgenv().WallHackEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if not getgenv().PersistentWalls then
    getgenv().PersistentWalls = {}
end

local SpecificWalls = {}

local targetWalls = {
    {path = "Workspace.Map.Unorganized.Part", position = Vector3.new(-7, 29, -79)},
    {path = "Workspace.Map.Unorganized.Part", position = Vector3.new(-7, 29, -72)},
    {path = "Workspace.Map.Unorganized.Part", position = Vector3.new(183, 18, -147)},
    {path = "Workspace.Map.Unorganized.Union", position = Vector3.new(89, 1, -115)},
    {path = "Workspace.Map.Unorganized.Part", position = Vector3.new(88, 0, -131)}
}

local function updateRoot()
    if player.Character then
        return player.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local root = updateRoot()

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    root = updateRoot()
    
    task.wait(0.5)
    if getgenv().WallHackEnabled then
        scanSpecificWalls(true)
    end
end)

local function scanSpecificWalls(afterRespawn)
    local unorganized = workspace.Map:FindFirstChild("Unorganized")
    if not unorganized then 
        if afterRespawn then
            task.wait(2)
            scanSpecificWalls(true)
        end
        return 
    end
    
    for _, target in pairs(targetWalls) do
        local foundPart = false
        
        for _, part in pairs(unorganized:GetChildren()) do
            if (part:IsA("BasePart") or part:IsA("UnionOperation")) then
                local distance = (part.Position - target.position).Magnitude
                if distance < 5 then
                    if not SpecificWalls[part] then
                        part.CanCollide = false
                        SpecificWalls[part] = true
                        getgenv().PersistentWalls[part] = true
                        foundPart = true
                    elseif part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
        
        if not foundPart and target.path then
            local success, part = pcall(function()
                local pathParts = target.path:split(".")
                local current = workspace
                for _, name in ipairs(pathParts) do
                    current = current:FindFirstChild(name)
                    if not current then break end
                end
                return current
            end)
            
            if success and part and (part:IsA("BasePart") or part:IsA("UnionOperation")) then
                if not SpecificWalls[part] then
                    part.CanCollide = false
                    SpecificWalls[part] = true
                    getgenv().PersistentWalls[part] = true
                end
            end
        end
    end
    
    for part, _ in pairs(getgenv().PersistentWalls) do
        if part and part.Parent then
            part.CanCollide = false
            SpecificWalls[part] = true
        end
    end
end

local wallsScanningThread
local function startWallsScanning()
    if wallsScanningThread then 
        return
    end
    
    wallsScanningThread = spawn(function()
        while getgenv().WallHackEnabled do
            scanSpecificWalls(false)
            
            for part, _ in pairs(SpecificWalls) do
                if part and part.Parent and part.CanCollide then
                    part.CanCollide = false
                end
            end
            task.wait(1)
        end
        wallsScanningThread = nil
    end)
end

local heartbeatConnection
local function startHeartbeat()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not getgenv().WallHackEnabled then return end
        
        root = updateRoot()
        if not root then return end
        
        for part, _ in pairs(SpecificWalls) do
            if part and part.Parent then
                part.CanCollide = false
            end
        end
    end)
end

-- دالة تفعيل سكربت فتح الجدران (مرة واحدة فقط)
local function activateWallScript()
    if wallScriptActivated then
        return
    end
    
    getgenv().WallHackEnabled = true
    startWallsScanning()
    startHeartbeat()
    wallScriptActivated = true
end

-- ===================================
-- دالة لتفعيل جميع ProximityPrompts مرة واحدة
-- ===================================
local function activateAllProximityPrompts()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

-- ===================================
-- دالة جمع الأسلحة من Armory (مبسطة)
-- ===================================
local function collectGunsFromArmory()
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- 1. حفظ المكان الحالي
    local savedPosition = hrp.CFrame
    
    -- 2. الانتقال إلى Armory (MinArmoryPos)
    hrp.CFrame = MinArmoryPos
    
    -- 3. انتظار بسيط
    task.wait(0.3)
    
    -- 4. فتح كل الـ ProximityPrompts
    activateAllProximityPrompts()
    
    -- 5. انتظار لجمع الأسلحة
    task.wait(2.5)
    
    -- 6. العودة إلى المكان الأصلي
    hrp.CFrame = savedPosition
end

-- ===================================
-- دالة سرقة الكي كارد مع اختيار النوع (بدون تجهيز الكي كارد)
-- ===================================
local function stealKeycard()
    if isStealingKeycard or not selectedKeycardType then 
        if not selectedKeycardType then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Keycard",
                Text = "Please select a keycard type first!",
                Duration = 3
            })
        end
        return 
    end
    
    isStealingKeycard = true
    local character = player.Character
    if not character then 
        isStealingKeycard = false
        return 
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        isStealingKeycard = false
        return 
    end
    
    -- حفظ الإعدادات الأصلية
    local savedPosition = hrp.CFrame
    local savedCameraType = camera.CameraType
    local savedCameraSubject = camera.CameraSubject
    local savedFOV = camera.FieldOfView
    
    -- تحديد إحداثيات حسب نوع الكي كارد
    local playerPosition, cameraCFrame
    
    if selectedKeycardType == "Director Keycard" then
        playerPosition = CFrame.new(122.88, 31.90, -86.88) * CFrame.Angles(-1.540, 0.172, 1.394)
        cameraCFrame = CFrame.new(121.064880371, 27.705160141, -83.727638245,
            0.999987900, -0.003909293, 0.002990719,
            0.000000000, 0.607611656, 0.794234276,
            -0.004922090, -0.794224679, 0.607604265)
        
    elseif selectedKeycardType == "Employee Keycard" then
        playerPosition = CFrame.new(33.13, -7.47, 37.74) * CFrame.Angles(-3.142, 0.494, 3.142)
        cameraCFrame = CFrame.new(39.232181549, -7.193625450, 32.689357758,
            -0.853826046, -0.184669748, 0.486701429,
            0.000000015, 0.934960127, 0.354753107,
            -0.520558536, 0.302897453, -0.798293233)
        
    elseif selectedKeycardType == "Corrections Keycard" then
        playerPosition = CFrame.new(-18.08, 21.77, -29.54) * CFrame.Angles(0.000002, -1.551304, 0.000002)
        cameraCFrame = CFrame.new(-14.644808769, 23.959465027, -30.164138794,
            -0.009028642, 0.668105960, -0.744011343,
            0.000000000, 0.744041681, 0.668133199,
            0.999959230, 0.006032335, -0.006717686)
    end
    
    -- حفظ محتويات الباكباك قبل البدء
    local backpackBefore = {}
    for _, item in player.Backpack:GetChildren() do
        table.insert(backpackBefore, {Name = item.Name, ClassName = item.ClassName})
    end
    
    -- الانتقال إلى موقع الكي كارد
    hrp.CFrame = playerPosition
    
    -- جعل الكاميرا ثابتة
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = cameraCFrame
    
    -- انتظار بسيط
    task.wait(0.5)
    
    -- تفعيل جميع ProximityPrompts مرة واحدة
    activateAllProximityPrompts()
    
    -- انتظار لجمع الكي كارد
    task.wait(2)
    
    -- التحقق من وجود أشياء جديدة في الباكباك
    local newItemsFound = false
    for _, item in player.Backpack:GetChildren() do
        local isNew = true
        for _, oldItem in ipairs(backpackBefore) do
            if oldItem.Name == item.Name and oldItem.ClassName == item.ClassName then
                isNew = false
                break
            end
        end
        if isNew then
            newItemsFound = true
            -- لا يتم نقل الكي كارد إلى الشخصية (يبقى في الباكباك)
            -- فقط نقوم بتسجيل أننا وجدنا عنصر جديد
        end
    end
    
    -- انتظار إضافي للتأكد من جمع كل شيء
    task.wait(1)
    
    -- جولة إضافية للتأكد من جمع كل شيء
    activateAllProximityPrompts()
    
    -- انتظار نهائي
    task.wait(1)
    
    -- إعادة اللاعب إلى المكان الأصلي
    hrp.CFrame = savedPosition
    
    -- إرجاع إعدادات الكاميرا
    camera.CameraType = savedCameraType
    camera.CameraSubject = savedCameraSubject
    camera.FieldOfView = savedFOV
    
    isStealingKeycard = false
    
    -- إشعار بنجاح العملية
    if newItemsFound then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Keycard Collected",
            Text = "Successfully collected " .. selectedKeycardType .. " (in backpack)!",
            Duration = 3
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Keycard",
            Text = "No new items collected. Try again.",
            Duration = 3
        })
    end
end

-- ===================================
-- إنشاء الواجهة الرسومية مع التصميم الجديد
-- ===================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GunSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- الإطار الرئيسي مع تأثير Liquid Glass
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 450)
mainFrame.Position = UDim2.new(0, 20, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- أسود داكن
mainFrame.BackgroundTransparency = 0.15 -- تأثير الزجاج
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- تأثير الزجاج Liquid Glass
local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 16)

-- تأثير Blur خلفي
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 15
blurEffect.Parent = mainFrame

-- الإطار المتحرك مع تدرج الألوان
local animatedStroke = Instance.new("Frame")
animatedStroke.Name = "AnimatedStroke"
animatedStroke.Size = UDim2.new(1, 6, 1, 6)
animatedStroke.Position = UDim2.new(0, -3, 0, -3)
animatedStroke.BackgroundTransparency = 1
animatedStroke.Parent = mainFrame

local strokeCorner = Instance.new("UICorner", animatedStroke)
strokeCorner.CornerRadius = UDim.new(0, 19)

-- التدرج اللوني المتحرك
local movingGradient = Instance.new("UIGradient")
movingGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), -- أسود
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(43, 2, 69)), -- 2b0245
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- أسود
})
movingGradient.Rotation = 0
movingGradient.Parent = animatedStroke

-- UIStroke للتدرج
local gradientStroke = Instance.new("UIStroke", animatedStroke)
gradientStroke.Thickness = 3
gradientStroke.LineJoinMode = Enum.LineJoinMode.Round

-- جعل التدرج يتحرك ببطء
spawn(function()
    while true do
        for i = 0, 360, 1 do
            movingGradient.Rotation = i
            task.wait(0.03) -- سرعة الحركة
        end
    end
end)

-- التبويبات
local tabNames = {"Locations", "Teleport"}
local tabButtons = {}
local tabContents = {}

local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0.9, 0, 0, 50)
tabsFrame.Position = UDim2.new(0.05, 0, 0, 20)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame

local tabPadding = 5
local totalWidth = 360 * 0.9
local buttonWidth = (totalWidth - (#tabNames - 1) * tabPadding) / #tabNames

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * (buttonWidth + tabPadding), 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(22, 1, 35) or Color3.fromRGB(22, 1, 35) -- 160123 داكن
    btn.BackgroundTransparency = 0.2 -- تأثير الزجاج
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220) -- رمادي فاتح
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = tabsFrame
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 12)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(40, 40, 40)
    
    tabButtons[name] = btn

    local content = Instance.new("Frame")
    content.Size = UDim2.new(0.9, 0, 0, 370)
    content.Position = UDim2.new(0.05, 0, 0, 80)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    tabContents[name] = content
end

for _, name in ipairs(tabNames) do
    tabButtons[name].MouseButton1Click:Connect(function()
        for k, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(22, 1, 35) -- 160123
            b.BackgroundTransparency = 0.2
            tabContents[k].Visible = false
        end
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(28, 5, 45) -- أفتح قليلاً عند التحديد
        tabButtons[name].BackgroundTransparency = 0.1
        tabContents[name].Visible = true
    end)
end

-- ==================== Locations Tab ====================
local locContent = tabContents["Locations"]

local function createStyledButton(name, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 70)
    btn.Position = UDim2.new(0.05, 0, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(22, 1, 35) -- 160123
    btn.BackgroundTransparency = 0.2 -- تأثير الزجاج
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 30
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = locContent
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 14)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(40, 40, 40)
    
    -- تأثير عند المرور بالمؤشر
    btn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
    end)
    
    return btn
end

local minBtn = createStyledButton("Min Lobby", 20)
local maxBtn = createStyledButton("Max", 110)
local bookingBtn = createStyledButton("Booking", 200)

minBtn.MouseButton1Click:Connect(function()
    minBtn.BackgroundColor3 = Color3.fromRGB(28, 5, 45)
    minBtn.BackgroundTransparency = 0.1
    maxBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    maxBtn.BackgroundTransparency = 0.2
    bookingBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    bookingBtn.BackgroundTransparency = 0.2
    selectedLocation = "Min"
end)

maxBtn.MouseButton1Click:Connect(function()
    maxBtn.BackgroundColor3 = Color3.fromRGB(28, 5, 45)
    maxBtn.BackgroundTransparency = 0.1
    minBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    minBtn.BackgroundTransparency = 0.2
    bookingBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    bookingBtn.BackgroundTransparency = 0.2
    selectedLocation = "Max"
end)

bookingBtn.MouseButton1Click:Connect(function()
    bookingBtn.BackgroundColor3 = Color3.fromRGB(28, 5, 45)
    bookingBtn.BackgroundTransparency = 0.1
    minBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    minBtn.BackgroundTransparency = 0.2
    maxBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    maxBtn.BackgroundTransparency = 0.2
    selectedLocation = "Booking"
end)

local locSpawnBtn = Instance.new("TextButton")
locSpawnBtn.Size = UDim2.new(0.9, 0, 0, 60)
locSpawnBtn.Position = UDim2.new(0.05, 0, 0, 290)
locSpawnBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35) -- 160123
locSpawnBtn.BackgroundTransparency = 0.2
locSpawnBtn.Text = "Spawn"
locSpawnBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
locSpawnBtn.TextSize = 30
locSpawnBtn.Font = Enum.Font.GothamBold
locSpawnBtn.AutoButtonColor = false
locSpawnBtn.Parent = locContent

local spawnCorner = Instance.new("UICorner", locSpawnBtn)
spawnCorner.CornerRadius = UDim.new(0, 14)

local spawnStroke = Instance.new("UIStroke", locSpawnBtn)
spawnStroke.Thickness = 2
spawnStroke.Color = Color3.fromRGB(40, 40, 40)

-- تأثيرات الماوس لزر Spawn
locSpawnBtn.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(locSpawnBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.1,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

locSpawnBtn.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(locSpawnBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2,
        TextColor3 = Color3.fromRGB(220, 220, 220)
    }):Play()
end)

local locLoadingDot = Instance.new("Frame")
locLoadingDot.Size = UDim2.new(0, 20, 0, 20)
locLoadingDot.Position = UDim2.new(1, -30, 0.5, -10)
locLoadingDot.BackgroundColor3 = Color3.fromRGB(43, 2, 69) -- 2b0245
locLoadingDot.Visible = false
locLoadingDot.Parent = locSpawnBtn
Instance.new("UICorner", locLoadingDot).CornerRadius = UDim.new(1, 0)

-- ==================== Teleport Tab ====================
local tpContent = tabContents["Teleport"]

local teleportButtons = {
    {name = "Gun", action = "gun"},
    {name = "Maintenance", pos = CFrame.new(172.34, 23.10, -143.87)},
    {name = "Security", pos = CFrame.new(224.47, 23.10, -167.90)},
    {name = "OC Lockers", pos = CFrame.new(137.60, 23.10, -169.93)},
    {name = "RIOT Lockers", pos = CFrame.new(165.63, 23.10, -192.25)},
    {name = "Ventilation", pos = CFrame.new(76.96, -7.02, -19.21)},
    {name = "Maximum", pos = CFrame.new(99.85, -8.87, -156.13)},
    {name = "Generator", pos = CFrame.new(100.95, -8.82, -57.59)},
    {name = "Outside", pos = CFrame.new(350.22, 5.40, -171.09)},
    {name = "Escape Base", pos = CFrame.new(749.02, -0.97, -470.45)},
    {name = "Escape", pos = CFrame.new(307.06, 5.40, -177.88)},
    {name = "Keycard (💳)", pos = CFrame.new(-13.36, 22.13, -27.47)},
    {name = "GAS STATION", pos = CFrame.new(274.30, 6.21, -612.77)},
    {name = "armory", pos = CFrame.new(189.40, 23.10, -214.47)},
    {name = "BARN", pos = CFrame.new(43.68, 10.37, 395.04)},
    {name = "R&D", pos = CFrame.new(-182.35, -85.90, 158.07)}
}

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1,0,1,0)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 6
tpScroll.ScrollBarImageColor3 = Color3.fromRGB(43, 2, 69)
tpScroll.Parent = tpContent

local tpList = Instance.new("UIListLayout")
tpList.Padding = UDim.new(0,8)
tpList.Parent = tpScroll

-- زر Keycard مع السهم والقائمة المنسدلة
local function createStyledTPButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,50)
    btn.BackgroundColor3 = Color3.fromRGB(22, 1, 35) -- 160123
    btn.BackgroundTransparency = 0.2
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 24
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    btn.Parent = tpScroll
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0,10)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(40, 40, 40)
    
    -- تأثيرات الماوس
    btn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
    end)
    
    return btn
end

local keycardBtn = createStyledTPButton("Keycard ▾")
keycardBtn.Position = UDim2.new(0.025, 0, 0, 0)

-- السهم الصغير
local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 20, 0, 20)
arrow.Position = UDim2.new(1, -30, 0.5, -10)
arrow.BackgroundTransparency = 1
arrow.Text = "▼"
arrow.TextColor3 = Color3.fromRGB(220, 220, 220)
arrow.TextSize = 16
arrow.Font = Enum.Font.GothamBold
arrow.Parent = keycardBtn

-- القائمة المنسدلة (مخفية في البداية)
local dropdownMenu = Instance.new("Frame")
dropdownMenu.Size = UDim2.new(0.95, 0, 0, 160)
dropdownMenu.Position = UDim2.new(0.025, 0, 0, 55)
dropdownMenu.BackgroundColor3 = Color3.fromRGB(15, 0, 25)
dropdownMenu.BackgroundTransparency = 0.1
dropdownMenu.Visible = false
dropdownMenu.Parent = tpScroll

local dropdownCorner = Instance.new("UICorner", dropdownMenu)
dropdownCorner.CornerRadius = UDim.new(0,10)

local dropdownStroke = Instance.new("UIStroke", dropdownMenu)
dropdownStroke.Thickness = 2
dropdownStroke.Color = Color3.fromRGB(43, 2, 69)

local menuList = Instance.new("UIListLayout")
menuList.Padding = UDim.new(0, 2)
menuList.Parent = dropdownMenu

-- أزرار أنواع الكي كارد
local keycardTypes = {
    "Director Keycard",
    "Employee Keycard", 
    "Corrections Keycard"
}

local keycardButtons = {}

for i, cardType in ipairs(keycardTypes) do
    local cardBtn = Instance.new("TextButton")
    cardBtn.Size = UDim2.new(0.95, 0, 0, 50)
    cardBtn.Position = UDim2.new(0.025, 0, 0, (i-1)*52)
    cardBtn.BackgroundColor3 = Color3.fromRGB(22, 1, 35)
    cardBtn.BackgroundTransparency = 0.2
    cardBtn.Text = cardType
    cardBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    cardBtn.TextSize = 18
    cardBtn.Font = Enum.Font.Gotham
    cardBtn.AutoButtonColor = false
    cardBtn.Parent = dropdownMenu
    
    local cardCorner = Instance.new("UICorner", cardBtn)
    cardCorner.CornerRadius = UDim.new(0,8)
    
    local cardStroke = Instance.new("UIStroke", cardBtn)
    cardStroke.Thickness = 2
    cardStroke.Color = Color3.fromRGB(40, 40, 40)
    
    -- تأثيرات الماوس
    cardBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(cardBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    cardBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(cardBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            TextColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
    end)
    
    cardBtn.MouseButton1Click:Connect(function()
        selectedKeycardType = cardType
        keycardBtn.Text = "Keycard: " .. cardType .. " ▾"
        dropdownMenu.Visible = false
        
        -- بدء عملية السرقة
        pcall(stealKeycard)
    end)
    
    table.insert(keycardButtons, cardBtn)
end

-- التحكم في فتح/إغلاق القائمة المنسدلة
local isDropdownOpen = false
keycardBtn.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    dropdownMenu.Visible = isDropdownOpen
    
    if isDropdownOpen then
        keycardBtn.Text = "Keycard ▴"
        arrow.Text = "▲"
    else
        keycardBtn.Text = selectedKeycardType and ("Keycard: " .. selectedKeycardType .. " ▾") or "Keycard ▾"
        arrow.Text = "▼"
    end
end)

-- إضافة بقية أزرار التيليبورت
for _, tp in ipairs(teleportButtons) do
    local btn = createStyledTPButton(tp.name)

    if tp.action == "gun" then
        btn.MouseButton1Click:Connect(function()
            pcall(collectGunsFromArmory)
        end)
    elseif tp.pos then
        btn.MouseButton1Click:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = tp.pos
            end
        end)
    end
end

tpScroll.CanvasSize = UDim2.new(0,0,0,(#teleportButtons + 1) * 58 + 160)

-- ===================================
-- دالة الدروب النهائية
-- ===================================
local function RunDrop(dropCFrame, camDropPos, armoryPos)
    -- ★★★ تشغيل سكربت فتح الجدران مرة واحدة فقط ★★★
    activateWallScript()
    
    task.wait(0.10)
    
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local oldCamType = camera.CameraType
    local oldCamSubject = camera.CameraSubject
    local oldFOV = camera.FieldOfView
    local camConnection
    
    local function FixCamera()
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = Enum.CameraType.Scriptable
        camera.FieldOfView = 120
        camConnection = RunService.RenderStepped:Connect(function()
            camera.CFrame = camDropPos
        end)
    end

    player.CharacterAdded:Once(function()
        if camConnection then camConnection:Disconnect() end
        camera.CameraType = oldCamType
        camera.CameraSubject = oldCamSubject
        camera.FieldOfView = oldFOV
    end)

    FixCamera()
    hrp.CFrame = armoryPos
    task.wait(0.4)

    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") then
            task.spawn(function() fireproximityprompt(v) end)
        end
    end

    task.wait(1.1)
    hrp.CFrame = dropCFrame

    local posFix = RunService.Heartbeat:Connect(function()
        hrp.CFrame = dropCFrame
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.RotVelocity = Vector3.new(0,0,0)
    end)

    task.wait(0.4)

    for _, tool in player.Backpack:GetChildren() do
        if tool:IsA("Tool") then
            tool.Parent = char
            task.wait(0.25)
            for _, obj in tool:GetDescendants() do
                if obj:IsA("RemoteEvent") and (string.find(string.lower(obj.Name), "drop") or string.find(string.lower(obj.Name), "send") or string.find(string.lower(obj.Name), "key")) then
                    obj:FireServer()
                    break
                end
            end
            task.wait(0.35)
        end
    end

    posFix:Disconnect()
    hrp.CFrame = FinalFarmPos

    local finalFix = RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent then
            hrp.CFrame = FinalFarmPos
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
    end)

    task.wait(0.5)
    finalFix:Disconnect()

    hum:ChangeState(Enum.HumanoidStateType.Dead)
end

local function RunMin() RunDrop(MinDropCFrame, MinCamDropPos, MinArmoryPos) end
local function RunMax() RunDrop(MaxDropCFrame, MaxCamDropPos, MaxArmoryPos) end
local function RunBooking() RunDrop(BookingDropCFrame, BookingCamDropPos, MaxArmoryPos) end

local function executeSelected(tabType)
    if tabType == "Locations" and selectedLocation then
        if selectedLocation == "Min" then RunMin()
        elseif selectedLocation == "Max" then RunMax()
        elseif selectedLocation == "Booking" then RunBooking() end
    end
end

local function startLoadingAnimation(dot)
    dot.Visible = true
    local tween = TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Transparency = 1})
    tween:Play()
    return tween
end

local function startCooldown(tabType)
    local dot = tabType == "Locations" and locLoadingDot
    local tween = startLoadingAnimation(dot)
    task.wait(cooldownTime)
    tween:Cancel()
    dot.Visible = false
    dot.Transparency = 0

    if tabType == "Locations" then isOnCooldownLocations = false end
end

locSpawnBtn.MouseButton1Click:Connect(function()
    if not isOnCooldownLocations and selectedLocation then
        isOnCooldownLocations = true
        task.spawn(function() executeSelected("Locations") end)
        task.spawn(function() startCooldown("Locations") end)
    end
end)
