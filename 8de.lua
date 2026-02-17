--[[
    سكربت ميزات مستخرجة (Environment, Bullets, Local Player, Crosshair)
    مع واجهة Rayfield
    تم استخراج الكود الأصلي من Psalms.Tech وتعديله ليعمل مع Rayfield
]]

-- تأكد من عدم وجود أخطاء بالمكتبات
if not getgenv then
    getgenv = function() return _G end
end

-- خدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ========================
-- إعدادات البيئة (Environment)
-- ========================
local originalSettings = {
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    ExposureCompensation = Lighting.ExposureCompensation,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ShadowSoftness = Lighting.ShadowSoftness
}

local Environment = {
    Settings = {
        Exposure = 0,
        ClockTime = 1,
        FogColor = Color3.fromRGB(0, 0, 255),
        FogStart = 0,
        FogEnd = 300,
        Ambient = Color3.fromRGB(0, 0, 255),
        Brightness = 0,
        Enabled = false,
        ColorShift_Bottom = Color3.fromRGB(0, 0, 50),
        ColorShift_Top = Color3.fromRGB(50, 50, 150),
        GlobalShadows = true,
        OutdoorAmbient = Color3.fromRGB(60, 60, 100),
        ShadowSoftness = 0.7,
        FogEnabled = false
    }
}

local function UpdateWorld()
    if Environment.Settings.Enabled then
        Lighting.Ambient = Environment.Settings.Ambient
        Lighting.Brightness = Environment.Settings.Brightness
        Lighting.ClockTime = Environment.Settings.ClockTime
        Lighting.ExposureCompensation = Environment.Settings.Exposure
        Lighting.ColorShift_Bottom = Environment.Settings.ColorShift_Bottom
        Lighting.ColorShift_Top = Environment.Settings.ColorShift_Top
        Lighting.GlobalShadows = Environment.Settings.GlobalShadows
        Lighting.OutdoorAmbient = Environment.Settings.OutdoorAmbient
        Lighting.ShadowSoftness = Environment.Settings.ShadowSoftness
    else
        Lighting.Ambient = originalSettings.Ambient
        Lighting.Brightness = originalSettings.Brightness
        Lighting.ClockTime = originalSettings.ClockTime
        Lighting.ExposureCompensation = originalSettings.ExposureCompensation
        Lighting.ColorShift_Bottom = originalSettings.ColorShift_Bottom
        Lighting.ColorShift_Top = originalSettings.ColorShift_Top
        Lighting.GlobalShadows = originalSettings.GlobalShadows
        Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
        Lighting.ShadowSoftness = originalSettings.ShadowSoftness
    end
end

local function UpdateFog()
    if Environment.Settings.FogEnabled then
        Lighting.FogColor = Environment.Settings.FogColor
        Lighting.FogStart = Environment.Settings.FogStart
        Lighting.FogEnd = Environment.Settings.FogEnd
    else
        Lighting.FogColor = originalSettings.FogColor
        Lighting.FogStart = originalSettings.FogStart
        Lighting.FogEnd = originalSettings.FogEnd
    end
end

