-- GUI VOLVER + HITBOX COLORIDA (ESP HITBOX MELHORADO)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("VolverGUI") then
    PlayerGui:FindFirstChild("VolverGUI"):Destroy()
end

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

_G.Config = {
    VolverAtivo = false,
    ultimoTexto = "",
    girando = false,
    ultimoComandoChat = "",
    HitboxEnabled = false,
    HitboxSize = 25,
    HitboxInvisible = false,
    HitboxTeam = false,
    ESPPlayers = false,
    ESPHitbox = false
}

local originalSizes = {}
local ESPObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VolverGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
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
Logo.Text = "🎖️"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 24
Logo.Font = Enum.Font.GothamBold
Logo.Parent = TopBar
addCorner(Logo, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 58, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Sistema Volver + Hitbox"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -140, 0, 20)
Subtitle.Position = UDim2.new(0, 58, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v1.1 ESP Melhorado"
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
MinimizedButton.Text = "🎖️"
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

-- SISTEMA DE ABAS
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 50)
TabContainer.Position = UDim2.new(0, 10, 0, 65)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabs, frames = {}, {}

local function createTab(name, icon, position)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.333, -5, 1, 0)
    tab.Position = UDim2.new(position * 0.333, 0, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tab.Text = ""
    tab.Parent = TabContainer
    addCorner(tab, 10)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 0, 22)
    iconLabel.Position = UDim2.new(0, 0, 0, 4)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = tab
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.Position = UDim2.new(0, 0, 1, -20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = tab
    
    tabs[name] = {button = tab, icon = iconLabel, name = nameLabel}
    return tab
end

createTab("Volver", "🎖️", 0)
createTab("Hitbox", "🎯", 1)
createTab("ESP", "👁️", 2)

local function createFrame(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -20, 1, -130)
    frame.Position = UDim2.new(0, 10, 0, 120)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.Parent = MainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)
    
    frames[name] = frame
    return frame
end

local VolverFrame = createFrame("Volver")
local HitboxFrame = createFrame("Hitbox")
local ESPFrame = createFrame("ESP")

local function switchTab(tabName)
    for name, tab in pairs(tabs) do
        tab.button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        tab.icon.TextColor3 = Color3.fromRGB(150, 150, 170)
        tab.name.TextColor3 = Color3.fromRGB(150, 150, 170)
        frames[name].Visible = false
    end
    tabs[tabName].button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    tabs[tabName].icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabs[tabName].name.TextColor3 = Color3.fromRGB(255, 255, 255)
    frames[tabName].Visible = true
end

for name, tab in pairs(tabs) do
    tab.button.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

local function createToggle(parent, text, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = parent
    addCorner(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 45, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggle.Text = ""
    toggle.Parent = container
    addCorner(toggle, 25)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 19, 0, 19)
    circle.Position = UDim2.new(0, 3, 0.5, -9.5)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    circle.BorderSizePixel = 0
    circle.Parent = toggle
    addCorner(circle, 10)
    
    local enabled = default
    
    local function update()
        if enabled then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -9.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9.5), BackgroundColor3 = Color3.fromRGB(200, 200, 220)}):Play()
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        callback(enabled)
    end)
    
    update()
end

