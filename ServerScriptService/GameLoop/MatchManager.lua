-- MatchManager.lua
-- Gère le tour par tour du mini-jeu de séduction

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PlayerManager = require(game.ServerScriptService.Modules.PlayerManager)
local GameConfig = require(game.ServerScriptService.Config.GameConfig)

local RequestAction = ReplicatedStorage:WaitForChild("RequestAction")
local ActionChosen = ReplicatedStorage:WaitForChild("ActionChosen")
local UpdateState = ReplicatedStorage:WaitForChild("UpdateState")

local MatchManager = {}
MatchManager.GameState = "Waiting"
MatchManager.ActivePlayers = {}
MatchManager.Actions = {} -- map UserId -> action table

local function broadcastState()
	local snapshot = {}
	for userId, data in pairs(PlayerManager.Players) do
		snapshot[userId] = {
			Name = data.Name,
			Charm = data.Stats.Charm,
			Health = data.Stats.Health
		}
	end
	UpdateState:FireAllClients(snapshot)
end

local function isPlayerActive(userId)
	local p = PlayerManager.Players[userId]
	if not p then return false end
	return p.Stats.Charm > 0
end

local function checkVictory()
	-- victoire par reach charm
	for userId, data in pairs(PlayerManager.Players) do
		if data.Stats.Charm >= 15 then
			return userId
		end
	end
	-- victoire par élimination (un seul actif)
	local alive = {}
	for userId, data in pairs(PlayerManager.Players) do
		if data.Stats.Charm > 0 then table.insert(alive, userId) end
	end
	if #alive == 1 then return alive[1] end
	return nil
end

-- Résoudre les actions collectées
local function resolveActions()
	-- Résoudre d'abord les sabotages (affectent les cibles avant séduction)
	for userId, action in pairs(MatchManager.Actions) do
		if action.type == "Sabotage" then
			local targetId = action.targetUserId
			if PlayerManager.Players[targetId] and PlayerManager.Players[targetId].Stats.Charm > 0 then
				local roll = math.random(1,6)
				local points = 0
				if roll <= 2 then points = -2 -- rumeurs
				elseif roll <= 4 then points = -3 -- voler un cadeau
				else points = -4 -- interrompre
				end
				PlayerManager:AddCharm({UserId = targetId}, points)
				print("🗡️  [Sabotage] ".. (PlayerManager.Players[userId] and PlayerManager.Players[userId].Name or "?") .." a saboté " .. (PlayerManager.Players[targetId] and PlayerManager.Players[targetId].Name or "?") .. " ("..points..")")
			end
		end
	end
	-- Puis résoudre les séductions
	for userId, action in pairs(MatchManager.Actions) do
		if action.type == "Seduce" then
			if PlayerManager.Players[userId] and PlayerManager.Players[userId].Stats.Charm > 0 then
				local roll = math.random(1,6)
				local points = 0
				if roll <= 2 then points = 2 -- poeme
				elseif roll <= 4 then points = 3 -- danse
				else points = 4 -- cadeau
				end
				PlayerManager:AddCharm({UserId = userId}, points)
				print("💘 [Seduce] ".. PlayerManager.Players[userId].Name .." séduit (roll="..roll..") => "..points)
			end
		end
		if action.type == "Rest" then
			if PlayerManager.Players[userId] and PlayerManager.Players[userId].Stats.Charm > 0 then
				PlayerManager:AddCharm({UserId = userId}, 2)
				print("💤 [Rest] ".. PlayerManager.Players[userId].Name .." récupère 2 points de charme")
			end
		end
	end
end

-- Nettoyer actions
local function clearActions()
	MatchManager.Actions = {}
end

-- Attendre actions des joueurs ou timeout
local function collectActions(activeUserIds)
	clearActions()
	local deadline = tick() + (GameConfig.ActionTimeLimit or 20)
	while tick() < deadline do
		local allReceived = true
		for _, uid in ipairs(activeUserIds) do
			if isPlayerActive(uid) then
				if not MatchManager.Actions[uid] then allReceived = false break end
			end
		end
		if allReceived then break end
		task.wait(0.25)
	end
end

-- Handler pour ActionChosen
ActionChosen.OnServerEvent:Connect(function(player, action)
	-- valider
	local userId = player.UserId
	if not PlayerManager.Players[userId] then return end
	if PlayerManager.Players[userId].Stats.Charm <= 0 then return end -- éliminé
	if type(action) ~= "table" or not action.type then return end
	if action.type == "Sabotage" then
		if not action.targetUserId then return end
	end
	MatchManager.Actions[userId] = action
	print("📨 [MatchManager] Action reçue de "..player.Name..": "..action.type)
end)

-- Lancer un match
function MatchManager:Start()
	self.GameState = "Playing"
	print("🏁 [MatchManager] Le match commence")
	-- initialiser joueurs actifs (max 6)
	local allPlayers = Players:GetPlayers()
	if #allPlayers == 0 then
		print("Pas de joueurs")
		return
	end
	-- limiter à 6 joueurs (les premiers qui rejoignent)
	for i = 1, math.min(6, #allPlayers) do
		local p = allPlayers[i]
		PlayerManager:SetupPlayer(p)
	end

	broadcastState()

	-- boucle principale des tours
	while self.GameState == "Playing" do
		-- construire la liste des participants actifs
		local active = {}
		for userId, data in pairs(PlayerManager.Players) do
			if data.Stats.Charm > 0 then table.insert(active, userId) end
		end
		if #active == 0 then
			print("Tous éliminés")
			break
		end

		-- demander l'action à chaque client actif
		for _, uid in ipairs(active) do
			local pl = Players:GetPlayerByUserId(uid)
			if pl then
				RequestAction:FireClient(pl, {timeLimit = GameConfig.ActionTimeLimit or 20})
			end
		end

		-- collecter les actions
		collectActions(active)

		-- résoudre les actions
		resolveActions()

		-- état et vérification de victoire
		broadcastState()
		local winnerId = checkVictory()
		if winnerId then
			print("🏆 [MatchManager] Victoire de ".. (PlayerManager.Players[winnerId] and PlayerManager.Players[winnerId].Name or winnerId))
			self.GameState = "Ended"
			break
		end

		-- attendre prochain tour court
		task.wait(1)
	end

	-- fin de partie
	if self.GameState == "Ended" then
		broadcastState()
	end
end

return MatchManager
