-- Combat GUI Script - Versão Completa com ESP e Fullbright
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configurações globais
_G.HeadSize = 20
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

-- Configurações Auto Volver
_G.SelectedCommander = nil
_G.AutoVolverEnabled = true
_G.RotationSpeed = 2
_G.CommandDelay = 1

-- Comandos do Volver
local VolverCommands = {
    ["Direita, volver."] = -90,
    ["Esquerda, volver."] = 90,
    ["Direita, inclinar."] = -45,
    ["Esquerda, inclinar."] = 45,
    ["Retaguarda, volver."] = 180,
    ["/a Direita, volver."] = -90,
    ["/a Esquerda, volver."] = 90,
    ["/a Direita, inclinar."] = -45,
    ["/a Esquerda, inclinar."] = 45,
    ["/a Retaguarda, volver."] = 180,
    ["/A Direita, volver."] = -90,
    ["/A Esquerda, volver."] = 90,
    ["/A Direita, inclinar."] = -45,
    ["/A Esquerda, inclinar."] = 45,
    ["/A Retaguarda, volver."] = 180
}

-- Variáveis ESP
local ESPObjects = {}

-- Variáveis Fullbright
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

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"

-- Detectar se é mobile ou PC
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if isMobile then
    -- Tamanho para Mobile (menor)
    MainFrame.Size = UDim2.new(0, 340, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
else
    -- Tamanho para PC
    MainFrame.Size = UDim2.new(0, 400, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -240)
end

MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "Combat GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = isMobile and 16 or 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botão Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Position = UDim2.new(1, -75, 0, 2.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = MainFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -37.5, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
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
MinimizedBall.Name = "MinimizedBall"
MinimizedBall.Size = UDim2.new(0, 60, 0, 60)
MinimizedBall.Position = UDim2.new(1, -70, 0, 10)
MinimizedBall.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinimizedBall.BorderSizePixel = 0
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
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

-- Botões das Abas
local CombatTab = Instance.new("TextButton")
CombatTab.Name = "CombatTab"
CombatTab.Size = UDim2.new(0.25, -3, 1, 0)
CombatTab.Position = UDim2.new(0, 2, 0, 0)
CombatTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CombatTab.BorderSizePixel = 0
CombatTab.Text = isMobile and "⚔️" or "⚔️ COMBATE"
CombatTab.TextColor3 = Color3.fromRGB(255, 255, 255)
CombatTab.TextSize = isMobile and 16 or 12
CombatTab.Font = Enum.Font.GothamBold
CombatTab.Parent = TabContainer

local CombatTabCorner = Instance.new("UICorner")
CombatTabCorner.CornerRadius = UDim.new(0, 6)
CombatTabCorner.Parent = CombatTab

local PlayerTab = Instance.new("TextButton")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(0.25, -3, 1, 0)
PlayerTab.Position = UDim2.new(0.25, 1, 0, 0)
PlayerTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerTab.BorderSizePixel = 0
PlayerTab.Text = isMobile and "👤" or "👤 PLAYER"
PlayerTab.TextColor3 = Color3.fromRGB(180, 180, 180)
PlayerTab.TextSize = isMobile and 16 or 12
PlayerTab.Font = Enum.Font.GothamBold
PlayerTab.Parent = TabContainer

local PlayerTabCorner = Instance.new("UICorner")
PlayerTabCorner.CornerRadius = UDim.new(0, 6)
PlayerTabCorner.Parent = PlayerTab

local VisualTab = Instance.new("TextButton")
VisualTab.Name = "VisualTab"
VisualTab.Size = UDim2.new(0.25, -3, 1, 0)
VisualTab.Position = UDim2.new(0.5, 0, 0, 0)
VisualTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
VisualTab.BorderSizePixel = 0
VisualTab.Text = isMobile and "👁️" or "👁️ VISUAL"
VisualTab.TextColor3 = Color3.fromRGB(180, 180, 180)
VisualTab.TextSize = isMobile and 16 or 12
VisualTab.Font = Enum.Font.GothamBold
VisualTab.Parent = TabContainer

local VisualTabCorner = Instance.new("UICorner")
VisualTabCorner.CornerRadius = UDim.new(0, 6)
VisualTabCorner.Parent = VisualTab

local VolverTab = Instance.new("TextButton")
VolverTab.Name = "VolverTab"
VolverTab.Size = UDim2.new(0.25, -3, 1, 0)
VolverTab.Position = UDim2.new(0.75, 1, 0, 0)
VolverTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
VolverTab.BorderSizePixel = 0
VolverTab.Text = isMobile and "🎖️" or "🎖️ VOLVER"
VolverTab.TextColor3 = Color3.fromRGB(180, 180, 180)
VolverTab.TextSize = isMobile and 16 or 12
VolverTab.Font = Enum.Font.GothamBold
VolverTab.Parent = TabContainer

local VolverTabCorner = Instance.new("UICorner")
VolverTabCorner.CornerRadius = UDim.new(0, 6)
VolverTabCorner.Parent = VolverTab

-- Frames das abas
local CombatFrame = Instance.new("Frame")
CombatFrame.Name = "CombatFrame"
CombatFrame.Size = UDim2.new(1, 0, 1, -80)
CombatFrame.Position = UDim2.new(0, 0, 0, 80)
CombatFrame.BackgroundTransparency = 1
CombatFrame.Visible = true
CombatFrame.Parent = MainFrame

local PlayerFrame = Instance.new("Frame")
PlayerFrame.Name = "PlayerFrame"
PlayerFrame.Size = UDim2.new(1, 0, 1, -80)
PlayerFrame.Position = UDim2.new(0, 0, 0, 80)
PlayerFrame.BackgroundTransparency = 1
PlayerFrame.Visible = false
PlayerFrame.Parent = MainFrame

local VisualFrame = Instance.new("Frame")
VisualFrame.Name = "VisualFrame"
VisualFrame.Size = UDim2.new(1, 0, 1, -80)
VisualFrame.Position = UDim2.new(0, 0, 0, 80)
VisualFrame.BackgroundTransparency = 1
VisualFrame.Visible = false
VisualFrame.Parent = MainFrame

local VolverFrame = Instance.new("Frame")
VolverFrame.Name = "VolverFrame"
VolverFrame.Size = UDim2.new(1, 0, 1, -80)
VolverFrame.Position = UDim2.new(0, 0, 0, 80)
VolverFrame.BackgroundTransparency = 1
VolverFrame.Visible = false
VolverFrame.Parent = MainFrame

-- Função trocar abas
local function switchTab(tab)
    -- Reset cores
    CombatTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CombatTab.TextColor3 = Color3.fromRGB(180, 180, 180)
    PlayerTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    PlayerTab.TextColor3 = Color3.fromRGB(180, 180, 180)
    VisualTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    VisualTab.TextColor3 = Color3.fromRGB(180, 180, 180)
    VolverTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    VolverTab.TextColor3 = Color3.fromRGB(180, 180, 180)
    
    -- Esconder todos
    CombatFrame.Visible = false
    PlayerFrame.Visible = false
    VisualFrame.Visible = false
    VolverFrame.Visible = false
    
    if tab == "Combat" then
        CombatTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        CombatTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        CombatFrame.Visible = true
    elseif tab == "Player" then
        PlayerTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        PlayerTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerFrame.Visible = true
    elseif tab == "Visual" then
        VisualTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        VisualTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        VisualFrame.Visible = true
    else
        VolverTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        VolverTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        VolverFrame.Visible = true
    end
end

CombatTab.MouseButton1Click:Connect(function() switchTab("Combat") end)
PlayerTab.MouseButton1Click:Connect(function() switchTab("Player") end)
VisualTab.MouseButton1Click:Connect(function() switchTab("Visual") end)
VolverTab.MouseButton1Click:Connect(function() switchTab("Volver") end)

-- ==================
-- ABA COMBATE
-- ==================

local CombatLabel = Instance.new("TextLabel")
CombatLabel.Size = UDim2.new(1, -20, 0, 30)
CombatLabel.Position = UDim2.new(0, 10, 0, 10)
CombatLabel.BackgroundTransparency = 1
CombatLabel.Text = "⚔️ COMBATE"
CombatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CombatLabel.TextSize = isMobile and 16 or 18
CombatLabel.Font = Enum.Font.GothamBold
CombatLabel.TextXAlignment = Enum.TextXAlignment.Left
CombatLabel.Parent = CombatFrame

local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, -20, 0, 25)
SizeLabel.Position = UDim2.new(0, 10, 0, 50)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Tamanho da Hitbox: 20"
SizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SizeLabel.TextSize = isMobile and 12 or 14
SizeLabel.Font = Enum.Font.Gotham
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.Parent = CombatFrame

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, -40, 0, 20)
SliderFrame.Position = UDim2.new(0, 20, 0, 80)
SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderFrame.BorderSizePixel = 0
SliderFrame.Parent = CombatFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 10)
SliderCorner.Parent = SliderFrame

