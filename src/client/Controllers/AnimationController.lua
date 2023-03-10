local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local BridgeNet = require(Packages.BridgeNet)

local Modules = ReplicatedStorage.Modules
local Configuration = require(Modules.Configuration)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local AnimationController = {
    Animations = {},
    bridge_PlayAnimation = BridgeNet.CreateBridge("PlayAnimation")
}

function AnimationController:OnStart()
    self:_Setup(character)
    player.CharacterAdded:Connect(function(...)
        self:_Setup(...)
    end)

    self.bridge_PlayAnimation:Connect(function(animationName)
        local animation = self.Animations[animationName]
        if animation then
            animation:Play()
        end
    end)
end

function AnimationController:_Setup(characterToSetup)
    local humanoid = characterToSetup:WaitForChild("Humanoid")
    for name, animationId in pairs(Configuration.PlayerAnimations) do
        local animation = Instance.new("Animation")
        animation.Name = name
        animation.AnimationId = "rbxassetid://" .. animationId
        animation.Parent = humanoid
        self.Animations[name] = humanoid:WaitForChild("Animator"):LoadAnimation(animation)
    end
end

return AnimationController