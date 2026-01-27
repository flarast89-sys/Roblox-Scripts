-- Script de Comandos Militares - Detecção Barra Superior
-- LocalScript - Coloque em StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis do personagem
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configurações
local scriptAtivado = false -- COMEÇA DESATIVADO
local comandosValidos = {
    ["Direita, volver."] = -90,
    ["Esquerda, volver."] = 90,
    ["Retaguarda, volver."] = 180,
    ["Direita, inclinar."] = -45,
    ["Esquerda, inclinar."] = 45,
    ["Direita, volte."] = -90,
    ["Esquerda, volte."] = 90,
    ["Retaguarda, volte."] = 180
}

local delayExecucao = 1.5 -- 1.5 SEGUNDOS
local comandoEmExecucao = false
local ultimoComandoDetectado = ""
local comandoJaExecutado = false

-- Criar GUI de controle
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ComandosMilitaresGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(1, -320, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
titleLabel.Text = "⚔️ Comandos Militares"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "❌ Desativado"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Área de Feedback (NOVA)
local feedbackFrame = Instance.new("Frame")
feedbackFrame.Name = "FeedbackFrame"
feedbackFrame.Size = UDim2.new(1, -20, 0, 80)
feedbackFrame.Position = UDim2.new(0, 10, 0, 80)
feedbackFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
feedbackFrame.BorderSizePixel = 1
feedbackFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
feedbackFrame.Parent = mainFrame

local feedbackCorner = Instance.new("UICorner")
feedbackCorner.CornerRadius = UDim.new(0, 6)
feedbackCorner.Parent = feedbackFrame

-- Label de Feedback
local feedbackLabel = Instance.new("TextLabel")
feedbackLabel.Name = "FeedbackLabel"
feedbackLabel.Size = UDim2.new(1, -10, 1, -10)
feedbackLabel.Position = UDim2.new(0, 5, 0, 5)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Text = "Aguardando comando..."
feedbackLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
feedbackLabel.TextSize = 13
feedbackLabel.Font = Enum.Font.Gotham
feedbackLabel.TextWrapped = true
feedbackLabel.TextXAlignment = Enum.TextXAlignment.Left
feedbackLabel.TextYAlignment = Enum.TextYAlignment.Top
feedbackLabel.Parent = feedbackFrame

-- Botão Toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 130, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 165)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
toggleButton.Text = "ATIVAR"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Botão Fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 140, 0, 35)
closeButton.Position = UDim2.new(0, 150, 0, 165)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeButton.Text = "Fechar GUI"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.Gotham
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Função para normalizar texto
local function normalizarTexto(texto)
    if not texto or texto == "" then return "" end
    texto = tostring(texto)
    texto = texto:gsub("%s+", " ")
    texto = texto:gsub("^%s+", "")
    texto = texto:gsub("%s+$", "")
    return texto
end

-- Função para extrair comando do texto da barra superior
local function extrairComando(texto)
    -- O texto da barra vem como "p7store01_1480rb: Direita, volver."
    -- Precisamos extrair apenas "Direita, volver."
    
    if texto:find(":") then
        -- Pega tudo depois dos dois pontos
        local comando = texto:match(":%s*(.+)$")
        if comando then
            return normalizarTexto(comando)
        end
    end
    
    return normalizarTexto(texto)
end

