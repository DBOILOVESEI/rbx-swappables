extends Camera3D

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
var MouseInputBuffer = Vector2.ZERO

## MAIN
func _physics_process(delta: float):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Yaw -= MouseInputBuffer.x * Sensitivity
	Pitch = clamp(Pitch - (MouseInputBuffer.y * Sensitivity), MinPitch, MaxPitch)
	
	MouseInputBuffer = Vector2.ZERO
	
	print(Pitch, Yaw)
	rotation_degrees = Vector3(Pitch, Yaw, 0)
	
	var targetPos = FocusObject.global_position if is_instance_valid(FocusObject) else Vector3.ZERO
	global_position = targetPos + Offset
	
func _unhandled_input(event: InputEvent):
	if not (event is InputEventMouseMotion):
		return
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	MouseInputBuffer = event.relative
