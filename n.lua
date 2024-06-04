
local stats = game:GetService("Players").LocalPlayer.stats
local remote = game:GetService("ReplicatedStorage").events.player["local"].punch

local oldPValue = stats.punches.Value
local oldNValue = stats.nextbux.Value

local Link = "https://raw.githubusercontent.com/fayvrit/Qeto/main/Tools.lua"
local Tools = loadstring(game:HttpGet(Link))()

if getgenv().Stats then
    if Stats.Noti and Stats.ScreenUI and Stats.loop1 and Stats.display then
        Stats.Noti = nil

        Stats.ScreenUI:Destroy()
        Stats.loop:Disconnect()
        Stats.display:Disconnect()
    end
end

getgenv().Stats = {}

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

Stats.texts = '<font color="rgb(233,189,56)">%s</font> Punches\n<font color="rgb(207,159,255)">%s</font> Nextbuxes'
Stats.display = stats.punches:GetPropertyChangedSignal('Value'):Connect(function()
    if stats.punches.Value < oldPValue + 50 or stats.nextbux.Value < oldNValue + 40 then return end
    oldValue = stats.punches.Value

    task.wait(.2)
    Stats.Noti.Message{
        Message = Stats.texts:format(Tools.FormatNumber(stats.punches.Value), Tools.FormatNumber(stats.nextbux.Value))
        Duration = 2
    }
end)
