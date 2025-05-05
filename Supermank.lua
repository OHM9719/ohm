local player = game.Players.LocalPlayer

local function warpAround(character, baseCFrame)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local randomX = math.random(-10, 10)
		local randomZ = math.random(-10, 10)
		local newCFrame = baseCFrame * CFrame.new(randomX, 0, randomZ)
		character:SetPrimaryPartCFrame(newCFrame)
	end
end

local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local hrp = character:WaitForChild("HumanoidRootPart")
	local isWarping = false

	humanoid.HealthChanged:Connect(function()
		if humanoid.Health < 30 then
			if not isWarping then
				isWarping = true
				humanoid.PlatformStand = true

				local baseCFrame = hrp.CFrame * CFrame.new(0, 15, 0)
				character:SetPrimaryPartCFrame(baseCFrame)

				task.spawn(function()
					while isWarping and humanoid.Health < 30 do
						warpAround(character, baseCFrame)
						task.wait(0.1)
					end
				end)
			end
		else
			if isWarping then
				isWarping = false
				humanoid.PlatformStand = false
			end
		end
	end)
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
	setupCharacter(player.Character)
end
