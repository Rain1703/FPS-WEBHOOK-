-- Roblox FPS Monitor & Optimizer
-- Author: Rain17C

-- ===== CONFIG =====
local WEBHOOK_URL = "https://discord.com/api/webhooks/1442340447790825593/Hb8B2seQdvg1iub_Wv03EKszJ6HdLDPJ-vKSRFKn_Cu37Gn6qvBwBVFks6p41QWI5NxV"
local SEND_INTERVAL = 10
-- ==================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- ===== FPS OPTIMIZE =====
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Enabled = false
    end
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "RainFPS"
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0, 200, 0, 40)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundColor3 = Color3.fromRGB(15,15,15)
label.BackgroundTransparency = 0.25
label.TextColor3 = Color3.fromRGB(0,255,0)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 24
label.Text = "FPS: ..."

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
        label.Text = "FPS: " .. fps
    end

    if tick() - lastSend >= SEND_INTERVAL then
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
