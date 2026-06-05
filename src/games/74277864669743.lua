-- fly for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local plr = game:GetService("Players").LocalPlayer
    local packetEvent = game:GetService("ReplicatedStorage").Libraries.Packet.RemoteEvent
    getgenv().Farming = false
    getgenv().FarmWings = false
    getgenv().AutoBest = false
    getgenv().AutoCollect = false

    elements:Label("Auto rejoin on kick recommended. (Settings tab)", section)

    elements:Toggle("Farm Brainrots", section, function(v)
        utils.StartToggleLoop("Farming", v, function()
            local brainrots = workspace:FindFirstChild("Brainrots")
            if not brainrots then return end

            for _, brainrot in pairs(brainrots:GetChildren()) do
                local rarity = brainrot:GetAttribute("Rarity")
                if rarity ~= "ADMIN"
                    and rarity ~= "Lucky"
                    and rarity ~= "Ascendant"
                    and rarity ~= "Transcendent"
                    and rarity ~= "OG" then
                    continue
                end

                local prompt = utils.FindFirstDescendantOfClass(brainrot, "ProximityPrompt")
                if brainrot.PrimaryPart and prompt then
                    utils.MoveCharacter(plr, brainrot.PrimaryPart.Position)
                    repeat
                        utils.FirePrompt(prompt)
                        task.wait()
                    until not getgenv().Farming or not brainrot.Parent or brainrot.Parent ~= brainrots
                    task.wait()
                    utils.MoveCharacter(plr, Vector3.new(7, 10, 44))
                    task.wait(0.25)
                end
            end
        end, 0.1)
    end)

    elements:Toggle("Auto Buy Speed", section, function(v)
        utils.StartToggleLoop("FarmWings", v, function()
            packetEvent:FireServer(
                buffer.fromstring("\x15\x01")
            )
        end, 0.05)
    end)

    elements:Toggle("Auto Equip Best", section, function(v)
        utils.StartToggleLoop("AutoBest", v, function()
            packetEvent:FireServer(
                buffer.fromstring("\x0E")
            )
        end, 1)
    end)

    elements:Toggle("Auto Collect", section, function(v)
        utils.StartToggleLoop("AutoCollect", v, function()
            local plots = workspace:FindFirstChild("Plots")
            local character = utils.GetCharacter(plr)
            local head = character and character:FindFirstChild("Head")
            if not plots or not head or typeof(firetouchinterest) ~= "function" then return end

            for _, plot in pairs(plots:GetChildren()) do
                if plot:GetAttribute("Owner") == plr.UserId and plot:FindFirstChild("Podiums") then
                    for _, pod in pairs(plot.Podiums:GetChildren()) do
                        local collect = pod:FindFirstChild("Collect")
                        if collect then
                            firetouchinterest(head, collect, true)
                            task.wait()
                            firetouchinterest(head, collect, false)
                        end
                    end
                end
            end
        end, 2)
    end)
end
