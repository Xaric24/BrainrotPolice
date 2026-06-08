-- fly for brainrots

return function(section, data)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local httpservice = game:GetService("HttpService")

    local plr = game:GetService("Players").LocalPlayer
    getgenv().Farming = false
    getgenv().FarmWings = false
    getgenv().AutoBest = false
    getgenv().AutoCollect = false

    elements:Label("Auto rejoin on kick recommended. (Settings tab)", section)

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farmrots = setdata.farmrots or false
    setdata.farmequip = setdata.farmequip or false
    setdata.farmspeed = setdata.farmspeed or false
    setdata.farmcollect = setdata.farmcollect or false
    writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(setdata))

    elements:Toggle("Farm Brainrots", section, setdata.farmrots, function(v)
        local dec = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
        dec[tostring(game.PlaceId)].farmrots = v
        writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(dec))
        if v then
            getgenv().Farming = true

            while getgenv().Farming do
                for _, v in pairs(workspace.Brainrots:GetChildren()) do
                    if v:GetAttribute("Rarity") ~= "ADMIN"
                    and v:GetAttribute("Rarity") ~= "Lucky"
                    and v:GetAttribute("Rarity") ~= "Ascendant"
                    and v:GetAttribute("Rarity") ~= "Transcendent"
                    and v:GetAttribute("Rarity") ~= "OG" then
                        continue
                    end

                    if v.PrimaryPart then
                        plr.Character:MoveTo(v.PrimaryPart.Position)
                        if v:FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart"):FindFirstChildOfClass("ProximityPrompt") then
                            repeat
                                fireproximityprompt(v:FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart"):FindFirstChildOfClass("ProximityPrompt"))
                                task.wait()
                            until not v or v.Parent ~= workspace.Brainrots
                            task.wait()
                            plr.Character:MoveTo(Vector3.new(7, 10, 44))
                            task.wait(0.25)
                        end
                    end
                end
                task.wait(0.1)
            end
        else
            getgenv().Farming = false
        end
    end)

    elements:Toggle("Auto Buy Speed", section, setdata.farmspeed, function(v)
        local dec = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
        dec[tostring(game.PlaceId)].farmspeed = v
        writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(dec))
        if v then
            getgenv().FarmWings = true

            while getgenv().FarmWings do
                local Event = game:GetService("ReplicatedStorage").Libraries.Packet.RemoteEvent
                Event:FireServer(
                    buffer.fromstring("\x15\x01")
                )
                task.wait()
            end
        else
            getgenv().FarmWings = false
        end
    end)

    elements:Toggle("Auto Equip Best", section, setdata.farmequip, function(v)
        local dec = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
        dec[tostring(game.PlaceId)].farmequip = v
        writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(dec))
        if v then
            getgenv().AutoBest = true

            while getgenv().AutoBest do
                local Event = game:GetService("ReplicatedStorage").Libraries.Packet.RemoteEvent
                Event:FireServer(
                    buffer.fromstring("\x0E")
                )
                task.wait(1)
            end
        else
            getgenv().AutoBest = false
        end
    end)

    elements:Toggle("Auto Collect", section, setdata.farmcollect, function(v)
        local dec = httpservice:JSONDecode(readfile("BrainrotPolice/Config.json"))
        dec[tostring(game.PlaceId)].farmcollect = v
        writefile("BrainrotPolice/Config.json", httpservice:JSONEncode(dec))
        if v then
            getgenv().AutoCollect = true

            while getgenv().AutoCollect do
                for _, v in pairs(workspace.Plots:GetChildren()) do
                    if v:GetAttribute("Owner") == plr.UserId then
                        for i, pod in pairs(v.Podiums:GetChildren()) do
                            firetouchinterest(plr.Character.Head, pod.Collect, true)
                            task.wait()
                            firetouchinterest(plr.Character.Head, pod.Collect, false)
                        end
                    end
                end
                task.wait(2)
            end
        else
            getgenv().AutoCollect = false
        end
    end)
end