local SliderButton = Instance.new("Frame")
SliderButton.Size = UDim2.new(0.19, 0, 1, 0)
SliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderFrame

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(0, 10)
SliderButtonCorner.Parent = SliderButton

local dragging = false
SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        MainFrame.Draggable = false -- DESABILITA arrasto da GUI
    end
end)

SliderFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        MainFrame.Draggable = true -- REABILITA arrasto da GUI
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouse = LocalPlayer:GetMouse()
        local relativeX = math.clamp(mouse.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X)
        local percent = relativeX / SliderFrame.AbsoluteSize.X
        SliderButton.Size = UDim2.new(percent, 0, 1, 0)
        
        _G.HeadSize = math.floor(1 + (percent * 99))
        SizeLabel.Text = "Tamanho da Hitbox: " .. _G.HeadSize
    end
end)

local TeamToggle = Instance.new("TextButton")
TeamToggle.Size = UDim2.new(1, -40, 0, 40)
TeamToggle.Position = UDim2.new(0, 20, 0, 120)
TeamToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TeamToggle.BorderSizePixel = 0
TeamToggle.Text = "Hitbox Team: OFF (Desativado)"
TeamToggle.TextColor3 = Color3.fromRGB(120, 120, 120)
TeamToggle.TextSize = isMobile and 13 or 16
TeamToggle.Font = Enum.Font.GothamBold
TeamToggle.Parent = CombatFrame