-- ========================
-- Skybox
-- ========================
local skyboxEnabled = false
local skyboxType = 1
local function ChangeSkybox()
    if skyboxEnabled then
        if skyboxType == 1 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=1279987105"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=1279987105"
        elseif skyboxType == 2 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=2571711090"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=2571711090"
        elseif skyboxType == 3 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "rbxassetid://6277563515"
            Lighting.Sky.SkyboxDn = "rbxassetid://6277565742"
            Lighting.Sky.SkyboxFt = "rbxassetid://6277567481"
            Lighting.Sky.SkyboxLf = "rbxassetid://6277569562"
            Lighting.Sky.SkyboxRt = "rbxassetid://6277583250"
            Lighting.Sky.SkyboxUp = "rbxassetid://6277586065"
        elseif skyboxType == 4 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "rbxassetid://6285719338"
            Lighting.Sky.SkyboxDn = "rbxassetid://6285721078"
            Lighting.Sky.SkyboxFt = "rbxassetid://6285722964"
            Lighting.Sky.SkyboxLf = "rbxassetid://6285724682"
            Lighting.Sky.SkyboxRt = "rbxassetid://6285726335"
            Lighting.Sky.SkyboxUp = "rbxassetid://6285730635"
        elseif skyboxType == 5 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "rbxassetid://877168885"
            Lighting.Sky.SkyboxDn = "rbxassetid://877169070"
            Lighting.Sky.SkyboxFt = "rbxassetid://877169154"
            Lighting.Sky.SkyboxLf = "rbxassetid://877169233"
            Lighting.Sky.SkyboxRt = "rbxassetid://877169317"
            Lighting.Sky.SkyboxUp = "rbxassetid://877169431"
        elseif skyboxType == 6 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=9971120429"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=9971120429"
        elseif skyboxType == 7 then
            Lighting.ClockTime = "12"
            Lighting.Sky.SkyboxBk = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxDn = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxFt = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxLf = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxRt = "http://www.roblox.com/asset/?id=8754359769"
            Lighting.Sky.SkyboxUp = "http://www.roblox.com/asset/?id=8754359769"
        end
    end
end

-- ========================
-- إعدادات الرصاص (Bullets)
-- ========================
local BulletTexture = {
    Electro = "rbxassetid://139193109954329",
    Cool = "rbxassetid://116848240236550",
    Cum = "rbxassetid://88263664141635"
}

local Configurations = {
    Visuals = {
        Bullet_Trails = {
            Enabled = false,
            Width = 1.0,
            Duration = 3,
            Fade = false,
            Color = Color3.fromRGB(255, 255, 255),
            Texture = "Cool"
        }
    }
}

local function GetBullet()
    if Workspace:FindFirstChild("Ignored") and Workspace.Ignored:FindFirstChild("Siren") and Workspace.Ignored.Siren:FindFirstChild("Radius") then
        return {
            BulletPath = Workspace.Ignored.Siren.Radius,
            BulletName = "BULLET_RAYS",
            BulletBeamName = "GunBeam"
        }
    elseif Workspace:FindFirstChild("Ignored") then
        return {
            BulletPath = Workspace.Ignored,
            BulletName = "BULLET_RAYS",
            BulletBeamName = "GunBeam"
        }
    else
        return {
            BulletPath = Workspace,
            BulletName = "Part",
            BulletBeamName = "gb"
        }
    end
end

local support = GetBullet()
local bulletPath = support.BulletPath
local bulletName = support.BulletName
local bulletBeamName = support.BulletBeamName

local function createBeam(textureId, width, from, to, color, duration, fadeEnabled)
    local mainPart = Instance.new("Part")
    mainPart.Parent = Workspace
    mainPart.Size = Vector3.zero
    mainPart.Massless = true
    mainPart.Transparency = 1
    mainPart.CanCollide = false
    mainPart.Position = from
    mainPart.Anchored = true

    local part0 = Instance.new("Part", mainPart)
    part0.Size = Vector3.zero
    part0.Massless = true
    part0.Transparency = 1
    part0.CanCollide = false
    part0.Position = from
    part0.Anchored = true

    local part1 = Instance.new("Part", mainPart)
    part1.Size = Vector3.zero
    part1.Massless = true
    part1.Transparency = 1
    part1.CanCollide = false
    part1.Position = to
    part1.Anchored = true

    local att0 = Instance.new("Attachment", part0)
    local att1 = Instance.new("Attachment", part1)

    local beam = Instance.new("Beam")
    beam.Parent = mainPart
    beam.Texture = textureId
    beam.TextureMode = Enum.TextureMode.Wrap
    beam.TextureLength = 10
    beam.LightEmission = 10
    beam.LightInfluence = 1
    beam.FaceCamera = true
    beam.ZOffset = -1
    beam.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    beam.Color = ColorSequence.new(color)
    beam.Width0 = width
    beam.Width1 = width
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Enabled = true

    if fadeEnabled then
        local totalTime = 0
        local connection
        connection = RunService.Heartbeat:Connect(function(delta)
            totalTime = totalTime + delta
            local progress = totalTime / duration
            if progress >= 1 then
                beam.Transparency = NumberSequence.new(1)
                connection:Disconnect()
            else
                beam.Transparency = NumberSequence.new(progress)
            end
        end)
    end

    task.delay(duration, function()
        if mainPart then mainPart:Destroy() end
    end)
