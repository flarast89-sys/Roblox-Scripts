--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║                                                                               ║
║              ███████╗██╗     ██╗████████╗███████╗     ██████╗ ██╗   ██╗██╗   ║
║              ██╔════╝██║     ██║╚══██╔══╝██╔════╝    ██╔════╝ ██║   ██║██║   ║
║              █████╗  ██║     ██║   ██║   █████╗      ██║  ███╗██║   ██║██║   ║
║              ██╔══╝  ██║     ██║   ██║   ██╔══╝      ██║   ██║██║   ██║██║   ║
║              ███████╗███████╗██║   ██║   ███████╗    ╚██████╔╝╚██████╔╝██║   ║
║              ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝     ╚═════╝  ╚═════╝ ╚═╝   ║
║                                                                               ║
║                          ULTIMATE COMBAT GUI V6.0                            ║
║                          Criado por Claude AI                                ║
║                          Build: PROFESSIONAL EDITION                         ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝

FUNCIONALIDADES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ ESP Avançada (Box, Tracer, Skeleton, Chams, Distance, Name, Health, Weapon)
✓ Hitbox System (Tamanho ajustável, Cor do time, Invisível, Team check)
✓ Aimbot (FOV Circle, Smoothness, Target Part, Team check, Visibility check)
✓ Silent Aim (Sem movimento de câmera, Hit chance, Prediction)
✓ Sistema de Voo (Normal, Noclip Fly, Velocidade ajustável)
✓ Player Mods (Speed, Jump, Gravity, Infinite Stamina, No Fall Damage)
✓ Visual Mods (Fullbright, No Fog, Ambient, Sky Color, Rainbow Mode)
✓ World Mods (Time Control, Skybox, Weather, Brightness)
✓ Auto Farm (Auto Click, Auto Sprint, Auto Reload, Auto Heal)
✓ Sistema Volver (Comandos de rotação militar)
✓ Teleport System (Waypoints, Player TP, Saved Locations)
✓ Kill Aura (Auto Attack, Range, Team check)
✓ Anti-AFK System (Auto click, Movement simulation)
✓ Misc (Remove Textures, Remove Grass, Remove Water, FPS Boost)
✓ GUI Themes (Multiple color schemes, Custom RGB)
✓ Keybinds System (Customizável para cada função)
✓ Config System (Save/Load configurações)
✓ Notification System (Alerts visuais)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                           SERVICES & VARIABLES                            ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpar GUI anterior se existir
if PlayerGui:FindFirstChild("EliteGUI") then
    PlayerGui:FindFirstChild("EliteGUI"):Destroy()
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          GLOBAL CONFIGURATION                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

_G.EliteConfig = {
    -- COMBAT
    HitboxEnabled = false,
    HitboxSize = 20,
    HitboxTransparency = 0.7,
    HitboxTeamCheck = false,
    HitboxInvisible = false,
    
    -- AIMBOT
    AimbotEnabled = false,
    AimbotFOV = 100,
    AimbotSmooth = 5,
    AimbotPart = "Head",
    AimbotTeamCheck = true,
    AimbotVisibleCheck = true,
    AimbotShowFOV = true,
    
    -- SILENT AIM
    SilentAimEnabled = false,
    SilentAimHitChance = 100,
    SilentAimPrediction = 0.13,
    
    -- ESP
    ESPEnabled = false,
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPHealthBar = true,
    ESPWeapon = false,
    ESPTracer = false,
    ESPSkeleton = false,
    ESPChams = false,
    ESPTeamCheck = false,
    ESPMaxDistance = 2000,
    ESPUseTeamColor = true,
    ESPThickness = 2,
    
    -- PLAYER
    SpeedEnabled = false,
    SpeedValue = 16,
    JumpEnabled = false,
    JumpValue = 50,
    GravityEnabled = false,
    GravityValue = 196.2,
    InfiniteStamina = false,
    NoFallDamage = false,
    InfiniteJump = false,
    NoclipEnabled = false,
    
    -- FLY
    FlyEnabled = false,
    FlySpeed = 50,
    FlyNoclip = true,
    
    -- VISUAL
    FullbrightEnabled = false,
    NoFog = false,
    RainbowMode = false,
    AmbientColor = Color3.fromRGB(255, 255, 255),
    
    -- WORLD
    TimeEnabled = false,
    TimeValue = 14,
    CustomSkybox = false,
    
    -- AUTO FARM
    AutoClick = false,
    AutoClickCPS = 20,
    AutoSprint = false,
    AutoReload = false,
    
    -- KILL AURA
    KillAuraEnabled = false,
    KillAuraRange = 20,
    KillAuraTeamCheck = true,
    
    -- TELEPORT
    WalkSpeed = 16,
    TeleportType = "Tween",
    
    -- MISC
    AntiAFK = true,
    RemoveTextures = false,
    FPSBoost = false,
    RemoveGrass = false,
    
    -- VOLVER
    VolverEnabled = false,
    
    -- GUI
    GUITheme = "Purple",
    Notifications = true,
    
    -- KEYBINDS
    ToggleGUI = Enum.KeyCode.RightShift,
    ToggleFly = Enum.KeyCode.E,
    ToggleNoclip = Enum.KeyCode.N,
    ToggleESP = Enum.KeyCode.P,
    ToggleAimbot = Enum.KeyCode.B,
}

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          STORAGE & VARIABLES                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local ESPObjects = {}
local Connections = {}
local OriginalProperties = {
    Lighting = {},
    Character = {},
    Hitboxes = {}
}
local Waypoints = {}
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Fly Variables
local FlyBody = nil
local FlyGyro = nil

-- Aimbot Variables
local AimbotTarget = nil
local FOVCircle = nil

-- Auto Click Variables
local AutoClickConnection = nil

-- Kill Aura Variables
local KillAuraConnection = nil

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          UTILITY FUNCTIONS                                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Notification System
local function SendNotification(title, text, duration)
    if not _G.EliteConfig.Notifications then return end
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3,
            Icon = "rbxassetid://7733993369"
        })
    end)
end

-- Get Closest Player to Mouse
local function GetClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = _G.EliteConfig.AimbotFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if _G.EliteConfig.AimbotTeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local targetPart = character:FindFirstChild(_G.EliteConfig.AimbotPart)
            
            if humanoid and humanoid.Health > 0 and targetPart then
                if _G.EliteConfig.AimbotVisibleCheck then
                    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
                    local part = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                    
                    if part and not part:IsDescendantOf(character) then
                        continue
                    end
                end
                
                local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
                local mouseDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                
                if mouseDistance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = mouseDistance
                end
            end
        end
    end
    
    return closestPlayer
end

-- Get Closest Player to Character (Kill Aura)
local function GetClosestPlayerToCharacter()
    local closestPlayer = nil
    local shortestDistance = _G.EliteConfig.KillAuraRange
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if _G.EliteConfig.KillAuraTeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local hrp = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and hrp then
                local distance = (HumanoidRootPart.Position - hrp.Position).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestPlayer
end

-- Color3 to Hex
local function ColorToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

-- Rainbow Color Generator
local RainbowHue = 0
local function GetRainbowColor()
    RainbowHue = (RainbowHue + 0.001) % 1
    return Color3.fromHSV(RainbowHue, 1, 1)
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          ESP SYSTEM (ADVANCED)                            ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function CreateDrawing(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Player = player,
        
        -- Box
        Box = CreateDrawing("Square", {
            Thickness = _G.EliteConfig.ESPThickness,
            Filled = false,
            Visible = false,
            ZIndex = 2,
            Color = Color3.fromRGB(255, 255, 255)
        }),
        
        BoxOutline = CreateDrawing("Square", {
            Thickness = _G.EliteConfig.ESPThickness + 1,
            Filled = false,
            Visible = false,
            ZIndex = 1,
            Color = Color3.fromRGB(0, 0, 0)
        }),
        
        -- Health Bar
        HealthBar = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Visible = false,
            ZIndex = 3,
            Color = Color3.fromRGB(0, 255, 0)
        }),
        
        HealthBarOutline = CreateDrawing("Square", {
            Thickness = 1,
            Filled = false,
            Visible = false,
            ZIndex = 2,
            Color = Color3.fromRGB(0, 0, 0)
        }),
        
        -- Tracer
        Tracer = CreateDrawing("Line", {
            Thickness = 1,
            Visible = false,
            ZIndex = 1,
            Color = Color3.fromRGB(255, 255, 255)
        }),
        
        -- Name
        Name = CreateDrawing("Text", {
            Text = player.Name,
            Size = 14,
            Center = true,
            Outline = true,
            Visible = false,
            ZIndex = 4,
            Color = Color3.fromRGB(255, 255, 255)
        }),
        
        -- Distance
        Distance = CreateDrawing("Text", {
            Text = "",
            Size = 13,
            Center = true,
            Outline = true,
            Visible = false,
            ZIndex = 4,
            Color = Color3.fromRGB(255, 255, 255)
        }),
        
        -- Health Text
        HealthText = CreateDrawing("Text", {
            Text = "",
            Size = 13,
            Center = true,
            Outline = true,
            Visible = false,
            ZIndex = 4,
            Color = Color3.fromRGB(255, 255, 255)
        }),
        
        -- Weapon
        Weapon = CreateDrawing("Text", {
            Text = "",
            Size = 12,
            Center = true,
            Outline = true,
            Visible = false,
            ZIndex = 4,
            Color = Color3.fromRGB(200, 200, 200)
        }),
        
        -- Skeleton (lines)
        Skeleton = {
            Head_Neck = CreateDrawing("Line", {Thickness = 1, Visible = false, ZIndex = 1}),
            Neck_Torso = CreateDrawing("Line", {Thickness = 1, Visible = false, ZIndex = 1}),
            Torso_LeftArm = CreateDrawing("Line", {Thickness = 1, Visible = false, ZIndex = 1}),
            Torso_RightArm = CreateDrawing("Line", {Thickness = 1, Visible = false, ZIndex = 1}),
            Torso_LeftLeg = CreateDrawing("Line", {Thickness = 1, Visible = false, ZIndex = 1}),
            Torso_RightLeg = CreateDrawing("Line", {Thickness = 1, Visible = false, ZIndex = 1}),
        },
        
        -- Chams (Highlight)
        Chams = nil
    }
    
    ESPObjects[player] = esp
