-- ═══════════════════════════════════════════════════════════════
--     SCRIPT COMPLETO - AIMLOCK + FARM + ANTI-AFK (MOBILE/PC)
-- ═══════════════════════════════════════════════════════════════

repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- ═══════════════════════════════════════════════════════════════
--                    DETECÇÃO DE PLATAFORMA
-- ═══════════════════════════════════════════════════════════════

local UserInputService = game:GetService("UserInputService")
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local IsPC = UserInputService.KeyboardEnabled

print("════════════════════════════════════════════════")
if IsMobile then
    print("📱 PLATAFORMA: MOBILE DETECTADO")
    print("✅ Controles touch habilitados")
else
    print("💻 PLATAFORMA: PC DETECTADO")
    print("✅ Controles de teclado habilitados")
end
print("════════════════════════════════════════════════")

-- Configurações AimLock (adaptadas para cada plataforma)
local AimSettings = {
    AimKey = Enum.KeyCode.E,
    TeamCheck = true,
    FOV = IsMobile and 80 or 40, -- FOV maior para mobile
    TargetPart = "Head",
    Smoothness = 0,
    FOVColor = Color3.fromRGB(128, 0, 128),
    UseTeamColor = true,
    ESPForAll = true,
}

-- Configurações Auto Farm
local FarmSettings = {
    Position1 = Vector3.new(118.28, 13.00, 193.00),
    Position2 = Vector3.new(228.86, 21.19, 8.67),
    TeleportDelay = 1,
    KeyPressDelay = 0.5,
    MovementAmount = 3,
    TotalCycles = 3,
    RespawnWaitTime = 3,
}

-- Serviços
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis AimLock
local AimLockEnabled = false
local LockedPlayer = nil
local ESPObjects = {}

-- Variáveis Auto Farm
local AutoFarmEnabled = false
local CurrentCycle = 0

-- Variáveis Anti-AFK
local AntiAFKEnabled = true
local PlayTime = {hours = 0, minutes = 0, seconds = 0}

-- Variáveis Fullbright
local FullbrightEnabled = false
local OriginalLightingSettings = {}

-- Criar FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = AimSettings.FOVColor
FOVCircle.Filled = false
FOVCircle.Radius = AimSettings.FOV
FOVCircle.Visible = false
FOVCircle.Transparency = 1
FOVCircle.NumSides = 64

-- ═══════════════════════════════════════════════════════════════
--                    ANTI-AFK SYSTEM
-- ═══════════════════════════════════════════════════════════════

local VirtualUser = game:GetService('VirtualUser')

LocalPlayer.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("Anti-AFK ativado!")
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                    FULLBRIGHT SYSTEM
-- ═══════════════════════════════════════════════════════════════

local function SaveOriginalLighting()
    OriginalLightingSettings = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ClockTime = Lighting.ClockTime,
        GeographicLatitude = Lighting.GeographicLatitude,
        GlobalShadows = Lighting.GlobalShadows,
        Technology = Lighting.Technology
    }
end

local function EnableFullbright()
    SaveOriginalLighting()
    
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    Lighting.EnvironmentDiffuseScale = 1
    Lighting.EnvironmentSpecularScale = 1
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.ClockTime = 14
    Lighting.GeographicLatitude = 0
    Lighting.GlobalShadows = false
    
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or 
           effect:IsA("ColorCorrectionEffect") or 
           effect:IsA("SunRaysEffect") or 
           effect:IsA("BloomEffect") or
           effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = false
        end
    end
    
    print("Fullbright ativado!")
end

local function DisableFullbright()
    if next(OriginalLightingSettings) ~= nil then
        for property, value in pairs(OriginalLightingSettings) do
            pcall(function()
                Lighting[property] = value
            end)
        end
    end
    
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or 
           effect:IsA("ColorCorrectionEffect") or 
           effect:IsA("SunRaysEffect") or 
           effect:IsA("BloomEffect") or
           effect:IsA("DepthOfFieldEffect") then
            effect.Enabled = true
        end
    end
    
    print("Fullbright desativado!")
end