-- Função para validar comando e dar feedback detalhado
local function validarComandoComFeedback(texto)
    local textoOriginal = texto
    local textoNorm = extrairComando(texto)
    
    -- Verifica se é um comando válido
    if comandosValidos[textoNorm] then
        feedbackLabel.Text = "✅ COMANDO VÁLIDO!\n\n" .. textoNorm
        feedbackLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        feedbackFrame.BorderColor3 = Color3.fromRGB(100, 255, 100)
        return true, comandosValidos[textoNorm]
    end
    
    -- Se não é válido, analisa o problema
    local textoLimpo = textoNorm
    
    -- Remove vírgula e ponto para análise
    local semPontuacao = textoLimpo:gsub("[,.]", "")
    
    -- Verifica comandos sem pontuação
    local comandosSemPontuacao = {
        ["Direita volver"] = "Direita, volver.",
        ["Esquerda volver"] = "Esquerda, volver.",
        ["Retaguarda volver"] = "Retaguarda, volver.",
        ["Direita inclinar"] = "Direita, inclinar.",
        ["Esquerda inclinar"] = "Esquerda, inclinar.",
        ["Direita volte"] = "Direita, volte.",
        ["Esquerda volte"] = "Esquerda, volte.",
        ["Retaguarda volte"] = "Retaguarda, volte."
    }
    
    if comandosSemPontuacao[semPontuacao] then
        feedbackLabel.Text = "❌ COMANDO INVÁLIDO!\n\nFalta vírgula e/ou ponto final.\n\nCorreto: " .. comandosSemPontuacao[semPontuacao]
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        feedbackFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
        return false, nil
    end
    
    -- Verifica se tem só vírgula mas falta ponto
    if textoLimpo:match(",%s*[^.]+$") then
        feedbackLabel.Text = "❌ COMANDO INVÁLIDO!\n\nFalta ponto final.\n\nTexto: " .. textoLimpo
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        feedbackFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
        return false, nil
    end
    
    -- Verifica se está em caixa alta/baixa errada
    local minusculo = textoLimpo:lower()
    for comando, _ in pairs(comandosValidos) do
        if minusculo == comando:lower() then
            feedbackLabel.Text = "❌ COMANDO INVÁLIDO!\n\nProblema de MAIÚSCULAS/minúsculas.\n\nCorreto: " .. comando
            feedbackLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            feedbackFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
            return false, nil
        end
    end
    
    -- Se não reconheceu nada, mostra que comando está completamente errado
    if textoLimpo ~= "" then
        feedbackLabel.Text = "❌ COMANDO INVÁLIDO!\n\nComando não reconhecido.\n\nTexto: " .. textoLimpo
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        feedbackFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    return false, nil
end

-- Função para rotacionar
local function rotacionarPersonagem(angulo)
    if comandoEmExecucao or not scriptAtivado then
        return
    end
    
    comandoEmExecucao = true
    print("🔄 Executando rotação: " .. angulo .. "°")
    
    local cframeInicial = humanoidRootPart.CFrame
    local tempoAnimacao = 0.3
    local tempoInicio = tick()
    
    local rotacaoFinal = cframeInicial * CFrame.Angles(0, math.rad(angulo), 0)
    
    while tick() - tempoInicio < tempoAnimacao do
        local progresso = (tick() - tempoInicio) / tempoAnimacao
        humanoidRootPart.CFrame = cframeInicial:Lerp(rotacaoFinal, progresso)
        task.wait(0.02)
    end
    
    humanoidRootPart.CFrame = rotacaoFinal
    comandoEmExecucao = false
    print("✅ Comando executado!")
end

-- Função para processar comando
local function processarComando(texto)
    if not scriptAtivado then return end
    
    local valido, angulo = validarComandoComFeedback(texto)
    
    if not valido then 
        -- Se não é comando válido, reseta
        if ultimoComandoDetectado ~= "" then
            ultimoComandoDetectado = ""
            comandoJaExecutado = false
        end
        return 
    end
    
    local comandoExtraido = extrairComando(texto)
    
    -- Se é um NOVO comando diferente do anterior
    if comandoExtraido ~= ultimoComandoDetectado then
        print("🆕 NOVO comando detectado: " .. comandoExtraido)
        ultimoComandoDetectado = comandoExtraido
        comandoJaExecutado = false
        
        feedbackLabel.Text = "✅ COMANDO VÁLIDO!\n\n" .. comandoExtraido .. "\n\n⏳ Executando em " .. delayExecucao .. "s..."
        feedbackLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
        
        print("⏳ Aguardando " .. delayExecucao .. "s...")
        
        -- Executa UMA VEZ após o delay
        task.spawn(function()
            task.wait(delayExecucao)
            if not comandoJaExecutado and scriptAtivado then
                comandoJaExecutado = true
                rotacionarPersonagem(angulo)
                feedbackLabel.Text = "✅ Comando executado!\n\n" .. comandoExtraido
                feedbackLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        end)
    end
end

