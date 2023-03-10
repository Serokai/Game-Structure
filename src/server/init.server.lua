local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Packages = ReplicatedStorage.Packages
local Loader = require(Packages.Loader)

for _, screenGui in ipairs(StarterGui:GetChildren()) do
	screenGui.Parent = ReplicatedStorage.Interface.Replicated
end

Loader.SpawnAll(
	Loader.LoadDescendants(script.Services, Loader.MatchesName("Service$")),
	"OnStart"
)

Loader.LoadDescendants(script.Components)