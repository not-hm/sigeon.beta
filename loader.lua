repeat task.wait() until game:IsLoaded()
local Utility = loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/libraries/universal.lua'))()
local Experience = {139566161526375, 71480482338212, 6872265039}

for _, v in pairs(Experience) do
    local Status, Id = Utility.Misc.GetId(v)
    if not Status then continue end
	loadstring(game:HttpGet('https://raw.githubusercontent.com/not-hm/sigeon.beta/refs/heads/main/games/' .. Id .. '.lua'))()
end