-- Wait for 10 seconds before running the rest of the script
wait(10)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Corrected path to BossBattle NPCs
local bossBattleFolder = game:GetService("Workspace").Entities.NPC.BossBattle

-- Equip the weapon first
local equipArgs = {
    [1] = "Equipped",
    [2] = "Imperial Fang"
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Player"):WaitForChild("Combat"):WaitForChild("WeaponsRemote"):FireServer(unpack(equipArgs))

-- Wait 1 second before unequipping the weapon
wait(1)

-- Unequip the weapon after 1 second
local unequipArgs = {
    [1] = "Unequipped",
    [2] = "Imperial Fang"
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Player"):WaitForChild("Combat"):WaitForChild("WeaponsRemote"):FireServer(unpack(unequipArgs))

-- Function for the farmer loop (M1 event)
getgenv().farmer2 = true
task.spawn(function()
    while wait(0.1) do
        if getgenv().farmer2 == true then
            local args = {
                [1] = "M1"
            }

            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Weapons"):WaitForChild("SwordRemote"):FireServer(unpack(args))
        end
    end
end)

-- Function to teleport the character behind a given NPC
local function teleportBehindNpc(npc)
    -- Make sure the NPC has a HumanoidRootPart or PrimaryPart
    local npcRootPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("PrimaryPart")
    
    -- Skip if NPC is missing its root part or is invalid
    if not npcRootPart then
        warn("NPC " .. npc.Name .. " does not have a valid root part or is invalid.")
        return
    end

    -- Get the direction behind the NPC (opposite of where the NPC is facing)
    local directionBehind = -npcRootPart.CFrame.LookVector

    -- Position the player slightly behind the NPC (adjust distance as needed)
    local behindPosition = npcRootPart.Position + directionBehind * 5  -- You can adjust the 5 to make it closer or farther

    -- Teleport the character to the behind position
    humanoidRootPart.CFrame = CFrame.new(behindPosition)

    -- Optionally: Make the character face the NPC (turn towards the NPC)
    humanoidRootPart.CFrame = CFrame.new(behindPosition, npcRootPart.Position)
end

-- Loop through the NPCs in BossBattle and teleport behind them
for _, npc in ipairs(bossBattleFolder:GetChildren()) do
    -- Ensure the NPC is valid and not a non-NPC object (like a model or irrelevant part)
    if npc:IsA("Model") and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("PrimaryPart")) then
        teleportBehindNpc(npc)
        wait(1)  -- Wait 1 second before teleporting to the next NPC
    end
end

-- Wait 2 seconds after the teleportation sequence to fire the "Again" event
wait(2)

-- Fire the "Again" event after the 2-second delay
local args = {
    [1] = "Again"
}

game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Player"):WaitForChild("Inheritance"):FireServer(unpack(args))
