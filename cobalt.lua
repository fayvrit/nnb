-- rit owns ya

local Settings = {
  Repo = "https://github.com/dawid-scripts/Fluent",
  Title = "Cobalt",
  SubTitle = "0.0.1",
}

local Fluent = loadstring(game:HttpGet(Settings.Repo .. "/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Connections = {}
local IConnections = {}
local Tools = {}

Tools.Connect = function( Instance, Callback, Name )
    if not Instance or not Callback then return warn("RBXSignal Failed!") end
    local Connection = Instance:Connect(Callback)
    table.insert(Connections, Connection)
    
    if Name then
        if IConnections[Name] then 
            IConnections:Disonnect()
        end

        IConnections[Name] = Connection
    end
  
    return Connection
end
  
Tools.Rejoin = function()
    local Success, ErrorMessage = pcall(function()
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end)
  
    if ErrorMessage and not Success then
        Fluent:Notify({
            Title = "Failed!",
            Content = "Rejoin attempt failed!",
            Duration = 2
        })
    end
end

Tools.TeleportTo = function(CFrame)
    if not Players.LocalPlayer or not Players.LocalPlayer.Character then
        return Fluent:Notify({
            Title = "Instance not found!",
            Content = "Player Instance is nil!",
            Duration = 2
        })
    end

    Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame)
end

Tools.GetSafeValue = function(Instance)
    if not Instance then warn("Safe Value Not Found!") return end

    return Instance.Value
end

Tools.FireSafeRemote = function(Instance)
    if not Instance then warn("Safe Remote Not Found!") return end

    return Instance:FireServer()
end

-- // User Interface Start

local Window = Fluent:CreateWindow({
    Title = Settings.Title,
    SubTitle = Settings.SubTitle,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Self = Window:AddTab({ Title = "Self", Icon = "" }),
    Game = Window:AddTab({ Title = "Game", Icon = "" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

local Options = Fluent.Options

--[[ Self Tabs ]] do
    Tabs.Self:AddParagraph({
        Title = "Info",
        Content = string.format("Name: %s\nDisplay Name: %s\nID: %s\nAccount Age: %s", Players.LocalPlayer.Name, Players.LocalPlayer.DisplayName, Players.LocalPlayer.UserId, Players.LocalPlayer.AccountAge)
    })
    
    Tabs.Self:AddButton({
        Title = "Respawn",
        Description = "Respawns your character",
        Callback = function()
            
            Window:Dialog({
                Title = string.format("%s's Dialog", Settings.Title),
                Content = "Would you like to \"Respawn your character?\"",
                Buttons = {
                
                    { Title = "Confirm", Callback = function()
                        Tools.FireSafeRemote(ReplicatedStorage.events.player.char.respawnchar)
                    end },
                
                    { Title = "Cancel" }
                }
            })
          
        end
    })
    
    Tabs.Self:AddButton({
        Title = "Rejoin",
        Description = "Rejoins the server",
        Callback = function()
            Window:Dialog({
                Title = string.format("%s's Dialog", Settings.Title),
                Content = "Would you like to \"Rejoin the server?\"",
                Buttons = {
                    { Title = "Confirm", Callback = Tools.Rejoin },
                    { Title = "Cancel" }
                }
            })
        end
    })
end

--[[ Auto Tabs  do
    local Punch = Tabs.Auto:AddToggle("Punch", { Title = "Punch", Default = false })
    Punch:OnChanged(function()
        if Options.Punch.Value then
            Tools.Connect(RunService.Heartbeat, function()
                Tools.FireSafeRemote(ReplicatedStorage.events.player.local.punch)
            end, "Punch")
        elseif IConnections.Punch then
            IConnections.Punch:Disconnect()
        end
    end)
  
end]]


  
Window:SelectTab(1)

Fluent:Notify({
    Title = "Loaded!",
    Content = string.format("Successfully loaded %s!", Settings.Title),
    Duration = 5
})

