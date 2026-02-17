-- Rayfield Library Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Original Lighting settings
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

-- Environment settings table
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

-- Update world lighting based on settings
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

-- Fog update
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

-- Skybox variables
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

-- Bullet trail textures
local BulletTexture = {
    Electro = "rbxassetid://139193109954329",
    Cool = "rbxassetid://116848240236550",
    Cum = "rbxassetid://88263664141635"
}

-- Bullet trail config
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

-- Utility functions for bullet trails
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

-- Detect bullets and create trails
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

-- Local Player Trail
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

-- Local Player Chams (ForceField)
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

-- Connect character respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    UpdateAllForcefields()
end)

if LocalPlayer.Character then
    UpdateAllForcefields()
end

-- Crosshair setup
local Cursor = loadstring(game:HttpGet("https://gist.githubusercontent.com/CongoOhioDog/53ec2f8bdde91bda1d9a17fe5d11e23f/raw/1e5dde366ce1f20ea6621ed230837eb69f441dbc/gistfile1.txt", true))()
getgenv().crosshair = {
    color = Color3.fromRGB(255, 255, 255),
    mode = "Middle",
    sticky = false,
    enabled = false,
    spin = false,
    resize = false,
    position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
}

local crosshairPositionMode = "Middle"
RunService.PostSimulation:Connect(function()
    if getgenv().crosshair.sticky and TargetPlr and TargetPlr.Character then
        -- Sticky to target is not extracted (no aimbot), so we'll ignore or disable.
        -- We'll keep the original logic but TargetPlr may not exist. Better to disable sticky.
        -- We'll handle it by not using sticky since we don't have target selection.
    else
        getgenv().crosshair.mode = crosshairPositionMode
    end
end)

-- Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Extracted Features",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Psalms Tech",
    ConfigurationSaving = { Enabled = true, FolderName = "PsalmsTech", FileName = "Extracted" },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Environment Tab
local EnvTab = Window:CreateTab("Environment", "rbxassetid://4483345998")
local EnvSection = EnvTab:CreateSection("Lighting")
EnvSection:CreateToggle({
    Name = "Enable Lighting Override",
    CurrentValue = false,
    Flag = "EnvEnable",
    Callback = function(value)
        Environment.Settings.Enabled = value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "Exposure",
    Range = {0, 10},
    Increment = 0.1,
    CurrentValue = Environment.Settings.Exposure,
    Flag = "EnvExposure",
    Callback = function(value)
        Environment.Settings.Exposure = value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "Clock Time",
    Range = {0, 24},
    Increment = 0.1,
    CurrentValue = Environment.Settings.ClockTime,
    Flag = "EnvClock",
    Callback = function(value)
        Environment.Settings.ClockTime = value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "Brightness",
    Range = {0, 10},
    Increment = 0.1,
    CurrentValue = Environment.Settings.Brightness,
    Flag = "EnvBrightness",
    Callback = function(value)
        Environment.Settings.Brightness = value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "Ambient Color",
    CurrentValue = Environment.Settings.Ambient,
    Flag = "EnvAmbient",
    Callback = function(value)
        Environment.Settings.Ambient = value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "Outdoor Ambient",
    CurrentValue = Environment.Settings.OutdoorAmbient,
    Flag = "EnvOutdoor",
    Callback = function(value)
        Environment.Settings.OutdoorAmbient = value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "Color Shift Bottom",
    CurrentValue = Environment.Settings.ColorShift_Bottom,
    Flag = "EnvShiftBottom",
    Callback = function(value)
        Environment.Settings.ColorShift_Bottom = value
        UpdateWorld()
    end
})
EnvSection:CreateColorPicker({
    Name = "Color Shift Top",
    CurrentValue = Environment.Settings.ColorShift_Top,
    Flag = "EnvShiftTop",
    Callback = function(value)
        Environment.Settings.ColorShift_Top = value
        UpdateWorld()
    end
})
EnvSection:CreateToggle({
    Name = "Global Shadows",
    CurrentValue = Environment.Settings.GlobalShadows,
    Flag = "EnvShadows",
    Callback = function(value)
        Environment.Settings.GlobalShadows = value
        UpdateWorld()
    end
})
EnvSection:CreateSlider({
    Name = "Shadow Softness",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = Environment.Settings.ShadowSoftness,
    Flag = "EnvShadowSoft",
    Callback = function(value)
        Environment.Settings.ShadowSoftness = value
        UpdateWorld()
    end
})

