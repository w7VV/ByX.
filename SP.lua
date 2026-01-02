--[[

		Gui2Lua™
		10zOfficial
		Version 1.0.0

]]


-- Instances

local ScreenGui = Instance.new("ScreenGui")
local A = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local TextLabel_2 = Instance.new("TextLabel")
local Frame = Instance.new("Frame")
local A2 = Instance.new("ScrollingFrame")
local Frame_2 = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")
local ImageLabel = Instance.new("ImageLabel")
local Frame_3 = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local TextButton_2 = Instance.new("TextButton")
local ImageLabel_2 = Instance.new("ImageLabel")
local Frame_4 = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local TextButton_3 = Instance.new("TextButton")
local ImageLabel_3 = Instance.new("ImageLabel")
local Frame_5 = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local TextButton_4 = Instance.new("TextButton")
local ImageLabel_4 = Instance.new("ImageLabel")
local Frame_6 = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local TextButton_5 = Instance.new("TextButton")
local ImageLabel_5 = Instance.new("ImageLabel")
local Frame_7 = Instance.new("Frame")
local UICorner_7 = Instance.new("UICorner")
local TextButton_6 = Instance.new("TextButton")
local ImageLabel_6 = Instance.new("ImageLabel")
local ImageLabel_7 = Instance.new("ImageLabel")
local ImageLabel_8 = Instance.new("ImageLabel")
local ImageLabel_9 = Instance.new("ImageLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local ImageButton = Instance.new("ImageButton")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

-- Properties

ScreenGui.Parent = game.GcoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

A.Name = "A"
A.Parent = ScreenGui
A.AnchorPoint = Vector2.new(0.5, 0.5)
A.BackgroundColor3 = Color3.new(1, 1, 1)
A.BackgroundTransparency = 0.019999999552965164
A.BorderColor3 = Color3.new(0, 0, 0)
A.BorderSizePixel = 0
A.Position = UDim2.new(0.511919916, 0, 0.544476032, 0)
A.Size = UDim2.new(0.256249994, 0, 0.607970357, 0)

UICorner.Parent = A
UICorner.CornerRadius = UDim.new(0, 0)

TextLabel.Parent = A
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.296747953, 0, 0.0457317084, 0)
TextLabel.Size = UDim2.new(0.104166664, 0, 0.0463392027, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "سحب (اكادمية ريفن)"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 65

TextLabel_2.Parent = A
TextLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.BorderColor3 = Color3.new(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.296747953, 0, 0.137195125, 0)
TextLabel_2.Size = UDim2.new(0.104166664, 0, 0.0463392027, 0)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "ملاحظة: هذه جزء من السكربت الرئيسي "
TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
TextLabel_2.TextSize = 35

Frame.Parent = A
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderColor3 = Color3.new(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.0529015996, 0, 0.214918002, 0)
Frame.Size = UDim2.new(0.228125006, 0, 0.00463392027, 0)

A2.Name = "A2"
A2.Parent = A
A2.Active = true
A2.BackgroundColor3 = Color3.new(1, 1, 1)
A2.BackgroundTransparency = 1
A2.BorderColor3 = Color3.new(0, 0, 0)
A2.BorderSizePixel = 0
A2.Position = UDim2.new(0.0146201532, 0, 0.24706696, 0)
A2.Size = UDim2.new(0.246875003, 0, 0.440222442, 0)

Frame_2.Parent = A2
Frame_2.BackgroundColor3 = Color3.new(0.0509804, 0.0431373, 0.301961)
Frame_2.BorderColor3 = Color3.new(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.0397351757, 0, 0.0161900874, 0)
Frame_2.Size = UDim2.new(0.100520834, 0, 0.0426320657, 0)

UICorner_2.Parent = Frame_2

TextButton.Parent = Frame_2
TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton.BackgroundTransparency = 1
TextButton.BorderColor3 = Color3.new(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.187796026, 0, 0, 0)
TextButton.Size = UDim2.new(0.0708333328, 0, 0.0463392027, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "ارميهم في البحر"
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.TextSize = 39

ImageLabel.Parent = TextButton
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(-0.269392133, 0, -0.415740967, 0)
ImageLabel.Size = UDim2.new(0.0187500007, 0, 0.0296570901, 0)
ImageLabel.Image = "rbxassetid://483446873"
ImageLabel.ImageColor3 = Color3.new(1, 0, 0.0156863)
ImageLabel.ImageTransparency = 1

Frame_3.Parent = A2
Frame_3.BackgroundColor3 = Color3.new(0.0509804, 0.0431373, 0.301961)
Frame_3.BorderColor3 = Color3.new(0, 0, 0)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0.579586744, 0, 0.0192388669, 0)
Frame_3.Size = UDim2.new(0.0895833299, 0, 0.0426320657, 0)

UICorner_3.Parent = Frame_3

TextButton_2.Parent = Frame_3
TextButton_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_2.BackgroundTransparency = 1
TextButton_2.BorderColor3 = Color3.new(0, 0, 0)
TextButton_2.BorderSizePixel = 0
TextButton_2.Position = UDim2.new(0.235671639, 0, -0.0869565234, 0)
TextButton_2.Size = UDim2.new(0.0557291657, 0, 0.0463392027, 0)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "غطسهم"
TextButton_2.TextColor3 = Color3.new(1, 1, 1)
TextButton_2.TextSize = 51

ImageLabel_2.Parent = TextButton_2
ImageLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_2.BackgroundTransparency = 1
ImageLabel_2.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_2.BorderSizePixel = 0
ImageLabel_2.Position = UDim2.new(-0.269392133, 0, -0.415740967, 0)
ImageLabel_2.Size = UDim2.new(0.0187500007, 0, 0.0296570901, 0)
ImageLabel_2.Image = "rbxassetid://483446873"
ImageLabel_2.ImageColor3 = Color3.new(1, 0, 0.0156863)
ImageLabel_2.ImageTransparency = 1

Frame_4.Parent = A2
Frame_4.BackgroundColor3 = Color3.new(0.0509804, 0.0431373, 0.301961)
Frame_4.BorderColor3 = Color3.new(0, 0, 0)
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0.0397351757, 0, 0.0794522837, 0)
Frame_4.Size = UDim2.new(0.100520834, 0, 0.0426320657, 0)