local TeamToggleCorner = Instance.new("UICorner")
TeamToggleCorner.CornerRadius = UDim.new(0, 8)
TeamToggleCorner.Parent = TeamToggle

local HitboxToggle = Instance.new("TextButton")
HitboxToggle.Size = UDim2.new(1, -40, 0, 50)
HitboxToggle.Position = UDim2.new(0, 20, 0, 180)
HitboxToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HitboxToggle.BorderSizePixel = 0
HitboxToggle.Text = "ATIVAR HITBOX"
HitboxToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxToggle.TextSize = isMobile and 15 or 18
HitboxToggle.Font = Enum.Font.GothamBold
HitboxToggle.Parent = CombatFrame

local HitboxToggleCorner = Instance.new("UICorner")
HitboxToggleCorner.CornerRadius = UDim.new(0, 8)
HitboxToggleCorner.Parent = HitboxToggle

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
            TeamToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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
        HitboxToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        for _, v in pairs(Players:GetPlayers()) do
            if v.Name ~= LocalPlayer.Name then
                pcall(function()
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end
    updateTeamButton()
end)

-- ==================
-- ABA PLAYER
-- ==================

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -40, 0, 50)
NoclipToggle.Position = UDim2.new(0, 20, 0, 10)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoclipToggle.BorderSizePixel = 0
NoclipToggle.Text = "ATIVAR NOCLIP"
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.TextSize = 18
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.Parent = PlayerFrame

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 8)
NoclipCorner.Parent = NoclipToggle

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -20, 0, 25)
SpeedLabel.Position = UDim2.new(0, 10, 0, 80)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidade: 16 (Desativado)"
SpeedLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = PlayerFrame

local SpeedSliderFrame = Instance.new("Frame")
SpeedSliderFrame.Size = UDim2.new(1, -100, 0, 20)
SpeedSliderFrame.Position = UDim2.new(0, 20, 0, 110)
SpeedSliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSliderFrame.BorderSizePixel = 0
SpeedSliderFrame.Parent = PlayerFrame

local SpeedSliderCorner = Instance.new("UICorner")
SpeedSliderCorner.CornerRadius = UDim.new(0, 10)
SpeedSliderCorner.Parent = SpeedSliderFrame