local FogSection = EnvTab:CreateSection("Fog")
FogSection:CreateToggle({
    Name = "Enable Fog",
    CurrentValue = false,
    Flag = "FogEnable",
    Callback = function(value)
        Environment.Settings.FogEnabled = value
        UpdateFog()
    end
})
FogSection:CreateColorPicker({
    Name = "Fog Color",
    CurrentValue = Environment.Settings.FogColor,
    Flag = "FogColor",
    Callback = function(value)
        Environment.Settings.FogColor = value
        UpdateFog()
    end
})
FogSection:CreateSlider({
    Name = "Fog Start",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = Environment.Settings.FogStart,
    Flag = "FogStart",
    Callback = function(value)
        Environment.Settings.FogStart = value
        UpdateFog()
    end
})
FogSection:CreateSlider({
    Name = "Fog End",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = Environment.Settings.FogEnd,
    Flag = "FogEnd",
    Callback = function(value)
        Environment.Settings.FogEnd = value
        UpdateFog()
    end
})

local SkyboxSection = EnvTab:CreateSection("Skybox")
SkyboxSection:CreateToggle({
    Name = "Enable Skybox",
    CurrentValue = false,
    Flag = "SkyboxEnable",
    Callback = function(value)
        skyboxEnabled = value
        ChangeSkybox()
    end
})
SkyboxSection:CreateDropdown({
    Name = "Skybox Type",
    Options = {"1", "2", "3", "4", "5", "6", "7"},
    CurrentOption = "1",
    Flag = "SkyboxType",
    Callback = function(value)
        skyboxType = tonumber(value)
        ChangeSkybox()
    end
})

-- Bullets Tab
local BulletTab = Window:CreateTab("Bullets", "rbxassetid://4483345998")
local BulletSection = BulletTab:CreateSection("Bullet Trails")
BulletSection:CreateToggle({
    Name = "Enable Bullet Trails",
    CurrentValue = false,
    Flag = "BulletTrailEnable",
    Callback = function(value)
        Configurations.Visuals.Bullet_Trails.Enabled = value
    end
})
BulletSection:CreateColorPicker({
    Name = "Trail Color",
    CurrentValue = Configurations.Visuals.Bullet_Trails.Color,
    Flag = "BulletColor",
    Callback = function(value)
        Configurations.Visuals.Bullet_Trails.Color = value
    end
})
BulletSection:CreateSlider({
    Name = "Width",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = Configurations.Visuals.Bullet_Trails.Width,
    Flag = "BulletWidth",
    Callback = function(value)
        Configurations.Visuals.Bullet_Trails.Width = value
    end
})
BulletSection:CreateSlider({
    Name = "Duration",
    Range = {0.5, 10},
    Increment = 0.1,
    CurrentValue = Configurations.Visuals.Bullet_Trails.Duration,
    Flag = "BulletDuration",
    Callback = function(value)
        Configurations.Visuals.Bullet_Trails.Duration = value
    end
})
BulletSection:CreateToggle({
    Name = "Fade",
    CurrentValue = false,
    Flag = "BulletFade",
    Callback = function(value)
        Configurations.Visuals.Bullet_Trails.Fade = value
    end
})
BulletSection:CreateDropdown({
    Name = "Texture",
    Options = {"Cool", "Cum", "Electro"},
    CurrentOption = "Cool",
    Flag = "BulletTexture",
    Callback = function(value)
        Configurations.Visuals.Bullet_Trails.Texture = value
    end
})

