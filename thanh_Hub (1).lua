-- Thanh Hub V2.1 | Anime Adventures | GUI prototype
-- UI only: no game automation or unverified remote calls.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local StarterGui = game:GetService('StarterGui')
local player = Players.LocalPlayer
if not player then warn('[Thanh Hub] LocalPlayer unavailable'); return end
local parent = player:WaitForChild('PlayerGui', 15)
if not parent then warn('[Thanh Hub] PlayerGui unavailable'); return end
local previous = parent:FindFirstChild('ThanhHubV2')
if previous then previous:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name = 'ThanhHubV2'
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 100
gui.Parent = parent

local function make(class, props, owner)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = owner
    return obj
end
local bg = Color3.fromRGB(22,25,35)
local panel = Color3.fromRGB(32,36,49)
local accent = Color3.fromRGB(95,118,255)
local white = Color3.fromRGB(238,240,250)
local muted = Color3.fromRGB(180,188,210)
local frame = make('Frame', {
    Name='Window', AnchorPoint=Vector2.new(.5,.5),
    Position=UDim2.fromScale(.5,.5), Size=UDim2.fromOffset(400,320),
    BackgroundColor3=bg, BorderSizePixel=0
}, gui)
make('UISizeConstraint', {MaxSize=Vector2.new(400,320),MinSize=Vector2.new(280,240)},frame)
make('UICorner',{CornerRadius=UDim.new(0,12)},frame)
make('UIStroke',{Color=Color3.fromRGB(66,72,96),Thickness=1},frame)
local top = make('Frame',{Name='Header',Size=UDim2.new(1,0,0,44),BackgroundColor3=panel,BorderSizePixel=0},frame)
make('UICorner',{CornerRadius=UDim.new(0,12)},top)
make('TextLabel',{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-95,1,0),BackgroundTransparency=1,
    Text='Thanh Hub V2.1',TextColor3=white,TextSize=17,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left},top)
local minimize=make('TextButton',{Position=UDim2.new(1,-76,0,7),Size=UDim2.fromOffset(30,30),
    BackgroundColor3=bg,Text='−',TextColor3=white,TextSize=22},top)
local close=make('TextButton',{Position=UDim2.new(1,-40,0,7),Size=UDim2.fromOffset(30,30),
    BackgroundColor3=Color3.fromRGB(140,58,68),Text='×',TextColor3=white,TextSize=22},top)
for _,b in ipairs({minimize,close}) do make('UICorner',{CornerRadius=UDim.new(0,7)},b) end
local nav=make('Frame',{Position=UDim2.fromOffset(9,53),Size=UDim2.new(0,102,1,-96),
    BackgroundColor3=panel,BorderSizePixel=0},frame)
make('UICorner',{CornerRadius=UDim.new(0,9)},nav)
local content=make('Frame',{Position=UDim2.fromOffset(120,53),Size=UDim2.new(1,-129,1,-96),BackgroundTransparency=1},frame)
local status=make('TextLabel',{Position=UDim2.new(0,9,1,-36),Size=UDim2.new(1,-18,0,28),
    BackgroundColor3=panel,TextColor3=muted,TextSize=11,Font=Enum.Font.Gotham,
    Text='GUI ready | Automation not connected',TextWrapped=true},frame)
make('UICorner',{CornerRadius=UDim.new(0,7)},status)
local pages={}
local function createPage(name)
    local p=make('ScrollingFrame',{Name=name,Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},content)
    make('UIListLayout',{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},p)
    pages[name]=p
    return p
end
local farm=createPage('Farm')
local units=createPage('Units')
local settings=createPage('Settings')
local function heading(owner,label)
    make('TextLabel',{Size=UDim2.new(1,-7,0,30),BackgroundTransparency=1,
        Text=label,TextColor3=white,TextSize=15,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left},owner)
end
local switches={}
local function toggle(owner,key,label)
    local b=make('TextButton',{Size=UDim2.new(1,-8,0,40),BackgroundColor3=panel,
        TextColor3=white,Font=Enum.Font.GothamMedium,TextSize=12,Text=label..'  [OFF]'},owner)
    make('UICorner',{CornerRadius=UDim.new(0,8)},b)
    switches[key]=false
    b.MouseButton1Click:Connect(function()
        switches[key]=not switches[key]
        b.Text=label..(switches[key] and '  [ON]' or '  [OFF]')
        b.BackgroundColor3=switches[key] and accent or panel
        status.Text=label..' selected | Automation NOT connected'
    end)
end
heading(farm,'Farm Controls')
toggle(farm,'farm','Auto Farm')
toggle(farm,'replay','Auto Replay')
toggle(farm,'skip','Auto Skip Wave')
heading(units,'Unit Controls')
toggle(units,'place','Auto Place Unit')
toggle(units,'upgrade','Auto Upgrade Unit')
heading(settings,'Information')
make('TextLabel',{Size=UDim2.new(1,-8,0,130),BackgroundColor3=panel,
    TextColor3=white,TextWrapped=true,TextSize=12,Font=Enum.Font.Gotham,
    Text='Thanh Hub V2.1 is a GUI prototype. ON/OFF only changes the interface. Auto Farm, Place, Upgrade, Replay and Skip Wave require verified game APIs and are not implemented.'},settings)
local function show(name)
    for n,p in pairs(pages) do p.Visible=(n==name) end
end
for i,name in ipairs({'Farm','Units','Settings'}) do
    local b=make('TextButton',{Position=UDim2.fromOffset(6,7+(i-1)*47),
        Size=UDim2.new(1,-12,0,39),BackgroundColor3=bg,TextColor3=white,
        Text=name,Font=Enum.Font.GothamBold,TextSize=13},nav)
    make('UICorner',{CornerRadius=UDim.new(0,7)},b)
    b.MouseButton1Click:Connect(function() show(name) end)
end
show('Farm')
local expanded=true
minimize.MouseButton1Click:Connect(function()
    expanded=not expanded
    nav.Visible=expanded
    content.Visible=expanded
    status.Visible=expanded
    frame.Size=expanded and UDim2.fromOffset(400,320) or UDim2.fromOffset(400,44)
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
-- Drag header with mouse or touch, but do not start dragging on header buttons.
local dragging=false
local dragInput=nil
local startPos=nil
local startFrame=nil
top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragInput=input
        startPos=input.Position
        startFrame=frame.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
local changeConnection
changeConnection=UIS.InputChanged:Connect(function(input)
    if not gui.Parent then
        if changeConnection then changeConnection:Disconnect() end
        return
    end
    if dragging and startPos and startFrame and
        (input==dragInput or (dragInput and dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then
        local d=input.Position-startPos
        frame.Position=UDim2.new(startFrame.X.Scale,startFrame.X.Offset+d.X,startFrame.Y.Scale,startFrame.Y.Offset+d.Y)
    end
end)
-- Scale to fit LDPlayer's smaller windows without clipping.
local camera=workspace.CurrentCamera
local function fit()
    camera=workspace.CurrentCamera
    if not camera then return end
    local view=camera.ViewportSize
    local w=math.max(280,math.min(400,view.X-20))
    local h=math.max(240,math.min(320,view.Y-35))
    if expanded then frame.Size=UDim2.fromOffset(w,h) end
end
fit()
if camera then camera:GetPropertyChangedSignal('ViewportSize'):Connect(fit) end
print('[Thanh Hub V2.1] GUI created successfully')
pcall(function()
    StarterGui:SetCore('SendNotification',{Title='Thanh Hub V2.1',Text='GUI da khoi tao!',Duration=4})
end)
