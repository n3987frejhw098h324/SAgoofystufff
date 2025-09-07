local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local WALK_ID = 113501364545554
local IDLE_TOP_ID = 7041936950
local IDLE_BOTTOM_ID = 7037920924
local B1_ID = 12968759745
local B2_ID = 12968763209

local function createAnim(id)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(id)
    return anim
end

local function setupForCharacter(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

if player.Data:WaitForChild("Stand").Value ~= 34 then
    return
end
    -- animations
    local idleTopTrack = hum:LoadAnimation(createAnim(IDLE_TOP_ID))
    local idleBottomTrack = hum:LoadAnimation(createAnim(IDLE_BOTTOM_ID))
    local walkTrack = hum:LoadAnimation(createAnim(WALK_ID))
    local bTrack1 = hum:LoadAnimation(createAnim(B1_ID))
    local bTrack2 = hum:LoadAnimation(createAnim(B2_ID))

    -- priorities
    idleBottomTrack.Priority = Enum.AnimationPriority.Idle  -- always underneath
    walkTrack.Priority = Enum.AnimationPriority.Movement    -- on top of bottom idle
    idleTopTrack.Priority = Enum.AnimationPriority.Action   -- only when standing
    bTrack1.Priority = Enum.AnimationPriority.Action
    bTrack2.Priority = Enum.AnimationPriority.Action

    -- play bottom idle always
    idleBottomTrack:Play()

    local bPlaying = false
    local bConn

    -- handle walking
    hum.Running:Connect(function(speed)
        if speed and speed > 0 then
            -- stop top idle, play walk
            if idleTopTrack.IsPlaying then idleTopTrack:Stop() end
            if not walkTrack.IsPlaying then walkTrack:Play() end
        else
            -- stopped
            if walkTrack.IsPlaying then walkTrack:Stop() end
            if not idleTopTrack.IsPlaying then idleTopTrack:Play() end
        end
    end)

    -- B toggle
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
                    if bPlaying then
                        bTrack2:Play()
                    end
                end)
            end
        end
    end)
end

local function onChar(char)
    setupForCharacter(char)
end
if player.Character then onChar(player.Character) end
player.CharacterAdded:Connect(onChar)
end