-- ═══════════════════════════════════════════════════════════════
--                    CRIAR UI RESPONSIVA (MOBILE/PC)
-- ═══════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Tamanhos adaptados para cada plataforma
local UIScale = IsMobile and 1.2 or 1
local MainFrameWidth = IsMobile and 380 or 350
local MainFrameHeight = IsMobile and 480 or 430

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, MainFrameWidth, 0, MainFrameHeight)
MainFrame.Position = UDim2.new(0.5, -MainFrameWidth/2, 0.5, -MainFrameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, IsMobile and 60 or 50)
Header.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = IsMobile and "🎯 MOBILE MODE" or "🎯 AIMLOCK + AS VAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = IsMobile and 22 or 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, IsMobile and 50 or 40, 0, IsMobile and 50 or 40)
MinimizeButton.Position = UDim2.new(1, IsMobile and -105 or -90, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = IsMobile and 30 or 25
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, IsMobile and 50 or 40, 0, IsMobile and 50 or 40)
CloseButton.Position = UDim2.new(1, IsMobile and -50 or -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = IsMobile and 24 or 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, IsMobile and -60 or -50)
ContentFrame.Position = UDim2.new(0, 0, 0, IsMobile and 60 or 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Função para criar labels
local function CreateStatusLabel(name, text, position, parent)
    local Label = Instance.new("TextLabel")
    Label.Name = name
    Label.Size = UDim2.new(0, MainFrameWidth - 50, 0, IsMobile and 35 or 30)
    Label.Position = position
    Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = IsMobile and 16 or 14
    Label.Font = Enum.Font.Gotham
    Label.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Label
    
    return Label
end

-- Info AimLock
local aimInfoText = IsMobile and "Ativar AimLock: Botão 🎯" or "Ativar AimLock: Tecla E"
local AimInfo = CreateStatusLabel("AimInfo", aimInfoText, UDim2.new(0, 25, 0, 20), ContentFrame)

-- Botão Pegar AS VAL
local PegarValButton = Instance.new("TextButton")
PegarValButton.Name = "PegarValButton"
PegarValButton.Size = UDim2.new(0, MainFrameWidth - 50, 0, IsMobile and 70 or 60)
PegarValButton.Position = UDim2.new(0, 25, 0, IsMobile and 70 or 65)
PegarValButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
PegarValButton.Text = "⚡ PEGAR AS VAL"
PegarValButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PegarValButton.TextSize = IsMobile and 22 or 20
PegarValButton.Font = Enum.Font.GothamBold
PegarValButton.Parent = ContentFrame

local ValCorner = Instance.new("UICorner")
ValCorner.CornerRadius = UDim.new(0, 8)
ValCorner.Parent = PegarValButton

-- Status Farm
local FarmStatus = CreateStatusLabel("FarmStatus", "Aguardando...", UDim2.new(0, 25, 0, IsMobile and 155 or 140), ContentFrame)

-- Botão Fullbright
local FullbrightButton = Instance.new("TextButton")
FullbrightButton.Name = "FullbrightButton"
FullbrightButton.Size = UDim2.new(0, MainFrameWidth - 50, 0, IsMobile and 50 or 40)
FullbrightButton.Position = UDim2.new(0, 25, 0, IsMobile and 205 or 185)
FullbrightButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FullbrightButton.Text = "💡 BRILHO: OFF"
FullbrightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FullbrightButton.TextSize = IsMobile and 18 or 16
FullbrightButton.Font = Enum.Font.GothamBold
FullbrightButton.Parent = ContentFrame

local FullbrightCorner = Instance.new("UICorner")
FullbrightCorner.CornerRadius = UDim.new(0, 8)
FullbrightCorner.Parent = FullbrightButton

-- Separador
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, MainFrameWidth - 50, 0, 2)
Separator.Position = UDim2.new(0, 25, 0, IsMobile and 270 or 240)
Separator.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
Separator.BorderSizePixel = 0
Separator.Parent = ContentFrame