UICorner_4.Parent = Frame_4

TextButton_3.Parent = Frame_4
TextButton_3.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_3.BackgroundTransparency = 1
TextButton_3.BorderColor3 = Color3.new(0, 0, 0)
TextButton_3.BorderSizePixel = 0
TextButton_3.Position = UDim2.new(0.146345228, 0, 0, 0)
TextButton_3.Size = UDim2.new(0.0708333328, 0, 0.0463392027, 0)
TextButton_3.Font = Enum.Font.SourceSans
TextButton_3.Text = "ارميهم في المكان السري"
TextButton_3.TextColor3 = Color3.new(1, 1, 1)
TextButton_3.TextSize = 28

ImageLabel_3.Parent = TextButton_3
ImageLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_3.BackgroundTransparency = 1
ImageLabel_3.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_3.BorderSizePixel = 0
ImageLabel_3.Position = UDim2.new(-0.269392133, 0, -0.415740967, 0)
ImageLabel_3.Size = UDim2.new(0.0187500007, 0, 0.0296570901, 0)
ImageLabel_3.Image = "rbxassetid://483446873"
ImageLabel_3.ImageColor3 = Color3.new(1, 0, 0.0156863)
ImageLabel_3.ImageTransparency = 1

Frame_5.Parent = A2
Frame_5.BackgroundColor3 = Color3.new(0.0509804, 0.0431373, 0.301961)
Frame_5.BorderColor3 = Color3.new(0, 0, 0)
Frame_5.BorderSizePixel = 0
Frame_5.Position = UDim2.new(0.579586744, 0, 0.0794522837, 0)
Frame_5.Size = UDim2.new(0.0895833299, 0, 0.0426320657, 0)

UICorner_5.Parent = Frame_5

