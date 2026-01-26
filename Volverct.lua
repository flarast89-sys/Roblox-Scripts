-- Sistema de Comandos Volver - VERSÃO FINAL COMPLETA
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Aguardar character carregar
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis de controle
local sistemaAtivo = false
local ultimoTexto = ""
local girando = false

print("========================================")
print("SISTEMA VOLVER INICIANDO...")
print("========================================")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VolverSystem"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0.5, -160, 0.3, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚔️ SISTEMA VOLVER"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.SourceSansBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Botão Minimizar
local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 35, 0, 35)
btnMinimize.Position = UDim2.new(1, -75, 0, 2.5)
btnMinimize.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
btnMinimize.BorderSizePixel = 0
btnMinimize.Text = "—"
btnMinimize.TextColor3 = Color3.fromRGB(0, 0, 0)
btnMinimize.TextSize = 20
btnMinimize.Font = Enum.Font.SourceSansBold
btnMinimize.Parent = titleBar

-- Botão Fechar
local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 35, 0, 35)
btnClose.Position = UDim2.new(1, -37.5, 0, 2.5)
btnClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btnClose.BorderSizePixel = 0
btnClose.Text = "✕"
btnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
btnClose.TextSize = 18
btnClose.Font = Enum.Font.SourceSansBold
btnClose.Parent = titleBar

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: DESATIVADO"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Botão Ativar/Desativar
local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0, 280, 0, 50)
btnToggle.Position = UDim2.new(0, 20, 0, 90)
btnToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnToggle.BorderSizePixel = 2
btnToggle.BorderColor3 = Color3.fromRGB(255, 100, 100)
btnToggle.Text = "ATIVAR SISTEMA"
btnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
btnToggle.TextSize = 20
btnToggle.Font = Enum.Font.SourceSansBold
btnToggle.Parent = mainFrame

-- Display de comando
local cmdDisplay = Instance.new("TextLabel")
cmdDisplay.Size = UDim2.new(1, -20, 0, 40)
cmdDisplay.Position = UDim2.new(0, 10, 0, 150)
cmdDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
cmdDisplay.BorderSizePixel = 2
cmdDisplay.BorderColor3 = Color3.fromRGB(100, 100, 100)
cmdDisplay.Text = "Aguardando..."
cmdDisplay.TextColor3 = Color3.fromRGB(150, 150, 150)
cmdDisplay.TextSize = 16
cmdDisplay.Font = Enum.Font.SourceSansBold
cmdDisplay.Parent = mainFrame

-- Frame Minimizado
local miniFrame = Instance.new("Frame")
miniFrame.Name = "MiniFrame"
miniFrame.Size = UDim2.new(0, 180, 0, 45)
miniFrame.Position = UDim2.new(0.5, -90, 0.3, 0)
miniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
miniFrame.BorderSizePixel = 2
miniFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.Parent = screenGui

local miniLabel = Instance.new("TextLabel")
miniLabel.Size = UDim2.new(1, -50, 1, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.Text = "⚔️ VOLVER"
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.TextSize = 16
miniLabel.Font = Enum.Font.SourceSansBold
miniLabel.Parent = miniFrame

local btnRestore = Instance.new("TextButton")
btnRestore.Size = UDim2.new(0, 40, 0, 40)
btnRestore.Position = UDim2.new(1, -42.5, 0, 2.5)
btnRestore.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
btnRestore.BorderSizePixel = 0
btnRestore.Text = "+"
btnRestore.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRestore.TextSize = 24
btnRestore.Font = Enum.Font.SourceSansBold
btnRestore.Parent = miniFrame

-- Função para girar personagem
local function girarPersonagem(graus)
    if girando then return end
    girando = true
    
    wait(1) -- Espera 1 segundo
    
    -- Inverte direção
    local grausFinal = -graus
    
    local cfAtual = humanoidRootPart.CFrame
    local cfFinal = cfAtual * CFrame.Angles(0, math.rad(grausFinal), 0)
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = cfFinal})
    
    tween:Play()
    tween.Completed:Wait()
    
    girando = false
end

