local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Lumina = {}
Lumina.__index = Lumina

local COLORS = {
	background = Color3.fromRGB(18, 18, 20),
	surface = Color3.fromRGB(24, 24, 28),
	sidebar = Color3.fromRGB(15, 15, 17),
	border = Color3.fromRGB(35, 35, 40),
	primary = Color3.fromRGB(45, 120, 255),
	text_primary = Color3.fromRGB(230, 230, 235),
	text_secondary = Color3.fromRGB(175, 175, 180),
	text_muted = Color3.fromRGB(140, 140, 145),
	accent = Color3.fromRGB(255, 255, 255),
}

local TWEENS = {
	fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	smooth = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

function Lumina.new(title)
	local self = setmetatable({}, Lumina)
	
	self.title = title or "Lumina UI"
	self.parent = CoreGui
	self.tabs = {}
	self.pages = {}
	self.config = {}
	self.minimized = false
	
	if gethui then
		pcall(function()
			self.parent = gethui()
		end)
	end
	
	self:_createGui()
	
	return self
end

function Lumina:_createGui()
	if self.parent:FindFirstChild("lumina_gui") then
		self.parent.lumina_gui:Destroy()
	end
	
	local gui = Instance.new("ScreenGui")
	gui.Name = "lumina_gui"
	gui.ResetOnSpawn = false
	gui.Parent = self.parent
	self.gui = gui
	
	local main = Instance.new("Frame")
	main.Name = "MainFrame"
	main.Size = UDim2.new(0, 550, 0, 400)
	main.Position = UDim2.new(0.5, -275, 0.5, -200)
	main.BackgroundColor3 = COLORS.background
	main.BorderSizePixel = 0
	main.Active = true
	main.ClipsDescendants = true
	main.Parent = gui
	self.mainFrame = main
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = main
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = COLORS.border
	stroke.Parent = main
	
	self:_createHeader()
	self:_createLayout()
end

function Lumina:_createHeader()
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = COLORS.surface
	header.BorderSizePixel = 0
	header.Parent = self.mainFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = header
	
	local title = Instance.new("TextLabel")
	title.Text = self.title
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.TextColor3 = COLORS.text_primary
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 15, 0, 0)
	title.Size = UDim2.new(0.7, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Parent = header
	
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
	minimizeBtn.Position = UDim2.new(1, -42, 0.5, -16)
	minimizeBtn.BackgroundColor3 = COLORS.surface
	minimizeBtn.BorderSizePixel = 0
	minimizeBtn.Text = "−"
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.TextSize = 18
	minimizeBtn.TextColor3 = COLORS.text_muted
	minimizeBtn.Parent = header
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = minimizeBtn
	
	minimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(minimizeBtn, TWEENS.fast, {BackgroundColor3 = COLORS.border}):Play()
	end)
	
	minimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(minimizeBtn, TWEENS.fast, {BackgroundColor3 = COLORS.surface}):Play()
	end)
	
	minimizeBtn.MouseButton1Click:Connect(function()
		self.minimized = not self.minimized
		local targetSize = self.minimized and UDim2.new(0, 550, 0, 50) or UDim2.new(0, 550, 0, 400)
		TweenService:Create(self.mainFrame, TWEENS.normal, {Size = targetSize}):Play()
	end)
	
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	header.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inp.Position
			startPos = self.mainFrame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(inp)
		if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) and dragging then
			local delta = inp.Position - dragStart
			self.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Lumina:_createLayout()
	local nav = Instance.new("Frame")
	nav.Position = UDim2.new(0, 0, 0, 50)
	nav.Size = UDim2.new(0, 140, 1, -50)
	nav.BackgroundColor3 = COLORS.sidebar
	nav.BorderSizePixel = 0
	nav.Parent = self.mainFrame
	
	local divider = Instance.new("Frame")
	divider.Position = UDim2.new(0, 140, 0, 50)
	divider.Size = UDim2.new(0, 1, 1, -50)
	divider.BackgroundColor3 = COLORS.border
	divider.BorderSizePixel = 0
	divider.Parent = self.mainFrame
	
	local content = Instance.new("Frame")
	content.Position = UDim2.new(0, 141, 0, 50)
	content.Size = UDim2.new(1, -141, 1, -50)
	content.BackgroundColor3 = COLORS.background
	content.BorderSizePixel = 0
	content.Parent = self.mainFrame
	
	self.navFrame = nav
	self.contentFrame = content
