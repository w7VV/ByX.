-- ═══════════════════════════════════════════════════════════════
--          سكربت نظيف 100% | فقط الميزات المطلوبة
--          Environment + Bullets + LocalPlayer (Trail + Chams) + Crosshair
--          بواجهة Rayfield احترافية من sirius.menu
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- الإعدادات (فقط الميزات المطلوبة)
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
        Position = "Middle"
    }
}

-- حفظ الإضاءة الأصلية
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

-- ═══════════════════════════════════════════════════════════════
--                     جميع الدوال (تعمل 100%)
-- ═══════════════════════════════════════════════════════════════

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
        for k,v in pairs(originalLighting) do
            Lighting[k] = v
        end
    end
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
    local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    Lighting.ClockTime = 12
    local ids = {
        "http://www.roblox.com/asset/?id=1279987105",
        "http://www.roblox.com/asset/?id=2571711090",
        "rbxassetid://6277563515", "rbxassetid://6277565742", "rbxassetid://6277567481",
        "rbxassetid://6277569562", "rbxassetid://6277583250", "rbxassetid://6277586065",
        "rbxassetid://6285719338", "rbxassetid://6285721078", "rbxassetid://6285722964",
        "rbxassetid://6285724682", "rbxassetid://6285726335", "rbxassetid://6285730635",
        "rbxassetid://877168885", "rbxassetid://877169070", "rbxassetid://877169154",
        "rbxassetid://877169233", "rbxassetid://877169317", "rbxassetid://877169431",
        "http://www.roblox.com/asset/?id=9971120429",
        "http://www.roblox.com/asset/?id=8754359769"
    }
    local t = Settings.Environment.SkyboxType
    sky.SkyboxBk = ids[(t-1)*6 +1] or ids[1]
    sky.SkyboxDn = ids[(t-1)*6 +2] or ids[1]
    sky.SkyboxFt = ids[(t-1)*6 +3] or ids[1]
    sky.SkyboxLf = ids[(t-1)*6 +4] or ids[1]
    sky.SkyboxRt = ids[(t-1)*6 +5] or ids[1]
    sky.SkyboxUp = ids[(t-1)*6 +6] or ids[1]
end

-- Bullets
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
    beam.TextureMode = Enum.TextureMode.Wrap
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
        RunService.Heartbeat:Connect(function()
            local elapsed = tick() - start
            if elapsed >= duration then
                beam.Transparency = NumberSequence.new(1)
                part:Destroy()
            else
                beam.Transparency = NumberSequence.new(elapsed / duration)
            end
        end)
    else
        task.delay(duration, function() part:Destroy() end)
    end
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
    if obj.Name ~= bulletName and not obj:FindFirstChild(bulletBeam) then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if (char.HumanoidRootPart.Position - obj.Position).Magnitude > 13 then return end
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

-- Trail
local trailPart, trailConn
local function updateTrail()
    if trailPart then trailPart:Destroy() trailPart = nil end
    if trailConn then trailConn:Disconnect() trailConn = nil end
    if not Settings.LocalPlayer.TrailEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
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
end
LocalPlayer.CharacterAdded:Connect(updateTrail)
if LocalPlayer.Character then updateTrail() end

-- Chams
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
    if char then applyForceField(char:GetChildren(), Settings.LocalPlayer.BodyChams, Settings.LocalPlayer.BodyColor) end
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

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateBodyChams()
    updateToolChams()
    updateHatChams()
end)
if LocalPlayer.Character then
    task.wait(0.5)
    updateBodyChams()
    updateToolChams()
    updateHatChams()
end

-- Crosshair
local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "CleanCrosshair"
crosshairGui.Parent = CoreGui
crosshairGui.Enabled = false

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Size = UDim2.new(0, 10, 0, 10)
crosshairFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
crosshairFrame.BorderSizePixel = 0
crosshairFrame.Parent = crosshairGui
Instance.new("UICorner", crosshairFrame).CornerRadius = UDim.new(1,0)

