local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Packages = ReplicatedStorage.Packages
local BridgeNet = require(Packages.BridgeNet)

local ChatController = {
    bridge_SendMessage = BridgeNet.CreateBridge("SendMessage")
}

function ChatController:OnStart()
    self.bridge_SendMessage:Connect(function(...)
        self:_OnMessageSent(...)
    end)
end

function ChatController:_OnMessageSent(text, color, font)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = text,
        Color = color,
        Font = font,
        TextSize = 18
    })
end

return ChatController