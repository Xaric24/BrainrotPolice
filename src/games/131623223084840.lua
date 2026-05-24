-- escape tsunami for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()

    getgenv().Farming = false
    local plr = game:GetService("Players").LocalPlayer

    local function getChar()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        return plr, char, hrp
    end

    local function farmLoop()
        while getgenv().Farming do
            pcall(function()
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                local plr, char, hrp = getChar()
                local devPath = workspace.ActiveBrainrots.Divine
                local celPath = workspace.ActiveBrainrots.Celestial
                local secPath = workspace.ActiveBrainrots.Secret
                local speedLabel = plr.PlayerGui.HUD.BottomLeft.JumpAndSpeed.Container.EventCurrency.Value

                local function moveTo(pos)
                    local targetY = 80
                    repeat
                        local current = hrp.Position
                        local yDiff = targetY - current.Y
                        if math.abs(yDiff) <=1 then
                            hrp.CFrame = CFrame.new(current.X, targetY, current.Z)
                            break
                        end

                        local step = math.clamp(yDiff, -6, 6)
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, step, 0)
                        task.wait()
                    until false

                    local endpos = Vector3.new(pos.X, targetY, pos.Z)

                    local finished = false
                    local connection

                    connection = RunService.Heartbeat:Connect(function(dt)
                        if not char or not hrp then
                            finished = true
                            connection:Disconnect()
                            return
                        end

                        local speed = tonumber(speedLabel.Text:match("[%d%.]+")) or 16

                        local currentPos = hrp.Position
                        local flatPos = Vector3.new(currentPos.X, targetY, currentPos.Z)

                        local direction = endpos - flatPos
                        local distance = direction.Magnitude
                        if distance <= 1 then
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            finished = true
                            connection:Disconnect()
                            return
                        end

                        direction = direction.Unit
                        local newPos = flatPos + (direction * speed * dt)

                        hrp.CFrame = CFrame.new(newPos)
                    end)

                    repeat task.wait() until finished
                end

                local function processFolder(folder, startPos)
                    if #folder:GetChildren() < 1 then return end

                    moveTo(startPos)

                    for _, br in pairs(folder:GetChildren()) do
                        if not getgenv().Farming then return end
                        if not br:FindFirstChild("Root") then continue end
                        moveTo(br.Root.Position)
                        if not br:FindFirstChild("Root") then continue end
                        repeat
                            fireproximityprompt(br.Root.TakePrompt)
                            task.wait()
                        until plr.Character:FindFirstChild("RenderedBrainrot")
                        task.wait(0.1)
                        moveTo(Vector3.new(121, 3, 19))
                    end
                end
                processFolder(devPath, Vector3.new(2785, 0, 0))
                processFolder(celPath, Vector3.new(4164, 0, 0))
                processFolder(secPath, Vector3.new(2430, 0, 0))
            end)

            task.wait()
        end
    end

    elements:Toggle("Farm Brainrots", section, function(bool)
        getgenv().Farming = bool

        if bool then
            task.spawn(farmLoop)
        end
    end)
end
