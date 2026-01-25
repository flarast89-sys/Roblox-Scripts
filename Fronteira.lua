-- Combat GUI Mobile Optimized - Estilo Rayfield
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configurações
_G.HeadSize = 25
_G.HitboxEnabled = false
_G.HitboxTeam = false
_G.NoclipEnabled = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.JumpEnabled = false
_G.JumpValue = 50
_G.AntiAFKEnabled = true
_G.ESPEnabled = false
_G.TeamESPEnabled = false
_G.FullbrightEnabled = false
_G.SelectedCommander = nil
_G.AutoVolverEnabled = false

-- Variáveis Noclip
local noclipConnection = nil

-- Comandos Volver
local VolverCommands = {
    ["Direita, volver."] = -90,
    ["/a Direita, volver."] = -90,
    ["/A Direita, volver."] = -90,
    ["/h Direita, volver."] = -90,
    ["/H Direita, volver."] = -90,
    [";h Direita, volver."] = -90,
    [";H Direita, volver."] = -90,
    
    ["Esquerda, volver."] = 90,
    ["/a Esquerda, volver."] = 90,
    ["/A Esquerda, volver."] = 90,
    ["/h Esquerda, volver."] = 90,
    ["/H Esquerda, volver."] = 90,
    [";h Esquerda, volver."] = 90,
    [";H Esquerda, volver."] = 90,
    
    ["Direita, inclinar."] = -45,
    ["/a Direita, inclinar."] = -45,
    ["/A Direita, inclinar."] = -45,
    ["/h Direita, inclinar."] = -45,
    ["/H Direita, inclinar."] = -45,
    [";h Direita, inclinar."] = -45,
    [";H Direita, inclinar."] = -45,
    
    ["Esquerda, inclinar."] = 45,
    ["/a Esquerda, inclinar."] = 45,
    ["/A Esquerda, inclinar."] = 45,
    ["/h Esquerda, inclinar."] = 45,
    ["/H Esquerda, inclinar."] = 45,
    [";h Esquerda, inclinar."] = 45,
    [";H Esquerda, inclinar."] = 45,
    
    ["Retaguarda, volver."] = 180,
    ["/a Retaguarda, volver."] = 180,
    ["/A Retaguarda, volver."] = 180,
    ["/h Retaguarda, volver."] = 180,
    ["/H Retaguarda, volver."] = 180,
    [";h Retaguarda, volver."] = 180,
    [";H Retaguarda, volver."] = 180,
}

local ESPObjects = {}
local originalLightingSettings = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows
}

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Blur de fundo
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game:GetService("Lighting")

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 620)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -310)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 16)
TopFix.Position = UDim2.new(0, 0, 1, -16)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Logo e Título
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0.5, -20)
Logo.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
Logo.Text = "⚔️"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 24
Logo.Font = Enum.Font.GothamBold
Logo.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 58, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Combat GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -140, 0, 20)
Subtitle.Position = UDim2.new(0, 58, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v2.0 Mobile Optimized"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

-- Container de Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 50)
TabContainer.Position = UDim2.new(0, 10, 0, 65)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Sistema de Abas
local tabs = {}
local frames = {}
local currentTab = nil

