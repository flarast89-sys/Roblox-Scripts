-- COMBAT GUI COMPLETO: ESP + VOLVER + FLY + COMBAT
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("CombatGUI") then
    PlayerGui:FindFirstChild("CombatGUI"):Destroy()
end

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

_G.Config = {
    HeadSize = 25, HitboxEnabled = false, HitboxTeam = false, HitboxInvisible = false,
    NoclipEnabled = false, SpeedEnabled = false, SpeedValue = 16,
    JumpEnabled = false, JumpValue = 50, AntiAFKEnabled = true,
    VolverAtivo = false, ultimoTexto = "", girando = false, ultimoComandoChat = "",
    -- Configurações ESP
    ESPEnabled = false,
    ESPShowHealth = true,
    ESPShowName = true,
    ESPShowDistance = true,
    ESPShowBox = true,
    ESPTeamCheck = false,
    ESPHealthBar = true,
    ESPMaxDistance = 1000,
    -- Configurações Fly
    FlyEnabled = false,
    FlySpeed = 50
}

local noclipConnection, originalSizes = nil, {}
local originalLighting = {
    Ambient = Lighting.Ambient, Brightness = Lighting.Brightness,
    ColorShift_Bottom = Lighting.ColorShift_Bottom, ColorShift_Top = Lighting.ColorShift_Top,
    OutdoorAmbient = Lighting.OutdoorAmbient, ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, GlobalShadows = Lighting.GlobalShadows
}

-- Sistema ESP Avançado
local ESPObjects = {}

local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for i,v in pairs(properties) do
        drawing[i] = v
    end
    return drawing
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Player = player,
        BoxFilled = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Transparency = 0.3,
            Visible = false,
            ZIndex = 1
        }),
        Box = CreateDrawing("Square", {
            Thickness = 2,
            Filled = false,
            Visible = false,
            ZIndex = 2
        }),
        HealthBar = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Visible = false,
            ZIndex = 3
        }),
        HealthBarOutline = CreateDrawing("Square", {
            Thickness = 1,
            Filled = false,
            Color = Color3.fromRGB(0, 0, 0),
            Visible = false,
            ZIndex = 2
        }),
        Name = CreateDrawing("Text", {
            Text = player.Name,
            Size = 14,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 4
        }),
        Distance = CreateDrawing("Text", {
            Text = "",
            Size = 14,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 4
        }),
        Health = CreateDrawing("Text", {
            Text = "",
            Size = 14,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 4
        })
    }
    
    ESPObjects[player] = esp
end

