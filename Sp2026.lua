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
        -- إذا لم تكن الدوال المتقدمة متوفرة، نستخدم رابط الصورة مباشرة
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
    
    task.wait(0.1)  -- انتظار بسيط
    
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
-- إنشاء الواجهة الرسومية (220x500)
-- ===================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GunSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 500)
mainFrame.Position = UDim2.new(0, 20, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromHex("#061733")
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHex("#061733")),
    ColorSequenceKeypoint.new(1, Color3.fromHex("#075bb4"))
})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1
mainStroke.Color = Color3.fromHex("#075bb4")
mainStroke.Parent = mainFrame

-- Header
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.BackgroundColor3 = Color3.fromHex("#061733")
headerFrame.BackgroundTransparency = 0.4
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHex("#061733")),
    ColorSequenceKeypoint.new(1, Color3.fromHex("#075bb4"))
})
headerGradient.Rotation = 90
headerGradient.Parent = headerFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 140, 0, 18)
titleLabel.Position = UDim2.new(0, 10, 0, 8)
titleLabel.Text = "GUN SPAWNER UI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = headerFrame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundColor3 = Color3.fromHex("#061733")
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Scrolling Frame الرئيسي لكل المحتوى
local mainScroll = Instance.new("ScrollingFrame")
mainScroll.Size = UDim2.new(1, 0, 1, 0)
mainScroll.BackgroundTransparency = 1
mainScroll.BorderSizePixel = 0
mainScroll.ScrollBarThickness = 6
mainScroll.ScrollBarImageColor3 = Color3.fromHex("#075bb4")
mainScroll.Parent = contentFrame

local mainList = Instance.new("UIListLayout")
mainList.Padding = UDim.new(0, 10)
mainList.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainList.SortOrder = Enum.SortOrder.LayoutOrder
mainList.Parent = mainScroll

mainList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    mainScroll.CanvasSize = UDim2.new(0, 0, 0, mainList.AbsoluteContentSize.Y + 20)
end)

-- ==================== Locations Section ====================
local locSection = Instance.new("Frame")
locSection.Size = UDim2.new(1, -10, 0, 180)
locSection.BackgroundColor3 = Color3.fromHex("#0a2a5a")
locSection.BackgroundTransparency = 0.65
locSection.LayoutOrder = 1
locSection.Parent = mainScroll

local locSectionTitle = Instance.new("TextLabel")
locSectionTitle.Size = UDim2.new(1, 0, 0, 30)
locSectionTitle.Position = UDim2.new(0, 0, 0, 5)
locSectionTitle.Text = "LOCATIONS"
locSectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
locSectionTitle.Font = Enum.Font.GothamBold
locSectionTitle.TextSize = 18
locSectionTitle.BackgroundTransparency = 1
locSectionTitle.Parent = locSection

local locGrid = Instance.new("UIGridLayout")
locGrid.CellSize = UDim2.new(1, -10, 0, 35)
locGrid.CellPadding = UDim2.new(0, 0, 0, 8)
locGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
locGrid.VerticalAlignment = Enum.VerticalAlignment.Top
locGrid.Parent = locSection

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.9, 0, 0, 35)
minBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
minBtn.BackgroundTransparency = 0.65
minBtn.Text = "Min Lobby"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = locSection
minBtn.LayoutOrder = 1

local maxBtn = Instance.new("TextButton")
maxBtn.Size = UDim2.new(0.9, 0, 0, 35)
maxBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
maxBtn.BackgroundTransparency = 0.65
maxBtn.Text = "Max"
maxBtn.TextColor3 = Color3.new(1,1,1)
maxBtn.TextSize = 16
maxBtn.Font = Enum.Font.GothamBold
maxBtn.Parent = locSection
maxBtn.LayoutOrder = 2

local bookingBtn = Instance.new("TextButton")
bookingBtn.Size = UDim2.new(0.9, 0, 0, 35)
bookingBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
bookingBtn.BackgroundTransparency = 0.65
bookingBtn.Text = "Booking"
bookingBtn.TextColor3 = Color3.new(1,1,1)
bookingBtn.TextSize = 16
bookingBtn.Font = Enum.Font.GothamBold
bookingBtn.Parent = locSection
bookingBtn.LayoutOrder = 3

local locSpawnBtn = Instance.new("TextButton")
locSpawnBtn.Size = UDim2.new(0.9, 0, 0, 40)
locSpawnBtn.BackgroundColor3 = Color3.fromHex("#075bb4")
locSpawnBtn.BackgroundTransparency = 0.5
locSpawnBtn.Text = "SPAWN"
locSpawnBtn.TextColor3 = Color3.new(1,1,1)
locSpawnBtn.TextSize = 18
locSpawnBtn.Font = Enum.Font.GothamBold
locSpawnBtn.Parent = locSection
locSpawnBtn.LayoutOrder = 4

