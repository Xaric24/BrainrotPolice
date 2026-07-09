-- hack vault for brainrots

return function(section, data)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local plr = game:GetService("Players").LocalPlayer
    local entitiesFolder = workspace:FindFirstChild("EntitiesFolder")
    local grabPosition = Vector3.new(-2494, 4, -726)
    local dropPosition = Vector3.new(77, 4, -729)

    getgenv().FarmRots = false

    local function getSpawnZone(model)
        local zone = tonumber(model:GetAttribute("SpawnZone"))
        if zone then
            return zone
        end

        return -1
    end

    local function findLastZoneBrainrot()
        if not entitiesFolder then
            return nil, nil, nil
        end

        local bestBrainrot
        local bestPrompt
        local bestPart
        local highestZone = -1

        for _, br in pairs(entitiesFolder:GetChildren()) do
            local zone = getSpawnZone(br)
            local primaryPart = br.PrimaryPart
            local prompt = utils.FindPrompt(br, "TakeBrainrotPrompt")

            if zone > highestZone and primaryPart and prompt then
                highestZone = zone
                bestBrainrot = br
                bestPrompt = prompt
                bestPart = primaryPart
            end
        end

        return bestBrainrot, bestPrompt, bestPart
    end

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farmrots = setdata.farmrots or false
    data[tostring(game.PlaceId)] = setdata
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))

    elements:Toggle("Farm Brainrots", section, setdata.farmrots, function(v)
        getgenv().setconfig("farmrots", v)
        if v then
            getgenv().FarmRots = true

            while getgenv().FarmRots do
                entitiesFolder = entitiesFolder or workspace:FindFirstChild("EntitiesFolder")

                if entitiesFolder then
                    utils.MoveCharacter(plr, grabPosition)
                    task.wait(0.35)

                    local br, prompt, primaryPart = findLastZoneBrainrot()

                    if br and prompt and primaryPart then
                        utils.MoveCharacter(plr, primaryPart.Position)
                        task.wait(0.1)

                        local started = os.clock()
                        repeat
                            utils.FirePrompt(prompt)
                            task.wait(0.1)
                        until not getgenv().FarmRots
                            or not br.Parent
                            or not primaryPart.Parent
                            or primaryPart:FindFirstChild("Attachment")
                            or os.clock() - started > 4

                        utils.MoveCharacter(plr, dropPosition)
                        task.wait(1)
                    end
                end

                task.wait(0.2)
            end
        else
            getgenv().FarmRots = false
        end
    end)
end
