local OTS = {
	_defaultExtendCF = CFrame.new(2,0,0);
	_aimExtendCF = CFrame.new(2,0,0);   
	
	_cameraMaxZoomDistance = 48;
	_cameraMinZoomDistance = 2;
	
	_aiming = false;
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer

local TweenInfoAim = TweenInfo.new(0.4)

local CameraConnection

function OTS.new(camera) -- using OOP because its optimal
	local Object = {
		_camera = camera;
		_mouse = Player:GetMouse();
	}

	setmetatable(Object , OTS)
	OTS.__index = OTS
	return Object
end

local function CamToDefault()
	game.Workspace.CurrentCamera.CFrame = game.Workspace.CurrentCamera.CFrame
end

function OTS:NoEffect() -- also known as, normal state
	UserInputService.MouseIconEnabled = false

	CameraConnection = RunService:BindToRenderStep("OTS",1000,function(DeltaTime)
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		Player.CameraMinZoomDistance = self._cameraMinZoomDistance
		Player.CameraMaxZoomDistance = self._cameraMaxZoomDistance
		
		if not self._aiming then
			self._camera.CFrame = self._camera.CFrame * self._defaultExtendCF
		else
		    self._camera.CFrame = self._camera.CFrame * self._aimExtendCF
		end
	end)
end

function OTS:Aim()
	self._aiming = true

	local AimTween = TweenService:Create(
		self._camera,
		TweenInfoAim,
		{FieldOfView = 58}
	)
	AimTween:Play()
end 

function OTS:UnAim()
	self._aiming = false

	local AimTween = TweenService:Create(
		self._camera,
		TweenInfoAim,
		{FieldOfView = 70}
	)
	AimTween:Play()
end

local HasWarned = false
function OTS:Disable() -- when unequipped	
	self._aiming = false;
	self:UnAim()
	
	UserInputService.MouseIconEnabled = true
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	RunService:UnbindFromRenderStep("OTS")
	CamToDefault()
end

return OTS
