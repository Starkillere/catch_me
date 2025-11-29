--[[
	Signals.lua - Système de signaux/événements personnalisés
	Permet la communication entre scripts via des signaux
]]

local Signal = {}
Signal.__index = Signal

-- Créer un nouveau signal
function Signal.new()
	local self = setmetatable({}, Signal)
	self._bindable = Instance.new("BindableEvent")
	return self
end

-- Connecter une fonction au signal
function Signal:Connect(callback)
	return self._bindable.Event:Connect(callback)
end

-- Déclencher le signal
function Signal:Fire(...)
	self._bindable:Fire(...)
end

-- Attendre le signal
function Signal:Wait()
	return self._bindable.Event:Wait()
end

return Signal
