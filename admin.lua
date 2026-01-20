-- CLIENT SIDE
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local event = ReplicatedStorage:WaitForChild("AdminRemotes"):WaitForChild("CommandEvent")

local THEME = {
	Background = Color3.fromRGB(13, 13, 15),
	Secondary = Color3.fromRGB(20, 20, 25),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	Error = Color3.fromRGB(255, 80, 80),
	Success = Color3.fromRGB(80, 255, 120)
}

local spawnDistance = 10
local isVisible = true

-- GUI Base
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AdminHub_Premium_V2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.fromOffset(450, 350)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = THEME.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = THEME.Accent
stroke.Thickness = 1.8
stroke.Transparency = 0.6

-- TopBar Drag
local top = Instance.new("Frame", main)
top.Name = "TopBar"
top.Size = UDim2.new(1, 0, 0, 55)
top.BackgroundColor3 = THEME.Secondary
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.fromOffset(20, 0)
title.Text = "ADMIN <font color='#00AAFF'>HUB</font> • PREMIUM"
title.TextColor3 = THEME.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.RichText = true

-- Drag
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	TweenService:Create(main, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

top.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- Toggle com LeftControl
UIS.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
		isVisible = not isVisible
		local targetSize = isVisible and UDim2.fromOffset(450, 350) or UDim2.fromOffset(450, 55)
		TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
		stroke.Enabled = isVisible
	end
end)

-- Login
local keyFrame = Instance.new("Frame", main)
keyFrame.Size = UDim2.new(1, 0, 1, -55)
keyFrame.Position = UDim2.fromOffset(0, 55)
keyFrame.BackgroundTransparency = 1

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.fromOffset(300, 45)
keyBox.Position = UDim2.fromScale(0.5, 0.4)
keyBox.AnchorPoint = Vector2.new(0.5, 0.5)
keyBox.BackgroundColor3 = THEME.Secondary
keyBox.PlaceholderText = "Digite sua Key..."
keyBox.TextColor3 = THEME.Text
keyBox.Font = Enum.Font.GothamMedium
keyBox.TextSize = 16
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)

local submit = Instance.new("TextButton", keyFrame)
submit.Size = UDim2.fromOffset(300, 42)
submit.Position = UDim2.fromScale(0.5, 0.58)
submit.AnchorPoint = Vector2.new(0.5, 0.5)
submit.BackgroundColor3 = THEME.Accent
submit.Text = "ENTRAR NO SISTEMA"
submit.TextColor3 = THEME.Background
submit.Font = Enum.Font.GothamBold
submit.TextSize = 14
submit.AutoButtonColor = false
Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 8)

-- Hub
local hub = Instance.new("ScrollingFrame", main)
hub.Size = UDim2.new(1, -40, 1, -75)
hub.Position = UDim2.fromOffset(20, 65)
hub.BackgroundTransparency = 1
hub.Visible = false
hub.ScrollBarThickness = 2
hub.CanvasSize = UDim2.new(0, 0, 0, 800)

local targetBox = Instance.new("TextBox", hub)
targetBox.Size = UDim2.new(1, 0, 0, 40)
targetBox.Position = UDim2.fromOffset(0, 5)
targetBox.BackgroundColor3 = THEME.Secondary
targetBox.PlaceholderText = "Nome do Jogador"
targetBox.TextColor3 = THEME.Text
targetBox.Font = Enum.Font.Gotham
targetBox.TextSize = 14
Instance.new("UICorner", targetBox).CornerRadius = UDim.new(0, 6)

-- Distância
local distFrame = Instance.new("Frame", hub)
distFrame.Size = UDim2.new(1, 0, 0, 40)
distFrame.Position = UDim2.fromOffset(0, 50)
distFrame.BackgroundTransparency = 1

local distLabel = Instance.new("TextLabel", distFrame)
distLabel.Size = UDim2.new(0.6, 0, 1, 0)
distLabel.BackgroundTransparency = 1
distLabel.Text = "Distância do Spawn: 10"
distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
distLabel.Font = Enum.Font.GothamMedium
distLabel.TextSize = 13
distLabel.TextXAlignment = Enum.TextXAlignment.Left

local distInput = Instance.new("TextBox", distFrame)
distInput.Size = UDim2.new(0.35, 0, 0.8, 0)
distInput.Position = UDim2.fromScale(1, 0.5)
distInput.AnchorPoint = Vector2.new(1, 0.5)
distInput.BackgroundColor3 = THEME.Secondary
distInput.Text = "10"
distInput.TextColor3 = THEME.Accent
distInput.Font = Enum.Font.GothamBold
distInput.TextSize = 14
Instance.new("UICorner", distInput).CornerRadius = UDim.new(0, 4)

distInput:GetPropertyChangedSignal("Text"):Connect(function()
	local val = tonumber(distInput.Text)
	if val then
		spawnDistance = val
		distLabel.Text = "Distância do Spawn: " .. val
	end
end)

