extends CharacterBody3D

@export var MoveSpeed: float = 16
@export var Camera: Camera3D

func _physics_process(delta: float) -> void:
	velocity += self.get_gravity() * delta
	
	var forwardVector := Vector3.FORWARD
	var rightVector := Vector3.RIGHT
	var yaw: float
	if Camera and Camera is Camera3D:
		# Camera.transform is fine, since it's not
		# relative to the Character. But still better
		# to use global_transform instead, in case of
		# special situations.
		
		# Flatten CFrame
		var cameraBasis := Camera.global_transform.basis
		
		forwardVector = cameraBasis.z
		forwardVector.y = 0
		
		rightVector = cameraBasis.x
		rightVector.y = 0
		
		yaw = Camera.Yaw
	else:
		yaw = 0
	
	var inputDir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var moveDir := (forwardVector * inputDir.y + rightVector * inputDir.x).normalized() * MoveSpeed
	
	self.velocity.x = moveDir.x
	self.velocity.z = moveDir.z
	
	self.rotation_degrees.y = yaw
	
	self.move_and_slide()
