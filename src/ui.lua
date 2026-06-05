local hui = gethui or get_hidden_gui
local getexec = identifyexecutor or function()
    return "Unknown"
end
local coregui = game:GetService("CoreGui")
local userinputservice = game:GetService("UserInputService")
local httpservice = game:GetService("HttpService")
local exservice = game:GetService("ExperienceService")
local utils = loadstring(game:HttpGet(getgitpath("src") .. "utils.lua"))()

local ui = import("rbxassetid://75281832304062")
if not ui then
    warn("[BrainrotPolice] UI asset failed to load.")
    return
end

ui.Parent = hui and hui() or coregui

local ToggleButton = ui.togglebtn
local MainFrame = ui.Frame

local Topbar = MainFrame.TopBar
local SectionContainers = MainFrame.sectionContainers
local TabList = MainFrame.tablist

local HideButton = Topbar.hidebtn

local Sections = {
    Home = {
        TabBtn = TabList.HomeTab,
        Container = SectionContainers.homeframe
    },

    Game = {
        TabBtn = TabList.GameTab,
        Container = SectionContainers.gameFrame
    },

    GamesList = {
        TabBtn = TabList.GameslistTab,
        Container = SectionContainers.gamelistFrame
    },

    Settings = {
        TabBtn = TabList.SettingsTab,
        Container = SectionContainers.settingsFrame
    },

    Credits = {
        TabBtn = TabList.CreditsTab,
        Container = SectionContainers.creditsFrame
    }
}

local CurSection

local function switchSection(sect)
    if CurSection == sect then return end

    if CurSection then
        CurSection.TabBtn.BackgroundTransparency = 1
        CurSection.Container:TweenPosition(UDim2.new(0.5, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    end

    sect.TabBtn.BackgroundTransparency = 0
    sect.Container:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
    sect.Container.Visible = true

    CurSection = sect
end

local function fetch(path)
    local ok, body = pcall(function()
        return game:HttpGet(path)
    end)

    if ok and body and body ~= "404: Not Found" then
        return body
    end

    return nil
end

local function decodeJson(path, fallback)
    local body = fetch(path)
    if not body then
        return fallback
    end

    local ok, decoded = pcall(function()
        return httpservice:JSONDecode(body)
    end)

    if ok and decoded then
        return decoded
    end

    return fallback
end

local function loadModule(source)
    if not source or #source == 0 then
        return nil
    end

    local loaded = loadstring(source)
    if not loaded then
        return nil
    end

    local ok, module = pcall(loaded)
    if ok then
        return module
    end

    return nil
end

for _, sect in pairs(Sections) do
    sect.TabBtn.MouseEnter:Connect(function()
        for _, stroke in pairs(sect.TabBtn:GetChildren()) do
            if stroke.Name == "InnerShadow" then
                stroke.Transparency = 0.95
            end
        end
    end)

    sect.TabBtn.MouseLeave:Connect(function()
        for _, stroke in pairs(sect.TabBtn:GetChildren()) do
            if stroke.Name == "InnerShadow" then
                stroke.Transparency = 1
            end
        end
    end)

    sect.TabBtn.MouseButton1Click:Connect(function()
        switchSection(sect)
    end)
end

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

local dragging = false
local dragInput, mousePos, framePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userinputservice.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

Sections.Home.Container.bugsLabel.Text = Sections.Home.Container.bugsLabel.Text:gsub("redacted", "discord.gg/vaehz")
Sections.Home.Container.discan.Text = Sections.Home.Container.discan.Text:gsub("redacted", "discord.gg/vaehz")
Sections.Home.Container.ythead.Text = Sections.Home.Container.ythead.Text:gsub("redacted", "YouTube")
Sections.Home.Container.execLabel.Text = "Executor: " .. getexec()

local gamePath = fetch(getgitpath("games") .. tostring(game.PlaceId) .. ".lua")
local gameList = decodeJson(getgitpath("src") .. "gameslist.json", {})
local creditsList = decodeJson(getgitpath("src") .. "credits.json", {})
local elements = loadModule(fetch(getgitpath("src") .. "elements.lua"))
if not elements then
    warn("[BrainrotPolice] Elements failed to load.")
    return
end

if not gamePath then
    local handledLocally = false

    if getgenv().FileScripts and typeof(isfile) == "function" and typeof(readfile) == "function" then
        local localPath = "BrainrotPolice/" .. tostring(game.PlaceId) .. ".lua"
        if isfile(localPath) then
            local gameModule = loadModule(readfile(localPath))
            if gameModule then
                utils.SafeCall(gameModule, Sections.Game.Container)
                handledLocally = true
            end
        end
    end

    if not handledLocally then
        elements:Unsupported(Sections.Game.Container, function()
            switchSection(Sections.GamesList)
        end)
    end
else
    local gameModule = loadModule(gamePath)
    if gameModule then
        utils.SafeCall(gameModule, Sections.Game.Container)
    else
        elements:Label("Game script failed to load.", Sections.Game.Container)
    end
end

for _, g in ipairs(gameList) do
    elements:Button(g.status .. " " .. g["game"], Sections.GamesList.Container, function()
        exservice:LaunchExperience({placeId = tonumber(g.id) or g.id})
    end)
end

for sect, c in pairs(creditsList) do
    elements:CredHead(Sections.Credits.Container, sect)

    for _, person in ipairs(c) do
        elements:CredPerson(Sections.Credits.Container, person)
    end
end

elements:Toggle("Disable 3D Rendering", Sections.Settings.Container, function(v)
    game:GetService("RunService"):Set3dRenderingEnabled(not v)
end)

elements:Toggle("Auto Rejoin (when kicked)", Sections.Settings.Container, function(v)
    getgenv().autorjjjj = v
end)
