--[[
	GameManager.lua - Script Principal du Serveur
	Gère la boucle principale du jeu, les états de jeu et la logique générale
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local GameManager = {}
GameManager.IsRunning = false
GameManager.GameState = "Waiting" -- Waiting, Playing, Ended

-- Imports des modules
local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)
local MapManager = require(game.ServerScriptService.Modules.MapManager)
local GameConfig = require(game.ServerScriptService.Config.GameConfig)

-- Initialiser le jeu
function GameManager:Init()
	print("🎮 [GameManager] Initialisation du jeu...")
	self.IsRunning = true
	self:StartGameLoop()
end

-- Boucle principale du jeu
function GameManager:StartGameLoop()
	while self.IsRunning do
		if self.GameState == "Waiting" then
			self:WaitForPlayers()
		elseif self.GameState == "Playing" then
			self:UpdateGameState()
		elseif self.GameState == "Ended" then
			self:EndGame()
		end
		task.wait(GameConfig.GameTickRate or 0.1)
	end
end

-- Attendre les joueurs
function GameManager:WaitForPlayers()
	if #Players:GetPlayers() >= GameConfig.MinPlayers then
		self.GameState = "Playing"
		print("🎮 [GameManager] Le jeu commence!")
	end
end

-- Mettre à jour l'état du jeu
function GameManager:UpdateGameState()
	-- Logique de mise à jour générale
	for _, player in pairs(Players:GetPlayers()) do
		PlayerManager:UpdatePlayer(player)
	end
end

-- Terminer le jeu
function GameManager:EndGame()
	print("🎮 [GameManager] Jeu terminé!")
	self.GameState = "Waiting"
	task.wait(GameConfig.RestartDelay or 5)
end

-- Événement: joueur rejoint
Players.PlayerAdded:Connect(function(player)
	print("👤 [GameManager] " .. player.Name .. " a rejoint!")
	PlayerManager:SetupPlayer(player)
end)

-- Événement: joueur part
Players.PlayerRemoving:Connect(function(player)
	print("👤 [GameManager] " .. player.Name .. " a quitté!")
	PlayerManager:CleanupPlayer(player)
end)

-- Démarrer le jeu
GameManager:Init()

return GameManager