local SpeedSliderButton = Instance.new("Frame")
SpeedSliderButton.Size = UDim2.new(0.066, 0, 1, 0)
SpeedSliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SpeedSliderButton.BorderSizePixel = 0
SpeedSliderButton.Parent = SpeedSliderFrame

local SpeedSliderButtonCorner = Instance.new("UICorner")
SpeedSliderButtonCorner.CornerRadius = UDim.new(0, 10)
SpeedSliderButtonCorner.Parent = SpeedSliderButton

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 70, 0, 35)
SpeedToggle.Position = UDim2.new(1, -90, 0, 102)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedToggle.BorderSizePixel = 0
SpeedToggle.Text = "OFF"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
SpeedToggle.TextSize = 14
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.Parent = PlayerFrame

local SpeedToggleCorner = Instance.new("UICorner")
SpeedToggleCorner.CornerRadius = UDim.new(0, 8)
SpeedToggleCorner.Parent = SpeedToggle

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(1, -20, 0, 25)
JumpLabel.Position = UDim2.new(0, 10, 0, 160)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "Pulo: 50 (Desativado)"
JumpLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
JumpLabel.TextSize = 14
JumpLabel.Font = Enum.Font.Gotham
JumpLabel.TextXAlignment = Enum.TextXAlignment.Left
JumpLabel.Parent = PlayerFrame

local JumpSliderFrame = Instance.new("Frame")
JumpSliderFrame.Size = UDim2.new(1, -100, 0, 20)
JumpSliderFrame.Position = UDim2.new(0, 20, 0, 190)
JumpSliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpSliderFrame.BorderSizePixel = 0
JumpSliderFrame.Parent = PlayerFrame

local JumpSliderCorner = Instance.new("UICorner")
JumpSliderCorner.CornerRadius = UDim.new(0, 10)
JumpSliderCorner.Parent = JumpSliderFrame

local JumpSliderButton = Instance.new("Frame")
JumpSliderButton.Size = UDim2.new(0.444, 0, 1, 0)
JumpSliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
JumpSliderButton.BorderSizePixel = 0
JumpSliderButton.Parent = JumpSliderFrame

local JumpSliderButtonCorner = Instance.new("UICorner")
JumpSliderButtonCorner.CornerRadius = UDim.new(0, 10)
JumpSliderButtonCorner.Parent = JumpSliderButton

local JumpToggle = Instance.new("TextButton")
JumpToggle.Size = UDim2.new(0, 70, 0, 35)
JumpToggle.Position = UDim2.new(1, -90, 0, 182)
JumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
JumpToggle.BorderSizePixel = 0
JumpToggle.Text = "OFF"
JumpToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
JumpToggle.TextSize = 14
JumpToggle.Font = Enum.Font.GothamBold
JumpToggle.Parent = PlayerFrame

local JumpToggleCorner = Instance.new("UICorner")
JumpToggleCorner.CornerRadius = UDim.new(0, 8)
JumpToggleCorner.Parent = JumpToggle

local AntiAFKToggle = Instance.new("TextButton")
AntiAFKToggle.Size = UDim2.new(1, -40, 0, 50)
AntiAFKToggle.Position = UDim2.new(0, 20, 0, 240)
AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
AntiAFKToggle.BorderSizePixel = 0
AntiAFKToggle.Text = "ANTI-AFK: ON"
AntiAFKToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
AntiAFKToggle.TextSize = 18
AntiAFKToggle.Font = Enum.Font.GothamBold
AntiAFKToggle.Parent = PlayerFrame

local AntiAFKCorner = Instance.new("UICorner")
AntiAFKCorner.CornerRadius = UDim.new(0, 8)
AntiAFKCorner.Parent = AntiAFKToggle

-- Botão Pegar Arma AS VAL
local GetWeaponButton = Instance.new("TextButton")
GetWeaponButton.Size = UDim2.new(1, -40, 0, 50)
GetWeaponButton.Position = UDim2.new(0, 20, 0, 300)
GetWeaponButton.BackgroundColor3 = Color3.fromRGB(80, 60, 100)
GetWeaponButton.BorderSizePixel = 0
GetWeaponButton.Text = "PEGAR ARMA AS VAL"
GetWeaponButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetWeaponButton.TextSize = 18
GetWeaponButton.Font = Enum.Font.GothamBold
GetWeaponButton.Parent = PlayerFrame

