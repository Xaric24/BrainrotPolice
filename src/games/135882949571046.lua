-- dream for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()
    getgenv().farming = false
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

    elements:Toggle("Farming", section, function(v)
        utils.StartToggleLoop("farming", v, function()
            remotes.DreamStateChanged:FireServer(true)
            remotes.RequestDreamBrainrots:FireServer()
            remotes.PickupDreamBrainrot:FireServer("60")
            task.wait()
            remotes.RequestDreamWallExit:FireServer()
        end, 0.05)
    end)
end
