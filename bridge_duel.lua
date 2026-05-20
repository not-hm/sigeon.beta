--Welcome skids! please skid my beautiful code! okay???!?!?!?!??!!
repeat task.wait() until game:IsLoaded() and workspace.CurrentCamera
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/library.lua"))()
local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/utility.lua"))()
local cloneref = cloneref or function(obj) return obj end
local hookfunction = hookfunction or function(func, callback) end
local hookmetamethod = hookmetamethod or function(func, callback) end
local getconnections = getconnections or function(obj) return end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local BridgeDuel = {}


local Team
local Crosshair, FakeCrosshair = nil, nil
task.defer(function()
	BridgeDuel = {
		Knit = require(ReplicatedStorage.Modules.Knit.Client),
		Blink = require(ReplicatedStorage.Blink.Client),
		Communication = require(ReplicatedStorage.Client.Communication),
		Modules = {
			Entity = require(ReplicatedStorage.Modules.Entity),
			ServerData = require(ReplicatedStorage.Modules.ServerData)
		},
		Constants = {
			Rank = require(ReplicatedStorage.Constants.Ranks),
			Melee = require(ReplicatedStorage.Constants.Melee),
			Pickaxes = require(ReplicatedStorage.Constants.Pickaxes),
			--Blocks = require(ReplicatedStorage.Constants.Blocks),
			Blocks = { --dude i fucking hate them for using viewport
				["Bed"] = {Time = 0.3, Image = nil },
				["Clay"] = {Time = 1.4, Image = "rbxassetid://108217791045618"},
				["WoodPlanks"] = {Time = 4, Image = "rbxassetid://120849093264241"},
				["Stone"] = {Time = 5, Image = "rbxassetid://16725185852"},
				["EndStone"] = {Time = 4, Image = "rbxassetid://119181217383917"},
				["Bricks"] = {Time = 8, Image = "rbxassetid://74905178355362"},
				["Iron"] = {Time = 13, Image = "rbxassetid://17566796057"},
				["Diamond"] = {Time = 25, Image = "rbxassetid://11168800609"},
				["TNT"] = {Time = 999, Image = "rbxassetid://109900238660461"},
			}
		},
		Remotes = {
			KnockBackApplied = ReplicatedStorage.Modules.Knit.Services.CombatService.RE.KnockBackApplied --im not using knit for this cus its to complex), and its also easier to do getconnection
		},
		Functions = {
			Utility = {
				GetBed = function()
					if not Utility.IsAlive(LocalPlayer) then return end
					local Bed, MinDist = nil, math.huge
					for _, v in workspace:GetDescendants() do
						if not (v.Parent:IsA("Model") and v.Parent.Name == "Bed" and v.Name == "Block") then continue end
						if v.Parent:GetAttribute("Team") == LocalPlayer.Team.Name then continue end
						local Dist = (v.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
						if Dist < MinDist then
							MinDist = Dist
							Bed = v
						end
					end
					return Bed
				end,
				GetUI = function()
					if LocalPlayer.PlayerGui:FindFirstChild("MainGui") then
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("Event") and LocalPlayer.PlayerGui.MainGui.Event.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("EventOld") and LocalPlayer.PlayerGui.MainGui.EventOld.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("Guild") and LocalPlayer.PlayerGui.MainGui.Guild.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("IDE") and LocalPlayer.PlayerGui.MainGui.IDE.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("Inventory") and LocalPlayer.PlayerGui.MainGui.Inventory.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("JSON") and LocalPlayer.PlayerGui.MainGui.JSON.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("Party") and LocalPlayer.PlayerGui.MainGui.Party.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("Settings") and LocalPlayer.PlayerGui.MainGui.Settings.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("TextureRepository") and LocalPlayer.PlayerGui.MainGui.TextureRepository.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("MenuBackground") and LocalPlayer.PlayerGui.MainGui.MenuBackground.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("Jumpscare") and LocalPlayer.PlayerGui.MainGui.Jumpscare.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("HostPanel") and LocalPlayer.PlayerGui.MainGui.HostPanel.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("ItemShop") and LocalPlayer.PlayerGui.MainGui.ItemShop.Visible then return true end
						if LocalPlayer.PlayerGui.MainGui:FindFirstChild("TeamUpgrades") and LocalPlayer.PlayerGui.MainGui.TeamUpgrades.Visible then return true end
					end
					return false
				end,
			}
		}
	}
end)