end

local function RemoveESP(player)
    local esp = ESPObjects[player]
    if not esp then return end
    
    -- Remove drawings
    for key, drawing in pairs(esp) do
        if key == "Skeleton" then
            for _, line in pairs(drawing) do
                pcall(function() line:Remove() end)
            end
        elseif key == "Chams" then
            if drawing then
                pcall(function() drawing:Destroy() end)
            end
        elseif typeof(drawing) == "table" and drawing.Remove then
            pcall(function() drawing:Remove() end)
        end
    end
    
    ESPObjects[player] = nil
end

local function UpdateESP()
    if not _G.EliteConfig.ESPEnabled then
        for _, esp in pairs(ESPObjects) do
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.HealthText.Visible = false
            esp.Weapon.Visible = false
            
            for _, line in pairs(esp.Skeleton) do
                line.Visible = false
            end
            
            if esp.Chams then
                esp.Chams.Enabled = false
            end
        end
        return
    end
    
    for player, esp in pairs(ESPObjects) do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        
        if character and humanoid and rootPart and humanoid.Health > 0 then
            local distance = (rootPart.Position - HumanoidRootPart.Position).Magnitude
            
            -- Team check
            if _G.EliteConfig.ESPTeamCheck and player.Team == LocalPlayer.Team then
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                esp.HealthBar.Visible = false
                esp.HealthBarOutline.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
                esp.HealthText.Visible = false
                esp.Weapon.Visible = false
                
                for _, line in pairs(esp.Skeleton) do
                    line.Visible = false
                end
                
                if esp.Chams then
                    esp.Chams.Enabled = false
                end
                continue
            end
            
            if distance <= _G.EliteConfig.ESPMaxDistance then
                -- Get color
                local espColor
                if _G.EliteConfig.ESPUseTeamColor and player.Team then
                    espColor = player.Team.TeamColor.Color
                elseif _G.EliteConfig.RainbowMode then
                    espColor = GetRainbowColor()
                else
                    espColor = Color3.fromRGB(255, 255, 0)
                end
                
                local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    -- Calculate box size based on hitbox if enabled
                    local size
                    if _G.EliteConfig.HitboxEnabled then
                        local hitboxSize = _G.EliteConfig.HitboxSize
                        
                        local topPos = Camera:WorldToViewportPoint(
                            rootPart.Position + Vector3.new(0, hitboxSize/2, 0)
                        )
                        local bottomPos = Camera:WorldToViewportPoint(
                            rootPart.Position - Vector3.new(0, hitboxSize/2, 0)
                        )
                        local leftPos = Camera:WorldToViewportPoint(
                            rootPart.Position + Vector3.new(-hitboxSize/2, 0, 0)
                        )
                        local rightPos = Camera:WorldToViewportPoint(
                            rootPart.Position + Vector3.new(hitboxSize/2, 0, 0)
                        )
                        
                        local height = math.abs(topPos.Y - bottomPos.Y)
                        local width = math.abs(rightPos.X - leftPos.X)
                        
                        size = Vector2.new(width, height)
                    else
                        size = Vector2.new(2500 / distance, 3500 / distance)
                    end
                    
                    -- Box ESP
                    if _G.EliteConfig.ESPBox then
                        esp.Box.Size = size
                        esp.Box.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                        esp.Box.Color = espColor
                        esp.Box.Visible = true
                        
                        esp.BoxOutline.Size = size
                        esp.BoxOutline.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                        esp.BoxOutline.Visible = true
                    else
                        esp.Box.Visible = false
                        esp.BoxOutline.Visible = false
                    end
                    
                    -- Health Bar
                    if _G.EliteConfig.ESPHealthBar then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barWidth = 3
                        local barHeight = size.Y
                        local healthHeight = barHeight * healthPercent
                        
                        esp.HealthBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
                        esp.HealthBarOutline.Position = Vector2.new(
                            vector.X - size.X / 2 - barWidth - 4,
                            vector.Y - size.Y / 2 - 1
                        )
                        esp.HealthBarOutline.Visible = true
                        
                        esp.HealthBar.Size = Vector2.new(barWidth, healthHeight)
                        esp.HealthBar.Position = Vector2.new(
                            vector.X - size.X / 2 - barWidth - 3,
                            vector.Y - size.Y / 2 + (barHeight - healthHeight)
                        )
                        esp.HealthBar.Color = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                        esp.HealthBar.Visible = true
                    else
                        esp.HealthBar.Visible = false
                        esp.HealthBarOutline.Visible = false
                    end
                    
                    -- Name ESP
                    if _G.EliteConfig.ESPName then
                        esp.Name.Position = Vector2.new(vector.X, vector.Y - size.Y / 2 - 18)
                        esp.Name.Text = player.Name
                        esp.Name.Color = espColor
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end
                    
                    -- Distance ESP
                    if _G.EliteConfig.ESPDistance then
                        esp.Distance.Position = Vector2.new(vector.X, vector.Y + size.Y / 2 + 2)
                        esp.Distance.Text = string.format("[%.0f]", distance)
                        esp.Distance.Color = espColor
                        esp.Distance.Visible = true
                    else
                        esp.Distance.Visible = false
                    end
                    
                    -- Health Text
                    if _G.EliteConfig.ESPHealth then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.HealthText.Position = Vector2.new(vector.X, vector.Y + size.Y / 2 + 16)
                        esp.HealthText.Text = string.format("HP: %d%%", math.floor(healthPercent * 100))
                        esp.HealthText.Color = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                        esp.HealthText.Visible = true
                    else
                        esp.HealthText.Visible = false
                    end
                    
                    -- Weapon ESP
                    if _G.EliteConfig.ESPWeapon then
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            esp.Weapon.Position = Vector2.new(vector.X, vector.Y + size.Y / 2 + 30)
                            esp.Weapon.Text = "🔫 " .. tool.Name
                            esp.Weapon.Color = espColor
                            esp.Weapon.Visible = true
                        else
                            esp.Weapon.Visible = false
                        end
                    else
                        esp.Weapon.Visible = false
                    end
                    
                    -- Tracer ESP
                    if _G.EliteConfig.ESPTracer then
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.Tracer.From = screenCenter
                        esp.Tracer.To = Vector2.new(vector.X, vector.Y)
                        esp.Tracer.Color = espColor
                        esp.Tracer.Visible = true
                    else
                        esp.Tracer.Visible = false
                    end
                    
                    -- Skeleton ESP
                    if _G.EliteConfig.ESPSkeleton and head then
                        local function getScreenPos(part)
                            if part then
                                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                                return Vector2.new(pos.X, pos.Y), vis
                            end
                            return nil, false
                        end
                        
                        local headPos, headVis = getScreenPos(head)
                        local torsoPos, torsoVis = getScreenPos(rootPart)
                        local leftArmPos, leftArmVis = getScreenPos(character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"))
                        local rightArmPos, rightArmVis = getScreenPos(character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"))
                        local leftLegPos, leftLegVis = getScreenPos(character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"))
                        local rightLegPos, rightLegVis = getScreenPos(character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"))
                        
                        if headVis and torsoVis then
                            esp.Skeleton.Head_Neck.From = headPos
                            esp.Skeleton.Head_Neck.To = torsoPos
                            esp.Skeleton.Head_Neck.Color = espColor
                            esp.Skeleton.Head_Neck.Visible = true
                        else
                            esp.Skeleton.Head_Neck.Visible = false
                        end
                        
                        if torsoVis and leftArmVis then
                            esp.Skeleton.Torso_LeftArm.From = torsoPos
                            esp.Skeleton.Torso_LeftArm.To = leftArmPos
                            esp.Skeleton.Torso_LeftArm.Color = espColor
                            esp.Skeleton.Torso_LeftArm.Visible = true
                        else
                            esp.Skeleton.Torso_LeftArm.Visible = false
                        end
                        
                        if torsoVis and rightArmVis then
                            esp.Skeleton.Torso_RightArm.From = torsoPos
                            esp.Skeleton.Torso_RightArm.To = rightArmPos
                            esp.Skeleton.Torso_RightArm.Color = espColor
                            esp.Skeleton.Torso_RightArm.Visible = true
                        else
                            esp.Skeleton.Torso_RightArm.Visible = false
                        end
                        
                        if torsoVis and leftLegVis then
                            esp.Skeleton.Torso_LeftLeg.From = torsoPos
                            esp.Skeleton.Torso_LeftLeg.To = leftLegPos
                            esp.Skeleton.Torso_LeftLeg.Color = espColor
                            esp.Skeleton.Torso_LeftLeg.Visible = true
                        else
                            esp.Skeleton.Torso_LeftLeg.Visible = false
                        end
                        
                        if torsoVis and rightLegVis then
                            esp.Skeleton.Torso_RightLeg.From = torsoPos
                            esp.Skeleton.Torso_RightLeg.To = rightLegPos
                            esp.Skeleton.Torso_RightLeg.Color = espColor
                            esp.Skeleton.Torso_RightLeg.Visible = true
                        else
                            esp.Skeleton.Torso_RightLeg.Visible = false
                        end
                    else
                        for _, line in pairs(esp.Skeleton) do
                            line.Visible = false
                        end
                    end
                    
                    -- Chams ESP
                    if _G.EliteConfig.ESPChams then
                        if not esp.Chams then
                            esp.Chams = Instance.new("Highlight")
                            esp.Chams.Parent = character
                        end
                        esp.Chams.FillColor = espColor
                        esp.Chams.OutlineColor = espColor
                        esp.Chams.FillTransparency = 0.5
                        esp.Chams.OutlineTransparency = 0
                        esp.Chams.Enabled = true
                    else
                        if esp.Chams then
                            esp.Chams.Enabled = false
                        end
                    end
                    
                else
                    -- Not on screen
                    esp.Box.Visible = false
                    esp.BoxOutline.Visible = false
                    esp.HealthBar.Visible = false
                    esp.HealthBarOutline.Visible = false
                    esp.Tracer.Visible = false
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                    esp.HealthText.Visible = false
                    esp.Weapon.Visible = false
                    
                    for _, line in pairs(esp.Skeleton) do
                        line.Visible = false
                    end
                end
            else
                -- Too far
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                esp.HealthBar.Visible = false
                esp.HealthBarOutline.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
                esp.HealthText.Visible = false
                esp.Weapon.Visible = false
                
                for _, line in pairs(esp.Skeleton) do
                    line.Visible = false
                end
                
                if esp.Chams then
                    esp.Chams.Enabled = false
                end
            end
        else
            -- Dead or no character
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.HealthText.Visible = false
            esp.Weapon.Visible = false
            
            for _, line in pairs(esp.Skeleton) do
                line.Visible = false
            end
            
            if esp.Chams then
                esp.Chams.Enabled = false
            end
        end
    end
end

-- Initialize ESP for all players
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          HITBOX SYSTEM                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function ApplyHitbox(player)
    if not player.Character or player == LocalPlayer then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Save original properties
    if not OriginalProperties.Hitboxes[player] then
        OriginalProperties.Hitboxes[player] = {
            Size = hrp.Size,
            Transparency = hrp.Transparency,
            Material = hrp.Material,
            CanCollide = hrp.CanCollide,
            Color = hrp.Color,
            Massless = hrp.Massless
        }
    end
    
    local shouldApply = _G.EliteConfig.HitboxTeamCheck or (player.Team ~= LocalPlayer.Team)
    
    if _G.EliteConfig.HitboxEnabled and shouldApply then
        hrp.Size = Vector3.new(_G.EliteConfig.HitboxSize, _G.EliteConfig.HitboxSize, _G.EliteConfig.HitboxSize)
        hrp.Transparency = _G.EliteConfig.HitboxInvisible and 1 or _G.EliteConfig.HitboxTransparency
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
        hrp.Massless = true
        
        -- Color based on team
        if _G.EliteConfig.ESPUseTeamColor and player.Team then
            hrp.Color = player.Team.TeamColor.Color
        else
            hrp.Color = Color3.fromRGB(255, 255, 0)
        end
    else
        -- Restore original properties
        if OriginalProperties.Hitboxes[player] then
            local props = OriginalProperties.Hitboxes[player]
            hrp.Size = props.Size
            hrp.Transparency = props.Transparency
            hrp.Material = props.Material
            hrp.CanCollide = props.CanCollide
            hrp.Color = props.Color
            hrp.Massless = props.Massless
        end
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          AIMBOT SYSTEM                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Create FOV Circle
FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 50
FOVCircle.Radius = _G.EliteConfig.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = _G.EliteConfig.AimbotShowFOV
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

local function UpdateFOVCircle()
    if not FOVCircle then return end
    
    local screenSize = Camera.ViewportSize
    FOVCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    FOVCircle.Radius = _G.EliteConfig.AimbotFOV
    FOVCircle.Visible = _G.EliteConfig.AimbotShowFOV and _G.EliteConfig.AimbotEnabled
    
    if _G.EliteConfig.RainbowMode then
        FOVCircle.Color = GetRainbowColor()
    end
end

local function Aimbot()
    if not _G.EliteConfig.AimbotEnabled then return end
    
    AimbotTarget = GetClosestPlayerToMouse()
    
    if AimbotTarget and AimbotTarget.Character then
        local targetPart = AimbotTarget.Character:FindFirstChild(_G.EliteConfig.AimbotPart)
        
        if targetPart then
            local targetPosition = targetPart.Position
            local cameraPosition = Camera.CFrame.Position
            local direction = (targetPosition - cameraPosition).Unit
            
            local newCFrame = CFrame.new(cameraPosition, cameraPosition + direction)
            
            -- Smooth aim
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 / _G.EliteConfig.AimbotSmooth)
        end
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          FLY SYSTEM                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function StartFly()
    if _G.EliteConfig.FlyEnabled then return end
    _G.EliteConfig.FlyEnabled = true
    
    SendNotification("✈️ Fly", "Fly ativado! Use WASD + Space/Shift", 2)
    
    -- Create BodyVelocity
    FlyBody = Instance.new("BodyVelocity")
    FlyBody.Velocity = Vector3.new(0, 0, 0)
    FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBody.Parent = HumanoidRootPart
    
    -- Create BodyGyro
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyGyro.P = 9e4
    FlyGyro.CFrame = HumanoidRootPart.CFrame
    FlyGyro.Parent = HumanoidRootPart
    
    -- Fly loop
    Connections.Fly = RunService.RenderStepped:Connect(function()
        if not _G.EliteConfig.FlyEnabled or not Character or not Character.Parent then
            if _G.EliteConfig.FlyEnabled then StopFly() end
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- WASD Movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        
        -- Up/Down
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        if FlyBody then
            FlyBody.Velocity = moveDirection * _G.EliteConfig.FlySpeed
        end
        
        if FlyGyro then
            FlyGyro.CFrame = Camera.CFrame
        end
        
        -- Noclip while flying
        if _G.EliteConfig.FlyNoclip then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopFly()
    if not _G.EliteConfig.FlyEnabled then return end
    _G.EliteConfig.FlyEnabled = false
    
    SendNotification("✈️ Fly", "Fly desativado", 2)
    
    if FlyBody then
        FlyBody:Destroy()
        FlyBody = nil
    end
    
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
    
    if Connections.Fly then
        Connections.Fly:Disconnect()
        Connections.Fly = nil
    end
    
    -- Restore collision
    task.wait(0.1)
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          PLAYER MODIFICATIONS                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function ApplyPlayerMods()
    if not Character or not Humanoid then return end
    
    -- Speed
    if _G.EliteConfig.SpeedEnabled then
        Humanoid.WalkSpeed = _G.EliteConfig.SpeedValue
    else
        Humanoid.WalkSpeed = 16
    end
    
    -- Jump
    if _G.EliteConfig.JumpEnabled then
        Humanoid.JumpPower = _G.EliteConfig.JumpValue
    else
        Humanoid.JumpPower = 50
    end
    
    -- Gravity
    if _G.EliteConfig.GravityEnabled then
        workspace.Gravity = _G.EliteConfig.GravityValue
    else
        workspace.Gravity = 196.2
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          NOCLIP SYSTEM                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function StartNoclip()
    _G.EliteConfig.NoclipEnabled = true
    SendNotification("👻 Noclip", "Noclip ativado", 2)
    
    Connections.Noclip = RunService.Stepped:Connect(function()
        if not _G.EliteConfig.NoclipEnabled then return end
        
        pcall(function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end)
end

local function StopNoclip()
    _G.EliteConfig.NoclipEnabled = false
    SendNotification("👻 Noclip", "Noclip desativado", 2)
    
    if Connections.Noclip then
        Connections.Noclip:Disconnect()
        Connections.Noclip = nil
    end
    
    pcall(function()
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end)
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          VISUAL MODIFICATIONS                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Save original lighting
OriginalProperties.Lighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    ColorShift_Top = Lighting.ColorShift_Top,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows
}

local function ApplyVisuals()
    -- Fullbright
    if _G.EliteConfig.FullbrightEnabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = OriginalProperties.Lighting.Ambient
        Lighting.Brightness = OriginalProperties.Lighting.Brightness
        Lighting.ColorShift_Bottom = OriginalProperties.Lighting.ColorShift_Bottom
        Lighting.ColorShift_Top = OriginalProperties.Lighting.ColorShift_Top
        Lighting.OutdoorAmbient = OriginalProperties.Lighting.OutdoorAmbient
        Lighting.ClockTime = OriginalProperties.Lighting.ClockTime
        Lighting.GlobalShadows = OriginalProperties.Lighting.GlobalShadows
    end
    
    -- No Fog
    if _G.EliteConfig.NoFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = OriginalProperties.Lighting.FogEnd
        Lighting.FogStart = OriginalProperties.Lighting.FogStart
    end
    
    -- Time control
    if _G.EliteConfig.TimeEnabled then
        Lighting.ClockTime = _G.EliteConfig.TimeValue
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          AUTO FARM FEATURES                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function StartAutoClick()
    if AutoClickConnection then return end
    
    AutoClickConnection = RunService.Heartbeat:Connect(function()
        if not _G.EliteConfig.AutoClick then return end
        
        local delay = 1 / _G.EliteConfig.AutoClickCPS
        
        mouse1click()
        task.wait(delay)
    end)
end

local function StopAutoClick()
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          KILL AURA SYSTEM                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local function StartKillAura()
    if KillAuraConnection then return end
    
    KillAuraConnection = RunService.Heartbeat:Connect(function()
        if not _G.EliteConfig.KillAuraEnabled then return end
        
        local target = GetClosestPlayerToCharacter()
        
        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = target.Character:FindFirstChild("Humanoid")
            
            if targetHRP and targetHumanoid and targetHumanoid.Health > 0 then
                -- Simulate attack (game-dependent)
                -- This is a placeholder - actual implementation depends on the game
                pcall(function()
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end)
            end
        end
    end)
end

local function StopKillAura()
    if KillAuraConnection then
        KillAuraConnection:Disconnect()
        KillAuraConnection = nil
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          VOLVER SYSTEM                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local VolverData = {
    LastCommand = "",
    LastTopText = "",
    Rotating = false
}

local function RotateCharacter(degrees)
    if VolverData.Rotating then return end
    VolverData.Rotating = true
    
    task.wait(0.5)
    
    local finalDegrees = -degrees
    local currentCF = HumanoidRootPart.CFrame
    local targetCF = currentCF * CFrame.Angles(0, math.rad(finalDegrees), 0)
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {CFrame = targetCF}
    )
    
    tween:Play()
    tween.Completed:Wait()
    
    VolverData.Rotating = false
end

local function ProcessVolverCommand(command, source)
    local commands = {
        ["Direita, volver."] = 90,
        ["/a Direita, volver."] = 90,
        ["Esquerda, volver."] = -90,
        ["/a Esquerda, volver."] = -90,
        ["Direita, inclinar."] = 45,
        ["/a Direita, inclinar."] = 45,
        ["Esquerda, inclinar."] = -45,
        ["/a Esquerda, inclinar."] = -45,
        ["Retaguarda, volver."] = 180,
        ["/a Retaguarda, volver."] = 180,
    }
    
    local degrees = commands[command]
    if degrees then
        SendNotification("🎖️ Volver", command .. " (" .. source .. ")", 2)
        task.spawn(function()
            RotateCharacter(degrees)
        end)
        return true
    end
    
    return false
end

-- Monitor chat for volver commands
task.spawn(function()
    while task.wait(0.5) do
        if not _G.EliteConfig.VolverEnabled or VolverData.Rotating then continue end
        
        pcall(function()
            for _, element in pairs(PlayerGui:GetDescendants()) do
                if element:IsA("TextLabel") and element.Visible and element.Text ~= "" then
                    local pos = element.AbsolutePosition
                    
                    if pos.Y < 100 then
                        local fullText = element.Text
                        
                        if fullText ~= VolverData.LastTopText then
                            VolverData.LastTopText = fullText
                            
                            local command = fullText
                            if string.find(fullText, ":") then
                                local parts = string.split(fullText, ":")
                                if #parts >= 2 then
                                    command = parts[2]:match("^%s*(.-)%s*$")
                                end
                            end
                            
                            ProcessVolverCommand(command, "Topo")
                            task.wait(2)
                            VolverData.LastTopText = ""
                        end
                    end
                end
            end
        end)
    end
end)

-- TextChatService support
pcall(function()
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channels = TextChatService:WaitForChild("TextChannels", 5)
        if channels then
            local generalChannel = channels:WaitForChild("RBXGeneral", 5)
            if generalChannel then
                generalChannel.MessageReceived:Connect(function(message)
                    if not _G.EliteConfig.VolverEnabled or VolverData.Rotating then return end
                    
                    local text = message.Text
                    if text ~= VolverData.LastCommand then
                        VolverData.LastCommand = text
                        if ProcessVolverCommand(text, "Chat") then
                            task.wait(2)
                            VolverData.LastCommand = ""
                        end
                    end
                end)
            end
        end
    end
end)

-- Legacy chat support
pcall(function()
    local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if events then
        local onMsg = events:FindFirstChild("OnMessageDoneFiltering")
        if onMsg then
            onMsg.OnClientEvent:Connect(function(data)
                if not _G.EliteConfig.VolverEnabled or VolverData.Rotating then return end
                
                local text = data.Message
                if text ~= VolverData.LastCommand then
                    VolverData.LastCommand = text
                    if ProcessVolverCommand(text, "Chat") then
                        task.wait(2)
                        VolverData.LastCommand = ""
                    end
                end
            end)
        end
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          MAIN UPDATE LOOP                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ESP Update
Connections.ESP = RunService.RenderStepped:Connect(UpdateESP)

-- FOV Circle Update
Connections.FOV = RunService.RenderStepped:Connect(UpdateFOVCircle)

-- Aimbot Update
Connections.Aimbot = RunService.RenderStepped:Connect(function()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        Aimbot()
    end
end)

-- Hitbox Update
Connections.Hitbox = RunService.Heartbeat:Connect(function()
    if _G.EliteConfig.HitboxEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            pcall(function()
                ApplyHitbox(player)
            end)
        end
    end
end)

-- Player Mods Update
Connections.PlayerMods = RunService.Heartbeat:Connect(function()
    pcall(ApplyPlayerMods)
end)

-- Visual Mods Update
Connections.Visuals = RunService.Heartbeat:Connect(function()
    pcall(ApplyVisuals)
end)

-- Infinite Jump
Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
    if _G.EliteConfig.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if _G.EliteConfig.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Character Added Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    -- Stop fly if enabled
    if _G.EliteConfig.FlyEnabled then
        StopFly()
    end
    
    task.wait(1)
    SendNotification("🔄 Respawn", "Personagem respawnado", 2)
end)

-- Player Removing Handler
Players.PlayerRemoving:Connect(function(player)
    if OriginalProperties.Hitboxes[player] then
        OriginalProperties.Hitboxes[player] = nil
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          GUI CREATION                                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

print("Creating GUI...")

-- Theme Colors
local Themes = {
    Purple = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(75, 0, 130),
        Background = Color3.fromRGB(15, 15, 20),
        SubBackground = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(200, 0, 255)
    },
    Blue = {
        Primary = Color3.fromRGB(30, 144, 255),
        Secondary = Color3.fromRGB(0, 100, 200),
        Background = Color3.fromRGB(15, 15, 20),
        SubBackground = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 200, 255)
    },
    Red = {
        Primary = Color3.fromRGB(220, 20, 60),
        Secondary = Color3.fromRGB(139, 0, 0),
        Background = Color3.fromRGB(15, 15, 20),
        SubBackground = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 100, 100)
    },
    Green = {
        Primary = Color3.fromRGB(50, 205, 50),
        Secondary = Color3.fromRGB(0, 128, 0),
        Background = Color3.fromRGB(15, 15, 20),
        SubBackground = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(144, 238, 144)
    }
}

local CurrentTheme = Themes[_G.EliteConfig.GUITheme] or Themes.Purple

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Create Blur Effect
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

-- Helper function to add corner radius
local function AddCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

-- Helper function to add stroke
local function AddStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = instance
    return stroke
end

-- Helper function to add gradient
local function AddGradient(instance, colors)
    local gradient = Instance.new("UIGradient")
    
    local keypoints = {}
    for i, color in ipairs(colors) do
        table.insert(keypoints, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
    end
    
    gradient.Color = ColorSequence.new(keypoints)
    gradient.Parent = instance
    return gradient
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 550)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -275)
MainFrame.BackgroundColor3 = CurrentTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

