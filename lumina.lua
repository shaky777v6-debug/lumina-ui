local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local COLORS = {
	background = Color3.fromRGB(15, 10, 25),
	surface = Color3.fromRGB(25, 18, 40),
	surface_light = Color3.fromRGB(35, 25, 55),

	primary = Color3.fromRGB(155, 89, 255),
	accent = Color3.fromRGB(190, 120, 255),

	text_primary = Color3.fromRGB(245, 240, 255),
	text_secondary = Color3.fromRGB(170, 155, 200),

	border = Color3.fromRGB(70, 45, 100),

	success = Color3.fromRGB(120, 255, 170),
	danger = Color3.fromRGB(255, 90, 120)
}

local Lumina = {}
Lumina.__index = Lumina

function Lumina.new(title)
	local self = setmetatable({}, Lumina)
	
	self.config = {}
	self.connections = {}
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LuminaUI_" .. title
	screenGui.ResetOnSpawn = false
	
	pcall(function()
		screenGui.Parent = CoreGui
	end)
	if not screenGui.Parent then
		screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end
	
	self.ScreenGui = screenGui
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 520, 0, 360)
	mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
	mainFrame.BackgroundColor3 = COLORS.background
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Parent = screenGui
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = mainFrame
	
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 40)
	topBar.BackgroundColor3 = COLORS.surface
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame
	
	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 8)
	topCorner.Parent = topBar
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title .. " | by @lookables"
	titleLabel.TextColor3 = COLORS.text_primary
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar
	
	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "Minimize"
	minimizeButton.Size = UDim2.new(0, 30, 0, 30)
	minimizeButton.Position = UDim2.new(1, -40, 0, 5)
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Text = "-"
	minimizeButton.TextColor3 = COLORS.text_secondary
	minimizeButton.TextSize = 20
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.Parent = topBar
	
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, 0, 1, -40)
	container.Position = UDim2.new(0, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.Parent = mainFrame
	
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 140, 1, 0)
	sidebar.BackgroundColor3 = COLORS.surface
	sidebar.BorderSizePixel = 0
	sidebar.Parent = container
	
	local tabContainer = Instance.new("Frame")
	tabContainer.Name = "Tabs"
	tabContainer.Size = UDim2.new(1, -140, 1, 0)
	tabContainer.Position = UDim2.new(0, 140, 0, 0)
	tabContainer.BackgroundTransparency = 1
	tabContainer.Parent = container
	
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = sidebar
	
	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingTop = UDim.new(0, 10)
	tabPadding.PaddingLeft = UDim.new(0, 10)
	tabPadding.PaddingRight = UDim.new(0, 10)
	tabPadding.Parent = sidebar

	local creditsLabel = Instance.new("TextLabel")
	creditsLabel.Name = "CreditsLabel"
	creditsLabel.Size = UDim2.new(1, 0, 0, 20)
	creditsLabel.BackgroundTransparency = 1
	creditsLabel.Text = "by @lookables"
	creditsLabel.TextColor3 = COLORS.text_secondary
	creditsLabel.TextSize = 12
	creditsLabel.Font = Enum.Font.GothamMedium
	creditsLabel.LayoutOrder = 9999
	creditsLabel.Parent = sidebar
	
	local dragging, dragInput, dragStart, startPos
	
	local topBarBegan = topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	table.insert(self.connections, topBarBegan)
	
	local topBarChanged = topBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	table.insert(self.connections, topBarChanged)
	
	local globalDrag = UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	table.insert(self.connections, globalDrag)
	
	local minimized = false
	local minimizeConnection = minimizeButton.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			container.Visible = false
			mainFrame.Size = UDim2.new(0, 520, 0, 40)
			minimizeButton.Text = "+"
		else
			mainFrame.Size = UDim2.new(0, 520, 0, 360)
			container.Visible = true
			minimizeButton.Text = "-"
		end
	end)
	table.insert(self.connections, minimizeConnection)
	
	self.MainFrame = mainFrame
	self.TabContainer = tabContainer
	self.Sidebar = sidebar
	self.Tabs = {}
	
	return self
end

