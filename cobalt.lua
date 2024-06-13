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

local OldNValue = Players.LocalPlayer.stats.nextbux.Value
local OldPValue = Players.LocalPlayer.stats.punches.Value
local Connections = {}
local IConnections = {}
local Tools = {}

Tools.FormatNumber = loadstring(game:HttpGet("https://raw.githubusercontent.com/fayvrit/Qeto/main/Tools.lua"))().FormatNumber

Tools.Connect = function( Instance, Callback, Name )
    if not Instance or not Callback then return warn("RBXSignal Failed!") end
    local Connection = Instance:Connect(Callback)
    table.insert(Connections, Connection)
    
    if Name then
        if IConnections[Name] then 
            IConnections[Name]:Disonnect()
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

--[[ Auto Tabs ]]  do
    local Punch = Tabs.Auto:AddToggle("Punch", { Title = "Punch", Default = false })
    Punch:OnChanged(function()
        if Options.Punch.Value then
            Tools.Connect(RunService.Heartbeat, function()
                Tools.FireSafeRemote(ReplicatedStorage.events.player["local"].punch)
            
                if not Options.Punch.Value then
                    if IConnections.Punch then IConnections.Punch:Disconnect() end
                end
            end, "Punch")
        end
    end)
end

--[[ Settings Tabs ]] do
    local NextBuxTracker = Tabs.Settings:AddToggle("NextBuxTracker", { Title = "NextBux Tracker", Default = false })
    NextBuxTracker:OnChanged(function()
      if Options.NextBuxTracker.Value then
            Tools.Connect(Players.LocalPlayer.stats.nextbux:GetPropertyChangedSignal('Value'), function()
                if Players.LocalPlayer.stats.nextbux.Value < OldNValue + 80 then return end
            
                OldNValue = Players.LocalPlayer.stats.nextbux.Value
            
                task.wait(.2)
            
                Fluent:Notify({
                    Title = "NextBux Tracker!",
                    Content = string.format("%s", Tools.FormatNumber(Players.LocalPlayer.stats.nextbux.Value)),
                    Duration = 2
                })
            
                if not Options.NextBuxTracker.Value then
                    if IConnections.NextBuxTracker then IConnections.NextBuxTracker:Disconnect() end
                end
            end, "NextBuxTracker")
        end
    end)
  
    local PunchTracker = Tabs.Settings:AddToggle("PunchTracker", { Title = "Punch Tracker", Default = false })
    PunchTracker:OnChanged(function()
        if Options.PunchTracker.Value then
            Tools.Connect(Players.LocalPlayer.stats.punches:GetPropertyChangedSignal('Value'), function()
                if Players.LocalPlayer.stats.punches.Value < OldPValue + 80 then return end
                
                OldPValue = Players.LocalPlayer.stats.punches.Value
                
                task.wait(.2)
               
                Fluent:Notify({
                    Title = "Punch Tracker!",
                    Content = string.format("%s", Tools.FormatNumber(Players.LocalPlayer.stats.punches.Value)),
                    Duration = 2
                })

                if not Options.PunchTracker.Value then
                    if IConnections.PunchTracker then IConnections.PunchTracker:Disconnect() end
                end
            end, "PunchTracker")
        end
    end)
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "Loaded!",
    Content = string.format("Successfully loaded %s!", Settings.Title),
    Duration = 5
})