AddCorner(MainFrame, 12)
AddStroke(MainFrame, CurrentTheme.Primary, 2, 0.3)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = CurrentTheme.SubBackground
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

AddCorner(TopBar, 12)
AddGradient(TopBar, {CurrentTheme.Primary, CurrentTheme.Secondary})

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 12)
TopBarFix.Position = UDim2.new(0, 0, 1, -12)
TopBarFix.BackgroundColor3 = CurrentTheme.Secondary
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0, 10, 0.5, -17.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://7733993369"
Logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
Logo.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 300, 0, 25)
Title.Position = UDim2.new(0, 52, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "ELITE COMBAT GUI"
Title.TextColor3 = CurrentTheme.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(0, 300, 0, 15)
Subtitle.Position = UDim2.new(0, 52, 0, 28)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "v6.0 Professional Edition • By Claude AI"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

-- Info Display (FPS, Ping, Time)
local InfoDisplay = Instance.new("TextLabel")
InfoDisplay.Name = "InfoDisplay"
InfoDisplay.Size = UDim2.new(0, 200, 0, 40)
InfoDisplay.Position = UDim2.new(1, -210, 0.5, -20)
InfoDisplay.BackgroundTransparency = 1
InfoDisplay.Text = "FPS: 60 | Ping: 0ms"
InfoDisplay.TextColor3 = CurrentTheme.Accent
InfoDisplay.TextSize = 11
InfoDisplay.Font = Enum.Font.Code
InfoDisplay.TextXAlignment = Enum.TextXAlignment.Right
InfoDisplay.Parent = TopBar

-- Update Info Display
task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        InfoDisplay.Text = string.format("FPS: %d | Ping: %dms", fps, ping)
    end
end)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -85, 0.5, -17.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