TextButton_4.Parent = Frame_5
TextButton_4.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_4.BackgroundTransparency = 1
TextButton_4.BorderColor3 = Color3.new(0, 0, 0)
TextButton_4.BorderSizePixel = 0
TextButton_4.Position = UDim2.new(0.237650767, 0, -0.0434782617, 0)
TextButton_4.Size = UDim2.new(0.0557291657, 0, 0.0463392027, 0)
TextButton_4.Font = Enum.Font.SourceSans
TextButton_4.Text = "احشرهم"
TextButton_4.TextColor3 = Color3.new(1, 1, 1)
TextButton_4.TextSize = 51

ImageLabel_4.Parent = TextButton_4
ImageLabel_4.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_4.BackgroundTransparency = 1
ImageLabel_4.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_4.BorderSizePixel = 0
ImageLabel_4.Position = UDim2.new(-0.269392133, 0, -0.415740967, 0)
ImageLabel_4.Size = UDim2.new(0.0187500007, 0, 0.0296570901, 0)
ImageLabel_4.Image = "rbxassetid://483446873"
ImageLabel_4.ImageColor3 = Color3.new(1, 0, 0.0156863)
ImageLabel_4.ImageTransparency = 1

Frame_6.Parent = A2
Frame_6.BackgroundColor3 = Color3.new(0.0509804, 0.0431373, 0.301961)
Frame_6.BorderColor3 = Color3.new(0, 0, 0)
Frame_6.BorderSizePixel = 0
Frame_6.Position = UDim2.new(0.263305664, 0, 0.151860818, 0)
Frame_6.Size = UDim2.new(0.114583336, 0, 0.0426320657, 0)

UICorner_6.Parent = Frame_6

TextButton_5.Parent = Frame_6
TextButton_5.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_5.BackgroundTransparency = 1
TextButton_5.BorderColor3 = Color3.new(0, 0, 0)
TextButton_5.BorderSizePixel = 0
TextButton_5.Position = UDim2.new(0.187796026, 0, 0, 0)
TextButton_5.Size = UDim2.new(0.0708333328, 0, 0.0463392027, 0)
TextButton_5.Font = Enum.Font.SourceSans
TextButton_5.Text = "اسحبهم لعندك"
TextButton_5.TextColor3 = Color3.new(1, 1, 1)
TextButton_5.TextSize = 32

ImageLabel_5.Parent = TextButton_5
ImageLabel_5.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_5.BackgroundTransparency = 1
ImageLabel_5.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_5.BorderSizePixel = 0
ImageLabel_5.Position = UDim2.new(-0.269392133, 0, -0.415740967, 0)
ImageLabel_5.Size = UDim2.new(0.0187500007, 0, 0.0296570901, 0)
ImageLabel_5.Image = "rbxassetid://483446873"
ImageLabel_5.ImageColor3 = Color3.new(1, 0, 0.0156863)
ImageLabel_5.ImageTransparency = 1

Frame_7.Parent = A2
Frame_7.BackgroundColor3 = Color3.new(1, 1, 1)
Frame_7.BorderColor3 = Color3.new(0, 0, 0)
Frame_7.BorderSizePixel = 0
Frame_7.Position = UDim2.new(0.26541537, 0, 0.236464471, 0)
Frame_7.Size = UDim2.new(0.114583336, 0, 0.0426320657, 0)

UICorner_7.Parent = Frame_7

TextButton_6.Parent = Frame_7
TextButton_6.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_6.BackgroundTransparency = 1
TextButton_6.BorderColor3 = Color3.new(0, 0, 0)
TextButton_6.BorderSizePixel = 0
TextButton_6.Position = UDim2.new(0.187796026, 0, 0, 0)
TextButton_6.Size = UDim2.new(0.0708333328, 0, 0.0463392027, 0)
TextButton_6.Font = Enum.Font.SourceSans
TextButton_6.Text = "تشغيل السكربت الرئيسي"
TextButton_6.TextColor3 = Color3.new(0, 0, 0)
TextButton_6.TextSize = 32

