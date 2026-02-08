repeat task.wait() until game:IsLoaded()
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Library = {}

local MainFolder = "sigeon"
local CurrentGame = MainFolder .. "/" .. game.PlaceId .. ".lua"
local ConfigTable = {Libraries = {ToggleButton = {}, MiniToggle = {}, Slider = {}, Dropdown = {}}}
if not isfolder(MainFolder) then makefolder(MainFolder) end

if isfile(CurrentGame) then
	local GetMain = readfile(CurrentGame)
	if GetMain and GetMain ~= "" then
		local Success, OldSettings = pcall(HttpService.JSONDecode, HttpService, GetMain)
		if Success and OldSettings then
			ConfigTable = OldSettings
		end
	end
end

task.spawn(function()
	while task.wait(5) do
		writefile(CurrentGame, HttpService:JSONEncode(ConfigTable))
	end
end)

local function GetChildrenY(obj)
	local OldY = 0
	for _, v in ipairs(obj:GetChildren()) do
		if v:IsA("GuiObject") then
			OldY += v.AbsoluteSize.Y + v.Position.Y.Offset
		end
	end
	return UDim2.new(obj.Size.X.Scale, obj.Size.X.Offset, 0, OldY)
end

function Library:Initialize()
	local Core = {}
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = HttpService:GenerateGUID(false)
	ScreenGui.ResetOnSpawn = false
	if RunService:IsStudio() then
		ScreenGui.Parent = PlayerGui
	else
		if CoreGui then
			ScreenGui.Parent = CoreGui
		else
			ScreenGui.Parent = PlayerGui
		end
	end
	
	--
	
	local VisualFrame = Instance.new("Frame")
	VisualFrame.Parent = ScreenGui
	VisualFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	VisualFrame.BackgroundTransparency = 1.000
	VisualFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	VisualFrame.BorderSizePixel = 0
	VisualFrame.Size = UDim2.new(1, 0, 1, 0)
	
	local ArrayContainer = Instance.new("Frame")
	ArrayContainer.Parent = VisualFrame
	ArrayContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArrayContainer.BackgroundTransparency = 1.000
	ArrayContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArrayContainer.BorderSizePixel = 0
	ArrayContainer.Position = UDim2.new(0, 15, 0, 15)
	ArrayContainer.Size = UDim2.new(0.196470603, 0, 0.855223835, 0)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = ArrayContainer
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local Logo = Instance.new("ImageLabel")
	Logo.Parent = VisualFrame
	Logo.AnchorPoint = Vector2.new(0.5, 0.5)
	Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Logo.BackgroundTransparency = 1.000
	Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Logo.BorderSizePixel = 0
	Logo.Position = UDim2.new(0.930000007, 0, 0.879999995, 0)
	Logo.Size = UDim2.new(0, 125, 0, 125)
	Logo.Image = "rbxassetid://135318918544831"
	Logo.ScaleType = Enum.ScaleType.Crop
	
	--
	
	local WindowsFrame = Instance.new("Frame")
	WindowsFrame.Parent = ScreenGui
	WindowsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	WindowsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowsFrame.Size = UDim2.new(0, 450, 0, 350)
	WindowsFrame.Visible = false

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = WindowsFrame
	
	local Title = Instance.new("TextLabel")
	Title.Parent = WindowsFrame
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.Font = Enum.Font.Nunito
	Title.Text = "   sigeon.pex | " .. LocalPlayer.Name .. " | " .. game.PlaceId
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.TextSize = 20.000
	Title.TextWrapped = true
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
	UITextSizeConstraint.Parent = Title
	UITextSizeConstraint.MaxTextSize = 20
	
	--
	
	local TabContainer = Instance.new("Frame")
	TabContainer.Parent = WindowsFrame
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabContainer.BorderSizePixel = 0
	TabContainer.Position = UDim2.new(0, 0, 0, 40)
	TabContainer.Size = UDim2.new(0, 75, 1, -40)

	local UIListLayout_2 = Instance.new("UIListLayout")
	UIListLayout_2.Parent = TabContainer
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.Padding = UDim.new(0, 25)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = TabContainer
	UIPadding.PaddingLeft = UDim.new(0, 25)
	UIPadding.PaddingTop = UDim.new(0, 35)
	
	--
	
	local ArrayTable = {}
	local function Insert_Array(name)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayContainer
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 0.500
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.LayoutOrder = 1
		TextLabel.Position = UDim2.new(1, -42, 0, 0)
		TextLabel.ZIndex = -1
		TextLabel.Font = Enum.Font.Nunito
		TextLabel.Text = string.lower(name)
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextSize = 18.000
		TextLabel.TextWrapped = false
		
		local MaxWidth = ArrayContainer.AbsoluteSize.X
		local TextSize = TextService:GetTextSize("  " .. name .. "  ", TextLabel.TextSize, TextLabel.Font, Vector2.new(MaxWidth, math.huge))
		local NewSize = UDim2.new(0, TextSize.X, 0, 20)
		if name == "" then
			NewSize = UDim2.new(0, 0, 0, 0)
		end
		TextLabel.Size = NewSize
		
		table.insert(ArrayTable, TextLabel)
		table.sort(ArrayTable, function(a, b) return TextService:GetTextSize(a.Text, a.TextSize, a.Font, Vector2.new(MaxWidth, math.huge)).X > game.TextService:GetTextSize(b.Text, b.TextSize, b.Font, Vector2.new(MaxWidth, math.huge)).X end)
		for i, v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function Remove_Array(name)
		local MaxWidth = ArrayContainer.AbsoluteSize.X
		table.sort(ArrayTable, function(a, b) return TextService:GetTextSize(a.Text, a.TextSize, a.Font, Vector2.new(MaxWidth, math.huge)).X > game.TextService:GetTextSize(b.Text, b.TextSize, b.Font, Vector2.new(MaxWidth, math.huge)).X end)
		for i, v in ipairs(ArrayTable) do
			if v.Text == string.lower(name) then
				v:Destroy()
				table.remove(ArrayTable, i)
			end
		end
		for i, v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end
	
	UserInputService.InputBegan:Connect(function(Input, gameProcessedEvent)
		if Input.KeyCode == Enum.KeyCode.RightShift and not gameProcessedEvent then
			WindowsFrame.Visible = not WindowsFrame.Visible
			if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end
		end
	end)
	
	--
	
	function Core:CreateSection(types)
		local Sections = {}
		
		local ImageButton = Instance.new("ImageButton")
		ImageButton.Parent = TabContainer
		ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageButton.BackgroundTransparency = 1.000
		ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageButton.BorderSizePixel = 0
		ImageButton.Size = UDim2.new(0, 25, 0, 25)
		
		if types == 1 then
			ImageButton.Image = "rbxassetid://10734898592"
		elseif types == 2 then
			ImageButton.Image = "rbxassetid://10709782230"
		elseif types == 3 then
			ImageButton.Image = "rbxassetid://10709782582"
		elseif types == 4 then
			ImageButton.Image = "rbxassetid://10734910187"
		end
		
		local Container = Instance.new("ScrollingFrame")
		Container.Parent = WindowsFrame
		Container.Active = true
		Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Container.BackgroundTransparency = 1.000
		Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Container.BorderSizePixel = 0
		Container.Position = UDim2.new(0, 75, 0, 40)
		Container.Size = UDim2.new(1, -90, 1, -55)
		Container.ScrollBarThickness = 8
		Container.Visible = false

		local UIPadding_2 = Instance.new("UIPadding")
		UIPadding_2.Parent = Container
		UIPadding_2.PaddingLeft = UDim.new(0, 15)
		UIPadding_2.PaddingTop = UDim.new(0, 25)

		local UIListLayout_3 = Instance.new("UIListLayout")
		UIListLayout_3.Parent = Container
		UIListLayout_3.Wraps = true
		UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 25)
		
		ImageButton.MouseButton1Click:Connect(function()
			for _, v in pairs(WindowsFrame:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			Container.Visible = true
		end)
		
		function Sections:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Enabled = ToggleButton.Enabled or false,
				Keybind = ToggleButton.Keybind or "Euro",
				Callback = ToggleButton.Callback or function() end,
			}
			if not ConfigTable.Libraries.ToggleButton[ToggleButton.Name] then
				ConfigTable.Libraries.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind,
				}
			else
				ToggleButton.Enabled = ConfigTable.Libraries.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = ConfigTable.Libraries.ToggleButton[ToggleButton.Name].Keybind
			end
			
			local ToggleMain = Instance.new("TextButton")
			ToggleMain.Parent = Container
			ToggleMain.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			ToggleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMain.BorderSizePixel = 0
			ToggleMain.Size = UDim2.new(0, 85, 0, 35)
			ToggleMain.Font = Enum.Font.Nunito
			ToggleMain.Text = string.lower(ToggleButton.Name)
			ToggleMain.TextColor3 = Color3.fromRGB(100, 100, 100)
			ToggleMain.TextScaled = true
			ToggleMain.TextSize = 16.000
			ToggleMain.TextWrapped = true
			ToggleMain.AutoButtonColor = false

			local UICorner_2 = Instance.new("UICorner")
			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = ToggleMain

			local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
			UITextSizeConstraint_3.Parent = ToggleMain
			UITextSizeConstraint_3.MaxTextSize = 16

			local ToggleMenu = Instance.new("TextButton")
			ToggleMenu.Parent = ToggleMain
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.Position = UDim2.new(1, -5, 0, 0)
			ToggleMenu.Size = UDim2.new(0.100000001, 10, 1, 0)
			ToggleMenu.Font = Enum.Font.SourceSans
			ToggleMenu.Text = "+"
			ToggleMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleMenu.TextScaled = true
			ToggleMenu.TextSize = 22.000
			ToggleMenu.TextWrapped = true
			ToggleMenu.AutoButtonColor = false
		
			local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
			UITextSizeConstraint_2.Parent = ToggleMenu
			UITextSizeConstraint_2.MaxTextSize = 22
			
			local MenuFrame = Instance.new("Frame")
			MenuFrame.Parent = WindowsFrame
			MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			MenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MenuFrame.BorderSizePixel = 0
			MenuFrame.Position = UDim2.new(1, 15, 0, 15)
			MenuFrame.Size = UDim2.new(0, 200, 0, 320)
			MenuFrame.Visible = false
			MenuFrame:SetAttribute("menu", true)
	
			local UICorner_3 = Instance.new("UICorner")
			UICorner_3.CornerRadius = UDim.new(0, 4)
			UICorner_3.Parent = MenuFrame
			
			local UIListLayout_4 = Instance.new("UIListLayout")
			UIListLayout_4.Parent = MenuFrame
			UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
			
			local TextBox_2 = Instance.new("TextBox")
			TextBox_2.Parent = MenuFrame
			TextBox_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TextBox_2.BackgroundTransparency = 1.000
			TextBox_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox_2.BorderSizePixel = 0
			TextBox_2.LayoutOrder = -1
			TextBox_2.Size = UDim2.new(1, 0, 0, 35)
			TextBox_2.Font = Enum.Font.Nunito
			TextBox_2.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
			TextBox_2.PlaceholderText = "None"
			TextBox_2.Text = ""
			TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox_2.TextScaled = true
			TextBox_2.TextSize = 18.000
			TextBox_2.TextWrapped = true
			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if TextBox_2:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						TextBox_2.PlaceholderText = ""
						TextBox_2.Text = Input.KeyCode.Name
						TextBox_2:ReleaseFocus()
						ConfigTable.Libraries.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					elseif ToggleButton.Keybind == "Backspace" then
						ToggleButton.Keybind = "Euro"
						TextBox_2.Text = ""
						TextBox_2.PlaceholderText = "None"
						TextBox_2:ReleaseFocus()
						ConfigTable.Libraries.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end       
				end
			end)
			
			local UITextSizeConstraint_4 = Instance.new("UITextSizeConstraint")
			UITextSizeConstraint_4.Parent = TextBox_2
			UITextSizeConstraint_4.MaxTextSize = 18
			
			local function OnClicked()
				if ToggleButton.Enabled then
					ToggleMain.TextColor3 = Color3.fromRGB(255, 255, 255)
					Insert_Array(ToggleButton.Name)
					ConfigTable.Libraries.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				else
					ToggleMain.TextColor3 = Color3.fromRGB(100, 100, 100)
					Remove_Array(ToggleButton.Name)
					ConfigTable.Libraries.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				end
			end
			
			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				OnClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			ToggleMain.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				OnClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)
			
			local Opened = false
			ToggleMenu.MouseButton1Click:Connect(function()
				Opened = not Opened
				for _, v in pairs(WindowsFrame:GetChildren()) do
					if v:IsA("Frame") and v:GetAttribute("menu") then
						v.Visible = false
					end
				end
				MenuFrame.Size = GetChildrenY(MenuFrame)
				MenuFrame.Visible = true
			end)
			
			ToggleMain.MouseButton2Click:Connect(function()
				Opened = not Opened
				for _, v in pairs(WindowsFrame:GetChildren()) do
					if v:IsA("Frame") and v:GetAttribute("menu") then
						v.Visible = false
					end
				end
				MenuFrame.Size = GetChildrenY(MenuFrame)
				MenuFrame.Visible = true
			end)
			
			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						OnClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end
			
			function ToggleButton:CreateDropdown(Dropdown)
				Dropdown = {
					Name = Dropdown.Name,
					List = Dropdown.List or {},
					Default = Dropdown.Default,
					Callback = Dropdown.Callback or function() end
				}
				if not ConfigTable.Libraries.Dropdown[Dropdown.Name] then
					ConfigTable.Libraries.Dropdown[Dropdown.Name] = {
						Default = Dropdown.Default
					}
				else
					Dropdown.Default = ConfigTable.Libraries.Dropdown[Dropdown.Name].Default
				end

				local Selected
				local DropdownHolder = Instance.new("TextButton")
				DropdownHolder.Parent = MenuFrame
				DropdownHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				DropdownHolder.BackgroundTransparency = 1.000
				DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.Size = UDim2.new(1, 0, 0, 28)
				DropdownHolder.AutoButtonColor = false
				DropdownHolder.Font = Enum.Font.SourceSans
				DropdownHolder.Text = ""
				DropdownHolder.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownHolder.TextSize = 16.000
				DropdownHolder.TextWrapped = true
				DropdownHolder.TextXAlignment = Enum.TextXAlignment.Left

				local DropdownSelected = Instance.new("TextLabel")
				DropdownSelected.Parent = DropdownHolder
				DropdownSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.BackgroundTransparency = 1.000
				DropdownSelected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownSelected.BorderSizePixel = 0
				DropdownSelected.Size = UDim2.new(0, 195, 1, 0)
				DropdownSelected.Font = Enum.Font.SourceSans
				DropdownSelected.Text = Dropdown.Default or "None"
				DropdownSelected.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownSelected.TextSize = 18.000
				DropdownSelected.TextWrapped = true
				DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right

				local DropdownMode = Instance.new("TextLabel")
				DropdownMode.Parent = DropdownHolder
				DropdownMode.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.BackgroundTransparency = 1.000
				DropdownMode.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownMode.BorderSizePixel = 0
				DropdownMode.Position = UDim2.new(0, 8, 0, 0)
				DropdownMode.Size = UDim2.new(0, 45, 1, 0)
				DropdownMode.Font = Enum.Font.SourceSans
				DropdownMode.Text = "mode:"
				DropdownMode.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownMode.TextSize = 18.000
				DropdownMode.TextWrapped = true
				DropdownMode.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				DropdownHolder.MouseButton1Click:Connect(function()
					DropdownSelected.Text = Dropdown.List[CurrentDropdown]
					Dropdown.Callback(Dropdown.List[CurrentDropdown])
					Selected = Dropdown.List[CurrentDropdown]
					CurrentDropdown = CurrentDropdown % #Dropdown.List + 1
					ConfigTable.Libraries.Dropdown[Dropdown.Name].Default = Selected
				end)

				if Dropdown.Default then
					DropdownSelected.Text = Dropdown.Default
					Dropdown.Callback(Dropdown.Default)
				else
					DropdownSelected.Text = Dropdown.List[1]
					Dropdown.Callback(Dropdown.List[1])
				end

				return Dropdown
			end
			
			function ToggleButton:CreateSlider(Slider)
				Slider = {
					Name = Slider.Name,
					Min = Slider.Min or 0,
					Max = Slider.Max or 100,
					Default = Slider.Default,
					Callback = Slider.Callback or function() end
				}
				if not ConfigTable.Libraries.Slider[Slider.Name] then
					ConfigTable.Libraries.Slider[Slider.Name] = {
						Default = Slider.Default
					}
				else
					Slider.Default = ConfigTable.Libraries.Slider[Slider.Name].Default
				end

				local Value
				local Dragged = false
				local SliderMain = Instance.new("Frame")
				SliderMain.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				SliderMain.BackgroundTransparency = 1.000
				SliderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderMain.BorderSizePixel = 0
				SliderMain.Size = UDim2.new(1, 0, 0, 40)
				SliderMain.Parent = MenuFrame

				local SliderName = Instance.new("TextLabel")
				SliderName.Parent = SliderMain
				SliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.BackgroundTransparency = 1.000
				SliderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderName.BorderSizePixel = 0
				SliderName.Position = UDim2.new(0, 8, 0, 5)
				SliderName.Size = UDim2.new(1, 0, 0, 15)
				SliderName.Font = Enum.Font.SourceSans
				SliderName.Text = string.lower(Slider.Name .. ":")
				SliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.TextSize = 18.000
				SliderName.TextWrapped = true
				SliderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderValue = Instance.new("TextBox")
				SliderValue.Parent = SliderMain
				SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.BackgroundTransparency = 1.000
				SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderValue.Position = UDim2.new(0, 35, 0, 5)
				SliderValue.BorderSizePixel = 0
				SliderValue.Size = UDim2.new(0, 160, 0, 15)
				SliderValue.Font = Enum.Font.SourceSans
				SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.TextSize = 18.000
				SliderValue.TextWrapped = true
				SliderValue.TextXAlignment = Enum.TextXAlignment.Right

				local SliderBack = Instance.new("TextButton")
				SliderBack.Parent = SliderMain
				SliderBack.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
				SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderBack.BorderSizePixel = 0
				SliderBack.Position = UDim2.new(0, 8, 0, 25)
				SliderBack.AutoButtonColor = false
				SliderBack.Size = UDim2.new(0, 185, 0, 8)
				SliderBack.Text = ""

				local SliderFront = Instance.new("Frame")
				SliderFront.Parent = SliderBack
				SliderFront.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFront.BorderSizePixel = 0
				SliderFront.Size = UDim2.new(0, 50, 1, 0)
				SliderFront.Interactable = false

				local function UpdateValue(Input)
					local MouseX = math.clamp(Input.Position.X, SliderMain.AbsolutePosition.X, SliderMain.AbsolutePosition.X + SliderMain.AbsoluteSize.X)
					Value = math.floor(((MouseX - SliderMain.AbsolutePosition.X) / SliderMain.AbsoluteSize.X) * (Slider.Max - Slider.Min) + Slider.Min + 0.05) * 10 / 10
					SliderFront.Size = UDim2.new((Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
					SliderValue.Text = Value
					Slider.Callback(Value)
					ConfigTable.Libraries.Slider[Slider.Name].Default = Value
				end

				SliderBack.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragged = true
						local MouseX = math.clamp(UserInputService:GetMouseLocation().X, SliderMain.AbsolutePosition.X, SliderMain.AbsolutePosition.X + SliderMain.AbsoluteSize.X)
						Value = math.floor(((MouseX - SliderMain.AbsolutePosition.X) / SliderMain.AbsoluteSize.X) * (Slider.Max - Slider.Min) + Slider.Min + 0.05) * 10 / 10
						SliderFront.Size = UDim2.new((Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
						SliderValue.Text = Value
						Slider.Callback(Value)
					end
				end)

				SliderBack.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Dragged and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
						UpdateValue(Input)
					end
				end)

				SliderValue.FocusLost:Connect(function(Return)
					if not Return then return end
					local NumValue = tonumber(SliderValue.Text)
					if NumValue then
						Value = math.clamp(NumValue, Slider.Min, Slider.Max)
						SliderFront.Size = UDim2.new((Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
						SliderValue.Text = Value
						Slider.Callback(Value)
					else
						SliderValue.Text = Value
					end
				end)

				if Slider.Default then
					Value = math.clamp(Slider.Default, Slider.Min, Slider.Max)
					SliderFront.Size = UDim2.new((Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
					SliderValue.Text = Value
					Slider.Callback(Value)
				else
					Value = math.clamp(0, Slider.Min, Slider.Max)
					SliderFront.Size = UDim2.new((Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
					SliderValue.Text = Value
					Slider.Callback(Value)
				end

				return Slider
			end
			
			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled or false,
					Callback = MiniToggle.Callback or function() end
				}
				if not ConfigTable.Libraries.MiniToggle[MiniToggle.Name] then
					ConfigTable.Libraries.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled,
					}
				else
					MiniToggle.Enabled = ConfigTable.Libraries.MiniToggle[MiniToggle.Name].Enabled
				end

				local MiniToggleMain = Instance.new("Frame")
				MiniToggleMain.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				MiniToggleMain.BackgroundTransparency = 1.000
				MiniToggleMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleMain.BorderSizePixel = 0
				MiniToggleMain.Size = UDim2.new(1, 0, 0, 28)
				MiniToggleMain.Parent = MenuFrame

				local MiniToggleName = Instance.new("TextLabel")
				MiniToggleName.Parent = MiniToggleMain
				MiniToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.BackgroundTransparency = 1.000
				MiniToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleName.BorderSizePixel = 0
				MiniToggleName.Position = UDim2.new(0, 8, 0, 0)
				MiniToggleName.Size = UDim2.new(0, 175, 1, 0)
				MiniToggleName.Font = Enum.Font.SourceSans
				MiniToggleName.Text = string.lower(MiniToggle.Name)
				MiniToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.TextSize = 18.000
				MiniToggleName.TextWrapped = true
				MiniToggleName.TextXAlignment = Enum.TextXAlignment.Left

				local MiniToggleClick = Instance.new("TextButton")
				MiniToggleClick.Parent = MiniToggleMain
				MiniToggleClick.AnchorPoint = Vector2.new(0.5, 0.5)
				MiniToggleClick.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MiniToggleClick.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleClick.BorderSizePixel = 0
				MiniToggleClick.Position = UDim2.new(0.9, 0, 0.5, 0)
				MiniToggleClick.Size = UDim2.new(0, 18, 0, 18)
				MiniToggleClick.AutoButtonColor = false
				MiniToggleClick.Font = Enum.Font.SourceSans
				MiniToggleClick.TextTransparency = 1
				MiniToggleClick.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleClick.TextSize = 18.000
				MiniToggleClick.TextWrapped = true
				MiniToggleClick.TextScaled = true
				MiniToggleClick.TextYAlignment = Enum.TextYAlignment.Center
				MiniToggleClick.TextXAlignment = Enum.TextXAlignment.Center

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = MiniToggleClick

				local function MiniToggleClicked()
					if MiniToggle.Enabled then
						MiniToggleClick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						ConfigTable.Libraries.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					else
						MiniToggleClick.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
						ConfigTable.Libraries.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					end
				end

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					MiniToggleClicked()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end

				MiniToggleClick.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					MiniToggleClicked()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)

				return MiniToggle
			end
			
			return ToggleButton
		end
		
		return Sections
	end
	
	return Core
end


return Library
