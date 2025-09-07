local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local trailRemote = ReplicatedStorage:WaitForChild("Trail")
local tran = ReplicatedStorage:WaitForChild("Main"):WaitForChild("Transparency")

local parts = {
    "RightZipper","Union","helmet","otherballs","otherballsrarm",
    "zipper","zippermang","Stand Left Arm","Stand Left Leg",
    "Stand Right Arm","Stand Right Leg","o","smallzip","smallzip1",
    "bigzip","Cone"
}

local function setupCharacter(char)
    local stand = char:WaitForChild("Stand")
    
if player.Data:WaitForChild("Stand").Value ~= 34 then
    return
end

    task.spawn(function()
        while char.Parent do  -- stops if char is destroyed
            task.wait(0.1)
            pcall(function()
                local leftTrail = stand:WaitForChild("Stand Left Arm"):WaitForChild("Trail")
                local rightTrail = stand:WaitForChild("Stand Right Arm"):WaitForChild("Trail")
                local cool = stand:WaitForChild("Stand Right Arm"):WaitForChild("cool")

                trailRemote:FireServer(leftTrail, true)
                trailRemote:FireServer(rightTrail, true)
                trailRemote:FireServer(cool, false)
            end)
        end
    end)

    -- Transparency loop
    task.spawn(function()
        while char.Parent do
            task.wait(0.1)
            for _, obj in ipairs(stand:GetChildren()) do
                for _, name in ipairs(parts) do
                    if obj.Name == name then
                        local args = { obj, 1 }
                        tran:FireServer(unpack(args))
                    end
                end
            end
        end
    end)
end


if plr.Character then
    setupCharacter(plr.Character)
end

-- Re-run on respawn
plr.CharacterAdded:Connect(setupCharacter)