local Core = Library:Initialize()
local Sections = {
	Combat = Core:CreateSection(1, UDim2.new(0, 0, 2, -350)),
	Movement = Core:CreateSection(2, UDim2.new(0, 0, 0, 0)),
	Visual = Core:CreateSection(3, UDim2.new(0, 0, 0, 0)),
	World = Core:CreateSection(4, UDim2.new(0, 0, 0, 0)),
	Misc = Core:CreateSection(5, UDim2.new(0, 0, 0, 0)),
}

local AimAssist
task.defer(function()
	local Strength, Prediction, Distances
	local ToolCheck = false

	AimAssist = Sections.Combat:CreateToggle({
		Name = "Aim Assist",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Heartbeat", "AimAssist", nil, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					if not Utility.IsFirstPerson() then return end
					if BridgeDuel.Functions.Utility.GetUI() then return end
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						local Entity = Utility.GetNearestEntity.Distance(Distances, "Angle", Team.Enabled, true, 120)
						if Entity then
							if ToolCheck and not Utility.Inventory.Character.Find("sword") then return end
							local FinalPos = Entity.Character.PrimaryPart.Position + (Entity.Character.PrimaryPart.AssemblyLinearVelocity * Prediction)
							workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, FinalPos), Strength)
						end
					end
				end)
			else
				Utility.BindRemove("Heartbeat", "AimAssist")
			end
		end
	})
	AimAssist:CreateMiniToggle({
		Name = "Tool Check",
		Enabled = true,
		Callback = function(callback)
			ToolCheck = callback
		end,
	})
	AimAssist:CreateSlider({
		Name = "Distances",
		Min = 0,
		Max = 30,
		Default = 22,
		Callback = function(callback)
			Distances = callback
		end
	})
	AimAssist:CreateSlider({
		Name = "Strength",
		Min = 1,
		Max = 15,
		Default = 12,
		Callback = function(callback)
			Strength = callback / 100
		end
	})
	AimAssist:CreateSlider({
		Name = "Prediction",
		Min = 0,
		Max = 10,
		Default = 3,
		Callback = function(callback)
			Prediction = callback / 100
		end
	})
end)

local AutoClicker
task.defer(function()
	local MaxCPS, MinCPS, CCPS = nil, nil, nil
	local Randomize, CDelay = false, nil

	AutoClicker = Sections.Combat:CreateToggle({
		Name = "Auto Clicker",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Heartbeat", "AutoClicker", 0, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					local Tool = Utility.Inventory.Character.Get()
					if not Tool then return end
					if Randomize then
						CCPS = math.random(MinCPS, MaxCPS)
					else
						CCPS = MaxCPS
					end
					if CCPS then
						CDelay = 1 / CCPS
						Utility.BindUpdate("Heartbeat", "AutoClicker", CDelay)
					end
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						Tool:Activate()
						BridgeDuel.Blink.player_state.update_cps.fire(CCPS)
					end
				end)
			else
				Utility.BindRemove("Heartbeat", "AutoClicker")
			end
		end
	})
	AutoClicker:CreateMiniToggle({
		Name = "Randomize",
		Enabled = true,
		Callback = function(callback)
			Randomize = callback
		end
	})
	AutoClicker:CreateSlider({
		Name = "Max",
		Min = 1,
		Max = 20,
		Default = 12,
		Callback = function(callback)
			MaxCPS = callback
		end
	})
	AutoClicker:CreateSlider({
		Name = "Min",
		Min = 1,
		Max = 20,
		Default = 8,
		Callback = function(callback)
			MinCPS = callback
		end
	})
end)

local MotionReset
task.defer(function()
	local Connection

	MotionReset = Sections.Combat:CreateToggle({
		Name = "Motion Reset",
		Callback = function(callback)
			repeat task.wait() until BridgeDuel.Remotes.KnockBackApplied
			if callback then
				Connection = BridgeDuel.Remotes.KnockBackApplied.OnClientEvent:Connect(function(...)
					LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
					LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Jump = true
				end)
			else
				if Connection then
					Connection:Disconnect()
					Connection = nil
				end
			end
		end
	})
end)