end

local function OnBulletAdded(obj)
    if obj.Name ~= bulletName and not obj:FindFirstChild("Attachment") and not obj:FindFirstChild(bulletBeamName) then return end

    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local distance = (rootPart.Position - obj.Position).Magnitude
    if distance > 13 then return end

    local gunBeam = obj:FindFirstChild(bulletBeamName)
    if not gunBeam then return end

    local att1 = gunBeam:FindFirstChild("Attachment1") or gunBeam:FindFirstChild("Attachment")
    if not att1 then return end

    if Configurations.Visuals.Bullet_Trails.Enabled then
        gunBeam:Destroy()
        createBeam(
            BulletTexture[Configurations.Visuals.Bullet_Trails.Texture],
            Configurations.Visuals.Bullet_Trails.Width,
            obj.Position,
            att1.WorldCFrame.Position,
            Configurations.Visuals.Bullet_Trails.Color,
            Configurations.Visuals.Bullet_Trails.Duration,
            Configurations.Visuals.Bullet_Trails.Fade
        )
    end
end

if bulletPath then
    bulletPath.ChildAdded:Connect(OnBulletAdded)
end

-- ========================
-- إعدادات اللاعب المحلي (Trail & Chams)
-- ========================
local trailObjects = {
    trailPart = nil,
    renderConnection = nil,
    characterConnection = nil
}
local trailColor = Color3.fromRGB(255, 255, 255)
local trailEnabled = false

local function CreateTrail(character)
    if trailObjects.trailPart then
        trailObjects.trailPart:Destroy()
        trailObjects.trailPart = nil
    end
    if trailObjects.renderConnection then
        trailObjects.renderConnection:Disconnect()
        trailObjects.renderConnection = nil
    end

    local rootPart = character:WaitForChild("HumanoidRootPart")
    trailObjects.trailPart = Instance.new("Part")
    trailObjects.trailPart.Name = "TrailPart"
    trailObjects.trailPart.Size = Vector3.new(0.1, 0.1, 0.1)
    trailObjects.trailPart.Transparency = 1
    trailObjects.trailPart.Anchored = true
    trailObjects.trailPart.CanCollide = false
    trailObjects.trailPart.CFrame = rootPart.CFrame
    trailObjects.trailPart.Parent = Workspace

    local trail = Instance.new("Trail", trailObjects.trailPart)
    trail.Name = "PlayerTrail"
    local att0 = Instance.new("Attachment", trailObjects.trailPart)
    att0.Position = Vector3.new(0, 1, 0)
    local att1 = Instance.new("Attachment", trailObjects.trailPart)
    att1.Position = Vector3.new(0, -1, 0)
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Lifetime = 5
    trail.Transparency = NumberSequence.new(0)
    trail.LightEmission = 150
    trail.Brightness = 1500
    trail.LightInfluence = 1
    trail.WidthScale = NumberSequence.new(0.08)

    trailObjects.renderConnection = RunService.RenderStepped:Connect(function()
        trail.Color = ColorSequence.new(trailColor)
        if rootPart and rootPart.Parent then
            trailObjects.trailPart.CFrame = rootPart.CFrame
        else
            if trailObjects.renderConnection then
                trailObjects.renderConnection:Disconnect()
                trailObjects.renderConnection = nil
            end
        end
    end)
end

