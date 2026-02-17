-- واجهة بسيطة للميزات المستخرجة
-- (Environment, Bullets, Local Player, Crosshair)
-- بدون مكتبات خارجية

-- الخدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- الإعدادات الأساسية
local Settings = {
    Environment = {
        Enabled = false,
        Brightness = 0,
        ClockTime = 1,
        Exposure = 0,
        Ambient = Color3.fromRGB(0,0,255),
        OutdoorAmbient = Color3.fromRGB(60,60,100),
        ColorShiftBottom = Color3.fromRGB(0,0,50),
        ColorShiftTop = Color3.fromRGB(50,50,150),
        GlobalShadows = true,
        ShadowSoftness = 0.7,
        FogEnabled = false,
        FogColor = Color3.fromRGB(0,0,255),
        FogStart = 0,
        FogEnd = 300,
        SkyboxEnabled = false,
        SkyboxType = 1
    },
    Bullets = {
        Enabled = false,
        Color = Color3.fromRGB(255,255,255),
        Width = 1.0,
        Duration = 3,
        Fade = false,
        Texture = "Cool"
    },
    LocalPlayer = {
        TrailEnabled = false,
        TrailColor = Color3.fromRGB(255,255,255),
        BodyChams = false,
        BodyColor = Color3.fromRGB(255,255,255),
        ToolChams = false,
        ToolColor = Color3.fromRGB(255,255,255),
        HatChams = false,
        HatColor = Color3.fromRGB(255,255,255)
    },
    Crosshair = {
        Enabled = false,
        Color = Color3.fromRGB(255,255,255),
        Spin = false,
        Resize = false,
        Sticky = false,
        Position = "Middle"
    }
}

-- حفظ الإعدادات الأصلية للإضاءة
local originalLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ExposureCompensation = Lighting.ExposureCompensation,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ShadowSoftness = Lighting.ShadowSoftness,
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd
}

-- دوال البيئة
local function updateEnvironment()
    if Settings.Environment.Enabled then
        Lighting.Ambient = Settings.Environment.Ambient
        Lighting.Brightness = Settings.Environment.Brightness
        Lighting.ClockTime = Settings.Environment.ClockTime
        Lighting.ExposureCompensation = Settings.Environment.Exposure
        Lighting.ColorShift_Bottom = Settings.Environment.ColorShiftBottom
        Lighting.ColorShift_Top = Settings.Environment.ColorShiftTop
        Lighting.GlobalShadows = Settings.Environment.GlobalShadows
        Lighting.OutdoorAmbient = Settings.Environment.OutdoorAmbient
        Lighting.ShadowSoftness = Settings.Environment.ShadowSoftness
    else
        Lighting.Ambient = originalLighting.Ambient
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.ExposureCompensation = originalLighting.ExposureCompensation
        Lighting.ColorShift_Bottom = originalLighting.ColorShift_Bottom
        Lighting.ColorShift_Top = originalLighting.ColorShift_Top
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.ShadowSoftness = originalLighting.ShadowSoftness
    end
    updateFog()
end

local function updateFog()
    if Settings.Environment.FogEnabled then
        Lighting.FogColor = Settings.Environment.FogColor
        Lighting.FogStart = Settings.Environment.FogStart
        Lighting.FogEnd = Settings.Environment.FogEnd
    else
        Lighting.FogColor = originalLighting.FogColor
        Lighting.FogStart = originalLighting.FogStart
        Lighting.FogEnd = originalLighting.FogEnd
    end
end