AddCorner(MinimizeBtn, 8)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

AddCorner(CloseBtn, 8)

-- Minimized Button (shows when minimized)
local MinimizedBtn = Instance.new("TextButton")
MinimizedBtn.Name = "MinimizedBtn"
MinimizedBtn.Size = UDim2.new(0, 60, 0, 60)
MinimizedBtn.Position = UDim2.new(1, -70, 0, 10)
MinimizedBtn.BackgroundColor3 = CurrentTheme.Primary
MinimizedBtn.Text = "⚔️"
MinimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBtn.TextSize = 28
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.Visible = false
MinimizedBtn.Active = true
MinimizedBtn.Draggable = true
MinimizedBtn.Parent = ScreenGui

AddCorner(MinimizedBtn, 30)
AddStroke(MinimizedBtn, CurrentTheme.Accent, 3)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 150, 1, -60)
TabContainer.Position = UDim2.new(0, 5, 0, 55)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 5)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -165, 1, -60)
ContentContainer.Position = UDim2.new(0, 160, 0, 55)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Storage for tabs and frames
local Tabs = {}
local Frames = {}
local CurrentTab = nil

-- Function to create tab button
local function CreateTab(name, icon, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(1, 0, 0, 45)
    tabBtn.BackgroundColor3 = CurrentTheme.SubBackground
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = ""
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabContainer
    
    AddCorner(tabBtn, 8)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 8, 0.5, -15)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = tabBtn
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, -45, 1, 0)
    nameLabel.Position = UDim2.new(0, 42, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = tabBtn
    
    Tabs[name] = {
        Button = tabBtn,
        Icon = iconLabel,
        Name = nameLabel
    }
    
    return tabBtn
end

-- Function to create content frame
local function CreateFrame(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 5
    frame.ScrollBarImageColor3 = CurrentTheme.Primary
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    Frames[name] = frame
    return frame
end

-- Switch Tab Function
local function SwitchTab(tabName)
    for name, tab in pairs(Tabs) do
        if name == tabName then
            tab.Button.BackgroundColor3 = CurrentTheme.Primary
            tab.Icon.TextColor3 = CurrentTheme.Text
            tab.Name.TextColor3 = CurrentTheme.Text
            Frames[name].Visible = true
            CurrentTab = name
        else
            tab.Button.BackgroundColor3 = CurrentTheme.SubBackground
            tab.Icon.TextColor3 = Color3.fromRGB(180, 180, 200)
            tab.Name.TextColor3 = Color3.fromRGB(180, 180, 200)
            Frames[name].Visible = false
        end
    end
end

-- Create Tabs
CreateTab("Combat", "⚔️", 1)
CreateTab("Aimbot", "🎯", 2)
CreateTab("ESP", "👁️", 3)
CreateTab("Player", "👤", 4)
CreateTab("Movement", "🏃", 5)
CreateTab("Visual", "🎨", 6)
CreateTab("World", "🌍", 7)
CreateTab("Farm", "🌾", 8)
CreateTab("Teleport", "📍", 9)
CreateTab("Misc", "⚙️", 10)
CreateTab("Settings", "🔧", 11)

-- Create Frames
local CombatFrame = CreateFrame("Combat")
local AimbotFrame = CreateFrame("Aimbot")
local ESPFrame = CreateFrame("ESP")
local PlayerFrame = CreateFrame("Player")
local MovementFrame = CreateFrame("Movement")
local VisualFrame = CreateFrame("Visual")
local WorldFrame = CreateFrame("World")
local FarmFrame = CreateFrame("Farm")
local TeleportFrame = CreateFrame("Teleport")
local MiscFrame = CreateFrame("Misc")
local SettingsFrame = CreateFrame("Settings")

-- Connect tab buttons
for name, tab in pairs(Tabs) do
    tab.Button.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          UI ELEMENTS CREATION                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Section Header
local function CreateSection(parent, text, order)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. text
    section.Size = UDim2.new(1, 0, 0, 35)
    section.BackgroundColor3 = CurrentTheme.Primary
    section.BorderSizePixel = 0
    section.LayoutOrder = order
    section.Parent = parent
    
    AddCorner(section, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -15, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CurrentTheme.Text
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return section
end

-- Toggle Button
local function CreateToggle(parent, text, default, callback, order)
    local container = Instance.new("Frame")
    container.Name = "Toggle_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = CurrentTheme.SubBackground
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = parent
    
    AddCorner(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CurrentTheme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 24)
    toggle.Position = UDim2.new(1, -55, 0.5, -12)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggle.Text = ""
    toggle.Parent = container
    
    AddCorner(toggle, 12)
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 18, 0, 18)
    indicator.Position = UDim2.new(0, 3, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    AddCorner(indicator, 9)
    
    local enabled = default
    
    local function Update()
        if enabled then
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = CurrentTheme.Primary
            }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -21, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            }):Play()
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(200, 200, 220)
            }):Play()
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Update()
        callback(enabled)
    end)
    
    Update()
    
    return container