local locLoadingDot = Instance.new("Frame")
locLoadingDot.Size = UDim2.new(0, 12, 0, 12)
locLoadingDot.Position = UDim2.new(1, -25, 0.5, -6)
locLoadingDot.BackgroundColor3 = Color3.fromHex("#22B365")
locLoadingDot.Visible = false
locLoadingDot.Parent = locSpawnBtn
Instance.new("UICorner", locLoadingDot).CornerRadius = UDim.new(1, 0)

minBtn.MouseButton1Click:Connect(function()
    minBtn.BackgroundColor3 = Color3.fromHex("#075bb4")
    maxBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    bookingBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    selectedLocation = "Min"
end)

maxBtn.MouseButton1Click:Connect(function()
    maxBtn.BackgroundColor3 = Color3.fromHex("#075bb4")
    minBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    bookingBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    selectedLocation = "Max"
end)

bookingBtn.MouseButton1Click:Connect(function()
    bookingBtn.BackgroundColor3 = Color3.fromHex("#075bb4")
    minBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    maxBtn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    selectedLocation = "Booking"
end)

-- ==================== Teleport Section ====================
local tpSection = Instance.new("Frame")
tpSection.Size = UDim2.new(1, -10, 0, 350)
tpSection.BackgroundColor3 = Color3.fromHex("#0a2a5a")
tpSection.BackgroundTransparency = 0.65
tpSection.LayoutOrder = 2
tpSection.Parent = mainScroll

local tpSectionTitle = Instance.new("TextLabel")
tpSectionTitle.Size = UDim2.new(1, 0, 0, 30)
tpSectionTitle.Position = UDim2.new(0, 0, 0, 5)
tpSectionTitle.Text = "TELEPORT"
tpSectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpSectionTitle.Font = Enum.Font.GothamBold
tpSectionTitle.TextSize = 18
tpSectionTitle.BackgroundTransparency = 1
tpSectionTitle.Parent = tpSection

local tpScroll = Instance.new("ScrollingFrame")
tpScroll.Size = UDim2.new(1, -10, 0, 300)
tpScroll.Position = UDim2.new(0, 5, 0, 35)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 6
tpScroll.ScrollBarImageColor3 = Color3.fromHex("#075bb4")
tpScroll.Parent = tpSection

local tpList = Instance.new("UIListLayout")
tpList.Padding = UDim.new(0, 8)
tpList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tpList.Parent = tpScroll

tpList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tpScroll.CanvasSize = UDim2.new(0, 0, 0, tpList.AbsoluteContentSize.Y + 10)
end)

-- زر Keycard مع القائمة المنسدلة
local keycardContainer = Instance.new("Frame")
keycardContainer.Size = UDim2.new(0.95, 0, 0, 35)
keycardContainer.BackgroundColor3 = Color3.fromHex("#0a2a5a")
keycardContainer.BackgroundTransparency = 0.65
keycardContainer.Parent = tpScroll

local keycardBtn = Instance.new("TextButton")
keycardBtn.Size = UDim2.new(1, 0, 1, 0)
keycardBtn.BackgroundTransparency = 1
keycardBtn.Text = "KEYCARD ▾"
keycardBtn.TextColor3 = Color3.new(1,1,1)
keycardBtn.TextSize = 16
keycardBtn.Font = Enum.Font.GothamBold
keycardBtn.AutoButtonColor = false
keycardBtn.Parent = keycardContainer

local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 20, 0, 20)
arrow.Position = UDim2.new(1, -25, 0.5, -10)
arrow.BackgroundTransparency = 1
arrow.Text = "▼"
arrow.TextColor3 = Color3.new(1,1,1)
arrow.TextSize = 12
arrow.Font = Enum.Font.GothamBold
arrow.Parent = keycardContainer

local dropdownMenu = Instance.new("Frame")
dropdownMenu.Size = UDim2.new(0.95, 0, 0, 120)
dropdownMenu.Position = UDim2.new(0, 2.5, 1, 5)
dropdownMenu.BackgroundColor3 = Color3.fromHex("#061733")
dropdownMenu.Visible = false
dropdownMenu.Parent = keycardContainer

local menuList = Instance.new("UIListLayout")
menuList.Padding = UDim.new(0, 2)
menuList.Parent = dropdownMenu

-- أزرار أنواع الكي كارد
local keycardTypes = {
    "Director Keycard",
    "Employee Keycard", 
    "Corrections Keycard"
}