local function SetTrailEnabled(state)
    trailEnabled = state
    if state then
        local character = LocalPlayer.Character
        if character then
            CreateTrail(character)
        end
        if not trailObjects.characterConnection then
            trailObjects.characterConnection = LocalPlayer.CharacterAdded:Connect(CreateTrail)
        end
    else
        if trailObjects.trailPart then
            trailObjects.trailPart:Destroy()
            trailObjects.trailPart = nil
        end
        if trailObjects.renderConnection then
            trailObjects.renderConnection:Disconnect()
            trailObjects.renderConnection = nil
        end
        if trailObjects.characterConnection then
            trailObjects.characterConnection:Disconnect()
            trailObjects.characterConnection = nil
        end
    end
end

-- Local Player Chams
local localPlayerEsp = {
    ForcefieldBody = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ForcefieldTools = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) },
    ForcefieldHats = { Enabled = false, Color = Color3.fromRGB(255, 255, 255) }
}

local function ApplyForcefieldToParts(parts, isEnabled, color)
    for _, part in pairs(parts) do
        if part:IsA("BasePart") then
            if isEnabled then
                part.Material = Enum.Material.ForceField
                part.Color = color
            else
                part.Material = Enum.Material.Plastic
            end
        end
    end
end

local function ApplyForcefieldToBody()
    local character = LocalPlayer.Character
    if character then
        ApplyForcefieldToParts(character:GetChildren(), localPlayerEsp.ForcefieldBody.Enabled, localPlayerEsp.ForcefieldBody.Color)
    end
end

local function ApplyForcefieldToTools()
    local backpack = LocalPlayer.Backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            ApplyForcefieldToParts(tool:GetChildren(), localPlayerEsp.ForcefieldTools.Enabled, localPlayerEsp.ForcefieldTools.Color)
        end
    end
end

local function ApplyForcefieldToHats()
    local character = LocalPlayer.Character
    if character then
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                ApplyForcefieldToParts(accessory:GetChildren(), localPlayerEsp.ForcefieldHats.Enabled, localPlayerEsp.ForcefieldHats.Color)
            end
        end
    end
end

local function UpdateAllForcefields()
    ApplyForcefieldToBody()
    ApplyForcefieldToTools()
    ApplyForcefieldToHats()
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    UpdateAllForcefields()
end)

if LocalPlayer.Character then
    UpdateAllForcefields()
end

-- ========================
-- إعدادات المؤشر (Crosshair)
-- ========================
-- استخدام crosshair من السكربت الأصلي (بدون Drawing لأن Rayfield لا يدعمه مباشرة، لكننا سنحتفظ بالكود لإمكانية التوسع)
-- سأقوم بتحميل crosshair كـ UI بسيط باستخدام ScreenGui
local crosshairEnabled = false
local crosshairColor = Color3.fromRGB(255, 255, 255)
local crosshairSpin = false
local crosshairResize = false
local crosshairSticky = false
local crosshairPositionMode = "Middle"

-- إنشاء عنصر واجهة بسيط للـ Crosshair
local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "RayfieldCrosshair"
crosshairGui.Parent = CoreGui
crosshairGui.Enabled = false

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Size = UDim2.new(0, 10, 0, 10)
crosshairFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
crosshairFrame.BackgroundColor3 = crosshairColor
crosshairFrame.BackgroundTransparency = 0
crosshairFrame.BorderSizePixel = 0
crosshairFrame.Parent = crosshairGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = crosshairFrame

local function UpdateCrosshairPosition()
    if crosshairPositionMode == "Mouse" then
        local mousePos = UserInputService:GetMouseLocation()
        crosshairFrame.Position = UDim2.new(0, mousePos.X - 5, 0, mousePos.Y - 5)
    else
        crosshairFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
    end
end

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if crosshairPositionMode == "Mouse" then
            UpdateCrosshairPosition()
        end
    end
end)

-- دورة حياة الـ Crosshair
RunService.RenderStepped:Connect(function()
    if crosshairEnabled then
        crosshairGui.Enabled = true
        crosshairFrame.BackgroundColor3 = crosshairColor
        if crosshairSpin then
            crosshairFrame.Rotation = crosshairFrame.Rotation + 2
        else
            crosshairFrame.Rotation = 0
        end
        if crosshairResize then
            local sin = math.sin(tick() * 5)
            local size = 10 + sin * 5
            crosshairFrame.Size = UDim2.new(0, size, 0, size)
            crosshairFrame.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
        end
    else
        crosshairGui.Enabled = false
    end
end)

