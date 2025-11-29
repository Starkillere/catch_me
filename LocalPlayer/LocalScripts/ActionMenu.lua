-- ActionMenu.lua
-- Crée une petite interface pour choisir l'action du tour

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RequestAction = ReplicatedStorage:WaitForChild("RequestAction")
local ActionChosen = ReplicatedStorage:WaitForChild("ActionChosen")
local UpdateState = ReplicatedStorage:WaitForChild("UpdateState")

-- Création UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ActionMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 120)
frame.Position = UDim2.new(0, 10, 1, -140)
frame.BackgroundTransparency = 0.4
frame.Parent = screenGui

local function makeButton(name, y)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = UDim2.new(0, 240, 0, 30)
	b.Position = UDim2.new(0, 10, 0, y)
	b.Text = name
	b.Parent = frame
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local seduceBtn = makeButton("Seduce", 10)
local sabotageBtn = makeButton("Sabotage", 50)
local restBtn = makeButton("Rest", 90)

local function chooseSabotageTarget()
	local list = Players:GetPlayers()
	local choices = {}
	for _, p in ipairs(list) do
		if p.UserId ~= player.UserId then table.insert(choices, p) end
	end
	if #choices == 0 then return nil end
	-- pour l'instant choisir le premier valide (on pourrait afficher un menu)
	return choices[1].UserId
end

-- Envoi d'action
seduceBtn.MouseButton1Click:Connect(function()
	ActionChosen:FireServer({type = "Seduce"})
end)

sabotageBtn.MouseButton1Click:Connect(function()
	local targetId = chooseSabotageTarget()
	if targetId then
		ActionChosen:FireServer({type = "Sabotage", targetUserId = targetId})
	end
end)

restBtn.MouseButton1Click:Connect(function()
	ActionChosen:FireServer({type = "Rest"})
end)

-- Quand le serveur demande l'action, on peut par ex. afficher la frame (optionnel)
RequestAction.OnClientEvent:Connect(function(data)
	frame.Visible = true
	-- on pourrait afficher un timer basé sur data.timeLimit
	-- si le joueur ne choisit rien avant la fin, le serveur appliquera timeout
end)

-- Mettre à jour HUD via l'event UpdateState
UpdateState.OnClientEvent:Connect(function(snapshot)
	-- snapshot est une table userId -> {Name, Charm, Health}
	-- si on veut afficher localement la valeur du joueur
	local myData = snapshot[player.UserId]
	if myData then
		-- Mettre à jour le HUD existant si présent
		local mainHud = playerGui:FindFirstChild("MainHUD")
		if mainHud then
			local scoreLabel = mainHud:FindFirstChild("ScoreLabel")
			local healthLabel = mainHud:FindFirstChild("HealthLabel")
			if scoreLabel then scoreLabel.Text = "Charme: " .. tostring(myData.Charm) end
			if healthLabel then healthLabel.Text = "Health: " .. tostring(myData.Health) end
		end
	end
end)

-- cacher par défaut
frame.Visible = false
