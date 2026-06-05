-- Survive flood for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local plr = game:GetService("Players").LocalPlayer
    local brainrotFold = workspace:WaitForChild("GameFolder"):WaitForChild("Brainrots")

    getgenv().Farming = false

    local function grabem(where)
        if not where then return end

        for _, br in pairs(where:GetChildren()) do
            local prompt = br.PrimaryPart and br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
            if not prompt then continue end

            utils.MoveCharacter(plr, br.PrimaryPart.Position)
            task.wait(0.5)
            utils.FirePrompt(prompt)
            task.wait(0.25)
            utils.MoveCharacter(plr, Vector3.new(-2, 4, 13))
            task.wait(0.5)
        end
    end

    elements:Toggle("Farming", section, function(isOn)
        utils.StartToggleLoop("Farming", isOn, function()
            grabem(brainrotFold:FindFirstChild("Infinity"))
            grabem(brainrotFold:FindFirstChild("Godly"))
            grabem(brainrotFold:FindFirstChild("Secret"))
            grabem(brainrotFold:FindFirstChild("Celestial"))
        end, 1)
    end)
end
