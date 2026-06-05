-- sail for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()
    getgenv().Farming = false
    getgenv().Selling = false
    getgenv().ChosenZone = nil
    getgenv().MaxPrice = 0

    local player = game:GetService("Players").LocalPlayer
    local zonesFold = workspace.Zones

    local function parseValue(str)
        str = tostring(str or ""):gsub("%s+", "")
        local suffixes = {
            K = 1e3,
            M = 1e6,
            B = 1e9,
            T = 1e12,
            Q = 1e15,
        }
        
        local num, suffix = str:match("^([%d%.]+)([A-Za-z]*)")
        
        if not num then return 0 end
        
        num = tonumber(num) or 0
        suffix = suffix:upper()
        
        if suffixes[suffix] then
            return num * suffixes[suffix]
        end
        
        return num
    end


    elements:Textbox("Farm Zone (1-13)", section, function(v)
        local zoneNumber = tonumber(v)
        if zoneNumber then
            getgenv().ChosenZone = zonesFold:FindFirstChild("Zone" .. zoneNumber)
        end
    end)

    elements:Toggle("Autofarm", section, function(v)
        utils.StartToggleLoop("Farming", v, function()
            local zone = getgenv().ChosenZone
            local objects = zone and zone:FindFirstChild("Objects")
            local baseRoot = workspace:FindFirstChild("Bases")
                and workspace.Bases:FindFirstChild(player.Name)
                and workspace.Bases[player.Name]:FindFirstChild("Root")
            if not objects or not baseRoot then return end

            for _, brainrot in pairs(objects:GetChildren()) do
                if not getgenv().Farming then return end

                local prompt = brainrot:FindFirstChildOfClass("ProximityPrompt")
                if brainrot.PrimaryPart and prompt then
                    utils.MoveCharacter(player, brainrot.PrimaryPart.Position)
                    repeat
                        utils.FirePrompt(prompt)
                        task.wait()
                    until not getgenv().Farming or brainrot.Parent ~= objects

                    utils.MoveCharacter(player, baseRoot.Position)
                    task.wait(0.5)
                end
            end
        end, 1)
    end)

    elements:Textbox("Max price", section, function(v)
        getgenv().MaxPrice = parseValue(v)
    end)

    elements:Toggle("Auto Sell", section, function(v)
        utils.StartToggleLoop("Selling", v, function()
            local sellRemote = game:GetService("ReplicatedStorage").Shared.Classes.RemoteFunction.Remotes.EntityShared_SellEntity

            for _, brainrot in pairs(player.Backpack:GetChildren()) do
                if brainrot.Name == "Bat" then continue end

                local valueLabel = brainrot:FindFirstChild("Handle")
                    and brainrot.Handle:FindFirstChild("ObjectInfo")
                    and brainrot.Handle.ObjectInfo:FindFirstChild("Value")
                    and brainrot.Handle.ObjectInfo.Value:FindFirstChild("ValueLabel")

                if valueLabel and parseValue(valueLabel.Text) <= getgenv().MaxPrice then
                    utils.SafeCall(function()
                        sellRemote:InvokeServer(brainrot.Name)
                    end)
                end
            end
        end, 3)
    end)

    elements:Button("Redeem Codes", section, function()
        local codes = {"Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin"}

        for i, v in pairs(codes) do
            local Event = game:GetService("ReplicatedStorage").Shared.Classes.RemoteFunction.Remotes.CodeShared_Redeem
            Event:InvokeServer(v)
            task.wait()
        end
    end)
end