end

function Lumina:AddTab(name, isDefault)
	isDefault = isDefault == nil and #self.tabs == 0 or isDefault
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 36)
	btn.Position = UDim2.new(0, 5, 0, #self.tabs * 42 + 10)
	btn.BackgroundColor3 = isDefault and COLORS.surface or COLORS.sidebar
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.TextColor3 = isDefault and COLORS.accent or COLORS.text_muted
	btn.Parent = self.navFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = btn
	
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundColor3 = COLORS.background
	page.BackgroundTransparency = 0
	page.BorderSizePixel = 0
	page.Visible = isDefault
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = COLORS.border
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Parent = self.contentFrame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 12)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 15)
	padding.PaddingBottom = UDim.new(0, 15)
	padding.PaddingLeft = UDim.new(0, 15)
	padding.PaddingRight = UDim.new(0, 15)
	padding.Parent = page
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
	end)
	
	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(self.pages) do
			p.Visible = false
		end
		
		for _, t in pairs(self.tabs) do
			TweenService:Create(t, TWEENS.fast, {BackgroundColor3 = COLORS.sidebar, TextColor3 = COLORS.text_muted}):Play()
		end
		
		page.Visible = true
		TweenService:Create(btn, TWEENS.fast, {BackgroundColor3 = COLORS.surface, TextColor3 = COLORS.accent}):Play()
	end)
	
	table.insert(self.tabs, btn)
	table.insert(self.pages, page)
	
	return page
end