local SilentAura
task.defer(function()
	local Distances
	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude
	RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	
	SilentAura = Sections.Combat:CreateToggle({
		Name = "Silent Aura",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Heartbeat", "SilentAura", nil, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					if BridgeDuel.Functions.Utility.GetUI() then return end
					--
					if not LocalPlayer.PlayerGui.MainGui:FindFirstChild("FakeCrosshair") then
						Crosshair = LocalPlayer.PlayerGui.MainGui.Crosshair
						FakeCrosshair = Crosshair:Clone()

						FakeCrosshair.Name = "FakeCrosshair"
						FakeCrosshair.Parent = Crosshair.Parent
						Crosshair.Image = "rbxassetid://10723346959"
					end
					--
					local Tool = Utility.Inventory.Character.Find("sword")
					if not Tool then return end
					local Entity = Utility.GetNearestEntity.Distance(24, "Angle", Team.Enabled, true, 120)
					if not Entity then
						Crosshair.Position = FakeCrosshair.Position
						return
					end
					--
					local Distance = Utility.GetMagnitude(Entity.Character.PrimaryPart.Position, LocalPlayer.Character.PrimaryPart.Position)
					if Distance <= Distances then
						Tool:Activate()
						BridgeDuel.Blink.player_state.update_cps.fire(math.random(8, 12))
						local Result = workspace:Raycast(LocalPlayer.Character.PrimaryPart.Position, (Entity.Character.PrimaryPart.Position + Vector3.new(0, 1.5, 0) - LocalPlayer.Character.PrimaryPart.Position).Unit * 1000, RayParams)
						local ScreenPos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Result and Result.Instance:IsDescendantOf(Entity.Character) and Result.Position or Entity.Character.PrimaryPart.Position)
						if OnScreen and Crosshair and FakeCrosshair then
							Crosshair.Position = UDim2.fromScale(ScreenPos.X / workspace.CurrentCamera.ViewportSize.X, ScreenPos.Y / workspace.CurrentCamera.ViewportSize.Y)
						else
							Crosshair.Position = FakeCrosshair.Position
						end
					else
						Crosshair.Position = FakeCrosshair.Position
					end
					--
				end)
			else
				Utility.BindRemove("Heartbeat", "SilentAura")
				--
				if LocalPlayer.PlayerGui.MainGui:FindFirstChild("FakeCrosshair") then
					Crosshair.Image = FakeCrosshair.Image
					Crosshair.Position = FakeCrosshair.Position
					FakeCrosshair:Destroy()
				end
				--
			end
		end,
	})
	SilentAura:CreateSlider({
		Name = "Start Swing",
		Min = 0,
		Max = 22,
		Default = 20,
		Callback = function(callback)
			Distances = callback
		end,
	})
end)

local TriggerBot
task.defer(function()
	local Distance

	TriggerBot = Sections.Combat:CreateToggle({
		Name = "Trigger Bot",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Stepped", "TriggerBot", nil, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					if BridgeDuel.Functions.Utility.GetUI() then return end
					local Entity = Utility.GetNearestEntity.Distance(Distance, "Angle", Team.Enabled, true, 120)
					if Entity and Mouse.Target and Mouse.Target:IsDescendantOf(Entity) then
						local Tool = Utility.Inventory.Character.Find("sword")
						if not Tool then return end
						Tool:Activate()
					end
				end)
			else
				Utility.BindRemove("Stepped", "TriggerBot")
			end
		end
	})
	TriggerBot:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 16,
		Default = 14,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
end)


