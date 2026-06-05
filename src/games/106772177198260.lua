-- Reel for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local repStorage = game:GetService("ReplicatedStorage")
    local plr = game:GetService("Players").LocalPlayer

    local placeEv = game:GetService("ReplicatedStorage").RemoteHandler.Plot

    getgenv().Farming = false

    elements:Toggle("Farming", section, function(isOn)
        utils.StartToggleLoop("Farming", isOn, function()
            local fishing = repStorage:FindFirstChild("RemoteHandler") and repStorage.RemoteHandler:FindFirstChild("Fishing")
            if fishing then
                fishing:FireServer(
                    "Caught",
                    3
                )
            end
        end, 0.1)
    end)

    elements:Button("Dupe Brainrot InHand", section, function()
        local char = utils.GetCharacter(plr)
        local br = char and char:FindFirstChildOfClass("Tool")
        if br and br:GetAttribute("brainrot") then
            for plotNum = 1, 30 do
                placeEv:FireServer("Add", "Plot" .. plotNum, br.Name)
                task.wait(0.5)
            end
        end
    end)
end