-- Anti-AFK Info Frame
local AntiAFKFrame = Instance.new("Frame")
AntiAFKFrame.Size = UDim2.new(0, MainFrameWidth - 50, 0, IsMobile and 130 or 120)
AntiAFKFrame.Position = UDim2.new(0, 25, 0, IsMobile and 285 or 255)
AntiAFKFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AntiAFKFrame.BorderSizePixel = 0
AntiAFKFrame.Parent = ContentFrame

local AntiAFKCorner = Instance.new("UICorner")
AntiAFKCorner.CornerRadius = UDim.new(0, 8)
AntiAFKCorner.Parent = AntiAFKFrame

local AntiAFKTitle = Instance.new("TextLabel")
AntiAFKTitle.Size = UDim2.new(1, -20, 0, IsMobile and 30 or 25)
AntiAFKTitle.Position = UDim2.new(0, 10, 0, 5)
AntiAFKTitle.BackgroundTransparency = 1
AntiAFKTitle.Text = "🛡️ ANTI-AFK ATIVO"
AntiAFKTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
AntiAFKTitle.TextSize = IsMobile and 18 or 16
AntiAFKTitle.Font = Enum.Font.GothamBold
AntiAFKTitle.Parent = AntiAFKFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, -20, 0, IsMobile and 25 or 20)
TimerLabel.Position = UDim2.new(0, 10, 0, IsMobile and 40 or 35)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "⏱️ Tempo: 0:0:0"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.TextSize = IsMobile and 16 or 14
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.Parent = AntiAFKFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, -20, 0, IsMobile and 25 or 20)
FPSLabel.Position = UDim2.new(0, 10, 0, IsMobile and 70 or 60)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "📊 FPS: 60"
FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSLabel.TextSize = IsMobile and 16 or 14
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = AntiAFKFrame

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(1, -20, 0, IsMobile and 25 or 20)
PingLabel.Position = UDim2.new(0, 10, 0, IsMobile and 100 or 85)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "📡 Ping: 0"
PingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PingLabel.TextSize = IsMobile and 16 or 14
PingLabel.Font = Enum.Font.Gotham
PingLabel.TextXAlignment = Enum.TextXAlignment.Left
PingLabel.Parent = AntiAFKFrame

-- ═══════════════════════════════════════════════════════════════
--          BOTÃO FLUTUANTE DE AIMLOCK (APENAS MOBILE)
-- ═══════════════════════════════════════════════════════════════

local AimLockButton = nil

if IsMobile then
    AimLockButton = Instance.new("TextButton")
    AimLockButton.Name = "AimLockButton"
    AimLockButton.Size = UDim2.new(0, 80, 0, 80)
    AimLockButton.Position = UDim2.new(1, -100, 0.5, -40)
    AimLockButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    AimLockButton.Text = "🎯"
    AimLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimLockButton.TextSize = 40
    AimLockButton.Font = Enum.Font.GothamBold
    AimLockButton.Active = true
    AimLockButton.Draggable = true
    AimLockButton.ZIndex = 10
    AimLockButton.Parent = ScreenGui
    
    local AimButtonCorner = Instance.new("UICorner")
    AimButtonCorner.CornerRadius = UDim.new(1, 0)
    AimButtonCorner.Parent = AimLockButton
    
    -- Sombra no botão
    local AimButtonStroke = Instance.new("UIStroke")
    AimButtonStroke.Color = Color3.fromRGB(0, 0, 0)
    AimButtonStroke.Thickness = 3
    AimButtonStroke.Parent = AimLockButton
end

ScreenGui.Parent = LocalPlayer.PlayerGui

-- ═══════════════════════════════════════════════════════════════
--                    FUNÇÕES DE MINIMIZAR
-- ═══════════════════════════════════════════════════════════════

local IsMinimized = false