local GetWeaponCorner = Instance.new("UICorner")
GetWeaponCorner.CornerRadius = UDim.new(0, 8)
GetWeaponCorner.Parent = GetWeaponButton

-- ==================
-- ABA VISUAL
-- ==================

local VisualLabel = Instance.new("TextLabel")
VisualLabel.Size = UDim2.new(1, -20, 0, 30)
VisualLabel.Position = UDim2.new(0, 10, 0, 10)
VisualLabel.BackgroundTransparency = 1
VisualLabel.Text = "👁️ VISUAL"
VisualLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VisualLabel.TextSize = 18
VisualLabel.Font = Enum.Font.GothamBold
VisualLabel.TextXAlignment = Enum.TextXAlignment.Left
VisualLabel.Parent = VisualFrame

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(1, -40, 0, 50)
ESPToggle.Position = UDim2.new(0, 20, 0, 50)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPToggle.BorderSizePixel = 0
ESPToggle.Text = "ATIVAR ESP"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.TextSize = 18
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.Parent = VisualFrame

local ESPToggleCorner = Instance.new("UICorner")
ESPToggleCorner.CornerRadius = UDim.new(0, 8)
ESPToggleCorner.Parent = ESPToggle

-- ESP Team Toggle
local ESPTeamToggle = Instance.new("TextButton")
ESPTeamToggle.Size = UDim2.new(1, -40, 0, 50)
ESPTeamToggle.Position = UDim2.new(0, 20, 0, 110)
ESPTeamToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPTeamToggle.BorderSizePixel = 0
ESPTeamToggle.Text = "ESP NO MEU TIME"
ESPTeamToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTeamToggle.TextSize = 18
ESPTeamToggle.Font = Enum.Font.GothamBold
ESPTeamToggle.Parent = VisualFrame

local ESPTeamCorner = Instance.new("UICorner")
ESPTeamCorner.CornerRadius = UDim.new(0, 8)
ESPTeamCorner.Parent = ESPTeamToggle

-- Fullbright Toggle
local FullbrightToggle = Instance.new("TextButton")
FullbrightToggle.Size = UDim2.new(1, -40, 0, 50)
FullbrightToggle.Position = UDim2.new(0, 20, 0, 170)
FullbrightToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FullbrightToggle.BorderSizePixel = 0
FullbrightToggle.Text = "ATIVAR FULLBRIGHT"
FullbrightToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FullbrightToggle.TextSize = 18
FullbrightToggle.Font = Enum.Font.GothamBold
FullbrightToggle.Parent = VisualFrame

local FullbrightCorner = Instance.new("UICorner")
FullbrightCorner.CornerRadius = UDim.new(0, 8)
FullbrightCorner.Parent = FullbrightToggle

-- ==================
-- FUNÇÕES
-- ==================

-- Noclip
NoclipToggle.MouseButton1Click:Connect(function()
    _G.NoclipEnabled = not _G.NoclipEnabled
    if _G.NoclipEnabled then
        NoclipToggle.Text = "DESATIVAR NOCLIP"
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        NoclipToggle.Text = "ATIVAR NOCLIP"
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Speed Slider
local draggingSpeed = false
SpeedSliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeed = true
        MainFrame.Draggable = false
    end
end)

SpeedSliderFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeed = false
        MainFrame.Draggable = true
    end
end)

local function updateSpeedLabel()
    if _G.SpeedEnabled then
        SpeedLabel.Text = "Velocidade: " .. _G.SpeedValue
        SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        SpeedLabel.Text = "Velocidade: " .. _G.SpeedValue .. " (Desativado)"
        SpeedLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

RunService.RenderStepped:Connect(function()
    if draggingSpeed then
        local mouse = LocalPlayer:GetMouse()
        local relativeX = math.clamp(mouse.X - SpeedSliderFrame.AbsolutePosition.X, 0, SpeedSliderFrame.AbsoluteSize.X)
        local percent = relativeX / SpeedSliderFrame.AbsoluteSize.X
        SpeedSliderButton.Size = UDim2.new(percent, 0, 1, 0)
        
        _G.SpeedValue = math.floor(10 + (percent * 90))
        updateSpeedLabel()
    end
end)

