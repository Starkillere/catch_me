-- InitReplicatedStorage.lua
-- Crée les RemoteEvents nécessaires si absents

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureEvent(name, class)
	local obj = ReplicatedStorage:FindFirstChild(name)
	if not obj then
		if class == "RemoteEvent" then
			obj = Instance.new("RemoteEvent")
		elseif class == "RemoteFunction" then
			obj = Instance.new("RemoteFunction")
		else
			obj = Instance.new("RemoteEvent")
		end
		obj.Name = name
		obj.Parent = ReplicatedStorage
	end
	return obj
end

-- Events utilisés pour la communication
ensureEvent("RequestAction", "RemoteEvent") -- serveur -> client pour demander l'action
ensureEvent("ActionChosen", "RemoteEvent") -- client -> serveur pour envoyer l'action choisie
ensureEvent("UpdateState", "RemoteEvent") -- serveur -> client pour mettre à jour l'UI/état

print("🔁 [InitReplicatedStorage] RemoteEvents prêts")
