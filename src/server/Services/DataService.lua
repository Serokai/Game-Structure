local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local ProfileService = require(Packages.ProfileService)
local BridgeNet = require(Packages.BridgeNet)
local Signal = require(Packages.Signal)

local ProfileStore = ProfileService.GetProfileStore(
    "PlayerData_5",
    {
		Goldys = 0,
		GangCalls = 0
    }
)

local DataService = {
    Profiles = {},
	ProfileLoad = Signal.new(),
    bridge_ProfileLoad = BridgeNet.CreateBridge("ProfileLoad"),
	bridge_DataSet = BridgeNet.CreateBridge("DataSet"),
	bridge_GetData = BridgeNet.CreateBridge("GetData")
}

local function leaderboardSetup(player, profile)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local goldys = Instance.new("NumberValue")
	goldys.Name = "Goldys"
	goldys.Value = profile.Data.Goldys
	goldys.Parent = leaderstats
end

function DataService:GetData(player, data)
	local profile = self.Profiles[player]
	if profile then
		return profile.Data[data]
	end
end

function DataService:SetData(player, data, value)
	self.Profiles[player].Data[data] = value
	self.bridge_DataSet:FireTo(player, data, value)

	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local stat = leaderstats:FindFirstChild(data)
		if stat then
			stat.Value = value
		end
	end
end

function DataService:OnStart()
	local function onPlayerAdded(player)
		local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
		if profile ~= nil then
			profile:AddUserId(player.UserId)
			profile:Reconcile()
			profile:ListenToRelease(function()
				self.Profiles[player] = nil
				player:Kick()
			end)
			if player:IsDescendantOf(Players) == true then
				self.Profiles[player] = profile
				leaderboardSetup(player, profile)
				--ProfileStore:WipeProfileAsync("Player_" .. player.UserId)
				self.ProfileLoad:Fire(player, profile.Data)
                self.bridge_ProfileLoad:FireTo(player, profile.Data)
			else
				profile:Release()
			end
		else
			player:Kick()
		end
	end

	local function onPlayerRemoving(player)
		local profile = DataService.Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end

	local function onClose()
		if RunService:IsStudio() then
			return
		end

		for _, player in pairs(Players:GetPlayers()) do
			task.spawn(onPlayerRemoving(player))
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		task.defer(onPlayerAdded, player)
	end

    self.bridge_GetData:OnInvoke(function(...)
		return self:GetData(...)
	end)

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
	game:BindToClose(onClose)
end

return DataService