local ReplicatedStorage = game:GetService("ReplicatedStorage")
local startUp = ReplicatedStorage:WaitForChild("DroneEvents"):WaitForChild("StartUp")
local controls = ReplicatedStorage:WaitForChild("DroneEvents"):WaitForChild("Controls")
local SSS = game:GetService("ServerScriptService")
local droneModule = require(SSS:WaitForChild("DroneSystem"):WaitForChild("DroneHandler"))
local playerFuncs = {}

startUp.OnServerEvent:Connect(function(plr, position, method)
	if method == "Create" then
		local drone = game.ServerStorage.DroneAssets.DroneModel:Clone()
		playerFuncs[plr.Name] = droneModule.new(plr, drone, position)
	elseif method == "Terminate" then
		playerFuncs[plr.Name].Drone:Destroy()
		table.remove(playerFuncs[plr.Name])
	end
	
end)


controls.OnServerEvent:Connect(function(plr, method, method2)
	
	if method == "Forward" or method == "Stop" then
		playerFuncs[plr.Name]:Forward(plr.Name, method)
	elseif method == "Backwards" or method == "StopBack" then
		playerFuncs[plr.Name]:Backwards(plr.Name, method)
	elseif method == "Left" or method == "Right" or method == "StopRotation" then
		playerFuncs[plr.Name]:Rotate(plr.Name, method)
	elseif method == "Up" or method == "StopUp" or method == "Down" or method == "StopDown" then
		playerFuncs[plr.Name]:Elevation(plr.Name, method)
	elseif method == "SetTermination" then
		playerFuncs[plr.Name]:FireRay(plr, method2)
	end
	
end)