local function updateSkybox()
    if not Settings.Environment.SkyboxEnabled then return end
    local t = Settings.Environment.SkyboxType
    local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    Lighting.ClockTime = 12
    if t == 1 then
        local id = "http://www.roblox.com/asset/?id=1279987105"
        sky.SkyboxBk = id; sky.SkyboxDn = id; sky.SkyboxFt = id; sky.SkyboxLf = id; sky.SkyboxRt = id; sky.SkyboxUp = id
    elseif t == 2 then
        local id = "http://www.roblox.com/asset/?id=2571711090"
        sky.SkyboxBk = id; sky.SkyboxDn = id; sky.SkyboxFt = id; sky.SkyboxLf = id; sky.SkyboxRt = id; sky.SkyboxUp = id
    elseif t == 3 then
        sky.SkyboxBk = "rbxassetid://6277563515"; sky.SkyboxDn = "rbxassetid://6277565742"; sky.SkyboxFt = "rbxassetid://6277567481"
        sky.SkyboxLf = "rbxassetid://6277569562"; sky.SkyboxRt = "rbxassetid://6277583250"; sky.SkyboxUp = "rbxassetid://6277586065"
    elseif t == 4 then
        sky.SkyboxBk = "rbxassetid://6285719338"; sky.SkyboxDn = "rbxassetid://6285721078"; sky.SkyboxFt = "rbxassetid://6285722964"
        sky.SkyboxLf = "rbxassetid://6285724682"; sky.SkyboxRt = "rbxassetid://6285726335"; sky.SkyboxUp = "rbxassetid://6285730635"
    elseif t == 5 then
        sky.SkyboxBk = "rbxassetid://877168885"; sky.SkyboxDn = "rbxassetid://877169070"; sky.SkyboxFt = "rbxassetid://877169154"
        sky.SkyboxLf = "rbxassetid://877169233"; sky.SkyboxRt = "rbxassetid://877169317"; sky.SkyboxUp = "rbxassetid://877169431"
    elseif t == 6 then
        local id = "http://www.roblox.com/asset/?id=9971120429"
        sky.SkyboxBk = id; sky.SkyboxDn = id; sky.SkyboxFt = id; sky.SkyboxLf = id; sky.SkyboxRt = id; sky.SkyboxUp = id
    elseif t == 7 then
        local id = "http://www.roblox.com/asset/?id=8754359769"
        sky.SkyboxBk = id; sky.SkyboxDn = id; sky.SkyboxFt = id; sky.SkyboxLf = id; sky.SkyboxRt = id; sky.SkyboxUp = id
    end
end

-- دوال الرصاص
local bulletTextures = {
    Cool = "rbxassetid://116848240236550",
    Cum = "rbxassetid://88263664141635",
    Electro = "rbxassetid://139193109954329"
}

local function createBeam(textureId, width, from, to, color, duration, fade)
    local part = Instance.new("Part")
    part.Parent = workspace
    part.Size = Vector3.zero
    part.Massless = true
    part.Transparency = 1
    part.CanCollide = false
    part.Position = from
    part.Anchored = true

    local a0 = Instance.new("Attachment", part)
    local a1 = Instance.new("Attachment", part)
    a1.WorldPosition = to

    local beam = Instance.new("Beam", part)
    beam.Texture = textureId
    beam.TextureMode = "Wrap"
    beam.TextureLength = 10
    beam.LightEmission = 10
    beam.LightInfluence = 1
    beam.FaceCamera = true
    beam.Transparency = NumberSequence.new(0)
    beam.Color = ColorSequence.new(color)
    beam.Width0 = width
    beam.Width1 = width
    beam.Attachment0 = a0
    beam.Attachment1 = a1

    if fade then
        local start = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - start
            if elapsed >= duration then
                beam.Transparency = NumberSequence.new(1)
                conn:Disconnect()
            else
                beam.Transparency = NumberSequence.new(elapsed / duration)
            end
        end)
    end
    task.delay(duration, part.Destroy, part)
end

local function getBulletPaths()
    if workspace:FindFirstChild("Ignored") and workspace.Ignored:FindFirstChild("Siren") and workspace.Ignored.Siren:FindFirstChild("Radius") then
        return workspace.Ignored.Siren.Radius, "BULLET_RAYS", "GunBeam"
    elseif workspace:FindFirstChild("Ignored") then
        return workspace.Ignored, "BULLET_RAYS", "GunBeam"
    else
        return workspace, "Part", "gb"
    end
end

local bulletPath, bulletName, bulletBeam = getBulletPaths()
bulletPath.ChildAdded:Connect(function(obj)
    if not Settings.Bullets.Enabled then return end
    if obj.Name ~= bulletName and not obj:FindFirstChild("Attachment") and not obj:FindFirstChild(bulletBeam) then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if (root.Position - obj.Position).Magnitude > 13 then return end
    local beam = obj:FindFirstChild(bulletBeam)
    if not beam then return end
    local att1 = beam:FindFirstChild("Attachment1") or beam:FindFirstChild("Attachment")
    if not att1 then return end
    beam:Destroy()
    createBeam(
        bulletTextures[Settings.Bullets.Texture],
        Settings.Bullets.Width,
        obj.Position,
        att1.WorldCFrame.Position,
        Settings.Bullets.Color,
        Settings.Bullets.Duration,
        Settings.Bullets.Fade
    )
end)

