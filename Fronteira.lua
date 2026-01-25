-- Combat GUI Completo - Mobile & PC Optimizado
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Detectar plataforma
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

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
_G.SilentAimEnabled = false
_G.HeadshotEnabled = false

-- Configurações Volver
_G.SelectedCommander = nil
_G.AutoVolverEnabled = true

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
ScreenGui.Parent = PlayerGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
if isMobile then
    MainFrame.Size = UDim2.new(0, 350, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
else
    MainFrame.Size = UDim2.new(0, 420, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
end
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BorderSizePixel = 0
Title.Text = "⚔️ COMBAT GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = isMobile and 18 or 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Botão Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -75, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeButton

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -37.5, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Bolinha minimizada
local MinimizedBall = Instance.new("TextButton")
MinimizedBall.Size = UDim2.new(0, 60, 0, 60)
MinimizedBall.Position = UDim2.new(1, -70, 0, 10)
MinimizedBall.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizedBall.Text = "⚔️"
MinimizedBall.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBall.TextSize = 30
MinimizedBall.Font = Enum.Font.GothamBold
MinimizedBall.Visible = false
MinimizedBall.Parent = ScreenGui

local BallCorner = Instance.new("UICorner")
BallCorner.CornerRadius = UDim.new(1, 0)
BallCorner.Parent = MinimizedBall

-- Container de Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -10, 0, 40)
TabContainer.Position = UDim2.new(0, 5, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Abas
local tabSize = isMobile and 0.25 or 0.25
local tabs = {}

local function createTab(name, emoji, position)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(tabSize, -4, 1, 0)
    tab.Position = UDim2.new(position * tabSize, 2, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tab.Text = isMobile and emoji or (emoji .. " " .. name:upper())
    tab.TextColor3 = Color3.fromRGB(150, 150, 150)
    tab.TextSize = isMobile and 18 or 11
    tab.Font = Enum.Font.GothamBold
    tab.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tab
    
    tabs[name] = tab
    return tab
end

local CombatTab = createTab("Combat", "⚔️", 0)
local PlayerTab = createTab("Player", "👤", 1)
local VisualTab = createTab("Visual", "👁️", 2)
local VolverTab = createTab("Volver", "🎖️", 3)

-- Frames das abas
local frames = {}

local function createFrame(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(1, -20, 1, -105)
    frame.Position = UDim2.new(0, 10, 0, 95)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 6
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.Parent = MainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    frames[name] = frame
    return frame
end

local CombatFrame = createFrame("Combat")
local PlayerFrame = createFrame("Player")
local VisualFrame = createFrame("Visual")
local VolverFrame = createFrame("Volver")

CombatFrame.Visible = true

-- Função trocar abas
local function switchTab(tabName)
    for name, tab in pairs(tabs) do
        tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tab.TextColor3 = Color3.fromRGB(150, 150, 150)
        frames[name].Visible = false
    end
    
    tabs[tabName].BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabs[tabName].TextColor3 = Color3.fromRGB(255, 255, 255)
    frames[tabName].Visible = true
end

CombatTab.MouseButton1Click:Connect(function() switchTab("Combat") end)
PlayerTab.MouseButton1Click:Connect(function() switchTab("Player") end)
VisualTab.MouseButton1Click:Connect(function() switchTab("Visual") end)
VolverTab.MouseButton1Click:Connect(function() switchTab("Volver") end)

-- Função criar botão
local function createButton(parent, text, layoutOrder)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, isMobile and 45 or 50)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = isMobile and 14 or 16
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = layoutOrder
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    return button
end

-- Função criar label
local function createLabel(parent, text, layoutOrder)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, isMobile and 28 or 32)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = isMobile and 13 or 15
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = layoutOrder
    label.Parent = parent
    
    return label
end

-- Função criar slider
local function createSlider(parent, min, max, default, callback, layoutOrder)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, isMobile and 35 or 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = layoutOrder
    container.Parent = parent
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -80, 0, isMobile and 18 or 22)
    sliderFrame.Position = UDim2.new(0, 0, 0.5, -11)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderFrame.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 70, 1, 0)
    valueLabel.Position = UDim2.new(1, -70, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = isMobile and 13 or 15
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = container
    
    local dragging = false
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            MainFrame.Draggable = false
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            MainFrame.Draggable = true
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = LocalPlayer:GetMouse()
            local relativeX = math.clamp(mouse.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local percent = relativeX / sliderFrame.AbsoluteSize.X
            local value = math.floor(min + (percent * (max - min)))
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return container
end

-- ==================
-- ABA COMBATE
-- ==================

createLabel(CombatFrame, "⚔️ CONFIGURAÇÕES DE COMBATE", 1)

createSlider(CombatFrame, 1, 100, 25, function(value)
    _G.HeadSize = value
end, 2)

local SizeInfo = createLabel(CombatFrame, "Tamanho da Hitbox", 3)

local TeamToggle = createButton(CombatFrame, "Hitbox Team: OFF", 4)
local HitboxToggle = createButton(CombatFrame, "ATIVAR HITBOX", 5)
local HeadshotToggle = createButton(CombatFrame, "HEADSHOT AUTOMÁTICO: OFF", 6)

local function updateTeamButton()
    if not _G.HitboxEnabled then
        TeamToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TeamToggle.TextColor3 = Color3.fromRGB(120, 120, 120)
        TeamToggle.Text = "Hitbox Team: OFF (Desativado)"
    else
        if _G.HitboxTeam then
            TeamToggle.Text = "Hitbox Team: ON"
            TeamToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
            TeamToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
        else
            TeamToggle.Text = "Hitbox Team: OFF"
            TeamToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
            TeamToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end
end

TeamToggle.MouseButton1Click:Connect(function()
    if _G.HitboxEnabled then
        _G.HitboxTeam = not _G.HitboxTeam
        updateTeamButton()
    end
end)

HitboxToggle.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = not _G.HitboxEnabled
    if _G.HitboxEnabled then
        HitboxToggle.Text = "DESATIVAR HITBOX"
        HitboxToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        HitboxToggle.Text = "ATIVAR HITBOX"
        HitboxToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
    updateTeamButton()
end)

HeadshotToggle.MouseButton1Click:Connect(function()
    _G.HeadshotEnabled = not _G.HeadshotEnabled
    if _G.HeadshotEnabled then
        HeadshotToggle.Text = "HEADSHOT AUTOMÁTICO: ON"
        HeadshotToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        HeadshotToggle.Text = "HEADSHOT AUTOMÁTICO: OFF"
        HeadshotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- ==================
-- ABA PLAYER
-- ==================

createLabel(PlayerFrame, "👤 CONFIGURAÇÕES DO JOGADOR", 1)

local NoclipToggle = createButton(PlayerFrame, "ATIVAR NOCLIP", 2)
local AntiAFKToggle = createButton(PlayerFrame, "ANTI-AFK: ON", 3)
local GetWeaponButton = createButton(PlayerFrame, "PEGAR ARMA AS VAL", 4)

createLabel(PlayerFrame, "Velocidade", 5)
createSlider(PlayerFrame, 16, 100, 16, function(value)
    _G.SpeedValue = value
end, 6)

local SpeedToggle = createButton(PlayerFrame, "SPEED: OFF", 7)

createLabel(PlayerFrame, "Força do Pulo", 8)
createSlider(PlayerFrame, 50, 150, 50, function(value)
    _G.JumpValue = value
end, 9)

local JumpToggle = createButton(PlayerFrame, "JUMP: OFF", 10)

AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)

NoclipToggle.MouseButton1Click:Connect(function()
    _G.NoclipEnabled = not _G.NoclipEnabled
    if _G.NoclipEnabled then
        NoclipToggle.Text = "DESATIVAR NOCLIP"
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        NoclipToggle.Text = "ATIVAR NOCLIP"
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

SpeedToggle.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    if _G.SpeedEnabled then
        SpeedToggle.Text = "SPEED: ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        SpeedToggle.Text = "SPEED: OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

JumpToggle.MouseButton1Click:Connect(function()
    _G.JumpEnabled = not _G.JumpEnabled
    if _G.JumpEnabled then
        JumpToggle.Text = "JUMP: ON"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        JumpToggle.Text = "JUMP: OFF"
        JumpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

AntiAFKToggle.MouseButton1Click:Connect(function()
    _G.AntiAFKEnabled = not _G.AntiAFKEnabled
    if _G.AntiAFKEnabled then
        AntiAFKToggle.Text = "ANTI-AFK: ON"
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    else
        AntiAFKToggle.Text = "ANTI-AFK: OFF"
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Função Pegar Arma
local function getASVAL()
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
    
    GetWeaponButton.Text = "✅ ARMA COLETADA!"
    GetWeaponButton.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
    wait(2)
    GetWeaponButton.Text = "PEGAR ARMA AS VAL"
    GetWeaponButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

GetWeaponButton.MouseButton1Click:Connect(function()
    GetWeaponButton.Text = "⏳ COLETANDO..."
    spawn(function()
        pcall(getASVAL)
    end)
end)

-- ==================
-- ABA VISUAL
-- ==================

createLabel(VisualFrame, "👁️ CONFIGURAÇÕES VISUAIS", 1)

local ESPToggle = createButton(VisualFrame, "ATIVAR ESP", 2)
local ESPTeamToggle = createButton(VisualFrame, "ESP NO MEU TIME", 3)
local FullbrightToggle = createButton(VisualFrame, "ATIVAR FULLBRIGHT", 4)

ESPToggle.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    if _G.ESPEnabled then
        ESPToggle.Text = "DESATIVAR ESP"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        ESPToggle.Text = "ATIVAR ESP"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

ESPTeamToggle.MouseButton1Click:Connect(function()
    _G.TeamESPEnabled = not _G.TeamESPEnabled
    if _G.TeamESPEnabled then
        ESPTeamToggle.Text = "DESATIVAR ESP NO TIME"
        ESPTeamToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        ESPTeamToggle.Text = "ESP NO MEU TIME"
        ESPTeamToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

FullbrightToggle.MouseButton1Click:Connect(function()
    _G.FullbrightEnabled = not _G.FullbrightEnabled
    if _G.FullbrightEnabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        
        FullbrightToggle.Text = "DESATIVAR FULLBRIGHT"
        FullbrightToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
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
        
        FullbrightToggle.Text = "ATIVAR FULLBRIGHT"
        FullbrightToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- ==================
-- ABA VOLVER
-- ==================

createLabel(VolverFrame, "🎖️ AUTO VOLVER", 1)

local CommanderLabel = createLabel(VolverFrame, "👤 Comandante: Nenhum", 2)
CommanderLabel.TextColor3 = Color3.fromRGB(255, 200, 100)

createLabel(VolverFrame, "📋 Selecione um Comandante:", 3)

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1, 0, 0, isMobile and 200 or 250)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.LayoutOrder = 4
PlayerListFrame.Parent = VolverFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = PlayerListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = PlayerListFrame

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)
end)

local StatusLabel = createLabel(VolverFrame, "⚠️ Selecione um comandante", 5)
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
StatusLabel.TextWrapped = true

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

-- Noclip
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if _G.NoclipEnabled then
                        part.CanCollide = false
                    else
                        -- Reativa colisão quando desabilitar (exceto HumanoidRootPart)
                        if part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end)
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

-- Hitbox Melhorada
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
                    
                    if shouldApply and v.Character then
                        -- Hitbox na Head para headshot
                        if _G.HeadshotEnabled and v.Character:FindFirstChild("Head") then
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
                        
                        -- Hitbox no HumanoidRootPart
                        if v.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            hrp.Transparency = 0.7
                            hrp.Material = Enum.Material.Neon
                            hrp.CanCollide = false
                            if v.Team then
                                hrp.BrickColor = v.Team.TeamColor
                            else
                                hrp.BrickColor = BrickColor.new("Really blue")
                            end
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
            
            if _G.TeamESPEnabled and player.Team == LocalPlayer.Team then
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
    Button.Size = UDim2.new(1, -10, 0, isMobile and 38 or 35)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = "  " .. player.Name .. (player == LocalPlayer and " (VOCÊ)" or "")
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = isMobile and 13 or 12
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = PlayerListFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 1, -8)
    Indicator.Position = UDim2.new(0, 3, 0, 4)
    Indicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = Button
    
    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator
    
    Button.MouseButton1Click:Connect(function()
        for _, btn in pairs(PlayerListFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                local ind = btn:FindFirstChild("Indicator")
                if ind then ind.Visible = false end
            end
        end
        
        Button.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
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
        updateStatus("⏳ Comando recebido! Executando...", Color3.fromRGB(255, 255, 100))
        
        task.spawn(function()
            task.wait(1.8)
            local success = rotateCharacter(angle)
            if success then
                updateStatus(string.format("🔄 Executado: %d°", math.abs(angle)), Color3.fromRGB(255, 255, 100))
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
        updateStatus("⚠️ Comandante saiu. Selecione outro.", Color3.fromRGB(255, 200, 100))
    end
    task.wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

-- ==================
-- BOTÕES GUI
-- ==================

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedBall.Visible = true
end)

MinimizedBall.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedBall.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = false
    ScreenGui:Destroy()
end)

-- Atalho P para Hitbox
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        _G.HitboxEnabled = not _G.HitboxEnabled
        if _G.HitboxEnabled then
            HitboxToggle.Text = "DESATIVAR HITBOX"
            HitboxToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        else
            HitboxToggle.Text = "ATIVAR HITBOX"
            HitboxToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        updateTeamButton()
    end
end)

print("✅ Combat GUI Completo carregado! Mobile: " .. tostring(isMobile))