local Velocity
task.defer(function()
	local Original = {Connection = nil, Function = nil}
	local Knockback = {X = 100, Y = 100}
	local Connection

	Velocity = Sections.Combat:CreateToggle({
		Name = "Velocity",
		Callback = function(callback)
			repeat task.wait() until BridgeDuel.Remotes.KnockBackApplied
			if callback then
				local v = getconnections(BridgeDuel.Remotes.KnockBackApplied.OnClientEvent)[1]
				if v and v.Function then
					Original.Function = v.Function
					v:Disable()
				end
				Connection = BridgeDuel.Remotes.KnockBackApplied.OnClientEvent:Connect(function(plr1, dir, pos, mag, data)
					local Horizontal = mag * (Knockback.X / 100)
					local Vertical = mag * (Knockback.Y / 100)
					local Magnitude = (Horizontal + Vertical) / 2
					if Original.Function then
						task.spawn(Original.Function, plr1, dir, pos, Magnitude, data)
					end
				end)
			else
				if Connection then
					Connection:Disconnect()
					Connection = nil
				end
				local v = getconnections(BridgeDuel.Remotes.KnockBackApplied.OnClientEvent)[1]
				if v then v:Enable() end
			end
		end
	})
	Velocity:CreateSlider({
		Name = "Horizontal",
		Min = 0,
		Max = 100,
		Default = 100,
		Callback = function(value)
			Knockback.X = value
		end
	})
	Velocity:CreateSlider({
		Name = "Vertical",
		Min = 0,
		Max = 100,
		Default = 100,
		Callback = function(value)
			Knockback.Y = value
		end
	})
end)


local BedAlarm
task.defer(function()
	--if not (string.find(BridgeDuel.Modules.ServerData.Submode, "bedwars") or string.find(BridgeDuel.Modules.ServerData.Submode, "playground")) then return end
	local Notified = false
	
	BedAlarm = Sections.Visual:CreateToggle({
		Name = "Bed Alarm",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Stepped", "BedAlarm", 0.5, function()
					for _, v in workspace:GetDescendants() do
						if v.Parent:IsA("Model") and v.Parent.Name == "Bed" then continue end
						if v.Parent:GetAttribute("Team") ~= LocalPlayer.Team.Name then continue end
						local Hitbox = v.Parent:FindFirstChild("Block")
						if not Hitbox then continue end
						for _, v in Players:GetPlayers() do
							if v == LocalPlayer then continue end
							if v.Team == LocalPlayer.Team then continue end
							if not Utility.IsAlive(v) then continue end
							local Distance = (Hitbox.Position - v.Character.PrimaryPart.Position).Magnitude
							if Distance < 15 and not Notified then
								Notified = true
								task.spawn(Core.CreateNotification, Core, "Bed Alarm", v.DisplayName .. " is near your bed!", 5)
								task.delay(5, function()
									Notified = false
								end)
							end
						end
					end
				end)
			else
				Utility.BindRemove("Stepped", "BedAlarm")
				Notified = false
			end
		end
	})
end)

local BedDisplay
task.defer(function()
	--if not (string.find(BridgeDuel.Modules.ServerData.Submode, "bedwars") or string.find(BridgeDuel.Modules.ServerData.Submode, "playground")) then return end
	local OverParams = OverlapParams.new()
	OverParams.FilterType = Enum.RaycastFilterType.Include
	OverParams.FilterDescendantsInstances = {workspace.Map}

	BedDisplay = Sections.Visual:CreateToggle({
		Name = "Bed Display",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Heartbeat", "BedDisplay", 0.5, function()
					for _, bed in workspace.Map:GetChildren() do
						if not (bed:IsA("Model") and bed.Name == "Bed") then continue end
						local Hitbox = bed:FindFirstChildWhichIsA("Part")
						if not Hitbox then Utility.BillBoard.Remove(bed) continue end
						local Counts = {}
						for _, part in workspace:GetPartBoundsInBox(CFrame.new(Hitbox.Position), Vector3.new(20, 20, 20), OverParams) do
							local blockType = part:GetAttribute("block_type")
							if blockType and BridgeDuel.Constants.Blocks[blockType] then
								Counts[blockType] = (Counts[blockType] or 0) + 1
							end
						end
						Utility.BillBoard.Remove(bed)
						Utility.BillBoard.Create(bed)
						for bname, count in Counts do
							local image = BridgeDuel.Constants.Blocks[bname].Image
							if not image then continue end
							Utility.BillBoard.Add(bed, image)
						end
					end
				end)
			else
				Utility.BindRemove("Heartbeat", "BedDisplay")
				for _, bed in workspace.Map:GetChildren() do
					if not (bed:IsA("Model") and bed.Name == "Bed") then continue end
					Utility.BillBoard.Remove(bed)
				end
			end
		end
	})