SpeedToggle.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    if _G.SpeedEnabled then
        SpeedToggle.Text = "ON"
        SpeedToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    else
        SpeedToggle.Text = "OFF"
        SpeedToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    updateSpeedLabel()
end)

-- Jump Slider
local draggingJump = false
JumpSliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingJump = true
        MainFrame.Draggable = false
    end
end)

JumpSliderFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingJump = false
        MainFrame.Draggable = true
    end
end)

local function updateJumpLabel()
    if _G.JumpEnabled then
        JumpLabel.Text = "Pulo: " .. _G.JumpValue
        JumpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        JumpLabel.Text = "Pulo: " .. _G.JumpValue .. " (Desativado)"
        JumpLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

RunService.RenderStepped:Connect(function()
    if draggingJump then
        local mouse = LocalPlayer:GetMouse()
        local relativeX = math.clamp(mouse.X - JumpSliderFrame.AbsolutePosition.X, 0, JumpSliderFrame.AbsoluteSize.X)
        local percent = relativeX / JumpSliderFrame.AbsoluteSize.X
        JumpSliderButton.Size = UDim2.new(percent, 0, 1, 0)
        
        _G.JumpValue = math.floor(10 + (percent * 90))
        updateJumpLabel()
    end
end)

JumpToggle.MouseButton1Click:Connect(function()
    _G.JumpEnabled = not _G.JumpEnabled
    if _G.JumpEnabled then
        JumpToggle.Text = "ON"
        JumpToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        JumpToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    else
        JumpToggle.Text = "OFF"
        JumpToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        JumpToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    updateJumpLabel()
end)

-- Anti-AFK
AntiAFKToggle.MouseButton1Click:Connect(function()
    _G.AntiAFKEnabled = not _G.AntiAFKEnabled
    if _G.AntiAFKEnabled then
        AntiAFKToggle.Text = "ANTI-AFK: ON"
        AntiAFKToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    else
        AntiAFKToggle.Text = "ANTI-AFK: OFF"
        AntiAFKToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        AntiAFKToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Função Pegar Arma AS VAL
local function getASVAL()
    local pos1 = Vector3.new(119.21, 13.00, 194.23)
    local pos2 = Vector3.new(228.34, 21.51, 9.05)
    
    local function teleportAndInteract(position)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            wait(0.3)
            -- Simular pressionar E
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
            wait(5) -- Aguardar respawn
        end
    end
    
    -- Ciclo 1: Teleporta pos1 → E → Teleporta pos2 → E → Reseta
    teleportAndInteract(pos1)
    teleportAndInteract(pos2)
    resetCharacter()
    
    -- Ciclo 2: Teleporta pos1 → E → Teleporta pos2 → E → Reseta
    teleportAndInteract(pos1)
    teleportAndInteract(pos2)
    resetCharacter()
    
    -- Ciclo 3: Teleporta pos1 → E → Teleporta pos2 → E (SEM RESET)
    teleportAndInteract(pos1)
    teleportAndInteract(pos2)
    
    GetWeaponButton.Text = "✅ ARMA COLETADA!"
    GetWeaponButton.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
    wait(2)
    GetWeaponButton.Text = "PEGAR ARMA AS VAL"
    GetWeaponButton.BackgroundColor3 = Color3.fromRGB(80, 60, 100)
end

GetWeaponButton.MouseButton1Click:Connect(function()
    GetWeaponButton.Text = "⏳ COLETANDO..."
    GetWeaponButton.BackgroundColor3 = Color3.fromRGB(100, 100, 40)
    
    spawn(function()
        pcall(function()
            getASVAL()
        end)
    end)
end)

-- ESP Toggle
ESPToggle.MouseButton1Click:Connect(function()
    _G.ESPEnabled = not _G.ESPEnabled
    if _G.ESPEnabled then
        ESPToggle.Text = "DESATIVAR ESP"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        ESPToggle.Text = "ATIVAR ESP"
        ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- ESP Team Toggle
ESPTeamToggle.MouseButton1Click:Connect(function()
    _G.TeamESPEnabled = not _G.TeamESPEnabled
    if _G.TeamESPEnabled then
        ESPTeamToggle.Text = "DESATIVAR ESP NO TIME"
        ESPTeamToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        ESPTeamToggle.Text = "ESP NO MEU TIME"
        ESPTeamToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Fullbright Toggle
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
        FullbrightToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Minimizar/Maximizar
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedBall.Visible = true
end)

MinimizedBall.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedBall.Visible = false
end)

-- Fechar
CloseButton.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = false
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name ~= LocalPlayer.Name then
            pcall(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = v.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                end
            end)
        end
    end
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
            HitboxToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            for _, v in pairs(Players:GetPlayers()) do
                if v.Name ~= LocalPlayer.Name then
                    pcall(function()
                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = v.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                            hrp.CanCollide = false
                        end
                    end)
                end
            end
        end
        updateTeamButton()
    end
end)

