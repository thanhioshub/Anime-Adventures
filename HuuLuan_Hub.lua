-- HuuLuan Hub V1 - Anime Adventures
-- Rayfield-style UI shell. Does not automate gameplay.
-- Use only code you trust. Designed for executor environments supporting loadstring and HttpGet.

local Players = game:GetService('Players')
local player = Players.LocalPlayer
if not player then return end

local old = player:WaitForChild('PlayerGui'):FindFirstChild('HuuLuanHub')
if old then old:Destroy() end

local gui = Instance.new('ScreenGui')
gui.Name = 'HuuLuanHub'
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local main = Instance.new('Frame')
main.Name = 'Main'
main.Size = UDim2.fromOffset(340, 365)
main.Position = UDim2.new(0.5, -170, 0.5, -182)
main.BackgroundColor3 = Color3.fromRGB(23, 26, 34)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new('UICorner', main).CornerRadius = UDim.new(0, 12)

local function label(parent, text, pos, size, fontSize)
    local t = Instance.new('TextLabel')
    t.BackgroundTransparency = 1
    t.Position = pos
    t.Size = size
    t.Text = text
    t.TextColor3 = Color3.fromRGB(238, 240, 247)
    t.TextSize = fontSize or 15
    t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end
label(main, 'HuuLuan Hub  |  Anime Adventures', UDim2.fromOffset(14, 9), UDim2.fromOffset(285, 35), 16)

local close = Instance.new('TextButton')
close.Text = 'X'
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -38, 0, 11)
close.BackgroundColor3 = Color3.fromRGB(65, 70, 83)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main
Instance.new('UICorner', close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local tabBar = Instance.new('Frame')
tabBar.Position = UDim2.fromOffset(12, 52)
tabBar.Size = UDim2.new(1, -24, 0, 36)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main
local tabLayout = Instance.new('UIListLayout', tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 7)

local content = Instance.new('Frame')
content.Position = UDim2.fromOffset(12, 99)
content.Size = UDim2.new(1, -24, 1, -147)
content.BackgroundTransparency = 1
content.Parent = main

local status = label(main, 'Ready | GUI demo only', UDim2.fromOffset(14, 331), UDim2.new(1, -28, 0, 24), 12)
status.TextColor3 = Color3.fromRGB(170, 185, 207)

local states = { AutoFarm=false, AutoReplay=false, AutoSkipWave=false, AutoPlace=false, AutoUpgrade=false }
local pages = {}
local function page(name)
    local frame = Instance.new('Frame')
    frame.Name = name
    frame.Size = UDim2.fromScale(1,1)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = content
    local layout = Instance.new('UIListLayout', frame)
    layout.Padding = UDim.new(0, 8)
    pages[name] = frame
    return frame
end
local farm, units, settings = page('Farm'), page('Units'), page('Settings')

local function toggle(parent, title, key)
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1,0,0,42)
    btn.BackgroundColor3 = Color3.fromRGB(37, 42, 54)
    btn.TextColor3 = Color3.fromRGB(240, 241, 245)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new('UICorner', btn).CornerRadius = UDim.new(0,8)
    local function redraw() btn.Text = title .. '    [' .. (states[key] and 'ON' or 'OFF') .. ']' end
    redraw()
    btn.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        redraw()
        status.Text = title .. ': ' .. (states[key] and 'ON' or 'OFF') .. ' (demo only)'
        -- Add verified game-specific implementation here.
    end)
end

toggle(farm, 'Auto Farm', 'AutoFarm')
toggle(farm, 'Auto Replay', 'AutoReplay')
toggle(farm, 'Auto Skip Wave', 'AutoSkipWave')
toggle(units, 'Auto Place Unit', 'AutoPlace')
toggle(units, 'Auto Upgrade Unit', 'AutoUpgrade')
label(settings, 'HuuLuan Hub V1', UDim2.fromOffset(4,8), UDim2.new(1,-8,0,28), 17)
label(settings, 'GUI demo. No game remotes are called.', UDim2.fromOffset(4,45), UDim2.new(1,-8,0,26), 12)
label(settings, 'Only run scripts from sources you trust.', UDim2.fromOffset(4,77), UDim2.new(1,-8,0,26), 12)

local function selectPage(name)
    for key, frame in pairs(pages) do frame.Visible = (key == name) end
end
for _, name in ipairs({'Farm','Units','Settings'}) do
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(0, 99, 1, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(50, 59, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = tabBar
    Instance.new('UICorner',btn).CornerRadius = UDim.new(0,7)
    btn.MouseButton1Click:Connect(function() selectPage(name) end)
end
selectPage('Farm')
