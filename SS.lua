-- Player ESP Script (مرئيات لاعبين دقيقة حسب الصورة)
-- يستخدم مكتبة Rayfield Interface Suite (رابط https://sirius.menu/rayfield)
-- تحديثات: Health Bar تدرج سلس متصل (غير متقطع بزيادة numLines)، إزالة Chams Outline نهائياً (بدون Picker و Transparency=1)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Player Visuals",
    LoadingTitle = "Player ESP",
    LoadingSubtitle = "by Professional Developer",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PlayerESPConfig",
        FileName = "Settings"
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Players", "user")

Tab:CreateSection("Player Visuals")
Tab:CreateToggle({
    Name = "Enabled",
    CurrentValue = true,
    Flag = "ESP_Enabled",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Bounding Boxes",
    CurrentValue = false,
    Flag = "ESP_BoundingBoxes",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Box Color",
    Color = Color3.new(1, 1, 1),
    Flag = "ESP_BoxColor",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Corner Boxes",
    CurrentValue = true,
    Flag = "ESP_CornerBoxes",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Filled Boxes",
    CurrentValue = true,
    Flag = "ESP_FilledBoxes",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Fill Color 1",
    Color = Color3.fromRGB(0, 100, 255),
    Flag = "ESP_FillColor1",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Fill Color 2",
    Color = Color3.fromRGB(255, 0, 100),
    Flag = "ESP_FillColor2",
    Callback = function() end
})
Tab:CreateToggle({
    Name = "Use Team Colors for Fill",
    CurrentValue = false,
    Flag = "ESP_UseTeamColors",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Names",
    CurrentValue = true,
    Flag = "ESP_Names",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Name Color",
    Color = Color3.new(1, 1, 1),
    Flag = "ESP_NameColor",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = false,
    Flag = "ESP_HealthBars",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "High Health Color",
    Color = Color3.new(0, 1, 0),
    Flag = "ESP_HighHealthColor",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Low Health Color",
    Color = Color3.new(1, 0, 0),
    Flag = "ESP_LowHealthColor",
    Callback = function() end
})
Tab:CreateSlider({
    Name = "Health Bar Width",
    Range = {0.5, 15},
    Increment = 0.5,
    Suffix = "px",
    CurrentValue = 4,
    Flag = "ESP_HealthBarWidth",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Health Text",
    CurrentValue = true,
    Flag = "ESP_HealthText",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Health Text Color",
    Color = Color3.new(1, 1, 1),
    Flag = "ESP_HealthTextColor",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Weapons",
    CurrentValue = true,
    Flag = "ESP_Weapons",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Weapon Color",
    Color = Color3.new(1, 1, 1),
    Flag = "ESP_WeaponColor",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Distance",
    CurrentValue = false,
    Flag = "ESP_Distance",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "ESP_Chams",
    Callback = function() end
})
Tab:CreateToggle({
    Name = "Chams Fill Enabled",
    CurrentValue = true,
    Flag = "ESP_ChamsFillEnabled",
    Callback = function() end
})
Tab:CreateColorPicker({
    Name = "Chams Fill Color",
    Color = Color3.fromRGB(0, 100, 255),
    Flag = "ESP_ChamsFill",
    Callback = function() end
})

Tab:CreateSection("Player Visual Settings")
Tab:CreateToggle({
    Name = "Animated Boxes",
    CurrentValue = true,
    Flag = "ESP_AnimatedBoxes",
    Callback = function() end
})
Tab:CreateToggle({
    Name = "Animated Filled Boxes",
    CurrentValue = true,
    Flag = "ESP_AnimatedFilled",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Dynamic Health Text",
    CurrentValue = true,
    Flag = "ESP_DynamicHealthText",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Gradient Health Bar",
    CurrentValue = true,
    Flag = "ESP_GradientHealthBar",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Thermal Chams",
    CurrentValue = false,
    Flag = "ESP_ThermalChams",
    Callback = function() end
})

Tab:CreateToggle({
    Name = "Only Visible Players",
    CurrentValue = true,
    Flag = "ESP_OnlyVisible",
    Callback = function() end
})

Tab:CreateDropdown({
    Name = "Chams Style",
    Options = {"Pixel", "Normal"},
    CurrentOption = {"Pixel"},
    Flag = "ESP_ChamsStyle",
    Callback = function() end
})

Tab:CreateSlider({
    Name = "Text Size",
    Range = {8, 24},
    Increment = 1,
    CurrentValue = 12,
    Flag = "ESP_TextSize",
    Callback = function() end
})

Tab:CreateSlider({
    Name = "Max Render Distance",
    Range = {100, 5000},
    Increment = 50,
    Suffix = "st",
    CurrentValue = 1550,
    Flag = "ESP_MaxDistance",
    Callback = function() end
})

-- ESP Logic
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local ESPDrawings = {}
local ESPHighlights = {}

local function CreateESP(player)
    if player == LocalPlayer then return end

    local drawings = {
        Bounding = Drawing.new("Square"),
        Filled = Drawing.new("Square"),
        HealthFill = Drawing.new("Square"),  -- للـ non-gradient
        HealthLines = {},  -- للـ gradient lines
        Name = Drawing.new("Text"),
        HealthNum = Drawing.new("Text"),
        Weapon = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        CornerLines = table.create(8)
    }

    for i = 1, 8 do 
        drawings.CornerLines[i] = Drawing.new("Line") 
    end

    drawings.Bounding.Thickness = 2
    drawings.Bounding.Filled = false
    drawings.Filled.Filled = true
    drawings.Filled.Transparency = 0.3
    drawings.HealthFill.Filled = true

    for _, txt in {drawings.Name, drawings.HealthNum, drawings.Weapon, drawings.Distance} do
        txt.Font = Drawing.Fonts.Plex
        txt.Outline = true
        txt.Center = true
    end

    ESPDrawings[player] = drawings
end

local function RemoveESP(player)
    local drawings = ESPDrawings[player]
    if drawings then
        for _, line in ipairs(drawings.HealthLines or {}) do
            line:Remove()
        end
        for _, obj in pairs(drawings) do
            if typeof(obj) == "table" then
                for _, line in ipairs(obj) do 
                    line:Remove() 
                end
            else
                obj:Remove()
            end
        end
        ESPDrawings[player] = nil
    end

    local hl = ESPHighlights[player]
    if hl then
        hl:Destroy()
        ESPHighlights[player] = nil
    end
end

for _, plr in ipairs(Players:GetPlayers()) do 
    CreateESP(plr) 
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

local function UpdateCorners(lines, pos, size, color, thickness)
    local third = size.X / 3
    local o = {
        {Vector2.new(pos.X, pos.Y + third), Vector2.new(pos.X, pos.Y)},
        {Vector2.new(pos.X, pos.Y), Vector2.new(pos.X + third, pos.Y)},
        {Vector2.new(pos.X + size.X - third, pos.Y), Vector2.new(pos.X + size.X, pos.Y)},
        {Vector2.new(pos.X + size.X, pos.Y), Vector2.new(pos.X + size.X, pos.Y + third)},
        {Vector2.new(pos.X, pos.Y + size.Y - third), Vector2.new(pos.X, pos.Y + size.Y)},
        {Vector2.new(pos.X, pos.Y + size.Y), Vector2.new(pos.X + third, pos.Y + size.Y)},
        {Vector2.new(pos.X + size.X - third, pos.Y + size.Y), Vector2.new(pos.X + size.X, pos.Y + size.Y)},
        {Vector2.new(pos.X + size.X, pos.Y + size.Y - third), Vector2.new(pos.X + size.X, pos.Y + size.Y)}
    }
    for i = 1, 8 do
        local line = lines[i]
        line.From = o[i][1]
        line.To = o[i][2]
        line.Color = color
        line.Thickness = thickness
        line.Visible = true
    end
end

local UpdateConnection
UpdateConnection = RunService.RenderStepped:Connect(function()
    if not Rayfield.Flags.ESP_Enabled.CurrentValue then
        -- إخفاء فوري لجميع الرسومات عند الإغلاق
        for player, drawings in pairs(ESPDrawings) do
            drawings.Bounding.Visible = false
            drawings.Filled.Visible = false
            drawings.HealthFill.Visible = false
            drawings.Name.Visible = false
            drawings.HealthNum.Visible = false
            drawings.Weapon.Visible = false
            drawings.Distance.Visible = false
            for _, line in ipairs(drawings.CornerLines) do
                line.Visible = false
            end
            for _, line in ipairs(drawings.HealthLines or {}) do
                line.Visible = false
            end
        end
        -- إزالة Highlights
        for player, hl in pairs(ESPHighlights) do
            if hl then hl:Destroy() end
        end
        ESPHighlights = {}
        return
    end

    local lChar = LocalPlayer.Character
    local lRoot = lChar and lChar:FindFirstChild("HumanoidRootPart")
    if not lRoot then return end

    for player, drawings in pairs(ESPDrawings) do
        local char = player.Character
        if not char then 
            drawings.Bounding.Visible = false
            drawings.Filled.Visible = false
            drawings.HealthFill.Visible = false
            drawings.Name.Visible = false
            drawings.HealthNum.Visible = false
            drawings.Weapon.Visible = false
            drawings.Distance.Visible = false
            for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
            for _, line in ipairs(drawings.HealthLines or {}) do line.Visible = false end
            continue 
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then 
            drawings.Bounding.Visible = false
            drawings.Filled.Visible = false
            drawings.HealthFill.Visible = false
            drawings.Name.Visible = false
            drawings.HealthNum.Visible = false
            drawings.Weapon.Visible = false
            drawings.Distance.Visible = false
            for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
            for _, line in ipairs(drawings.HealthLines or {}) do line.Visible = false end
            continue 
        end

        local dist = (root.Position - lRoot.Position).Magnitude
        if dist > Rayfield.Flags.ESP_MaxDistance.CurrentValue then 
            drawings.Bounding.Visible = false
            drawings.Filled.Visible = false
            drawings.HealthFill.Visible = false
            drawings.Name.Visible = false
            drawings.HealthNum.Visible = false
            drawings.Weapon.Visible = false
            drawings.Distance.Visible = false
            for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
            for _, line in ipairs(drawings.HealthLines or {}) do line.Visible = false end
            continue 
        end

        local head = char:FindFirstChild("Head")
        if not head then 
            drawings.Bounding.Visible = false
            drawings.Filled.Visible = false
            drawings.HealthFill.Visible = false
            drawings.Name.Visible = false
            drawings.HealthNum.Visible = false
            drawings.Weapon.Visible = false
            drawings.Distance.Visible = false
            for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
            for _, line in ipairs(drawings.HealthLines or {}) do line.Visible = false end
            continue 
        end

        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        if Rayfield.Flags.ESP_OnlyVisible.CurrentValue and not onScreen then 
            drawings.Bounding.Visible = false
            drawings.Filled.Visible = false
            drawings.HealthFill.Visible = false
            drawings.Name.Visible = false
            drawings.HealthNum.Visible = false
            drawings.Weapon.Visible = false
            drawings.Distance.Visible = false
            for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
            for _, line in ipairs(drawings.HealthLines or {}) do line.Visible = false end
            continue 
        end

        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local height = math.abs(headPos.Y - legPos.Y)
        local width = height * 0.65

        local boxPos = Vector2.new(headPos.X - width / 2, headPos.Y - height * 0.15)
        local boxSize = Vector2.new(width, height)

        local healthPct = hum.Health / hum.MaxHealth

        -- Team Colors
        local teamColor = Rayfield.Flags.ESP_UseTeamColors.CurrentValue and (player.TeamColor and player.TeamColor.Color or Color3.new(1, 1, 1)) or Rayfield.Flags.ESP_FillColor1.Color

        -- Animated Boxes (بطيء للـ Box + Fill)
        local pulseTime = tick() * 1.5  -- بطيء جداً
        local pulseThick = Rayfield.Flags.ESP_AnimatedBoxes.CurrentValue and (2 + math.sin(pulseTime) * 0.5) or 2
        local fillPulseTrans = Rayfield.Flags.ESP_AnimatedFilled.CurrentValue and (0.4 + math.sin(pulseTime * 0.8) * 0.2) or 0.3
        local animFillColor = Rayfield.Flags.ESP_AnimatedFilled.CurrentValue 
            and Rayfield.Flags.ESP_FillColor1.Color:Lerp(Rayfield.Flags.ESP_FillColor2.Color, math.abs(math.sin(pulseTime * 0.5))) 
            or Rayfield.Flags.ESP_FillColor1.Color
        local finalFillColor = Rayfield.Flags.ESP_UseTeamColors.CurrentValue and teamColor or animFillColor

        -- Boxes
        drawings.Bounding.Position = boxPos
        drawings.Bounding.Size = boxSize
        drawings.Bounding.Color = Rayfield.Flags.ESP_BoxColor.Color
        drawings.Bounding.Thickness = pulseThick
        drawings.Bounding.Visible = Rayfield.Flags.ESP_BoundingBoxes.CurrentValue

        drawings.Filled.Position = boxPos
        drawings.Filled.Size = boxSize
        drawings.Filled.Color = finalFillColor
        drawings.Filled.Transparency = fillPulseTrans
        drawings.Filled.Visible = Rayfield.Flags.ESP_FilledBoxes.CurrentValue

        if Rayfield.Flags.ESP_CornerBoxes.CurrentValue then
            UpdateCorners(drawings.CornerLines, boxPos, boxSize, Rayfield.Flags.ESP_BoxColor.Color, pulseThick)
        else
            for _, line in ipairs(drawings.CornerLines) do line.Visible = false end
        end

        -- Health Bar (سمك متغير + تدرج عمودي سلس متصل غير متقطع، بدون إطار أسود)
        local barW = Rayfield.Flags.ESP_HealthBarWidth.CurrentValue
        local barPos = Vector2.new(boxPos.X - barW - 4, boxPos.Y)
        local barSize = Vector2.new(barW, boxSize.Y)

        local fillH = barSize.Y * healthPct
        local fillStartY = barPos.Y + barSize.Y - fillH

        if Rayfield.Flags.ESP_GradientHealthBar.CurrentValue then
            -- إخفاء الـ Fill الرئيسي وارسم lines للتدرج
            drawings.HealthFill.Visible = false

            -- زيادة numLines ليكون سلساً (غير متقطع)
            local numLines = math.clamp(math.floor(fillH), 1, 200)  -- حتى 200 لسلسة عالية دون تأثير أداء كبير
            if #drawings.HealthLines < numLines then
                for i = #drawings.HealthLines + 1, numLines do
                    local line = Drawing.new("Line")
                    line.Thickness = fillH / numLines
                    line.Visible = true
                    drawings.HealthLines[i] = line
                end
            elseif #drawings.HealthLines > numLines then
                for i = numLines + 1, #drawings.HealthLines do
                    drawings.HealthLines[i].Visible = false
                end
            end

            local lineHeight = fillH / numLines
            for i = 1, numLines do
                local line = drawings.HealthLines[i]
                local pct = (i - 1) / (numLines - 1)  -- 0 أعلى (High) إلى 1 تحت (Low)
                line.Color = Rayfield.Flags.ESP_HighHealthColor.Color:Lerp(Rayfield.Flags.ESP_LowHealthColor.Color, pct)
                line.From = Vector2.new(barPos.X, fillStartY + (i - 1) * lineHeight)
                line.To = Vector2.new(barPos.X + barW, fillStartY + (i - 1) * lineHeight)
                line.Visible = Rayfield.Flags.ESP_HealthBars.CurrentValue
                line.Thickness = lineHeight + 0.1  -- ضمان تداخل طفيف لسلسة
            end
        else
            -- استخدم Fill واحد بدون تدرج
            for _, line in ipairs(drawings.HealthLines or {}) do
                line.Visible = false
            end
            drawings.HealthFill.Position = Vector2.new(barPos.X, fillStartY)
            drawings.HealthFill.Size = Vector2.new(barW, fillH)
            drawings.HealthFill.Color = Rayfield.Flags.ESP_HighHealthColor.Color
            drawings.HealthFill.Visible = Rayfield.Flags.ESP_HealthBars.CurrentValue
        end

        -- Texts
        local tSize = Rayfield.Flags.ESP_TextSize.CurrentValue
        local centerX = boxPos.X + boxSize.X / 2

        drawings.Name.Position = Vector2.new(centerX, boxPos.Y - tSize - 8)
        drawings.Name.Text = player.DisplayName
        drawings.Name.Color = Rayfield.Flags.ESP_NameColor.Color
        drawings.Name.Size = tSize
        drawings.Name.Visible = Rayfield.Flags.ESP_Names.CurrentValue

        drawings.HealthNum.Position = Vector2.new(centerX, boxPos.Y + boxSize.Y + 4)
        drawings.HealthNum.Text = math.floor(hum.Health) .. "/" .. hum.MaxHealth
        drawings.HealthNum.Color = Rayfield.Flags.ESP_DynamicHealthText.CurrentValue
            and Rayfield.Flags.ESP_HighHealthColor.Color:Lerp(Rayfield.Flags.ESP_LowHealthColor.Color, 1 - healthPct)
            or Rayfield.Flags.ESP_HealthTextColor.Color
        drawings.HealthNum.Size = tSize
        drawings.HealthNum.Visible = Rayfield.Flags.ESP_HealthText.CurrentValue

        local tool = char:FindFirstChildOfClass("Tool")
        drawings.Weapon.Position = Vector2.new(centerX, boxPos.Y - tSize - 22)
        drawings.Weapon.Text = tool and tool.Name or "None"
        drawings.Weapon.Color = Rayfield.Flags.ESP_WeaponColor.Color
        drawings.Weapon.Size = tSize
        drawings.Weapon.Visible = Rayfield.Flags.ESP_Weapons.CurrentValue

        drawings.Distance.Position = Vector2.new(centerX, boxPos.Y + boxSize.Y + tSize + 8)
        drawings.Distance.Text = math.floor(dist) .. "st"
        drawings.Distance.Color = Color3.new(1, 1, 1)  -- لون أبيض ثابت بعد إزالة ColorPicker
        drawings.Distance.Size = tSize
        drawings.Distance.Visible = Rayfield.Flags.ESP_Distance.CurrentValue
    end

    -- Chams (لون ثابت من ColorPicker، تغيير تلقائي فقط إذا Thermal مفعل، Team Colors إذا مفعل، بدون Outline)
    if Rayfield.Flags.ESP_Chams.CurrentValue then
        local fill = Rayfield.Flags.ESP_ThermalChams.CurrentValue
            and Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
            or Rayfield.Flags.ESP_ChamsFill.Color
        local transp = Rayfield.Flags.ESP_ChamsStyle.CurrentOption[1] == "Pixel" and 0.2 or 0.4
        local fillTrans = Rayfield.Flags.ESP_ChamsFillEnabled.CurrentValue and transp or 1  -- إيقاف Fill إذا غير مفعل

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local head = char:FindFirstChild("Head")
                    if hum and root and head and hum.Health > 0 then
                        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if not Rayfield.Flags.ESP_OnlyVisible.CurrentValue or onScreen then
                            local teamColor = Rayfield.Flags.ESP_UseTeamColors.CurrentValue and (plr.TeamColor and plr.TeamColor.Color or Color3.new(1, 1, 1)) or fill
                            local hl = ESPHighlights[plr] or Instance.new("Highlight")
                            hl.Name = "ESPHighlight"
                            hl.Parent = char
                            hl.Adornee = char
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.FillColor = teamColor
                            hl.FillTransparency = fillTrans
                            hl.OutlineTransparency = 1  -- إزالة Outline نهائياً
                            ESPHighlights[plr] = hl
                        else
                            local hl = ESPHighlights[plr]
                            if hl then hl:Destroy() ESPHighlights[plr] = nil end
                        end
                    end
                end
            end
        end
    else
        for player, hl in pairs(ESPHighlights) do
            if hl then hl:Destroy() end
        end
        ESPHighlights = {}
    end
end)

Rayfield:Notify({
    Title = "Player ESP Updated",
    Content = "تحديثات مطبقة: Health Bar تدرج سلس متصل غير متقطع، إزالة Chams Outline نهائياً.",
    Duration = 8,
    Image = 4483362748
})
