local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local trailRemote = ReplicatedStorage:WaitForChild("Trail")
local tran = ReplicatedStorage:WaitForChild("Main"):WaitForChild("Transparency")

local WALK_ID = 113501364545554
local IDLE_TOP_ID = 7041936950
local IDLE_BOTTOM_ID = 7037920924
local B1_ID = 12968759745
local B2_ID = 12968763209

local parts = {
    "RightZipper","Union","helmet","otherballs","otherballsrarm",
    "zipper","zippermang","Stand Left Arm","Stand Left Leg",
    "Stand Right Arm","Stand Right Leg","o","smallzip","smallzip1",
    "bigzip","Cone"
}

local function createAnim(id)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(id)
    return anim
end

local function setupCharacter(char)
    if not char then return end

    local data = plr:WaitForChild("Data")
    local standValue = data:WaitForChild("Stand")
    if standValue.Value ~= 34 then return end

    local stand = char:WaitForChild("Stand")
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    local idleTopTrack = hum:LoadAnimation(createAnim(IDLE_TOP_ID))
    local idleBottomTrack = hum:LoadAnimation(createAnim(IDLE_BOTTOM_ID))
    local walkTrack = hum:LoadAnimation(createAnim(WALK_ID))
    local bTrack1 = hum:LoadAnimation(createAnim(B1_ID))
    local bTrack2 = hum:LoadAnimation(createAnim(B2_ID))

    idleBottomTrack.Priority = Enum.AnimationPriority.Idle
    walkTrack.Priority = Enum.AnimationPriority.Movement
    idleTopTrack.Priority = Enum.AnimationPriority.Action
    bTrack1.Priority = Enum.AnimationPriority.Action
    bTrack2.Priority = Enum.AnimationPriority.Action

    idleBottomTrack:Play()

    local bPlaying = false
    local bConn

    hum.Running:Connect(function(speed)
        if speed > 0 then
            if idleTopTrack.IsPlaying then idleTopTrack:Stop() end
            if not walkTrack.IsPlaying then walkTrack:Play() end
        else
            if walkTrack.IsPlaying then walkTrack:Stop() end
            if not idleTopTrack.IsPlaying then idleTopTrack:Play() end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.B then
            if bPlaying then
                bPlaying = false
                bTrack1:Stop()
                bTrack2:Stop()
                if bConn then bConn:Disconnect() bConn = nil end
            else
                bPlaying = true
                bTrack1:Play()
                bConn = bTrack1.Stopped:Connect(function()
                    if bPlaying then bTrack2:Play() end
                end)
            end
        end
    end)

    task.spawn(function()
        while char.Parent do
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