local function ToggleMinimize()
    IsMinimized = not IsMinimized
    
    if IsMinimized then
        MainFrame:TweenSize(
            UDim2.new(0, MainFrameWidth, 0, IsMobile and 60 or 50),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        ContentFrame.Visible = false
        MinimizeButton.Text = "+"
    else
        MainFrame:TweenSize(
            UDim2.new(0, MainFrameWidth, 0, MainFrameHeight),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        ContentFrame.Visible = true
        MinimizeButton.Text = "-"
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    FUNÇÃO TOGGLE FULLBRIGHT
-- ═══════════════════════════════════════════════════════════════

local function ToggleFullbright()
    FullbrightEnabled = not FullbrightEnabled
    
    if FullbrightEnabled then
        EnableFullbright()
        FullbrightButton.Text = "💡 BRILHO: ON"
        FullbrightButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    else
        DisableFullbright()
        FullbrightButton.Text = "💡 BRILHO: OFF"
        FullbrightButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    FUNÇÕES AIMLOCK
-- ═══════════════════════════════════════════════════════════════

local function IsTeamMate(player)
    if not AimSettings.TeamCheck then return false end
    return LocalPlayer.Team == player.Team and LocalPlayer.Team ~= nil
end

local function GetTeamColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

local function CreateESP(player)
    if ESPObjects[player] then 
        local highlight = ESPObjects[player]
        if highlight then
            highlight.FillColor = GetTeamColor(player)
        end
        return 
    end
    
    local character = player.Character
    if not character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = GetTeamColor(player)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    ESPObjects[player] = highlight
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function ClearAllESP()
    for player, highlight in pairs(ESPObjects) do
        if highlight then
            highlight:Destroy()
        end
    end
    ESPObjects = {}
end

local function CreateESPForAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            CreateESP(player)
        end
    end
end

local function GetClosestPlayerByDistance()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge
    local CenterScreen = Camera.ViewportSize / 2
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local myPosition = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if IsTeamMate(player) then continue end
            
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local targetPart = character:FindFirstChild(AimSettings.TargetPart)
            
            if humanoid and humanoid.Health > 0 and targetPart and humanoidRootPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - CenterScreen).Magnitude
                    
                    if screenDistance < AimSettings.FOV then
                        local realDistance = (humanoidRootPart.Position - myPosition).Magnitude
                        
                        if realDistance < ShortestDistance then
                            ClosestPlayer = player
                            ShortestDistance = realDistance
                        end
                    end
                end
            end
        end
    end
    
    return ClosestPlayer
end

local function AimAt(part)
    if not part then return end
    
    local targetPos = part.Position
    local camPos = Camera.CFrame.Position
    
    local direction = (targetPos - camPos).Unit
    local newCFrame = CFrame.new(camPos, camPos + direction)
    
    if AimSettings.Smoothness > 0 then
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 / AimSettings.Smoothness)
    else
        Camera.CFrame = newCFrame
    end
end

local function UpdateFOV()
    local viewportSize = Camera.ViewportSize
    FOVCircle.Position = viewportSize / 2
    FOVCircle.Radius = AimSettings.FOV
    FOVCircle.Visible = AimLockEnabled
end

local function ToggleAimLock()
    AimLockEnabled = not AimLockEnabled
    
    if AimLockEnabled then
        local statusText = IsMobile and "✅ AimLock: ATIVADO (Botão 🎯)" or "✅ AimLock: ATIVADO (Tecla E)"
        AimInfo.Text = statusText
        AimInfo.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        
        if IsMobile and AimLockButton then
            AimLockButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
        
        if AimSettings.ESPForAll then
            CreateESPForAll()
        end
    else
        local statusText = IsMobile and "Ativar AimLock: Botão 🎯" or "Ativar AimLock: Tecla E"
        AimInfo.Text = statusText
        AimInfo.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        
        if IsMobile and AimLockButton then
            AimLockButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
        end
        
        LockedPlayer = nil
        ClearAllESP()
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    FUNÇÕES AUTO FARM
-- ═══════════════════════════════════════════════════════════════

local function IsAlive()
    if not LocalPlayer.Character then return false end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function WaitForDeath()
    FarmStatus.Text = "⚔️ Aguardando você morrer..."
    print("Aguardando morte do jogador...")
    
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        repeat 
            wait(0.5)
        until humanoid.Health <= 0 or not AutoFarmEnabled
    end
    
    if not AutoFarmEnabled then return false end
    
    FarmStatus.Text = "💀 Morreu! Aguardando respawn..."
    print("Jogador morreu! Aguardando respawn...")
    
    repeat wait(0.1) until not LocalPlayer.Character or not LocalPlayer.Character.Parent
    repeat wait(0.1) until LocalPlayer.Character
    repeat wait(0.1) until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    repeat wait(0.1) until humanoid.Health > 0
    
    wait(FarmSettings.RespawnWaitTime)
    
    FarmStatus.Text = "✅ Respawnado! Próximo ciclo..."
    print("Respawn completo! Iniciando próximo ciclo...")
    
    return true
