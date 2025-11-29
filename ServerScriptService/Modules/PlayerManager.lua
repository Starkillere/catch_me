--[[
	PlayerManager.lua - Gestion des joueurs
	Contrôle la création, la modification et la suppression des joueurs
]]

local Players = game:GetService("Players")
local PlayerManager = {}

-- Données des joueurs
PlayerManager.Players = {}

local GameConfig = require(game.ServerScriptService.Config.GameConfig)

-- Configuration du joueur au spawn
function PlayerManager:SetupPlayer(player)
	self.Players[player.UserId] = {
		UserId = player.UserId,
		Name = player.Name,
		Character = nil,
		Stats = {
			Charm = GameConfig.PlayerStartCharm or 3,
			Health = GameConfig.PlayerStartHealth or 100,
			IsPrincess = false
		}
	}
    
	-- Attendre le spawn du personnage
	if player.Character then
		self:OnCharacterSpawned(player, player.Character)
	end
    
	player.CharacterAdded:Connect(function(character)
		self:OnCharacterSpawned(player, character)
	end)
end

-- Événement: personnage spawn
function PlayerManager:OnCharacterSpawned(player, character)
	print("✨ [PlayerManager] " .. player.Name .. " a spawn!")
	self.Players[player.UserId].Character = character
    
	-- Ajouter le humanoid et configurer la santé
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Health = GameConfig.PlayerStartHealth or 100
end

-- Mettre à jour le joueur
function PlayerManager:UpdatePlayer(player)
	local playerData = self.Players[player.UserId]
	if playerData and playerData.Character then
		local humanoid = playerData.Character:FindFirstChild("Humanoid")
		if humanoid then
			playerData.Stats.Health = humanoid.Health
		end
	end
end

-- Nettoyer le joueur
function PlayerManager:CleanupPlayer(player)
	self.Players[player.UserId] = nil
	print("🗑️  [PlayerManager] Données de " .. player.Name .. " supprimées")
end

-- Modifier les points de charme (peut être négatif)
function PlayerManager:AddCharm(player, points)
	if self.Players[player.UserId] then
		local s = self.Players[player.UserId].Stats
		s.Charm = s.Charm + points
		if s.Charm < 0 then s.Charm = 0 end
	end
end

-- Lire les données d'un joueur
function PlayerManager:GetPlayerData(player)
	return self.Players[player.UserId]
end

return PlayerManager
