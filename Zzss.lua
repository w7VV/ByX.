--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
getgenv().crosshair = {
    enabled = true,
    refreshrate = 0,
    mode = 'mouse',
    position = Vector2.new(0, 0),

    width = 1.5,
    length = 10,
    radius = 11,
    color = Color3.fromRGB(128, 16, 255),

    spin = true,
    spin_speed = 150,
    spin_max = 340,
    spin_style = Enum.EasingStyle.Sine,

    resize = true,
    resize_speed = 150,
    resize_min = 5,
    resize_max = 22,
}

local old; old = hookfunction(Drawing.new, function(class, properties)
    local drawing = old(class)
    for i, v in next, properties or {} do
        drawing[i] = v
    end
    return drawing
end)

local runservice = game:GetService('RunService')
local inputservice = game:GetService('UserInputService')
local tweenservice = game:GetService('TweenService')
local camera = workspace.CurrentCamera

local last_render = 0

local drawings = {
    crosshair = {},
    text = {Drawing.new('Text', {Size = 13, Font = 2, Outline = true, Text = 'Client', Color = Color3.new(1, 1, 1)}),
            Drawing.new('Text', {Size = 13, Font = 2, Outline = true, Text = ".cc"}),},
}

for idx = 1, 8 do
    drawings.crosshair[idx] = Drawing.new('Line')
end

function solve(angle, radius)
    return Vector2.new(
        math.sin(math.rad(angle)) * radius,
        math.cos(math.rad(angle)) * radius
    )
end

runservice.PostSimulation:Connect(function()

    local _tick = tick()

    if _tick - last_render > crosshair.refreshrate then
        last_render = _tick

        local position = (
            crosshair.mode == 'center' and camera.ViewportSize / 2 or
            crosshair.mode == 'mouse' and inputservice:GetMouseLocation() or
            crosshair.position
        )

        local text_x = drawings.text[1].TextBounds.X + drawings.text[2].TextBounds.X

        drawings.text[1].Visible = crosshair.enabled
        drawings.text[2].Visible = crosshair.enabled

        if crosshair.enabled then
            drawings.text[1].Position = position + Vector2.new(-text_x / 2, crosshair.radius + (crosshair.resize and crosshair.resize_max or crosshair.length) + 15)
            drawings.text[2].Position = drawings.text[1].Position + Vector2.new(drawings.text[1].TextBounds.X)
            drawings.text[2].Color = crosshair.color
            
            for idx = 1, 4 do
                local outline = drawings.crosshair[idx]
                local inline = drawings.crosshair[idx + 4]
    
                local angle = (idx - 1) * 90
                local length = crosshair.length
    
                if crosshair.spin then
                    local spin_angle = -_tick * crosshair.spin_speed % crosshair.spin_max
                    angle = angle + tweenservice:GetValue(spin_angle / 360, crosshair.spin_style, Enum.EasingDirection.InOut) * 360
                end
    
                if crosshair.resize then
                    local resize_length = tick() * crosshair.resize_speed % 180
                    length = crosshair.resize_min + math.sin(math.rad(resize_length)) * crosshair.resize_max
                end
    
                inline.Visible = true
                inline.Color = crosshair.color
                inline.From = position + solve(angle, crosshair.radius)
                inline.To = position + solve(angle, crosshair.radius + length)
                inline.Thickness = crosshair.width
    
                outline.Visible = true
                outline.From = position + solve(angle, crosshair.radius - 1)
                outline.To = position + solve(angle, crosshair.radius + length + 1)
                outline.Thickness = crosshair.width + 1.5    
            end
        else
            for idx = 1, 8 do
                drawings.crosshair[idx].Visible = false
            end
        end

    end
end)
--////////////
--////////////
_G.SilentAim = false 
_G.AimbotNPC = false 
_G.FOV = 150 
_G.VisibleCheck = true 
_G.TeamCheck = true 
_G.TeamCheckForNPCs = false 
_G.Prediction = 0.165 
_G.UpdateRate = 0.1 
_G.TargetMode = "NPCs" -- "NPCs", "Both"
_G.AimPart = "Head" -- "Head", "Torso", "Both", "Random"
_G.ShowTarget = true 
_G.HitChance = 100 
_G.BulletTeleport = false 
_G.ShowTargetName = true 
_G.ShowTargetType = true 
_G.ShowTargetHP = true 
_G.ShowTargetDistance = true 
_G.ShowHitChance = true 
_G.HighlightTarget = false 
_G.DebugNPCs = false 
_G.AggressiveNPCDetection = false 


_G.TargetPriority = "Distance" -- "Crosshair", "Distance", "LowestHP"
_G.StickyAim = true 
_G.FOVColor = Color3.fromRGB(255, 255, 255) 
_G.NPC_ESP_Enabled = false 
_G.NPC_ESP_Skeleton = true 
_G.NPC_ESP_Name = true 
_G.NPC_ESP_Distance = true 
_G.NPC_ESP_Color = Color3.fromRGB(255, 0, 0) 


