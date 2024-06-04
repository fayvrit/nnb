
local stats = game:GetService("Players").LocalPlayer.stats
local remote = game:GetService("ReplicatedStorage").events.player["local"].punch

local oldPValue = stats.punches.Value
local oldNValue = stats.nextbux.Value

local Link = "https://raw.githubusercontent.com/fayvrit/Qeto/main/Tools.lua"
local Tools = loadstring(game:HttpGet(Link))()

if getgenv().Stats then
    if Stats.Noti and Stats.ScreenUI and Stats.loop and Stats.display1 and Stats.display2 then
        Stats.Noti = nil

        Stats.ScreenUI:Destroy()
        Stats.loop:Disconnect()
        Stats.display1:Disconnect()
        Stats.display2:Disconnect()
    end
end

getgenv().Stats = {}
Stats.text1 = '<font color="rgb(207,159,255)">%s</font> Nextbuxes'
Stats.text2 = '<font color="rgb(233,189,56)">%s</font> Punches'

Stats.ScreenUI = Instance.new("ScreenGui") do
    Stats.ScreenUI.Name = "ScreenUI"
    Stats.ScreenUI.IgnoreGuiInset = true
    Stats.ScreenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Stats.ScreenUI.Parent = game.CoreGui    
end

Stats.Noti = Tools.notification{Parent = Stats.ScreenUI}

Stats.loop = game:GetService("RunService").Heartbeat:Connect(function()
    remote:FireServer()
    task.wait()
end)

Stats.display1 = stats.nextbux:GetPropertyChangedSignal('Value'):Connect(function()
    if stats.nextbux.Value < oldNValue + 40 then return end
    oldNValue = stats.nextbux.Value

    task.wait(.2)
    Stats.Noti.Message{
        Message = Stats.text1:format(Tools.FormatNumber(stats.nextbux.Value))
        Duration = 3
    }
end)

Stats.display2 = stats.punches:GetPropertyChangedSignal('Value'):Connect(function()
    if stats.punches.Value < oldPValue + 80 then return end
    oldPValue = stats.punches.Value

    task.wait(.2)
    Stats.Noti.Message{
        Message = Stats.text2:format(Tools.FormatNumber(stats.punches.Value))
        Duration = 2
    }
end)
