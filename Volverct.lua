-- Sistema de Comandos Volver com GUI - VERSÃO CORRIGIDA
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

-- Variável de controle
local sistemaAtivo = false
local ultimoTextoDetectado = "" -- Guarda o texto completo detectado
local executandoComando = false

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VolverSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal da GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 210)
mainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚔️ SISTEMA VOLVER"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botão minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -65, 0, 2.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = titleBar

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -32.5, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

-- Status do sistema
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: DESATIVADO"
statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Botão de ativar/desativar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 260, 0, 45)
toggleButton.Position = UDim2.new(0, 20, 0, 85)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.BorderSizePixel = 2
toggleButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "ATIVAR SISTEMA"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = mainFrame

-- Display de detecção (simplificado)
local detectionFrame = Instance.new("Frame")
detectionFrame.Size = UDim2.new(1, -20, 0, 60)
detectionFrame.Position = UDim2.new(0, 10, 0, 140)
detectionFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
detectionFrame.BorderSizePixel = 2
detectionFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
detectionFrame.Parent = mainFrame

local detectionText = Instance.new("TextLabel")
detectionText.Size = UDim2.new(1, -10, 1, -10)
detectionText.Position = UDim2.new(0, 5, 0, 5)
detectionText.BackgroundTransparency = 1
detectionText.Text = "Aguardando..."
detectionText.TextColor3 = Color3.fromRGB(150, 150, 150)
detectionText.TextSize = 18
detectionText.Font = Enum.Font.SourceSansBold
detectionText.TextWrapped = true
detectionText.Parent = detectionFrame

-- Frame minimizado
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Size = UDim2.new(0, 200, 0, 40)
minimizedFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizedFrame.BorderSizePixel = 2
minimizedFrame.BorderColor3 = Color3.fromRGB(0, 200, 0)
minimizedFrame.Visible = false
minimizedFrame.Active = true
minimizedFrame.Draggable = true
minimizedFrame.Parent = screenGui

local minimizedLabel = Instance.new("TextLabel")
minimizedLabel.Size = UDim2.new(1, -40, 1, 0)
minimizedLabel.BackgroundTransparency = 1
minimizedLabel.Text = "⚔️ VOLVER"
minimizedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedLabel.TextSize = 14
minimizedLabel.Font = Enum.Font.SourceSansBold
minimizedLabel.Parent = minimizedFrame

local restoreButton = Instance.new("TextButton")
restoreButton.Size = UDim2.new(0, 35, 0, 35)
restoreButton.Position = UDim2.new(1, -37.5, 0, 2.5)
restoreButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
restoreButton.BorderSizePixel = 0
restoreButton.Text = "+"
restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreButton.TextSize = 20
restoreButton.Font = Enum.Font.SourceSansBold
restoreButton.Parent = minimizedFrame

