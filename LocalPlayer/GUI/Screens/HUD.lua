--[[
	HUD.lua - Interface utilisateur principal (Heads-Up Display)
	Affiche les informations en temps réel du joueur
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local HUD = {}

-- Créer le HUD
function HUD:Init()
	print("🖥️  [HUD] Création du HUD...")
	
	-- Créer la ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MainHUD"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- Créer le label de score
	local scoreLabel = Instance.new("TextLabel")
	scoreLabel.Name = "ScoreLabel"
	scoreLabel.Size = UDim2.new(0, 200, 0, 50)
	scoreLabel.Position = UDim2.new(0, 10, 0, 10)
	scoreLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	scoreLabel.BackgroundTransparency = 0.5
	scoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	scoreLabel.TextSize = 24
	scoreLabel.Font = Enum.Font.GothamBold
	scoreLabel.Text = "Score: 0"
	scoreLabel.Parent = screenGui
	
	-- Créer le label de santé
	local healthLabel = Instance.new("TextLabel")
	healthLabel.Name = "HealthLabel"
	healthLabel.Size = UDim2.new(0, 200, 0, 50)
	healthLabel.Position = UDim2.new(0, 10, 0, 70)
	healthLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	healthLabel.BackgroundTransparency = 0.5
	healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	healthLabel.TextSize = 24
	healthLabel.Font = Enum.Font.GothamBold
	healthLabel.Text = "Health: 100"
	healthLabel.Parent = screenGui
	
	-- Créer le label d'état
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(0, 300, 0, 50)
	statusLabel.Position = UDim2.new(0.5, -150, 0, 10)
	statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statusLabel.BackgroundTransparency = 0.5
	statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	statusLabel.TextSize = 24
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.Text = "Status: En attente..."
	statusLabel.Parent = screenGui
	
	self.ScreenGui = screenGui
	self.ScoreLabel = scoreLabel
	self.HealthLabel = healthLabel
	self.StatusLabel = statusLabel
end

-- Mettre à jour le score
function HUD:UpdateScore(score)
	self.ScoreLabel.Text = "Score: " .. score
end

-- Mettre à jour la santé
function HUD:UpdateHealth(health)
	self.HealthLabel.Text = "Health: " .. math.floor(health)
end

-- Mettre à jour le statut
function HUD:UpdateStatus(status)
	self.StatusLabel.Text = "Status: " .. status
end

HUD:Init()

return HUD
