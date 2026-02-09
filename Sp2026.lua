local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- ===================================
-- دالة تحميل الصورة المخصصة (تعمل في Synapse, Script-Ware, Fluxus, Comet, إلخ)
-- ===================================
local HttpRequest = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or request or http_request

local function LoadCustomImage(url, filename)
    if not isfolder then
        return url
    end
    
    if not isfolder("MyGuiImages") then
        makefolder("MyGuiImages")
    end
    
    local path = "MyGuiImages/" .. filename
    
    if not isfile(path) then
        local success, result = pcall(function()
            local response = HttpRequest({Url = url, Method = "GET"})
            if response and response.StatusCode == 200 then
                writefile(path, response.Body)
                return true
            end
            return false
        end)
        
        if not success then
            return url
        end
    end
    
    task.wait(0.1)
    
    if getcustomasset then
        return getcustomasset(path)
    else
        return url
    end
end

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
        end
    end
    
    task.wait(1)
    activateAllProximityPrompts()
    task.wait(1)
    
    hrp.CFrame = savedPosition
    camera.CameraType = savedCameraType
    camera.CameraSubject = savedCameraSubject
    camera.FieldOfView = savedFOV
    
    isStealingKeycard = false
    
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
-- إنشاء الواجهة الرسومية
-- ===================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GunSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 400)
mainFrame.Position = UDim2.new(0, 20, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

-- إضافة تدرج فوشيا بدلاً من الأسود
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(199, 21, 133))
})
gradient.Transparency = NumberSequence.new(0.2)
gradient.Rotation = 45
gradient.Parent = mainFrame

-- تأثير التألق البسيط
local glassEffect = Instance.new("Frame")
glassEffect.Size = UDim2.new(1, 0, 0.15, 0)
glassEffect.Position = UDim2.new(0, 0, 0, 0)
glassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glassEffect.BackgroundTransparency = 0.97
glassEffect.BorderSizePixel = 0
glassEffect.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(255, 105, 180)
mainStroke.Transparency = 0.2
mainStroke.Parent = mainFrame

-- التبويبات
local tabNames = {"Locations", "Teleport", "Player"}
local tabButtons = {}
local tabContents = {}

local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0.9, 0, 0, 35)
tabsFrame.Position = UDim2.new(0.05, 0, 0, 10)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame

local tabPadding = 3
local totalWidth = 260 * 0.9
local buttonWidth = (totalWidth - (#tabNames - 1) * tabPadding) / #tabNames

-- دالة لإنشاء تدرج الأزرار
local function createButtonGradient(button, isSelected)
    local gradient = Instance.new("UIGradient")
    if isSelected then
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 20, 140))
        })
    else
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(199, 21, 133)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 20, 120))
        })
    end
    gradient.Rotation = 90
    gradient.Parent = button
    return gradient
end

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * (buttonWidth + tabPadding), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = tabsFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    createButtonGradient(btn, i == 1)
    
    tabButtons[name] = btn

    local content = Instance.new("Frame")
    content.Size = UDim2.new(0.9, 0, 0, 340)
    content.Position = UDim2.new(0.05, 0, 0, 55)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    tabContents[name] = content
end

