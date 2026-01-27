-- Chat Spy Pro + Tradutor - Design Premium
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("ChatSpyGUI") then
    PlayerGui:FindFirstChild("ChatSpyGUI"):Destroy()
end

local targetPlayer = nil
local isEnabled = false
local messageHistory = {}

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

local function translateText(text, callback)
    local apiUrl = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=pt&dt=t&q=" .. HttpService:UrlEncode(text)
    
    local success, result = pcall(function()
        return game:HttpGet(apiUrl)
    end)
    
    if success then
        local translated = result:match('%[%[%["(.-)"%,')
        if translated then
            callback(translated)
        else
            callback("Erro ao traduzir")
        end
    else
        callback("Erro: Tradução não disponível")
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChatSpyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game:GetService("Lighting")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 620)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -310)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

addCorner(MainFrame, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
addCorner(TopBar, 16)

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 16)
TopFix.Position = UDim2.new(0, 0, 1, -16)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0.5, -20)
Logo.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
Logo.Text = "💬"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 24
Logo.Font = Enum.Font.GothamBold
Logo.Parent = TopBar
addCorner(Logo, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 58, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Chat Spy Pro"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -140, 0, 20)
Subtitle.Position = UDim2.new(0, 58, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v3.0 + Tradutor"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 170)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -95, 0.5, -20)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar
addCorner(MinimizeButton, 10)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar
addCorner(CloseButton, 10)

local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Size = UDim2.new(0, 70, 0, 70)
MinimizedButton.Position = UDim2.new(1, -80, 0, 20)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
MinimizedButton.Text = "💬"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.TextSize = 32
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Visible = false
MinimizedButton.Active = true
MinimizedButton.Draggable = true
MinimizedButton.Parent = ScreenGui
addCorner(MinimizedButton, 35)

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(150, 150, 255)
MinStroke.Thickness = 3
MinStroke.Parent = MinimizedButton

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local PlayerCard = Instance.new("Frame")
PlayerCard.Size = UDim2.new(1, 0, 0, 60)
PlayerCard.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerCard.BorderSizePixel = 0
PlayerCard.Parent = ContentFrame
addCorner(PlayerCard, 10)

local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Size = UDim2.new(1, -20, 0, 30)
PlayerLabel.Position = UDim2.new(0, 10, 0, 5)
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.Text = "👤 Nenhum jogador"
PlayerLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
PlayerLabel.TextSize = 15
PlayerLabel.Font = Enum.Font.GothamBold
PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerLabel.Parent = PlayerCard

local MsgCount = Instance.new("TextLabel")
MsgCount.Size = UDim2.new(1, -20, 0, 20)
MsgCount.Position = UDim2.new(0, 10, 0, 35)
MsgCount.BackgroundTransparency = 1
MsgCount.Text = "📊 0 mensagens capturadas"
MsgCount.TextColor3 = Color3.fromRGB(140, 140, 140)
MsgCount.TextSize = 12
MsgCount.Font = Enum.Font.Gotham
MsgCount.TextXAlignment = Enum.TextXAlignment.Left
MsgCount.Parent = PlayerCard

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 90)
ButtonContainer.Position = UDim2.new(0, 0, 0, 70)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = ContentFrame

local SelectButton = Instance.new("TextButton")
SelectButton.Size = UDim2.new(1, 0, 0, 40)
SelectButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
SelectButton.Text = "🎯 Selecionar Jogador"
SelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectButton.TextSize = 15
SelectButton.Font = Enum.Font.GothamBold
SelectButton.Parent = ButtonContainer
addCorner(SelectButton, 10)

local SelectGradient = Instance.new("UIGradient")
SelectGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 255))
}
SelectGradient.Rotation = 90
SelectGradient.Parent = SelectButton

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 40)
ToggleButton.Position = UDim2.new(0, 0, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
ToggleButton.Text = "⚫ Desativado"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 15
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ButtonContainer
addCorner(ToggleButton, 10)

local HistoryLabel = Instance.new("TextLabel")
HistoryLabel.Size = UDim2.new(1, 0, 0, 25)
HistoryLabel.Position = UDim2.new(0, 0, 0, 170)
HistoryLabel.BackgroundTransparency = 1
HistoryLabel.Text = "📜 Histórico de Mensagens"
HistoryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
HistoryLabel.TextSize = 14
HistoryLabel.Font = Enum.Font.GothamBold
HistoryLabel.TextXAlignment = Enum.TextXAlignment.Left
HistoryLabel.Parent = ContentFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -205)
ScrollFrame.Position = UDim2.new(0, 0, 0, 200)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
ScrollFrame.Parent = ContentFrame
addCorner(ScrollFrame, 10)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ScrollFrame

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 8)
ListPadding.PaddingBottom = UDim.new(0, 8)
ListPadding.PaddingLeft = UDim.new(0, 8)
ListPadding.PaddingRight = UDim.new(0, 8)
ListPadding.Parent = ScrollFrame