-- Sistema Anti-AFK
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Sistema Noclip
RunService.Stepped:Connect(function()
    if _G.NoclipEnabled then
        pcall(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Sistema Speed e Jump
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

-- Sistema Hitbox
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
                    if shouldApply and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        hrp.Transparency = 0.7
                        if v.Team then
                            hrp.BrickColor = v.Team.TeamColor
                        else
                            hrp.BrickColor = BrickColor.new("Really blue")
                        end
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end
end)

-- Sistema ESP
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
local lastCommandTime = 0
local commandCooldown = 1

local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

local function createPlayerButton(player)
    local Button = Instance.new("TextButton")
    Button.Name = player.Name
    Button.Size = UDim2.new(1, -10, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
    Button.Text = "  " .. player.Name
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 12
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
                btn.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
                local ind = btn:FindFirstChild("Indicator")
                if ind then ind.Visible = false end
            end
        end
        
        Button.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
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
        if player ~= LocalPlayer then
            createPlayerButton(player)
        end
    end
end

local function rotateCharacter(degrees)
    local currentTime = tick()
    if currentTime - lastCommandTime < commandCooldown then
        return false
    end
    
    if isRotating then
        return false
    end
    
    if not LocalPlayer.Character then return false end
    local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return false end
    
    isRotating = true
    lastCommandTime = currentTime
    
    local currentCFrame = HumanoidRootPart.CFrame
    local currentPosition = currentCFrame.Position
    local targetCFrame = currentCFrame * CFrame.Angles(0, math.rad(degrees), 0)
    targetCFrame = CFrame.new(currentPosition.X, currentPosition.Y, currentPosition.Z) * (targetCFrame - targetCFrame.Position)
    
    local tweenInfo = TweenInfo.new(_G.RotationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween.Completed:Connect(function()
        isRotating = false
    end)
    
    tween:Play()
    return true
end

local function processCommand(message, speaker)
    if not _G.SelectedCommander or speaker.UserId ~= _G.SelectedCommander.UserId then
        return
    end
    
    if not _G.AutoVolverEnabled then return end
    
    local angle = VolverCommands[message]
    
    if angle then
        updateStatus("⏳ Comando recebido! Executando em 1 segundo...", Color3.fromRGB(255, 255, 100))
        wait(_G.CommandDelay)
        
        local success = rotateCharacter(angle)
        if success then
            updateStatus(string.format("🔄 Executando: %s (%d°)", message, math.abs(angle)), Color3.fromRGB(255, 255, 100))
            wait(_G.RotationSpeed + 0.5)
            if _G.SelectedCommander then
                updateStatus("✅ Aguardando comandos de " .. _G.SelectedCommander.Name, Color3.fromRGB(100, 255, 100))
            end
        end
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
    wait(0.5)
    updatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if _G.SelectedCommander and player == _G.SelectedCommander then
        _G.SelectedCommander = nil
        CommanderLabel.Text = "👤 Comandante: Nenhum"
        CommanderLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        updateStatus("⚠️ Comandante saiu.\nSelecione outro.", Color3.fromRGB(255, 200, 100))
    end
    wait(0.5)
    updatePlayerList()
end)

updatePlayerList()

print("Combat GUI Completo carregado!")
