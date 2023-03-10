local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local BridgeNet = require(Packages.BridgeNet)

local SoundController = {
    bridge_PlaySound = BridgeNet.CreateBridge("PlaySound")
}

function SoundController:OnStart()
    self.bridge_PlaySound:Connect(function(...)
        self:PlaySound(...)
    end)
end

function SoundController:PlaySound(soundName)
	local sound = ReplicatedStorage.Sounds:FindFirstChild(soundName, true)
	if sound then
		SoundService:PlayLocalSound(sound)
	end
end

return SoundController