for _, name in ipairs(tabNames) do
    tabButtons[name].MouseButton1Click:Connect(function()
        for k, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
            for _, child in pairs(b:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end
            createButtonGradient(b, false)
            tabContents[k].Visible = false
        end
        tabButtons[name].BackgroundColor3 = Color3.fromRGB(255, 182, 193)
        for _, child in pairs(tabButtons[name]:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy()
            end
        end
        createButtonGradient(tabButtons[name], true)
        tabContents[name].Visible = true
    end)
end

-- ==================== Locations Tab ====================
local locContent = tabContents["Locations"]

local function createLocationButton(name, position, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = locContent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    createButtonGradient(btn, false)
    
    return btn
end

local minBtn = createLocationButton("Min Lobby", 0, 10)
local maxBtn = createLocationButton("Max", 0, 70)
local bookingBtn = createLocationButton("Booking", 0, 130)

-- تتبع الأزرار المحددة
local selectedLocationButton = nil

local function selectLocationButton(btn)
    if selectedLocationButton then
        selectedLocationButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        for _, child in pairs(selectedLocationButton:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy()
            end
        end
        createButtonGradient(selectedLocationButton, false)
    end
    
    selectedLocationButton = btn
    btn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    for _, child in pairs(btn:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end
    createButtonGradient(btn, true)
end

minBtn.MouseButton1Click:Connect(function()
    selectLocationButton(minBtn)
    selectedLocation = "Min"
end)

maxBtn.MouseButton1Click:Connect(function()
    selectLocationButton(maxBtn)
    selectedLocation = "Max"
end)

bookingBtn.MouseButton1Click:Connect(function()
    selectLocationButton(bookingBtn)
    selectedLocation = "Booking"
end)

local locSpawnBtn = Instance.new("TextButton")
locSpawnBtn.Size = UDim2.new(0.9, 0, 0, 40)
locSpawnBtn.Position = UDim2.new(0.05, 0, 0, 195)
locSpawnBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
locSpawnBtn.Text = "Spawn"
locSpawnBtn.TextColor3 = Color3.new(1,1,1)
locSpawnBtn.TextSize = 22
locSpawnBtn.Font = Enum.Font.GothamBold
locSpawnBtn.Parent = locContent
Instance.new("UICorner", locSpawnBtn).CornerRadius = UDim.new(0, 10)

createButtonGradient(locSpawnBtn, false)

local locLoadingDot = Instance.new("Frame")
locLoadingDot.Size = UDim2.new(0, 14, 0, 14)
locLoadingDot.Position = UDim2.new(1, -25, 0.5, -7)
locLoadingDot.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
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
tpScroll.ScrollBarThickness = 4
tpScroll.Parent = tpContent

local tpList = Instance.new("UIListLayout")
tpList.Padding = UDim.new(0,5)
tpList.Parent = tpScroll

-- زر Keycard مع السهم والقائمة المنسدلة
local keycardBtn = Instance.new("TextButton")
keycardBtn.Size = UDim2.new(0.95,0,0,35)
keycardBtn.Position = UDim2.new(0.025, 0, 0, 0)
keycardBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
keycardBtn.Text = "Keycard ▾"
keycardBtn.TextColor3 = Color3.new(1,1,1)
keycardBtn.TextSize = 16
keycardBtn.Font = Enum.Font.Gotham
keycardBtn.AutoButtonColor = false
keycardBtn.Parent = tpScroll
Instance.new("UICorner", keycardBtn).CornerRadius = UDim.new(0,6)

createButtonGradient(keycardBtn, false)

-- السهم الصغير
local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 14, 0, 14)
arrow.Position = UDim2.new(1, -22, 0.5, -7)
arrow.BackgroundTransparency = 1
arrow.Text = "▼"
arrow.TextColor3 = Color3.new(1,1,1)
arrow.TextSize = 10
arrow.Font = Enum.Font.GothamBold
arrow.Parent = keycardBtn

-- القائمة المنسدلة
local dropdownMenu = Instance.new("Frame")
dropdownMenu.Size = UDim2.new(0.95, 0, 0, 115)
dropdownMenu.Position = UDim2.new(0.025, 0, 0, 40)
dropdownMenu.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
dropdownMenu.Visible = false
dropdownMenu.Parent = tpScroll
Instance.new("UICorner", dropdownMenu).CornerRadius = UDim.new(0,6)

-- تدرج للقائمة المنسدلة
local dropdownGradient = Instance.new("UIGradient")
dropdownGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 20, 140))
})
dropdownGradient.Rotation = 90
dropdownGradient.Parent = dropdownMenu

local dropdownStroke = Instance.new("UIStroke")
dropdownStroke.Thickness = 1
dropdownStroke.Color = Color3.fromRGB(255, 20, 147)
dropdownStroke.Transparency = 0.5
dropdownStroke.Parent = dropdownMenu

local menuList = Instance.new("UIListLayout")
menuList.Padding = UDim.new(0, 1.5)
menuList.Parent = dropdownMenu

-- أزرار أنواع الكي كارد
local keycardTypes = {
    "Director Keycard",
    "Employee Keycard", 
    "Corrections Keycard"
}

local keycardButtons = {}
local selectedKeycardButton = nil

