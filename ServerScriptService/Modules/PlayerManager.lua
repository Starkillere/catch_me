--[[
	PlayerManager.lua - Gestion des joueurs
	Contrôle la création, la modification et la suppression des joueurs
]]

local Players = game:GetService("Players")
local PlayerManager = {}

-- Données des joueurs
PlayerManager.Players = {}

-- Configuration du joueur au spawn
function PlayerManager:SetupPlayer(player)
	self.Players[player.UserId] = {
		UserId = player.UserId,
		Name = player.Name,
		Character = nil,
		Stats = {
			Score = 0,
			Health = 100,
			IsCatcher = false
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
	humanoid.Health = 100
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

-- Donner des points
function PlayerManager:AddScore(player, points)
	if self.Players[player.UserId] then
		self.Players[player.UserId].Stats.Score += points
	end
end

-- Définir l'attrapeur
function PlayerManager:SetCatcher(player)
	for _, playerData in pairs(self.Players) do
		playerData.Stats.IsCatcher = false
	end
	if self.Players[player.UserId] then
		self.Players[player.UserId].Stats.IsCatcher = true
		print("🎯 [PlayerManager] " .. player.Name .. " est maintenant l'attrapeur!")
	end
end

return PlayerManager
