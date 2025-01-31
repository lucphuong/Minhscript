-- MinhxHub - Blox Fruits Auto Farm + Dragon Tribe Quest

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local workspace = game:GetService("Workspace")
local ui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local startButton = Instance.new("TextButton")
local stopButton = Instance.new("TextButton")
local dragonQuestButton = Instance.new("TextButton")
local farmActive = false

-- Create UI elements
ui.Name = "MinhxHub"
ui.Parent = player.PlayerGui

mainFrame.Name = "MainFrame"
mainFrame.Parent = ui
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2

startButton.Name = "StartButton"
startButton.Parent = mainFrame
startButton.Size = UDim2.new(0, 230, 0, 40)
startButton.Position = UDim2.new(0, 10, 0, 10)
startButton.Text = "Start Auto Farm"
startButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)

stopButton.Name = "StopButton"
stopButton.Parent = mainFrame
stopButton.Size = UDim2.new(0, 230, 0, 40)
stopButton.Position = UDim2.new(0, 10, 0, 55)
stopButton.Text = "Stop Auto Farm"
stopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)

dragonQuestButton.Name = "DragonQuestButton"
dragonQuestButton.Parent = mainFrame
dragonQuestButton.Size = UDim2.new(0, 230, 0, 40)
dragonQuestButton.Position = UDim2.new(0, 10, 0, 100)
dragonQuestButton.Text = "Start Dragon Tribe Quest"
dragonQuestButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
dragonQuestButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Function to find the closest enemy
function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge
    for _, enemy in pairs(workspace:FindPartsInRegion3(character.HumanoidRootPart.Position - Vector3.new(50, 50, 50), character.HumanoidRootPart.Position + Vector3.new(50, 50, 50), nil)) do
        if enemy.Parent and enemy.Parent:FindFirstChild("Humanoid") and enemy.Parent.Humanoid.Health > 0 then
            local distance = (enemy.Parent.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestEnemy = enemy.Parent
                shortestDistance = distance
            end
        end
    end
    return closestEnemy
end

-- Function to attack the enemy
function attackEnemy(enemy)
    if enemy and enemy:FindFirstChild("Humanoid") then
        -- Simulate an attack
        print("Attacking", enemy.Name)
    end
end

-- Auto-Farm loop
local function startAutoFarm()
    farmActive = true
    while farmActive do
        wait(1)
        local closestEnemy = getClosestEnemy()
        if closestEnemy then
            attackEnemy(closestEnemy)
        end
    end
end

-- Stop Auto-Farm
local function stopAutoFarm()
    farmActive = false
end

-- Auto start farm when the script runs
startAutoFarm()  -- Automatically starts farming

-- Function to start Dragon Tribe quest
function startDragonTribeQuest()
    print("Starting Dragon Tribe Quest...")

    -- Find the Dragon Tribe NPC (example)
    local npc = workspace:FindFirstChild("DragonTribeNPC") -- Thay tên NPC đúng trong game
    if npc and npc:FindFirstChild("Humanoid") then
        -- Di chuyển đến NPC
        character:MoveTo(npc.HumanoidRootPart.Position)
        wait(2)

        -- Giả lập tương tác với NPC
        print("Talking to Dragon Tribe NPC...")
        
        -- Giả lập làm nhiệm vụ (ví dụ: đánh bại quái vật)
        while farmActive do
            local closestEnemy = getClosestEnemy()
            if closestEnemy then
                attackEnemy(closestEnemy)
            end
            wait(1)
        end

        print("Dragon Tribe Quest Completed!")
    else
        print("Dragon Tribe NPC not found!")
    end
end

-- Connect buttons
startButton.MouseButton1Click:Connect(function()
    startAutoFarm()
    startButton.Text = "Farm Running..."
    startButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
end)

stopButton.MouseButton1Click:Connect(function()
    stopAutoFarm()
    startButton.Text = "Start Auto Farm"
    startButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
end)

dragonQuestButton.MouseButton1Click:Connect(function()
    startDragonTribeQuest()
end)
