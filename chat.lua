-- Chat Auto-Copy Script para Mobile v2.0
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variáveis de controle
local targetPlayer = nil
local isEnabled = false
local gui = nil
local messageHistory = {}

-- Função para copiar texto para área de transferência
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        StarterGui:SetCore("SendNotification", {
            Title = "✓ Copiado!";
            Text = text:sub(1, 50) .. (text:len() > 50 and "..." or "");
            Duration = 2;
        })
    end
end

-- Função para enviar mensagem
local function sendMessage(text)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(text)
        end
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
    end
end

-- Função para criar a GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ChatCopyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Frame principal (maior e mais bonito)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 380, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainShadow = Instance.new("UIStroke")
    mainShadow.Color = Color3.fromRGB(60, 140, 255)
    mainShadow.Thickness = 2
    mainShadow.Transparency = 0.5
    mainShadow.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Barra de título com gradiente
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 140, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 100, 255))
    }
    titleGradient.Rotation = 90
    titleGradient.Parent = titleBar
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- Ícone decorativo
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 5, 0, 5)
    icon.BackgroundTransparency = 1
    icon.Text = "💬"
    icon.TextSize = 24
    icon.Parent = titleBar
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 45, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Chat Spy Pro"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(1, -50, 0.5, -5)
    statusDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = titleBar
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = statusDot
    
    -- Botão minimizar
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 35, 0, 35)
    minimizeButton.Position = UDim2.new(1, -84, 0, 7.5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    minimizeButton.Text = "─"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 18
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = minimizeButton
    
    -- Botão fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -42, 0, 7.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Container de conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Label do jogador selecionado
    local playerCard = Instance.new("Frame")
    playerCard.Size = UDim2.new(1, 0, 0, 60)
    playerCard.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    playerCard.BorderSizePixel = 0
    playerCard.Parent = contentFrame
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = playerCard
    
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Name = "PlayerLabel"
    playerLabel.Size = UDim2.new(1, -100, 0, 30)
    playerLabel.Position = UDim2.new(0, 10, 0, 5)
    playerLabel.BackgroundTransparency = 1
    playerLabel.Text = "👤 Nenhum jogador"
    playerLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    playerLabel.TextSize = 15
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerLabel.Parent = playerCard
    
    local msgCount = Instance.new("TextLabel")
    msgCount.Name = "MsgCount"
    msgCount.Size = UDim2.new(1, -10, 0, 20)
    msgCount.Position = UDim2.new(0, 10, 0, 35)
    msgCount.BackgroundTransparency = 1
    msgCount.Text = "📊 0 mensagens capturadas"
    msgCount.TextColor3 = Color3.fromRGB(140, 140, 140)
    msgCount.TextSize = 12
    msgCount.Font = Enum.Font.Gotham
    msgCount.TextXAlignment = Enum.TextXAlignment.Left
    msgCount.Parent = playerCard
    
    -- Botões de controle
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 0, 90)
    buttonContainer.Position = UDim2.new(0, 0, 0, 70)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = contentFrame
    
    -- Botão de selecionar jogador
    local selectButton = Instance.new("TextButton")
    selectButton.Name = "SelectButton"
    selectButton.Size = UDim2.new(1, 0, 0, 40)
    selectButton.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    selectButton.Text = "🎯 Selecionar Jogador"
    selectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectButton.TextSize = 15
    selectButton.Font = Enum.Font.GothamBold
    selectButton.Parent = buttonContainer
    
    local selectGradient = Instance.new("UIGradient")
    selectGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 120, 255))
    }
    selectGradient.Rotation = 90
    selectGradient.Parent = selectButton
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 10)
    selectCorner.Parent = selectButton
    
    -- Botão Ativar/Desativar
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 0, 40)
    toggleButton.Position = UDim2.new(0, 0, 0, 50)
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    toggleButton.Text = "⚫ Desativado"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 15
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = buttonContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleButton
    
    -- Área de histórico de mensagens
    local historyLabel = Instance.new("TextLabel")
    historyLabel.Size = UDim2.new(1, 0, 0, 25)
    historyLabel.Position = UDim2.new(0, 0, 0, 170)
    historyLabel.BackgroundTransparency = 1
    historyLabel.Text = "📜 Histórico de Mensagens"
    historyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    historyLabel.TextSize = 14
    historyLabel.Font = Enum.Font.GothamBold
    historyLabel.TextXAlignment = Enum.TextXAlignment.Left
    historyLabel.Parent = contentFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "MessageHistory"
    scrollFrame.Size = UDim2.new(1, 0, 1, -205)
    scrollFrame.Position = UDim2.new(0, 0, 0, 200)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 140, 255)
    scrollFrame.Parent = contentFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 10)
    scrollCorner.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scrollFrame
    
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 8)
    listPadding.PaddingBottom = UDim.new(0, 8)
    listPadding.PaddingLeft = UDim.new(0, 8)
    listPadding.PaddingRight = UDim.new(0, 8)
    listPadding.Parent = scrollFrame
    
    -- Função para adicionar mensagem ao histórico
    local function addMessage(message)
        table.insert(messageHistory, message)
        msgCount.Text = "📊 " .. #messageHistory .. " mensagens capturadas"
        
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, -16, 0, 70)
        msgFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        msgFrame.BorderSizePixel = 0
        msgFrame.Parent = scrollFrame
        
        local msgCorner = Instance.new("UICorner")
        msgCorner.CornerRadius = UDim.new(0, 8)
        msgCorner.Parent = msgFrame
        
        local msgText = Instance.new("TextLabel")
        msgText.Size = UDim2.new(1, -210, 1, -10)
        msgText.Position = UDim2.new(0, 8, 0, 5)
        msgText.BackgroundTransparency = 1
        msgText.Text = message
        msgText.TextColor3 = Color3.fromRGB(230, 230, 230)
        msgText.TextSize = 13
        msgText.Font = Enum.Font.Gotham
        msgText.TextWrapped = true
        msgText.TextXAlignment = Enum.TextXAlignment.Left
        msgText.TextYAlignment = Enum.TextYAlignment.Top
        msgText.Parent = msgFrame
        
        -- Botão deletar (lixeira)
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 45, 0, 28)
        deleteBtn.Position = UDim2.new(1, -193, 0, 36)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        deleteBtn.Text = "🗑️"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.TextSize = 16
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.Parent = msgFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 6)
        deleteCorner.Parent = deleteBtn
        
        deleteBtn.MouseButton1Click:Connect(function()
            -- Remove da tabela
            for i, msg in ipairs(messageHistory) do
                if msg == message then
                    table.remove(messageHistory, i)
                    break
                end
            end
            
            -- Remove visualmente com animação
            game:GetService("TweenService"):Create(msgFrame, TweenInfo.new(0.3), {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 0, 0)
            }):Play()
            
            task.wait(0.3)
            msgFrame:Destroy()
            
            -- Atualiza contador
            msgCount.Text = "📊 " .. #messageHistory .. " mensagens capturadas"
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
            
            StarterGui:SetCore("SendNotification", {
                Title = "🗑️ Deletado!";
                Text = "Mensagem removida";
                Duration = 2;
            })
        end)
        
        -- Botão copiar
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 60, 0, 28)
        copyBtn.Position = UDim2.new(1, -128, 0, 36)
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
        copyBtn.Text = "📋"
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.TextSize = 16
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.Parent = msgFrame
        
        local copyCorner = Instance.new("UICorner")
        copyCorner.CornerRadius = UDim.new(0, 6)
        copyCorner.Parent = copyBtn
        
        copyBtn.MouseButton1Click:Connect(function()
            copyToClipboard(message)
        end)
        
        -- Botão enviar
        local sendBtn = Instance.new("TextButton")
        sendBtn.Size = UDim2.new(0, 60, 0, 28)
        sendBtn.Position = UDim2.new(1, -62, 0, 36)
        sendBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        sendBtn.Text = "📤"
        sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sendBtn.TextSize = 16
        sendBtn.Font = Enum.Font.GothamBold
        sendBtn.Parent = msgFrame
        
        local sendCorner = Instance.new("UICorner")
        sendCorner.CornerRadius = UDim.new(0, 6)
        sendCorner.Parent = sendBtn
        
        sendBtn.MouseButton1Click:Connect(function()
            sendMessage(message)
            StarterGui:SetCore("SendNotification", {
                Title = "✓ Enviado!";
                Text = message:sub(1, 50) .. (message:len() > 50 and "..." or "");
                Duration = 2;
            })
        end)
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
        scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)
    end
    
    -- Tornar arrastável
    local dragging = false
    local dragInput, mousePos, framePos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    -- Função para criar lista de jogadores
    local function showPlayerList()
        local listFrame = Instance.new("Frame")
        listFrame.Name = "PlayerList"
        listFrame.Size = UDim2.new(0, 300, 0, 350)
        listFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
        listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        listFrame.BorderSizePixel = 0
        listFrame.Parent = screenGui
        
        local listStroke = Instance.new("UIStroke")
        listStroke.Color = Color3.fromRGB(60, 140, 255)
        listStroke.Thickness = 2
        listStroke.Parent = listFrame
        
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 12)
        listCorner.Parent = listFrame
        
        local listTitle = Instance.new("Frame")
        listTitle.Size = UDim2.new(1, 0, 0, 45)
        listTitle.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
        listTitle.BorderSizePixel = 0
        listTitle.Parent = listFrame
        
        local listTitleCorner = Instance.new("UICorner")
        listTitleCorner.CornerRadius = UDim.new(0, 12)
        listTitleCorner.Parent = listTitle
        
        local titleText = Instance.new("TextLabel")
        titleText.Size = UDim2.new(1, 0, 1, 0)
        titleText.BackgroundTransparency = 1
        titleText.Text = "👥 Selecione um Jogador"
        titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleText.TextSize = 16
        titleText.Font = Enum.Font.GothamBold
        titleText.Parent = listTitle
        
        local scrollFrame2 = Instance.new("ScrollingFrame")
        scrollFrame2.Size = UDim2.new(1, -20, 1, -65)
        scrollFrame2.Position = UDim2.new(0, 10, 0, 50)
        scrollFrame2.BackgroundTransparency = 1
        scrollFrame2.ScrollBarThickness = 6
        scrollFrame2.ScrollBarImageColor3 = Color3.fromRGB(60, 140, 255)
        scrollFrame2.Parent = listFrame
        
        local listLayout2 = Instance.new("UIListLayout")
        listLayout2.Padding = UDim.new(0, 8)
        listLayout2.Parent = scrollFrame2
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, -10, 0, 40)
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                button.Text = "  👤 " .. player.Name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.Font = Enum.Font.GothamBold
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.Parent = scrollFrame2
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = button
                
                button.MouseButton1Click:Connect(function()
                    targetPlayer = player
                    playerLabel.Text = "👤 " .. player.Name
                    listFrame:Destroy()
                    StarterGui:SetCore("SendNotification", {
                        Title = "✓ Selecionado";
                        Text = player.Name;
                        Duration = 3;
                    })
                end)
            end
        end
        
        scrollFrame2.CanvasSize = UDim2.new(0, 0, 0, listLayout2.AbsoluteContentSize.Y)
    end
    
    -- Eventos dos botões
    selectButton.MouseButton1Click:Connect(showPlayerList)
    
    -- Variável para controlar estado minimizado
    local isMinimized = false
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            -- Minimizar
            game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 380, 0, 50)
            }):Play()
            contentFrame.Visible = false
            minimizeButton.Text = "□"
        else
            -- Restaurar
            game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 380, 0, 520)
            }):Play()
            contentFrame.Visible = true
            minimizeButton.Text = "─"
        end
    end)
    
    toggleButton.MouseButton1Click:Connect(function()
        if not targetPlayer then
            StarterGui:SetCore("SendNotification", {
                Title = "⚠️ Erro";
                Text = "Selecione um jogador primeiro!";
                Duration = 3;
            })
            return
        end
        
        isEnabled = not isEnabled
        if isEnabled then
            toggleButton.Text = "🟢 Ativado"
            toggleButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
            statusDot.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
        else
            toggleButton.Text = "⚫ Desativado"
            toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            statusDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return screenGui, addMessage
end

-- Monitorar chat
local addMessageFunc
local function onChatted(player, message)
    if isEnabled and targetPlayer and player == targetPlayer then
        copyToClipboard(message)
        if addMessageFunc then
            addMessageFunc(message)
        end
    end
end

-- Conectar ao chat de todos os jogadores
for _, player in pairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        onChatted(player, msg)
    end)
end)

-- Criar GUI
local guiObj, addMsg = createGUI()
gui = guiObj
addMessageFunc = addMsg

StarterGui:SetCore("SendNotification", {
    Title = "✓ Chat Spy Pro";
    Text = "Script carregado com sucesso!";
    Duration = 4;
})

print("Chat Spy Pro v2.0 carregado!")
