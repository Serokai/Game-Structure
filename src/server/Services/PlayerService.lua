local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local BridgeNet = require(Packages.BridgeNet)

local PlayerService = {
    bridge_SendMessage = BridgeNet.CreateBridge("SendMessage"),
    bridge_PlaySound = BridgeNet.CreateBridge("PlaySound"),
    bridge_PlayAnimation = BridgeNet.CreateBridge("PlayAnimation")
}

function PlayerService:OnStart()
    
end

return PlayerService