local function RemoveESP(player)
    local esp = ESPObjects[player]
    if esp then
        for _, drawing in pairs(esp) do
            if typeof(drawing) ~= "Instance" and typeof(drawing) ~= "table" then
                pcall(function() drawing:Remove() end)
            end
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    if not _G.Config.ESPEnabled then
        for _, esp in pairs(ESPObjects) do
            esp.BoxFilled.Visible = false
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.Health.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
        end
        return
    end
    
    for player, esp in pairs(ESPObjects) do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if character and humanoid and rootPart and humanoid.Health > 0 then
            local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if distance <= _G.Config.ESPMaxDistance then
                local isTeam = _G.Config.ESPTeamCheck and player.Team == LocalPlayer.Team
                local color = isTeam and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
                
                local useHitboxSize = _G.Config.HitboxEnabled
                local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local size
                    if useHitboxSize then
                        local hitboxSize = _G.Config.HeadSize
                        size = Vector2.new(hitboxSize * 50 / distance, hitboxSize * 50 / distance)
                    else
                        size = Vector2.new(2000 / distance, 3000 / distance)
                    end
                    
                    if _G.Config.ESPShowBox then
                        esp.BoxFilled.Size = size
                        esp.BoxFilled.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                        esp.BoxFilled.Color = color
                        esp.BoxFilled.Visible = true
                        
                        esp.Box.Size = size
                        esp.Box.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                        esp.Box.Color = color
                        esp.Box.Visible = true
                    else
                        esp.BoxFilled.Visible = false
                        esp.Box.Visible = false
                    end
                    
                    if _G.Config.ESPShowName then
                        esp.Name.Position = Vector2.new(vector.X, vector.Y - size.Y / 2 - 20)
                        esp.Name.Text = player.Name
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end
                    
                    if _G.Config.ESPShowDistance then
                        esp.Distance.Position = Vector2.new(vector.X, vector.Y + size.Y / 2 + 5)
                        esp.Distance.Text = string.format("[%.0f studs]", distance)
                        esp.Distance.Visible = true
                    else
                        esp.Distance.Visible = false
                    end
                    
                    if _G.Config.ESPShowHealth then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.Health.Position = Vector2.new(vector.X, vector.Y + size.Y / 2 + 20)
                        esp.Health.Text = string.format("HP: %.0f%%", healthPercent * 100)
                        esp.Health.Color = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                        esp.Health.Visible = true
                        
                        if _G.Config.ESPHealthBar then
                            local barWidth = 4
                            local barHeight = size.Y
                            local healthHeight = barHeight * healthPercent
                            
                            esp.HealthBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                            esp.HealthBarOutline.Position = Vector2.new(
                                vector.X - size.X / 2 - barWidth - 4,
                                vector.Y - size.Y / 2 - 1
                            )
                            esp.HealthBarOutline.Visible = true
                            
                            esp.HealthBar.Size = Vector2.new(barWidth, healthHeight)
                            esp.HealthBar.Position = Vector2.new(
                                vector.X - size.X / 2 - barWidth - 3,
                                vector.Y - size.Y / 2 + (barHeight - healthHeight)
                            )
                            esp.HealthBar.Color = Color3.fromRGB(
                                255 * (1 - healthPercent),
                                255 * healthPercent,
                                0
                            )
                            esp.HealthBar.Visible = true
                        else
                            esp.HealthBar.Visible = false
                            esp.HealthBarOutline.Visible = false
                        end
                    else
                        esp.Health.Visible = false
                        esp.HealthBar.Visible = false
                        esp.HealthBarOutline.Visible = false
                    end
                else
                    esp.BoxFilled.Visible = false
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                    esp.Health.Visible = false
                    esp.HealthBar.Visible = false
                    esp.HealthBarOutline.Visible = false
                end
            else
                esp.BoxFilled.Visible = false
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
                esp.Health.Visible = false
                esp.HealthBar.Visible = false
                esp.HealthBarOutline.Visible = false
            end
        else
            esp.BoxFilled.Visible = false
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.Health.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
        end
    end
end

-- Inicializar ESP
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)
RunService.RenderStepped:Connect(UpdateESP)

-- Sistema de Voo
local bodyVelocity, bodyGyro, flyConnection

local function startFlying()
    if _G.Config.FlyEnabled then return end
    _G.Config.FlyEnabled = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not _G.Config.FlyEnabled or not character or not character.Parent then
            if _G.Config.FlyEnabled then stopFlying() end
            return
        end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        if bodyVelocity then
            bodyVelocity.Velocity = moveDirection * _G.Config.FlySpeed
        end
        
        if bodyGyro then
            bodyGyro.CFrame = camera.CFrame
        end
    end)
end

local function stopFlying()
    if not _G.Config.FlyEnabled then return end
    _G.Config.FlyEnabled = false
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 650)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

