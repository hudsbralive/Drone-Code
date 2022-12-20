local tool = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local startUp = ReplicatedStorage:WaitForChild("DroneEvents"):WaitForChild("StartUp")
local controls = ReplicatedStorage:WaitForChild("DroneEvents"):WaitForChild("Controls")
local player = game.Players.LocalPlayer
local cameraSetup = ReplicatedStorage:WaitForChild("DroneEvents"):WaitForChild("CameraSetup")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local setUp
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera


tool.Equipped:Connect(function()
	player.PlayerGui.DroneXRay.Frame.Visible = true
	char:FindFirstChild("Humanoid").WalkSpeed = 0
	local hrpPosition = Vector3.new(hrp.Position.X - 3, hrp.Position.Y + 7, hrp.Position.Z - 3)
	startUp:FireServer(hrpPosition, "Create")
	
	if char:FindFirstChild(tool.Name) then
			
	uis.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.W then
			controls:FireServer("Forward")
		elseif input.KeyCode == Enum.KeyCode.S then
			controls:FireServer("Backwards")
		elseif input.KeyCode == Enum.KeyCode.A then
			controls:FireServer("Left")
		elseif input.KeyCode == Enum.KeyCode.D then
			controls:FireServer("Right")
		elseif input.KeyCode == Enum.KeyCode.E then
			controls:FireServer("Up")
		elseif input.KeyCode == Enum.KeyCode.Q then
				controls:FireServer("Down")
		elseif input.KeyCode == Enum.KeyCode.F then
			local mouse = player:GetMouse()
			controls:FireServer("SetTermination", mouse.Hit.LookVector)
		end
	end)
	
	
	uis.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.W then
			controls:FireServer("Stop")
		elseif input.KeyCode == Enum.KeyCode.S then
			controls:FireServer("StopBack")
		elseif input.KeyCode == Enum.KeyCode.A then
			controls:FireServer("StopRotation")
		elseif input.KeyCode == Enum.KeyCode.D then
			controls:FireServer("StopRotation")
		elseif input.KeyCode == Enum.KeyCode.E then
			controls:FireServer("StopUp")
		elseif input.KeyCode == Enum.KeyCode.Q then
				controls:FireServer("StopDown")
			end
			
	end)
end
end)

cameraSetup.OnClientEvent:Connect(function(cam)
	
	camera.CameraType = Enum.CameraType.Scriptable
	
	local function cameraUpdate()
		camera.CFrame = cam.CFrame
	end
	
	runService:BindToRenderStep("CameraUpdate", Enum.RenderPriority.Camera.Value, cameraUpdate)
	
end)

tool.Unequipped:Connect(function()
	char:FindFirstChild("Humanoid").WalkSpeed = 16
	player.PlayerGui.DroneXRay.Frame.Visible = false
	startUp:FireServer("Blah", "Terminate")
	runService:UnbindFromRenderStep("CameraUpdate")
	camera.CameraType = Enum.CameraType.Custom
end)
