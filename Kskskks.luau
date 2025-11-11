--== Universal Hub GUI Tự Tạo Hoàn Chỉnh ==--

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- GUI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Khung menu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Nút kéo
local DragButton = Instance.new("TextButton")
DragButton.Size = UDim2.new(1, 0, 0, 30)
DragButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
DragButton.Text = "Universal Hub - Drag me"
DragButton.TextColor3 = Color3.new(1,1,1)
DragButton.Parent = MainFrame

-- Container cho scroll
local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0,5)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Parent = MainFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0,35)
UIPadding.Parent = MainFrame

-- Bật/Tắt menu
local toggleKey = Enum.KeyCode.RightControl
local guiVisible = true
uis.InputBegan:Connect(function(input)
    if input.KeyCode == toggleKey then
        guiVisible = not guiVisible
        MainFrame.Visible = guiVisible
    end
end)

--== Kéo thả GUI ==
local dragging = false
local dragInput, mousePos, framePos

DragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

--== Hàm tạo Toggle Button ==
local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = name.." ❌"
    btn.Parent = MainFrame

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name.." "..(state and "✅" or "❌")
        callback(state)
    end)
end

--== Tính năng thật sự ==--

-- Fly
local flyEnabled = false
local flySpeed = 50
CreateToggle("Fly", function(state)
    flyEnabled = state
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    if state then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp

        spawn(function()
            while flyEnabled do
                wait()
                local cam = workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if dir.Magnitude > 0 then
                    bv.Velocity = dir.Unit * flySpeed
                else
                    bv.Velocity = Vector3.new(0,0,0)
                end
            end
            bv:Destroy()
        end)
    end
end)

-- Infinite Jump
CreateToggle("Infinite Jump", function(state)
    local conn
    if state then
        conn = uis.JumpRequest:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if conn then conn:Disconnect() end
    end
end)

-- Speed
local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(1, -10, 0, 30)
speedSlider.PlaceholderText = "WalkSpeed (16 default)"
speedSlider.Text = ""
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedSlider.Parent = MainFrame
speedSlider.FocusLost:Connect(function(enter)
    local val = tonumber(speedSlider.Text)
    if val then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end
end)

-- Teleport to Player
local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.new(1, -10, 0, 30)
tpBox.PlaceholderText = "Teleport to PlayerName"
tpBox.Text = ""
tpBox.TextColor3 = Color3.new(1,1,1)
tpBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
tpBox.Parent = MainFrame
tpBox.FocusLost:Connect(function(enter)
    local target = game.Players:FindFirstChild(tpBox.Text)
    local char = player.Character
    if target and char and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end)

-- God Mode / Bất tử
CreateToggle("God Mode", function(state)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.MaxHealth = math.huge
            char.Humanoid.Health = math.huge
        else
            char.Humanoid.MaxHealth = 100
            char.Humanoid.Health = 100
        end
    end
end)

-- Anti AFK
CreateToggle("Anti AFK", function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
end)

print("✅ Universal Hub hoàn chỉnh loaded! Toggle GUI with RightControl")