end

local function Teleport(position)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    return true
end

local function PressE()
    print("Pressionando tecla E...")
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    
    wait(0.1)
    
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        wait(0.1)
        tool:Deactivate()
    end
    
    print("Tecla E pressionada!")
end

local function MoveAround()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    print("Movimentando personagem...")
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    for i = 1, 8 do
        if not IsAlive() or not AutoFarmEnabled then break end
        
        hrp.CFrame = hrp.CFrame * CFrame.new(FarmSettings.MovementAmount, 0, 0)
        wait(0.15)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
        wait(0.15)
    end
    
    print("Movimento completo!")
end

local function RunCompleteFarm()
    AutoFarmEnabled = true
    CurrentCycle = 0
    PegarValButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    PegarValButton.Text = "⏳ PEGANDO..."
    
    spawn(function()
        for cycle = 1, FarmSettings.TotalCycles do
            if not AutoFarmEnabled then break end
            
            CurrentCycle = cycle
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. "/" .. FarmSettings.TotalCycles
            print("═══════════════════════════════════════")
            print("INICIANDO CICLO " .. cycle .. "/" .. FarmSettings.TotalCycles)
            print("═══════════════════════════════════════")
            
            print("PASSO 1: Teleportando para Position1...")
            if not Teleport(FarmSettings.Position1) then
                print("Erro no teleporte! Tentando novamente...")
                wait(1)
                Teleport(FarmSettings.Position1)
            end
            wait(FarmSettings.TeleportDelay)
            
            print("PASSO 2: Pressionando E...")
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. " - Pressionando E"
            PressE()
            wait(FarmSettings.KeyPressDelay)
            
            print("PASSO 3: Teleportando para Position2...")
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. " - Indo para Position2"
            if not Teleport(FarmSettings.Position2) then
                print("Erro no teleporte! Tentando novamente...")
                wait(1)
                Teleport(FarmSettings.Position2)
            end
            wait(FarmSettings.TeleportDelay)
            
            print("PASSO 4: Movimentando...")
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. " - Movimentando"
            MoveAround()
            wait(0.5)
            
            print("PASSO 5: Aguardando morte...")
            if not WaitForDeath() then
                print("Farm cancelado!")
                break
            end
            
            print("Ciclo " .. cycle .. " concluído!")
            print("═══════════════════════════════════════")
        end
        
        AutoFarmEnabled = false
        PegarValButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
        PegarValButton.Text = "⚡ PEGAR AS VAL"
        FarmStatus.Text = "✅ Completo! " .. FarmSettings.TotalCycles .. " ciclos"
        print("FARM COMPLETO! Total de ciclos: " .. FarmSettings.TotalCycles)
    end)
end

-- ═══════════════════════════════════════════════════════════════
--                    ATUALIZAR FPS E PING
-- ═══════════════════════════════════════════════════════════════

local FPSTable = {}
local lastFPSUpdate = tick()

local function UpdateFPS()
    local currentTime = tick()
    
    for i = #FPSTable, 1, -1 do
        if FPSTable[i] < currentTime - 1 then
            table.remove(FPSTable, i)
        end
    end
    
    table.insert(FPSTable, currentTime)
    
    if currentTime - lastFPSUpdate >= 0.5 then
        local fps = #FPSTable
        FPSLabel.Text = "📊 FPS: " .. fps
        lastFPSUpdate = currentTime
    end
end

local function UpdatePing()
    local success, ping = pcall(function()
        return Stats:FindFirstChild("PerformanceStats").Ping:GetValue()
    end)
    
    if success then
        ping = math.floor(ping)
        PingLabel.Text = "📡 Ping: " .. ping .. " ms"
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    TIMER SYSTEM
-- ═══════════════════════════════════════════════════════════════

