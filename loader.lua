repeat task.wait() until game:IsLoaded()
local Utility = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/libraries/universal.lua'))()
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

-- Ensure PlayerGui (and try to wait briefly for the common MainGui) so game scripts that index PlayerGui don't error immediately
repeat task.wait() until LocalPlayer and LocalPlayer:FindFirstChild('PlayerGui')
pcall(function() LocalPlayer.PlayerGui:WaitForChild('MainGui', 5) end)

local Experience = {139566161526375, 71480482338212, 6872265039}

for _, v in pairs(Experience) do
    local Status, Id = Utility.Misc.GetId(v)
    if not Status then continue end

    local ok, err = pcall(function()
        local chunk = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/games/' .. Id .. '.lua'))
        if chunk then
            chunk()
        end
    end)

    if not ok then
        warn(('sigeon.loader: failed to load %s - %s'):format(tostring(Id), tostring(err)))
    end
end
