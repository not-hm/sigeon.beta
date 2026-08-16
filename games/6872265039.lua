--// IDC IF I USE TASK.DEFER ALOT
repeat task.wait() until game:IsLoaded() and workspace.CurrentCamera
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/library.lua'))()
local Utility = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/libraries/universal.lua'))()
local Bedwars = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/libraries/bedwars.lua'))()
local cloneref = cloneref or function(obj) return obj end
local firesignal = firesignal or function(obj) return obj end

local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local UserInputService = cloneref(game:GetService('UserInputService'))
local TweenService = cloneref(game:GetService('TweenService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Team, AntiBot
local Core = Library:Initialize()
local Sections = {
	Combat = Core:CreateSection(1, UDim2.new(0, 0, 2, -150)),
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
					if Bedwars.GetUI() then return end
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						local Entity = Utility.Entity.Get.Distance(Distances, 'Angle', AntiBot.Enabled, Team.Enabled, true, 120)
						if Entity then
							if ToolCheck and not Utility.Entity.Inventory.Character.Get() then return end
							local FinalPos = Entity.PrimaryPart.Position + (Entity.PrimaryPart.AssemblyLinearVelocity * Prediction)
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
					local HandItem = Bedwars.GetController('SwordController'):getHandItem()
                    local Inventory = Bedwars.GetModule('inventory-util').getInventory(LocalPlayer)
					local Hand = Inventory and Inventory.hand
					
					local Tool
					if HandItem and HandItem.tool then
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

local SilentAura
task.defer(function()
    local Attacked, Swinged, AttackDelay, SwingDelay, Synced
	local StartRotate, StartSwing, StartAttack
	local Direction, Silent

	SilentAura = Sections.Combat:CreateToggle({
		Name = 'Silent Aura',
		Callback = function(callback)
			if callback then
                Swinged, Attacked = false, false
				Utility.Misc.Events.Add('RenderStepped', 'SilentAura', nil, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					if Bedwars.GetUI() then return end
					local Tool = Bedwars.GetController('SwordController'):getHandItem().tool
					if not Tool then return end
					local Entity = 	Utility.Entity.Get.Distance(24, 'Angle', AntiBot.Enabled, Team.Enabled, true, Direction)
					if not Entity then return end
					local Distance = Utility.Entity.GetMagnitude(Entity.PrimaryPart.Position, LocalPlayer.Character.PrimaryPart.Position)
					if Distance <= StartRotate then
                        local EntityPosition = Vector3.new(Entity.PrimaryPart.Position.X, LocalPlayer.Character.PrimaryPart.Position.Y, Entity.PrimaryPart.Position.Z)
						local LookCFrame = CFrame.lookAt(LocalPlayer.Character.PrimaryPart.Position, EntityPosition)
						if Utility.Entity.GetPerspective() == 'First' then
							if not Silent then 
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Entity.PrimaryPart.Position)
                            end
						end
						LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(LocalPlayer.Character.PrimaryPart.Position) * LookCFrame.Rotation
					end
					if Distance <= StartSwing then
                        if not Swinged then
                            Swinged = true
                            Bedwars.GetController('SwordController'):swingSwordAtMouse()
                            if Synced then
                                task.wait(AttackDelay)
                            else
                                task.wait(SwingDelay)
                            end
                            Swinged = false
                        end
					end
                    if Distance <= StartAttack then
                        local Cooldown = Bedwars.GetController('SwordController'):getRemainingSwingCooldown(Tool.Name)
                        if Cooldown > 0 then return end
                        if not Attacked then
                            Attacked = true
                            local EntityUtil = Bedwars.GetModule('entity-util').EntityUtil:getEntity(Entity)
                            if not EntityUtil then return end
                            Bedwars.GetController('SwordController'):attackEntity(EntityUtil, (Entity.PrimaryPart.Position - workspace.CurrentCamera.CFrame.Position).Unit)
                            task.wait(AttackDelay)
                            Attacked = false
                        end
                    end
				end)
			else
				Utility.Misc.Events.Remove('RenderStepped', 'SilentAura')
                Swinged, Attacked = false, false
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
		Name = 'Swing Delay',
		Min = 0,
		Max = 50,
		Default = 5,
		Callback = function(callback)
			SwingDelay = callback / 100
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
    SilentAura:CreateSlider({
		Name = 'Attack Delay',
		Min = 0,
		Max = 50,
		Default = 5,
		Callback = function(callback)
			AttackDelay = callback / 100
		end,
	})
    SilentAura:CreateMiniToggle({
		Name = 'Synchornize',
		Callback = function(callback)
			Synced = callback
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
	local Distance, Delays
    local Activated

	TriggerBot = Sections.Combat:CreateToggle({
		Name = 'Trigger Bot',
		Callback = function(callback)
			if callback then
                Activated = false
				Utility.Misc.Events.Add('Stepped', 'TriggerBot', nil, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					if Bedwars.GetUI() then return end
					local Entity = Utility.Entity.Get.Distance(Distance, 'Angle', AntiBot.Enabled, Team.Enabled, true, 120)
					if Entity and Mouse.Target and Mouse.Target:IsDescendantOf(Entity) then
						local Tool = Bedwars.GetController('SwordController'):getHandItem()
						if not Tool then return end
						if not Activated then
                            Activated = true
                            Bedwars.GetController('SwordController'):swingSwordAtMouse()
                            task.wait(Delays)
                            Activated = false
                        end
					end
				end)
			else
				Utility.Misc.Events.Remove('Stepped', 'TriggerBot')
                Activated = false
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
    TriggerBot:CreateSlider({
		Name = 'Delay',
		Min = 0,
		Max = 50,
		Default = 26,
		Callback = function(callback)
			if callback then
				Delays = callback / 100
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

local Bridger
task.defer(function()
    Bridger = Sections.World:CreateToggle({
        Name = 'Bridger',
        Callback = function(callback)
            if callback then
                Utility.Misc.Events.Add('Heartbeat', 'Bridger', nil, function()
                    if not Utility.Entity.IsAlive(LocalPlayer) then return end
                    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    if not Humanoid then return end
                    local Direction = Vector3.new(LocalPlayer.Character.PrimaryPart.CFrame.LookVector.X, 0, LocalPlayer.Character.PrimaryPart.CFrame.LookVector.Z)
                    if Direction.Magnitude <= 0.01 then return end
                    Direction = Direction.Unit

                    local BlockPlacer = Bedwars.GetController('BlockPlacementController'):getBlockPlacer()
                    if not BlockPlacer then return end
                    local BlockEngine = Bedwars.GetModule('block-engine.out').BlockEngine
                    local PlacePosition = Bedwars.GetPos(LocalPlayer.Character.PrimaryPart.Position + Direction - Vector3.yAxis * (LocalPlayer.Character.PrimaryPart.Size.Y / 2 + Humanoid.HipHeight + 1.5))
                    local BlockPosition = BlockEngine:getBlockPosition(PlacePosition - Direction)

                    local BlockAt = BlockEngine:getStore():getBlockAt(BlockPosition)
                    if not BlockAt then return end
                    local FinalPos = BlockPosition + Direction
                    BlockPlacer:placeBlock(FinalPos, {
                        target = {
                            blockInstance = BlockAt,
                            blockRef = {
                                blockPosition = BlockPosition
                            },
                            hitPosition = BlockPosition + Direction,
                            hitNormal = Direction
                        },
                        placementPosition = FinalPos
                    })
                end)
            else
                Utility.Misc.Events.Remove('Heartbeat', 'Bridger')
            end
        end
    })
end)

local Stealer
task.defer(function()
	local Stealing = false

	Stealer = Sections.World:CreateToggle({
		Name = 'Stealer',
		Callback = function(callback)
			if callback then
				Stealing = false
				Utility.Misc.Events.Add('Stepped', 'Stealer', nil, function()
					if not Utility.Entity.IsAlive(LocalPlayer) then return end
					local ChestApp = LocalPlayer.PlayerGui:FindFirstChild('ChestApp')
					if not ChestApp then return end
					local ChestContainer = ChestApp['2']['1']['3']['2']['4']['1']
					if not ChestContainer then return end
					for _, v in ChestContainer:GetDescendants() do
						if v:IsA('Frame') and v.Name == 'TooltipInterest' and v.Parent:IsA('ImageButton') then
							if not Stealing then
								Stealing = true
								firesignal(v.Parent.MouseButton1Click)
								task.wait(math.random(10, 40) / 100)
								Stealing = false
							end
						end
					end
				end)
			else
				Utility.Misc.Events.Remove('Stepped', 'Stealer')
				Stealing = false
			end
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

task.defer(function()
	AntiBot = Sections.Misc:CreateToggle({
		Name = 'Anti Bot',
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

Core:CreateNotification('sigeon.pex', 'loaded!', 3)
