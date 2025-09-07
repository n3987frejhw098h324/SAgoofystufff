local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local trailRemote = ReplicatedStorage:WaitForChild("Trail")
local tran = ReplicatedStorage:WaitForChild("Main"):WaitForChild("Transparency")

local parts = {
    "Skin","Meshes/6","Stand Head",
    "Stand Torso","Stand Left Arm","Stand Left Leg",
    "Stand Right Arm","Stand Right Leg"
}

local function setupCharacter(char)
    if not char then return end

    local data = plr:WaitForChild("Data")
    local standValue = data:WaitForChild("Stand")
    if standValue.Value ~= 64 or 63 then return end

    local stand = char:WaitForChild("Stand")
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    task.spawn(function()
        while char.Parent do
            task.wait(0.1)
            for _, obj in ipairs(stand:GetChildren()) do
                for _, name in ipairs(parts) do
                    if obj.Name == name then
                        tran:FireServer(obj, 1)
                    end
                end
            end
        end
    end)
end

if plr.Character then
    setupCharacter(plr.Character)
end

plr.CharacterAdded:Connect(setupCharacter)