addCorner(MainFrame, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
addCorner(TopBar, 16)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 16)
TopFix.Position = UDim2.new(0, 0, 1, -16)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0.5, -20)
Logo.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
Logo.Text = "⚔️"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 24
Logo.Font = Enum.Font.GothamBold
Logo.Parent = TopBar
addCorner(Logo, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 58, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Combat GUI Ultimate"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -140, 0, 20)
Subtitle.Position = UDim2.new(0, 58, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v5.0 Ultimate Edition"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -95, 0.5, -20)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar
addCorner(MinimizeButton, 10)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar
addCorner(CloseButton, 10)

local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Size = UDim2.new(0, 70, 0, 70)
MinimizedButton.Position = UDim2.new(1, -80, 0, 20)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
MinimizedButton.Text = "⚔️"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.TextSize = 32
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Visible = false
MinimizedButton.Active = true
MinimizedButton.Draggable = true
MinimizedButton.Parent = ScreenGui
addCorner(MinimizedButton, 35)

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(150, 150, 255)
MinStroke.Thickness = 3
MinStroke.Parent = MinimizedButton

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 50)
TabContainer.Position = UDim2.new(0, 10, 0, 65)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabs, frames = {}, {}

local function createTab(name, icon, position)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.2, -4, 1, 0)
    tab.Position = UDim2.new(position * 0.2, 0, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tab.Text = ""
    tab.Parent = TabContainer
    addCorner(tab, 10)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Position = UDim2.new(0, 0, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    iconLabel.TextSize = 16
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = tab
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.Position = UDim2.new(0, 0, 1, -20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    nameLabel.TextSize = 9
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = tab
    
    tabs[name] = {button = tab, icon = iconLabel, name = nameLabel}
    return tab
end

createTab("Combat", "⚔️", 0)
createTab("Player", "👤", 1)
createTab("Visual", "👁️", 2)
createTab("Fly", "✈️", 3)
createTab("Volver", "🎖️", 4)

local function createFrame(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -20, 1, -130)
    frame.Position = UDim2.new(0, 10, 0, 120)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.Parent = MainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)
    
    frames[name] = frame
    return frame
end

local CombatFrame = createFrame("Combat")
local PlayerFrame = createFrame("Player")
local VisualFrame = createFrame("Visual")
local FlyFrame = createFrame("Fly")
local VolverFrame = createFrame("Volver")

local function switchTab(tabName)
    for name, tab in pairs(tabs) do
        tab.button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        tab.icon.TextColor3 = Color3.fromRGB(150, 150, 170)
        tab.name.TextColor3 = Color3.fromRGB(150, 150, 170)
        frames[name].Visible = false
    end
    tabs[tabName].button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    tabs[tabName].icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabs[tabName].name.TextColor3 = Color3.fromRGB(255, 255, 255)
    frames[tabName].Visible = true
end

for name, tab in pairs(tabs) do
    tab.button.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

local function createToggle(parent, text, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = parent
    addCorner(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 45, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggle.Text = ""
    toggle.Parent = container
    addCorner(toggle, 25)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 19, 0, 19)
    circle.Position = UDim2.new(0, 3, 0.5, -9.5)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    addCorner(circle, 10)
    
    local enabled = default
    
    local function update()
        if enabled then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -9.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9.5), BackgroundColor3 = Color3.fromRGB(200, 200, 220)}):Play()
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        callback(enabled)
    end)
    
    update()
end