-- Função para procurar elementos na parte SUPERIOR da tela
local function procurarBarraSuperior()
    if not scriptAtivado then return end
    
    local comandoEncontrado = false
    
    -- Varre TODOS os elementos
    for _, gui in pairs(playerGui:GetChildren()) do
        for _, elemento in pairs(gui:GetDescendants()) do
            -- Procura TextLabels na parte superior (Y < 0.2)
            if elemento:IsA("TextLabel") and elemento.Visible then
                local posicao = elemento.AbsolutePosition
                local tamanhoTela = elemento.Parent and elemento.Parent.AbsoluteSize or Vector2.new(1920, 1080)
                
                -- Verifica se está na parte superior da tela (20% superior)
                if posicao.Y < (tamanhoTela.Y * 0.2) and elemento.Text and elemento.Text ~= "" then
                    local valido, angulo = validarComandoComFeedback(elemento.Text)
                    if valido then
                        print("📍 Texto encontrado no topo: " .. elemento.Text)
                        processarComando(elemento.Text)
                        comandoEncontrado = true
                        break
                    end
                end
            end
        end
        if comandoEncontrado then break end
    end
    
    -- Se não encontrou comando válido, reseta
    if not comandoEncontrado and ultimoComandoDetectado ~= "" then
        ultimoComandoDetectado = ""
        comandoJaExecutado = false
        feedbackLabel.Text = "Aguardando comando..."
        feedbackLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        feedbackFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    end
end

-- Sistema de detecção contínua
local function iniciarDeteccao()
    -- Método 1: Monitora mudanças de texto em TODOS elementos
    local function conectarElemento(elemento)
        if elemento:IsA("TextLabel") or elemento:IsA("TextBox") then
            elemento:GetPropertyChangedSignal("Text"):Connect(function()
                if scriptAtivado then
                    procurarBarraSuperior()
                end
            end)
        end
    end
    
    -- Conecta elementos existentes
    for _, gui in pairs(playerGui:GetChildren()) do
        for _, elemento in pairs(gui:GetDescendants()) do
            conectarElemento(elemento)
        end
    end
    
    -- Conecta novos elementos
    playerGui.DescendantAdded:Connect(function(elemento)
        task.wait(0.05)
        conectarElemento(elemento)
    end)
    
    -- Método 2: Varredura contínua focada no topo
    local ultimaVerificacao = tick()
    RunService.Heartbeat:Connect(function()
        if not scriptAtivado then return end
        
        -- Verifica a cada 0.3 segundos
        if tick() - ultimaVerificacao < 0.3 then return end
        ultimaVerificacao = tick()
        
        procurarBarraSuperior()
    end)
end

-- Botão Toggle
toggleButton.MouseButton1Click:Connect(function()
    scriptAtivado = not scriptAtivado
    
    if scriptAtivado then
        statusLabel.Text = "✅ Ativado"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleButton.Text = "DESATIVAR"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        feedbackLabel.Text = "Aguardando comando..."
        feedbackLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        feedbackFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        print("🟢 Script ATIVADO")
    else
        statusLabel.Text = "❌ Desativado"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleButton.Text = "ATIVAR"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        ultimoComandoDetectado = ""
        comandoJaExecutado = false
        feedbackLabel.Text = "Script desativado.\nClique em ATIVAR para começar."
        feedbackLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        feedbackFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
        print("🔴 Script DESATIVADO")
    end
end)

-- Botão Fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    scriptAtivado = false
    print("❌ GUI fechada")
end)

-- Tornar GUI arrastável
local dragging = false
local dragInput, dragStart, startPos

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Atualizar ao respawnar
player.CharacterAdded:Connect(function(novoCharacter)
    character = novoCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    comandoEmExecucao = false
    ultimoComandoDetectado = ""
    comandoJaExecutado = false
end)

-- Iniciar sistema de detecção
iniciarDeteccao()

print("✅ Sistema de Comandos Militares carregado!")
print("⚠️ Script está DESATIVADO - Clique em ATIVAR para começar")
print("⏱️ Delay de execução: " .. delayExecucao .. " segundos")
print("📋 Comandos válidos:")
for comando, _ in pairs(comandosValidos) do
    print("  - " .. comando)
end
