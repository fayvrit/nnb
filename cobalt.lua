-- rit owns ya
print("????")

local Settings = {
  Repo = "https://github.com/dawid-scripts/Fluent",
  Title = "Cobalt",
  SubTitle = "0.0.1",
}

local Fluent = loadstring(game:HttpGet(Settings.Repo .. "/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(Settings.Repo .. "/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(Settings.Repo .. "/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StartTick = tick() 
local Tools = {}

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
    SubTitle = "ritownsya",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Self = Window:AddTab({ Title = "Self", Icon = "" }),
    Game = Window:AddTab({ Title = "Game", Icon = "" })
    Shop = Window:AddTab({ Title = "Shop", Icon = "" })
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "" })
    Auto = Window:AddTab({ Title = "Auto", Icon = "" })
}

local Options = Fluent.Options

do
    Tabs.Self:AddParagraph({
        Title = "Self Info",
        Content = string.format("Name: %s\nDisplay Name: %s\nID: %s\nAccount Age: %s", Players.LocalPlayer.Name, Players.LocalPlayer.DisplayName, Players.LocalPlayer.UserId, Players.LocalPlayer.AccountAge)
    })

    Tabs.Self:AddButton({
        Title = "Reset",
        Description = "Reset your character",
        Callback = function()
            Window:Dialog({
                Title = string.format("%s's Dialog", Settings.Title),
                Content = "Would you like to \"Reset your character?\"",
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

    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)
    
    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)

    Slider:SetValue(3)

    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)

    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)



    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle",
        Default = "LeftControl",

        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,
      
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- example for checking if a keybind is being pressed
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder(Settings.Title)
SaveManager:SetFolder(string.format("%s/NNB", Settings.Title))

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Loaded!",
    Content = string.format("Loaded in %ss", Tick() - StartTick),
    Duration = 5
})

SaveManager:LoadAutoloadConfig()

-- // User Interface End
