warn("Rain FPS Menu Loaded (Delta)")

-- ===== REQUEST FIX FOR DELTA =====
local request = request or http_request or (syn and syn.request)
if not request then
    warn("Delta: request not supported, webhook disabled until supported")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- ===== SETTINGS =====
local WEBHOOK_URL = ""
local SEND_INTERVAL = 10
local SEND_ENABLED = false

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "RainFPSMenu"
pcall(function()
    gui.Parent = CoreGui
end)

-- FPS label
local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.new(0, 150, 0, 35)
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsLabel.BackgroundTransparency = 0.2
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 20
fpsLabel.Text = "FPS: ..."

-- Menu frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0, 10, 0, 55)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Rain FPS Menu (Delta)"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local input = Instance.new("TextBox", frame)
input.Position = UDim2.new(0, 10, 0, 40)
input.Size = UDim2.new(1, -20, 0, 30)
input.PlaceholderText = "Paste Discord Webhook"
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(25,25,25)
input.TextColor3 = Color3.fromRGB(255,255,255)
input.ClearTextOnFocus = false

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Position = UDim2.new(0, 10, 0, 80)
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.Text = "Save Webhook"
saveBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
saveBtn.TextColor3 = Color3.fromRGB(0,255,0)
saveBtn.Font = Enum.Font.SourceSansBold

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.new(0, 10, 0, 120)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Text = "Send FPS: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.fromRGB(255,80,80)
toggleBtn.Font = Enum.Font.SourceSansBold

-- Buttons
saveBtn.MouseButton1Click:Connect(function()
    WEBHOOK_URL = input.Text
    saveBtn.Text = "Saved ✔"
    task.delay(1.2, function()
        saveBtn.Text = "Save Webhook"
    end)
end)

toggleBtn.MouseButton1Click:Connect(function()
    SEND_ENABLED = not SEND_ENABLED
    if SEND_ENABLED then
        toggleBtn.Text = "Send FPS: ON"
        toggleBtn.TextColor3 = Color3.fromRGB(0,255,0)
    else
        toggleBtn.Text = "Send FPS: OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255,80,80)
    end
end)

-- FPS counter
local frames, fps = 0, 60
local last = tick()
local lastSend = 0

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last >= 1 then
        fps = frames
        frames = 0
        last = tick()
        fpsLabel.Text = "FPS: " .. fps
    end

    if SEND_ENABLED and WEBHOOK_URL ~= "" and request and tick() - lastSend >= SEND_INTERVAL then
        lastSend = tick()
        pcall(function()
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "📊 FPS Roblox (Delta): " .. fps
                })
            })
        end)
    end
end)