local function createTab(name, icon, position)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(0.25, -5, 1, 0)
    tab.Position = UDim2.new(position * 0.25, 0, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tab.Text = ""
    tab.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tab
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Position = UDim2.new(0, 0, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = tab
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.Position = UDim2.new(0, 0, 1, -20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = tab
    
    tabs[name] = {button = tab, icon = iconLabel, name = nameLabel}
    return tab
end

local CombatTab = createTab("Combat", "⚔️", 0)
local PlayerTab = createTab("Player", "👤", 1)
local VisualTab = createTab("Visual", "👁️", 2)
local VolverTab = createTab("Volver", "🎖️", 3)

-- Criar Frames
local function createFrame(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name .. "Frame"
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
local VolverFrame = createFrame("Volver")

-- Função trocar abas
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
    currentTab = tabName
end

CombatTab.MouseButton1Click:Connect(function() switchTab("Combat") end)
PlayerTab.MouseButton1Click:Connect(function() switchTab("Player") end)
VisualTab.MouseButton1Click:Connect(function() switchTab("Visual") end)
VolverTab.MouseButton1Click:Connect(function() switchTab("Volver") end)

-- Função criar Toggle
local function createToggle(parent, text, default, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.LayoutOrder = layoutOrder
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container
    
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
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 19, 0, 19)
    circle.Position = UDim2.new(0, 3, 0.5, -9.5)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    local enabled = default
    
    local function updateToggle()
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
        updateToggle()
        callback(enabled)
    end)
    
    updateToggle()
    return container
end

-- Função criar Slider
local function createSlider(parent, text, min, max, default, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 65)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.LayoutOrder = layoutOrder
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container
    
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
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
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
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = LocalPlayer:GetMouse()
            local relativeX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relativeX / sliderBg.AbsoluteSize.X
            local value = math.floor(min + (percent * (max - min)))
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return container
end

-- Função criar Botão
local function createButton(parent, text, callback, layoutOrder)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = layoutOrder
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 235)}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
        callback()
    end)
    
    return button
end

-- ==================
-- ABA COMBAT
-- ==================

createSlider(CombatFrame, "Tamanho Hitbox Cabeça", 1, 100, 25, function(value)
    _G.HeadSize = value
end, 1)

createToggle(CombatFrame, "Hitbox no Time", false, function(value)
    _G.HitboxTeam = value
end, 2)

createToggle(CombatFrame, "Ativar Hitbox", false, function(value)
    _G.HitboxEnabled = value
end, 3)

-- ==================
-- ABA PLAYER
-- ==================

createToggle(PlayerFrame, "Noclip", false, function(value)
    _G.NoclipEnabled = value
    
    if value then
        -- Ativar Noclip
        noclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
    else
        -- Desativar Noclip
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        -- Restaurar colisões
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

createToggle(PlayerFrame, "Anti-AFK", true, function(value)
    _G.AntiAFKEnabled = value
end, 2)

createSlider(PlayerFrame, "Velocidade", 16, 100, 16, function(value)
    _G.SpeedValue = value
end, 3)

createToggle(PlayerFrame, "Ativar Speed", false, function(value)
    _G.SpeedEnabled = value
end, 4)

createSlider(PlayerFrame, "Força do Pulo", 50, 150, 50, function(value)
    _G.JumpValue = value
end, 5)

createToggle(PlayerFrame, "Ativar Jump", false, function(value)
    _G.JumpEnabled = value
end, 6)

createButton(PlayerFrame, "🔫 Pegar Arma AS VAL", function()
    local pos1 = Vector3.new(119.21, 13.00, 194.23)
    local pos2 = Vector3.new(228.34, 21.51, 9.05)
    
    local function teleportAndInteract(position)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            wait(0.3)
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            wait(0.5)
        end
    end
    
    local function resetCharacter()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
            wait(5)
        end
    end
    
    teleportAndInteract(pos1)
    teleportAndInteract(pos2)
    resetCharacter()
    teleportAndInteract(pos1)
    teleportAndInteract(pos2)
    resetCharacter()
    teleportAndInteract(pos1)
    teleportAndInteract(pos2)
end, 7)

-- ==================
-- ABA VISUAL
-- ==================

createToggle(VisualFrame, "ESP nos Jogadores", false, function(value)
    _G.ESPEnabled = value
end, 1)

createToggle(VisualFrame, "ESP no Meu Time", false, function(value)
    _G.TeamESPEnabled = value
end, 2)

createToggle(VisualFrame, "Fullbright", false, function(value)
    _G.FullbrightEnabled = value
    if value then
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
        Lighting.Ambient = originalLightingSettings.Ambient
        Lighting.Brightness = originalLightingSettings.Brightness
        Lighting.ColorShift_Bottom = originalLightingSettings.ColorShift_Bottom
        Lighting.ColorShift_Top = originalLightingSettings.ColorShift_Top
        Lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
        Lighting.ClockTime = originalLightingSettings.ClockTime
        Lighting.FogEnd = originalLightingSettings.FogEnd
        Lighting.FogStart = originalLightingSettings.FogStart
        Lighting.GlobalShadows = originalLightingSettings.GlobalShadows
    end
end, 3)

-- ==================
-- ABA VOLVER
-- ==================

createToggle(VolverFrame, "🎖️ Ativar Auto Volver", false, function(value)
    _G.AutoVolverEnabled = value
end, 1)

local CommanderLabel = Instance.new("TextLabel")
CommanderLabel.Size = UDim2.new(1, 0, 0, 40)
CommanderLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
CommanderLabel.Text = "👤 Comandante: Nenhum"
CommanderLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
CommanderLabel.TextSize = 13
CommanderLabel.Font = Enum.Font.GothamBold
CommanderLabel.LayoutOrder = 2
CommanderLabel.Parent = VolverFrame

local cmdCorner = Instance.new("UICorner")
cmdCorner.CornerRadius = UDim.new(0, 10)
cmdCorner.Parent = CommanderLabel

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, 250)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 4
PlayerListFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.LayoutOrder = 3
PlayerListFrame.Parent = VolverFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 10)
listCorner.Parent = PlayerListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = PlayerListFrame

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 50)
StatusLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
StatusLabel.Text = "⚠️ Ative o Auto Volver"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextWrapped = true
StatusLabel.LayoutOrder = 4
StatusLabel.Parent = VolverFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = StatusLabel