for i, cardType in ipairs(keycardTypes) do
    local cardBtn = Instance.new("TextButton")
    cardBtn.Size = UDim2.new(1, 0, 0, 38)
    cardBtn.BackgroundColor3 = Color3.fromHex("#075bb4")
    cardBtn.BackgroundTransparency = 0.5
    cardBtn.Text = cardType
    cardBtn.TextColor3 = Color3.new(1,1,1)
    cardBtn.TextSize = 14
    cardBtn.Font = Enum.Font.Gotham
    cardBtn.AutoButtonColor = false
    cardBtn.Parent = dropdownMenu
    
    cardBtn.MouseButton1Click:Connect(function()
        selectedKeycardType = cardType
        keycardBtn.Text = "KEYCARD: " .. cardType .. " ▾"
        dropdownMenu.Visible = false
        arrow.Text = "▼"
        
        pcall(stealKeycard)
    end)
end

-- التحكم في فتح/إغلاق القائمة المنسدلة
local isDropdownOpen = false
keycardBtn.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    dropdownMenu.Visible = isDropdownOpen
    
    if isDropdownOpen then
        arrow.Text = "▲"
    else
        arrow.Text = "▼"
    end
end)

-- أزرار التيليبورت الأساسية
local teleportButtons = {
    {name = "GUN", action = "gun"},
    {name = "MAINTENANCE", pos = CFrame.new(172.34, 23.10, -143.87)},
    {name = "SECURITY", pos = CFrame.new(224.47, 23.10, -167.90)},
    {name = "OC LOCKERS", pos = CFrame.new(137.60, 23.10, -169.93)},
    {name = "RIOT LOCKERS", pos = CFrame.new(165.63, 23.10, -192.25)},
    {name = "VENTILATION", pos = CFrame.new(76.96, -7.02, -19.21)},
    {name = "MAXIMUM", pos = CFrame.new(99.85, -8.87, -156.13)},
    {name = "GENERATOR", pos = CFrame.new(100.95, -8.82, -57.59)},
    {name = "OUTSIDE", pos = CFrame.new(350.22, 5.40, -171.09)},
    {name = "ESCAPE BASE", pos = CFrame.new(749.02, -0.97, -470.45)},
    {name = "ESCAPE", pos = CFrame.new(307.06, 5.40, -177.88)},
    {name = "GAS STATION", pos = CFrame.new(274.30, 6.21, -612.77)},
    {name = "ARMORY", pos = CFrame.new(189.40, 23.10, -214.47)},
    {name = "BARN", pos = CFrame.new(43.68, 10.37, 395.04)},
    {name = "R&D", pos = CFrame.new(-182.35, -85.90, 158.07)}
}

for i, tp in ipairs(teleportButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromHex("#0a2a5a")
    btn.BackgroundTransparency = 0.65
    btn.Text = tp.name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.AutoButtonColor = false
    btn.Parent = tpScroll

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

-- ==================== Player Section ====================
local playerSection = Instance.new("Frame")
playerSection.Size = UDim2.new(1, -10, 0, 280)
playerSection.BackgroundColor3 = Color3.fromHex("#0a2a5a")
playerSection.BackgroundTransparency = 0.65
playerSection.LayoutOrder = 3
playerSection.Parent = mainScroll

local playerSectionTitle = Instance.new("TextLabel")
playerSectionTitle.Size = UDim2.new(1, 0, 0, 30)
playerSectionTitle.Position = UDim2.new(0, 0, 0, 5)
playerSectionTitle.Text = "PLAYER"
playerSectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
playerSectionTitle.Font = Enum.Font.GothamBold
playerSectionTitle.TextSize = 18
playerSectionTitle.BackgroundTransparency = 1
playerSectionTitle.Parent = playerSection

-- صورة البروفايل
local profileContainer = Instance.new("Frame")
profileContainer.Size = UDim2.new(0, 70, 0, 70)
profileContainer.Position = UDim2.new(0.5, -35, 0, 40)
profileContainer.BackgroundTransparency = 1
profileContainer.Parent = playerSection

local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(1, 0, 1, 0)
profileImage.BackgroundColor3 = Color3.fromHex("#0a2a5a")
profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
profileImage.Parent = profileContainer
Instance.new("UICorner", profileImage).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local userId = player.UserId
    local alternativeUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", userId)
    local customImage = LoadCustomImage(alternativeUrl, "profile_" .. userId .. ".png")
    profileImage.Image = customImage
end)

-- ScrollingFrame لأزرار اللاعب
local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -10, 0, 170)
playerScroll.Position = UDim2.new(0, 5, 0, 120)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 6
playerScroll.ScrollBarImageColor3 = Color3.fromHex("#075bb4")
playerScroll.Parent = playerSection

