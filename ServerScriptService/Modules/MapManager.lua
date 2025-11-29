--[[
	MapManager.lua - Gestion des cartes
	Contrôle le chargement, la sélection et la gestion des cartes
]]

local MapManager = {}

-- Liste des cartes disponibles
MapManager.AvailableMaps = {}
MapManager.CurrentMap = nil

-- Initialiser les cartes
function MapManager:Init()
	print("🗺️  [MapManager] Initialisation des cartes...")
	self:LoadMaps()
end

-- Charger les cartes
function MapManager:LoadMaps()
	local mapsFolder = game.ServerStorage:FindFirstChild("Maps")
	if mapsFolder then
		for _, map in pairs(mapsFolder:GetChildren()) do
			table.insert(self.AvailableMaps, map)
		end
		print("🗺️  [MapManager] " .. #self.AvailableMaps .. " cartes chargées")
	end
end

-- Sélectionner une carte aléatoire
function MapManager:SelectRandomMap()
	if #self.AvailableMaps > 0 then
		self.CurrentMap = self.AvailableMaps[math.random(1, #self.AvailableMaps)]
		print("🗺️  [MapManager] Carte sélectionnée: " .. self.CurrentMap.Name)
		return self.CurrentMap
	end
end

-- Activer une carte
function MapManager:LoadMap(map)
	self.CurrentMap = map
	if self.CurrentMap then
		self.CurrentMap:SetAttribute("Active", true)
	end
end

-- Décharger la carte actuelle
function MapManager:UnloadMap()
	if self.CurrentMap then
		self.CurrentMap:SetAttribute("Active", false)
		self.CurrentMap = nil
	end
end

return MapManager