-- ========================
-- تحميل Rayfield
-- ========================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- إنشاء النافذة الرئيسية
local Window = Rayfield:CreateWindow({
    Name = "الميزات المستخرجة",
    LoadingTitle = "جاري التحميل...",
    LoadingSubtitle = "من Psalms.Tech",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PsalmsTech",
        FileName = "ExtractedFeatures"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- تبويب البيئة
local EnvTab = Window:CreateTab("البيئة", "rbxassetid://4483345998")
local EnvSection = EnvTab:CreateSection("الإضاءة")
EnvSection:CreateToggle({
    Name = "تفعيل تعديل الإضاءة",
    CurrentValue = Environment.Settings.Enabled,
    Flag = "EnvEnable",
    Callback = function(Value)
        Environment.Settings.Enabled = Value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "السطوع",
    Range = {0, 10},
    Increment = 0.1,
    CurrentValue = Environment.Settings.Brightness,
    Flag = "EnvBrightness",
    Callback = function(Value)
        Environment.Settings.Brightness = Value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "وقت الساعة",
    Range = {0, 24},
    Increment = 0.1,
    CurrentValue = Environment.Settings.ClockTime,
    Flag = "EnvClock",
    Callback = function(Value)
        Environment.Settings.ClockTime = Value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "مستوى التعريض",
    Range = {0, 10},
    Increment = 0.1,
    CurrentValue = Environment.Settings.Exposure,
    Flag = "EnvExposure",
    Callback = function(Value)
        Environment.Settings.Exposure = Value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "لون الضوء المحيط",
    CurrentValue = Environment.Settings.Ambient,
    Flag = "EnvAmbient",
    Callback = function(Value)
        Environment.Settings.Ambient = Value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "لون الضوء الخارجي",
    CurrentValue = Environment.Settings.OutdoorAmbient,
    Flag = "EnvOutdoor",
    Callback = function(Value)
        Environment.Settings.OutdoorAmbient = Value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "تحول اللون (أسفل)",
    CurrentValue = Environment.Settings.ColorShift_Bottom,
    Flag = "EnvShiftBottom",
    Callback = function(Value)
        Environment.Settings.ColorShift_Bottom = Value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "تحول اللون (أعلى)",
    CurrentValue = Environment.Settings.ColorShift_Top,
    Flag = "EnvShiftTop",
    Callback = function(Value)
        Environment.Settings.ColorShift_Top = Value
        UpdateWorld()
    end
})
EnvSection:CreateToggle({
    Name = "الظلال العامة",
    CurrentValue = Environment.Settings.GlobalShadows,
    Flag = "EnvShadows",
    Callback = function(Value)
        Environment.Settings.GlobalShadows = Value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "نعومة الظل",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = Environment.Settings.ShadowSoftness,
    Flag = "EnvShadowSoft",
    Callback = function(Value)
        Environment.Settings.ShadowSoftness = Value
        UpdateWorld()
    end
})

local FogSection = EnvTab:CreateSection("الضباب")
FogSection:CreateToggle({
    Name = "تفعيل الضباب",
    CurrentValue = Environment.Settings.FogEnabled,
    Flag = "FogEnable",
    Callback = function(Value)
        Environment.Settings.FogEnabled = Value
        UpdateFog()
    end
})
FogSection:CreateColorPicker({
    Name = "لون الضباب",
    CurrentValue = Environment.Settings.FogColor,
    Flag = "FogColor",
    Callback = function(Value)
        Environment.Settings.FogColor = Value
        UpdateFog()
    end
})
FogSection:CreateSlider({
    Name = "بداية الضباب",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = Environment.Settings.FogStart,
    Flag = "FogStart",
    Callback = function(Value)
        Environment.Settings.FogStart = Value
        UpdateFog()
    end
})
FogSection:CreateSlider({
    Name = "نهاية الضباب",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = Environment.Settings.FogEnd,
    Flag = "FogEnd",
    Callback = function(Value)
        Environment.Settings.FogEnd = Value
        UpdateFog()
    end
})

local SkyboxSection = EnvTab:CreateSection("السماء")
SkyboxSection:CreateToggle({
    Name = "تفعيل تغيير السماء",
    CurrentValue = skyboxEnabled,
    Flag = "SkyboxEnable",
    Callback = function(Value)
        skyboxEnabled = Value
        ChangeSkybox()
    end
})
SkyboxSection:CreateDropdown({
    Name = "نوع السماء",
    Options = {"1", "2", "3", "4", "5", "6", "7"},
    CurrentOption = "1",
    Flag = "SkyboxType",
    Callback = function(Value)
        skyboxType = tonumber(Value)
        ChangeSkybox()
    end
})

-- تبويب الرصاص
local BulletTab = Window:CreateTab("الرصاص", "rbxassetid://4483345998")
local BulletSection = BulletTab:CreateSection("مسارات الرصاص")
BulletSection:CreateToggle({
    Name = "تفعيل مسارات الرصاص",
    CurrentValue = Configurations.Visuals.Bullet_Trails.Enabled,
    Flag = "BulletEnable",
    Callback = function(Value)
        Configurations.Visuals.Bullet_Trails.Enabled = Value
    end
})
BulletSection:CreateColorPicker({
    Name = "لون المسار",
    CurrentValue = Configurations.Visuals.Bullet_Trails.Color,
    Flag = "BulletColor",
    Callback = function(Value)
        Configurations.Visuals.Bullet_Trails.Color = Value
    end
})
BulletSection:CreateSlider({
    Name = "العرض",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = Configurations.Visuals.Bullet_Trails.Width,
    Flag = "BulletWidth",
    Callback = function(Value)
        Configurations.Visuals.Bullet_Trails.Width = Value
    end
})
BulletSection:CreateSlider({
    Name = "المدة",
    Range = {0.5, 10},
    Increment = 0.1,
    CurrentValue = Configurations.Visuals.Bullet_Trails.Duration,
    Flag = "BulletDuration",
    Callback = function(Value)
        Configurations.Visuals.Bullet_Trails.Duration = Value
    end
})
BulletSection:CreateToggle({
    Name = "تلاشي",
    CurrentValue = Configurations.Visuals.Bullet_Trails.Fade,
    Flag = "BulletFade",
    Callback = function(Value)
        Configurations.Visuals.Bullet_Trails.Fade = Value
    end
})
BulletSection:CreateDropdown({
    Name = "نسيج المسار",
    Options = {"Cool", "Cum", "Electro"},
    CurrentOption = Configurations.Visuals.Bullet_Trails.Texture,
    Flag = "BulletTexture",
    Callback = function(Value)
        Configurations.Visuals.Bullet_Trails.Texture = Value
    end
})

-- تبويب اللاعب المحلي
local LocalTab = Window:CreateTab("اللاعب", "rbxassetid://4483345998")
local TrailSection = LocalTab:CreateSection("مسار اللاعب")
TrailSection:CreateToggle({
    Name = "تفعيل مسار اللاعب",
    CurrentValue = trailEnabled,
    Flag = "TrailEnable",
    Callback = function(Value)
        SetTrailEnabled(Value)
    end
})
TrailSection:CreateColorPicker({
    Name = "لون المسار",
    CurrentValue = trailColor,
    Flag = "TrailColor",
    Callback = function(Value)
        trailColor = Value
    end
})

local BodyChamSection = LocalTab:CreateSection("شامات الجسم")
BodyChamSection:CreateToggle({
    Name = "تفعيل شامات الجسم",
    CurrentValue = localPlayerEsp.ForcefieldBody.Enabled,
    Flag = "BodyCham",
    Callback = function(Value)
        localPlayerEsp.ForcefieldBody.Enabled = Value
        ApplyForcefieldToBody()
    end
})
BodyChamSection:CreateColorPicker({
    Name = "لون الجسم",
    CurrentValue = localPlayerEsp.ForcefieldBody.Color,
    Flag = "BodyChamColor",
    Callback = function(Value)
        localPlayerEsp.ForcefieldBody.Color = Value
        ApplyForcefieldToBody()
    end
})

local ToolChamSection = LocalTab:CreateSection("شامات الأدوات")
ToolChamSection:CreateToggle({
    Name = "تفعيل شامات الأدوات",
    CurrentValue = localPlayerEsp.ForcefieldTools.Enabled,
    Flag = "ToolCham",
    Callback = function(Value)
        localPlayerEsp.ForcefieldTools.Enabled = Value
        ApplyForcefieldToTools()
    end
})
ToolChamSection:CreateColorPicker({
    Name = "لون الأدوات",
    CurrentValue = localPlayerEsp.ForcefieldTools.Color,
    Flag = "ToolChamColor",
    Callback = function(Value)
        localPlayerEsp.ForcefieldTools.Color = Value
        ApplyForcefieldToTools()
    end
})

local HatChamSection = LocalTab:CreateSection("شامات الإكسسوارات")
HatChamSection:CreateToggle({
    Name = "تفعيل شامات الإكسسوارات",
    CurrentValue = localPlayerEsp.ForcefieldHats.Enabled,
    Flag = "HatCham",
    Callback = function(Value)
        localPlayerEsp.ForcefieldHats.Enabled = Value
        ApplyForcefieldToHats()
    end
})
HatChamSection:CreateColorPicker({
    Name = "لون الإكسسوارات",
    CurrentValue = localPlayerEsp.ForcefieldHats.Color,
    Flag = "HatChamColor",
    Callback = function(Value)
        localPlayerEsp.ForcefieldHats.Color = Value
        ApplyForcefieldToHats()
    end
})

-- تبويب المؤشر
local CrossTab = Window:CreateTab("المؤشر", "rbxassetid://4483345998")
local CrossSection = CrossTab:CreateSection("إعدادات المؤشر")
CrossSection:CreateToggle({
    Name = "تفعيل المؤشر",
    CurrentValue = crosshairEnabled,
    Flag = "CrossEnable",
    Callback = function(Value)
        crosshairEnabled = Value
    end
})
CrossSection:CreateColorPicker({
    Name = "لون المؤشر",
    CurrentValue = crosshairColor,
    Flag = "CrossColor",
    Callback = function(Value)
        crosshairColor = Value
    end
})
CrossSection:CreateToggle({
    Name = "دوران",
    CurrentValue = crosshairSpin,
    Flag = "CrossSpin",
    Callback = function(Value)
        crosshairSpin = Value
    end
})
CrossSection:CreateToggle({
    Name = "تكبير وتصغير",
    CurrentValue = crosshairResize,
    Flag = "CrossResize",
    Callback = function(Value)
        crosshairResize = Value
    end
})
CrossSection:CreateToggle({
    Name = "الالتصاق بالهدف (غير مفعل)", -- بدون نظام هدف
    CurrentValue = crosshairSticky,
    Flag = "CrossSticky",
    Callback = function(Value)
        crosshairSticky = Value
    end
})
CrossSection:CreateDropdown({
    Name = "الوضع",
    Options = {"Middle", "Mouse"},
    CurrentOption = crosshairPositionMode,
    Flag = "CrossPos",
    Callback = function(Value)
        crosshairPositionMode = Value
        UpdateCrosshairPosition()
    end
})

-- رسالة تأكيد
Rayfield:Notify({
    Title = "تم التحميل",
    Content = "تم تحميل جميع الميزات الأربعة بنجاح",
    Duration = 3
})

-- فتح الواجهة عند الضغط على مفتاح (اختياري)
local toggleKey = Enum.KeyCode.RightControl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        Window:Toggle()
    end
end)
