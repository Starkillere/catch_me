--[[
	GameConfig.lua - Configuration centrale du jeu
	Tous les paramètres du jeu sont centralisés ici
]]

local GameConfig = {
	-- Configuration générale
	GameName = "Catch Me!",
	GameVersion = "1.0.0",
	
	-- Paramètres de jeu
	MinPlayers = 2,
	MaxPlayers = 16,
	GameTickRate = 0.1, -- Mise à jour par 0.1 secondes
	GameDuration = 300, -- 5 minutes
	RestartDelay = 5,
	
	-- Configuration des joueurs
	PlayerStartHealth = 100,
	PlayerMovementSpeed = 50,
	PlayerStartCharm = 3,
	ActionTimeLimit = 20, -- secondes pour choisir une action par tour

	-- Configuration de l'attrapeur
	CatcherDuration = 30,
	CatcherSpeed = 60,
	CatchRadius = 5,
	
	-- Récompenses
	CatchReward = 10,
	SurvivalReward = 5,
	
	-- Spawn points
	SpawnLocations = {
		Vector3.new(0, 5, 0),
		Vector3.new(10, 5, 0),
		Vector3.new(-10, 5, 0),
		Vector3.new(0, 5, 10),
		Vector3.new(0, 5, -10),
	}
}

return GameConfig
