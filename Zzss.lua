local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- متغيرات التتبع
local currentHighlight = nil
local currentPath = nil
local currentTarget = nil
local lastTarget = nil  -- جديد: لتتبع آخر جزء مضغوط

-- حالة اللغة (ar = عربي، en = إنجليزي)
local currentLang = "en"  -- افتراضي إنجليزي

-- نصوص متعددة اللغات (العنوان الآن ثابت)
local texts = {
    en = {
        infoDefault = "Click on any part in the game to start scanning...",
        name = "Name",
        type = "Type",
        parent = "Parent",
        position = "Position",
        path = "Full Path",
        scripts = "Scripts / Remotes",
        none = "None",
        description = "Description",
        copyAll = "Copy All",
        copyPath = "Copy Path",
        delete = "Delete"
    },
    ar = {
        infoDefault = "اضغط على أي جزء في اللعبة لبدء الفحص...",
        name = "الاسم",
        type = "النوع",
        parent = "الأب",
        position = "الموقع",
        path = "المسار الكامل",
        scripts = "السكريبتات / الريموتات",
        none = "لا يوجد",
        description = "الوصف",
        copyAll = "نسخ الكل",
        copyPath = "نسخ المسار",
        delete = "حذف"
    }
}

-- دالة تحديث اللغة والمحاذاة
local function updateLanguage()
    local t = texts[currentLang]
    
    copyBtn:FindFirstChildWhichIsA("TextLabel").Text = t.copyAll
    pathBtn:FindFirstChildWhichIsA("TextLabel").Text = t.copyPath
    delBtn:FindFirstChildWhichIsA("TextLabel").Text = t.delete
    langBtn:FindFirstChildWhichIsA("TextLabel").Text = currentLang == "ar" and "ع" or "E"
    
    -- محاذاة المعلومات فقط
    local align = currentLang == "ar" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
    infoLabel.TextXAlignment = align
end

-- دالة استخراج المسار الكامل للجزء
local function getFullPath(instance)
    local path = {}
    local current = instance
    while current and current ~= game do
        local name = current.Name
        if name:find(" ") or name:find("[^%w]") then
            name = '["' .. name .. '"]'
        end
        table.insert(path, 1, name)
        current = current.Parent
    end
    return table.concat(path, ".")
end

-- تنظيف التحديد السابق
local function clearHighlight()
    if currentHighlight then currentHighlight:Destroy() currentHighlight = nil end
    currentPath = nil
    currentTarget = nil
end

-- إنشاء الـ GUI الرئيسي
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmoothNeonClickInfo"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- الواجهة الرئيسية (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 280)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local MainNeon = Instance.new("UIGradient")
MainNeon.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 20)),   
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 50, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
})
MainNeon.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -4, 1, -4)
contentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
contentFrame.AnchorPoint = Vector2.new(0.5, 0.5)
contentFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
contentFrame.ZIndex = 2
contentFrame.Parent = mainFrame
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- دالة إنشاء الأزرار بإطار نحيف ودوران سموث
local function CreateNeonButton(name, text, pos, size, color, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5
    btn.Parent = parent

    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundColor3 = Color3.new(1, 1, 1)
    border.ZIndex = 5
    border.Parent = btn
    Instance.new("UICorner", border).CornerRadius = UDim.new(0, 8)

    local bGrad = Instance.new("UIGradient")
    bGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color), 
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10,10,20)), 
        ColorSequenceKeypoint.new(1, color)
    })
    bGrad.Parent = border

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -2, 1, -2)
    inner.Position = UDim2.new(0.5,0,0.5,0)
    inner.AnchorPoint = Vector2.new(0.5,0.5)
    inner.BackgroundColor3 = Color3.fromRGB(15,15,22)
    inner.ZIndex = 6
    inner.Parent = btn
    Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 7)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.ZIndex = 7
    lbl.Parent = inner

    task.spawn(function()
        local rotationInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
        local tween = TweenService:Create(bGrad, rotationInfo, {Rotation = 360})
        tween:Play()
    end)
    
    return btn
end

-- أزرار التحكم
local closeBtn = CreateNeonButton("Close", "X", UDim2.new(1, -35, 0, 10), UDim2.new(0, 25, 0, 25), Color3.fromRGB(255, 50, 50), contentFrame)
local langBtn = CreateNeonButton("Lang", "E", UDim2.new(1, -65, 0, 10), UDim2.new(0, 25, 0, 25), Color3.fromRGB(100, 100, 255), contentFrame)

local copyBtn = CreateNeonButton("Copy", "Copy All", UDim2.new(0, 15, 1, -55), UDim2.new(0, 150, 0, 40), Color3.fromRGB(130, 50, 255), contentFrame)
local pathBtn = CreateNeonButton("Path", "Copy Path", UDim2.new(0.5, -75, 1, -55), UDim2.new(0, 150, 0, 40), Color3.fromRGB(50, 150, 255), contentFrame)
local delBtn = CreateNeonButton("Delete", "Delete", UDim2.new(1, -165, 1, -55), UDim2.new(0, 150, 0, 40), Color3.fromRGB(255, 80, 80), contentFrame)

