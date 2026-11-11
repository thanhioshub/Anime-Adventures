-- Thanh Hub V3 | Anime Adventures | Delta / LDPlayer
-- GUI and configuration only. No unverified game automation.
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
if not player then warn("[Thanh Hub] LocalPlayer unavailable") return end
local parent = player:WaitForChild("PlayerGui", 15)
if not parent then warn("[Thanh Hub] PlayerGui unavailable") return end
local old = parent:FindFirstChild("ThanhHubV3")
if old then old:Destroy() end
local connections = {}
local function connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(connections, c)
    return c
end
local gui = Instance.new("ScreenGui")
gui.Name = "ThanhHubV3"
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
local C = {bg=Color3.fromRGB(20,23,33), panel=Color3.fromRGB(32,37,53), accent=Color3.fromRGB(106,126,255), text=Color3.fromRGB(242,244,255), muted=Color3.fromRGB(183,190,209)}
local window = make("Frame", {Name="Window",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(390,320),BackgroundColor3=C.bg,BorderSizePixel=0},gui)
make("UICorner",{CornerRadius=UDim.new(0,12)},window)
make("UIStroke",{Color=C.accent,Thickness=1},window)
make("UISizeConstraint",{MinSize=Vector2.new(280,240),MaxSize=Vector2.new(390,320)},window)
local scale = make("UIScale",{Scale=1},window)
local function resize()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(800,600)
    scale.Scale = math.clamp(math.min((viewport.X-30)/390,(viewport.Y-65)/320),.65,1)
end
resize()
local cameraConn
local function watchCamera()
    if cameraConn then cameraConn:Disconnect() end
    if workspace.CurrentCamera then cameraConn = connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),resize) end
    resize()