local function createSlider(parent, text, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 65)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = parent
    addCorner(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -18)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    addCorner(sliderBg, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    addCorner(fill, 3)
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            MainFrame.Draggable = false
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            MainFrame.Draggable = true
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = LocalPlayer:GetMouse()
            local relX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relX / sliderBg.AbsoluteSize.X
            local value = math.floor(min + (percent * (max - min)))
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
end

-- SEÇÃO VOLVER
local volverSection = Instance.new("TextLabel")
volverSection.Size = UDim2.new(1, 0, 0, 35)
volverSection.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
volverSection.Text = "⚔️ SISTEMA VOLVER"
volverSection.TextColor3 = Color3.fromRGB(255, 255, 255)
volverSection.TextSize = 16
volverSection.Font = Enum.Font.GothamBold
volverSection.LayoutOrder = 1
volverSection.Parent = VolverFrame
addCorner(volverSection, 10)

local volverStatus = Instance.new("TextLabel")
volverStatus.Size = UDim2.new(1, 0, 0, 60)
volverStatus.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
volverStatus.Text = "📡 Status: DESATIVADO"
volverStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
volverStatus.TextSize = 14
volverStatus.Font = Enum.Font.GothamBold
volverStatus.LayoutOrder = 2
volverStatus.Parent = VolverFrame
addCorner(volverStatus, 10)

createToggle(VolverFrame, "Ativar Sistema Volver", false, function(v)
    _G.Config.VolverAtivo = v
    if v then
        volverStatus.Text = "📡 Status: ATIVADO ✓"
        volverStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        volverStatus.Text = "📡 Status: DESATIVADO"
        volverStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end, 3)

local cmdMonitor = Instance.new("TextLabel")
cmdMonitor.Size = UDim2.new(1, 0, 0, 80)
cmdMonitor.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
cmdMonitor.Text = "📋 Últimos Comandos\n\nAguardando..."
cmdMonitor.TextColor3 = Color3.fromRGB(150, 150, 170)
cmdMonitor.TextSize = 12
cmdMonitor.Font = Enum.Font.Code
cmdMonitor.TextWrapped = true
cmdMonitor.TextYAlignment = Enum.TextYAlignment.Top
cmdMonitor.LayoutOrder = 4
cmdMonitor.Parent = VolverFrame
addCorner(cmdMonitor, 10)

-- SEÇÃO HITBOX
local hitboxSection = Instance.new("TextLabel")
hitboxSection.Size = UDim2.new(1, 0, 0, 35)
hitboxSection.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
hitboxSection.Text = "🎯 HITBOX COLORIDA"
hitboxSection.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxSection.TextSize = 16
hitboxSection.Font = Enum.Font.GothamBold
hitboxSection.LayoutOrder = 1
hitboxSection.Parent = HitboxFrame
addCorner(hitboxSection, 10)

createSlider(HitboxFrame, "Tamanho da Hitbox", 1, 100, 25, function(v)
    _G.Config.HitboxSize = v
end, 2)

createToggle(HitboxFrame, "Hitbox Invisível", false, function(v)
    _G.Config.HitboxInvisible = v
end, 3)

createToggle(HitboxFrame, "Hitbox Time", false, function(v)
    _G.Config.HitboxTeam = v
end, 4)

createToggle(HitboxFrame, "Ativar Hitbox", false, function(v)
    _G.Config.HitboxEnabled = v
    if not v then
        for player, data in pairs(originalSizes) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = data.Size
                hrp.Transparency = data.Transparency
                hrp.Material = data.Material
                hrp.CanCollide = data.CanCollide
            end
        end
        originalSizes = {}
    end
end, 5)

-- SEÇÃO ESP
local espSection = Instance.new("TextLabel")
espSection.Size = UDim2.new(1, 0, 0, 35)
espSection.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
espSection.Text = "👁️ ESP SYSTEM"
espSection.TextColor3 = Color3.fromRGB(255, 255, 255)
espSection.TextSize = 16
espSection.Font = Enum.Font.GothamBold
espSection.LayoutOrder = 1
espSection.Parent = ESPFrame
addCorner(espSection, 10)

createToggle(ESPFrame, "ESP Players (Com Vida)", false, function(v)
    _G.Config.ESPPlayers = v
end, 2)

createToggle(ESPFrame, "ESP Hitbox (Nome + Vida + Box)", false, function(v)
    _G.Config.ESPHitbox = v
end, 3)

-- FUNÇÃO DE GIRAR PERSONAGEM (VOLVER)
local function girarPersonagem(graus)
    if _G.Config.girando then return end
    _G.Config.girando = true
    task.wait(1)
    local grausFinal = -graus
    local cfAtual = humanoidRootPart.CFrame
    local cfFinal = cfAtual * CFrame.Angles(0, math.rad(grausFinal), 0)
    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = cfFinal})
    tween:Play()
    tween.Completed:Wait()
    _G.Config.girando = false
