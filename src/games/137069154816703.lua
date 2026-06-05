-- hack vault for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local plr = game:GetService("Players").LocalPlayer
    getgenv().FarmRots = false

    elements:Toggle("Farm Brainrots", section, function(v)
        utils.StartToggleLoop("FarmRots", v, function()
            local entities = workspace:FindFirstChild("EntitiesFolder")
            if not entities then return end

            for _, br in pairs(entities:GetChildren()) do
                utils.MoveCharacter(plr, Vector3.new(-2494, 4, -726))
                task.wait(0.5)

                if br:GetAttribute("SpawnZone") ~= 22 then
                    continue
                end

                local prompt = br.PrimaryPart and br.PrimaryPart:FindFirstChild("TakeBrainrotPrompt")
                if not prompt then
                    continue
                end

                utils.MoveCharacter(plr, br.PrimaryPart.Position)
                task.wait()
                repeat
                    utils.FirePrompt(prompt)
                    task.wait()
                until not getgenv().FarmRots or not br.PrimaryPart or br.PrimaryPart:FindFirstChild("Attachment")
                utils.MoveCharacter(plr, Vector3.new(77, 4, -729))
                task.wait(1)
            end
        end, 0.05)
    end)
end
