-- Configurações
local Settings = {
    AimKey = Enum.KeyCode.E,
    TeamCheck = true,
    FOV = 40,
    TargetPart = "Head",
    Smoothness = 0,
    FOVColor = Color3.fromRGB(128, 0, 128),
    UseTeamColor = true, -- ESP usa cor do time
    ESPForAll = true, -- ESP em todos os jogadores
}

-- Serviços
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis
local AimLockEnabled = false
local LockedPlayer = nil
local ESPObjects = {}

-- Criar FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Settings.FOVColor
FOVCircle.Filled = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Visible = false
FOVCircle.Transparency = 1
FOVCircle.NumSides = 64

-- Função para verificar se é do mesmo time
local function IsTeamMate(player)
    if not Settings.TeamCheck then return false end
    return LocalPlayer.Team == player.Team and LocalPlayer.Team ~= nil
end

-- Função para obter cor do time
local function GetTeamColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    end
    -- Cor padrão se não tiver time
    return Color3.fromRGB(255, 255, 255)
end

-- Função para criar ESP
local function CreateESP(player)
    if ESPObjects[player] then 
        -- Atualizar cor se já existe
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

-- Função para remover ESP
local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

-- Função para limpar todos os ESP
local function ClearAllESP()
    for player, highlight in pairs(ESPObjects) do
        if highlight then
            highlight:Destroy()
        end
    end
    ESPObjects = {}
end

-- Função para criar ESP em todos
local function CreateESPForAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            CreateESP(player)
        end
    end
end

-- Função para obter o jogador mais próximo baseado na DISTÂNCIA REAL (3D)
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
            local targetPart = character:FindFirstChild(Settings.TargetPart)
            
            -- Verificar se está vivo
            if humanoid and humanoid.Health > 0 and targetPart and humanoidRootPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - CenterScreen).Magnitude
                    
                    -- Verificar se está dentro do FOV
                    if screenDistance < Settings.FOV then
                        -- Calcular distância 3D real
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

-- Função principal de aim
local function AimAt(part)
    if not part then return end
    
    local targetPos = part.Position
    local camPos = Camera.CFrame.Position
    
    -- Calcular a direção para o alvo
    local direction = (targetPos - camPos).Unit
    local newCFrame = CFrame.new(camPos, camPos + direction)
    
    if Settings.Smoothness > 0 then
        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 / Settings.Smoothness)
    else
        Camera.CFrame = newCFrame
    end
end

-- Atualizar FOV Circle
local function UpdateFOV()
    local viewportSize = Camera.ViewportSize
    FOVCircle.Position = viewportSize / 2
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = AimLockEnabled
end

-- Toggle Aim Lock
local function ToggleAimLock()
    AimLockEnabled = not AimLockEnabled
    
    if AimLockEnabled then
        print("╔════════════════════╗")
        print("║ AIM LOCK ATIVADO  ║")
        print("╚════════════════════╝")
        -- Criar ESP em todos quando ativar
        if Settings.ESPForAll then
            CreateESPForAll()
        end
    else
        print("╔════════════════════╗")
        print("║ AIM LOCK DESATIVADO║")
        print("╚════════════════════╝")
        LockedPlayer = nil
        ClearAllESP()
    end
end

-- Input Handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Settings.AimKey then
        ToggleAimLock()
    end
end)

-- Loop Principal
RunService.RenderStepped:Connect(function()
    UpdateFOV()
    
    if AimLockEnabled then
        -- Manter ESP em todos atualizado
        if Settings.ESPForAll then
            CreateESPForAll()
        end
        
        -- SEMPRE buscar o jogador mais próximo (atualiza constantemente)
        local closestPlayer = GetClosestPlayerByDistance()
        
        -- Se encontrou alguém
        if closestPlayer then
            -- Se é um novo alvo, atualizar
            if closestPlayer ~= LockedPlayer then
                LockedPlayer = closestPlayer
            end
            
            -- Mirar no alvo
            if LockedPlayer.Character then
                local targetPart = LockedPlayer.Character:FindFirstChild(Settings.TargetPart)
                local humanoid = LockedPlayer.Character:FindFirstChild("Humanoid")
                
                if targetPart and humanoid and humanoid.Health > 0 then
                    AimAt(targetPart)
                else
                    LockedPlayer = nil
                end
            end
        else
            -- Nenhum jogador no FOV
            if LockedPlayer then
                LockedPlayer = nil
            end
        end
    end
end)

-- Detectar quando novo jogador entra
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar carregar
        if AimLockEnabled and Settings.ESPForAll then
            CreateESP(player)
        end
    end)
end)

-- Detectar quando jogador morre ou sai
Players.PlayerRemoving:Connect(function(player)
    if player == LockedPlayer then
        LockedPlayer = nil
    end
    RemoveESP(player)
end)

-- Limpeza ao morrer
LocalPlayer.CharacterAdded:Connect(function()
    wait(0.5)
    LockedPlayer = nil
    ClearAllESP()
    if AimLockEnabled and Settings.ESPForAll then
        CreateESPForAll()
    end
end)

-- Atualizar ESP quando jogador troca de time
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player:GetPropertyChangedSignal("Team"):Connect(function()
            if ESPObjects[player] then
                RemoveESP(player)
                if AimLockEnabled and Settings.ESPForAll then
                    CreateESP(player)
                end
            end
        end)
    end
end

print("════════════════════════════════")
print("   AIMLOCK + ESP TODOS - FOV: 40")
print("════════════════════════════════")
print("Pressione 'E' para ativar/desativar")
print("ESP em TODOS com cor do time!")
print("════════════════════════════════")