end)

local ESP
task.defer(function()
	local IncludeBed = false

	ESP = Sections.Visual:CreateToggle({
		Name = "ESP",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Stepped", "ESP", nil, function()
					for _, v in Players:GetPlayers() do
						if v ~= LocalPlayer and Utility.IsAlive(v) then
							Utility.HighlightAdd(v.Character)
						end
					end
					if IncludeBed then
						for _, v in workspace.Map:GetChildren() do
							if v:IsA("Model") and v.Name == "Bed" then
								if v:GetAttribute("Team") ~= LocalPlayer.Team.Name then
									Utility.HighlightAdd(v)
								end
							end
						end
					end
				end)
			else
				Utility.BindRemove("Stepped", "ESP")
				for _, v in Players:GetPlayers() do
					if v ~= LocalPlayer and Utility.IsAlive(v) then
						Utility.HighlightRemove(v.Character)
					end
				end
				if IncludeBed then
					for _, v in workspace.Map:GetChildren() do
						if v:IsA("Model") and v.Name == "Bed" then
							Utility.HighlightRemove(v)
						end
					end
				end
			end
		end
	})
	if not string.find(BridgeDuel.Modules.ServerData.Submode, "bedwars") then return end
	ESP:CreateMiniToggle({
		Name = "Include Bed",
		Callback = function(callback)
			IncludeBed = callback
			if ESP.Enabled then
				for _, v in workspace.Map:GetChildren() do
					if v:IsA("Model") and v.Name == "Bed" then
						if v:GetAttribute("Team") ~= LocalPlayer.Team.Name then
							if callback then
								Utility.HighlightAdd(v)
							else
								Utility.HighlightRemove(v)
							end
						end
					end
				end
			end
		end,
	})
end)

--[[
local AutoSneak
task.defer(function()
	local Height = nil
	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude
	RayParams.FilterDescendantsInstances = {LocalPlayer.Character}

	AutoSneak = Sections.World:CreateToggle({
		Name = "Auto Sneak",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Heartbeat", "AutoBridge", nil, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					if BridgeDuel.Functions.Utility.GetUI() then return end
					local Result = workspace:Raycast(LocalPlayer.Character.PrimaryPart.Position + (LocalPlayer.Character.PrimaryPart.CFrame.LookVector * 1.5), Vector3.new(0, -Height, 0), RayParams)
					if Result then
						if LocalPlayer:GetAttribute("ClientSneaking") then
							BridgeDuel.Knit.GetController("MovementController"):RemoveSpeedOverride("sigeonpex")
							LocalPlayer:SetAttribute("ClientSneaking", false)
						end
					else
						if not LocalPlayer:GetAttribute("ClientSneaking") then
							LocalPlayer:SetAttribute("ClientSneaking", true)
							BridgeDuel.Knit.GetController("MovementController"):AddSpeedOverride("sigeonpex", 0, 1)
						end
					end
				end)
			else
				Utility.BindRemove("Heartbeat", "AutoBridge")
				BridgeDuel.Knit.GetController("MovementController"):RemoveSpeedOverride("sigeonpex")
				LocalPlayer:SetAttribute("ClientSneaking", false)
			end
		end
	})
	AutoSneak:CreateSlider({
		Name = "Height",
		Min = 0,
		Max = 12,
		Default = 6,
		Callback = function(callback)
			if callback then
				Height = callback
			end
		end
	})
end)
--]]