-- دوال اللاعب المحلي (Trail & Chams)
-- Trail
local trailPart, trailConn
local function updateTrail()
    if Settings.LocalPlayer.TrailEnabled then
        if trailPart then trailPart:Destroy() end
        if trailConn then trailConn:Disconnect() end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:WaitForChild("HumanoidRootPart")
        trailPart = Instance.new("Part")
        trailPart.Name = "PlayerTrail"
        trailPart.Size = Vector3.new(0.1,0.1,0.1)
        trailPart.Transparency = 1
        trailPart.Anchored = true
        trailPart.CanCollide = false
        trailPart.CFrame = root.CFrame
        trailPart.Parent = workspace

        local trail = Instance.new("Trail", trailPart)
        local a0 = Instance.new("Attachment", trailPart)
        a0.Position = Vector3.new(0,1,0)
        local a1 = Instance.new("Attachment", trailPart)
        a1.Position = Vector3.new(0,-1,0)
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 5
        trail.Transparency = NumberSequence.new(0)
        trail.LightEmission = 150
        trail.Brightness = 1500
        trail.LightInfluence = 1
        trail.WidthScale = NumberSequence.new(0.08)

        trailConn = RunService.RenderStepped:Connect(function()
            if root and root.Parent then
                trailPart.CFrame = root.CFrame
                trail.Color = ColorSequence.new(Settings.LocalPlayer.TrailColor)
            else
                updateTrail()
            end
        end)
    else
        if trailPart then trailPart:Destroy() trailPart = nil end
        if trailConn then trailConn:Disconnect() trailConn = nil end
    end
end

LocalPlayer.CharacterAdded:Connect(updateTrail)
if LocalPlayer.Character then updateTrail() end

-- Chams (ForceField)
local function applyForceField(parts, enable, color)
    for _, p in pairs(parts) do
        if p:IsA("BasePart") then
            p.Material = enable and Enum.Material.ForceField or Enum.Material.Plastic
            if enable then p.Color = color end
        end
    end
end

local function updateBodyChams()
    local char = LocalPlayer.Character
    if char then
        applyForceField(char:GetChildren(), Settings.LocalPlayer.BodyChams, Settings.LocalPlayer.BodyColor)
    end
end

local function updateToolChams()
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            applyForceField(tool:GetChildren(), Settings.LocalPlayer.ToolChams, Settings.LocalPlayer.ToolColor)
        end
    end
end

local function updateHatChams()
    local char = LocalPlayer.Character
    if char then
        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") then
                applyForceField(acc:GetChildren(), Settings.LocalPlayer.HatChams, Settings.LocalPlayer.HatColor)
            end
        end
    end
end

local function updateAllChams()
    updateBodyChams()
    updateToolChams()
    updateHatChams()
end

LocalPlayer.CharacterAdded:Connect(updateAllChams)
if LocalPlayer.Character then updateAllChams() end

-- دوال المؤشر
local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "SimpleCrosshair"
crosshairGui.Parent = CoreGui
crosshairGui.Enabled = false

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Size = UDim2.new(0, 10, 0, 10)
crosshairFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
crosshairFrame.BackgroundTransparency = 0
crosshairFrame.BorderSizePixel = 0
crosshairFrame.Parent = crosshairGui
Instance.new("UICorner", crosshairFrame).CornerRadius = UDim.new(1,0)

local function updateCrosshair()
    crosshairGui.Enabled = Settings.Crosshair.Enabled
    if not Settings.Crosshair.Enabled then return end
    crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
    if Settings.Crosshair.Position == "Mouse" then
        crosshairFrame.Position = UDim2.new(0, Mouse.X - crosshairFrame.AbsoluteSize.X/2, 0, Mouse.Y - crosshairFrame.AbsoluteSize.Y/2)
    else
        crosshairFrame.Position = UDim2.new(0.5, -crosshairFrame.AbsoluteSize.X/2, 0.5, -crosshairFrame.AbsoluteSize.Y/2)
    end