-- Função principal de verificação
local function verificarComandos()
    while sistemaAtivo do
        -- Procurar por TextLabels no topo da tela
        for _, elemento in pairs(playerGui:GetDescendants()) do
            if elemento:IsA("TextLabel") and elemento.Visible and elemento.Text ~= "" then
                local pos = elemento.AbsolutePosition
                local size = elemento.AbsoluteSize
                local screenSize = workspace.CurrentCamera.ViewportSize
                
                -- Verifica se está no topo e centralizado
                if pos.Y < 100 then
                    local centroX = pos.X + (size.X / 2)
                    local centroDaTela = screenSize.X / 2
                    
                    if math.abs(centroX - centroDaTela) < 500 then
                        local textoCompleto = elemento.Text
                        
                        -- Se for texto novo E não estiver girando
                        if textoCompleto ~= ultimoTexto and not girando then
                            ultimoTexto = textoCompleto
                            
                            -- Extrair comando
                            local comando = textoCompleto
                            if string.find(textoCompleto, ":") then
                                local partes = string.split(textoCompleto, ":")
                                if #partes >= 2 then
                                    comando = partes[2]:match("^%s*(.-)%s*$")
                                end
                            end
                            
                            -- Executar comandos
                            local executou = false
                            
                            if comando == "Direita, volver." then
                                cmdDisplay.Text = "✓ Direita"
                                cmdDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
                                print("✓ EXECUTANDO: Direita, volver.")
                                spawn(function() girarPersonagem(90) end)
                                executou = true
                                
                            elseif comando == "Esquerda, volver." then
                                cmdDisplay.Text = "✓ Esquerda"
                                cmdDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
                                print("✓ EXECUTANDO: Esquerda, volver.")
                                spawn(function() girarPersonagem(-90) end)
                                executou = true
                                
                            elseif comando == "Direita, inclinar." then
                                cmdDisplay.Text = "✓ Inclinar Direita"
                                cmdDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
                                print("✓ EXECUTANDO: Direita, inclinar.")
                                spawn(function() girarPersonagem(45) end)
                                executou = true
                                
                            elseif comando == "Esquerda, inclinar." then
                                cmdDisplay.Text = "✓ Inclinar Esquerda"
                                cmdDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
                                print("✓ EXECUTANDO: Esquerda, inclinar.")
                                spawn(function() girarPersonagem(-45) end)
                                executou = true
                                
                            elseif comando == "Retaguarda, volver." then
                                cmdDisplay.Text = "✓ Retaguarda"
                                cmdDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
                                print("✓ EXECUTANDO: Retaguarda, volver.")
                                spawn(function() girarPersonagem(180) end)
                                executou = true
                            end
                            
                            -- Se executou, AGUARDAR o texto SUMIR da tela
                            if executou then
                                print("Aguardando texto sumir...")
                                
                                -- Esperar até o texto sumir
                                while sistemaAtivo do
                                    local textoAindaExiste = false
                                    
                                    for _, elem in pairs(playerGui:GetDescendants()) do
                                        if elem:IsA("TextLabel") and elem.Visible and elem.Text == textoCompleto then
                                            local p = elem.AbsolutePosition
                                            if p.Y < 100 then
                                                textoAindaExiste = true
                                                break
                                            end
                                        end
                                    end
                                    
                                    if not textoAindaExiste then
                                        print("Texto sumiu! Pronto para próximo comando.")
                                        ultimoTexto = "" -- Resetar para aceitar novo comando
                                        break
                                    end
                                    
                                    wait(0.2)
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- Botão Toggle
btnToggle.MouseButton1Click:Connect(function()
    sistemaAtivo = not sistemaAtivo
    
    if sistemaAtivo then
        statusLabel.Text = "Status: ATIVADO ✓"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        btnToggle.Text = "DESATIVAR SISTEMA"
        btnToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        btnToggle.BorderColor3 = Color3.fromRGB(100, 255, 100)
        cmdDisplay.Text = "Aguardando comando..."
        cmdDisplay.TextColor3 = Color3.fromRGB(150, 150, 150)
        ultimoTexto = ""
        spawn(verificarComandos)
        print("✓ Sistema Ativado!")
    else
        statusLabel.Text = "Status: DESATIVADO"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        btnToggle.Text = "ATIVAR SISTEMA"
        btnToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btnToggle.BorderColor3 = Color3.fromRGB(255, 100, 100)
        cmdDisplay.Text = "Sistema desativado"
        cmdDisplay.TextColor3 = Color3.fromRGB(150, 150, 150)
        ultimoTexto = ""
        print("✗ Sistema Desativado!")
    end
end)

-- Botão Minimizar
btnMinimize.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

-- Botão Restaurar
btnRestore.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    mainFrame.Visible = true
end)

-- Botão Fechar
btnClose.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    sistemaAtivo = false
    print("Sistema Volver fechado!")
end)

-- Atualizar ao morrer
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

print("========================================")
print("✓ SISTEMA VOLVER CARREGADO!")
print("✓ GUI ABERTA!")
print("========================================")