local function updateCrosshair()
    crosshairGui.Enabled = Settings.Crosshair.Enabled
    if not Settings.Crosshair.Enabled then return end
    crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
    if Settings.Crosshair.Position == "Mouse" then
        crosshairFrame.Position = UDim2.new(0, Mouse.X - 5, 0, Mouse.Y - 5)
    else
        crosshairFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
    end
end

RunService.RenderStepped:Connect(function()
    if Settings.Crosshair.Enabled then
        crosshairFrame.Rotation = Settings.Crosshair.Spin and (crosshairFrame.Rotation + 2) or 0
        if Settings.Crosshair.Resize then
            local s = 10 + math.sin(tick()*5)*5
            crosshairFrame.Size = UDim2.new(0,s,0,s)
        else
            crosshairFrame.Size = UDim2.new(0,10,0,10)
        end
        updateCrosshair()
    end
end)
Mouse.Move:Connect(updateCrosshair)

-- ═══════════════════════════════════════════════════════════════
--                     Rayfield Interface
-- ═══════════════════════════════════════════════════════════════
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "الميزات المستخرجة",
   LoadingTitle = "جاري التحميل...",
   LoadingSubtitle = "Environment + Bullets + Chams + Crosshair",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CleanFeatures",
      FileName = "Settings"
   },
   KeySystem = false
})

-- تبويب البيئة
local EnvTab = Window:CreateTab("البيئة", 4483362458)
EnvTab:CreateSection("إعدادات الإضاءة")

EnvTab:CreateToggle({
   Name = "تفعيل الإضاءة",
   CurrentValue = Settings.Environment.Enabled,
   Flag = "EnvEnabled",
   Callback = function(v)
      Settings.Environment.Enabled = v
      updateEnvironment()
   end
})

EnvTab:CreateSlider({
   Name = "السطوع",
   Range = {0, 10},
   Increment = 0.1,
   CurrentValue = Settings.Environment.Brightness,
   Flag = "EnvBrightness",
   Callback = function(v)
      Settings.Environment.Brightness = v
      updateEnvironment()
   end
})

EnvTab:CreateSlider({
   Name = "وقت الساعة",
   Range = {0, 24},
   Increment = 0.5,
   CurrentValue = Settings.Environment.ClockTime,
   Flag = "EnvClockTime",
   Callback = function(v)
      Settings.Environment.ClockTime = v
      updateEnvironment()
   end
})

EnvTab:CreateSlider({
   Name = "التعريض",
   Range = {0, 10},
   Increment = 0.1,
   CurrentValue = Settings.Environment.Exposure,
   Flag = "EnvExposure",
   Callback = function(v)
      Settings.Environment.Exposure = v
      updateEnvironment()
   end
})

EnvTab:CreateColorpicker({
   Name = "الضوء المحيط",
   Color = Settings.Environment.Ambient,
   Flag = "EnvAmbient",
   Callback = function(v)
      Settings.Environment.Ambient = v
      updateEnvironment()
   end
})

EnvTab:CreateColorpicker({
   Name = "الضوء الخارجي",
   Color = Settings.Environment.OutdoorAmbient,
   Flag = "EnvOutdoor",
   Callback = function(v)
      Settings.Environment.OutdoorAmbient = v
      updateEnvironment()
   end
})

EnvTab:CreateColorpicker({
   Name = "تحول اللون (أسفل)",
   Color = Settings.Environment.ColorShiftBottom,
   Flag = "EnvBottom",
   Callback = function(v)
      Settings.Environment.ColorShiftBottom = v
      updateEnvironment()
   end
})

EnvTab:CreateColorpicker({
   Name = "تحول اللون (أعلى)",
   Color = Settings.Environment.ColorShiftTop,
   Flag = "EnvTop",
   Callback = function(v)
      Settings.Environment.ColorShiftTop = v
      updateEnvironment()
   end
})

EnvTab:CreateToggle({
   Name = "الظلال العامة",
   CurrentValue = Settings.Environment.GlobalShadows,
   Flag = "EnvShadows",
   Callback = function(v)
      Settings.Environment.GlobalShadows = v
      updateEnvironment()
   end
})