end

-- Slider
local function CreateSlider(parent, text, min, max, default, callback, order)
    local container = Instance.new("Frame")
    container.Name = "Slider_" .. text
    container.Size = UDim2.new(1, 0, 0, 55)
    container.BackgroundColor3 = CurrentTheme.SubBackground
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.Parent = parent
    
    AddCorner(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CurrentTheme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 18)
    valueLabel.Position = UDim2.new(1, -65, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = CurrentTheme.Accent
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -16)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    AddCorner(sliderBg, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    AddCorner(fill, 3)
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            MainFrame.Draggable = false
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            MainFrame.Draggable = true
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging then
            local relX = math.clamp(Mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relX / sliderBg.AbsoluteSize.X
            local value = math.floor(min + (percent * (max - min)))
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return container
end

-- Button
local function CreateButton(parent, text, callback, order)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = CurrentTheme.Primary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = CurrentTheme.Text
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = order
    button.Parent = parent
    
    AddCorner(button, 6)
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = CurrentTheme.Secondary
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = CurrentTheme.Primary
        }):Play()
    end)
    
    return button
end

-- Dropdown
local function CreateDropdown(parent, text, options, default, callback, order)
    local container = Instance.new("Frame")
    container.Name = "Dropdown_" .. text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = CurrentTheme.SubBackground
    container.BorderSizePixel = 0
    container.LayoutOrder = order
    container.ClipsDescendants = false
    container.Parent = parent
    
    AddCorner(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CurrentTheme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local selected = Instance.new("TextButton")
    selected.Size = UDim2.new(0, 140, 0, 30)
    selected.Position = UDim2.new(1, -145, 0.5, -15)
    selected.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    selected.Text = default or options[1]
    selected.TextColor3 = CurrentTheme.Text
    selected.TextSize = 11
    selected.Font = Enum.Font.Gotham
    selected.Parent = container
    
    AddCorner(selected, 5)
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = CurrentTheme.Accent
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamBold
    arrow.Parent = selected
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.Size = UDim2.new(0, 140, 0, 0)
    optionsFrame.Position = UDim2.new(1, -145, 1, 5)
    optionsFrame.BackgroundColor3 = CurrentTheme.SubBackground
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = container
    
    AddCorner(optionsFrame, 5)
    AddStroke(optionsFrame, CurrentTheme.Primary, 1)
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.Padding = UDim.new(0, 2)
    optionsList.Parent = optionsFrame
    
    for _, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        optionBtn.BackgroundTransparency = 0.5
        optionBtn.Text = option
        optionBtn.TextColor3 = CurrentTheme.Text
        optionBtn.TextSize = 11
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.ZIndex = 11
        optionBtn.Parent = optionsFrame
        
        AddCorner(optionBtn, 4)
        
        optionBtn.MouseButton1Click:Connect(function()
            selected.Text = option
            optionsFrame.Visible = false
            arrow.Text = "▼"
            callback(option)
        end)
    end
    
    optionsFrame.Size = UDim2.new(0, 140, 0, #options * 32)
    
    selected.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
        arrow.Text = optionsFrame.Visible and "▲" or "▼"
    end)
    
    return container
end

-- Info Box
local function CreateInfoBox(parent, text, order)
    local infoBox = Instance.new("Frame")
    infoBox.Name = "InfoBox"
    infoBox.Size = UDim2.new(1, 0, 0, 0)
    infoBox.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
    infoBox.BackgroundTransparency = 0.8
    infoBox.BorderSizePixel = 0
    infoBox.LayoutOrder = order
    infoBox.Parent = parent
    
    AddCorner(infoBox, 6)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = infoBox
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 230, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = infoBox
    
    local textBounds = Instance.new("TextLabel")
    textBounds.Text = text
    textBounds.TextSize = 11
    textBounds.Font = Enum.Font.Gotham
    textBounds.TextWrapped = true
    textBounds.Size = UDim2.new(1, -20, 0, math.huge)
    textBounds.Parent = Instance.new("Frame")
    
    local height = textBounds.TextBounds.Y + 20
    infoBox.Size = UDim2.new(1, 0, 0, height)
    
    return infoBox
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          POPULATE TABS                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- COMBAT TAB
CreateSection(CombatFrame, "⚔️ HITBOX SYSTEM", 1)
CreateInfoBox(CombatFrame, "📌 Aumenta a hitbox dos inimigos para facilitar acertos. ESP sincroniza automaticamente!", 2)

CreateSlider(CombatFrame, "Tamanho da Hitbox", 1, 50, _G.EliteConfig.HitboxSize, function(v)
    _G.EliteConfig.HitboxSize = v
end, 3)

CreateSlider(CombatFrame, "Transparência", 0, 1, _G.EliteConfig.HitboxTransparency, function(v)
    _G.EliteConfig.HitboxTransparency = v / 100
end, 4)

CreateToggle(CombatFrame, "Hitbox Invisível", _G.EliteConfig.HitboxInvisible, function(v)
    _G.EliteConfig.HitboxInvisible = v
end, 5)

CreateToggle(CombatFrame, "Aplicar no Próprio Time", _G.EliteConfig.HitboxTeamCheck, function(v)
    _G.EliteConfig.HitboxTeamCheck = v
end, 6)

CreateToggle(CombatFrame, "✅ Ativar Hitbox", _G.EliteConfig.HitboxEnabled, function(v)
    _G.EliteConfig.HitboxEnabled = v
    if not v then
        for player, props in pairs(OriginalProperties.Hitboxes) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = props.Size
                hrp.Transparency = props.Transparency
                hrp.Material = props.Material
                hrp.CanCollide = props.CanCollide
                hrp.Color = props.Color
            end
        end
    end
    SendNotification("⚔️ Hitbox", v and "Ativado" or "Desativado", 2)
end, 7)

CreateSection(CombatFrame, "🎖️ SISTEMA VOLVER", 8)
CreateInfoBox(CombatFrame, "📌 Rotação automática por comandos de chat militar", 9)

CreateToggle(CombatFrame, "✅ Ativar Volver", _G.EliteConfig.VolverEnabled, function(v)
    _G.EliteConfig.VolverEnabled = v
    SendNotification("🎖️ Volver", v and "Ativado" or "Desativado", 2)
end, 10)

-- AIMBOT TAB
CreateSection(AimbotFrame, "🎯 AIMBOT", 1)
CreateInfoBox(AimbotFrame, "📌 Mira automática. Segure botão direito do mouse para ativar.", 2)

CreateSlider(AimbotFrame, "FOV (Campo de Visão)", 20, 500, _G.EliteConfig.AimbotFOV, function(v)
    _G.EliteConfig.AimbotFOV = v
end, 3)

CreateSlider(AimbotFrame, "Suavidade (Smoothness)", 1, 20, _G.EliteConfig.AimbotSmooth, function(v)
    _G.EliteConfig.AimbotSmooth = v
end, 4)

CreateDropdown(AimbotFrame, "Parte do Corpo", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, 
    _G.EliteConfig.AimbotPart, function(v)
    _G.EliteConfig.AimbotPart = v
end, 5)

CreateToggle(AimbotFrame, "Mostrar Círculo FOV", _G.EliteConfig.AimbotShowFOV, function(v)
    _G.EliteConfig.AimbotShowFOV = v
end, 6)

CreateToggle(AimbotFrame, "Team Check (Ignorar Time)", _G.EliteConfig.AimbotTeamCheck, function(v)
    _G.EliteConfig.AimbotTeamCheck = v
end, 7)

CreateToggle(AimbotFrame, "Verificar Visibilidade", _G.EliteConfig.AimbotVisibleCheck, function(v)
    _G.EliteConfig.AimbotVisibleCheck = v
end, 8)

CreateToggle(AimbotFrame, "✅ Ativar Aimbot", _G.EliteConfig.AimbotEnabled, function(v)
    _G.EliteConfig.AimbotEnabled = v
    SendNotification("🎯 Aimbot", v and "Ativado - Segure botão direito" or "Desativado", 2)
end, 9)

CreateSection(AimbotFrame, "🎲 SILENT AIM", 10)
CreateInfoBox(AimbotFrame, "📌 Mira silenciosa - sem mover a câmera", 11)

CreateSlider(AimbotFrame, "Hit Chance (%)", 0, 100, _G.EliteConfig.SilentAimHitChance, function(v)
    _G.EliteConfig.SilentAimHitChance = v
end, 12)

CreateSlider(AimbotFrame, "Predição", 0, 1, _G.EliteConfig.SilentAimPrediction * 100, function(v)
    _G.EliteConfig.SilentAimPrediction = v / 100
end, 13)

CreateToggle(AimbotFrame, "✅ Ativar Silent Aim", _G.EliteConfig.SilentAimEnabled, function(v)
    _G.EliteConfig.SilentAimEnabled = v
    SendNotification("🎲 Silent Aim", v and "Ativado" or "Desativado", 2)
end, 14)

-- ESP TAB
CreateSection(ESPFrame, "👁️ ESP VISUAL", 1)
CreateInfoBox(ESPFrame, "📌 ESP sincronizada com hitbox. Mostra informações dos jogadores.", 2)

CreateToggle(ESPFrame, "📦 Box ESP", _G.EliteConfig.ESPBox, function(v)
    _G.EliteConfig.ESPBox = v
end, 3)

CreateToggle(ESPFrame, "📛 Nome", _G.EliteConfig.ESPName, function(v)
    _G.EliteConfig.ESPName = v
end, 4)

CreateToggle(ESPFrame, "📏 Distância", _G.EliteConfig.ESPDistance, function(v)
    _G.EliteConfig.ESPDistance = v
end, 5)

CreateToggle(ESPFrame, "❤️ Vida (HP)", _G.EliteConfig.ESPHealth, function(v)
    _G.EliteConfig.ESPHealth = v
end, 6)

CreateToggle(ESPFrame, "💚 Barra de Vida", _G.EliteConfig.ESPHealthBar, function(v)
    _G.EliteConfig.ESPHealthBar = v
end, 7)

CreateToggle(ESPFrame, "🔫 Arma", _G.EliteConfig.ESPWeapon, function(v)
    _G.EliteConfig.ESPWeapon = v
end, 8)

CreateToggle(ESPFrame, "📡 Tracer (Linha)", _G.EliteConfig.ESPTracer, function(v)
    _G.EliteConfig.ESPTracer = v
end, 9)

CreateToggle(ESPFrame, "💀 Skeleton (Esqueleto)", _G.EliteConfig.ESPSkeleton, function(v)
    _G.EliteConfig.ESPSkeleton = v
end, 10)

CreateToggle(ESPFrame, "✨ Chams (Highlight)", _G.EliteConfig.ESPChams, function(v)
    _G.EliteConfig.ESPChams = v
end, 11)

CreateSection(ESPFrame, "⚙️ CONFIGURAÇÕES ESP", 12)

CreateSlider(ESPFrame, "Distância Máxima", 100, 5000, _G.EliteConfig.ESPMaxDistance, function(v)
    _G.EliteConfig.ESPMaxDistance = v
end, 13)

CreateSlider(ESPFrame, "Espessura das Linhas", 1, 5, _G.EliteConfig.ESPThickness, function(v)
    _G.EliteConfig.ESPThickness = v
end, 14)

CreateToggle(ESPFrame, "👥 Team Check (Ignorar Time)", _G.EliteConfig.ESPTeamCheck, function(v)
    _G.EliteConfig.ESPTeamCheck = v
end, 15)

CreateToggle(ESPFrame, "🎨 Usar Cor do Time", _G.EliteConfig.ESPUseTeamColor, function(v)
    _G.EliteConfig.ESPUseTeamColor = v
end, 16)

CreateToggle(ESPFrame, "✅ Ativar ESP", _G.EliteConfig.ESPEnabled, function(v)
    _G.EliteConfig.ESPEnabled = v
    SendNotification("👁️ ESP", v and "Ativado" or "Desativado", 2)
end, 17)

-- PLAYER TAB
CreateSection(PlayerFrame, "⚡ VELOCIDADE & PULO", 1)

CreateSlider(PlayerFrame, "Velocidade", 16, 200, _G.EliteConfig.SpeedValue, function(v)
    _G.EliteConfig.SpeedValue = v
end, 2)

CreateToggle(PlayerFrame, "✅ Ativar Speed", _G.EliteConfig.SpeedEnabled, function(v)
    _G.EliteConfig.SpeedEnabled = v
    SendNotification("⚡ Speed", v and "Ativado" or "Desativado", 2)
end, 3)

CreateSlider(PlayerFrame, "Força do Pulo", 50, 300, _G.EliteConfig.JumpValue, function(v)
    _G.EliteConfig.JumpValue = v
end, 4)

CreateToggle(PlayerFrame, "✅ Ativar Super Jump", _G.EliteConfig.JumpEnabled, function(v)
    _G.EliteConfig.JumpEnabled = v
    SendNotification("🦘 Super Jump", v and "Ativado" or "Desativado", 2)
end, 5)

CreateToggle(PlayerFrame, "♾️ Pulo Infinito", _G.EliteConfig.InfiniteJump, function(v)
    _G.EliteConfig.InfiniteJump = v
    SendNotification("♾️ Infinite Jump", v and "Ativado" or "Desativado", 2)
end, 6)

CreateSection(PlayerFrame, "🌌 GRAVIDADE", 7)

CreateSlider(PlayerFrame, "Gravidade", 0, 196, _G.EliteConfig.GravityValue, function(v)
    _G.EliteConfig.GravityValue = v
end, 8)

CreateToggle(PlayerFrame, "✅ Ativar Gravidade Custom", _G.EliteConfig.GravityEnabled, function(v)
    _G.EliteConfig.GravityEnabled = v
    SendNotification("🌌 Gravity", v and "Ativado" or "Desativado", 2)
end, 9)

CreateSection(PlayerFrame, "💪 OUTROS", 10)

CreateToggle(PlayerFrame, "♾️ Stamina Infinita", _G.EliteConfig.InfiniteStamina, function(v)
    _G.EliteConfig.InfiniteStamina = v
    SendNotification("♾️ Infinite Stamina", v and "Ativado" or "Desativado", 2)
end, 11)

CreateToggle(PlayerFrame, "🛡️ Sem Dano de Queda", _G.EliteConfig.NoFallDamage, function(v)
    _G.EliteConfig.NoFallDamage = v
    SendNotification("🛡️ No Fall Damage", v and "Ativado" or "Desativado", 2)
end, 12)

-- MOVEMENT TAB
CreateSection(MovementFrame, "✈️ SISTEMA DE VOO", 1)
CreateInfoBox(MovementFrame, "📌 Voe livremente! WASD = Mover | Space = Subir | Shift = Descer | E = Toggle", 2)

CreateSlider(MovementFrame, "Velocidade de Voo", 20, 300, _G.EliteConfig.FlySpeed, function(v)
    _G.EliteConfig.FlySpeed = v
end, 3)

CreateToggle(MovementFrame, "Noclip Automático (Fly)", _G.EliteConfig.FlyNoclip, function(v)
    _G.EliteConfig.FlyNoclip = v
end, 4)

CreateToggle(MovementFrame, "✅ Ativar Fly (Tecla E)", _G.EliteConfig.FlyEnabled, function(v)
    if v then
        StartFly()
    else
        StopFly()
    end
end, 5)

CreateSection(MovementFrame, "👻 NOCLIP", 6)
CreateInfoBox(MovementFrame, "📌 Atravesse paredes! Pressione N para ativar/desativar", 7)

CreateToggle(MovementFrame, "✅ Ativar Noclip (Tecla N)", _G.EliteConfig.NoclipEnabled, function(v)
    if v then
        StartNoclip()
    else
        StopNoclip()
    end
end, 8)

-- VISUAL TAB
CreateSection(VisualFrame, "💡 ILUMINAÇÃO", 1)

CreateToggle(VisualFrame, "💡 Fullbright", _G.EliteConfig.FullbrightEnabled, function(v)
    _G.EliteConfig.FullbrightEnabled = v
    ApplyVisuals()
    SendNotification("💡 Fullbright", v and "Ativado" or "Desativado", 2)
end, 2)

CreateToggle(VisualFrame, "🌫️ Remover Neblina", _G.EliteConfig.NoFog, function(v)
    _G.EliteConfig.NoFog = v
    ApplyVisuals()
    SendNotification("🌫️ No Fog", v and "Ativado" or "Desativado", 2)
end, 3)

CreateToggle(VisualFrame, "🌈 Modo Rainbow", _G.EliteConfig.RainbowMode, function(v)
    _G.EliteConfig.RainbowMode = v
    SendNotification("🌈 Rainbow", v and "Ativado" or "Desativado", 2)
end, 4)

-- WORLD TAB
CreateSection(WorldFrame, "🕐 CONTROLE DE TEMPO", 1)

CreateSlider(WorldFrame, "Hora do Dia", 0, 24, _G.EliteConfig.TimeValue, function(v)
    _G.EliteConfig.TimeValue = v
    if _G.EliteConfig.TimeEnabled then
        Lighting.ClockTime = v
    end
end, 2)

CreateToggle(WorldFrame, "✅ Fixar Horário", _G.EliteConfig.TimeEnabled, function(v)
    _G.EliteConfig.TimeEnabled = v
    ApplyVisuals()
    SendNotification("🕐 Time Control", v and "Ativado" or "Desativado", 2)
end, 3)

CreateButton(WorldFrame, "☀️ Dia (12h)", function()
    _G.EliteConfig.TimeValue = 12
    _G.EliteConfig.TimeEnabled = true
    Lighting.ClockTime = 12
end, 4)

CreateButton(WorldFrame, "🌙 Noite (0h)", function()
    _G.EliteConfig.TimeValue = 0
    _G.EliteConfig.TimeEnabled = true
    Lighting.ClockTime = 0
end, 5)

-- FARM TAB
CreateSection(FarmFrame, "🖱️ AUTO CLICK", 1)

CreateSlider(FarmFrame, "CPS (Clicks por segundo)", 1, 50, _G.EliteConfig.AutoClickCPS, function(v)
    _G.EliteConfig.AutoClickCPS = v
end, 2)

CreateToggle(FarmFrame, "✅ Auto Click", _G.EliteConfig.AutoClick, function(v)
    _G.EliteConfig.AutoClick = v
    if v then
        StartAutoClick()
    else
        StopAutoClick()
    end
    SendNotification("🖱️ Auto Click", v and "Ativado" or "Desativado", 2)
end, 3)

CreateSection(FarmFrame, "⚔️ KILL AURA", 4)
CreateInfoBox(FarmFrame, "📌 Ataca automaticamente inimigos próximos", 5)

CreateSlider(FarmFrame, "Alcance", 5, 50, _G.EliteConfig.KillAuraRange, function(v)
    _G.EliteConfig.KillAuraRange = v
end, 6)

CreateToggle(FarmFrame, "Team Check", _G.EliteConfig.KillAuraTeamCheck, function(v)
    _G.EliteConfig.KillAuraTeamCheck = v
end, 7)

CreateToggle(FarmFrame, "✅ Ativar Kill Aura", _G.EliteConfig.KillAuraEnabled, function(v)
    _G.EliteConfig.KillAuraEnabled = v
    if v then
        StartKillAura()
    else
        StopKillAura()
    end
    SendNotification("⚔️ Kill Aura", v and "Ativado" or "Desativado", 2)
end, 8)

CreateSection(FarmFrame, "🏃 AUTO FARM", 9)

CreateToggle(FarmFrame, "🏃 Auto Sprint", _G.EliteConfig.AutoSprint, function(v)
    _G.EliteConfig.AutoSprint = v
    SendNotification("🏃 Auto Sprint", v and "Ativado" or "Desativado", 2)
end, 10)

CreateToggle(FarmFrame, "🔄 Auto Reload", _G.EliteConfig.AutoReload, function(v)
    _G.EliteConfig.AutoReload = v
    SendNotification("🔄 Auto Reload", v and "Ativado" or "Desativado", 2)
end, 11)

-- TELEPORT TAB
CreateSection(TeleportFrame, "📍 TELEPORTE", 1)
CreateInfoBox(TeleportFrame, "📌 Sistema de teleporte e waypoints", 2)

CreateButton(TeleportFrame, "💾 Salvar Posição Atual", function()
    local pos = HumanoidRootPart.Position
    table.insert(Waypoints, {Name = "Waypoint " .. #Waypoints + 1, Position = pos})
    SendNotification("📍 Waypoint", "Posição salva!", 2)
end, 3)

CreateButton(TeleportFrame, "🗺️ Ver Waypoints", function()
    if #Waypoints == 0 then
        SendNotification("📍 Waypoints", "Nenhum waypoint salvo", 2)
    else
        for i, wp in ipairs(Waypoints) do
            print(i .. ". " .. wp.Name .. " - " .. tostring(wp.Position))
        end
        SendNotification("📍 Waypoints", "Check console (F9)", 2)
    end
end, 4)

-- MISC TAB
CreateSection(MiscFrame, "⚙️ CONFIGURAÇÕES DIVERSAS", 1)

CreateToggle(MiscFrame, "💤 Anti-AFK", _G.EliteConfig.AntiAFK, function(v)
    _G.EliteConfig.AntiAFK = v
    SendNotification("💤 Anti-AFK", v and "Ativado" or "Desativado", 2)
end, 2)

CreateToggle(MiscFrame, "🚀 FPS Boost", _G.EliteConfig.FPSBoost, function(v)
    _G.EliteConfig.FPSBoost = v
    
    if v then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
    end
    
    SendNotification("🚀 FPS Boost", v and "Ativado" or "Desativado", 2)
end, 3)

CreateToggle(MiscFrame, "🌿 Remover Grama", _G.EliteConfig.RemoveGrass, function(v)
    _G.EliteConfig.RemoveGrass = v
    
    if v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then
                obj.Transparency = 1
            end
        end
    end
    
    SendNotification("🌿 Remove Grass", v and "Ativado" or "Desativado", 2)
end, 4)

CreateSection(MiscFrame, "📋 INFORMAÇÕES", 5)

CreateButton(MiscFrame, "📊 Ver Estatísticas", function()
    local stats = string.format([[
FPS: %d
Ping: %dms
Players: %d
Tempo de Jogo: %ds
    ]], 
        math.floor(1 / RunService.RenderStepped:Wait()),
        math.floor(LocalPlayer:GetNetworkPing() * 1000),
        #Players:GetPlayers(),
        math.floor(tick() - game:GetService("Workspace").DistributedGameTime)
    )
    
    print(stats)
    SendNotification("📊 Stats", "Check console (F9)", 3)
end, 6)

CreateButton(MiscFrame, "🔄 Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end, 7)

CreateButton(MiscFrame, "🏠 Voltar ao Lobby", function()
    LocalPlayer:Kick("Voltando ao lobby...")
end, 8)

-- SETTINGS TAB
CreateSection(SettingsFrame, "🎨 TEMA DA GUI", 1)

CreateDropdown(SettingsFrame, "Tema", {"Purple", "Blue", "Red", "Green"}, _G.EliteConfig.GUITheme, function(v)
    _G.EliteConfig.GUITheme = v
    SendNotification("🎨 Tema", "Reinicie a GUI para aplicar", 3)
end, 2)

CreateSection(SettingsFrame, "🔔 NOTIFICAÇÕES", 3)

CreateToggle(SettingsFrame, "Mostrar Notificações", _G.EliteConfig.Notifications, function(v)
    _G.EliteConfig.Notifications = v
end, 4)

CreateSection(SettingsFrame, "⌨️ KEYBINDS", 5)
CreateInfoBox(SettingsFrame, "📌 Teclas padrão:\nRightShift = Toggle GUI\nE = Fly\nN = Noclip\nP = ESP\nB = Aimbot", 6)

CreateSection(SettingsFrame, "📁 CONFIG", 7)

CreateButton(SettingsFrame, "💾 Salvar Config", function()
    -- Placeholder para save system
    SendNotification("💾 Config", "Salvo! (Em desenvolvimento)", 3)
end, 8)

CreateButton(SettingsFrame, "📂 Carregar Config", function()
    -- Placeholder para load system
    SendNotification("📂 Config", "Carregado! (Em desenvolvimento)", 3)
end, 9)

CreateSection(SettingsFrame, "ℹ️ SOBRE", 10)
CreateInfoBox(SettingsFrame, [[
✨ ELITE COMBAT GUI v6.0
👨‍💻 Criado por: Claude AI
📅 Data: 2026
🌟 Features: 100+ funções
💜 Obrigado por usar!

Discord: discord.gg/elitegui (exemplo)
]], 11)

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          GUI ANIMATIONS & EVENTS                          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Minimize Button
MinimizeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
    
    task.wait(0.3)
    MainFrame.Visible = false
    MinimizedBtn.Visible = true
    
    MinimizedBtn.Size = UDim2.new(0, 0, 0, 0)
    MinimizedBtn.Position = UDim2.new(1, -35, 0, 35)
    
    TweenService:Create(MinimizedBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(1, -70, 0, 10)
    }):Play()
end)

-- Restore from Minimize
MinimizedBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MinimizedBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 10}):Play()
    
    task.wait(0.3)
    MinimizedBtn.Visible = false
    MainFrame.Visible = true
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 550),
        Position = UDim2.new(0.5, -350, 0.5, -275)
    }):Play()