function Lumina:AddTab(name, active)
	local tabButton = Instance.new("TextButton")
	tabButton.Name = name .. "Tab"
	tabButton.Size = UDim2.new(1, 0, 0, 32)
	tabButton.BackgroundColor3 = active and COLORS.surface_light or COLORS.surface
	tabButton.BorderSizePixel = 0
	tabButton.Text = name
	tabButton.TextColor3 = active and COLORS.text_primary or COLORS.text_secondary
	tabButton.TextSize = 14
	tabButton.Font = Enum.Font.GothamMedium
	tabButton.Parent = self.Sidebar
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabButton
	
	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Name = name .. "Page"
	scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 4
	scrollingFrame.ScrollBarImageColor3 = COLORS.surface_light
	
	if active then
		for _, child in ipairs(self.TabContainer:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child.Visible = false
			end
		end
	end
	
	scrollingFrame.Visible = active
	scrollingFrame.Parent = self.TabContainer
	
	local pageLayout = Instance.new("UIListLayout")
	pageLayout.Padding = UDim.new(0, 8)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Parent = scrollingFrame
	
	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 15)
	pagePadding.PaddingLeft = UDim.new(0, 15)
	pagePadding.PaddingRight = UDim.new(0, 15)
	pagePadding.Parent = scrollingFrame
	
	local layoutChanged = pageLayout.Changed:Connect(function()
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30)
	end)
	table.insert(self.connections, layoutChanged)
	
	local tabConnection = tabButton.MouseButton1Click:Connect(function()
		for _, child in ipairs(self.Sidebar:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = COLORS.surface
				child.TextColor3 = COLORS.text_secondary
			end
		end
		for _, child in ipairs(self.TabContainer:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child.Visible = false
			end
		end
		tabButton.BackgroundColor3 = COLORS.surface_light
		tabButton.TextColor3 = COLORS.text_primary
		scrollingFrame.Visible = true
	end)
	table.insert(self.connections, tabConnection)
	
	return scrollingFrame
end

function Lumina:AddSlider(parent, text, minVal, maxVal, key, callback)
	self.config[key] = self.config[key] or minVal
	local initialValue = self.config[key]
	
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = text .. "Slider"
	sliderFrame.Size = UDim2.new(1, 0, 0, 50)
	sliderFrame.BackgroundColor3 = COLORS.surface
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Active = true
	sliderFrame.Parent = parent
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = sliderFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 0, 20)
	label.Position = UDim2.new(0, 12, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = COLORS.text_primary
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
	valueLabel.Position = UDim2.new(0.7, -12, 0, 6)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(initialValue)
	valueLabel.TextColor3 = COLORS.text_secondary
	valueLabel.TextSize = 14
	valueLabel.Font = Enum.Font.GothamMedium
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame
	
	local sliderBar = Instance.new("Frame")
	sliderBar.Name = "SliderBar"
	sliderBar.Size = UDim2.new(1, -24, 0, 14)
	sliderBar.Position = UDim2.new(0, 12, 0, 30)
	sliderBar.BackgroundColor3 = COLORS.surface_light
	sliderBar.BorderSizePixel = 0
	sliderBar.Active = true
	sliderBar.ZIndex = 1
	sliderBar.Parent = sliderFrame
	
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 3)
	barCorner.Parent = sliderBar
	
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
	fill.BorderSizePixel = 0
	fill.ZIndex = 1
	fill.Parent = sliderBar
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = fill
	
	local knob = Instance.new("TextButton")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = UDim2.new(0, 0, 0.5, -6)
	knob.BackgroundColor3 = Color3.fromRGB(220, 150, 255)
	knob.BorderSizePixel = 0
	knob.Text = ""
	knob.AutoButtonColor = false
	knob.Active = true
	knob.ZIndex = 2
	knob.Parent = sliderBar
	
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob
	
	local initialPercentage = math.clamp((initialValue - minVal) / (maxVal - minVal), 0, 1)
	if maxVal == minVal then initialPercentage = 0 end
	fill.Size = UDim2.new(initialPercentage, 0, 1, 0)
	knob.Position = UDim2.new(initialPercentage, 0, 0.5, -6)
	
	local isDragging = false
	
	local function updateSlider(input)
		local barWidth = sliderBar.AbsoluteSize.X
		if barWidth <= 0 then return end
		local inputX = input.Position.X
		local barLeft = sliderBar.AbsolutePosition.X
		local percentage = math.clamp((inputX - barLeft) / barWidth, 0, 1)
		
		local rawValue = minVal + ((maxVal - minVal) * percentage)
		local roundedValue = math.round(rawValue)
		
		self.config[key] = roundedValue
		valueLabel.Text = tostring(roundedValue)
		
		fill.Size = UDim2.new(percentage, 0, 1, 0)
		knob.Position = UDim2.new(percentage, 0, 0.5, -6)
		
		pcall(function()
			if callback then
				callback(roundedValue)
			end
		end)
	end
	
	local sliderBegan = sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			updateSlider(input)
		end
	end)
	table.insert(self.connections, sliderBegan)
	
	local knobBegan = knob.MouseButton1Down:Connect(function()
		isDragging = true
		local mouse = UserInputService:GetMouseLocation() - game:GetService("GuiService"):GetGuiInset()
		updateSlider({
			Position = Vector3.new(mouse.X, mouse.Y, 0)
		})
	end)
	table.insert(self.connections, knobBegan)
	
	local globalMove = UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
	table.insert(self.connections, globalMove)
	
	local globalEnd = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)
	table.insert(self.connections, globalEnd)