EnvTab:CreateSlider({
   Name = "نعومة الظل",
   Range = {0, 1},
   Increment = 0.01,
   CurrentValue = Settings.Environment.ShadowSoftness,
   Flag = "EnvSoftness",
   Callback = function(v)
      Settings.Environment.ShadowSoftness = v
      updateEnvironment()
   end
})

EnvTab:CreateSection("الضباب")
EnvTab:CreateToggle({
   Name = "تفعيل الضباب",
   CurrentValue = Settings.Environment.FogEnabled,
   Flag = "FogEnabled",
   Callback = function(v)
      Settings.Environment.FogEnabled = v
      updateEnvironment()
   end
})

EnvTab:CreateColorpicker({
   Name = "لون الضباب",
   Color = Settings.Environment.FogColor,
   Flag = "FogColor",
   Callback = function(v)
      Settings.Environment.FogColor = v
      updateEnvironment()
   end
})

EnvTab:CreateSlider({
   Name = "بداية الضباب",
   Range = {0, 1000},
   Increment = 10,
   CurrentValue = Settings.Environment.FogStart,
   Flag = "FogStart",
   Callback = function(v)
      Settings.Environment.FogStart = v
      updateEnvironment()
   end
})

EnvTab:CreateSlider({
   Name = "نهاية الضباب",
   Range = {0, 1000},
   Increment = 10,
   CurrentValue = Settings.Environment.FogEnd,
   Flag = "FogEnd",
   Callback = function(v)
      Settings.Environment.FogEnd = v
      updateEnvironment()
   end
})

EnvTab:CreateSection("السماء")
EnvTab:CreateToggle({
   Name = "تفعيل السماء",
   CurrentValue = Settings.Environment.SkyboxEnabled,
   Flag = "SkyEnabled",
   Callback = function(v)
      Settings.Environment.SkyboxEnabled = v
      updateSkybox()
   end
})

EnvTab:CreateDropdown({
   Name = "نوع السماء",
   Options = {"1","2","3","4","5","6","7"},
   CurrentOption = {tostring(Settings.Environment.SkyboxType)},
   Flag = "SkyType",
   Callback = function(opt)
      Settings.Environment.SkyboxType = tonumber(opt[1])
      updateSkybox()
   end
})

-- تبويب الرصاص
local BulletsTab = Window:CreateTab("الرصاص", 4483362458)

BulletsTab:CreateToggle({
   Name = "تفعيل مسارات الرصاص",
   CurrentValue = Settings.Bullets.Enabled,
   Flag = "BulletsEnabled",
   Callback = function(v) Settings.Bullets.Enabled = v end
})

BulletsTab:CreateColorpicker({
   Name = "لون المسار",
   Color = Settings.Bullets.Color,
   Flag = "BulletsColor",
   Callback = function(v) Settings.Bullets.Color = v end
})

BulletsTab:CreateSlider({
   Name = "العرض",
   Range = {0.1, 5},
   Increment = 0.1,
   CurrentValue = Settings.Bullets.Width,
   Flag = "BulletsWidth",
   Callback = function(v) Settings.Bullets.Width = v end
})

BulletsTab:CreateSlider({
   Name = "المدة",
   Range = {0.5, 10},
   Increment = 0.5,
   CurrentValue = Settings.Bullets.Duration,
   Flag = "BulletsDuration",
   Callback = function(v) Settings.Bullets.Duration = v end
})

BulletsTab:CreateToggle({
   Name = "تلاشي",
   CurrentValue = Settings.Bullets.Fade,
   Flag = "BulletsFade",
   Callback = function(v) Settings.Bullets.Fade = v end
})

BulletsTab:CreateDropdown({
   Name = "النسيج",
   Options = {"Cool","Cum","Electro"},
   CurrentOption = {Settings.Bullets.Texture},
   Flag = "BulletsTexture",
   Callback = function(opt) Settings.Bullets.Texture = opt[1] end
})