local function createSlider(parent, text, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 65)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = parent
    addCorner(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    addCorner(sliderBg, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    addCorner(fill, 3)
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            MainFrame.Draggable = false
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            MainFrame.Draggable = true
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = LocalPlayer:GetMouse()
            local relX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relX / sliderBg.AbsoluteSize.X
            local value = math.floor(min + (percent * (max - min)))
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
end

-- COMBAT TAB
createSlider(CombatFrame, "Tamanho da Hitbox", 1, 100, 25, function(v) _G.Config.HeadSize = v end, 1)
createToggle(CombatFrame, "Hitbox Invisível", false, function(v) _G.Config.HitboxInvisible = v end, 2)
createToggle(CombatFrame, "Hitbox no Time", false, function(v) _G.Config.HitboxTeam = v end, 3)
createToggle(CombatFrame, "Ativar Hitbox", false, function(v)
    _G.Config.HitboxEnabled = v
    if not v then
        for player, data in pairs(originalSizes) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = data.Size
                hrp.Transparency = data.Transparency
                hrp.Material = data.Material
                hrp.CanCollide = data.CanCollide
            end
        end
        originalSizes = {}
    end
end, 4)

-- PLAYER TAB
createToggle(PlayerFrame, "Noclip", false, function(v)
    _G.Config.NoclipEnabled = v
    if v then
        noclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        pcall(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end, 1)

createToggle(PlayerFrame, "Anti-AFK", true, function(v) _G.Config.AntiAFKEnabled = v end, 2)
createSlider(PlayerFrame, "Velocidade", 16, 100, 16, function(v) _G.Config.SpeedValue = v end, 3)
createToggle(PlayerFrame, "Ativar Speed", false, function(v) _G.Config.SpeedEnabled = v end, 4)
createSlider(PlayerFrame, "Força do Pulo", 50, 150, 50, function(v) _G.Config.JumpValue = v end, 5)
createToggle(PlayerFrame, "Ativar Jump", false, function(v) _G.Config.JumpEnabled = v end, 6)

-- VISUAL TAB (ESP AVANÇADA)
local espInfo = Instance.new("TextLabel")
espInfo.Size = UDim2.new(1, 0, 0, 80)
espInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
espInfo.Text = "👁️ ESP AVANÇADA\n\nBox colorida + Hitbox visível\nVermelho = Inimigo | Verde = Aliado"
espInfo.TextColor3 = Color3.fromRGB(100, 100, 255)
espInfo.TextSize = 12
espInfo.Font = Enum.Font.GothamBold
espInfo.TextYAlignment = Enum.TextYAlignment.Top
espInfo.LayoutOrder = 1
espInfo.Parent = VisualFrame
addCorner(espInfo, 10)

createToggle(VisualFrame, "🎯 Ativar ESP", false, function(v) _G.Config.ESPEnabled = v end, 2)
createToggle(VisualFrame, "📛 Mostrar Nome", true, function(v) _G.Config.ESPShowName = v end, 3)
createToggle(VisualFrame, "❤️ Mostrar Vida", true, function(v) _G.Config.ESPShowHealth = v end, 4)
createToggle(VisualFrame, "📏 Mostrar Distância", true, function(v) _G.Config.ESPShowDistance = v end, 5)
createToggle(VisualFrame, "📦 Mostrar Box", true, function(v) _G.Config.ESPShowBox = v end, 6)
createToggle(VisualFrame, "💚 Barra de Vida", true, function(v) _G.Config.ESPHealthBar = v end, 7)
createToggle(VisualFrame, "👥 ESP no Meu Time", false, function(v) _G.Config.ESPTeamCheck = v end, 8)
createToggle(VisualFrame, "💡 Fullbright", false, function(v)
    if v then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
    else
        for k, v in pairs(originalLighting) do Lighting[k] = v end
    end
end, 9)

-- FLY TAB
local flyInfo = Instance.new("TextLabel")
flyInfo.Size = UDim2.new(1, 0, 0, 100)
flyInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
flyInfo.Text = "✈️ SISTEMA DE VOO\n\nControles:\nW/A/S/D - Mover\nSpace - Subir | Shift - Descer\nE - Ativar/Desativar"
flyInfo.TextColor3 = Color3.fromRGB(100, 100, 255)
flyInfo.TextSize = 12
flyInfo.Font = Enum.Font.GothamBold
flyInfo.TextYAlignment = Enum.TextYAlignment.Top
flyInfo.LayoutOrder = 1
flyInfo.Parent = FlyFrame
addCorner(flyInfo, 10)

createSlider(FlyFrame, "⚡ Velocidade de Voo", 20, 200, 50, function(v) _G.Config.FlySpeed = v end, 2)
createToggle(FlyFrame, "🚀 Ativar Voo (Tecla E)", false, function(v)
    if v then
        startFlying()
    else
        stopFlying()
    end
end, 3)

-- VOLVER TAB
local volverStatus = Instance.new("TextLabel")
volverStatus.Size = UDim2.new(1, 0, 0, 60)
volverStatus.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
volverStatus.Text = "⚔️ SISTEMA VOLVER\n\nStatus: DESATIVADO"
volverStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
volverStatus.TextSize = 14
volverStatus.Font = Enum.Font.GothamBold
volverStatus.LayoutOrder = 1
volverStatus.Parent = VolverFrame
addCorner(volverStatus, 10)

createToggle(VolverFrame, "Ativar Sistema Volver", false, function(v)
    _G.Config.VolverAtivo = v
    if v then
        volverStatus.Text = "⚔️ SISTEMA VOLVER\n\nStatus: ATIVADO ✓"
        volverStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        volverStatus.Text = "⚔️ SISTEMA VOLVER\n\nStatus: DESATIVADO"
        volverStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end, 2)

local cmdMonitor = Instance.new("TextLabel")
cmdMonitor.Size = UDim2.new(1, 0, 0, 80)
cmdMonitor.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
cmdMonitor.Text = "📡 Últimos Comandos\n\nAguardando..."
cmdMonitor.TextColor3 = Color3.fromRGB(150, 150, 170)
cmdMonitor.TextSize = 12
cmdMonitor.Font = Enum.Font.Code
cmdMonitor.TextWrapped = true
cmdMonitor.TextYAlignment = Enum.TextYAlignment.Top
cmdMonitor.LayoutOrder = 3
cmdMonitor.Parent = VolverFrame
addCorner(cmdMonitor, 10)

-- Tecla E para alternar voo
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        if _G.Config.FlyEnabled then
            stopFlying()
        else
            startFlying()
        end
    end
end)

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    if _G.Config.AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- SPEED E JUMP
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local h = LocalPlayer.Character.Humanoid
                h.WalkSpeed = _G.Config.SpeedEnabled and _G.Config.SpeedValue or 16
                h.JumpPower = _G.Config.JumpEnabled and _G.Config.JumpValue or 50
            end
        end)
    end
end)

