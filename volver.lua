-- Auto Comando Roblox - VERSÃO SIMPLES SEM TELEPORTE
-- Detecta e gira suavemente

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local ativado = false
local ultimoComando = "Nenhum"
local comandosExecutados = 0
local girando = false

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoComandoGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
titulo.Text = "🎮 AUTO COMANDO"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.TextSize = 18
titulo.Font = Enum.Font.GothamBold
titulo.Parent = mainFrame

local tituloCorner = Instance.new("UICorner")
tituloCorner.CornerRadius = UDim.new(0, 10)
tituloCorner.Parent = titulo

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: ⏸ DESATIVADO"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Último comando
local comandoLabel = Instance.new("TextLabel")
comandoLabel.Size = UDim2.new(1, -20, 0, 20)
comandoLabel.Position = UDim2.new(0, 10, 0, 80)
comandoLabel.BackgroundTransparency = 1
comandoLabel.Text = "Último: Nenhum"
comandoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
comandoLabel.TextSize = 12
comandoLabel.Font = Enum.Font.Gotham
comandoLabel.TextXAlignment = Enum.TextXAlignment.Left
comandoLabel.Parent = mainFrame

-- Contador
local contadorLabel = Instance.new("TextLabel")
contadorLabel.Size = UDim2.new(1, -20, 0, 20)
contadorLabel.Position = UDim2.new(0, 10, 0, 105)
contadorLabel.BackgroundTransparency = 1
contadorLabel.Text = "Executados: 0"
contadorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
contadorLabel.TextSize = 12
contadorLabel.Font = Enum.Font.Gotham
contadorLabel.TextXAlignment = Enum.TextXAlignment.Left
contadorLabel.Parent = mainFrame

-- Botão Ativar/Desativar
local botaoToggle = Instance.new("TextButton")
botaoToggle.Size = UDim2.new(0, 130, 0, 35)
botaoToggle.Position = UDim2.new(0, 10, 0, 140)
botaoToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
botaoToggle.Text = "▶ ATIVAR"
botaoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoToggle.TextSize = 14
botaoToggle.Font = Enum.Font.GothamBold
botaoToggle.Parent = mainFrame

local botaoCorner = Instance.new("UICorner")
botaoCorner.CornerRadius = UDim.new(0, 8)
botaoCorner.Parent = botaoToggle

-- Botão Resetar
local botaoReset = Instance.new("TextButton")
botaoReset.Size = UDim2.new(0, 130, 0, 35)
botaoReset.Position = UDim2.new(0, 160, 0, 140)
botaoReset.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
botaoReset.Text = "🔄 RESETAR"
botaoReset.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoReset.TextSize = 14
botaoReset.Font = Enum.Font.GothamBold
botaoReset.Parent = mainFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = botaoReset

-- Tornar arrastável
local dragging = false
local dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y - mainFrame.AbsolutePosition.Y <= 40 then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position
        end
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Atualizar GUI
local function atualizarGUI()
    if ativado then
        statusLabel.Text = "Status: ▶ ATIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        botaoToggle.Text = "⏸ DESATIVAR"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        statusLabel.Text = "Status: ⏸ DESATIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        botaoToggle.Text = "▶ ATIVAR"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    end
    comandoLabel.Text = "Último: " .. ultimoComando
    contadorLabel.Text = "Executados: " .. comandosExecutados
end

-- Variáveis de controle
local comandoAtual = nil
local anguloAlvo = 0
local anguloInicial = 0
local tempoInicio = 0
local duracao = 0.5 -- Duração da rotação em segundos
local comandoExecutado = false -- Controla se já executou o comando atual

-- Função para iniciar rotação (COM DELAY DE 2.5s)
local function iniciarRotacao(graus, nomeComando)
    if girando or comandoExecutado then return end
    
    comandoExecutado = true -- Marca como executado IMEDIATAMENTE
    
    print("✓ " .. nomeComando .. " detectado! Aguardando 2.5s...")
    
    -- AGUARDA 2.5 SEGUNDOS ANTES DE GIRAR
    task.delay(2.5, function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then 
            comandoExecutado = false
            return 
        end
        
        local hrp = char.HumanoidRootPart
        
        -- Pega ângulo Y atual
        local _, y, _ = hrp.CFrame:ToOrientation()
        anguloInicial = math.deg(y)
        anguloAlvo = anguloInicial + graus
        
        girando = true
        tempoInicio = tick()
        
        ultimoComando = nomeComando .. " (" .. graus .. "°)"
        comandosExecutados = comandosExecutados + 1
        atualizarGUI()
        
        print("✓ " .. nomeComando .. " - Girando " .. graus .. "°")
    end)