end)

-- Close Button
CloseBtn.MouseButton1Click:Connect(function()
    -- Disable all features
    _G.EliteConfig.HitboxEnabled = false
    _G.EliteConfig.ESPEnabled = false
    _G.EliteConfig.AimbotEnabled = false
    
    if _G.EliteConfig.FlyEnabled then
        StopFly()
    end
    
    if _G.EliteConfig.NoclipEnabled then
        StopNoclip()
    end
    
    -- Restore hitboxes
    for player, props in pairs(OriginalProperties.Hitboxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = props.Size
            hrp.Transparency = props.Transparency
            hrp.Material = props.Material
            hrp.CanCollide = props.CanCollide
            hrp.Color = props.Color
        end
    end
    
    -- Disconnect all connections
    for _, conn in pairs(Connections) do
        if conn then
            conn:Disconnect()
        end
    end
    
    -- Animate close
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
    
    task.wait(0.3)
    ScreenGui:Destroy()
    BlurEffect:Destroy()
    
    SendNotification("👋 Elite GUI", "GUI fechada. Até logo!", 3)
end)

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          KEYBINDS                                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Toggle GUI
    if input.KeyCode == _G.EliteConfig.ToggleGUI then
        MainFrame.Visible = not MainFrame.Visible
        MinimizedBtn.Visible = not MinimizedBtn.Visible
    end
    
    -- Toggle Fly
    if input.KeyCode == _G.EliteConfig.ToggleFly then
        if _G.EliteConfig.FlyEnabled then
            StopFly()
        else
            StartFly()
        end
    end
    
    -- Toggle Noclip
    if input.KeyCode == _G.EliteConfig.ToggleNoclip then
        if _G.EliteConfig.NoclipEnabled then
            StopNoclip()
        else
            StartNoclip()
        end
    end
    
    -- Toggle ESP
    if input.KeyCode == _G.EliteConfig.ToggleESP then
        _G.EliteConfig.ESPEnabled = not _G.EliteConfig.ESPEnabled
        SendNotification("👁️ ESP", _G.EliteConfig.ESPEnabled and "Ativado" or "Desativado", 2)
    end
    
    -- Toggle Aimbot
    if input.KeyCode == _G.EliteConfig.ToggleAimbot then
        _G.EliteConfig.AimbotEnabled = not _G.EliteConfig.AimbotEnabled
        SendNotification("🎯 Aimbot", _G.EliteConfig.AimbotEnabled and "Ativado" or "Desativado", 2)
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          INITIALIZATION                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Animate GUI entrance
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 10}):Play()

TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 700, 0, 550),
    Position = UDim2.new(0.5, -350, 0.5, -275)
}):Play()

-- Switch to Combat tab by default
task.wait(0.2)
SwitchTab("Combat")

-- Welcome notification
task.wait(0.5)
SendNotification("✨ Elite Combat GUI", "v6.0 carregado com sucesso!", 4)
SendNotification("📌 Keybinds", "RightShift=Menu | E=Fly | N=Noclip", 5)

-- Console logs
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✨ ELITE COMBAT GUI v6.0 PROFESSIONAL EDITION")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ GUI Carregada com sucesso!")
print("📌 Keybinds:")
print("   - RightShift: Toggle GUI")
print("   - E: Fly On/Off")
print("   - N: Noclip On/Off")
print("   - P: ESP On/Off")
print("   - B: Aimbot On/Off")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎮 Divirta-se!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
