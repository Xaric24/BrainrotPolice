-- scream for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()
    getgenv().AddingSpins = false
    getgenv().AutoSleepy = false
    getgenv().AutoOg = false
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

    elements:Toggle("Add Inf Spins", section, function(v)
        utils.StartToggleLoop("AddingSpins", v, function()
            remotes.AddSpin:FireServer()
        end, 0.05)
    end)

    elements:Toggle("Auto Spin Sleepy Mutation", section, function(v)
        utils.StartToggleLoop("AutoSleepy", v, function()
            remotes.SpinEventWheel:FireServer(
                5
            )
        end, 0.5)
    end)

    elements:Toggle("Auto Spin OG", section, function(v)
        utils.StartToggleLoop("AutoOg", v, function()
            remotes.SpinEventWheel:FireServer(
                4
            )
        end, 0.5)
    end)
end
