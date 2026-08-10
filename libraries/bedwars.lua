local cloneref = cloneref or function(obj) return obj end
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local Players = cloneref(game:GetService('Players'))
local LocalPlayer = Players.LocalPlayer

local Collected = {}
local node_modules = ReplicatedStorage:WaitForChild('rbxts_include'):WaitForChild('node_modules')
local easy_games = node_modules:WaitForChild('@easy-games')
local knit_module = easy_games:WaitForChild('knit'):WaitForChild('src'):WaitForChild('Knit'):WaitForChild('KnitClient')
local Modules = ReplicatedStorage:WaitForChild('Modules')
local TS = ReplicatedStorage:WaitForChild('TS')
local KnitClient = require(knit_module)

local function Collect(class, obj)
    if type(obj) ~= 'table' then return end
    Collected[class] = Collected[class] or {}
    Collected[class].Result = obj
    Collected[class].Functions = Collected[class].Functions or {}
    Collected[class].Tables = Collected[class].Tables or {}
    for i, v in pairs(obj) do
        if type(v) == 'function' then
            Collected[class].Functions[tostring(i)] = v
        elseif type(v) == 'table' then
            Collected[class].Tables[tostring(i)] = v
        end
    end
    local ok, mt = pcall(getmetatable, obj)
    if ok and type(mt) == 'table' then
        local index = mt['__index']
        if type(index) == 'table' then
            for i, v in pairs(index) do
                if type(v) == 'function' then
                    Collected[class].Functions[tostring(i)] = v
                elseif type(v) == 'table' then
                    Collected[class].Tables[tostring(i)] = v
                end
            end
        end
    end
    return Collected[class]
end

local function Scan(folder, parent)
    parent = parent or ''
    for _, v in ipairs(folder:GetChildren()) do
        local path = parent == '' and v.Name or parent .. '.' .. v.Name
        if v:IsA('ModuleScript') then
            local ok, res = pcall(require, v)
            if ok then
                Collected[path] = Collected[path] or {
                    Result = res,
                    Functions = {},
                    Tables = {}
                }

                Collected[path].Result = res
                if type(res) == 'table' then
                    for _, x in pairs(res) do
                        if type(x) == 'table' then
                            Collect(path, x)
                        end
                    end
                    Collect(path, res)
                end
                Scan(v, path)
            end
        elseif v:IsA('Folder') or v:IsA('Configuration') then
            Scan(v, path)
        end
    end
end

Scan(TS)
Scan(Modules)
Scan(node_modules)
local Bedwars = {}
Bedwars.GetController = function(name, debug) --// PlayerScripts
    if not debug then debug = false end
    local ok, res = pcall(function()
        return KnitClient.GetController(name)
    end)
    if ok and res then
        for i, v in pairs(res) do
            if type(v) == 'function' then
                if debug then
                    print(i, 'function')
                end
            end
        end
        local mt = getmetatable(res)
        if mt and type(mt.__index) == 'table' then
            for i, v in pairs(mt.__index) do
                if type(v) == 'function' then
                    if debug then
                        print(i, 'function')
                    end
                    if res[i] == nil then
                        res[i] = v
                    end
                end
            end
        end
        return res
    else
        warn('[bw_dumper]: unable to find ' .. tostring(name))
        return nil
    end
end
Bedwars.GetModule = function(name) --// ReplicatedStorage
    local result = Collected[name]
    if not result then
        local found
        for path, data in pairs(Collected) do
            if path:sub(-#name - 1) == '.' .. name then
                if found then
                    warn('[bw_dumper]: unsure result for ' .. tostring(name))
                    return nil
                end
                found = data
            end
        end
        result = found
    end
    if not result then
        warn('[bw_dumper]: unable to find ' .. tostring(name))
        return nil
    end
    if type(result.Result) == 'function' then
        return result.Result
    end
    if type(result.Result) == 'table' then
        for i, v in pairs(result.Functions) do
            if result.Result[i] == nil then
                result.Result[i] = v
            end
        end
        return result.Result
    end
    return result.Functions
end

Bedwars.GetUI = function()
    if LocalPlayer.PlayerGui:FindFirstChild('ItemShop') then return true end
    if LocalPlayer.PlayerGui:FindFirstChild('ChestApp') then return true end
	if LocalPlayer.PlayerGui:FindFirstChild('InventoryApp') then return true end
	if LocalPlayer.PlayerGui:FindFirstChild('TeamUpgradeApp') then return true end
    if LocalPlayer.PlayerGui:FindFirstChild('EnchantTable') then return true end
	return false
end

Bedwars.GetPos = function(pos)
    return Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
end

return Bedwars