end

RunService.RenderStepped:Connect(function()
    if Settings.Crosshair.Enabled then
        if Settings.Crosshair.Spin then
            crosshairFrame.Rotation = crosshairFrame.Rotation + 2
        else
            crosshairFrame.Rotation = 0
        end
        if Settings.Crosshair.Resize then
            local sin = math.sin(tick()*5)
            local size = 10 + sin*5
            crosshairFrame.Size = UDim2.new(0, size, 0, size)
        else
            crosshairFrame.Size = UDim2.new(0,10,0,10)
        end
        updateCrosshair()
    end
end)

Mouse.Move:Connect(updateCrosshair)

-- بناء الواجهة البسيطة
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleFeaturesGUI"
gui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,8)

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "الميزات المستخرجة"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 18
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

-- علامات التبويب (Tabs)
local tabButtons = {}
local tabs = {}
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabNames = {"البيئة", "الرصاص", "اللاعب", "المؤشر"}
local tabX = 5
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, tabX, 0, 5)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(70,130,200) or Color3.fromRGB(50,50,50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = tabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    tabX = tabX + 110

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, -20, 1, -90)
    tabContent.Position = UDim2.new(0, 10, 0, 80)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 6
    tabContent.CanvasSize = UDim2.new(0,0,0,0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.Visible = i == 1
    tabContent.Parent = mainFrame
    tabs[i] = tabContent

    btn.MouseButton1Click:Connect(function()
        for j, b in ipairs(tabButtons) do
            b.BackgroundColor3 = j == i and Color3.fromRGB(70,130,200) or Color3.fromRGB(50,50,50)
            tabs[j].Visible = (j == i)
        end
    end)
    table.insert(tabButtons, btn)
end

-- دالة مساعدة لإنشاء عناصر التحكم
local function createToggle(parent, text, flag, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 30)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -5, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 20)
    btn.Position = UDim2.new(1, -55, 0.5, -10)
    btn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(70,200,70) or Color3.fromRGB(150,50,50)
    btn.Text = Settings[flag] and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    btn.MouseButton1Click:Connect(function()
        Settings[flag] = not Settings[flag]
        btn.BackgroundColor3 = Settings[flag] and Color3.fromRGB(70,200,70) or Color3.fromRGB(150,50,50)
        btn.Text = Settings[flag] and "ON" or "OFF"
        callback(Settings[flag])
    end)

    return row
end

local function createSlider(parent, text, flag, min, max, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 40)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, -5, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Parent = row

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(Settings[flag])
    valueLabel.TextColor3 = Color3.fromRGB(255,255,255)
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.TextSize = 16
    valueLabel.Parent = row

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.4, -5, 0, 10)
    slider.Position = UDim2.new(0.6, 0, 0.5, -5)
    slider.BackgroundColor3 = Color3.fromRGB(80,80,80)
    slider.Parent = row
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((Settings[flag]-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100,150,250)
    fill.Parent = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local function update(pos)
        local relX = math.clamp((pos.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local val = min + (max-min) * relX
        Settings[flag] = val
        fill.Size = UDim2.new(relX, 0, 1, 0)
        valueLabel.Text = string.format("%.2f", val)
        callback(val)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(input.Position)
            local conn
            conn = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    update(inp.Position)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                end
            end)
        end
    end)
end

local function createColorPicker(parent, text, flag, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 30)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -5, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Parent = row

    local colorBtn = Instance.new("Frame")
    colorBtn.Size = UDim2.new(0, 30, 0, 20)
    colorBtn.Position = UDim2.new(1, -35, 0.5, -10)
    colorBtn.BackgroundColor3 = Settings[flag]
    colorBtn.BorderSizePixel = 2
    colorBtn.BorderColor3 = Color3.fromRGB(255,255,255)
    colorBtn.Parent = row
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0,3)

    -- نافذة اختيار اللون البسيطة
    colorBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local picker = Instance.new("Frame")
            picker.Size = UDim2.new(0, 200, 0, 200)
            picker.Position = UDim2.new(0, input.Position.X - 100, 0, input.Position.Y - 100)
            picker.BackgroundColor3 = Color3.fromRGB(40,40,40)
            picker.BorderSizePixel = 0
            picker.Parent = gui
            Instance.new("UICorner", picker).CornerRadius = UDim.new(0,6)

            -- (للتبسيط، نغلق النافذة بعد ثانية)
            task.delay(3, picker.Destroy, picker)
        end
    end)