-- ==================
-- SISTEMAS
-- ==================

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Speed e Jump
RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            if _G.SpeedEnabled then
                humanoid.WalkSpeed = _G.SpeedValue
            else
                humanoid.WalkSpeed = 16
            end
            if _G.JumpEnabled then
                humanoid.JumpPower = _G.JumpValue
            else
                humanoid.JumpPower = 50
            end
        end
    end)
end)

-- Hitbox (APENAS CABEÇA)
RunService.RenderStepped:Connect(function()
    if _G.HitboxEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v.Name ~= LocalPlayer.Name then
                pcall(function()
                    local shouldApply = false
                    if _G.HitboxTeam then
                        shouldApply = true
                    else
                        if v.Team ~= LocalPlayer.Team then
                            shouldApply = true
                        end
                    end
                    
                    if shouldApply and v.Character and v.Character:FindFirstChild("Head") then
                        local head = v.Character.Head
                        head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        head.Transparency = 0.7
                        head.Material = Enum.Material.Neon
                        head.CanCollide = false
                        if v.Team then
                            head.BrickColor = v.Team.TeamColor
                        else
                            head.BrickColor = BrickColor.new("Really red")
                        end
                    end
                end)
            end
        end
    end
end)

-- ESP
local function createESP(player)
    if player == LocalPlayer then return end
    
    local function addESP(character)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                obj:Destroy()
            end
        end
        
        ESPObjects[player] = {}
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        table.insert(ESPObjects[player], highlight)
        
        local function updateESP()
            if not character or not character.Parent then return end
            
            local shouldShow = _G.ESPEnabled
            
            if not _G.TeamESPEnabled and player.Team == LocalPlayer.Team then
                shouldShow = false
            end
            
            highlight.Enabled = shouldShow
            
            if shouldShow and player.Team then
                highlight.FillColor = player.TeamColor.Color
                highlight.OutlineColor = player.TeamColor.Color
            end
        end
        
        RunService.RenderStepped:Connect(updateESP)
    end
    
    if player.Character then
        addESP(player.Character)
    end
    
    player.CharacterAdded:Connect(addESP)
end

