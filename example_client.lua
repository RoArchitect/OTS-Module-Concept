-- << Defined >> --
local OTS = require(game:GetService("ReplicatedStorage"):WaitForChild("OTS"));
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local RootPart = script.Parent.Parent:WaitForChild('HumanoidRootPart')
local LocalPlayer = Players.LocalPlayer
local Character = script.Parent.Parent
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local OTS_HUD = PlayerGui:WaitForChild("OTS_HUD")
local Cursor = OTS_HUD:WaitForChild("Cursor")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TweenInfoCursor = TweenInfo.new(0.4)

local Enabled = false
local Gun;

-- << Main System >> --

local OTSSystem = OTS.new(Camera)

Character.ChildAdded:Connect(function(child)
	if child:GetAttribute("IsGun") then
		TweenService:Create(Cursor , TweenInfoCursor , { ImageTransparency = 0 }):Play()
		
		Gun = child
	else end
end)

Character.ChildRemoved:Connect(function(child)
	if child:GetAttribute("IsGun") then
		TweenService:Create(Cursor , TweenInfoCursor , { ImageTransparency = 1 }):Play()

		Gun = nil
	else end
end)

-- << Functions >> --

local Binds = {
	[Enum.UserInputType.MouseButton2] = function() -- [AIMING]
		if OTSSystem._aiming then
			OTSSystem:UnAim()
		else
			OTSSystem:Aim()
		end
	end,
}

local function SyncHeights(p0, p1)
	local Flat = Vector3.new(1, 0, 1)
	return p0 * Flat, p1 * Flat
end

local function Update()
	local TargetPosition = Camera.CFrame.Position + (Camera.CFrame.LookVector * LocalPlayer.CameraMaxZoomDistance * 2)
	local LookerFrame = CFrame.lookAt(SyncHeights(RootPart.Position, TargetPosition))
	local Frame = LookerFrame - LookerFrame.Position + RootPart.Position

	RootPart.CFrame = Frame
end

-- << Connections & Core >> --

UserInputService.InputBegan:Connect(function(Input,GP)
	if GP then return end
	if not Gun then return end
	
	if Binds[Input.UserInputType] then Binds[Input.UserInputType]() end
end)

UserInputService.InputEnded:Connect(function(Input,GP)
	if GP then return end
	if not Gun then return end
	
	if Binds[Input.UserInputType] then Binds[Input.UserInputType]() end
end)

local Camera do
	while not Workspace.CurrentCamera do
		Workspace.Changed:Wait()
	end

	Camera = Workspace.CurrentCamera
end

task.spawn(function()
	while task.wait() do
		if Gun and not Enabled then Enabled = true OTSSystem:NoEffect() end
		if not Gun and Enabled == true then Enabled = false OTSSystem:Disable() end
		if OTSSystem._aiming and Gun and Enabled then Update() end
	end
end)