task.spawn(function()
    for k, v in pairs(getgc(true)) do
        if pcall(function()
            return rawget(v, "indexInstance")
        end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
            setreadonly(v, false)
            v.tvk = {
                "kick",
                function()
                    return game.Workspace:WaitForChild("")
                end
            }
        end
    end
end)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Fov circle
local Circle = getgenv().ScriptFOVCircle or Drawing.new("Circle")
getgenv().ScriptFOVCircle = Circle
Circle.Color = _G.FOVColor or Color3.fromRGB(255, 255, 255)
Circle.Thickness = 2
Circle.Visible = false
Circle.Radius = _G.FOV
Circle.Transparency = 0.7
Circle.Filled = false

--// Target info
local TargetInfo = getgenv().ScriptTargetInfo or Drawing.new("Text")
getgenv().ScriptTargetInfo = TargetInfo
TargetInfo.Visible = false
TargetInfo.Color = Color3.fromRGB(255, 255, 255)
TargetInfo.Size = 18
TargetInfo.Font = 2
TargetInfo.Outline = true
TargetInfo.OutlineColor = Color3.fromRGB(0, 0, 0)
TargetInfo.Text = ""

--// HIGHLIGHT
local TargetHighlight = nil
local HighlightConnection = nil

--// V
local CurrentTarget = nil
local TargetPart = nil
local TargetInRange = false
local NPCCache = {}
local PlayerCache = {}
local LastCacheUpdate = 0
local CacheUpdateInterval = 2
local NPCESPObjects = {}

--// hookvariables
local oldNamecall = nil
local oldIndex = nil

--// create highlights
local function CreateHighlight(target)
    if not target or not target:IsA("Model") then return nil end
    
    -- remove old highlight
    if TargetHighlight then
        TargetHighlight:Destroy()
        TargetHighlight = nil
    end
    
    if HighlightConnection then
        HighlightConnection:Disconnect()
        HighlightConnection = nil
    end
    
    -- create new highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "SilentAimHighlight"
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = game:GetService("CoreGui")
    
    
    HighlightConnection = target.Destroying:Connect(function()
        if highlight then
            highlight:Destroy()
            TargetHighlight = nil
        end
    end)
    
    return highlight
end

--// update highlight
local function UpdateHighlight()
    if not _G.HighlightTarget then
        if TargetHighlight then
            TargetHighlight:Destroy()
            TargetHighlight = nil
        end
        if HighlightConnection then
            HighlightConnection:Disconnect()
            HighlightConnection = nil
        end
        return
    end
    
    if CurrentTarget then
        if not TargetHighlight or TargetHighlight.Adornee ~= CurrentTarget then
            TargetHighlight = CreateHighlight(CurrentTarget)
        end
        
        if TargetHighlight then
            -- update cores 
            local isPlayer = false
            for _, data in pairs(PlayerCache) do
                if data.Model == CurrentTarget then
                    isPlayer = true
                    break
                end
            end
            
            if isPlayer then
                TargetHighlight.FillColor = Color3.fromHSV(0.584951, 0.807843, 1)  -- Azul para players
            else
                TargetHighlight.FillColor = Color3.fromRGB(103, 206, 255)   -- Vermelho para NPCs
            end
            
            -- hit chance
            if _G.HitChance >= 80 then
                local pulse = math.sin(tick() * 3) * 0.2 + 0.8
                TargetHighlight.FillTransparency = 0.7 + (0.2 * (1 - pulse))
            else
                TargetHighlight.FillTransparency = 0.7
            end
        end
    else
        if TargetHighlight then
            TargetHighlight:Destroy()
            TargetHighlight = nil
        end
        if HighlightConnection then
            HighlightConnection:Disconnect()
            HighlightConnection = nil
        end
    end
end


local function CleanupUIOnly()
   
    if Circle then 
        Circle.Visible = false
    end
    
 
    if TargetInfo then
        TargetInfo.Visible = false
        TargetInfo.Text = ""  
    end
    
    
    if TargetHighlight then
        TargetHighlight:Destroy()
        TargetHighlight = nil
    end
    
    if HighlightConnection then
        HighlightConnection:Disconnect()
        HighlightConnection = nil
    end
    
    CurrentTarget = nil
    TargetPart = nil
    TargetInRange = false
    NPCCache = {}
    PlayerCache = {}
end

--// npcs function
local function GetCharacterPart(character, names)
    for _, name in ipairs(names) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part
        end
    end
end


local NPCSkeletonBones = {
    {{"Head"}, {"UpperTorso", "Torso"}}, 
    {{"UpperTorso", "Torso"}, {"HumanoidRootPart"}}, 
    {{"UpperTorso", "Torso"}, {"LeftUpperArm", "Left Arm", "LeftArm"}}, 
    {{"UpperTorso", "Torso"}, {"RightUpperArm", "Right Arm", "RightArm"}}, 
    {{"HumanoidRootPart", "UpperTorso", "Torso"}, {"LeftUpperLeg", "Left Leg", "LeftLeg"}}, 
    {{"HumanoidRootPart", "UpperTorso", "Torso"}, {"RightUpperLeg", "Right Leg", "RightLeg"}}, 
}

local function EnsureNPCESPEntry(model)
    local esp = NPCESPObjects[model]
    if esp then return esp end

    esp = {
        SkeletonLines = {},
        Label = Drawing.new("Text"),
    }

    esp.Label.Visible = false
    esp.Label.Color = _G.NPC_ESP_Color
    esp.Label.Size = 14
    esp.Label.Font = 2
    esp.Label.Outline = true
    esp.Label.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Label.Text = ""

    -- skeleton esp
    for i = 1, #NPCSkeletonBones do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.Color = _G.NPC_ESP_Color
        esp.SkeletonLines[i] = line
    end

    NPCESPObjects[model] = esp
    return esp
end

local function HideNPCESPEntry(esp)
    if not esp then return end
    if esp.Label then
        esp.Label.Visible = false
    end
    if esp.SkeletonLines then
        for _, line in ipairs(esp.SkeletonLines) do
            line.Visible = false
        end
    end
end

local function UpdateNPCESP()
    if not _G.NPC_ESP_Enabled then
        for _, esp in pairs(NPCESPObjects) do
            HideNPCESPEntry(esp)
        end
        return
    end

    for model, esp in pairs(NPCESPObjects) do
        if not NPCCache[model] or not model.Parent then
            HideNPCESPEntry(esp)
            NPCESPObjects[model] = nil
        end
    end

   
    for model, data in pairs(NPCCache) do
        local humanoid = data.Humanoid
        if humanoid and humanoid.Health > 0 and model.Parent then
            local esp = EnsureNPCESPEntry(model)

            -- update color based on ui
            esp.Label.Color = _G.NPC_ESP_Color
            for _, line in ipairs(esp.SkeletonLines) do
                line.Color = _G.NPC_ESP_Color
            end

            
            local head = GetCharacterPart(model, {"Head"})
            local root = GetCharacterPart(model, {"HumanoidRootPart"})
            local basePart = head or root

            -- esp
            if _G.NPC_ESP_Name or _G.NPC_ESP_Distance then
                if basePart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(basePart.Position)
                    if onScreen then
                        local lines = {}
                        if _G.NPC_ESP_Name then
                            table.insert(lines, "[NPC] " .. model.Name)
                        end

                        if _G.NPC_ESP_Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local localRoot = LocalPlayer.Character.HumanoidRootPart
                            local distance = (basePart.Position - localRoot.Position).Magnitude
                            table.insert(lines, string.format("Dist: %.1f studs", distance))
                        end

                        if #lines > 0 then
                            esp.Label.Visible = true
                            esp.Label.Position = Vector2.new(screenPos.X, screenPos.Y - 25)
                            esp.Label.Text = table.concat(lines, "\n")
                        else
                            esp.Label.Visible = false
                            esp.Label.Text = ""
                        end
                    else
                        esp.Label.Visible = false
                    end
                else
                    esp.Label.Visible = false
                end
            else
                esp.Label.Visible = false
            end

            -- Skeleton ESP
            if _G.NPC_ESP_Skeleton then
                for index, bone in ipairs(NPCSkeletonBones) do
                    local fromPart = GetCharacterPart(model, bone[1])
                    local toPart = GetCharacterPart(model, bone[2])
                    local line = esp.SkeletonLines[index]

                    if fromPart and toPart and line then
                        local s1, on1 = Camera:WorldToViewportPoint(fromPart.Position)
                        local s2, on2 = Camera:WorldToViewportPoint(toPart.Position)

                        if on1 and on2 then
                            line.Visible = true
                            line.From = Vector2.new(s1.X, s1.Y)
                            line.To = Vector2.new(s2.X, s2.Y)
                        else
                            line.Visible = false
                        end
                    elseif line then
                        line.Visible = false
                    end
                end
            else
                for _, line in ipairs(esp.SkeletonLines) do
                    line.Visible = false
                end
            end
        else
            local esp = NPCESPObjects[model]
            if esp then
                HideNPCESPEntry(esp)
            end
        end
    end
end

--// Npc tags list
local NPCTags = {
    -- NPC
    "NPC", "Npc", "npc",
    
    "Enemy", "enemy", "Enemies", "enemies",
    "Hostile", "hostile", "Bad", "bad", "BadGuy", "badguy",
    "Foe", "foe", "Opponent", "opponent",
    
    "Bot", "bot", "Bots", "bots",
    "Mob", "mob", "Mobs", "mobs",
    "Monster", "monster", "Monsters", "monsters",
    "Zombie", "zombie", "Zombies", "zombies",
    "Creature", "creature", "Animal", "animal", "Beast", "beast",
    
    "Villain", "villain", "Villian", "villian",
    "Boss", "boss", "MiniBoss", "miniboss",
    "Guard", "guard", "Guardian", "guardian",
    "Soldier", "soldier", "Warrior", "warrior",
    "Fighter", "fighter",
    
    "Target", "target",
    "Dummy", "dummy", "Dummies", "dummies",
    "Practice", "practice", "Training", "training",
    
    "Skeleton", "skeleton",
    "Orc", "orc", "Goblin", "goblin",
    "Troll", "troll", "Ogre", "ogre",
    "Demon", "demon", "Devil", "devil",
    "Ghost", "ghost", "Spirit", "spirit",
    "Vampire", "vampire", "Werewolf", "werewolf",
    "Dragon", "dragon", "Wyvern", "wyvern",
    
    "Gang", "gang", "Thug", "thug",
    "Bandit", "bandit", "Raider", "raider",
    "Pirate", "pirate", "Corsair", "corsair",
    
    "Agent", "agent", "Assassin", "assassin",
    "Mercenary", "mercenary", "Hunter", "hunter",
    
    "Robot", "robot", "Drone", "drone",
    "Android", "android", "Cyborg", "cyborg",
    "Automaton", "automaton",
    
    "Servant", "servant", "Minion", "minion",
    "Slave", "slave", "Pawn", "pawn",
    
    "AI", "ai", "A.I.",
    "Char", "char", "Character", "character",
    "Model", "model",
    
    "Event", "event", "Special", "special",
    "Holiday", "holiday", "Seasonal", "seasonal",
}

--// npcs debug
local function DebugNPCDetection(character, reason)
    if not _G.DebugNPCs then return end
end

local function IsPlayer(character)
    if not character or not character:IsA("Model") then
        return false
    end
    if character == LocalPlayer.Character then
        return true
    end
    local player = Players:GetPlayerFromCharacter(character)
    return player ~= nil
end

-- Is npc? function
local function IsNPC(character)
    if not character or not character:IsA("Model") then
        return false
    end
    
    -- Ignore if is player
    if IsPlayer(character) then
        return false
    end
    
    -- basics 
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not head or not hrp or humanoid.Health <= 0 then
        return false
    end
    
    -- detects any humanoid model as npc
    if _G.AggressiveNPCDetection then
        DebugNPCDetection(character, "Npc")
        return true
    end
    
    local charName = character.Name:lower()
    
    -- verify tags
    for _, tag in pairs(NPCTags) do
        if charName:find(tag:lower(), 1, true) then
            DebugNPCDetection(character, "Tag: " .. tag)
            return true
        end
    end
    
    local npcFolders = {
        "NPCs", "Enemies", "Bots", "Mobs", "Targets", "Enemy", "Hostile",
        "Monsters", "Zombies", "Creatures", "Characters", "Spawns",
        "EnemySpawns", "NPCSpawns", "Bosses", "Minions"
    }
    
    for _, folderName in pairs(npcFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder and character:IsDescendantOf(folder) then
            DebugNPCDetection(character, "Na pasta: " .. folderName)
            return true
        end
    end
    
    -- verify for values and customs ig
    local possibleNPCIndicators = {
        "NPC", "IsNPC", "IsEnemy", "Hostile", "Enemy", 
        "IsBot", "IsMob", "IsMonster", "Team", "Faction"
    }
    
    for _, indicator in pairs(possibleNPCIndicators) do
        local value = character:FindFirstChild(indicator)
        if value then
            if value:IsA("BoolValue") then
                if indicator == "NPC" or indicator == "IsNPC" or 
                   indicator == "IsEnemy" or indicator == "Hostile" then
                    if value.Value == true then
                        DebugNPCDetection(character, "BoolValue: " .. indicator .. " = true")
                        return true
                    end
                end
            elseif value:IsA("StringValue") then
                local valLower = value.Value:lower()
                if valLower == "enemy" or valLower == "hostile" or 
                   valLower == "npc" or valLower == "bot" or
                   valLower == "monster" or valLower == "mob" then
                    DebugNPCDetection(character, "StringValue: " .. indicator .. " = " .. value.Value)
                    return true
                end
            elseif value:IsA("IntValue") then
                if indicator == "Team" then
                    DebugNPCDetection(character, "Team Value: " .. value.Value)
                    return true
                end
            end
        end
    end
    
    local hasAIBehavior = false
    for _, child in pairs(character:GetChildren()) do
        local childName = child.Name:lower()
        if child:IsA("Script") or child:IsA("LocalScript") then
            if childName:find("ai") or childName:find("behavior") or 
               childName:find("path") or childName:find("attack") or
               childName:find("patrol") or childName:find("combat") then
                hasAIBehavior = true
                break
            end
        end
    end
    
    -- verify conection service tags ig
    local tags = CollectionService:GetTags(character)
    for _, tag in pairs(tags) do
        local tagLower = tag:lower()
        for _, npcTag in pairs(NPCTags) do
            if tagLower:find(npcTag:lower(), 1, true) then
                DebugNPCDetection(character, "CollectionService Tag: " .. tag)
                return true
            end
        end
    end
    
    local npcAbilities = {"Attack", "Damage", "Aggro", "Patrol", "Spawn", "Respawn", "AI", "BehaviorTree"}
    for _, ability in pairs(npcAbilities) do
        if character:FindFirstChild(ability) or character:FindFirstChild(ability .. "Script") then
            hasAIBehavior = true
            break
        end
    end
    
    if hasAIBehavior then
        DebugNPCDetection(character, "AI Behaviour detected")
        return true
    end
    
    -- verify for prefix
    local namePatterns = {"^npc_", "^enemy_", "^bot_", "^mob_", "_npc$", "_enemy$", "_bot$"}
    for _, pattern in pairs(namePatterns) do
        if string.match(charName, pattern) then
            DebugNPCDetection(character, "Name: " .. pattern)
            return true
        end
    end
    
    DebugNPCDetection(character, "Npc")
    return true
end

--// search for npcs everywhere ig
local function FindNPCsInWorkspaceRecursive(parent)
    local foundNPCs = {}
    
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("Model") then
            if IsNPC(child) then
                table.insert(foundNPCs, child)
            end
        end
        
        -- search npc thing too 
        if not child:IsA("BasePart") and not child:IsA("Decal") and not child:IsA("Texture") then
            local subNPCs = FindNPCsInWorkspaceRecursive(child)
            for _, npc in pairs(subNPCs) do
                table.insert(foundNPCs, npc)
            end
        end
    end
    
    return foundNPCs
end


local function IsEnemyPlayer(player)
    if not _G.TeamCheck then
        return true
    end
    
    if not player then
        return false
    end
    
    if not LocalPlayer.Team or not player.Team then
        return true
    end
    
    return LocalPlayer.Team ~= player.Team
end

--// verify team npc
local function IsEnemyNPC(npcModel)
    if not _G.TeamCheckForNPCs then
        return true
    end
    
    -- verify if npc has a team
    local npcTeamValue = npcModel:FindFirstChild("Team")
    if npcTeamValue and npcTeamValue:IsA("StringValue") then
        local npcTeam = npcTeamValue.Value
        local localTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""
        
        if npcTeam and localTeam and npcTeam ~= localTeam then
            return true
        end
    end
    
    -- Verify for enemy boolvalue
    local isEnemy = npcModel:FindFirstChild("IsEnemy")
    if isEnemy and isEnemy:IsA("BoolValue") and isEnemy.Value == true then
        return true
    end
    
    return true
end

--// Hit part selection
local function GetTargetPart(character)
    if _G.AimPart == "Head" then
        return character:FindFirstChild("Head")
    elseif _G.AimPart == "Torso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif _G.AimPart == "Random" then
        local parts = {
            character:FindFirstChild("Head"),
            character:FindFirstChild("UpperTorso"),
            character:FindFirstChild("Torso"),
            character:FindFirstChild("HumanoidRootPart")
        }
        for _, part in pairs(parts) do
            if part then return part end
        end
    elseif _G.AimPart == "Both" then
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
        if head and torso then
            return tick() % 1 > 0.5 and head or torso
        elseif head then
            return head
        elseif torso then
            return torso
        end
    end
    
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
end

--// update cache function optimized
local function UpdateCaches()
    local currentTime = tick()
    
    if currentTime - LastCacheUpdate < CacheUpdateInterval then
        return
    end
    
    LastCacheUpdate = currentTime
    
    local tempNPCCache = {}
    local tempPlayerCache = {}
    local allModels = {}
    
    local wsChildren = workspace:GetChildren()
    for _, model in pairs(wsChildren) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            table.insert(allModels, model)
        end
    end
    
    local npcFolders = {"NPCs", "Enemies", "Bots", "Mobs", "Targets", 
                        "Characters", "Spawns", "Monsters", "Zombies",
                        "Enemy", "Hostile", "Bosses", "Minions", "Creatures"}
    
    for _, folderName in pairs(npcFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            local npcsInFolder = FindNPCsInWorkspaceRecursive(folder)
            for _, npc in pairs(npcsInFolder) do
                table.insert(allModels, npc)
            end
        end
    end
    

    if _G.AggressiveNPCDetection then
        local counter = 0
        local descendants = workspace:GetDescendants() -- Get anythin
        
        for _, descendant in pairs(descendants) do
            -- Filter models
            if descendant:IsA("Model") and descendant ~= LocalPlayer.Character then
                table.insert(allModels, descendant)
                
                counter = counter + 1
                if counter % 150 == 0 then
                    task.wait() 
                end
            end
        end
    end
    
    local processCounter = 0
    for _, model in pairs(allModels) do
        processCounter = processCounter + 1
        if processCounter % 200 == 0 then task.wait() end

        local hrp = model:FindFirstChild("HumanoidRootPart")
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        
        if hrp and humanoid and humanoid.Health > 0 then
            if IsPlayer(model) then
                tempPlayerCache[model] = {
                    Model = model,
                    HRP = hrp,
                    Humanoid = humanoid,
                    Player = Players:GetPlayerFromCharacter(model),
                    IsNPC = false
                }
            elseif IsNPC(model) then
                tempNPCCache[model] = {
                    Model = model,
                    HRP = hrp,
                    Humanoid = humanoid,
                    IsNPC = true
                }
            end
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                tempPlayerCache[char] = {
                    Model = char,
                    HRP = hrp,
                    Humanoid = humanoid,
                    Player = player,
                    IsNPC = false
                }
            end
        end
    end
    
    NPCCache = tempNPCCache
    PlayerCache = tempPlayerCache
end

local function ValidateCurrentTarget()
    if not CurrentTarget or not TargetPart then return false end
    
    local humanoid = CurrentTarget:FindFirstChildOfClass("Humanoid")
    local hrp = CurrentTarget:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or humanoid.Health <= 0 or not hrp then return false end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local targetPos = TargetPart.Position
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    
    if not onScreen then return false end
    
    local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
    local dist = (screenPoint - screenCenter).Magnitude
    
    if dist > _G.FOV then return false end
    
    -- wallcheck
    if _G.VisibleCheck then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true
        
        local origin = Camera.CFrame.Position
        local direction = (targetPos - origin).Unit * (targetPos - origin).Magnitude
        local ray = workspace:Raycast(origin, direction, raycastParams)
        
        if ray then
            local hitPart = ray.Instance
            if not hitPart:IsDescendantOf(CurrentTarget) then
                return false
            end
        end
    end
    
    return true
end

local function GetTarget()
    if not LocalPlayer.Character then 
        TargetInRange = false
        TargetPart = nil
        return nil 
    end
    
    UpdateCaches()
    
    if _G.StickyAim and CurrentTarget then
        if ValidateCurrentTarget() then
            TargetInRange = true
            return CurrentTarget
        else
            CurrentTarget = nil
            TargetPart = nil
        end
    end
    
    local bestScore = math.huge 
    local closestPart = nil
    local closestTarget = nil
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local localChar = LocalPlayer.Character
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    
    TargetInRange = false
    TargetPart = nil
    
    if not localRoot then return nil end
    
    local function ProcessTarget(data, isPlayer)
        local hrp = data.HRP
        local humanoid = data.Humanoid
        
        if hrp and humanoid and humanoid.Health > 0 then
            -- teamcheck
            if isPlayer then
                if not IsEnemyPlayer(data.Player) then return end
            else
                if not IsEnemyNPC(data.Model) then return end
            end
            
            -- hitpart
            local targetPart = GetTargetPart(data.Model)
            if not targetPart then targetPart = hrp end
            
            local targetPos = targetPart.Position
            
            if hrp.Velocity.Magnitude > 1 and _G.Prediction > 0 then
                targetPos = targetPos + (hrp.Velocity * _G.Prediction)
            end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            
            if onScreen then
                local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                local distFromCenter = (screenPoint - screenCenter).Magnitude
                
                
                if distFromCenter <= _G.FOV then
                    local isVisible = true
                    
                    -- WALL CHECK
                    if _G.VisibleCheck then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {localChar, Camera}
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.IgnoreWater = true
                        
                        local origin = Camera.CFrame.Position
                        local direction = (targetPos - origin).Unit * (targetPos - origin).Magnitude
                        local ray = workspace:Raycast(origin, direction, raycastParams)
                        
                        if ray then
                            local hitPart = ray.Instance
                            local isTargetPart = hitPart:IsDescendantOf(data.Model)
                            if not isTargetPart then isVisible = false end
                        end
                    end
                    
                    TargetInRange = true
                    
                    -- priority logic
                    if isVisible or not _G.VisibleCheck then
                        local currentScore = 0
                        
                        if _G.TargetPriority == "Crosshair" then
                            -- Prioridade padrão: Distância da mira
                            currentScore = distFromCenter
                        elseif _G.TargetPriority == "Distance" then
                            -- Nova Prioridade: Distância 3D (perto do player)
                            currentScore = (targetPos - localRoot.Position).Magnitude
                        elseif _G.TargetPriority == "LowestHP" then
                            -- Nova Prioridade: Menor Vida
                            currentScore = humanoid.Health
                        else
                            currentScore = distFromCenter
                        end
                        
                        if currentScore < bestScore then
                            bestScore = currentScore
                            closestPart = targetPart
                            closestTarget = data.Model
                        end
                    end
                end
            end
        end
    end
    
    if _G.TargetMode == "NPCs" or _G.TargetMode == "Both" then
        for _, data in pairs(NPCCache) do ProcessTarget(data, false) end
    end
    
    if _G.TargetMode == "Players" or _G.TargetMode == "Both" then
        for _, data in pairs(PlayerCache) do ProcessTarget(data, true) end
    end
    
    TargetPart = closestPart
    return closestTarget
end

--// update target
task.spawn(function()
    while true do
        task.wait(_G.UpdateRate)
        if _G.SilentAim or _G.AimbotNPC then
            CurrentTarget = GetTarget()
        else
            CurrentTarget = nil
            TargetInRange = false
            TargetPart = nil
        end
    end
end)

--// hit chance
local function ShouldHit()
    if _G.HitChance >= 100 then
        return true
    end
    if _G.HitChance <= 0 then
        return false
    end
    local randomNumber = math.random(1, 100)
    return randomNumber <= _G.HitChance
end

-- hitchance display
local function CalculateHitChanceDisplay()
    if not CurrentTarget or not TargetPart then
        return 0
    end
    local baseChance = _G.HitChance
    local distanceFactor = 1.0
    local fovFactor = 1.0
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local localPos = LocalPlayer.Character.HumanoidRootPart.Position
        local targetPos = TargetPart.Position
        local distance = (targetPos - localPos).Magnitude
        
        if distance < 50 then distanceFactor = 1.1 
        elseif distance > 200 then distanceFactor = 0.8 end
    end
    
    if _G.FOV < 100 then fovFactor = 1.15 elseif _G.FOV > 250 then fovFactor = 0.9 end
    local finalChance = baseChance * distanceFactor * fovFactor
    local randomVariation = math.random(-5, 5)
    finalChance = math.clamp(finalChance + randomVariation, 1, 100)
    
    return math.floor(finalChance)
end

--// target
local function UpdateTargetInfo()
    if not _G.ShowTarget or not TargetInfo then
        TargetInfo.Visible = false
        TargetInfo.Text = "" 
        return
    end
    
    if not (_G.SilentAim or _G.AimbotNPC) then
        TargetInfo.Visible = false
        TargetInfo.Text = "" 
        return
    end
    
    local shouldShowHitChance = _G.ShowHitChance and _G.HitChance > 0
    
    if CurrentTarget and TargetPart then
        local screenPos, onScreen = Camera:WorldToViewportPoint(TargetPart.Position)
        
        if onScreen then
            TargetInfo.Visible = true
            TargetInfo.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
            
            local infoLines = {}
            
            if _G.ShowTargetName then
                local targetName = CurrentTarget.Name
                local targetType = "NPC"
                for _, data in pairs(PlayerCache) do
                    if data.Model == CurrentTarget then
                        targetType = "Player"
                        targetName = data.Player.Name
                        break
                    end
                end
                
                if _G.ShowTargetType then
                    table.insert(infoLines, string.format("[%s] %s", targetType, targetName))
                else
                    table.insert(infoLines, targetName)
                end
            end
            
            if _G.ShowTargetHP then
                local humanoid = CurrentTarget:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local health = string.format("%.0f", humanoid.Health)
                    local maxHealth = string.format("%.0f", humanoid.MaxHealth)
                    table.insert(infoLines, string.format("HP: %s/%s", health, maxHealth))
                end
            end
            
            if _G.ShowTargetDistance then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local localPos = LocalPlayer.Character.HumanoidRootPart.Position
                    local targetPos = TargetPart.Position
                    local distance = string.format("%.1f", (targetPos - localPos).Magnitude)
                    table.insert(infoLines, string.format("Dist: %s studs", distance))
                end
            end
            
            if shouldShowHitChance then
                local displayChance = CalculateHitChanceDisplay()
                table.insert(infoLines, string.format("Chance: %d%%", displayChance))
            end
            
            if #infoLines > 0 then
                TargetInfo.Text = table.concat(infoLines, "\n")
            else
                TargetInfo.Text = "nigger detected"
            end
        else
            TargetInfo.Visible = false
            TargetInfo.Text = ""
        end
    else
        TargetInfo.Visible = false
        TargetInfo.Text = "" 
    end
end

--// bullet tp
local function TeleportBulletToTargetImproved(origin, direction, bulletName)
    if not _G.BulletTeleport or not TargetPart or not CurrentTarget then
        return origin, direction
end
    
    local bulletNames = {"bullet", "ammo", "shot", "projectile", "missile", "rocket", "hit", "damage", "fire", "shoot"}
    local isBullet = false
    
    for _, name in pairs(bulletNames) do
        if string.find(bulletName:lower(), name) then
            isBullet = true
            break
        end
    end
    
    if not isBullet then return origin, direction end
    if not ShouldHit() then return origin, direction end
    
    local targetPosition = TargetPart.Position
    
    if _G.Prediction > 0 and TargetPart.Parent:FindFirstChild("HumanoidRootPart") then
        local hrp = TargetPart.Parent:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Velocity.Magnitude > 1 then
            targetPosition = targetPosition + (hrp.Velocity * _G.Prediction)
        end
    end
    
    local randomOffset = Vector3.new(
        (math.random() - 0.5) * 0.5,
        (math.random() - 0.5) * 0.3,
        (math.random() - 0.5) * 0.5
    )
    
    targetPosition = targetPosition + randomOffset
    local newDirection = (targetPosition - origin).Unit * direction.Magnitude
    
    return origin, newDirection
end

--// HOOKS
if not oldNamecall then
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not _G.SilentAim or not TargetPart or not CurrentTarget then
            return oldNamecall(self, ...)
        end
        
        local method = getnamecallmethod()
        local args = {...}
        
        -- bullet tp
        if _G.BulletTeleport and (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
            local selfName = self.Name:lower()
        end
        
        -- HIT REDIRECTION
        if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
            local selfName = self.Name:lower()
            if string.find(selfName, "fire") or string.find(selfName, "hit") or string.find(selfName, "attack") or string.find(selfName, "damage") then
                if not ShouldHit() then
                    return oldNamecall(self, ...)
                end
                
                local newArgs = {}
                local modified = false
                
                for i, arg in pairs(args) do
                    if typeof(arg) == "Vector3" then
                        newArgs[i] = TargetPart.Position
                        modified = true
                    elseif typeof(arg) == "CFrame" then
                        newArgs[i] = CFrame.new(TargetPart.Position)
                        modified = true
                    elseif typeof(arg) == "Ray" then
                        local origin = arg.Origin
                        newArgs[i] = Ray.new(origin, (TargetPart.Position - origin).Unit * 100)
                        modified = true
                    else
                        newArgs[i] = arg
                    end
                end
        
                if modified then
                    return oldNamecall(self, unpack(newArgs))
                end
            end
        end
        
        if method == "Raycast" and self == workspace then
            local origin = args[1]
            local direction = args[2]
            
            if origin and TargetPart then
                if not ShouldHit() then
                    return oldNamecall(self, ...)
                end
                
                local newDir = (TargetPart.Position - origin).Unit * direction.Magnitude
                return oldNamecall(self, origin, newDir, args[3], args[4])
            end
        end
        
        return oldNamecall(self, ...)
    end)
end

if not oldIndex then
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if self == Mouse and _G.SilentAim and TargetPart then
            local keyLower = string.lower(key)
            if keyLower == "hit" then
                if not ShouldHit() then
                    return oldIndex(self, key)
                end
                return CFrame.new(TargetPart.Position)
            elseif keyLower == "target" then
                return TargetPart
            end
        end
        return oldIndex(self, key)
    end)
end

-- update loop visuals
RunService.RenderStepped:Connect(function()
    Circle.Visible = _G.SilentAim or _G.AimbotNPC
    
    if _G.SilentAim or _G.AimbotNPC then
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        Circle.Position = screenCenter
        Circle.Radius = _G.FOV
        
        -- fov color
        Circle.Color = _G.FOVColor or Color3.fromRGB(255, 255, 255)
    else
        Circle.Visible = false
    end
    
    UpdateTargetInfo()
    UpdateHighlight()

    -- aimbot
    if _G.AimbotNPC then
        CurrentTarget = GetTarget()
    end

    if _G.AimbotNPC and CurrentTarget and TargetPart then
        if _G.TargetMode == "NPCs" or not IsPlayer(CurrentTarget) then
            local camPos = Camera.CFrame.Position
            local targetPos = TargetPart.Position

            -- prediction
            if _G.Prediction > 0 then
                local vel = (typeof(TargetPart.Velocity) == "Vector3") and TargetPart.Velocity or nil
                local hrp = CurrentTarget:FindFirstChild("HumanoidRootPart")
                if (not vel or vel.Magnitude < 0.01) and hrp then
                    vel = (typeof(hrp.Velocity) == "Vector3") and hrp.Velocity or nil
                end
                if vel and vel.Magnitude > 0.01 then
                    targetPos = targetPos + (vel * _G.Prediction)
                end
            end

            local desired = CFrame.new(camPos, targetPos)
            Camera.CFrame = desired
        end
    end

    -- ESP npc
    UpdateNPCESP()
end)


local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/qxkzx/NpcDetection/refs/heads/main/Ui-Open-Source"
))()

