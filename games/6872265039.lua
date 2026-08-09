--// IDC IF I USE TASK.DEFER ALOT
repeat task.wait() until game:IsLoaded() and workspace.CurrentCamera
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/library.lua'))()
local Utility = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/libraries/universal.lua'))()
local Bedwars = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/libraries/bedwars.lua'))()
local cloneref = cloneref or function(obj) return obj end
local hookfunction = hookfunction or function(func, callback) end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local UserInputService = cloneref(game:GetService('UserInputService'))
local TweenService = cloneref(game:GetService('TweenService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Team
local Core = Library:Initialize()
local Sections = {
	Combat = Core:CreateSection(1, UDim2.new(0, 0, 2, -200)),
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
		Name = 'Aim Assist',
		Callback = function(callback)
			if callback then
				Utility.Misc.Events.Add('Heartbeat', 'AimAssist', nil, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					if Utility.Entity.GetPerspective() == 'Third' then return end
					if Bedwars.Functions.UI.GetUI() then return end
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						local Entity = Utility.Entity.Get.Distance(Distances, 'Angle', Team.Enabled, true, 120)
						if Entity then
							if ToolCheck and not Utility.Entity.Inventory.Character.Get() then return end
							local FinalPos = Entity.Character.PrimaryPart.Position + (Entity.Character.PrimaryPart.AssemblyLinearVelocity * Prediction)
							workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, FinalPos), Strength)
						end
					end
				end)
			else
				Utility.Misc.Events.Remove('Heartbeat', 'AimAssist')
			end
		end
	})
	AimAssist:CreateMiniToggle({
		Name = 'Tool Check',
		Enabled = true,
		Callback = function(callback)
			ToolCheck = callback
		end,
	})
	AimAssist:CreateSlider({
		Name = 'Distances',
		Min = 0,
		Max = 30,
		Default = 22,
		Callback = function(callback)
			Distances = callback
		end
	})
	AimAssist:CreateSlider({
		Name = 'Strength',
		Min = 1,
		Max = 15,
		Default = 12,
		Callback = function(callback)
			Strength = callback / 100
		end
	})
	AimAssist:CreateSlider({
		Name = 'Prediction',
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
		Name = 'Auto Clicker',
		Callback = function(callback)
			if callback then
				Utility.Misc.Events.Add('Heartbeat', 'AutoClicker', 0, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					local Tool
                    local Inventory = Bedwars.GetModule('inventory-util').getInventory(LocalPlayer)
					local Hand = Inventory and Inventory.hand

					if Bedwars.GetController('SwordController'):getHandItem().tool then
    					Tool = 'Melee'
					elseif Hand and Hand.itemType then
    					Tool = 'Block'
					end
					if Randomize then
						CCPS = math.random(MinCPS, MaxCPS)
					else
						CCPS = MaxCPS
					end
					if CCPS then
						CDelay = 1 / CCPS
						Utility.Misc.Events.Update('Heartbeat', 'AutoClicker', CDelay)
					end
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						if Tool == 'Melee' then
                            Bedwars.GetController('SwordController'):swingSwordAtMouse()
                        elseif Tool == 'Block' then
                            local BlockPlacer = Bedwars.GetController('BlockPlacementController'):getBlockPlacer()
                            if not BlockPlacer then return end
                            local Selector = BlockPlacer.clientManager:getBlockSelector()
                            if not Selector then return end
							local BlockSelectorMode = Bedwars.GetModule('block-selector').BlockSelectorMode
                            local MouseInfo = Selector:getMouseInfo(BlockSelectorMode.PLACE)
                            if MouseInfo then
                                BlockPlacer:placeBlock(MouseInfo.placementPosition, MouseInfo)
                            end
                        end
					end
				end)
			else
				Utility.Misc.Events.Remove('Heartbeat', 'AutoClicker')
			end
		end
	})
	AutoClicker:CreateMiniToggle({
		Name = 'Randomize',
		Enabled = true,
		Callback = function(callback)
			Randomize = callback
		end
	})
	AutoClicker:CreateSlider({
		Name = 'Max',
		Min = 1,
		Max = 20,
		Default = 12,
		Callback = function(callback)
			MaxCPS = callback
		end
	})
	AutoClicker:CreateSlider({
		Name = 'Min',
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
	local OldFunc

	MotionReset = Sections.Combat:CreateToggle({
		Name = 'Motion Reset',
		Callback = function(callback)
			if callback then
                OldFunc = hookfunction(Bedwars.GetModule('knockback-util').applyKnockback, function(...)
                    LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState(Enum.HumanoidStateType.Jumping)
					LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Jump = true
                    return OldFunc(...)
                end)
			else
                hookfunction(Bedwars.GetModule('knockback-util').applyKnockback, OldFunc)
                OldFunc = nil
			end
		end
	})
end)

local SilentAura
task.defer(function()
	local StartRotate, StartSwing, StartAttack
	local Direction, Silent

	SilentAura = Sections.Combat:CreateToggle({
		Name = 'Silent Aura',
		Callback = function(callback)
			if callback then
				Utility.Misc.Events.Add('Heartbeat', 'SilentAura', nil, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					if Bedwars.Functions.UI.GetUI() then return end
					local Tool = Bedwars.GetController('SwordController'):getHandItem().tool
					if not Tool then return end
					local Entity = 	Utility.Entity.Get.Distance(24, 'Angle', Team.Enabled, true, Direction)
					if not Entity then return end
					local Distance = Utility.Entity.GetMagnitude(Entity.Character.PrimaryPart.Position, LocalPlayer.Character.PrimaryPart.Position)
					if Distance <= StartRotate then
						local EntityPosition = Vector3.new(Entity.Character.PrimaryPart.Position.X, LocalPlayer.Character.PrimaryPart.Position.Y, Entity.Character.PrimaryPart.Position.Z)
						local LookCFrame = CFrame.lookAt(LocalPlayer.Character.PrimaryPart.Position, EntityPosition)
						if Utility.Entity.GetPerspective() == 'First' then
							if not Silent then return end
							workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Entity.Character.PrimaryPart.Position)
						end
						LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(LocalPlayer.Character.PrimaryPart.Position) * LookCFrame.Rotation
					end
					if Distance <= StartSwing then
                        Bedwars.GetController('SwordController'):swingSwordAtMouse()
					end
                    if Distance <= StartAttack then
                        local Cooldown = Bedwars.GetController('SwordController'):getRemainingSwingCooldown(Tool.Name)
                        if Cooldown > 0 then return end
                        Bedwars.GetController:attackEntity(Entity, (Entity.Character.PrimaryPart.Position - workspace.CurrentCamera.CFrame.Position).Unit)
                    end
				end)
			else
				Utility.Misc.Events.Remove('Heartbeat', 'SilentAura')
			end
		end,
	})
	SilentAura:CreateSlider({
		Name = 'Direction',
		Min = 0,
		Max = 360,
		Default = 360,
		Callback = function(callback)
			Direction = callback
		end,
	})
	SilentAura:CreateSlider({
		Name = 'Start Rotate',
		Min = 0,
		Max = 24,
		Default = 24,
		Callback = function(callback)
			StartRotate = callback
		end,
	})
	SilentAura:CreateSlider({
		Name = 'Start Swing',
		Min = 0,
		Max = 24,
		Default = 22,
		Callback = function(callback)
			StartSwing = callback
		end,
	})
    SilentAura:CreateSlider({
		Name = 'Start Attack',
		Min = 0,
		Max = 24,
		Default = 18,
		Callback = function(callback)
			StartAttack = callback
		end,
	})
	SilentAura:CreateMiniToggle({
		Name = 'Silent',
		Callback = function(callback)
			Silent = callback
		end,
	})
end)