-- Função para girar o personagem SUAVEMENTE (CORRIGIDO - INVERTIDO)
local function girarPersonagem(graus)
    if executandoComando then return end
    executandoComando = true
    
    -- Esperar 1 segundo antes de executar (REDUZIDO)
    wait(1)
    
    -- CORRIGIDO: Invertendo a direção (negativo se torna positivo e vice-versa)
    local grausCorrigidos = -graus
    
    local currentCFrame = humanoidRootPart.CFrame
    local targetCFrame = currentCFrame * CFrame.Angles(0, math.rad(grausCorrigidos), 0)
    
    -- Criar animação suave de 0.5 segundos (MAIS RÁPIDO)
    local tweenInfo = TweenInfo.new(
        0.5, -- Duração de 0.5 segundos (antes era 1)
        Enum.EasingStyle.Quad, -- Estilo suave
        Enum.EasingDirection.InOut
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    tween.Completed:Wait()
    
    -- IMPORTANTE: NÃO resetar o último comando mais, para evitar múltiplas execuções
    executandoComando = false
end

-- Função para verificar comandos NA TELA (TOPO CENTRALIZADO)
local function verificarComandos()
    while sistemaAtivo do
        -- Procurar especificamente por TextLabels no topo da tela
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Visible and gui.Text ~= "" then
                local texto = gui.Text
                local posicao = gui.AbsolutePosition
                local tamanho = gui.AbsoluteSize
                local tamanhoTela = workspace.CurrentCamera.ViewportSize
                
                -- Verificar se o elemento está MUITO NO TOPO da tela (Y < 100 pixels)
                -- e está centralizado horizontalmente
                local estaMuitoNoTopo = posicao.Y < 100
                local centroDaGui = posicao.X + (tamanho.X / 2)
                local centroDaTela = tamanhoTela.X / 2
                local estaCentralizado = math.abs(centroDaGui - centroDaTela) < 500
                
                if estaMuitoNoTopo and estaCentralizado and not executandoComando then
                    -- Verificar se é o mesmo texto da última vez
                    if texto == ultimoTextoDetectado then
                        -- Mesmo texto, ignorar para não executar de novo
                        return
                    end
                    
                    -- Texto novo, atualizar
                    ultimoTextoDetectado = texto
                    
                    -- Debug: mostrar TUDO que está detectando
                    print("========================================")
                    print("NOVO TEXTO DETECTADO:", texto)
                    print("========================================")
                    
                    -- Extrair o comando após os dois pontos
                    local comando = texto
                    if string.find(texto, ":") then
                        local partes = string.split(texto, ":")
                        if #partes >= 2 then
                            comando = partes[2]:match("^%s*(.-)%s*$") or partes[2]
                            print("COMANDO EXTRAÍDO:", comando)
                        end
                    else
                        comando = texto:match("^%s*(.-)%s*$") or texto
                    end
                    
                    -- Verificar comandos EXATOS
                    -- Verificar comandos EXATOS
                    if comando == "Direita, volver." then
                        detectionText.Text = "✓"
                        detectionText.TextColor3 = Color3.fromRGB(0, 255, 0)
                        print("✓ EXECUTANDO: Direita, volver.")
                        spawn(function() girarPersonagem(90) end)
                    elseif comando == "Esquerda, volver." then
                        detectionText.Text = "✓"
                        detectionText.TextColor3 = Color3.fromRGB(0, 255, 0)
                        print("✓ EXECUTANDO: Esquerda, volver.")
                        spawn(function() girarPersonagem(-90) end)
                    elseif comando == "Direita, inclinar." then
                        detectionText.Text = "✓"
                        detectionText.TextColor3 = Color3.fromRGB(0, 255, 0)
                        print("✓ EXECUTANDO: Direita, inclinar.")
                        spawn(function() girarPersonagem(45) end)
                    elseif comando == "Esquerda, inclinar." then
                        detectionText.Text = "✓"
                        detectionText.TextColor3 = Color3.fromRGB(0, 255, 0)
                        print("✓ EXECUTANDO: Esquerda, inclinar.")
                        spawn(function() girarPersonagem(-45) end)
                    elseif comando == "Retaguarda, volver." then
                        detectionText.Text = "✓"
                        detectionText.TextColor3 = Color3.fromRGB(0, 255, 0)
                        print("✓ EXECUTANDO: Retaguarda, volver.")
                        spawn(function() girarPersonagem(180) end)
                    else
                        -- Comando inválido - mostrar só o erro
                        if comando ~= "" and comando ~= "exemplo" then
                            -- Verificar qual é o erro
                            if not string.find(comando, ",") then
                                detectionText.Text = "Falta vírgula"
                            elseif not string.find(comando, "%.") then
                                detectionText.Text = "Falta ponto"
                            elseif comando:sub(1,1) ~= comando:sub(1,1):upper() then
                                detectionText.Text = "Maiúscula errada"
                            else
                                detectionText.Text = "Comando inválido"
                            end
                            
                            detectionText.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end
        
        wait(0.1) -- Verificar a cada 0.1 segundos
        
        -- Debug: mostrar quantos elementos estão sendo verificados
        local count = 0
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Visible and gui.Text ~= "" then
                count = count + 1
            end
        end
        if count > 0 then
            print("Total de TextLabels visíveis:", count)
        end
    end
end

-- Botão de ativar/desativar
toggleButton.MouseButton1Click:Connect(function()
    sistemaAtivo = not sistemaAtivo
    
    if sistemaAtivo then
        statusLabel.Text = "Status: ATIVADO ✓"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.Text = "DESATIVAR SISTEMA"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Limpar texto detectado ao ativar
        ultimoTextoDetectado = ""
        
        spawn(verificarComandos)
        print("========================================")
        print("SISTEMA VOLVER ATIVADO!")
        print("Aguardando comandos no topo da tela...")
        print("========================================")
    else
        statusLabel.Text = "Status: DESATIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "ATIVAR SISTEMA"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        toggleButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Limpar texto detectado ao desativar
        ultimoTextoDetectado = ""
        
        print("========================================")
        print("SISTEMA VOLVER DESATIVADO!")
        print("========================================")
    end
end)

-- Botão minimizar
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

-- Botão restaurar
restoreButton.MouseButton1Click:Connect(function()
    minimizedFrame.Visible = false
    mainFrame.Visible = true
end)

-- Botão fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    sistemaAtivo = false
    print("Sistema Volver fechado!")
end)

-- Atualizar character quando morrer
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

print("========================================")
print("SISTEMA VOLVER CARREGADO!")
print("Abra a GUI para ativar o sistema")
print("========================================")
