extends Camera3D

@onready var RayCast: RayCast3D = $RayCast

## CONFIG

# Base config
@export var FocusObject: Node3D

# Position config
@export var Offset: Vector3 = Vector3(0, 0, 10)
@export var Pitch: float = 0.0
@export var Yaw: float = 0.0
@export var MaxPitch: int = 89
@export var MinPitch: int = -89

# Mouse config
@export var FollowMouse: bool = true
@export var Sensitivity: float = 1.0

# Private config
var MouseInputBuffer: Vector2 = Vector2.ZERO

## FUNCTION
func get_wall_position(originPos: Vector3, targetPos: Vector3):
	RayCast.global_position = originPos
	RayCast.target_position = targetPos
	
	RayCast.force_raycast_update()
	if RayCast.is_colliding() == false:
		return null
	
	return RayCast

## MAIN
func _process(delta: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Yaw = wrapf(Yaw - (MouseInputBuffer.x * Sensitivity), -180, 180)
	Pitch = clamp(Pitch - (MouseInputBuffer.y * Sensitivity), MinPitch, MaxPitch)
	
	MouseInputBuffer = Vector2.ZERO
	var focusPos = FocusObject.global_position if is_instance_valid(FocusObject) else Vector3.ZERO
	var lookVector = Vector3(Pitch, Yaw, 0)
	var lookVectorRad = Vector3(deg_to_rad(Pitch), deg_to_rad(Yaw), 0)
	
	# Get position vector based on direction
	var rotationQuat = Quaternion.from_euler(lookVectorRad)
	var desiredCameraPos = rotationQuat * Offset
		
	var result: RayCast3D = get_wall_position(focusPos, desiredCameraPos)
	if result is RayCast3D:
		var wallPos = result.get_collision_point()
		var wallNormal = result.get_collision_normal()
		
		self.global_position = wallPos + (wallNormal * 0.05)
	else:
		self.global_position = focusPos + desiredCameraPos

	self.rotation_degrees = lookVector
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if Offset.length() <= 0:
				return
			Offset -= Vector3(0, 0, 1 * Sensitivity)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Offset += Vector3(0, 0, 1 * Sensitivity)
		return
	if not (event is InputEventMouseMotion):
		return
	
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	MouseInputBuffer = event.relative
	
	
