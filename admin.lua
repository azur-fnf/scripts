-- ADMIN HUB AUTO GUI (Refatorado & Melhorado)
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local event = game.ReplicatedStorage:WaitForChild("AdminEvent")

-- ================= CONFIGURAÇÕES DE CORES =================
local COLORS = {
	Background = Color3.fromRGB(20, 20, 20),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(70, 70, 70),
	Hover = Color3.fromRGB(90, 90, 90),
	Text = Color3.fromRGB(255, 255, 255),
	Placeholder = Color3.fromRGB(150, 150, 150)
}

-- ================= CRIAÇÃO DA GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "AdminHubPro"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 400)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -200)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "ADMIN HUB V2"
title.Font = Enum.Font.GothamBold
title.TextColor3 = COLORS.Text
title.TextSize = 16
title.Parent = mainFrame

-- SELEÇÃO DE JOGADOR (TextBox)
local targetBox = Instance.new("TextBox")
targetBox.Name = "TargetBox"
targetBox.Size = UDim2.new(1, -20, 0, 35)
targetBox.Position = UDim2.new(0, 10, 0, 40)
targetBox.BackgroundColor3 = COLORS.Secondary
targetBox.TextColor3 = COLORS.Text
targetBox.PlaceholderText = "Nome do Jogador..."
targetBox.PlaceholderColor3 = COLORS.Placeholder
targetBox.Font = Enum.Font.Gotham
targetBox.TextSize = 14
targetBox.Text = ""
targetBox.ClearTextOnFocus = false
targetBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner", targetBox)
boxCorner.CornerRadius = UDim.new(0, 6)

-- Container dos Botões
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -95)
container.Position = UDim2.new(0, 10, 0, 85)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.ScrollBarThickness = 2
container.Parent = mainFrame

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= FUNÇÃO CRIAR BOTÃO =================
local function createButton(text, icon)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = COLORS.Secondary
	btn.TextColor3 = COLORS.Text
	btn.Text = "  " .. icon .. " " .. text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = container

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Hover}):Play()
	end)
	btn.MouseLeave:Connect(function()
		tweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Secondary}):Play()
	end)
	
	return btn
end

-- ================= ELEMENTOS =================
local speedBtn   = createButton("Speed", "⚡")
local flyBtn     = createButton("Fly [OFF]", "🕊")
local gravBtn    = createButton("Gravity [OFF]", "🌌")
local blockBtn   = createButton("Spawn Block Tool", "🧱")
local deleteBtn  = createButton("Delete Tool", "🗑️")
local killBtn    = createButton("Kill Target", "☠")
local explodeBtn = createButton("Explode Target", "💥")

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- ================= SISTEMA DE ARRASTAR =================
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	tweenService:Create(mainFrame, TweenInfo.new(0.1), {Position = newPos}):Play()
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

userInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- ================= MINIMIZAR (LEFT CONTROL) =================
local visible = true
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
		visible = not visible
		if visible then
			mainFrame.Visible = true
			mainFrame:TweenSize(UDim2.new(0, 260, 0, 400), "Out", "Back", 0.3, true)
		else
			mainFrame:TweenSize(UDim2.new(0, 260, 0, 0), "In", "Quad", 0.2, true, function()
				if not visible then mainFrame.Visible = false end
			end)
		end
	end
end)

-- ================= AUXILIARES =================
local function getTarget()
	local text = targetBox.Text:lower()
	if text == "" then return nil end
	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Name:lower():sub(1, #text) == text then
			return v
		end
	end
	return nil
end

-- ================= FUNCIONALIDADES =================
local fly = false
local gravity = false

speedBtn.MouseButton1Click:Connect(function()
	event:FireServer("Speed", 100)
end)

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	event:FireServer("Fly", fly)
	flyBtn.Text = fly and "  🕊 Fly [ON]" or "  🕊 Fly [OFF]"
end)

gravBtn.MouseButton1Click:Connect(function()
	gravity = not gravity
	event:FireServer("Gravity", gravity)
	gravBtn.Text = gravity and "  🌌 Gravity [ON]" or "  🌌 Gravity [OFF]"
end)

blockBtn.MouseButton1Click:Connect(function()
	local tool = Instance.new("Tool")
	tool.Name = "SpawnBlockTool"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		event:FireServer("Block", 12)
	end)
	tool.Parent = player.Backpack
end)

deleteBtn.MouseButton1Click:Connect(function()
	local tool = Instance.new("Tool")
	tool.Name = "DeleteTool"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		local mouse = player:GetMouse()
		local target = mouse.Target
		if target then
			-- Envia o comando para o servidor deletar o objeto alvo
			event:FireServer("DeletePart", target)
		end
	end)
	tool.Parent = player.Backpack
end)

killBtn.MouseButton1Click:Connect(function()
	local target = getTarget()
	if target then event:FireServer("Kill", target.Name) end
end)

explodeBtn.MouseButton1Click:Connect(function()
	local target = getTarget()
	if target then event:FireServer("Explode", target.Name) end
end)
