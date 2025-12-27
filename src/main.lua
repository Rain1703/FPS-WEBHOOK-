-- Roblox FPS Monitor & Optimizer
-- Author: Rain1703
-- Menu version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ===== SETTINGS (RUNTIME) =====
local WEBHOOK_URL = ""
local SEND_INTERVAL = 10
local SEND_ENABLED = false

-- ===== FPS OPTIMIZE =====
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "RainFPSMenu"
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== FPS LABEL =====
local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.new(0, 160, 0, 35)
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsLabel.BackgroundTransparency = 0.2
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 20
fpsLabel.Text = "FPS: ..."

-- ===== MENU FRAME =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 55)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0

-- ===== TITLE =====
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Rain FPS Webhook Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- ===== WEBHOOK INPUT =====
local input = Instance.new("TextBox", frame)
input.Position = UDim2.new(0, 10, 0, 40)
input.Size = UDim2.new(1, -20, 0, 30)
input.PlaceholderText = "Paste Discord Webhook here"
input.Text = ""
input.ClearTextOnFocus = false
input.TextSize = 14
input.BackgroundColor3 = Color3.fromRGB(25,25,25)
input.TextColor3 = Color3.fromRGB(255,255,255)

-- ===== SAVE BUTTON =====
local saveBtn = Instance.new("TextButton", frame)
saveBtn.Position = UDim2.new(0, 10, 0, 80)
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.Text = "Save Webhook"
saveBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
saveBtn.TextColor3 = Color3.fromRGB(0,255,0)
saveBtn.Font = Enum.Font.SourceSansBold
saveBtn.TextSize = 16

-- ===== TOGGLE BUTTON =====
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.new(0, 10, 0, 120)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Text = "Send FPS: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.fromRGB(255,80,80)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16

-- ===== BUTTON LOGIC =====
saveBtn.MouseButton1Click:Connect(function()
    if input.Text ~= "" then
        WEBHOOK_URL = input.Text
        saveBtn.Text = "Webhook Saved ✔"
        task.delay(1.5, function()
            saveBtn.Text = "Save Webhook"
        end)
    end
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

-- ===== FPS COUNTER =====
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

    if SEND_ENABLED and WEBHOOK_URL ~= "" and tick() - lastSend >= SEND_INTERVAL then
        lastSend = tick()
        pcall(function()
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "📊 FPS Roblox: " .. fps
                })
            })
        end)
    end
end)
