-- pole obby for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    getgenv().farming = false
    local plr = game:GetService("Players").LocalPlayer
    local safeZoneEvent = game:GetService("ReplicatedStorage").Packages.Net["RE/SafeZoneEvent"]

    elements:Toggle("Farm Brainrots", section, function(v)
        utils.StartToggleLoop("farming", v, function()
            local mobs = workspace:FindFirstChild("Mobs")
            if not mobs then return end

            for _, mob in pairs(mobs:GetChildren()) do
                local primary = mob.PrimaryPart
                local rarityLabel = primary
                    and primary:FindFirstChild("OverheadAttach")
                    and primary.OverheadAttach:FindFirstChild("AnimalOverhead")
                    and primary.OverheadAttach.AnimalOverhead:FindFirstChild("Rarity")
                local prompt = primary and primary:FindFirstChildOfClass("ProximityPrompt")

                if rarityLabel and prompt and (rarityLabel.Text == "OG" or rarityLabel.Text == "Admin") then
                    utils.MoveCharacter(plr, primary.Position)
                    repeat
                        utils.FirePrompt(prompt)
                        task.wait()
                    until not getgenv().farming or not mob.Parent or not mob.PrimaryPart or mob.PrimaryPart:FindFirstChild("MobCarryWeld")
                    safeZoneEvent:FireServer()
                    task.wait(0.1)
                end
            end
        end, 0.1)
    end)
end