local function addMessage(message)
    table.insert(messageHistory, message)
    MsgCount.Text = "📊 " .. #messageHistory .. " mensagens capturadas"
    
    local msgFrame = Instance.new("Frame")
    msgFrame.Size = UDim2.new(1, -16, 0, 70)
    msgFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    msgFrame.BorderSizePixel = 0
    msgFrame.Parent = ScrollFrame
    addCorner(msgFrame, 8)
    
    local msgText = Instance.new("TextLabel")
    msgText.Size = UDim2.new(1, -270, 1, -10)
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
    
    local translateBtn = Instance.new("TextButton")
    translateBtn.Size = UDim2.new(0, 60, 0, 28)
    translateBtn.Position = UDim2.new(1, -258, 0, 36)
    translateBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 60)
    translateBtn.Text = "🌐"
    translateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    translateBtn.TextSize = 16
    translateBtn.Font = Enum.Font.GothamBold
    translateBtn.Parent = msgFrame
    addCorner(translateBtn, 6)
    
    translateBtn.MouseButton1Click:Connect(function()
        translateBtn.Text = "⏳"
        translateText(message, function(translated)
            translateBtn.Text = "🌐"
            msgText.Text = translated
            StarterGui:SetCore("SendNotification", {
                Title = "🌐 Traduzido!";
                Text = "Mensagem traduzida para português";
                Duration = 2;
            })
        end)
    end)
    
    local deleteBtn = Instance.new("TextButton")
    deleteBtn.Size = UDim2.new(0, 60, 0, 28)
    deleteBtn.Position = UDim2.new(1, -193, 0, 36)
    deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    deleteBtn.Text = "🗑️"
    deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteBtn.TextSize = 16
    deleteBtn.Font = Enum.Font.GothamBold
    deleteBtn.Parent = msgFrame
    addCorner(deleteBtn, 6)
    
    deleteBtn.MouseButton1Click:Connect(function()
        for i, msg in ipairs(messageHistory) do
            if msg == message then
                table.remove(messageHistory, i)
                break
            end
        end
        
        TweenService:Create(msgFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 0, 0)
        }):Play()
        
        task.wait(0.3)
        msgFrame:Destroy()
        MsgCount.Text = "📊 " .. #messageHistory .. " mensagens capturadas"
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
        
        StarterGui:SetCore("SendNotification", {
            Title = "🗑️ Deletado!";
            Text = "Mensagem removida";
            Duration = 2;
        })
    end)
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 60, 0, 28)
    copyBtn.Position = UDim2.new(1, -128, 0, 36)
    copyBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
    copyBtn.Text = "📋"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 16
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Parent = msgFrame
    addCorner(copyBtn, 6)
    
    copyBtn.MouseButton1Click:Connect(function()
        copyToClipboard(msgText.Text)
    end)
    
    local sendBtn = Instance.new("TextButton")
    sendBtn.Size = UDim2.new(0, 60, 0, 28)
    sendBtn.Position = UDim2.new(1, -62, 0, 36)
    sendBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sendBtn.Text = "📤"
    sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendBtn.TextSize = 16
    sendBtn.Font = Enum.Font.GothamBold
    sendBtn.Parent = msgFrame
    addCorner(sendBtn, 6)
    
    sendBtn.MouseButton1Click:Connect(function()
        sendMessage(msgText.Text)
        StarterGui:SetCore("SendNotification", {
            Title = "✓ Enviado!";
            Text = msgText.Text:sub(1, 50) .. (msgText.Text:len() > 50 and "..." or "");
            Duration = 2;
        })
    end)
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
    ScrollFrame.CanvasPosition = Vector2.new(0, ScrollFrame.CanvasSize.Y.Offset)
end

local function showPlayerList()
    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(0, 300, 0, 350)
    listFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    listFrame.BorderSizePixel = 0
    listFrame.Parent = ScreenGui
    addCorner(listFrame, 12)
    
    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(60, 60, 80)
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    
    local listTitle = Instance.new("Frame")
    listTitle.Size = UDim2.new(1, 0, 0, 45)
    listTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    listTitle.BorderSizePixel = 0
    listTitle.Parent = listFrame
    addCorner(listTitle, 12)
    
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
    scrollFrame2.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    scrollFrame2.Parent = listFrame
    
    local listLayout2 = Instance.new("UIListLayout")
    listLayout2.Padding = UDim.new(0, 8)
    listLayout2.Parent = scrollFrame2
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 40)
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            button.Text = "  👤 " .. player.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.Parent = scrollFrame2
            addCorner(button, 8)
            
            button.MouseButton1Click:Connect(function()
                targetPlayer = player
                PlayerLabel.Text = "👤 " .. player.Name
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

SelectButton.MouseButton1Click:Connect(showPlayerList)

ToggleButton.MouseButton1Click:Connect(function()
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
        ToggleButton.Text = "🟢 Ativado"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
    else
        ToggleButton.Text = "⚫ Desativado"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    end
end)

local function onChatted(player, message)
    if isEnabled and targetPlayer and player == targetPlayer then
        copyToClipboard(message)
        addMessage(message)
    end
end

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

MinimizeButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    MinimizedButton.Visible = true
    MinimizedButton.Size = UDim2.new(0, 0, 0, 0)
    MinimizedButton.Position = UDim2.new(1, -45, 0, 55)
    TweenService:Create(MinimizedButton, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(1, -80, 0, 20)}):Play()
end)

MinimizedButton.MouseButton1Click:Connect(function()
    TweenService:Create(MinimizedButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 10}):Play()
    task.wait(0.3)
    MinimizedButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 380, 0, 620), Position = UDim2.new(0.5, -190, 0.5, -310)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
    Blur:Destroy()
end)

TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 10}):Play()

print("✅ Chat Spy Pro + Tradutor Carregado!")
print("📌 Design Premium - Tradutor Google integrado!")