local Window = Library:CreateWindow({
    Title = "Client.cc",
    Author = "6qxs",
    Keybind = Enum.KeyCode.RightControl
})

--// Tabs
local TabMain = Window:CreateTab("SilentAim")
local TabAimbotNPC = Window:CreateTab("Aimbot")
local TabNPC = Window:CreateTab("Npc detection")
local TabESP = Window:CreateTab("Esp (npc)")
local TabTarget = Window:CreateTab("Target")
local TabAim = Window:CreateTab("Fov color")
local TabTeam = Window:CreateTab("Team")
local TabInfo = Window:CreateTab("target info")
local TabExtra = Window:CreateTab("Extra")

--// Main tab
TabMain:CreateLabel("Main")
TabMain:CreateToggle("Silent Aim", function(Value)
    _G.SilentAim = Value
    if Value then
        LastCacheUpdate = 0; UpdateCaches()
        Library:Notification({Title = "SILENT AIM", Text = "On", Duration = 1.5, Type = "Success"})
    else
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
        Library:Notification({Title = "SILENT AIM", Text = "Off", Duration = 1.5, Type = "Error"})
    end
end, false)

TabMain:CreateSlider("FOV", 50, 300, 150, function(Value) _G.FOV = math.floor(Value); Circle.Radius = _G.FOV end)
TabMain:CreateSlider("Prediction", 0, 0.5, 0.165, function(Value) _G.Prediction = tonumber(string.format("%.3f", Value)) end)
TabMain:CreateSlider("Hit Chance", 0, 100, 100, function(Value) _G.HitChance = math.floor(Value) end)
TabMain:CreateSlider("update rate", 0.05, 0.5, 0.1, function(Value) _G.UpdateRate = tonumber(string.format("%.2f", Value)) end)

