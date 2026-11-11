-- Thanh Hub V2 | Anime Adventures | GUI shell
-- This file does not automate gameplay or call unverified game remotes.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local player = Players.LocalPlayer
if not player then return end
local parent = (gethui and gethui()) or player:WaitForChild('PlayerGui')
local old = parent:FindFirstChild('ThanhHubV2')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name = 'ThanhHubV2'; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.Parent = parent
local function new(class, props, holder)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = holder
    return obj
end
local bg = Color3.fromRGB(22,25,35)
local panel = Color3.fromRGB(32,36,49)
local accent = Color3.fromRGB(95,118,255)
local white = Color3.fromRGB(238,240,250)
local frame = new('Frame', {Name='Window', Size=UDim2.fromOffset(440,350), Position=UDim2.new(.5,-220,.5,-175), BackgroundColor=bg, BorderSizePixel=0}, gui)
new('UICorner',{CornerRadius=UDim.new(0,12)},frame)
new('UIStroke',{Color=Color3.fromRGB(66,72,96),Thickness=1},frame)
local top = new('Frame',{Size=UDim2.new(1,0,0,48),BackgroundColor=panel,BorderSizePixel=0},frame)
new('UICorner',{CornerRadius=UDim.new(0,12)},top)
new('TextLabel',{Size=UDim2.new(1,-105,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text='Thanh Hub V2  |  Anime Adventures',TextColor3=white,TextSize=17,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},top)
local minimize = new('TextButton',{Size=UDim2.fromOffset(35,30),Position=UDim2.new(1,-80,0,9),Text='−',TextSize=23,TextColor3=white,BackgroundColor=bg},top)
local close = new('TextButton',{Size=UDim2.fromOffset(35,30),Position=UDim2.new(1,-40,0,9),Text='×',TextSize=23,TextColor3=white,BackgroundColor=Color3.fromRGB(137,55,66)},top)
for _,b in ipairs({minimize,close}) do new('UICorner',{CornerRadius=UDim.new(0,7)},b) end
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local nav = new('Frame',{Position=UDim2.fromOffset(10,58),Size=UDim2.fromOffset(115,242),BackgroundColor=panel,BorderSizePixel=0},frame)
new('UICorner',{CornerRadius=UDim.new(0,9)},nav)
local content = new('Frame',{Position=UDim2.fromOffset(135,58),Size=UDim2.new(1,-145,1,-108),BackgroundTransparency=1},frame)
local status = new('TextLabel',{Position=UDim2.new(0,12,1,-40),Size=UDim2.new(1,-24,0,30),BackgroundColor=panel,TextColor=white,TextSize=11,Font=Enum.Font.Gotham,Text='V2 GUI ready | Automation not connected',TextWrapped=true},frame)
new('UICorner',{CornerRadius=UDim.new(0,7)},status)
local pages = {}
local function page(name)
    local f = new('ScrollingFrame',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ScrollBarThickness=3,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},content)
    new('UIListLayout',{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},f)
    pages[name]=f
    return f
end
local farm=page('Farm'); local units=page('Units'); local settings=page('Settings')
local function heading(parent,text)
    new('TextLabel',{Size=UDim2.new(1,-5,0,34),BackgroundTransparency=1,Text=text,TextColor=white,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},parent)
end
local toggles = {}
local function toggle(parent,key,label)
    local button = new('TextButton',{Size=UDim2.new(1,-8,0,43),BackgroundColor=panel,TextColor=white,Font=Enum.Font.GothamMedium,TextSize=13,Text=label..'  [OFF]',TextXAlignment=Enum.TextXAlignment.Center},parent)
    new('UICorner',{CornerRadius=UDim.new(0,8)},button)
    toggles[key]=false
    button.MouseButton1Click:Connect(function()
        toggles[key]=not toggles[key]
        button.Text=label..(toggles[key] and '  [ON]' or '  [OFF]')
        status.Text=label..' selected; game automation is NOT connected'
    end)
end
heading(farm,'Farm Controls')
toggle(farm,'farm','Auto Farm')
toggle(farm,'replay','Auto Replay')
toggle(farm,'skip','Auto Skip Wave')
heading(units,'Unit Controls')
toggle(units,'place','Auto Place Unit')
toggle(units,'upgrade','Auto Upgrade Unit')
heading(settings,'Settings & Info')
new('TextLabel',{Size=UDim2.new(1,-8,0,105),BackgroundColor=panel,TextColor=white,TextWrapped=true,TextSize=13,Font=Enum.Font.Gotham,Text='Thanh Hub V2 is a GUI prototype. Toggles save only in this session. No unit placement, upgrades, replay, wave skip, or farming actions are implemented. Verify game APIs before connecting automation.'},settings)
local function show(name)
    for k,p in pairs(pages) do p.Visible=(k==name) end
end
for i,name in ipairs({'Farm','Units','Settings'}) do
    local b = new('TextButton',{Position=UDim2.fromOffset(7,8+(i-1)*51),Size=UDim2.new(1,-14,0,43),BackgroundColor=bg,TextColor=white,Text=name,Font=Enum.Font.GothamBold,TextSize=14},nav)
    new('UICorner',{CornerRadius=UDim.new(0,7)},b)
    b.MouseButton1Click:Connect(function() show(name) end)
end
show('Farm')
local collapsed=false
minimize.MouseButton1Click:Connect(function()
    collapsed=not collapsed
    nav.Visible=not collapsed; content.Visible=not collapsed; status.Visible=not collapsed
    frame.Size=collapsed and UDim2.fromOffset(440,48) or UDim2.fromOffset(440,350)
end)
local dragging=false; local startPos; local framePos
local function begin(input)
    dragging=true; startPos=input.Position; framePos=frame.Position
end
top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        begin(input)
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-startPos
        frame.Position=UDim2.new(framePos.X.Scale,framePos.X.Offset+delta.X,framePos.Y.Scale,framePos.Y.Offset+delta.Y)
    end
end)
