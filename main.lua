local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Margad's Simple Scripts",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Simple Exploits",
    Theme = "Dark",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MargadsSimpleScripts",
        FileName = "Settings"
    }
})

local ScriptsTab = Window:CreateTab("Scripts", 1234567890)
local ScriptsSection = ScriptsTab:CreateSection("Simple Scripts")

-- WalkSpeed
ScriptsSection:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
})

-- JumpPower
ScriptsSection:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
    end
})

-- GoTo
ScriptsSection:CreateInput({
    Name = "GoTo Player",
    PlaceholderText = "Enter name...",
    Callback = function(name)
        local target = game.Players:FindFirstChild(name)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
})

-- Fly toggle + speed
local flying = false
local flyspeed = 2

ScriptsSection:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(val)
        flying = val
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local hrp = char:WaitForChild("HumanoidRootPart")

        if val then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyForce"
            bv.MaxForce = Vector3.new(1, 1, 1) * 1e5
            bv.Velocity = Vector3.new()
            bv.Parent = hrp

            task.spawn(function()
                while flying and bv.Parent do
                    bv.Velocity = plr:GetMouse().Hit.LookVector * flyspeed * 10
                    task.wait()
                end
            end)
        else
            if hrp:FindFirstChild("FlyForce") then
                hrp.FlyForce:Destroy()
            end
        end
    end
})

ScriptsSection:CreateSlider({
    Name = "FlySpeed",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(val)
        flyspeed = val
    end
})

-- Noclip
local noclip = false

ScriptsSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(val)
        noclip = val
        game:GetService("RunService").Stepped:Connect(function()
            if noclip then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

ScriptsSection:CreateButton({
    Name = "Unnoclip",
    Callback = function()
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        noclip = false
    end
})

-- ESP
local espParts = {}

ScriptsSection:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(val)
        if val then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local esp = Instance.new("BoxHandleAdornment")
                    esp.Size = Vector3.new(4, 6, 2)
                    esp.Transparency = 0.5
                    esp.Color3 = Color3.new(1, 0, 0)
                    esp.AlwaysOnTop = true
                    esp.ZIndex = 5
                    esp.Adornee = p.Character.HumanoidRootPart
                    esp.Name = "ESPBox"
                    esp.Parent = p.Character
                    table.insert(espParts, esp)
                end
            end
        else
            for _, esp in pairs(espParts) do
                if esp and esp.Parent then
                    esp:Destroy()
                end
            end
            espParts = {}
        end
    end
})

ScriptsSection:CreateButton({
    Name = "UnESP",
    Callback = function()
        for _, esp in pairs(espParts) do
            if esp and esp.Parent then
                esp:Destroy()
            end
        end
        espParts = {}
    end
})