for i, cardType in ipairs(keycardTypes) do
    local cardBtn = Instance.new("TextButton")
    cardBtn.Size = UDim2.new(0.95, 0, 0, 35)
    cardBtn.Position = UDim2.new(0.025, 0, 0, (i-1)*36)
    cardBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    cardBtn.Text = cardType
    cardBtn.TextColor3 = Color3.new(1,1,1)
    cardBtn.TextSize = 13
    cardBtn.Font = Enum.Font.Gotham
    cardBtn.AutoButtonColor = false
    cardBtn.Parent = dropdownMenu
    Instance.new("UICorner", cardBtn).CornerRadius = UDim.new(0,5)
    
    createButtonGradient(cardBtn, false)
    
    cardBtn.MouseButton1Click:Connect(function()
        if selectedKeycardButton then
            selectedKeycardButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
            for _, child in pairs(selectedKeycardButton:GetChildren()) do
                if child:IsA("UIGradient") then
                    child:Destroy()
                end
            end
            createButtonGradient(selectedKeycardButton, false)
        end
        
        selectedKeycardButton = cardBtn
        selectedKeycardType = cardType
        keycardBtn.Text = "Keycard: " .. cardType .. " ▾"
        dropdownMenu.Visible = false
        
        cardBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
        for _, child in pairs(cardBtn:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy()
            end
        end
        createButtonGradient(cardBtn, true)
        
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
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,35)
    btn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    btn.Text = tp.name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    btn.Parent = tpScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    
    createButtonGradient(btn, false)

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

tpScroll.CanvasSize = UDim2.new(0,0,0,(#teleportButtons + 1) * 40 + 115)

-- ==================== Player Tab ====================
local playerContent = tabContents["Player"]

-- ScrollingFrame جديد لقسم البلاير
local playerScrollMain = Instance.new("ScrollingFrame")
playerScrollMain.Size = UDim2.new(1, 0, 1, 0)
playerScrollMain.BackgroundTransparency = 1
playerScrollMain.ScrollBarThickness = 4
playerScrollMain.Parent = playerContent

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 10)
playerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerListLayout.Parent = playerScrollMain

-- صورة البروفايل الدائرية
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0.9, 0, 0, 100)
profileFrame.Position = UDim2.new(0.05, 0, 0, 10)
profileFrame.BackgroundTransparency = 1
profileFrame.Parent = playerScrollMain

local profileImageContainer = Instance.new("Frame")
profileImageContainer.Size = UDim2.new(0, 70, 0, 70)
profileImageContainer.Position = UDim2.new(0.5, -35, 0, 0)
profileImageContainer.BackgroundTransparency = 1
profileImageContainer.Parent = profileFrame

local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(1, 0, 1, 0)
profileImage.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
profileImage.Parent = profileImageContainer
Instance.new("UICorner", profileImage).CornerRadius = UDim.new(1, 0)

-- تدرج للصورة
local profileGradient = Instance.new("UIGradient")
profileGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(199, 21, 133)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 20, 120))
})
profileGradient.Rotation = 90
profileGradient.Parent = profileImage

-- تحميل صورة البروفايل الحقيقية
task.spawn(function()
    local userId = player.UserId
    local success, result = pcall(function()
        local thumbnailType = Enum.ThumbnailType.HeadShot
        local thumbnailSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
        return content
    end)
    
    if success and result then
        profileImage.Image = result
    else
        local alternativeUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", userId)
        local customImage = LoadCustomImage(alternativeUrl, "profile_" .. userId .. ".png")
        profileImage.Image = customImage
    end
end)

local profileStroke = Instance.new("UIStroke")
profileStroke.Thickness = 1.5
profileStroke.Color = Color3.fromRGB(255, 182, 193)
profileStroke.Parent = profileImage

-- إضافة قسم جديد للـ ScrollingFrame
local materialsFrame = Instance.new("Frame")
materialsFrame.Size = UDim2.new(0.9, 0, 0, 200)
materialsFrame.Position = UDim2.new(0.05, 0, 0, 110)
materialsFrame.BackgroundTransparency = 1
materialsFrame.Parent = playerScrollMain

local materialsTitle = Instance.new("TextLabel")
materialsTitle.Size = UDim2.new(1, 0, 0, 30)
materialsTitle.Position = UDim2.new(0, 0, 0, 0)
materialsTitle.BackgroundTransparency = 1
materialsTitle.Text = "Materials"
materialsTitle.TextColor3 = Color3.new(1, 1, 1)
materialsTitle.TextSize = 16
materialsTitle.Font = Enum.Font.GothamBold
materialsTitle.TextXAlignment = Enum.TextXAlignment.Left
materialsTitle.Parent = materialsFrame

-- GridLayout للمواد
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.45, 0, 0, 80)
gridLayout.CellPadding = UDim2.new(0.05, 0, 0.05, 0)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
gridLayout.Parent = materialsFrame