local function removeESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj:Destroy()
        end
        ESPObjects[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ==================
-- SISTEMA VOLVER
-- ==================

local isRotating = false

local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

local function createPlayerButton(player)
    local Button = Instance.new("TextButton")
    Button.Name = player.Name
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Button.Text = "  " .. player.Name .. (player == LocalPlayer and " (VOCÊ)" or "")
    Button.TextColor3 = Color3.fromRGB(200, 200, 220)
    Button.TextSize = 12
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = PlayerListFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 4, 1, -10)
    Indicator.Position = UDim2.new(0, 3, 0, 5)
    Indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = Button
    
    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator
    
    Button.MouseButton1Click:Connect(function()
        for _, btn in pairs(PlayerListFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                local ind = btn:FindFirstChild("Indicator")
                if ind then ind.Visible = false end
            end
        end
        
        Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        Indicator.Visible = true
        
        _G.SelectedCommander = player
        CommanderLabel.Text = "👤 Comandante: " .. player.Name
        CommanderLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        updateStatus("✅ Aguardando comandos de " .. player.Name, Color3.fromRGB(100, 255, 100))
    end)
    
    return Button
end

local function updatePlayerList()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerButton(player)
    end
end

local function rotateCharacter(degrees)
    if isRotating then return false end
    if not LocalPlayer.Character then return false end
    
    local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return false end
    
    local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if Humanoid then
        Humanoid.AutoRotate = false
    end
    
    isRotating = true
    
    local currentCFrame = HumanoidRootPart.CFrame
    local overshoot = math.random(5, 10)
    local firstRotation = degrees + (degrees > 0 and overshoot or -overshoot)
    
    local firstCFrame = currentCFrame * CFrame.Angles(0, math.rad(firstRotation), 0)
    
    local tween1 = TweenService:Create(HumanoidRootPart, 
        TweenInfo.new(0.4, Enum.EasingStyle.Linear), 
        {CFrame = firstCFrame})
    tween1:Play()
    tween1.Completed:Wait()
    
    local finalCFrame = currentCFrame * CFrame.Angles(0, math.rad(degrees), 0)
    
    local tween2 = TweenService:Create(HumanoidRootPart, 
        TweenInfo.new(0.2, Enum.EasingStyle.Linear), 
        {CFrame = finalCFrame})
    tween2:Play()
    tween2.Completed:Wait()
    
    if Humanoid then
        Humanoid.AutoRotate = true
    end
    
    isRotating = false
    return true
end

local function processCommand(message, speaker)
    if not _G.SelectedCommander or speaker.UserId ~= _G.SelectedCommander.UserId then
        return
    end
    
    if not _G.AutoVolverEnabled then return end
    
    local angle = VolverCommands[message]
    
    if angle then
        updateStatus("⏳ Executando comando...", Color3.fromRGB(255, 255, 100))
        
        task.spawn(function()
            task.wait(1.8)
            local success = rotateCharacter(angle)
            if success then
                updateStatus(string.format("🔄 Executado: %d°", math.abs(angle)), Color3.fromRGB(100, 255, 100))
                task.wait(1)
                if _G.SelectedCommander then
                    updateStatus("✅ Aguardando comandos de " .. _G.SelectedCommander.Name, Color3.fromRGB(100, 255, 100))
                end
            end
        end)
    end
end

pcall(function()
    TextChatService.MessageReceived:Connect(function(message)
        local speaker = Players:GetPlayerByUserId(message.TextSource.UserId)
        if speaker then
            processCommand(message.Text, speaker)
        end
    end)
end)

local function connectPlayerChat(player)
    player.Chatted:Connect(function(message)
        processCommand(message, player)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    connectPlayerChat(player)
end

Players.PlayerAdded:Connect(function(player)
    connectPlayerChat(player)
    task.wait(0.5)
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if _G.SelectedCommander and player == _G.SelectedCommander then
        _G.SelectedCommander = nil
        CommanderLabel.Text = "👤 Comandante: Nenhum"
        CommanderLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        updateStatus("⚠️ Comandante saiu", Color3.fromRGB(255, 200, 100))
    end
    task.wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

-- ==================
-- BOTÕES GUI
-- ==================

CloseButton.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = false
    if noclipConnection then
        noclipConnection:Disconnect()
    end
    ScreenGui:Destroy()
    Blur:Destroy()
end)

-- Efeito Blur ao abrir
TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 10}):Play()

-- Iniciar na aba Combat
switchTab("Combat")

print("✅ Combat GUI Mobile Loaded!")
