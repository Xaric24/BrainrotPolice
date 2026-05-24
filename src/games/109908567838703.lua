-- nuke for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()

    local brainrotFold = workspace.Camera.BrainrotContainer
    local wallDurabilities = require(game:GetService("ReplicatedStorage").Modules.Constants.WallDurabilities)
    local plr = game:GetService("Players").LocalPlayer

    local powerAmt = plr.PlayerGui.HUD.BottomRight.Stats.Container.Power.CollectedText

    getgenv().AutoMoney = false
    getgenv().AutoRebirth = false
    getgenv().FarmRots = false
    getgenv().FarmZone = 1

    elements:Textbox("Farm Zone (1-15)", section, function(v)
        getgenv().FarmZone = tonumber(v)
    end)

    elements:Toggle("FarmRots", section, function(v)
        if v then
            getgenv().FarmRots = true

            while getgenv().FarmRots do
                local spot = workspace.GameArea.Interactables.BrainrotSpawns[tostring(getgenv().FarmZone)]:FindFirstChildOfClass("Part")
                local halfSize = spot.Size * 0.5

                for _,v in pairs(brainrotFold:GetChildren()) do
                    if v.PrimaryPart then
                        local pos = v.PrimaryPart.Position
                        local localPos = spot.CFrame:PointToObjectSpace(pos)

                        if math.abs(localPos.X) <= halfSize.X
                        and math.abs(localPos.Z) <= halfSize.Z then
                            plr.Character:MoveTo(pos)
                            task.wait()
                            repeat fireproximityprompt(v.ProximityPrompt) task.wait() until v:FindFirstChild("WeldConstraint")
                            plr.Character:MoveTo(Vector3.new(-54, 31, -2196))

                            task.wait(0.5)
                        end
                    end
                end
                task.wait(1)
            end
        else
            getgenv().FarmRots = false
        end
    end)

    elements:Toggle("Auto Money", section, function(v)
        if v then
            getgenv().AutoMoney = true

            while getgenv().AutoMoney do
                task.spawn(function()
                    local Event = game:GetService("ReplicatedStorage").ModifiedPackages.Packet.RemoteEvent
                    Event:FireServer(
                        buffer.fromstring("\x0E")
                    )
                end)
                task.wait()
            end
        else
            getgenv().AutoMoney = false
        end
    end)

    elements:Toggle("Auto Rebirth", section, function(v)
        if v then
            getgenv().AutoRebirth = true

            while getgenv().AutoRebirth do
                local Event = game:GetService("ReplicatedStorage").ModifiedPackages.Packet.RemoteEvent
                Event:FireServer(
                    buffer.fromstring("\x93")
                )
                task.wait(1)
            end
        else
            getgenv().AutoRebirth = false
        end
    end)
end
