-- Cross road for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local plr = game:GetService("Players").LocalPlayer

    getgenv().FarmBrainrots = false

    elements:Toggle("Farm Brainrots", section, function(bool)
        if bool then
            getgenv().FarmBrainrots = true

            local function tp(pos)
                local hrp = utils.GetRoot(plr)
                if not hrp then return false end

                utils.MoveCharacter(plr, pos)

                repeat
                    task.wait()
                until not getgenv().FarmBrainrots or (hrp.Position - pos).Magnitude < 10

                return getgenv().FarmBrainrots
            end

            local function waitForFolderChildren(folder, minimum, timeout)
                timeout = timeout or 5
                local start = tick()
                repeat
                    if #folder:GetChildren() >= minimum then
                        return true
                    end

                    task.wait(0.25)
                until tick() - start > timeout

                return false
            end

            while getgenv().FarmBrainrots do
                if not tp(Vector3.new(345, 19, 2242)) then break end
                local itemSpawners = workspace:FindFirstChild("ItemSpawners")
                local celestial = itemSpawners and itemSpawners:WaitForChild("Celestial", 5)
                if not celestial then task.wait(1) continue end

                waitForFolderChildren(celestial, 1, 5)

                for _, br in pairs(celestial:GetChildren()) do
                    if br.PrimaryPart then
                        tp(br.PrimaryPart.Position)

                        task.wait(0.5)

                        local prompt = br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")

                        if prompt then
                            repeat
                                utils.FirePrompt(prompt)
                                task.wait()
                            until not getgenv().FarmBrainrots or not br or br.Parent ~= celestial
                        else
                            continue
                        end

                        task.wait(0.5)

                        tp(Vector3.new(343, 2, -15))
                        task.wait(2)

                        tp(Vector3.new(345, 19, 2242))
                        task.wait(1)
                    end
                end


                if not tp(Vector3.new(353, 2, 2092)) then break end
                local secret = itemSpawners and itemSpawners:WaitForChild("Secret", 5)
                if not secret then task.wait(1) continue end
                waitForFolderChildren(secret, 1)

                for _, br in pairs(secret:GetChildren()) do
                    if br.PrimaryPart then
                        tp(br.PrimaryPart.Position)

                        local prompt = br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")

                        if prompt then
                            repeat
                                utils.FirePrompt(prompt)
                                task.wait()
                            until not getgenv().FarmBrainrots or not br or br.Parent ~= secret
                        else
                            continue
                        end

                        task.wait(0.5)

                        tp(Vector3.new(343, 2, -15))
                        task.wait(2)

                        tp(Vector3.new(353, 2, 2092))
                        task.wait(1)
                    end
                end

                task.wait(0.1)
            end
        else
            getgenv().FarmBrainrots = false
        end
    end)

    elements:Button("Remove Cars", section, function()
        local carSpawn = workspace:FindFirstChild("CarSpawn")
        if carSpawn then
            carSpawn:Destroy()
        end
    end)
end
