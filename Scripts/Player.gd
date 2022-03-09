extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14
# Vertical impulse applied to the character upon jumping in meters per second.
export var jump_impulse = 20
# Vertical impulse applied to the character upon bouncing over a mob in meters per second.
export var bounce_impulse = 16
# The downward acceleration when in the air, in meters per second per second.
export var fall_acceleration = 75

var velocity = Vector3.ZERO

var cameraRY = .0
var cameraRX = .0

var respawn = Vector3(0, 1, 0)

func _physics_process(delta):
	rotation_degrees.y -= cameraRY
	if($RotationX.rotation_degrees.x - cameraRX > -90 && $RotationX.rotation_degrees.x - cameraRX < 0):
		$RotationX.rotation_degrees.x -= cameraRX
	cameraRY = .0
	cameraRX = .0
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1 * cos(rotation.y)
		direction.z -= 1 * sin(rotation.y)
	if Input.is_action_pressed("left"):
		direction.x += -1 * cos(rotation.y)
		direction.z -= -1 * sin(rotation.y)
	if Input.is_action_pressed("down"):
		direction.x += 1 * sin(rotation.y)
		direction.z += 1 * cos(rotation.y)
	if Input.is_action_pressed("up"):
		direction.x += -1 * sin(rotation.y)
		direction.z += -1 * cos(rotation.y)

	if direction != Vector3.ZERO:
		# In the lines below, we turn the character when moving and make the animation play faster.
		direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse

	# We apply gravity every frame so the character always collides with the ground when moving.
	# This is necessary for the is_on_floor() function to work as a body can always detect
	# the floor, walls, etc. when a collision happens the same frame.
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if translation.y < -5:
		translation = respawn

func _input(event):
	if event is InputEventMouseMotion:
		cameraRY += event.relative.x
		cameraRX += event.relative.y/2

func _on_CheckPoint_body_entered(coord):
	respawn = coord + Vector3.UP * 2
	print(coord)
