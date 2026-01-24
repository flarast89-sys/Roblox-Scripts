local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Configurações
local selectedPlayer = nil
local isEnabled = false
local DELAY_TIME = 1.8
local ROTATION_TIME = 0.6

-- Comandos de Volver
local commands = {
    ["Direita, volver."] = -90,
    ["/a Direita, volver."] = -90,
    ["/A Direita, volver."] = -90,
    ["/h Direita, volver."] = -90,
    ["/H Direita, volver."] = -90,
    [";h Direita, volver."] = -90,
    [";H Direita, volver."] = -90,
    
    ["Esquerda, volver."] = 90,
    ["/a Esquerda, volver."] = 90,
    ["/A Esquerda, volver."] = 90,
    ["/h Esquerda, volver."] = 90,
    ["/H Esquerda, volver."] = 90,
    [";h Esquerda, volver."] = 90,
    [";H Esquerda, volver."] = 90,
    
    ["Direita, inclinar."] = -45,
    ["/a Direita, inclinar."] = -45,
    ["/A Direita, inclinar."] = -45,
    ["/h Direita, inclinar."] = -45,
    ["/H Direita, inclinar."] = -45,
    [";h Direita, inclinar."] = -45,
    [";H Direita, inclinar."] = -45,
    
    ["Esquerda, inclinar."] = 45,
    ["/a Esquerda, inclinar."] = 45,
    ["/A Esquerda, inclinar."] = 45,
    ["/h Esquerda, inclinar."] = 45,
    ["/H Esquerda, inclinar."] = 45,
    [";h Esquerda, inclinar."] = 45,
    [";H Esquerda, inclinar."] = 45,
    
    ["Retaguarda, volver."] = 180,
    ["/a Retaguarda, volver."] = 180,
    ["/A Retaguarda, volver."] = 180,
    ["/h Retaguarda, volver."] = 180,
    ["/H Retaguarda, volver."] = 180,
    [";h Retaguarda, volver."] = 180,
    [";H Retaguarda, volver."] = 180,
}

-- Criar GUI com proteção
local success, err = pcall(function()
    local gui = Instance.new("ScreenGui")
    gui.Name = "VolverGUI"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(1, 1, 1)
    frame.Active = true
    frame.Draggable = true
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    title.Text = "SISTEMA DE VOLVER"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    
    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.9, 0, 0, 35)
    toggle.Position = UDim2.new(0.05, 0, 0, 50)
    toggle.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    toggle.Text = "DESATIVADO"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.TextSize = 16
    toggle.Font = Enum.Font.GothamBold
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.9, 0, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, 95)
    label.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    label.Text = "Nenhum instrutor"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(0.9, 0, 1, -140)
    scroll.Position = UDim2.new(0.05, 0, 0, 135)
    scroll.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 8
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Funções
    local function rotateCharacter(degrees)
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChild("Humanoid")
        
        if hum then hum.AutoRotate = false end
        
        local current = root.CFrame
        local over = math.random(5, 10)
        local first = degrees + (degrees > 0 and over or -over)
        
        local tween1 = TweenService:Create(root, TweenInfo.new(0.4, Enum.EasingStyle.Linear), 
            {CFrame = current * CFrame.Angles(0, math.rad(first), 0)})
        tween1:Play()
        tween1.Completed:Wait()
        
        local tween2 = TweenService:Create(root, TweenInfo.new(0.2, Enum.EasingStyle.Linear), 
            {CFrame = current * CFrame.Angles(0, math.rad(degrees), 0)})
        tween2:Play()
        tween2.Completed:Wait()
        
        if hum then hum.AutoRotate = true end
    end
    
    local function processMsg(player, msg)
        print("📨 MSG: " .. player.Name .. " disse: '" .. msg .. "'")
        
        if not isEnabled then
            print("⚠️ Sistema desativado")
            return
        end
        
        if not selectedPlayer then
            print("⚠️ Nenhum instrutor selecionado")
            return
        end
        
        if player ~= selectedPlayer then
            print("⚠️ Não é o instrutor selecionado")
            return
        end
        
        print("✅ É o instrutor! Verificando comando...")
        
        local rot = commands[msg]
        if rot then
            print("✅ COMANDO ENCONTRADO! Rotação: " .. rot .. "°")
            task.spawn(function()
                print("⏳ Aguardando " .. DELAY_TIME .. " segundos...")
                task.wait(DELAY_TIME)
                print("🔄 EXECUTANDO ROTAÇÃO AGORA!")
                rotateCharacter(rot)
            end)
        else
            print("❌ Comando não reconhecido: '" .. msg .. "'")
            print("📋 Comandos disponíveis:")
            for cmd, deg in pairs(commands) do
                print("  - '" .. cmd .. "' = " .. deg .. "°")
            end
        end
    end
    
    local function updateList()
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        
        -- Adiciona TODOS os jogadores, incluindo você mesmo
        for _, p in ipairs(Players:GetPlayers()) do
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            btn.Text = p.Name .. (p == LocalPlayer and " (VOCÊ)" or "")
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 14
            btn.Font = Enum.Font.Gotham
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                label.Text = "Instrutor: " .. p.Name .. (p == LocalPlayer and " (VOCÊ)" or "")
                
                for _, b in ipairs(scroll:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
                    end
                end
                btn.BackgroundColor3 = Color3.new(0.3, 0.5, 1)
            end)
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            toggle.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
            toggle.Text = "ATIVADO"
        else
            toggle.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            toggle.Text = "DESATIVADO"
        end
    end)
    
    for _, p in ipairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg) processMsg(p, msg) end)
    end
    
    Players.PlayerAdded:Connect(function(p)
        updateList()
        p.Chatted:Connect(function(msg) processMsg(p, msg) end)
    end)
    
    Players.PlayerRemoving:Connect(function(p)
        if selectedPlayer == p then
            selectedPlayer = nil
            label.Text = "Nenhum instrutor"
        end
        updateList()
    end)
    
    updateList()
    
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    print("GUI CRIADA COM SUCESSO!")
end)

if not success then
    warn("ERRO AO CRIAR GUI: " .. tostring(err))
end