-- Botão Helper
local function makeButton(text, y, color)
	local b = Instance.new("TextButton", hub)
	b.Size = UDim2.new(1, 0, 0, 45)
	b.Position = UDim2.fromOffset(0, y)
	b.BackgroundColor3 = THEME.Secondary
	b.Text = text:upper()
	b.TextColor3 = THEME.Text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.AutoButtonColor = false

	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	local bStroke = Instance.new("UIStroke", b)
	bStroke.Color = color or THEME.Accent
	bStroke.Thickness = 1
	bStroke.Transparency = 0.7
	bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
		TweenService:Create(bStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Secondary}):Play()
		TweenService:Create(bStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
	end)

	return b
end

-- Botões
local explode = makeButton("Explodir Alvo", 100, THEME.Error)
local gotoP = makeButton("Teleportar até Alvo", 155)
local spawnToolBtn = makeButton("Ferramenta de Spawn", 210, Color3.fromRGB(80, 200, 255))
local deleteToolBtn = makeButton("Ferramenta de Deletar", 265, Color3.fromRGB(200, 200, 200))
local flyBtn = makeButton("Fly", 320, Color3.fromRGB(255, 200, 0))
local noclipBtn = makeButton("Noclip", 375, Color3.fromRGB(255, 200, 0))
local bringBtn = makeButton("Trazer Jogador", 430, Color3.fromRGB(120, 255, 120))
local healBtn = makeButton("Curar", 485, Color3.fromRGB(120, 255, 120))
local killBtn = makeButton("Matar", 540, Color3.fromRGB(255, 80, 80))
local speedBtn = makeButton("Speed", 595, Color3.fromRGB(120, 255, 120))
local freezeBtn = makeButton("Congelar", 650, Color3.fromRGB(255, 200, 0))
local unfreezeBtn = makeButton("Descongelar", 705, Color3.fromRGB(120, 255, 120))

-- Auth
submit.MouseButton1Click:Connect(function()
	event:FireServer("auth", {key = keyBox.Text})
end)

event.OnClientEvent:Connect(function(response, data)
	if response == "auth_success" then
		submit.Text = "ACESSO CONCEDIDO"
		submit.BackgroundColor3 = THEME.Success
		task.wait(0.6)
		keyFrame.Visible = false
		hub.Visible = true
	elseif response == "auth_fail" then
		keyBox.Text = ""
		keyBox.PlaceholderText = "KEY INVÁLIDA"
		local originalPos = keyBox.Position
		for i = 1, 6 do
			keyBox.Position = originalPos + UDim2.fromOffset(math.random(-5,5), 0)
			task.wait(0.05)
		end
		keyBox.Position = originalPos
	end
end)

-- Comandos
explode.MouseButton1Click:Connect(function()
	event:FireServer("explode", {target = targetBox.Text})
end)

gotoP.MouseButton1Click:Connect(function()
	event:FireServer("goto", {target = targetBox.Text})
end)

flyBtn.MouseButton1Click:Connect(function()
	event:FireServer("fly", {})
end)

noclipBtn.MouseButton1Click:Connect(function()
	event:FireServer("noclip", {})
end)

bringBtn.MouseButton1Click:Connect(function()
	event:FireServer("bring", {target = targetBox.Text})
end)

healBtn.MouseButton1Click:Connect(function()
	event:FireServer("heal", {target = targetBox.Text})
end)

killBtn.MouseButton1Click:Connect(function()
	event:FireServer("kill", {target = targetBox.Text})
end)

speedBtn.MouseButton1Click:Connect(function()
	event:FireServer("speed", {target = targetBox.Text, speed = 50})
end)

freezeBtn.MouseButton1Click:Connect(function()
	event:FireServer("freeze", {target = targetBox.Text})
end)

unfreezeBtn.MouseButton1Click:Connect(function()
	event:FireServer("unfreeze", {target = targetBox.Text})
end)

-- Spawn Tool
spawnToolBtn.MouseButton1Click:Connect(function()
	if player.Backpack:FindFirstChild("Spawnar Bloco") or (player.Character and player.Character:FindFirstChild("Spawnar Bloco")) then
		return 
	end

	local spawnTool = Instance.new("Tool")
	spawnTool.Name = "Spawnar Bloco"
	spawnTool.RequiresHandle = false
	spawnTool.Parent = player.Backpack

	spawnTool.Activated:Connect(function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local spawnPos = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -spawnDistance)
			event:FireServer("spawnblock", {pos = spawnPos.Position})
		end
	end)
end)

-- Delete Tool
deleteToolBtn.MouseButton1Click:Connect(function()
	if player.Backpack:FindFirstChild("Deletar Objeto") or (player.Character and player.Character:FindFirstChild("Deletar Objeto")) then
		return 
	end

	local deleteTool = Instance.new("Tool")
	deleteTool.Name = "Deletar Objeto"
	deleteTool.RequiresHandle = false
	deleteTool.Parent = player.Backpack

	deleteTool.Activated:Connect(function()
		local target = mouse.Target
		if target and target:IsA("BasePart") then
			event:FireServer("deleteblock", {part = target})
		end
	end)
end)
