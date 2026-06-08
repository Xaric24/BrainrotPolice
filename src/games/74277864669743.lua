-- fly for brainrots

return function(section, data)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()
    local httpservice = game:GetService("HttpService")

    local plr = game:GetService("Players").LocalPlayer
    local packetEvent = game:GetService("ReplicatedStorage").Libraries.Packet.RemoteEvent
    getgenv().Farming = false
    getgenv().FarmWings = false
    getgenv().AutoBest = false
    getgenv().AutoCollect = false

    data = data or {}
    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farmrots = setdata.farmrots == true
    setdata.farmequip = setdata.farmequip == true
    setdata.farmspeed = setdata.farmspeed == true
    setdata.farmcollect = setdata.farmcollect == true
    data[tostring(game.PlaceId)] = setdata

    local function saveSetting(key, value)
        setdata[key] = value == true
        data[tostring(game.PlaceId)] = setdata

        if typeof(writefile) == "function" then
            writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(data))
        end
    end

    elements:Label("Auto rejoin on kick recommended. (Settings tab)", section)

    elements:Toggle("Farm Brainrots", section, setdata.farmrots, function(v)
        saveSetting("farmrots", v)
        utils.StartToggleLoop("Farming", v, function()
            local brainrots = workspace:FindFirstChild("Brainrots")
            if not brainrots then return end

            for _, brainrot in pairs(brainrots:GetChildren()) do
                local rarity = brainrot:GetAttribute("Rarity")
                local wanted = rarity == "ADMIN"
                    or rarity == "Lucky"
                    or rarity == "Ascendant"
                    or rarity == "Transcendent"
                    or rarity == "OG"

                if wanted then
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
            end
        end, 0.1)
    end)

    elements:Toggle("Auto Buy Speed", section, setdata.farmspeed, function(v)
        saveSetting("farmspeed", v)
        utils.StartToggleLoop("FarmWings", v, function()
            packetEvent:FireServer(
                buffer.fromstring("\x15\x01")
            )
        end, 0.05)
    end)

    elements:Toggle("Auto Equip Best", section, setdata.farmequip, function(v)
        saveSetting("farmequip", v)
        utils.StartToggleLoop("AutoBest", v, function()
            packetEvent:FireServer(
                buffer.fromstring("\x0E")
            )
        end, 1)
    end)

    elements:Toggle("Auto Collect", section, setdata.farmcollect, function(v)
        saveSetting("farmcollect", v)
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
