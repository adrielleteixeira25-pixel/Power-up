-- GodModeServer
-- Coloque em ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Criar RemoteEvent automaticamente
local remote = ReplicatedStorage:FindFirstChild("GodModeRemote")

if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "GodModeRemote"
	remote.Parent = ReplicatedStorage
end

-- Dados temporários de cada jogador
local playerData = {}

local function getCharacter(player)
	local character = player.Character

	if not character then
		return nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		return nil
	end

	return character, humanoid, root
end

local function setGodMode(player, enabled)
	local data = playerData[player]

	if not data then
		return
	end

	data.godMode = enabled

	local character, humanoid, root = getCharacter(player)

	if not character then
		return
	end

	if enabled then
		-- Vida muito alta e regeneração
		humanoid.MaxHealth = 1000000
		humanoid.Health = humanoid.MaxHealth

		-- ForceField ajuda contra danos físicos/explosões
		local forceField = character:FindFirstChild("GodModeForceField")

		if not forceField then
			forceField = Instance.new("ForceField")
			forceField.Name = "GodModeForceField"
			forceField.Visible = false
			forceField.Parent = character
		end

		data.forceField = forceField
	else
		if data.forceField then
			data.forceField:Destroy()
			data.forceField = nil
		end

		humanoid.MaxHealth = 100
		humanoid.Health = math.min(humanoid.Health, 100)
	end
end

Players.PlayerAdded:Connect(function(player)
	playerData[player] = {
		savedPosition = nil,
		godMode = false,
		forceField = nil
	}

	player.CharacterAdded:Connect(function(character)
		task.wait(0.5)

		local data = playerData[player]

		if data and data.godMode then
			setGodMode(player, true)
		end
	end)
end)

Players.PlayerRemoving:Connect