spawn(function()
    while true do
        wait(1)
        
        PlayTime.seconds = PlayTime.seconds + 1
        
        if PlayTime.seconds >= 60 then
            PlayTime.seconds = 0
            PlayTime.minutes = PlayTime.minutes + 1
        end
        
        if PlayTime.minutes >= 60 then
            PlayTime.minutes = 0
            PlayTime.hours = PlayTime.hours + 1
        end
        
        TimerLabel.Text = string.format("⏱️ Tempo: %d:%d:%d", PlayTime.hours, PlayTime.minutes, PlayTime.seconds)
    end
end)

spawn(function()
    while wait(2) do
        UpdatePing()
    end
end)

spawn(function()
    while wait(1) do
        if FullbrightEnabled then
            EnableFullbright()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                    EVENTOS UI
-- ═══════════════════════════════════════════════════════════════

PegarValButton.MouseButton1Click:Connect(function()
    if not AutoFarmEnabled then
        RunCompleteFarm()
    end
end)

FullbrightButton.MouseButton1Click:Connect(function()
    ToggleFullbright()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    ToggleMinimize()
end)

CloseButton.MouseButton1Click:Connect(function()
    AutoFarmEnabled = false
    AntiAFKEnabled = false
    if FullbrightEnabled then
        DisableFullbright()
    end
    ScreenGui:Destroy()
    FOVCircle:Remove()
    ClearAllESP()
end)

-- Botão AimLock Mobile
if IsMobile and AimLockButton then
    AimLockButton.MouseButton1Click:Connect(function()
        ToggleAimLock()
    end)
end

-- ═══════════════════════════════════════════════════════════════
--                    INPUT HANDLER (PC)
-- ═══════════════════════════════════════════════════════════════

if IsPC then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == AimSettings.AimKey then
            ToggleAimLock()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
--                    LOOP PRINCIPAL
-- ═══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    UpdateFOV()
    UpdateFPS()
    
    if AimLockEnabled then
        if AimSettings.ESPForAll then
            CreateESPForAll()
        end
        
        local closestPlayer = GetClosestPlayerByDistance()
        
        if closestPlayer then
            if closestPlayer ~= LockedPlayer then
                LockedPlayer = closestPlayer
            end
            
            if LockedPlayer.Character then
                local targetPart = LockedPlayer.Character:FindFirstChild(AimSettings.TargetPart)
                local humanoid = LockedPlayer.Character:FindFirstChild("Humanoid")
                
                if targetPart and humanoid and humanoid.Health > 0 then
                    AimAt(targetPart)
                else
                    LockedPlayer = nil
                end
            end
        else
            if LockedPlayer then
                LockedPlayer = nil
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                    EVENTOS DE JOGADORES
-- ═══════════════════════════════════════════════════════════════

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        if AimLockEnabled and AimSettings.ESPForAll then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player == LockedPlayer then
        LockedPlayer = nil
    end
    RemoveESP(player)
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    LockedPlayer = nil
    ClearAllESP()
    if AimLockEnabled and AimSettings.ESPForAll then
        CreateESPForAll()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                    MENSAGENS FINAIS
-- ═══════════════════════════════════════════════════════════════

print("════════════════════════════════════════════════")
print("    🎯 SCRIPT COMPLETO CARREGADO")
print("════════════════════════════════════════════════")
if IsMobile then
    print("📱 MODO MOBILE:")
    print("✅ AimLock: Toque no botão flutuante 🎯")
    print("✅ Interface touch otimizada")
    print("✅ Botões maiores para facilitar")
    print("✅ FOV aumentado: " .. AimSettings.FOV)
else
    print("💻 MODO PC:")
    print("✅ AimLock: Pressione 'E'")
    print("✅ Interface padrão")
    print("✅ Controles de teclado")
end
print("✅ Auto Farm: Clique no botão roxo")
print("✅ Anti-AFK: Ativo automaticamente")
print("✅ Fullbright: Botão '💡 BRILHO'")
print("✅ Minimizar: Botão '-'")
print("════════════════════════════════════════════════")