local ProjectileAssist
task.defer(function()
	local ChargeTime
	
	ProjectileAssist = Sections.World:CreateToggle({
		Name = "Projectile Assist",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Heartbeat", "ProjectileAssist", nil, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					if BridgeDuel.Functions.Utility.GetUI() then return end
					--
					if not LocalPlayer.PlayerGui.MainGui:FindFirstChild("FakeCrosshair") then
						Crosshair = LocalPlayer.PlayerGui.MainGui.Crosshair
						FakeCrosshair = Crosshair:Clone()

						FakeCrosshair.Name = "FakeCrosshair"
						FakeCrosshair.Parent = Crosshair.Parent
						Crosshair.Image = "rbxassetid://10723346959"
					end
					--
					local Tool = Utility.Inventory.Character.Find("bow")
					if not Tool then return end
					if BridgeDuel.Modules.Entity.LocalEntity.IsChargingBow then
						if not ChargeTime then ChargeTime = tick() end
					else
						ChargeTime = nil
						Crosshair.Position = FakeCrosshair.Position
						return
					end
					local Entity = Utility.GetNearestEntity.Mouse(1000, 180, true, true)
					if Entity and Entity.Character and Entity.Character.PrimaryPart then
						local Origin = (workspace.CurrentCamera:ScreenPointToRay(workspace.CurrentCamera.ViewportSize.X / 2, FakeCrosshair.AbsolutePosition.Y)).Origin
						local Charge = math.clamp(tick() - ChargeTime, 0, 0.7)
						local Speed = Charge >= 0.7 and 160 or Charge >= 0.5 and 120 or Charge >= 0.1 and 80 or 60
						--
						local Predicted = Utility.GetPrediction(Entity.Character.PrimaryPart, Origin, Speed)
						local Distance = (Predicted - Origin).Magnitude
						local Time = Distance / Speed
						--
						local GravityComp = math.clamp(0.5 * workspace.Gravity * Time * Time, 0, 80)
						Predicted = Vector3.new(Predicted.X, Predicted.Y + 1.5 + GravityComp, Predicted.Z)
						local ScreenPos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Predicted)
						if OnScreen then
							Crosshair.Position = UDim2.fromScale(ScreenPos.X / workspace.CurrentCamera.ViewportSize.X, ScreenPos.Y / workspace.CurrentCamera.ViewportSize.Y)
						else
							Crosshair.Position = FakeCrosshair.Position
						end
					else
						Crosshair.Position = FakeCrosshair.Position
					end
				end)
				--
			else
				Utility.BindRemove("Heartbeat", "ProjectileAssist")
				ChargeTime = nil
				--
				if LocalPlayer.PlayerGui.MainGui:FindFirstChild("FakeCrosshair") then
					Crosshair.Image = FakeCrosshair.Image
					Crosshair.Position = FakeCrosshair.Position
					FakeCrosshair:Destroy()
				end
				--
			end
		end
	})
end)