function Lumina:AddToggle(parent, text, key, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -30, 0, 42)
	frame.BackgroundColor3 = COLORS.surface
	frame.BorderSizePixel = 0
	frame.Parent = parent
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 4)
	frameCorner.Parent = frame
	
	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = COLORS.border
	frameStroke.Thickness = 1
	frameStroke.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 13
	label.TextColor3 = COLORS.text_primary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Parent = frame
	
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 44, 0, 24)
	toggle.Position = UDim2.new(1, -56, 0.5, -12)
	toggle.BackgroundColor3 = self.config[key] and COLORS.primary or COLORS.border
	toggle.Text = ""
	toggle.Parent = frame
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggle
	
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 18, 0, 18)
	dot.Position = self.config[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	dot.BackgroundColor3 = COLORS.accent
	dot.Parent = toggle
	
	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot
	
	toggle.MouseButton1Click:Connect(function()
		self.config[key] = not self.config[key]
		
		TweenService:Create(toggle, TWEENS.fast, {
			BackgroundColor3 = self.config[key] and COLORS.primary or COLORS.border
		}):Play()
		
		TweenService:Create(dot, TWEENS.fast, {
			Position = self.config[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		}):Play()
		
		if callback then
			callback(self.config[key])
		end
	end)
end

function Lumina:AddSlider(parent, text, minVal, maxVal, key, callback)
	self.config[key] = self.config[key] or minVal

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -30, 0, 70)
	frame.BackgroundColor3 = COLORS.surface
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 4)
	frameCorner.Parent = frame

	local frameStroke = Instance.new("UIStroke")
	frameStroke.Color = COLORS.border
	frameStroke.Thickness = 1
	frameStroke.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 0, 20)
	label.Position = UDim2.new(0, 12, 0, 8)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 13
	label.TextColor3 = COLORS.text_primary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.25, 0, 0, 20)
	valueLabel.Position = UDim2.new(0.75, -12, 0, 8)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(self.config[key])
	valueLabel.Font = Enum.Font.GothamMonospace
	valueLabel.TextSize = 12
	valueLabel.TextColor3 = COLORS.primary
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = frame

	local sliderBar = Instance.new("Frame")
	sliderBar.Size = UDim2.new(1, -24, 0, 6)
	sliderBar.Position = UDim2.new(0, 12, 0, 38)
	sliderBar.BackgroundColor3 = COLORS.border
	sliderBar.BorderSizePixel = 0
	sliderBar.Active = true
	sliderBar.Parent = frame

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = sliderBar

	local pct = math.clamp((self.config[key] - minVal) / (maxVal - minVal), 0, 1)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(pct, 0, 1, 0)
	fill.BackgroundColor3 = COLORS.primary
	fill.BorderSizePixel = 0
	fill.Parent = sliderBar

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local knob = Instance.new("TextButton")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(pct, 0, 0.5, 0)
	knob.BackgroundColor3 = COLORS.accent
	knob.BorderSizePixel = 0
	knob.Text = ""
	knob.Active = true
	knob.Parent = sliderBar

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local dragging = false

	local function update(input)
		local width = sliderBar.AbsoluteSize.X
		if width <= 0 then
			return
		end

		local mouseX = input.Position.X - sliderBar.AbsolutePosition.X
		local percent = math.clamp(mouseX / width, 0, 1)

		local value = math.floor(minVal + ((maxVal - minVal) * percent) + 0.5)

		self.config[key] = value

		fill.Size = UDim2.new(percent, 0, 1, 0)
		knob.Position = UDim2.new(percent, 0, 0.5, 0)
		valueLabel.Text = tostring(value)

		if callback then
			callback(value)
		end
	end

	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(input)
		end
	end)

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end
function Lumina:AddDropdown(parent, text, options, key, callback)
	self.config[key] = self.config[key] or {}
	
	local buttons = {}
	local isOpen = false
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -30, 0, 46)
	container.BackgroundColor3 = COLORS.surface
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = parent
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 4)
	containerCorner.Parent = container
	
	local containerStroke = Instance.new("UIStroke")
	containerStroke.Color = COLORS.border
	containerStroke.Thickness = 1
	containerStroke.Parent = container
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 46)
	header.BackgroundTransparency = 1
	header.Parent = container
	
	local headerLabel = Instance.new("TextLabel")
	headerLabel.Size = UDim2.new(0.5, 0, 1, 0)
	headerLabel.Position = UDim2.new(0, 12, 0, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.Text = text
	headerLabel.Font = Enum.Font.GothamSemibold
	headerLabel.TextSize = 13
	headerLabel.TextColor3 = COLORS.text_primary
	headerLabel.TextXAlignment = Enum.TextXAlignment.Left
	headerLabel.TextYAlignment = Enum.TextYAlignment.Center
	headerLabel.Parent = header
	
	local triggerBtn = Instance.new("TextButton")
	triggerBtn.Size = UDim2.new(0.4, -10, 0, 30)
	triggerBtn.Position = UDim2.new(1, -10, 0.5, -15)
	triggerBtn.AnchorPoint = Vector2.new(1, 0.5)
	triggerBtn.BackgroundColor3 = COLORS.sidebar
	triggerBtn.Text = "Select..."
	triggerBtn.Font = Enum.Font.GothamSemibold
	triggerBtn.TextSize = 11
	triggerBtn.TextColor3 = COLORS.text_primary
	triggerBtn.Parent = header
	
	local triggerCorner = Instance.new("UICorner")
	triggerCorner.CornerRadius = UDim.new(0, 4)
	triggerCorner.Parent = triggerBtn
	
	local triggerStroke = Instance.new("UIStroke")
	triggerStroke.Color = COLORS.border
	triggerStroke.Thickness = 1
	triggerStroke.Parent = triggerBtn
	
	local dropdownContent = Instance.new("ScrollingFrame")
	dropdownContent.Size = UDim2.new(1, -20, 0, 150)
	dropdownContent.Position = UDim2.new(0, 10, 0, 50)
	dropdownContent.BackgroundColor3 = COLORS.sidebar
	dropdownContent.BorderSizePixel = 0
	dropdownContent.ScrollBarThickness = 3
	dropdownContent.ScrollBarImageColor3 = COLORS.border
	dropdownContent.Parent = container
	
	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 4)
	dropCorner.Parent = dropdownContent
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = dropdownContent
	
	local layoutPadding = Instance.new("UIPadding")
	layoutPadding.PaddingTop = UDim.new(0, 6)
	layoutPadding.PaddingLeft = UDim.new(0, 6)
	layoutPadding.PaddingRight = UDim.new(0, 6)
	layoutPadding.Parent = dropdownContent
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		dropdownContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
	end)
	
	for _, option in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, -12, 0, 30)
		optBtn.BackgroundColor3 = self.config[key][option] and COLORS.primary or COLORS.surface
		optBtn.BorderSizePixel = 0
		optBtn.Text = option
		optBtn.Font = Enum.Font.GothamSemibold
		optBtn.TextSize = 12
		optBtn.TextColor3 = self.config[key][option] and COLORS.accent or COLORS.text_primary
		optBtn.Parent = dropdownContent
		
		local optCorner = Instance.new("UICorner")
		optCorner.CornerRadius = UDim.new(0, 4)
		optCorner.Parent = optBtn
		
		optBtn.MouseButton1Click:Connect(function()
			self.config[key][option] = not self.config[key][option]
			
			TweenService:Create(optBtn, TWEENS.fast, {
				BackgroundColor3 = self.config[key][option] and COLORS.primary or COLORS.surface,
				TextColor3 = self.config[key][option] and COLORS.accent or COLORS.text_primary
			}):Play()
			
			if callback then
				callback(option, self.config[key][option])
			end
		end)
		
		buttons[option] = optBtn
	end
	
	triggerBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		TweenService:Create(container, TWEENS.fast, {
			Size = isOpen and UDim2.new(1, -30, 0, 210) or UDim2.new(1, -30, 0, 46)
		}):Play()
	end)
