-- ULTRA FISH SPAMMER - PURE ROBLOX GUI (GAK PERNAH ILANG!)
if _G.FishScreen then _G.FishScreen:Destroy() end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Bikin ScreenGui
local screen = Instance.new("ScreenGui")
screen.Name = "UltraFishGUI"
screen.ResetOnSpawn = false
screen.Parent = pgui

-- Frame utama (bisa digeser)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 320)
frame.Position = UDim2.new(0.5, -200, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 100, 100)
frame.Active = true
frame.Draggable = true  -- BISA DIGESER PAKE JARI/MOUSE
frame.Parent = screen

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
title.Text = "ULTRA FISH SPAMMER v6"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 50)
status.BackgroundTransparency = 1
status.Text = "Status: OFFLINE"
status.TextColor3 = Color3.fromRGB(255, 100, 100)
status.Font = Enum.Font.GothamBold
status.TextSize = 18
status.Parent = frame

-- Slider jumlah loop (pake TextBox soalnya gampang)
local loopLabel = Instance.new("TextLabel")
loopLabel.Size = UDim2.new(1, -20, 0, 30)
loopLabel.Position = UDim2.new(0, 10, 0, 90)
loopLabel.BackgroundTransparency = 1
loopLabel.Text = "Jumlah Loop: 200"
loopLabel.TextColor3 = Color3.new(1,1,1)
loopLabel.Font = Enum.Font.Gotham
loopLabel.Parent = frame

local loopBox = Instance.new("TextBox")
loopBox.Size = UDim2.new(0, 100, 0, 30)
loopBox.Position = UDim2.new(0, 280, 0, 90)
loopBox.Text = "200"
loopBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
loopBox.TextColor3 = Color3.new(1,1,1)
loopBox.Parent = frame

-- Remote stuff
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local RF_Charge = net:WaitForChild("RF/ChargeFishingRod")
local RF_Start = net:WaitForChild("RF/RequestFishingMinigameStarted")
local RE_Complete = net:WaitForChild("RE/FishingCompleted")
local args = { -0.5718746185302734, 0.9508609374809511, 1764814604.223853 }

_G.FishRun = false
_G.Threads = {}

-- START BUTTON
local start = Instance.new("TextButton")
start.Size = UDim2.new(0, 350, 0, 50)
start.Position = UDim2.new(0, 25, 0, 140)
start.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
start.Text = "START ROKET FISHING"
start.TextColor3 = Color3.new(1,1,1)
start.Font = Enum.Font.GothamBold
start.TextSize = 20
start.Parent = frame

start.MouseButton1Click:Connect(function()
    if _G.FishRun then return end
    local num = tonumber(loopBox.Text) or 200
    if num < 10 then num = 10 end
    if num > 1000 then num = 1000 end
    
    _G.FishRun = true
    status.Text = "Status: ONLINE → "..num.."x loops"
    status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    for i = 1, num do
        local t = task.spawn(function()
            while _G.FishRun do
                pcall(RF_Charge.InvokeServer, RF_Charge)
                pcall(RF_Start.InvokeServer, RF_Start, unpack(args))
                pcall(RE_Complete.FireServer, RE_Complete)
            end
        end)
        table.insert(_G.Threads, t)
    end
end)

-- STOP BUTTON
local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0, 350, 0, 50)
stop.Position = UDim2.new(0, 25, 0, 200)
stop.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
stop.Text = "STOP SEMUA"
stop.TextColor3 = Color3.new(1,1,1)
stop.Font = Enum.Font.GothamBold
stop.TextSize = 20
stop.Parent = frame

stop.MouseButton1Click:Connect(function()
    _G.FishRun = false
    for _, t in ipairs(_G.Threads) do task.cancel(t) end
    _G.Threads = {}
    status.Text = "Status: OFFLINE"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

-- HIDE/SHOW BUTTON (selalu muncul di pojok kiri atas)
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggle.Text = "SHOW GUI"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.Visible = false
toggle.Parent = screen

toggle.MouseButton1Click:Connect(function()
    frame.Visible = true
    toggle.Visible = false
end)

-- Tombol Hide di dalam frame
local hide = Instance.new("TextButton")
hide.Size = UDim2.new(0, 100, 0, 30)
hide.Position = UDim2.new(1, -110, 0, 5)
hide.BackgroundColor3 = Color3.fromRGB(100,100,100)
hide.Text = "HIDE"
hide.TextColor3 = Color3.new(1,1,1)
hide.Parent = frame

hide.MouseButton1Click:Connect(function()
    frame.Visible = false
    toggle.Visible = true
end)

_G.FishScreen = screen
print("GUI MUNcul! Geser pake jari/mouse, klik HIDE → klik SHOW GUI di pojok kiri atas buat balikin")