-- Local Player Tab
local LocalTab = Window:CreateTab("Local Player", "rbxassetid://4483345998")
local TrailSection = LocalTab:CreateSection("Trail")
TrailSection:CreateToggle({
    Name = "Enable Trail",
    CurrentValue = false,
    Flag = "TrailEnable",
    Callback = SetTrailEnabled
})
TrailSection:CreateColorPicker({
    Name = "Trail Color",
    CurrentValue = trailColor,
    Flag = "TrailColor",
    Callback = function(value)
        trailColor = value
    end
})

local BodyChamSection = LocalTab:CreateSection("Body Chams")
BodyChamSection:CreateToggle({
    Name = "Body ForceField",
    CurrentValue = false,
    Flag = "BodyCham",
    Callback = function(value)
        localPlayerEsp.ForcefieldBody.Enabled = value
        ApplyForcefieldToBody()
    end
})
BodyChamSection:CreateColorPicker({
    Name = "Body Color",
    CurrentValue = localPlayerEsp.ForcefieldBody.Color,
    Flag = "BodyChamColor",
    Callback = function(value)
        localPlayerEsp.ForcefieldBody.Color = value
        ApplyForcefieldToBody()
    end
})

local ToolChamSection = LocalTab:CreateSection("Tool Chams")
ToolChamSection:CreateToggle({
    Name = "Tool ForceField",
    CurrentValue = false,
    Flag = "ToolCham",
    Callback = function(value)
        localPlayerEsp.ForcefieldTools.Enabled = value
        ApplyForcefieldToTools()
    end
})
ToolChamSection:CreateColorPicker({
    Name = "Tool Color",
    CurrentValue = localPlayerEsp.ForcefieldTools.Color,
    Flag = "ToolChamColor",
    Callback = function(value)
        localPlayerEsp.ForcefieldTools.Color = value
        ApplyForcefieldToTools()
    end
})

local HatChamSection = LocalTab:CreateSection("Accessories Chams")
HatChamSection:CreateToggle({
    Name = "Accessories ForceField",
    CurrentValue = false,
    Flag = "HatCham",
    Callback = function(value)
        localPlayerEsp.ForcefieldHats.Enabled = value
        ApplyForcefieldToHats()
    end
})
HatChamSection:CreateColorPicker({
    Name = "Accessories Color",
    CurrentValue = localPlayerEsp.ForcefieldHats.Color,
    Flag = "HatChamColor",
    Callback = function(value)
        localPlayerEsp.ForcefieldHats.Color = value
        ApplyForcefieldToHats()
    end
})

-- Crosshair Tab
local CrosshairTab = Window:CreateTab("Crosshair", "rbxassetid://4483345998")
local CrossSection = CrosshairTab:CreateSection("Crosshair Settings")
CrossSection:CreateToggle({
    Name = "Enable Crosshair",
    CurrentValue = false,
    Flag = "CrossEnable",
    Callback = function(value)
        getgenv().crosshair.enabled = value
    end
})
CrossSection:CreateColorPicker({
    Name = "Crosshair Color",
    CurrentValue = getgenv().crosshair.color,
    Flag = "CrossColor",
    Callback = function(value)
        getgenv().crosshair.color = value
    end
})
CrossSection:CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Flag = "CrossSpin",
    Callback = function(value)
        getgenv().crosshair.spin = value
    end
})
CrossSection:CreateToggle({
    Name = "Resize",
    CurrentValue = false,
    Flag = "CrossResize",
    Callback = function(value)
        getgenv().crosshair.resize = value
    end
})
CrossSection:CreateToggle({
    Name = "Sticky (requires target)",
    CurrentValue = false,
    Flag = "CrossSticky",
    Callback = function(value)
        getgenv().crosshair.sticky = value
    end
})
CrossSection:CreateDropdown({
    Name = "Position",
    Options = {"Middle", "Mouse"},
    CurrentOption = "Middle",
    Flag = "CrossPosition",
    Callback = function(value)
        crosshairPositionMode = value
        getgenv().crosshair.mode = value
    end
})

-- Notify
Rayfield:Notify({
    Title = "Extracted Features Loaded",
    Content = "Environment, Bullets, Local Player, Crosshair",
    Duration = 3
})