local TriggerBot
task.defer(function()
	local Distance

	TriggerBot = Sections.Combat:CreateToggle({
		Name = 'Trigger Bot',
		Callback = function(callback)
			if callback then
				Utility.Misc.Events.Add('Stepped', 'TriggerBot', nil, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					if Bedwars.Functions.UI.GetUI() then return end
					local Entity = Utility.Entity.Get.Distance(Distance, 'Angle', Team.Enabled, true, 120)
					if Entity and Mouse.Target and Mouse.Target:IsDescendantOf(Entity) then
						local Tool = Bedwars.GetController('SwordController'):getHandItem()
						if not Tool then return end
						Bedwars.GetController('SwordController'):swingSwordAtMouse()
					end
				end)
			else
				Utility.Misc.Events.Remove('Stepped', 'TriggerBot')
			end
		end
	})
	TriggerBot:CreateSlider({
		Name = 'Distance',
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
    local OldFunc
	local Knockback = {X = 100, Y = 100}
    local Original = {
        X = Bedwars.GetModule('knockback-util').KnockbackConstants.kbDirectionStrength,
        Y = Bedwars.GetModule('knockback-util').KnockbackConstants.kbUpwardStrength
    }
	
	Velocity = Sections.Combat:CreateToggle({
		Name = 'Velocity',
		Callback = function(callback)
            if callback then
                Bedwars.GetModule('knockback-util').KnockbackConstants.kbDirectionStrength = Original.X * (Knockback.X / 100)
                Bedwars.GetModule('knockback-util').KnockbackConstants.kbUpwardStrength = Original.Y * (Knockback.Y / 100)
			else
                Bedwars.GetModule('knockback-util').KnockbackConstants.kbDirectionStrength = Original.X
                Bedwars.GetModule('knockback-util').KnockbackConstants.kbUpwardStrength = Original.Y
            end
		end
	})
	Velocity:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 100,
		Default = 100,
		Callback = function(value)
			Knockback.X = value
            Bedwars.GetModule('knockback-util').KnockbackConstants.kbDirectionStrength = Original.X * (Knockback.X / 100)
		end
	})
	Velocity:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 100,
		Default = 100,
		Callback = function(value)
			Knockback.Y = value
            Bedwars.GetModule('knockback-util').KnockbackConstants.kbUpwardStrength = Original.Y * (Knockback.Y / 100)
		end
	})
end)

task.defer(function()
	Team = Sections.Misc:CreateToggle({
		Name = 'Team',
		Callback = function(callback)
		end
	})
end)

local Shutdown
task.defer(function()
	Shutdown = Sections.Misc:CreateToggle({
		Name = 'Shutdown',
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				Core:Uninject()
			end
		end
	})
end)