TabMain:CreateLabel("")
TabMain:CreateLabel("Configurations")
TabTarget:CreateDropdown("Mode", {"NPCs", "Both"}, function(Value) _G.TargetMode = Value end)
TabMain:CreateDropdown("Hit part", {"Head", "Torso", "Both", "Random"}, function(Value) _G.AimPart = Value; CurrentTarget = nil end)
TabMain:CreateToggle("Wall Check", function(Value) _G.VisibleCheck = Value end, true)
TabMain:CreateToggle("Bullet Teleport", function(Value) _G.BulletTeleport = Value end, false)
TabTarget:CreateToggle("Show Target", function(Value) _G.ShowTarget = Value end, true)


TabMain:CreateDropdown("priority mode", {"Crosshair", "Distance", "LowestHP"}, function(Value)
    _G.TargetPriority = Value
    CurrentTarget = nil -- Resetar alvo ao mudar
    Library:Notification({Title = "Mode changed", Text = "Prioridade: " .. Value, Duration = 2})
end)

TabMain:CreateToggle("Sticky Aim", function(Value)
    _G.StickyAim = Value
end, true)

TabMain:CreateLabel("Crosshair")
TabMain:CreateLabel("Distance")
TabMain:CreateLabel("LowestHP")
TabMain:CreateLabel("Sticky Aim")