end

local function createDropdown(parent, text, flag, options, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 40)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -5, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 25)
    btn.Position = UDim2.new(0.6, 0, 0.5, -12.5)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = Settings[flag]
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = row
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    btn.MouseButton1Click:Connect(function()
        local menu = Instance.new("Frame")
        menu.Size = UDim2.new(0, 120, 0, #options * 30)
        menu.Position = UDim2.new(0, btn.AbsolutePosition.X, 0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y)
        menu.BackgroundColor3 = Color3.fromRGB(40,40,40)
        menu.BorderSizePixel = 0
        menu.Parent = gui
        Instance.new("UICorner", menu).CornerRadius = UDim.new(0,4)

        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            optBtn.BackgroundColor3 = opt == Settings[flag] and Color3.fromRGB(70,130,200) or Color3.fromRGB(50,50,50)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(255,255,255)
            optBtn.Font = Enum.Font.SourceSans
            optBtn.TextSize = 16
            optBtn.Parent = menu
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0,4)

            optBtn.MouseButton1Click:Connect(function()
                Settings[flag] = opt
                btn.Text = opt
                callback(opt)
                menu:Destroy()
            end)
        end

        menu.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local pos = input.Position
                if not (pos.X >= menu.AbsolutePosition.X and pos.X <= menu.AbsolutePosition.X + menu.AbsoluteSize.X and
                        pos.Y >= menu.AbsolutePosition.Y and pos.Y <= menu.AbsolutePosition.Y + menu.AbsoluteSize.Y) then
                    menu:Destroy()
                end
            end
        end)
    end)
end

-- تعبئة التبويبات
-- البيئة
createToggle(tabs[1], "تفعيل تعديل الإضاءة", "Environment.Enabled", function(v) Settings.Environment.Enabled = v; updateEnvironment() end)
createSlider(tabs[1], "السطوع", "Environment.Brightness", 0, 10, function(v) Settings.Environment.Brightness = v; updateEnvironment() end)
createSlider(tabs[1], "وقت الساعة", "Environment.ClockTime", 0, 24, function(v) Settings.Environment.ClockTime = v; updateEnvironment() end)
createSlider(tabs[1], "التعريض", "Environment.Exposure", 0, 10, function(v) Settings.Environment.Exposure = v; updateEnvironment() end)
createColorPicker(tabs[1], "الضوء المحيط", "Environment.Ambient", function(v) Settings.Environment.Ambient = v; updateEnvironment() end)
createColorPicker(tabs[1], "الضوء الخارجي", "Environment.OutdoorAmbient", function(v) Settings.Environment.OutdoorAmbient = v; updateEnvironment() end)
createColorPicker(tabs[1], "تحول اللون (أسفل)", "Environment.ColorShiftBottom", function(v) Settings.Environment.ColorShiftBottom = v; updateEnvironment() end)
createColorPicker(tabs[1], "تحول اللون (أعلى)", "Environment.ColorShiftTop", function(v) Settings.Environment.ColorShiftTop = v; updateEnvironment() end)
createToggle(tabs[1], "الظلال العامة", "Environment.GlobalShadows", function(v) Settings.Environment.GlobalShadows = v; updateEnvironment() end)
createSlider(tabs[1], "نعومة الظل", "Environment.ShadowSoftness", 0, 1, function(v) Settings.Environment.ShadowSoftness = v; updateEnvironment() end)
createToggle(tabs[1], "تفعيل الضباب", "Environment.FogEnabled", function(v) Settings.Environment.FogEnabled = v; updateFog() end)
createColorPicker(tabs[1], "لون الضباب", "Environment.FogColor", function(v) Settings.Environment.FogColor = v; updateFog() end)
createSlider(tabs[1], "بداية الضباب", "Environment.FogStart", 0, 1000, function(v) Settings.Environment.FogStart = v; updateFog() end)
createSlider(tabs[1], "نهاية الضباب", "Environment.FogEnd", 0, 1000, function(v) Settings.Environment.FogEnd = v; updateFog() end)
createToggle(tabs[1], "تفعيل تغيير السماء", "Environment.SkyboxEnabled", function(v) Settings.Environment.SkyboxEnabled = v; updateSkybox() end)
createDropdown(tabs[1], "نوع السماء", "Environment.SkyboxType", {"1","2","3","4","5","6","7"}, function(v) Settings.Environment.SkyboxType = tonumber(v); updateSkybox() end)