end

-- Conexão de rotação (roda todo frame)
local conexaoRotacao = RunService.Heartbeat:Connect(function()
    if not girando then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        girando = false
        return
    end
    
    local hrp = char.HumanoidRootPart
    local tempoDecorrido = tick() - tempoInicio
    
    if tempoDecorrido >= duracao then
        -- Terminou a rotação - define ângulo final exato
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(anguloAlvo), 0)
        
        girando = false
        
        print("✓ Rotação concluída! Aguardando comando sumir...")
        
        return
    end
    
    -- Interpola o ângulo
    local progresso = tempoDecorrido / duracao
    local anguloAtualInterpol = anguloInicial + (anguloAlvo - anguloInicial) * progresso
    
    -- Aplica apenas a rotação Y, mantendo X e Z
    local pos = hrp.Position
    hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(anguloAtualInterpol), 0)
end)

-- Detectar comandos
RunService.Heartbeat:Connect(function()
    if not ativado then return end
    
    local comandoEncontrado = nil
    
    for _, obj in pairs(player.PlayerGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if obj.Visible and obj ~= statusLabel and obj ~= comandoLabel and obj ~= contadorLabel and obj ~= titulo then
                local texto = obj.Text:lower()
                
                -- Remove prefixos e tudo após o ponto
                texto = texto:gsub("^[;/]%w+%s*", "")
                texto = texto:match("([^%.]+)") or texto
                texto = texto:gsub("%s+", " "):match("^%s*(.-)%s*$") or texto
                
                if texto:find("direita,%s*volver") or texto:find("direita,volver") then
                    comandoEncontrado = "direita_volver"
                elseif texto:find("esquerda,%s*volver") or texto:find("esquerda,volver") then
                    comandoEncontrado = "esquerda_volver"
                elseif texto:find("retaguarda,%s*volver") or texto:find("retaguarda,volver") then
                    comandoEncontrado = "retaguarda_volver"
                elseif texto:find("direita,%s*inclinar") or texto:find("direita,inclinar") then
                    comandoEncontrado = "direita_inclinar"
                elseif texto:find("esquerda,%s*inclinar") or texto:find("esquerda,inclinar") then
                    comandoEncontrado = "esquerda_inclinar"
                end
                
                if comandoEncontrado then break end
            end
        end
    end
    
    -- Se encontrou um comando novo E não está executado ainda
    if comandoEncontrado and comandoEncontrado ~= comandoAtual then
        comandoAtual = comandoEncontrado
        comandoExecutado = false -- Reseta para permitir execução
        
        -- Executa o comando
        if comandoEncontrado == "direita_volver" then
            iniciarRotacao(-90, "Direita Volver")
        elseif comandoEncontrado == "esquerda_volver" then
            iniciarRotacao(90, "Esquerda Volver")
        elseif comandoEncontrado == "retaguarda_volver" then
            iniciarRotacao(180, "Retaguarda Volver")
        elseif comandoEncontrado == "direita_inclinar" then
            iniciarRotacao(-45, "Direita Inclinar")
        elseif comandoEncontrado == "esquerda_inclinar" then
            iniciarRotacao(45, "Esquerda Inclinar")
        end
    end
    
    -- Se o comando SUMIU da tela, reseta tudo
    if not comandoEncontrado and comandoAtual then
        print("✓ Comando sumiu! Pronto para próximo.")
        comandoAtual = nil
        comandoExecutado = false
    end
end)

-- Botões
botaoToggle.MouseButton1Click:Connect(function()
    ativado = not ativado
    atualizarGUI()
    print(ativado and "▶ ATIVADO" or "⏸ DESATIVADO")
end)

botaoReset.MouseButton1Click:Connect(function()
    comandosExecutados = 0
    ultimoComando = "Resetado"
    atualizarGUI()
    wait(1)
    ultimoComando = "Nenhum"
    atualizarGUI()
end)

-- Tecla HOME
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Home then
        ativado = not ativado
        atualizarGUI()
    end
end)

atualizarGUI()

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎮 Auto Comando!")
print("• Detecta comando")
print("• Aguarda 2.5 segundos")
print("• Gira em 0.5 segundos")
print("• Aguarda comando sumir")
print("• Pronto para próximo!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