-- بيانات المواد
local materialsData = {
    {
        name = "Metal",
        imageUrl = "https://i.imgur.com/hZXn5h7.png",
        filename = "metal.png",
        selected = false
    },
    {
        name = "Plastic",
        imageUrl = "https://i.imgur.com/tzy2Dtx.png",
        filename = "plastic.png",
        selected = false
    },
    {
        name = "Pants",
        imageUrl = "https://i.imgur.com/rb5w2bV.png",
        filename = "pants.png",
        selected = false
    },
    {
        name = "Tshirt",
        imageUrl = "https://i.imgur.com/w8K9RoO.png",
        filename = "tshirt.png",
        selected = false
    },
    -- إضافة مواد إضافية مستقبلاً
    {
        name = "Wood",
        imageUrl = "",
        filename = "wood.png",
        selected = false
    },
    {
        name = "Glass",
        imageUrl = "",
        filename = "glass.png",
        selected = false
    }
}

local materialButtons = {}

-- دالة لتحديد الدائرة
local function updateSelectionCircle(circle, stroke, selected)
    if selected then
        circle.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
        circle.BackgroundTransparency = 0
        stroke.Transparency = 1
    else
        circle.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        circle.BackgroundTransparency = 1
        stroke.Transparency = 0
    end
end

-- إنشاء أزرار المواد
for i, material in ipairs(materialsData) do
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 1, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = materialsFrame
    
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0.8, 0, 0.65, 0)
    button.Position = UDim2.new(0.1, 0, 0.05, 0)
    button.BackgroundTransparency = 1
    button.ScaleType = Enum.ScaleType.Fit
    button.Parent = buttonContainer
    
    if material.imageUrl and material.imageUrl ~= "" then
        task.spawn(function()
            local customImage = LoadCustomImage(material.imageUrl, material.filename)
            button.Image = customImage
        end)
    else
        button.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = material.name
        text.TextColor3 = Color3.new(1, 1, 1)
        text.TextSize = 12
        text.Font = Enum.Font.GothamBold
        text.Parent = button
    end
    
    -- الدائرة
    local circleContainer = Instance.new("Frame")
    circleContainer.Size = UDim2.new(0, 8, 0, 8)
    circleContainer.Position = UDim2.new(0.85, -4, 0.05, -4)
    circleContainer.BackgroundTransparency = 1
    circleContainer.Parent = button
    
    local selectionCircle = Instance.new("Frame")
    selectionCircle.Size = UDim2.new(1, 0, 1, 0)
    selectionCircle.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    selectionCircle.BackgroundTransparency = 1
    selectionCircle.Parent = circleContainer
    Instance.new("UICorner", selectionCircle).CornerRadius = UDim.new(1, 0)
    
    local circleStroke = Instance.new("UIStroke")
    circleStroke.Thickness = 1
    circleStroke.Color = Color3.fromRGB(255, 20, 147)
    circleStroke.Transparency = 0
    circleStroke.Parent = selectionCircle
    
    -- النص
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.2, 0)
    label.Position = UDim2.new(0, 0, 0.7, 0)
    label.BackgroundTransparency = 1
    label.Text = material.name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.Parent = buttonContainer
    
    materialButtons[i] = {
        container = buttonContainer,
        button = button,
        circle = selectionCircle,
        stroke = circleStroke,
        data = material
    }
    
    button.MouseButton1Click:Connect(function()
        for j, btn in ipairs(materialButtons) do
            btn.data.selected = (j == i)
            updateSelectionCircle(btn.circle, btn.stroke, btn.data.selected)
        end
        
        game.StarterGui:SetCore("SendNotification", {
            Title = material.name,
            Text = material.name .. " material selected!",
            Duration = 1.5
        })
    end)
    
    updateSelectionCircle(selectionCircle, circleStroke, material.selected)
end

-- قسم جديد فارغ لإضافة أزرار مستقبلية
local extraSection = Instance.new("Frame")
extraSection.Size = UDim2.new(0.9, 0, 0, 150)
extraSection.Position = UDim2.new(0.05, 0, 0, 320)
extraSection.BackgroundTransparency = 1
extraSection.Parent = playerScrollMain

local extraTitle = Instance.new("TextLabel")
extraTitle.Size = UDim2.new(1, 0, 0, 30)
extraTitle.Position = UDim2.new(0, 0, 0, 0)
extraTitle.BackgroundTransparency = 1
extraTitle.Text = "More Features (Coming Soon)"
extraTitle.TextColor3 = Color3.new(1, 1, 1)
extraTitle.TextSize = 14
extraTitle.Font = Enum.Font.GothamBold
extraTitle.TextXAlignment = Enum.TextXAlignment.Left
extraTitle.Parent = extraSection

-- ضبط حجم الـ Canvas
playerScrollMain.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 50)

-- ===================================
-- دالة الدروب النهائية
-- ===================================
local function RunDrop(dropCFrame, camDropPos, armoryPos)
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