-- الرصاص
createToggle(tabs[2], "تفعيل مسارات الرصاص", "Bullets.Enabled", function(v) Settings.Bullets.Enabled = v end)
createColorPicker(tabs[2], "لون المسار", "Bullets.Color", function(v) Settings.Bullets.Color = v end)
createSlider(tabs[2], "العرض", "Bullets.Width", 0.1, 5, function(v) Settings.Bullets.Width = v end)
createSlider(tabs[2], "المدة", "Bullets.Duration", 0.5, 10, function(v) Settings.Bullets.Duration = v end)
createToggle(tabs[2], "تلاشي", "Bullets.Fade", function(v) Settings.Bullets.Fade = v end)
createDropdown(tabs[2], "النسيج", "Bullets.Texture", {"Cool","Cum","Electro"}, function(v) Settings.Bullets.Texture = v end)

-- اللاعب
createToggle(tabs[3], "تفعيل مسار اللاعب", "LocalPlayer.TrailEnabled", function(v) Settings.LocalPlayer.TrailEnabled = v; updateTrail() end)
createColorPicker(tabs[3], "لون المسار", "LocalPlayer.TrailColor", function(v) Settings.LocalPlayer.TrailColor = v; updateTrail() end)
createToggle(tabs[3], "شامات الجسم", "LocalPlayer.BodyChams", function(v) Settings.LocalPlayer.BodyChams = v; updateBodyChams() end)
createColorPicker(tabs[3], "لون الجسم", "LocalPlayer.BodyColor", function(v) Settings.LocalPlayer.BodyColor = v; updateBodyChams() end)
createToggle(tabs[3], "شامات الأدوات", "LocalPlayer.ToolChams", function(v) Settings.LocalPlayer.ToolChams = v; updateToolChams() end)
createColorPicker(tabs[3], "لون الأدوات", "LocalPlayer.ToolColor", function(v) Settings.LocalPlayer.ToolColor = v; updateToolChams() end)
createToggle(tabs[3], "شامات الإكسسوارات", "LocalPlayer.HatChams", function(v) Settings.LocalPlayer.HatChams = v; updateHatChams() end)
createColorPicker(tabs[3], "لون الإكسسوارات", "LocalPlayer.HatColor", function(v) Settings.LocalPlayer.HatColor = v; updateHatChams() end)

-- المؤشر
createToggle(tabs[4], "تفعيل المؤشر", "Crosshair.Enabled", function(v) Settings.Crosshair.Enabled = v; updateCrosshair() end)
createColorPicker(tabs[4], "لون المؤشر", "Crosshair.Color", function(v) Settings.Crosshair.Color = v; updateCrosshair() end)
createToggle(tabs[4], "دوران", "Crosshair.Spin", function(v) Settings.Crosshair.Spin = v end)
createToggle(tabs[4], "تكبير وتصغير", "Crosshair.Resize", function(v) Settings.Crosshair.Resize = v end)
createDropdown(tabs[4], "الوضع", "Crosshair.Position", {"Middle","Mouse"}, function(v) Settings.Crosshair.Position = v; updateCrosshair() end)

-- زر إظهار/إخفاء
local showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0, 120, 0, 30)
showBtn.Position = UDim2.new(0, 10, 0, 10)
showBtn.BackgroundColor3 = Color3.fromRGB(50,50,150)
showBtn.Text = "إظهار القائمة"
showBtn.TextColor3 = Color3.fromRGB(255,255,255)
showBtn.Font = Enum.Font.SourceSans
showBtn.TextSize = 18
showBtn.Parent = gui
Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0,6)

showBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    showBtn.Visible = not mainFrame.Visible
end)

mainFrame.Visible = false
showBtn.Visible = true

-- إغلاق آمن
gui.Parent = CoreGui
