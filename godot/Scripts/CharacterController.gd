extends CharacterBody3D

@export var Camera: Camera3D
@export var MoveSpeed: float = 16
@export var JumpPower: float = 5.0
@export var GravityFactor: float = 2.5

func _physics_process(delta: float) -> void:
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
	
	var inputDir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var moveDir := (forwardVector * inputDir.y + rightVector * inputDir.x).normalized() * MoveSpeed
	
	self.velocity.x = moveDir.x
	self.velocity.z = moveDir.z
	
	# Fall
	var gravity: Vector3 = self.get_gravity()
	if self.velocity.y < 0:
		# Falling
		# Add gravity with extra fall speed
		self.velocity += gravity * GravityFactor * delta
	else:
		# Jumping
		# Add gravity so we are pulled down
		# after a while
		self.velocity += gravity * delta
	
	print(gravity)
	
	self.rotation_degrees.y = yaw
	
	self.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not Input.is_action_just_pressed("Jump"):
		return
	
	if not self.is_on_floor():
		return
	
	self.velocity.y = JumpPower;