ImageLabel_6.Parent = A2
ImageLabel_6.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_6.BackgroundTransparency = 1
ImageLabel_6.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_6.BorderSizePixel = 0
ImageLabel_6.Position = UDim2.new(-0.788403749, 0, -0.268707991, 0)
ImageLabel_6.Size = UDim2.new(0.605208337, 0, 0.8303985, 0)
ImageLabel_6.Image = "rbxassetid://106379443682584"
ImageLabel_6.ImageTransparency = 0.9700000286102295

ImageLabel_7.Parent = A
ImageLabel_7.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_7.BackgroundTransparency = 1
ImageLabel_7.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_7.BorderSizePixel = 0
ImageLabel_7.Position = UDim2.new(0.0216987431, 0, 0.0213414636, 0)
ImageLabel_7.Size = UDim2.new(0.0265625007, 0, 0.0454124175, 0)

ImageLabel_8.Parent = A
ImageLabel_8.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_8.BackgroundTransparency = 1
ImageLabel_8.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_8.BorderSizePixel = 0
ImageLabel_8.Position = UDim2.new(-0.0272977259, 0, 0.0459551923, 0)
ImageLabel_8.Rotation = 2
ImageLabel_8.Size = UDim2.new(0.0348958336, 0, 0.054680258, 0)
ImageLabel_8.Image = "rbxassetid://17169180878"
ImageLabel_8.ImageColor3 = Color3.new(0.894118, 0.933333, 1)

ImageLabel_9.Parent = A
ImageLabel_9.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_9.BackgroundTransparency = 1
ImageLabel_9.BorderColor3 = Color3.new(0, 0, 0)
ImageLabel_9.BorderSizePixel = 0
ImageLabel_9.Position = UDim2.new(-0.212335348, 0, -0.150914639, 0)
ImageLabel_9.Rotation = -17
ImageLabel_9.Size = UDim2.new(0.123437501, 0, 0.219647825, 0)
ImageLabel_9.Image = "rbxassetid://137496030683368"

UIAspectRatioConstraint.Parent = A
UIAspectRatioConstraint.AspectRatio = 0.75

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
ImageButton.BackgroundTransparency = 1
ImageButton.BorderColor3 = Color3.new(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.122828439, 0, 0.233388245, 0)
ImageButton.Size = UDim2.new(0.0375000015, 0, 0.0648748875, 0)
ImageButton.Image = "rbxassetid://17169180878"
ImageButton.ImageColor3 = Color3.new(0.0823529, 0, 1)

UIAspectRatioConstraint_2.Parent = ImageButton
UIAspectRatioConstraint_2.AspectRatio = 1.0285714864730835

-- Scripts

local function BFALKX_fake_script() -- A.LocalScript 
	local script = Instance.new('LocalScript', A)

	local TweenService = game:GetService("TweenService")
	local gradient = script.Parent:WaitForChild("UIGradient")
	
	local tweenInfo = TweenInfo.new(
		10, -- مدة الحركة (كل ما زادت = أبطأ)
		Enum.EasingStyle.Linear, -- حركة ناعمة
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- ذهاب وإياب
	)
	
	local tween = TweenService:Create(
		gradient,
		tweenInfo,
		{Rotation = 360} -- دوران التدرج
	)
	
	tween:Play()
	
end
coroutine.wrap(BFALKX_fake_script)()
local function SXROLOY_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)

	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local image = button:WaitForChild("ImageLabel")
	
	local isActive = false
	local pulseTween
	
	-- إعدادات النبض (تلاشي)
	local pulseInfo = TweenInfo.new(
		1, -- مدة النبض (أكبر = أبطأ)
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- اختفاء ورجوع
	)
	
	button.MouseButton1Click:Connect(function()
		if not isActive then
			-- إظهار + بدء النبض
			image.ImageTransparency = 0
			pulseTween = TweenService:Create(
				image,
				pulseInfo,
				{ImageTransparency = 0.6} -- مقدار الاختفاء
			)
			pulseTween:Play()
		else
			-- إيقاف النبض + إخفاء
			if pulseTween then
				pulseTween:Cancel()
			end
			image.ImageTransparency = 1
		end
	
		isActive = not isActive
	end)
	
