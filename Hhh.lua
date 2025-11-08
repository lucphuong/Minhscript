local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "🌙 Linh Tinh Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "LinhTinhHub"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

OrionLib:MakeNotification({
	Name = "Linh Tinh Hub",
	Content = "Đã tải thành công!",
	Image = "rbxassetid://4483345998",
	Time = 5
})

local infjumpEnabled = false
MainTab:AddToggle({
	Name = "🦘 Infinite Jump",
	Default = false,
	Callback = function(Value)
		infjumpEnabled = Value
	end    
})

game:GetService("UserInputService").JumpRequest:Connect(function()
	if infjumpEnabled then
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

local flying = false
local flySpeed = 60
MainTab:AddToggle({
	Name = "✈️ Fly (G để bật/tắt)",
	Default = false,
	Callback = function(Value)
		flying = Value
		local plr = game.Players.LocalPlayer
		local char = plr.Character or plr.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")

		if flying then
			local root = char:WaitForChild("HumanoidRootPart")
			local bv = Instance.new("BodyVelocity", root)
			bv.Name = "FlyVelocity"
			bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			bv.Velocity = Vector3.zero

			game:GetService("RunService").Heartbeat:Connect(function()
				if flying and root and bv then
					local dir = Vector3.zero
					local cam = workspace.CurrentCamera
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
						dir += cam.CFrame.LookVector
					end
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
						dir -= cam.CFrame.LookVector
					end
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
						dir -= cam.CFrame.RightVector
					end
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
						dir += cam.CFrame.RightVector
					end
					bv.Velocity = dir * flySpeed
				elseif not flying then
					if bv then bv:Destroy() end
				end
			end)
		else
			local bv = char:FindFirstChild("FlyVelocity")
			if bv then bv:Destroy() end
		end
	end
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.G then
		flying = not flying
		OrionLib:MakeNotification({
			Name = "Fly",
			Content = flying and "🕊️ Đã bật bay" or "🛬 Đã tắt bay",
			Time = 2
		})
	end
end)

local speed = 16
MainTab:AddSlider({
	Name = "🏃‍♂️ Speed",
	Min = 16,
	Max = 100,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		speed = Value
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
	end    
})

MainTab:AddDropdown({
	Name = "📍 Teleport tới người chơi",
	Default = "Chọn người chơi",
	Options = {},
	Callback = function(selected)
		local plr = game.Players:FindFirstChild(selected)
		if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			game.Players.LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
		end
	end
})

task.spawn(function()
	while task.wait(3) do
		local names = {}
		for _, v in pairs(game.Players:GetPlayers()) do
			table.insert(names, v.Name)
		end
		MainTab:UpdateDropdown("📍 Teleport tới người chơi", names)
	end
end)

MainTab:AddToggle({
	Name = "🖱️ Click TP",
	Default = false,
	Callback = function(v)
		getgenv().ClickTP = v
	end
})

local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

UIS.InputBegan:Connect(function(input)
	if getgenv().ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Mouse.Target then
			Player.Character:MoveTo(Mouse.Hit.p)
		end
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Toggleui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Toggle.BackgroundTransparency = 0.5
Toggle.Position = UDim2.new(0, 0, 0.454, 0)
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.2, 0)
Corner.Parent = Toggle

local Image = Instance.new("ImageLabel")
Image.Name = "Icon"
Image.Parent = Toggle
Image.Size = UDim2.new(1, 0, 1, 0)
Image.BackgroundTransparency = 1
Image.Image = "rbxassetid://117239677500065"

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0.2, 0)
Corner2.Parent = Image

Toggle.MouseButton1Click:Connect(function()
  OrionLib:ToggleUi()
end)

OrionLib:Init()