end

-- PROCESSAR COMANDOS VOLVER
local function processarComando(comando, origem)
    if comando == "Direita, volver." or comando == "/a Direita, volver." then
        cmdMonitor.Text = "📋 Últimos Comandos\n\n✓ Direita (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(90) end)
        return true
    elseif comando == "Esquerda, volver." or comando == "/a Esquerda, volver." then
        cmdMonitor.Text = "📋 Últimos Comandos\n\n✓ Esquerda (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(-90) end)
        return true
    elseif comando == "Direita, inclinar." or comando == "/a Direita, inclinar." then
        cmdMonitor.Text = "📋 Últimos Comandos\n\n✓ Inclinar Direita (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(45) end)
        return true
    elseif comando == "Esquerda, inclinar." or comando == "/a Esquerda, inclinar." then
        cmdMonitor.Text = "📋 Últimos Comandos\n\n✓ Inclinar Esquerda (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(-45) end)
        return true
    elseif comando == "Retaguarda, volver." or comando == "/a Retaguarda, volver." then
        cmdMonitor.Text = "📋 Últimos Comandos\n\n✓ Retaguarda (" .. origem .. ")"
        cmdMonitor.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function() girarPersonagem(180) end)
        return true
    end
    return false
end

-- DETECTOR DE COMANDOS NO TOPO DA TELA
task.spawn(function()
    while task.wait(0.5) do
        if _G.Config.VolverAtivo and not _G.Config.girando then
            pcall(function()
                for _, elemento in pairs(PlayerGui:GetDescendants()) do
                    if elemento:IsA("TextLabel") and elemento.Visible and elemento.Text ~= "" then
                        local pos = elemento.AbsolutePosition
                        if pos.Y < 100 then
                            local textoCompleto = elemento.Text
                            if textoCompleto ~= _G.Config.ultimoTexto then
                                _G.Config.ultimoTexto = textoCompleto
                                local comando = textoCompleto
                                if string.find(textoCompleto, ":") then
                                    local partes = string.split(textoCompleto, ":")
                                    if #partes >= 2 then
                                        comando = partes[2]:match("^%s*(.-)%s*$")
                                    end
                                end
                                processarComando(comando, "Topo")
                                task.wait(2)
                                _G.Config.ultimoTexto = ""
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- DETECTOR DE COMANDOS NO CHAT (TextChatService)
pcall(function()
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channels = TextChatService:WaitForChild("TextChannels", 5)
        if channels then
            local generalChannel = channels:WaitForChild("RBXGeneral", 5)
            if generalChannel then
                generalChannel.MessageReceived:Connect(function(message)
                    if _G.Config.VolverAtivo and not _G.Config.girando then
                        local texto = message.Text
                        if texto ~= _G.Config.ultimoComandoChat then
                            _G.Config.ultimoComandoChat = texto
                            if processarComando(texto, "Chat") then
                                task.wait(2)
                                _G.Config.ultimoComandoChat = ""
                            end
                        end
                    end
                end)
            end
        end
    end
end)

-- DETECTOR DE COMANDOS NO CHAT (Legacy)
pcall(function()
    local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if events then
        local onMsg = events:FindFirstChild("OnMessageDoneFiltering")
        if onMsg then
            onMsg.OnClientEvent:Connect(function(data)
                if _G.Config.VolverAtivo and not _G.Config.girando then
                    local texto = data.Message
                    if texto ~= _G.Config.ultimoComandoChat then
                        _G.Config.ultimoComandoChat = texto
                        if processarComando(texto, "Chat") then
                            task.wait(2)
                            _G.Config.ultimoComandoChat = ""
                        end
                    end
                end
            end)
        end
    end
end)

-- SISTEMA DE HITBOX COLORIDA POR TIME
local function applyHitbox(player)
    if not player.Character or player == LocalPlayer then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not originalSizes[player] then
        originalSizes[player] = {
            Size = hrp.Size,
            Transparency = hrp.Transparency,
            Material = hrp.Material,
            CanCollide = hrp.CanCollide
        }
    end
    
    local shouldApply = _G.Config.HitboxTeam or (player.Team ~= LocalPlayer.Team)
    
    if _G.Config.HitboxEnabled and shouldApply then
        hrp.Size = Vector3.new(_G.Config.HitboxSize, _G.Config.HitboxSize, _G.Config.HitboxSize)
        hrp.Transparency = _G.Config.HitboxInvisible and 1 or 0.7
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
        hrp.BrickColor = player.Team and player.Team.TeamColor or BrickColor.new("Really blue")
    else
        if originalSizes[player] then
            hrp.Size = originalSizes[player].Size
            hrp.Transparency = originalSizes[player].Transparency
            hrp.Material = originalSizes[player].Material
            hrp.CanCollide = originalSizes[player].CanCollide
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if _G.Config.HitboxEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function() applyHitbox(player) end)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    originalSizes[player] = nil
end)

