warn("Rain FPS Logger Started (Delta Safe)")

local request = request or http_request or (syn and syn.request)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local WEBHOOK_URL = ""
local SEND_INTERVAL = 10

-- === COMMAND QUA CHAT ===
-- !webhook <link>
-- !fps on / off

local SEND = false

Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,8) == "!webhook" then
        WEBHOOK_URL = msg:sub(10)
        warn("Webhook set")
    elseif msg == "!fps on" then
        SEND = true
        warn("FPS sending ON")
    elseif msg == "!fps off" then
        SEND = false
        warn("FPS sending OFF")
    end
end)

-- === FPS COUNTER ===
local frames, fps = 0, 0
local last = tick()
local lastSend = 0

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last >= 1 then
        fps = frames
        frames = 0
        last = tick()
        print("FPS:", fps)
    end

    if SEND and WEBHOOK_URL ~= "" and request and tick() - lastSend >= SEND_INTERVAL then
        lastSend = tick()
        pcall(function()
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "📊 FPS Roblox (Delta): "..fps
                })
            })
        end)
    end
end)toggleBtn.Position = UDim2.new(0, 10, 0, 120)
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