--// aim
TabAim:CreateColorPicker("Fov color", Color3.fromRGB(255, 255, 255), function(Color) _G.FOVColor = Color; Circle.Color = Color end)

--// team
TabTeam:CreateLabel("Teamcheck")
TabTeam:CreateToggle("Team Check - Players", function(Value) _G.TeamCheck = Value end, true)
TabTeam:CreateToggle("Team Check - NPCs", function(Value) _G.TeamCheckForNPCs = Value end, false)

--// extra
TabExtra:CreateLabel("Extra")
TabExtra:CreateToggle("Highlight", function(Value) _G.HighlightTarget = Value end, false)
TabExtra:CreateColorPicker("Highlight NPC", Color3.fromRGB(255, 255, 255), function(Color) end)
TabExtra:CreateColorPicker("Highlight Player", Color3.fromRGB(50, 150, 255), function(Color) end)
TabExtra:CreateTextBox("Cache Interval (s)", "2", function(Text) local num = tonumber(Text); if num and num > 0 then CacheUpdateInterval = num end end)

--// npc
TabNPC:CreateLabel("Npc")
TabNPC:CreateToggle("Npc Detection", function(Value)
    _G.AggressiveNPCDetection = Value
    LastCacheUpdate = 0; UpdateCaches()

end, false)
TabNPC:CreateToggle("Debug NPCs", function(Value) _G.DebugNPCs = Value end, false)
TabNPC:CreateButton("Force cache update", function() LastCacheUpdate = 0; UpdateCaches() end)
TabNPC:CreateButton("detected npcs list", function()
    local npcCount = 0; for _ in pairs(NPCCache) do npcCount = npcCount + 1 end
    Library:Notification({Title = "detection", Text = string.format("NPCs: %d", npcCount), Duration = 2})
end)

