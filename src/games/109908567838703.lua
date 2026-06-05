-- nuke for brainrots

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local utils = loadstring(game:HttpGet(getgitpath("src").."utils.lua"))()

    local packetEvent = game:GetService("ReplicatedStorage").ModifiedPackages.Packet.RemoteEvent

    getgenv().AutoMoney = false
    getgenv().AutoRebirth = false

    elements:Toggle("Auto Money", section, function(v)
        utils.StartToggleLoop("AutoMoney", v, function()
            packetEvent:FireServer(
                buffer.fromstring("\x0E")
            )
        end, 0.05)
    end)

    elements:Toggle("Auto Rebirth", section, function(v)
        utils.StartToggleLoop("AutoRebirth", v, function()
            packetEvent:FireServer(
                buffer.fromstring("\x93")
            )
        end, 1)
    end)
end
