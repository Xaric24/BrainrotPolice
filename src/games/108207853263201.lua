-- "Rizz Tower" because its the first result when searching 'vaehz'

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    getgenv().WinFarm = false

    local plr = game:GetService("Players").LocalPlayer

    elements:Toggle("Win Farm", section, function(bool)
        utils.StartToggleLoop("WinFarm", bool, function()
            local character = utils.GetCharacter(plr)
            local head = character and character:FindFirstChild("Head")
            local reward = workspace:FindFirstChild("TeleportWin") and workspace.TeleportWin:FindFirstChild("Reward")

            if head and reward and typeof(firetouchinterest) == "function" then
                utils.MoveCharacter(plr, Vector3.new(1, 477, -315))
                task.wait()
                firetouchinterest(head, reward, true)
                task.wait()
                firetouchinterest(head, reward, false)
            end
        end, 0.05)
    end)
end
