--[[
	PlayerController.lua - Contrôleur du joueur côté client
	Gère les entrées du joueur et le mouvement
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local PlayerController = {}

-- État de contrôle
local KeysPressed = {}

-- Détecter les touches enfoncées
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.W then KeysPressed.W = true end
	if input.KeyCode == Enum.KeyCode.A then KeysPressed.A = true end
	if input.KeyCode == Enum.KeyCode.S then KeysPressed.S = true end
	if input.KeyCode == Enum.KeyCode.D then KeysPressed.D = true end
end)

-- Détecter les touches relâchées
UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.W then KeysPressed.W = false end
	if input.KeyCode == Enum.KeyCode.A then KeysPressed.A = false end
	if input.KeyCode == Enum.KeyCode.S then KeysPressed.S = false end
	if input.KeyCode == Enum.KeyCode.D then KeysPressed.D = false end
end)

-- Boucle de mouvement
RunService.RenderStepped:Connect(function()
	if humanoid.Health <= 0 then return end
	
	local moveDirection = Vector3.new(0, 0, 0)
	
	if KeysPressed.W then moveDirection = moveDirection + (humanoidRootPart.CFrame.LookVector) end
	if KeysPressed.A then moveDirection = moveDirection - (humanoidRootPart.CFrame.RightVector) end
	if KeysPressed.S then moveDirection = moveDirection - (humanoidRootPart.CFrame.LookVector) end
	if KeysPressed.D then moveDirection = moveDirection + (humanoidRootPart.CFrame.RightVector) end
	
	if moveDirection.Magnitude > 0 then
		moveDirection = moveDirection.Unit
		humanoid:MoveTo(humanoidRootPart.Position + moveDirection * 0.6)
	end
end)

return PlayerController