-- SISTEMA DE ESP MELHORADO
local function createESP(player)
    if player == LocalPlayer then return end
    
    local function addESP(char)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do 
                pcall(function() obj:Destroy() end) 
            end
        end
        ESPObjects[player] = {}
        
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not hrp or not humanoid then return end
        
        -- ESP PLAYERS (Highlight + BillboardGui com vida)
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Enabled = false
        highlight.Parent = char
        table.insert(ESPObjects[player], highlight)
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPBillboard"
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = false
        billboard.Parent = char
        table.insert(ESPObjects[player], billboard)
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = billboard
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0, 20)
        healthLabel.Position = UDim2.new(0, 0, 0, 20)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        healthLabel.TextColor3 = Color3.new(0, 1, 0)
        healthLabel.TextSize = 12
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0.5
        healthLabel.Parent = billboard
        
        -- ESP HITBOX (BoxHandleAdornment + BillboardGui dinâmico)
        local boxAdornment = Instance.new("BoxHandleAdornment")
        boxAdornment.Name = "ESPHitbox"
        boxAdornment.Adornee = hrp
        boxAdornment.Size = hrp.Size
        boxAdornment.Color3 = player.Team and player.Team.TeamColor.Color or Color3.new(0, 0.5, 1)
        boxAdornment.Transparency = 0.7
        boxAdornment.AlwaysOnTop = true
        boxAdornment.ZIndex = 5
        boxAdornment.Visible = false
        boxAdornment.Parent = hrp
        table.insert(ESPObjects[player], boxAdornment)
        
        -- BillboardGui para ESP Hitbox (nome e vida acima da hitbox)
        local billboardHitbox = Instance.new("BillboardGui")
        billboardHitbox.Name = "ESPHitboxBillboard"
        billboardHitbox.Adornee = hrp
        billboardHitbox.Size = UDim2.new(0, 150, 0, 60)
        billboardHitbox.AlwaysOnTop = true
        billboardHitbox.Enabled = false
        billboardHitbox.Parent = hrp
        table.insert(ESPObjects[player], billboardHitbox)
        
        local nameLabelHitbox = Instance.new("TextLabel")
        nameLabelHitbox.Size = UDim2.new(1, 0, 0, 25)
        nameLabelHitbox.BackgroundTransparency = 1
        nameLabelHitbox.Text = player.Name
        nameLabelHitbox.TextColor3 = Color3.new(1, 1, 1)
        nameLabelHitbox.TextSize = 16
        nameLabelHitbox.Font = Enum.Font.GothamBold
        nameLabelHitbox.TextStrokeTransparency = 0.3
        nameLabelHitbox.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabelHitbox.Parent = billboardHitbox
        
        local healthLabelHitbox = Instance.new("TextLabel")
        healthLabelHitbox.Size = UDim2.new(1, 0, 0, 22)
        healthLabelHitbox.Position = UDim2.new(0, 0, 0, 25)
        healthLabelHitbox.BackgroundTransparency = 1
        healthLabelHitbox.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        healthLabelHitbox.TextColor3 = Color3.new(0, 1, 0)
        healthLabelHitbox.TextSize = 14
        healthLabelHitbox.Font = Enum.Font.GothamBold
        healthLabelHitbox.TextStrokeTransparency = 0.3
        healthLabelHitbox.TextStrokeColor3 = Color3.new(0, 0, 0)
        healthLabelHitbox.Parent = billboardHitbox
        
        -- Atualização em tempo real
        task.spawn(function()
            while char and char.Parent and hrp and hrp.Parent and humanoid and humanoid.Parent do
                task.wait(0.1)
                
                local teamColor = player.Team and player.Team.TeamColor.Color or Color3.new(0, 0.5, 1)
                
                -- ESP Players
                if _G.Config.ESPPlayers then
                    highlight.Enabled = true
                    billboard.Enabled = true
                    highlight.FillColor = teamColor
                    highlight.OutlineColor = teamColor
                    healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    if healthPercent > 0.6 then
                        healthLabel.TextColor3 = Color3.new(0, 1, 0)
                    elseif healthPercent > 0.3 then
                        healthLabel.TextColor3 = Color3.new(1, 1, 0)
                    else
                        healthLabel.TextColor3 = Color3.new(1, 0, 0)
                    end
                else
                    highlight.Enabled = false
                    billboard.Enabled = false
                end
                
                -- ESP Hitbox (com nome e vida dinâmicos)
                if _G.Config.ESPHitbox then
                    boxAdornment.Visible = true
                    billboardHitbox.Enabled = true
                    boxAdornment.Size = hrp.Size
                    boxAdornment.Color3 = teamColor
                    
                    -- Atualizar vida no ESP Hitbox
                    healthLabelHitbox.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    if healthPercent > 0.6 then
                        healthLabelHitbox.TextColor3 = Color3.new(0, 1, 0)
                    elseif healthPercent > 0.3 then
                        healthLabelHitbox.TextColor3 = Color3.new(1, 1, 0)
                    else
                        healthLabelHitbox.TextColor3 = Color3.new(1, 0, 0)
                    end
                    
                    -- Ajustar posição do BillboardGui baseado no tamanho da hitbox
                    local hitboxSize = hrp.Size.Y
                    local offsetY = (hitboxSize / 2) + 1.5
                    billboardHitbox.StudsOffset = Vector3.new(0, offsetY, 0)
                    
                else
                    boxAdornment.Visible = false
                    billboardHitbox.Enabled = false
                end
            end
        end)
    end
    
    if player.Character then 
        addESP(player.Character) 
    end
    player.CharacterAdded:Connect(addESP)
end

for _, player in pairs(Players:GetPlayers()) do 
    createESP(player) 
end

Players.PlayerAdded:Connect(createESP)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do 
            pcall(function() obj:Destroy() end) 
        end
        ESPObjects[player] = nil
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)

-- BOTÕES DE MINIMIZAR E FECHAR
MinimizeButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
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
    task.wait(0.3)
    MinimizedButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 380, 0, 500), Position = UDim2.new(0.5, -190, 0.5, -250)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    _G.Config.HitboxEnabled = false
    for player, data in pairs(originalSizes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = data.Size
            hrp.Transparency = data.Transparency
            hrp.Material = data.Material
            hrp.CanCollide = data.CanCollide
        end
    end
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

print("✅ GUI Volver + Hitbox Carregada! (ESP Hitbox Melhorado)")
print("📌 Sistema Volver funcionando!")
print("🎯 Hitbox colorida por time ativada!")
print("👁️ ESP Hitbox agora mostra Nome e Vida acima da hitbox!")

switchTab("Volver")