--// ESP NPC TAB
TabESP:CreateLabel("ESP NPCs")
TabESP:CreateToggle("Enable ESP", function(Value)
    _G.NPC_ESP_Enabled = Value
    if not Value then
        -- Esconder imediatamente quando desligar
        for _, esp in pairs(NPCESPObjects) do
            if esp.Label then esp.Label.Visible = false end
            if esp.SkeletonLines then
                for _, line in ipairs(esp.SkeletonLines) do
                    line.Visible = false
                end
            end
        end
    end
end, false)

TabESP:CreateToggle("Skeleton ESP", function(Value)
    _G.NPC_ESP_Skeleton = Value
end, true)

TabESP:CreateToggle("Name ESP", function(Value)
    _G.NPC_ESP_Name = Value
end, true)

TabESP:CreateToggle("Distance ESP", function(Value)
    _G.NPC_ESP_Distance = Value
end, true)

TabESP:CreateColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(Color)
    _G.NPC_ESP_Color = Color
end)

--// Aimbot
TabAimbotNPC:CreateLabel("")
TabAimbotNPC:CreateToggle("Aimbot", function(Value)
    _G.AimbotNPC = Value
    if Value then
        _G.TargetMode = "NPCs"
        _G.AimPart = "Head"
        LastCacheUpdate = 0
        UpdateCaches()
        Library:Notification({Title = "Aimbot", Text = "On", Duration = 1.5, Type = "Success"})
    else
        if TargetHighlight then TargetHighlight:Destroy(); TargetHighlight = nil end
        Library:Notification({Title = "Aimbot", Text = "Off", Duration = 1.5, Type = "Error"})
    end
end, false)