end

function Lumina:AddToggle(parent, text, key, callback)
	self.config[key] = (self.config[key] ~= nil) and self.config[key] or false
	local state = self.config[key]
	
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = text .. "Toggle"
	toggleFrame.Size = UDim2.new(1, 0, 0, 40)
	toggleFrame.BackgroundColor3 = COLORS.surface
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Parent = parent
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = toggleFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = COLORS.text_primary
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 34, 0, 20)
	button.Position = UDim2.new(1, -46, 0.5, -10)
	button.BackgroundColor3 = state and COLORS.primary or COLORS.surface_light
	button.BorderSizePixel = 0
	button.Text = ""
	button.Parent = toggleFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = button
	
	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 14, 0, 14)
	indicator.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	indicator.BackgroundColor3 = state and COLORS.text_primary or COLORS.text_secondary
	indicator.BorderSizePixel = 0
	indicator.Parent = button
	
	local indCorner = Instance.new("UICorner")
	indCorner.CornerRadius = UDim.new(1, 0)
	indCorner.Parent = indicator
	
	local toggleConnection = button.MouseButton1Click:Connect(function()
		state = not state
		self.config[key] = state
		
		local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		local targetColor = state and COLORS.primary or COLORS.surface_light
		local indColor = state and COLORS.text_primary or COLORS.text_secondary
		
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(indicator, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = indColor}):Play()
		
		pcall(function()
			if callback then
				callback(state)
			end
		end)
	end)
	table.insert(self.connections, toggleConnection)
end