-- HITBOX SYSTEM
local function applyHitbox(player)
    if not player.Character or player == LocalPlayer then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not originalSizes[player] then
        originalSizes[player] = {
            Size = hrp.Size, Transparency = hrp.Transparency,
            Material = hrp.Material, CanCollide = hrp.CanCollide
        }
    end
    
    local shouldApply = _G.Config.HitboxTeam or (player.Team ~= LocalPlayer.Team)
    
    if _G.Config.HitboxEnabled and shouldApply then
        hrp.Size = Vector3.new(_G.Config.HeadSize, _G.Config.HeadSize, _G.Config.HeadSize)
        hrp.Transparency = _G.Config.HitboxInvisible and 1 or 0.7
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
        hrp.BrickColor = player.Team and player.Team.TeamColor or BrickColor.new("Really blue")
    else
        if originalSizes[player] then
            hrp.Size = originalSizes[player].Size
            hrp.Transparency = originalSizes[player].Transparency
            hrp.Material = originalSizes[player].Material
            hrp.CanCollide = originalSizes[player].CanCollide
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if _G.Config.HitboxEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function() applyHitbox(player) end)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    originalSizes[player] = nil
end)

-- VOLVER SYSTEM
local function girarPersonagem(graus)
    if _G.Config.girando then return end
    _G.Config.girando = true
    task.wait(1)
    local grausFinal = -graus
    local cfAtual = humanoidRootPart.CFrame
    local cfFinal = cfAtual * CFrame.Angles(0, math.rad(grausFinal), 0)
    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = cfFinal})
    tween:Play()
    tween.Completed:Wait()
    _G.Config.girando = false
end

local function processarComando(comando, origem)
    if comando == "Direita, volver." or comando == "/a Direita, volver." then
        cmdMonitor.Text = "📡 Últimos Comandos\n\n✓ Direita (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(90) end)
        return true
    elseif comando == "Esquerda, volver." or comando == "/a Esquerda, volver." then
        cmdMonitor.Text = "📡 Últimos Comandos\n\n✓ Esquerda (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(-90) end)
        return true
    elseif comando == "Direita, inclinar." or comando == "/a Direita, inclinar." then
        cmdMonitor.Text = "📡 Últimos Comandos\n\n✓ Inclinar Direita (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(45) end)
        return true
    elseif comando == "Esquerda, inclinar." or comando == "/a Esquerda, inclinar." then
        cmdMonitor.Text = "📡 Últimos Comandos\n\n✓ Inclinar Esquerda (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(-45) end)
        return true
    elseif comando == "Retaguarda, volver." or comando == "/a Retaguarda, volver." then
        cmdMonitor.Text = "📡 Últimos Comandos\n\n✓ Retaguarda (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(180) end)
        return true
    end
    return false
