-- ═══════════════════════════════════════════════════════════════
--                    SCRIPT COMPLETO - AIMLOCK + PEGAR AS VAL
-- ═══════════════════════════════════════════════════════════════

-- Configurações AimLock
local AimSettings = {
    AimKey = Enum.KeyCode.E,
    TeamCheck = true,
    FOV = 40,
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
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis AimLock
local AimLockEnabled = false
local LockedPlayer = nil
local ESPObjects = {}

-- Variáveis Auto Farm
local AutoFarmEnabled = false
local CurrentCycle = 0

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
--                         CRIAR UI
-- ═══════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
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
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎯 AIMLOCK + AS VAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Função para criar label de status
local function CreateStatusLabel(name, text, position, parent)
    local Label = Instance.new("TextLabel")
    Label.Name = name
    Label.Size = UDim2.new(0, 300, 0, 30)
    Label.Position = position
    Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Label
    
    return Label
end

-- Info AimLock
local AimInfo = CreateStatusLabel("AimInfo", "Ativar AimLock: Tecla E", UDim2.new(0, 25, 0, 70), MainFrame)

-- Botão Pegar AS VAL
local PegarValButton = Instance.new("TextButton")
PegarValButton.Name = "PegarValButton"
PegarValButton.Size = UDim2.new(0, 300, 0, 60)
PegarValButton.Position = UDim2.new(0, 25, 0, 115)
PegarValButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
PegarValButton.Text = "⚡ PEGAR AS VAL"
PegarValButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PegarValButton.TextSize = 20
PegarValButton.Font = Enum.Font.GothamBold
PegarValButton.Parent = MainFrame

local ValCorner = Instance.new("UICorner")
ValCorner.CornerRadius = UDim.new(0, 8)
ValCorner.Parent = PegarValButton

-- Status Farm
local FarmStatus = CreateStatusLabel("FarmStatus", "Aguardando...", UDim2.new(0, 25, 0, 190), MainFrame)

ScreenGui.Parent = LocalPlayer.PlayerGui

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
        AimInfo.Text = "✅ AimLock: ATIVADO (Tecla E)"
        AimInfo.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        if AimSettings.ESPForAll then
            CreateESPForAll()
        end
    else
        AimInfo.Text = "Ativar AimLock: Tecla E"
        AimInfo.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        LockedPlayer = nil
        ClearAllESP()
    end
end

-- ═══════════════════════════════════════════════════════════════
--                    FUNÇÕES AUTO FARM
-- ═══════════════════════════════════════════════════════════════

-- Função para verificar se está vivo
local function IsAlive()
    if not LocalPlayer.Character then return false end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

-- Função para aguardar morte
local function WaitForDeath()
    FarmStatus.Text = "⚔️ Aguardando você morrer..."
    print("Aguardando morte do jogador...")
    
    -- Aguardar até morrer
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        repeat 
            wait(0.5)
        until humanoid.Health <= 0 or not AutoFarmEnabled
    end
    
    if not AutoFarmEnabled then return false end
    
    FarmStatus.Text = "💀 Morreu! Aguardando respawn..."
    print("Jogador morreu! Aguardando respawn...")
    
    -- Esperar personagem sumir
    repeat wait(0.1) until not LocalPlayer.Character or not LocalPlayer.Character.Parent
    
    -- Esperar novo personagem
    repeat wait(0.1) until LocalPlayer.Character
    
    -- Esperar HumanoidRootPart
    repeat wait(0.1) until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    -- Esperar Humanoid estar vivo
    humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    repeat wait(0.1) until humanoid.Health > 0
    
    -- Tempo extra de segurança
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
    
    -- Método 1: VirtualInputManager
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    
    wait(0.1)
    
    -- Método 2: Backup usando mouse1click se houver ferramenta equipada
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
    
    -- Movimento em pequeno círculo
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
            
            -- PASSO 1: Teleportar para Position1
            print("PASSO 1: Teleportando para Position1...")
            if not Teleport(FarmSettings.Position1) then
                print("Erro no teleporte! Tentando novamente...")
                wait(1)
                Teleport(FarmSettings.Position1)
            end
            wait(FarmSettings.TeleportDelay)
            
            -- PASSO 2: Pressionar E
            print("PASSO 2: Pressionando E...")
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. " - Pressionando E"
            PressE()
            wait(FarmSettings.KeyPressDelay)
            
            -- PASSO 3: Teleportar para Position2
            print("PASSO 3: Teleportando para Position2...")
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. " - Indo para Position2"
            if not Teleport(FarmSettings.Position2) then
                print("Erro no teleporte! Tentando novamente...")
                wait(1)
                Teleport(FarmSettings.Position2)
            end
            wait(FarmSettings.TeleportDelay)
            
            -- PASSO 4: Se mexer
            print("PASSO 4: Movimentando...")
            FarmStatus.Text = "🔄 Ciclo " .. cycle .. " - Movimentando"
            MoveAround()
            wait(0.5)
            
            -- PASSO 5: Aguardar morte
            print("PASSO 5: Aguardando morte...")
            if not WaitForDeath() then
                print("Farm cancelado!")
                break
            end
            
            print("Ciclo " .. cycle .. " concluído!")
            print("═══════════════════════════════════════")
        end
        
        -- Finalizar
        AutoFarmEnabled = false
        PegarValButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
        PegarValButton.Text = "⚡ PEGAR AS VAL"
        FarmStatus.Text = "✅ Completo! " .. FarmSettings.TotalCycles .. " ciclos"
        print("FARM COMPLETO! Total de ciclos: " .. FarmSettings.TotalCycles)
    end)
end

-- ═══════════════════════════════════════════════════════════════
--                    EVENTOS UI
-- ═══════════════════════════════════════════════════════════════

PegarValButton.MouseButton1Click:Connect(function()
    if not AutoFarmEnabled then
        RunCompleteFarm()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    AutoFarmEnabled = false
    ScreenGui:Destroy()
    FOVCircle:Remove()
    ClearAllESP()
end)

-- ═══════════════════════════════════════════════════════════════
--                    INPUT HANDLER
-- ═══════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == AimSettings.AimKey then
        ToggleAimLock()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--                    LOOP PRINCIPAL
-- ═══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    UpdateFOV()
    
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

print("════════════════════════════════════════════════")
print("    🎯 AIMLOCK + PEGAR AS VAL CARREGADO")
print("════════════════════════════════════════════════")
print("✅ AimLock: Pressione 'E'")
print("✅ Pegar AS VAL: Clique no botão roxo")
print("✅ Fluxo: Teleporta → Clica E → Se mexe → Aguarda morte")
print("════════════════════════════════════════════════")