-- تبويب اللاعب
local PlayerTab = Window:CreateTab("اللاعب", 4483362458)

PlayerTab:CreateSection("Trail")
PlayerTab:CreateToggle({
   Name = "تفعيل التريل",
   CurrentValue = Settings.LocalPlayer.TrailEnabled,
   Flag = "TrailEnabled",
   Callback = function(v)
      Settings.LocalPlayer.TrailEnabled = v
      updateTrail()
   end
})

PlayerTab:CreateColorpicker({
   Name = "لون التريل",
   Color = Settings.LocalPlayer.TrailColor,
   Flag = "TrailColor",
   Callback = function(v)
      Settings.LocalPlayer.TrailColor = v
      updateTrail()
   end
})

PlayerTab:CreateSection("Chams")
PlayerTab:CreateToggle({
   Name = "Body Chams",
   CurrentValue = Settings.LocalPlayer.BodyChams,
   Flag = "BodyChams",
   Callback = function(v)
      Settings.LocalPlayer.BodyChams = v
      updateBodyChams()
   end
}):CreateColorpicker({
   Name = "لون الجسم",
   Color = Settings.LocalPlayer.BodyColor,
   Flag = "BodyColor",
   Callback = function(v)
      Settings.LocalPlayer.BodyColor = v
      updateBodyChams()
   end
})

PlayerTab:CreateToggle({
   Name = "Gun Chams",
   CurrentValue = Settings.LocalPlayer.ToolChams,
   Flag = "ToolChams",
   Callback = function(v)
      Settings.LocalPlayer.ToolChams = v
      updateToolChams()
   end
}):CreateColorpicker({
   Name = "لون الأدوات",
   Color = Settings.LocalPlayer.ToolColor,
   Flag = "ToolColor",
   Callback = function(v)
      Settings.LocalPlayer.ToolColor = v
      updateToolChams()
   end
})

PlayerTab:CreateToggle({
   Name = "Accessories Chams",
   CurrentValue = Settings.LocalPlayer.HatChams,
   Flag = "HatChams",
   Callback = function(v)
      Settings.LocalPlayer.HatChams = v
      updateHatChams()
   end
}):CreateColorpicker({
   Name = "لون الإكسسوارات",
   Color = Settings.LocalPlayer.HatColor,
   Flag = "HatColor",
   Callback = function(v)
      Settings.LocalPlayer.HatColor = v
      updateHatChams()
   end
})

-- تبويب المؤشر
local CrossTab = Window:CreateTab("المؤشر", 4483362458)

CrossTab:CreateToggle({
   Name = "تفعيل المؤشر",
   CurrentValue = Settings.Crosshair.Enabled,
   Flag = "CrossEnabled",
   Callback = function(v)
      Settings.Crosshair.Enabled = v
      updateCrosshair()
   end
})

CrossTab:CreateColorpicker({
   Name = "لون المؤشر",
   Color = Settings.Crosshair.Color,
   Flag = "CrossColor",
   Callback = function(v)
      Settings.Crosshair.Color = v
      updateCrosshair()
   end
})

CrossTab:CreateToggle({
   Name = "دوران",
   CurrentValue = Settings.Crosshair.Spin,
   Flag = "CrossSpin",
   Callback = function(v) Settings.Crosshair.Spin = v end
})

CrossTab:CreateToggle({
   Name = "تكبير وتصغير",
   CurrentValue = Settings.Crosshair.Resize,
   Flag = "CrossResize",
   Callback = function(v) Settings.Crosshair.Resize = v end
})

CrossTab:CreateDropdown({
   Name = "الوضع",
   Options = {"Middle","Mouse"},
   CurrentOption = {Settings.Crosshair.Position},
   Flag = "CrossPosition",
   Callback = function(opt)
      Settings.Crosshair.Position = opt[1]
      updateCrosshair()
   end
})

Rayfield:LoadConfiguration()
print("✅ تم تحميل السكربت النظيف مع Rayfield")