TabAimbotNPC:CreateSlider("FOV", 50, 350, 150, function(Value)
    _G.FOV = math.floor(Value)
    Circle.Radius = _G.FOV
end)

TabAimbotNPC:CreateSlider("Prediction", 0, 0.6, 0.165, function(Value)
    _G.Prediction = tonumber(string.format("%.3f", Value))
end)

TabAimbotNPC:CreateDropdown("Hit part", {"Head", "Torso", "Both", "Random"}, function(Value)
    _G.AimPart = Value
    CurrentTarget = nil
end)

TabAimbotNPC:CreateDropdown("Priority", {"Crosshair", "Distance", "LowestHP"}, function(Value)
    _G.TargetPriority = Value
    CurrentTarget = nil
    Library:Notification({Title = "Prioridade", Text = Value, Duration = 1.5})
end)

TabAimbotNPC:CreateLabel("")
TabAimbotNPC:CreateSlider("Hit Chance %", 0, 100, 100, function(Value)
    _G.HitChance = math.floor(Value)
end)

TabAimbotNPC:CreateSlider("Update rate", 0.05, 0.5, 0.1, function(Value)
    _G.UpdateRate = tonumber(string.format("%.2f", Value))
end)

TabAimbotNPC:CreateLabel("")
TabAimbotNPC:CreateToggle("Sticky Aim", function(Value) _G.StickyAim = Value end, true)
TabAimbotNPC:CreateToggle("Wall Check", function(Value) _G.VisibleCheck = Value end, true)
TabAimbotNPC:CreateToggle("Bullet Teleport", function(Value) _G.BulletTeleport = Value end, false)