end

task.spawn(function()
    while task.wait(0.5) do
        if _G.Config.VolverAtivo and not _G.Config.girando then
            pcall(function()
                for _, elemento in pairs(PlayerGui:GetDescendants()) do
                    if elemento:IsA("TextLabel") and elemento.Visible and elemento.Text ~= "" then
                        local pos = elemento.AbsolutePosition
                        if pos.Y < 100 then
                            local textoCompleto = elemento.Text
                            if textoCompleto ~= _G.Config.ultimoTexto then
                                _G.Config.ultimoTexto = textoCompleto
                                local comando = textoCompleto
                                if string.find(textoCompleto, ":") then
                                    local partes = string.split(textoCompleto, ":")
                                    if #partes >= 2 then
                                        comando = partes[2]:match("^%s*(.-)%s*$")
                                    end
                                end
                                processarComando(comando, "Topo")
                                task.wait(2)
                                _G.Config.ultimoTexto = ""
                            end
                        end
                    end
                end
            end)
        end
    end
end)

pcall(function()
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channels = TextChatService:WaitForChild("TextChannels", 5)
        if channels then
            local generalChannel = channels:WaitForChild("RBXGeneral", 5)
            if generalChannel then
                generalChannel.MessageReceived:Connect(function(message)
                    if _G.Config.VolverAtivo and not _G.Config.girando then
                        local texto = message.Text
                        if texto ~= _G.Config.ultimoComandoChat then
                            _G.Config.ultimoComandoChat = texto
                            if processarComando(texto, "Chat") then
                                task.wait(2)
                                _G.Config.ultimoComandoChat = ""
                            end
                        end
                    end
                end)
            end
        end
    end
end)

pcall(function()
    local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if events then
        local onMsg = events:FindFirstChild("OnMessageDoneFiltering")
        if onMsg then
            onMsg.OnClientEvent:Connect(function(data)
                if _G.Config.VolverAtivo and not _G.Config.girando then
                    local texto = data.Message
                    if texto ~= _G.Config.ultimoComandoChat then
                        _G.Config.ultimoComandoChat = texto
                        if processarComando(texto, "Chat") then
                            task.wait(2)
                            _G.Config.ultimoComandoChat = ""
                        end
                    end
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    stopFlying()
end)

-- GUI ANIMATIONS
MinimizeButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    MinimizedButton.Visible = true
    MinimizedButton.Size = UDim2.new(0, 0, 0, 0)
    MinimizedButton.Position = UDim2.new(1, -45, 0, 55)
    TweenService:Create(MinimizedButton, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(1, -80, 0, 20)}):Play()
end)

MinimizedButton.MouseButton1Click:Connect(function()
    TweenService:Create(MinimizedButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 10}):Play()
    task.wait(0.3)
    MinimizedButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 400, 0, 650), Position = UDim2.new(0.5, -200, 0.5, -325)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    _G.Config.HitboxEnabled = false
    _G.Config.ESPEnabled = false
    stopFlying()
    for player, data in pairs(originalSizes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = data.Size
            hrp.Transparency = data.Transparency
            hrp.Material = data.Material
            hrp.CanCollide = data.CanCollide
        end
    end
    if noclipConnection then noclipConnection:Disconnect() end
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
    Blur:Destroy()
end)

TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 10}):Play()
switchTab("Combat")

print("✅ Combat GUI Ultimate Edition Carregado!")
print("📌 5 Abas: Combat | Player | Visual (ESP) | Fly | Volver")
print("🎯 Hitbox + ESP sincronizadas para ver através das paredes!")
print("✈️ Sistema de voo ativado - Pressione E para voar!")
print("⚔️ Sistema Volver integrado!")