end
watchCamera()
connect(workspace:GetPropertyChangedSignal("CurrentCamera"),watchCamera)
local top=make("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=C.panel,BorderSizePixel=0},window)
make("UICorner",{CornerRadius=UDim.new(0,12)},top)
make("TextLabel",{Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-95,1,0),BackgroundTransparency=1,Text="Thanh Hub V3 | Anime Adventures",TextColor3=C.text,TextSize=15,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},top)
local mini=make("TextButton",{Position=UDim2.new(1,-75,0,7),Size=UDim2.fromOffset(30,30),BackgroundColor3=C.bg,Text="−",TextSize=22,TextColor3=C.text},top)
local close=make("TextButton",{Position=UDim2.new(1,-38,0,7),Size=UDim2.fromOffset(30,30),BackgroundColor3=Color3.fromRGB(155,57,71),Text="×",TextSize=22,TextColor3=C.text},top)
for _,b in ipairs({mini,close}) do make("UICorner",{CornerRadius=UDim.new(0,7)},b) end
local nav=make("Frame",{Position=UDim2.fromOffset(9,52),Size=UDim2.fromOffset(100,225),BackgroundColor3=C.panel,BorderSizePixel=0},window)
make("UICorner",{CornerRadius=UDim.new(0,8)},nav)
local content=make("Frame",{Position=UDim2.fromOffset(118,52),Size=UDim2.new(1,-127,1,-94),BackgroundTransparency=1},window)
local status=make("TextLabel",{Position=UDim2.new(0,9,1,-35),Size=UDim2.new(1,-18,0,27),BackgroundColor3=C.panel,Text="GUI ready | Game automation not connected",TextColor3=C.muted,TextSize=11,TextWrapped=true,Font=Enum.Font.Gotham},window)
make("UICorner",{CornerRadius=UDim.new(0,7)},status)
local state={farm=false,place=false,upgrade=false,replay=false,skip=false}
local pages={}
local function page(name)
    local f=make("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},content)
    make("UIListLayout",{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},f)
    pages[name]=f
    return f
end
local farm=page("Farm")
local units=page("Units")
local settings=page("Settings")
local function heading(p,t)
    make("TextLabel",{Size=UDim2.new(1,-8,0,29),BackgroundTransparency=1,Text=t,TextColor3=C.text,TextSize=15,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},p)
end
local buttons={}
local function toggle(p,key,label)
    local b=make("TextButton",{Size=UDim2.new(1,-8,0,40),BackgroundColor3=C.panel,TextColor3=C.text,TextSize=12,Font=Enum.Font.GothamMedium,Text=label.." [OFF]"},p)
    make("UICorner",{CornerRadius=UDim.new(0,8)},b)
    buttons[key]={button=b,label=label}
    connect(b.MouseButton1Click,function()
        state[key]=not state[key]
        b.Text=label..(state[key] and " [ON]" or " [OFF]")
        b.BackgroundColor3=state[key] and Color3.fromRGB(49,63,106) or C.panel
        status.Text=label.." configured | No gameplay action implemented"
    end)
end
heading(farm,"Farm controls")
toggle(farm,"farm","Auto Farm")
toggle(farm,"replay","Auto Replay")
toggle(farm,"skip","Auto Skip Wave")
heading(units,"Unit controls")
toggle(units,"place","Auto Place Unit")
toggle(units,"upgrade","Auto Upgrade Unit")
heading(settings,"Settings & diagnostics")
local info=make("TextLabel",{Size=UDim2.new(1,-8,0,100),BackgroundColor3=C.panel,TextColor3=C.text,TextSize=12,TextWrapped=true,Font=Enum.Font.Gotham,Text="V3 GUI prototype. Auto buttons are configuration switches only. No farming, placement, upgrades, replay or wave skipping is implemented. Settings persist only while this GUI is running."},settings)
make("UICorner",{CornerRadius=UDim.new(0,8)},info)
local reset=make("TextButton",{Size=UDim2.new(1,-8,0,38),BackgroundColor3=C.panel,TextColor3=C.text,TextSize=12,Text="Reset switches",Font=Enum.Font.GothamBold},settings)
make("UICorner",{CornerRadius=UDim.new(0,8)},reset)
connect(reset.MouseButton1Click,function()
    for key, entry in pairs(buttons) do
        state[key]=false
        entry.button.Text=entry.label.." [OFF]"
        entry.button.BackgroundColor3=C.panel
    end
    status.Text="All switches reset"
end)
local function show(name)
    for k,p in pairs(pages) do p.Visible=(k==name) end
end
for i,name in ipairs({"Farm","Units","Settings"}) do
    local b=make("TextButton",{Position=UDim2.fromOffset(7,8+(i-1)*49),Size=UDim2.new(1,-14,0,40),BackgroundColor3=C.bg,TextColor3=C.text,Text=name,TextSize=13,Font=Enum.Font.GothamBold},nav)
    make("UICorner",{CornerRadius=UDim.new(0,7)},b)
    connect(b.MouseButton1Click,function() show(name) end)
end
show("Farm")
local collapsed=false
connect(mini.MouseButton1Click,function()
    collapsed=not collapsed
    nav.Visible=not collapsed
    content.Visible=not collapsed
    status.Visible=not collapsed
    window.Size=collapsed and UDim2.fromOffset(390,44) or UDim2.fromOffset(390,320)
end)
local dragging=false
local startInput, startWindow, dragType
connect(top.InputBegan,function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragType=input.UserInputType
        startInput=input.Position
        startWindow=window.Position
        connect(input.Changed,function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
connect(UIS.InputChanged,function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) and (dragType==Enum.UserInputType.MouseButton1 or input.UserInputType==dragType) then
        local delta=input.Position-startInput
        window.Position=UDim2.new(startWindow.X.Scale,startWindow.X.Offset+delta.X,startWindow.Y.Scale,startWindow.Y.Offset+delta.Y)
    end
end)
local function shutdown()
    for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    gui:Destroy()
end
connect(close.MouseButton1Click,shutdown)
print("[Thanh Hub V3] GUI created successfully (automation not connected)")
pcall(function() StarterGui:SetCore("SendNotification",{Title="Thanh Hub V3",Text="GUI loaded successfully",Duration=4}) end)