end
coroutine.wrap(SXROLOY_fake_script)()
local function RFOQK_fake_script() -- TextButton_2.LocalScript 
	local script = Instance.new('LocalScript', TextButton_2)

	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local image = button:WaitForChild("ImageLabel")
	
	local isActive = false
	local pulseTween
	
	-- إعدادات النبض (تلاشي)
	local pulseInfo = TweenInfo.new(
		1, -- مدة النبض (أكبر = أبطأ)
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- اختفاء ورجوع
	)
	
	button.MouseButton1Click:Connect(function()
		if not isActive then
			-- إظهار + بدء النبض
			image.ImageTransparency = 0
			pulseTween = TweenService:Create(
				image,
				pulseInfo,
				{ImageTransparency = 0.6} -- مقدار الاختفاء
			)
			pulseTween:Play()
		else
			-- إيقاف النبض + إخفاء
			if pulseTween then
				pulseTween:Cancel()
			end
			image.ImageTransparency = 1
		end
	
		isActive = not isActive
	end)
	
end
coroutine.wrap(RFOQK_fake_script)()
local function UPQMBS_fake_script() -- TextButton_3.LocalScript 
	local script = Instance.new('LocalScript', TextButton_3)

	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local image = button:WaitForChild("ImageLabel")
	
	local isActive = false
	local pulseTween
	
	-- إعدادات النبض (تلاشي)
	local pulseInfo = TweenInfo.new(
		1, -- مدة النبض (أكبر = أبطأ)
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- اختفاء ورجوع
	)
	
	button.MouseButton1Click:Connect(function()
		if not isActive then
			-- إظهار + بدء النبض
			image.ImageTransparency = 0
			pulseTween = TweenService:Create(
				image,
				pulseInfo,
				{ImageTransparency = 0.6} -- مقدار الاختفاء
			)
			pulseTween:Play()
		else
			-- إيقاف النبض + إخفاء
			if pulseTween then
				pulseTween:Cancel()
			end
			image.ImageTransparency = 1
		end
	
		isActive = not isActive
	end)
	
end
coroutine.wrap(UPQMBS_fake_script)()
local function SQZUQY_fake_script() -- TextButton_4.LocalScript 
	local script = Instance.new('LocalScript', TextButton_4)

	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local image = button:WaitForChild("ImageLabel")
	
	local isActive = false
	local pulseTween
	
	-- إعدادات النبض (تلاشي)
	local pulseInfo = TweenInfo.new(
		1, -- مدة النبض (أكبر = أبطأ)
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- اختفاء ورجوع
	)
	
	button.MouseButton1Click:Connect(function()
		if not isActive then
			-- إظهار + بدء النبض
			image.ImageTransparency = 0
			pulseTween = TweenService:Create(
				image,
				pulseInfo,
				{ImageTransparency = 0.6} -- مقدار الاختفاء
			)
			pulseTween:Play()
		else
			-- إيقاف النبض + إخفاء
			if pulseTween then
				pulseTween:Cancel()
			end
			image.ImageTransparency = 1
		end
	
		isActive = not isActive
	end)
	
end
coroutine.wrap(SQZUQY_fake_script)()
local function OLAWCV_fake_script() -- TextButton_5.LocalScript 
	local script = Instance.new('LocalScript', TextButton_5)

	local TweenService = game:GetService("TweenService")
	
	local button = script.Parent
	local image = button:WaitForChild("ImageLabel")
	
	local isActive = false
	local pulseTween
	
	-- إعدادات النبض (تلاشي)
	local pulseInfo = TweenInfo.new(
		1, -- مدة النبض (أكبر = أبطأ)
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- اختفاء ورجوع
	)
	
	button.MouseButton1Click:Connect(function()
		if not isActive then
			-- إظهار + بدء النبض
			image.ImageTransparency = 0
			pulseTween = TweenService:Create(
				image,
				pulseInfo,
				{ImageTransparency = 0.6} -- مقدار الاختفاء
			)
			pulseTween:Play()
		else
			-- إيقاف النبض + إخفاء
			if pulseTween then
				pulseTween:Cancel()
			end
			image.ImageTransparency = 1
		end
	
		isActive = not isActive
	end)
	