local playerGrid = Instance.new("UIGridLayout")
playerGrid.CellSize = UDim2.new(0.45, 0, 0, 80)
playerGrid.CellPadding = UDim2.new(0.05, 0, 0.05, 0)
playerGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerGrid.VerticalAlignment = Enum.VerticalAlignment.Top
playerGrid.Parent = playerScroll

playerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerGrid.AbsoluteContentSize.Y + 10)
end)

-- بيانات الأزرار
local playerButtonsData = {
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
    }
}

local playerButtons = {}

-- دالة لتحديث مظهر الدائرة
local function updateSelectionCircle(circle, stroke, selected)
    if selected then
        circle.BackgroundColor3 = Color3.fromHex("#22B365")
        circle.BackgroundTransparency = 0
        stroke.Transparency = 1
    else
        circle.BackgroundColor3 = Color3.fromHex("#22B365")
        circle.BackgroundTransparency = 1
        stroke.Transparency = 0
    end
end

-- إنشاء الأزرار
for i, buttonData in ipairs(playerButtonsData) do
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 1, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = playerScroll
    
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0.8, 0, 0.65, 0)
    button.Position = UDim2.new(0.1, 0, 0.05, 0)
    button.BackgroundTransparency = 1
    button.ScaleType = Enum.ScaleType.Fit
    button.Parent = buttonContainer
    
    -- تحميل الصورة
    if buttonData.imageUrl and buttonData.imageUrl ~= "" then
        task.spawn(function()
            local customImage = LoadCustomImage(buttonData.imageUrl, buttonData.filename)
            button.Image = customImage
        end)
    end
    
    -- الدائرة
    local circleContainer = Instance.new("Frame")
    circleContainer.Size = UDim2.new(0, 12, 0, 12)
    circleContainer.Position = UDim2.new(0.85, -6, 0.05, -6)
    circleContainer.BackgroundTransparency = 1
    circleContainer.Parent = button
    
    local selectionCircle = Instance.new("Frame")
    selectionCircle.Size = UDim2.new(1, 0, 1, 0)
    selectionCircle.BackgroundColor3 = Color3.fromHex("#22B365")
    selectionCircle.BackgroundTransparency = 1
    selectionCircle.Parent = circleContainer
    Instance.new("UICorner", selectionCircle).CornerRadius = UDim.new(1, 0)
    
    local circleStroke = Instance.new("UIStroke")
    circleStroke.Thickness = 1.5
    circleStroke.Color = Color3.fromHex("#22B365")
    circleStroke.Transparency = 0
    circleStroke.Parent = selectionCircle
    
    -- النص
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.2, 0)
    label.Position = UDim2.new(0, 0, 0.8, 0)
    label.BackgroundTransparency = 1
    label.Text = buttonData.name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = buttonContainer
    
    -- تخزين البيانات
    playerButtons[i] = {
        container = buttonContainer,
        button = button,
        circle = selectionCircle,
        stroke = circleStroke,
        data = buttonData
    }
    
    -- حدث النقر
    button.MouseButton1Click:Connect(function()
        for j, btn in ipairs(playerButtons) do
            btn.data.selected = (j == i)
            updateSelectionCircle(btn.circle, btn.stroke, btn.data.selected)
        end
        
        game.StarterGui:SetCore("SendNotification", {
            Title = buttonData.name,
            Text = buttonData.name .. " selected!",
            Duration = 2
        })
    end)
    
    updateSelectionCircle(selectionCircle, circleStroke, buttonData.selected)
end

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

local function startLoadingAnimation(dot)
    dot.Visible = true
    local tween = TweenService:Create(dot, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Transparency = 1})
    tween:Play()
    return tween
end

local function startCooldown()
    local tween = startLoadingAnimation(locLoadingDot)
    task.wait(cooldownTime)
    tween:Cancel()
    locLoadingDot.Visible = false
    locLoadingDot.Transparency = 0
    isOnCooldownLocations = false
end

locSpawnBtn.MouseButton1Click:Connect(function()
    if not isOnCooldownLocations and selectedLocation then
        isOnCooldownLocations = true
        task.spawn(function()
            if selectedLocation == "Min" then RunMin()
            elseif selectedLocation == "Max" then RunMax()
            elseif selectedLocation == "Booking" then RunBooking() end
        end)
        task.spawn(startCooldown)
    end
end)

-- إشعار بالتحميل الناجح
task.wait(1)
game.StarterGui:SetCore("SendNotification", {
    Title = "Gun Spawner UI",
    Text = "Interface loaded successfully!",
    Duration = 3
})