function Lumina:AddDropdown(parent, text, list, key, callback)
	self.config[key] = self.config[key] or list[1]
	
	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = text .. "Dropdown"
	dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
	dropdownFrame.BackgroundColor3 = COLORS.surface
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.Parent = parent
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = dropdownFrame
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 40)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = dropdownFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = COLORS.text_primary
	label.TextSize = 14
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = button
	
	local currentLabel = Instance.new("TextLabel")
	currentLabel.Size = UDim2.new(0.3, 0, 1, 0)
	currentLabel.Position = UDim2.new(0.7, -12, 0, 0)
	currentLabel.BackgroundTransparency = 1
	currentLabel.Text = tostring(self.config[key])
	currentLabel.TextColor3 = COLORS.text_secondary
	currentLabel.TextSize = 14
	currentLabel.Font = Enum.Font.GothamMedium
	currentLabel.TextXAlignment = Enum.TextXAlignment.Right
	currentLabel.Parent = button
	
	local itemsFrame = Instance.new("Frame")
	itemsFrame.Size = UDim2.new(1, -24, 0, 0)
	itemsFrame.Position = UDim2.new(0, 12, 0, 40)
	itemsFrame.BackgroundTransparency = 1
	itemsFrame.Parent = dropdownFrame
	
	local itemsLayout = Instance.new("UIListLayout")
	itemsLayout.Padding = UDim.new(0, 4)
	itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	itemsLayout.Parent = itemsFrame
	
	local open = false
	
	local function refreshLayout()
		if open then
			local contentSize = itemsLayout.AbsoluteContentSize.Y
			dropdownFrame.Size = UDim2.new(1, 0, 0, 45 + contentSize)
		else
			dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
		end
		
		if parent and parent:IsA("ScrollingFrame") then
			local pageLayout = parent:FindFirstChildOfClass("UIListLayout")
			if pageLayout then
				parent.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30)
			end
		end
	end
	
	local dropdownConnection = button.MouseButton1Click:Connect(function()
		open = not open
		refreshLayout()
	end)
	table.insert(self.connections, dropdownConnection)
	
	for i, val in ipairs(list) do
		local itemButton = Instance.new("TextButton")
		itemButton.Size = UDim2.new(1, 0, 0, 30)
		itemButton.BackgroundColor3 = COLORS.surface_light
		itemButton.BorderSizePixel = 0
		itemButton.Text = tostring(val)
		itemButton.TextColor3 = COLORS.text_secondary
		itemButton.TextSize = 13
		itemButton.Font = Enum.Font.GothamMedium
		itemButton.Parent = itemsFrame
		
		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 4)
		itemCorner.Parent = itemButton
		
		local itemConnection = itemButton.MouseButton1Click:Connect(function()
			currentLabel.Text = tostring(val)
			self.config[key] = val
			open = false
			refreshLayout()
			pcall(function()
				if callback then
					callback(val)
				end
			end)
		end)
		table.insert(self.connections, itemConnection)
	end
end

function Lumina:Notify(title, message)
	local notifyFrame = Instance.new("Frame")
	notifyFrame.Size = UDim2.new(0, 260, 0, 70)
	notifyFrame.Position = UDim2.new(1, 300, 1, -85)
	notifyFrame.BackgroundColor3 = COLORS.surface
	notifyFrame.BorderSizePixel = 0
	notifyFrame.Parent = self.ScreenGui
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = notifyFrame
	
	local nTitle = Instance.new("TextLabel")
	nTitle.Size = UDim2.new(1, -24, 0, 25)
	nTitle.Position = UDim2.new(0, 12, 0, 4)
	nTitle.BackgroundTransparency = 1
	nTitle.Text = title
	nTitle.TextColor3 = COLORS.text_primary
	nTitle.TextSize = 14
	nTitle.Font = Enum.Font.GothamBold
	nTitle.TextXAlignment = Enum.TextXAlignment.Left
	nTitle.Parent = notifyFrame
	
	local nDesc = Instance.new("TextLabel")
	nDesc.Size = UDim2.new(1, -24, 0, 35)
	nDesc.Position = UDim2.new(0, 12, 0, 25)
	nDesc.BackgroundTransparency = 1
	nDesc.Text = message
	nDesc.TextColor3 = COLORS.text_secondary
	nDesc.TextSize = 12
	nDesc.Font = Enum.Font.GothamMedium
	nDesc.TextXAlignment = Enum.TextXAlignment.Left
	nDesc.TextYAlignment = Enum.TextYAlignment.Top
	nDesc.TextWrapped = true
	nDesc.Parent = notifyFrame
	
	TweenService:Create(notifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -275, 1, -85)}):Play()
	
	task.delay(4, function()
		if notifyFrame and notifyFrame.Parent then
			local closeTween = TweenService:Create(notifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, -85)})
			
			local closeConnection = closeTween.Completed:Connect(function()
				notifyFrame:Destroy()
			end)
			table.insert(self.connections, closeConnection)
			
			closeTween:Play()
		end
	end)
end

function Lumina:Destroy()
	if self.connections then
		for _, connection in ipairs(self.connections) do
			if connection then
				connection:Disconnect()
			end
		end
		self.connections = nil
	end
	if self.ScreenGui then
		self.ScreenGui:Destroy()
		self.ScreenGui = nil
	end
end

return Lumina