end
coroutine.wrap(OLAWCV_fake_script)()
local function IDNBJBW_fake_script() -- Frame_7.LocalScript 
	local script = Instance.new('LocalScript', Frame_7)

	local TweenService = game:GetService("TweenService")
	local frame = script.Parent
	local gradient = frame:WaitForChild("UIGradient")
	
	-- إعدادات التوين
	local tweenInfo = TweenInfo.new(
		3, -- مدة التحرك
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.InOut,
		-1, -- تكرار لا نهائي
		true -- ذهاب وإياب
	)
	
	-- Tween من اليمين لليسار
	local tween = TweenService:Create(
		gradient,
		tweenInfo,
		{Offset = Vector2.new(1, 0)} -- هنا تتحرك من الوضع الطبيعي لـ x=1
	)
	
	-- نبدأ من اليسار
	gradient.Offset = Vector2.new(0, 0)
	
	tween:Play()
	
end
coroutine.wrap(IDNBJBW_fake_script)()
local function SFQXBTL_fake_script() -- A.LocalScript 
	local script = Instance.new('LocalScript', A)

	local frame = script.Parent
	local userInputService = game:GetService("UserInputService")
	
	local dragging = false
	local dragStartPos
	local frameStartPos
	
	-- بدء السحب
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			frameStartPos = frame.Position
	
			-- إيقاف السحب عند رفع الماوس
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	-- أثناء السحب
	frame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStartPos
			frame.Position = UDim2.new(
				frameStartPos.X.Scale,
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale,
				frameStartPos.Y.Offset + delta.Y
			)
		end
	end)
	
end
coroutine.wrap(SFQXBTL_fake_script)()
local function WOJVV_fake_script() -- A.LocalScript 
	local script = Instance.new('LocalScript', A)

	local frame = script.Parent
	local userInputService = game:GetService("UserInputService")
	
	local dragging = false
	local dragStartPos
	local frameStartPos
	
	-- بدء السحب
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			frameStartPos = frame.Position
	
			-- إيقاف السحب عند رفع الماوس
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	-- أثناء السحب
	frame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStartPos
			frame.Position = UDim2.new(
				frameStartPos.X.Scale,
				frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale,
				frameStartPos.Y.Offset + delta.Y
			)
		end
	end)
	
end
coroutine.wrap(WOJVV_fake_script)()
local function OCGA_fake_script() -- A.LocalScript 
	local script = Instance.new('LocalScript', A)

	local UISizeConstraint = Instance.new("UISizeConstraint")
	UISizeConstraint.MinSize = Vector2.new(450, 300) -- أصغر حجم
	UISizeConstraint.MaxSize = Vector2.new(900, 650) -- أكبر حجم
	UISizeConstraint.Parent = A
	
end
coroutine.wrap(OCGA_fake_script)()
local function QZVPE_fake_script() -- ImageButton.LocalScript 
	local script = Instance.new('LocalScript', ImageButton)

	local button = script.Parent
	local screenGui = button:FindFirstAncestorOfClass("ScreenGui") -- نبحث عن الـ ScreenGui الأعلى
	local frameA = screenGui:WaitForChild("A") -- الـ Frame الذي نريد التحكم به
	
	button.MouseButton1Click:Connect(function()
		frameA.Visible = not frameA.Visible -- تبديل الإخفاء والظهور
	end)
	
end
coroutine.wrap(QZVPE_fake_script)()
local function XJKY_fake_script() -- ImageButton.LocalScript 
	local script = Instance.new('LocalScript', ImageButton)

	local button = script.Parent
	local userInputService = game:GetService("UserInputService")
	
	local dragging = false
	local dragStartPos
	local buttonStartPos
	
	-- بدء السحب
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = input.Position
			buttonStartPos = button.Position
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	-- أثناء السحب
	button.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStartPos
			button.Position = UDim2.new(
				buttonStartPos.X.Scale,
				buttonStartPos.X.Offset + delta.X,
				buttonStartPos.Y.Scale,
				buttonStartPos.Y.Offset + delta.Y
			)
		end
	end)
	
end
coroutine.wrap(XJKY_fake_script)()
