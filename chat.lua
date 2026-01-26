-- Chat Auto-Copy Script para Mobile
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Variáveis de controle
local targetPlayer = nil
local isEnabled = false
local gui = nil

-- Função para copiar texto para área de transferência
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        StarterGui:SetCore("SendNotification", {
            Title = "Copiado!";
            Text = text;
            Duration = 2;
        })
    end
end

-- Função para criar a GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ChatCopyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    title.Text = "Chat Auto-Copy"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    -- Label do jogador selecionado
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Name = "PlayerLabel"
    playerLabel.Size = UDim2.new(1, -20, 0, 30)
    playerLabel.Position = UDim2.new(0, 10, 0, 50)
    playerLabel.BackgroundTransparency = 1
    playerLabel.Text = "Nenhum jogador selecionado"
    playerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    playerLabel.TextSize = 14
    playerLabel.Font = Enum.Font.Gotham
    playerLabel.Parent = mainFrame
    
    -- Botão de selecionar jogador
    local selectButton = Instance.new("TextButton")
    selectButton.Name = "SelectButton"
    selectButton.Size = UDim2.new(1, -20, 0, 40)
    selectButton.Position = UDim2.new(0, 10, 0, 90)
    selectButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    selectButton.Text = "Selecionar Jogador"
    selectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectButton.TextSize = 16
    selectButton.Font = Enum.Font.GothamBold
    selectButton.Parent = mainFrame
    
    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 8)
    selectCorner.Parent = selectButton
    
    -- Botão Ativar/Desativar
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 140)
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Text = "Desativado"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 16
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    -- Botão fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Tornar arrastável
    local dragging = false
    local dragInput, mousePos, framePos
    
    mainFrame.InputBegan:Connect(function(input)
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
    
    mainFrame.InputChanged:Connect(function(input)
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
        listFrame.Size = UDim2.new(0, 250, 0, 300)
        listFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
        listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        listFrame.BorderSizePixel = 0
        listFrame.Parent = screenGui
        
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 10)
        listCorner.Parent = listFrame
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -10, 1, -50)
        scrollFrame.Position = UDim2.new(0, 5, 0, 40)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.Parent = listFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 5)
        listLayout.Parent = scrollFrame
        
        local listTitle = Instance.new("TextLabel")
        listTitle.Size = UDim2.new(1, 0, 0, 35)
        listTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        listTitle.Text = "Selecione um Jogador"
        listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        listTitle.TextSize = 16
        listTitle.Font = Enum.Font.GothamBold
        listTitle.Parent = listFrame
        
        local titleCorner2 = Instance.new("UICorner")
        titleCorner2.CornerRadius = UDim.new(0, 10)
        titleCorner2.Parent = listTitle
        
        for _, player in pairs(Players:GetPlayers()) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 35)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.Text = player.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = scrollFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                targetPlayer = player
                playerLabel.Text = "Alvo: " .. player.Name
                listFrame:Destroy()
                StarterGui:SetCore("SendNotification", {
                    Title = "Jogador Selecionado";
                    Text = player.Name;
                    Duration = 3;
                })
            end)
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end
    
    -- Eventos dos botões
    selectButton.MouseButton1Click:Connect(showPlayerList)
    
    toggleButton.MouseButton1Click:Connect(function()
        if not targetPlayer then
            StarterGui:SetCore("SendNotification", {
                Title = "Erro";
                Text = "Selecione um jogador primeiro!";
                Duration = 3;
            })
            return
        end
        
        isEnabled = not isEnabled
        if isEnabled then
            toggleButton.Text = "Ativado"
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            toggleButton.Text = "Desativado"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return screenGui
end

-- Monitorar chat
local function onChatted(player, message)
    if isEnabled and targetPlayer and player == targetPlayer then
        copyToClipboard(message)
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
gui = createGUI()

print("Chat Auto-Copy carregado! Abra a interface para selecionar um jogador.")