local Breaker
task.defer(function()
	local Distance, Current = nil, nil
	local IsBreaking = false
	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Include
	RayParams.FilterDescendantsInstances = {workspace.Map}

	Breaker = Sections.World:CreateToggle({
		Name = "Breaker",
		Callback = function(callback)
			if callback then
				IsBreaking = false
				Utility.BindAdd("Heartbeat", "Breaker", nil, function()
					if not Utility.IsAlive(LocalPlayer) then return end
					if BridgeDuel.Functions.Utility.GetUI() then return end
					--
					local MainGui = LocalPlayer.PlayerGui.MainGui
					if not MainGui:FindFirstChild("FakeCrosshair") then
						FakeCrosshair = MainGui.Crosshair:Clone()
						FakeCrosshair.Name = "FakeCrosshair"
						FakeCrosshair.Parent = MainGui
						MainGui.Crosshair.Image = "rbxassetid://10723346959"
					end
					--
					if Current and not Current.Parent then Current = nil end
					if not Current then
						local Bed = BridgeDuel.Functions.Utility.GetBed()
						if Bed then
							local Direction = Bed.Position - LocalPlayer.Character.PrimaryPart.Position
							local Distances = Direction.Magnitude
							if Distances <= Distance then
								local Result = workspace:Raycast(LocalPlayer.Character.PrimaryPart.Position, Direction.Unit * Distances, RayParams)
								if not Result then
									Current = Bed
								else
									local Hit = Result.Instance
									if Hit.Name == "Block" then
										Current = Hit
									elseif Hit:IsDescendantOf(Bed.Parent) then
										Current = Bed
									end
								end
							end
						end
					end
					if Current and not IsBreaking then
						local Part = Current:IsA("Model") and (Current.PrimaryPart or Current:FindFirstChildWhichIsA("BasePart")) or Current
						if Part then
							local Tool = Utility.Inventory.Character.Find("pickaxe")
							if not Tool then return end
							local ScreenPos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Part.Position)
							local ViewportSize = workspace.CurrentCamera.ViewportSize
							if OnScreen then
								MainGui.Crosshair.Position = UDim2.fromScale(ScreenPos.X / ViewportSize.X, ScreenPos.Y / ViewportSize.Y)
							else
								MainGui.Crosshair.Position = FakeCrosshair.Position
							end
							local IsBed = Part.Parent and Part.Parent.Name == "Bed"
							local BlockType = Part:GetAttribute("block_type") or "Clay"
							local BreakTime
							if IsBed then
								BreakTime = BridgeDuel.Constants.Blocks["Bed"].Time
							else
								local BlockTime = BridgeDuel.Constants.Blocks[BlockType] and BridgeDuel.Constants.Blocks[BlockType].Time or 1.4
								local PickaxeSpeed = BridgeDuel.Constants.Pickaxes[Tool.Name] or 1
								local SpeedModif = 1
								if LocalPlayer.Team then
									local TeamUpgrades = BridgeDuel.Communication.team_upgrades.value[LocalPlayer.Team.Name]
									if TeamUpgrades and TeamUpgrades.BreakSpeed then
										SpeedModif = 1 - TeamUpgrades.BreakSpeed / 10 * 2
									end
								end
								BreakTime = BlockTime * PickaxeSpeed * SpeedModif
							end
							IsBreaking = true
							task.spawn(function()
								BridgeDuel.Blink.item_action.start_break_block.fire({
									position = Part.Position,
									pickaxe_name = Tool.Name,
									timestamp = workspace:GetServerTimeNow()
								})
								task.wait(BreakTime)
								BridgeDuel.Blink.item_action.stop_break_block.fire(true)
								task.wait(0.5)
								Current = nil
								IsBreaking = false
							end)
						end
					end
				end)
			else
				Utility.BindRemove("Heartbeat", "Breaker")
				IsBreaking = false
				Current = nil
				BridgeDuel.Blink.item_action.stop_break_block.fire(false)
				--
				local MainGui = LocalPlayer.PlayerGui.MainGui
				if MainGui:FindFirstChild("FakeCrosshair") then
					MainGui.Crosshair.Image = FakeCrosshair.Image
					MainGui.Crosshair.Position = FakeCrosshair.Position
					FakeCrosshair:Destroy()
					FakeCrosshair = nil
				end
				--
			end
		end
	})
	Breaker:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 18,
		Default = 18,
		Callback = function(callback)
			Distance = callback
		end
	})
end)

local AntiStaff
task.defer(function()
	local Available = {}

	AntiStaff = Sections.Misc:CreateToggle({
		Name = "Anti Staff",
		Callback = function(callback)
			if callback then
				Utility.BindAdd("Stepped", "AntiStaff", 5, function()
					for _, v in Players:GetPlayers() do
						for _, r in ipairs(BridgeDuel.Constants.Rank) do
							if r.Name == "Admin" then
								for _, id in ipairs(r.Users) do
									if v.UserId == id then
										if not table.find(Available, v.Name) then
											Core:CreateNotification("Anti Staff", "Staff joined " .. v.Name, 15)
											table.insert(Available, v.Name)
										end
									end
								end
							end
						end
					end
					for i = #Available, 1, -1 do
						local InGame = false
						for _, v in Players:GetPlayers() do
							if v.Name == Available[i] then
								InGame = true
								break
							end
						end
						if not InGame then
							Core:CreateNotification("Anti Staff", "Staff left " .. Available[i], 15)
							table.remove(Available, i)
						end
					end
				end)
			else
				Utility.BindRemove("Stepped", "AntiStaff")
				table.clear(Available)
			end
		end
	})
end)

task.defer(function()
	Team = Sections.Misc:CreateToggle({
		Name = "Team",
		Callback = function(callback)
		end
	})
end)

Core:CreateNotification("sigeon.pex", "loaded!", 3)
