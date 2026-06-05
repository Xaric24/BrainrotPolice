-- parkour run for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()
    getgenv().farming = false

    local plr = game:GetService("Players").LocalPlayer
    local returnEvent = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net["RE/BG_ReturnToBase"]

    elements:Toggle("Farming", section, function(v)
        utils.StartToggleLoop("farming", v, function()
            utils.MoveCharacter(plr, Vector3.new(12738, 1490, 231))

            local spawner = workspace:FindFirstChild("BG_BrainrotSpawner")
            if not spawner then return end

            for _, holder in pairs(spawner:GetChildren()) do
                local br = holder:FindFirstChildOfClass("Model")
                local prompt = br and br.PrimaryPart and br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")

                if holder.Name == "Mythical" and br and prompt then
                    repeat
                        utils.FirePrompt(prompt)
                        task.wait()
                    until not getgenv().farming or br.Parent ~= holder
                    returnEvent:FireServer()
                    task.wait(1)
                end
            end
        end, 0.1)
    end)
end