TabAimbotNPC:CreateLabel("")
TabAimbotNPC:CreateButton("Force npcs mode", function()
    _G.TargetMode = "NPCs"
    CurrentTarget = nil
    Library:Notification({Title = "Modo", Text = "Alvo: apenas NPCs", Duration = 2})
end)

--// info
TabInfo:CreateLabel("Infos")
TabInfo:CreateToggle("Name", function(Value) _G.ShowTargetName = Value; if _G.SilentAim then UpdateTargetInfo() end end, true)
TabInfo:CreateToggle("HP", function(Value) _G.ShowTargetHP = Value; if _G.SilentAim then UpdateTargetInfo() end end, true)
TabInfo:CreateToggle("Distance", function(Value) _G.ShowTargetDistance = Value; if _G.SilentAim then UpdateTargetInfo() end end, true)
TabInfo:CreateToggle("Hit Chance", function(Value) _G.ShowHitChance = Value; if _G.SilentAim then UpdateTargetInfo() end end, true)
TabInfo:CreateLabel("")
TabInfo:CreateLabel("")
TabInfo:CreateButton("Cleanup ui", function() CleanupUIOnly() end)

Library:Notification({
    Title = "Client.cc",
    Text = "by $",
    Duration = 4,
    Type = "Loaded"
})

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then CleanupUIOnly() end
end)
