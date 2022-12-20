local droneHandler = {}
local runService = game:GetService("RunService")
local cameraSetup = game.ReplicatedStorage:WaitForChild("DroneEvents"):WaitForChild("CameraSetup")

droneHandler.__index = droneHandler

function droneHandler.new(plr, drone, position)
	local newDrone = {}
	setmetatable(newDrone, droneHandler)
	
	newDrone.Drone = drone
	newDrone.ControlPart = drone.Controller
	newDrone.Camera = newDrone.Drone.Camera
	newDrone.Position = position
	newDrone.Owner = plr.Name
	newDrone.Speed = newDrone.ControlPart.BodyVelocity
	newDrone.TurnSpeed = newDrone.ControlPart.BodyAngularVelocity
	newDrone.Drone.Parent = workspace
	newDrone.Drone:MoveTo(position)
	newDrone.Moving = false
	newDrone.ForwardActive = false
	newDrone.BackwardsActive = false
	newDrone.UpForce = newDrone.ControlPart.UpForce
	newDrone.CurrentlyElevating = false
	cameraSetup:FireClient(plr, newDrone.Camera)
	newDrone.ControlPart:SetNetworkOwner(nil)
	return newDrone
	
end

function droneHandler:Forward(plr, method)
		
		if method == "Forward" and self.Moving == false then
			self.Moving = true
			self.ForwardActive = true
			forwardUpdate = runService.Heartbeat:Connect(function()
				self.Speed.Velocity = Vector3.new(self.ControlPart.CFrame.LookVector.X * 20, 0, self.ControlPart.CFrame.LookVector.Z * 20)
			end)
			
		elseif method == "Stop" then
			forwardUpdate:Disconnect()
			self.Speed.Velocity = Vector3.new(0,0,0)
			self.Moving = false
			self.ForwardActive = false
		end
	end

function droneHandler:Backwards(plr, method)
		if method == "Backwards" and self.Moving == false then
		self.Moving = true
		self.BackwardsActive = true
			BackwardsUpdate = runService.Heartbeat:Connect(function()
			self.Speed.Velocity = Vector3.new(self.ControlPart.CFrame.LookVector.X * -20, 0, self.ControlPart.CFrame.LookVector.Z * -20)
			
			if self.Moving == false then
				BackwardsUpdate:Disconnect()
				self.Speed.Velocity = Vector3.new(0,0,0)
			end
			
			end)

		elseif method == "StopBack" then
		BackwardsUpdate:Disconnect()
		self.BackwardsActive = false
		self.Speed.Velocity = Vector3.new(0,0,0)
		self.Moving = false
		end
	end
	
function droneHandler:Rotate(plr, method)
	
	if method == "Left" then
		self.Moving = true
		self.TurnSpeed.AngularVelocity = Vector3.new(0,2,0)
		
	elseif method == "Right" then
		
		self.Moving = true
		self.TurnSpeed.AngularVelocity = Vector3.new(0,-2,0)
		self.Speed.Velocity = Vector3.new(0,0,0)
		
	elseif method == "StopRotation" then
		
		self.TurnSpeed.AngularVelocity = Vector3.new(0,0,0)
		self.Moving = false
		
	end
	
end

function droneHandler:Elevation(plr, method)
	
	if method == "Up" and self.CurrentlyElevating == false then
		self.CurrentlyElevating = true
		self.UpForce.Velocity = self.ControlPart.CFrame.UpVector * 15
		
	elseif method == "Down" and self.CurrentlyElevating == false then
		self.CurrentlyElevating = true
		self.UpForce.Velocity = self.ControlPart.CFrame.UpVector * -15
	elseif method == "StopUp" then

		self.UpForce.Velocity = Vector3.new(0,0,0)
		self.CurrentlyElevating = false
		
	elseif method == "StopDown" then

		self.UpForce.Velocity = Vector3.new(0,0,0)
		self.CurrentlyElevating = false
	end
	
end

function droneHandler:FireRay(plr, mousePos)
	local raycastResult = workspace:Raycast(self.Camera.Position, mousePos * 20)
	if raycastResult.Instance.Parent:FindFirstChild("Humanoid") and not raycastResult.Instance.Parent:FindFirstChild("IsSCP") then
		local head = raycastResult.Instance.Parent:FindFirstChild("Head")
		game.ServerStorage.DroneAssets.Terminate:Clone().Parent = head
	end
end

return droneHandler
