-- +1 Wings for brainrot
-- Developed by wirlypirly12

return (function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local player = game:GetService("Players").LocalPlayer

    -- Keep teleports paced so streamed objects and server position stay in sync.
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]

    local farming = false
    

    -- // this game uses streaming enabled, so we need to use always rendered world spots.
    local worldPositions = { 
        cosmic = Vector3.new(169, 42, 6124),
        spawn = Vector3.new(22, 71, -133)
    }

    local function getSpawnData(name)
        local item = workspace:FindFirstChild("ItemSpawners")
        if not item then return end

        local data = item:FindFirstChild(name)
        return data
    end

    local function waitForUnpause()
        while player.GameplayPaused do
            task.wait(0.1)
        end
    end

    local function teleportTo(pos)
        local root = utils.GetRoot(player)
        if not root then return false end

        pos = typeof(pos) == "Vector3" and CFrame.new(pos) or pos
        root.CFrame = pos

        local waitTime = ((ping:GetValue() * 4) / 1000)
        task.wait(waitTime)

        waitForUnpause()
        return true
    end

    local function putToolsAway()
        local character = utils.GetCharacter(player)
        if not character then return end

        for _, part in character:GetChildren() do
            if part:IsA("Tool") then
                part.Parent = player.Backpack
            end
        end
    end

    local function getBrainrot(rot)
        local brainrotMesh = rot:WaitForChild("Mesh", 3) -- we hate infinite yield!!!
        if not brainrotMesh then return end
		
        local proximityPrompt = brainrotMesh:FindFirstChildWhichIsA("ProximityPrompt")
        if not proximityPrompt then return end

        if not teleportTo(rot.WorldPivot) then return end
        utils.FirePrompt(proximityPrompt)

        task.wait()

        -- // this game requires you to be in spawn so the brainrot becomes a tool inside of ur char
        teleportTo(worldPositions.spawn)

        task.wait()

        putToolsAway()

        return true
    end

    local function doFarm(rotContainer)
        for i, v in rotContainer:GetChildren() do
            if getBrainrot(v) then
                teleportTo(worldPositions.cosmic)
            end
        end
    end

    task.spawn(function()
        while task.wait() do
            if farming == false then continue end
            local cosmics = getSpawnData("Cosmic")
            if cosmics == nil then
                -- // teleport
                teleportTo(worldPositions.cosmic)
				continue
            end
            doFarm(cosmics)
        end
    end)

    elements:Toggle("Farming", section, function(value)
        farming = value
    end)

    elements:Button("Teleport to spawn", section, function(value)
        teleportTo(worldPositions.spawn)
    end)

end)