end

function Lumina:Notify(title, message, duration)
	duration = duration or 4
	
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 320, 0, 100)
	notif.Position = UDim2.new(1, 330, 1, -120)
	notif.BackgroundColor3 = COLORS.background
	notif.BorderSizePixel = 0
	notif.Parent = self.gui
	
	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = notif
	
	local notifStroke = Instance.new("UIStroke")
	notifStroke.Thickness = 1
	notifStroke.Color = COLORS.border
	notifStroke.Parent = notif
	
	local notifHeader = Instance.new("Frame")
	notifHeader.Size = UDim2.new(1, 0, 0, 35)
	notifHeader.BackgroundColor3 = COLORS.surface
	notifHeader.BorderSizePixel = 0
	notifHeader.Parent = notif
	
	local notifHeaderCorner = Instance.new("UICorner")
	notifHeaderCorner.CornerRadius = UDim.new(0, 8)
	notifHeaderCorner.Parent = notifHeader
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = COLORS.text_primary
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = notifHeader
	
	local messageLabel = Instance.new("TextLabel")
	messageLabel.Size = UDim2.new(1, -24, 1, -43)
	messageLabel.Position = UDim2.new(0, 12, 0, 37)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Text = message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 12
	messageLabel.TextColor3 = COLORS.text_secondary
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.Parent = notif
	
	TweenService:Create(notif, TWEENS.smooth, {Position = UDim2.new(1, -330, 1, -120)}):Play()
	
	task.delay(duration, function()
		local tw = TweenService:Create(notif, TWEENS.fast, {Position = UDim2.new(1, 330, 1, -120)})
		tw:Play()
		tw.Completed:Connect(function()
			notif:Destroy()
		end)
	end)
end

return Lumina