-- العنوان الثابت مع v1.5 مدمج
local title = Instance.new("TextLabel")
title.Text = [[EXPLORER CLICK INFO <font color="#00FFFF">v1.5</font>]]
title.RichText = true
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 15, 0, 5)
title.TextColor3 = Color3.fromRGB(180, 120, 255)
title.BackgroundTransparency = 1
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 20
title.Parent = contentFrame

-- نص المعلومات
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -30, 0, 170)
infoLabel.Position = UDim2.new(0, 15, 0, 45)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = texts.en.infoDefault
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 14
infoLabel.Font = Enum.Font.GothamMedium
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextTransparency = 0
infoLabel.ZIndex = 30
infoLabel.Parent = contentFrame

-- دالة Fade In/Out محسنة
local function fadeInfo(newText)
    local fadeOut = TweenService:Create(infoLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()
    
    infoLabel.Text = newText
    infoLabel.TextTransparency = 1
    
    local fadeIn = TweenService:Create(infoLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0})
    fadeIn:Play()
end

-- أنيميشن الواجهة الرئيسي
task.spawn(function()
    local mainRotate = TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    TweenService:Create(MainNeon, mainRotate, {Rotation = 360}):Play()
end)

-- تبديل اللغة
langBtn.MouseButton1Click:Connect(function()
    currentLang = currentLang == "en" and "ar" or "en"
    updateLanguage()
    fadeInfo(texts[currentLang].infoDefault)
end)

-- الوظائف التشغيلية
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() clearHighlight() end)

delBtn.MouseButton1Click:Connect(function()
    if currentTarget then 
        local name = currentTarget.Name
        currentTarget:Destroy() 
        fadeInfo(currentLang == "ar" and "تم حذف ["..name.."] بنجاح!" or "Deleted ["..name.."] successfully!")
        clearHighlight()
        lastTarget = nil  -- إعادة تعيين بعد الحذف
    end
end)

pathBtn.MouseButton1Click:Connect(function()
    if currentPath then setclipboard(currentPath) end
end)

copyBtn.MouseButton1Click:Connect(function()
    if infoLabel.Text then setclipboard(infoLabel.Text) end
end)

-- دالة بسيطة لوصف الجزء + كشف السكريبتات/الريموتات
local function getDescriptionAndScripts(target)
    local t = texts[currentLang]
    local desc = ""
    local scripts = {}
    
    if target:IsA("BasePart") then
        desc = currentLang == "ar" and "جزء أساسي في الخريطة. يمكن تغيير حجمه، موقعه، لونه، شفافيته، أو إضافة تأثيرات فيزيائية." 
                            or "Basic building block. Can modify size, position, color, transparency, or physics."
    elseif target:IsA("Model") then
        desc = currentLang == "ar" and "مجموعة من الأجزاء. غالبًا خريطة أو كائن معقد." 
                            or "Group of parts. Often a map section or complex object."
    elseif target:IsA("Folder") then
        desc = currentLang == "ar" and "مجلد تنظيمي. يحتوي على أجزاء أو سكريبتات أخرى." 
                            or "Organizational container. Holds other parts/scripts."
    elseif target:IsA("Script") or target:IsA("LocalScript") then
        desc = currentLang == "ar" and "سكريبت يتحكم في سلوك اللعبة (محلي أو خادم)." 
                            or "Script controlling game behavior (local or server)."
    elseif target:IsA("RemoteEvent") or target:IsA("RemoteFunction") then
        desc = currentLang == "ar" and "ريموت للتواصل بين العميل والخادم." 
                            or "Remote for client-server communication."
    else
        desc = currentLang == "ar" and "كائن عام في اللعبة." or "General game object."
    end
    
    for _, child in pairs(target:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(scripts, child:GetFullName())
        end
    end
    
    local scriptsText = #scripts > 0 and table.concat(scripts, "\n") or t.none
    
    return desc, scriptsText
end

mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target then
        clearHighlight()
        currentTarget = target
        currentPath = getFullPath(target)
        
        local hl = Instance.new("Highlight", target)
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
        hl.OutlineColor = Color3.fromRGB(130, 50, 255)
        currentHighlight = hl
        
        local t = texts[currentLang]
        local posX = math.floor(target.Position.X)
        local posY = math.floor(target.Position.Y)
        local posZ = math.floor(target.Position.Z)
        
        local desc, scriptsText = getDescriptionAndScripts(target)
        
        local newText = string.format(
            "📍 %s: %s\n\n🔹 %s: %s\n🔹 %s: %s\n🔹 %s: %s\n\n🔗 %s:\n%s\n\n📜 %s:\n%s\n\nℹ️ %s:\n%s",
            t.name, target.Name,
            t.type, target.ClassName,
            t.parent, target.Parent.Name,
            t.position, posX..", "..posY..", "..posZ,
            t.path, currentPath,
            t.scripts, scriptsText,
            t.description, desc
        )
        
        -- الجديد: إذا نفس الجزء السابق → تحديث مباشر بدون Fade
        if target == lastTarget then
            infoLabel.Text = newText
        else
            fadeInfo(newText)
        end
        
        lastTarget = target  -- حفظ الجزء الحالي
    end
end)

-- تحديث اللغة عند التشغيل
updateLanguage()
