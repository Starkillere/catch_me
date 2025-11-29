--[[
	Tween.lua - Utilitaire pour les animations fluides
	Permet de créer des animations tweens facilement
]]

local TweenService = game:GetService("TweenService")
local Tween = {}

-- Créer un tween
function Tween:Create(instance, duration, targetProperties)
	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.InOut
	)
	
	local tween = TweenService:Create(instance, tweenInfo, targetProperties)
	return tween
end

-- Créer un tween avec style personnalisé
function Tween:CreateCustom(instance, duration, targetProperties, easingStyle, easingDirection)
	local tweenInfo = TweenInfo.new(
		duration,
		easingStyle or Enum.EasingStyle.Quad,
		easingDirection or Enum.EasingDirection.InOut
	)
	
	local tween = TweenService:Create(instance, tweenInfo, targetProperties)
	return tween
end

return Tween
