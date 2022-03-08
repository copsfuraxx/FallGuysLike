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

func _physics_process(delta):	
	rotation_degrees.y += cameraRY
	$RotationX.	rotation_degrees.x += cameraRX
	cameraRY = .0
	cameraRX = .0
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("right"):
		var v = Vector3.RIGHT
		rotate(v, $RotationX/Camera.rotation.y)# * PI/180)
		direction += v
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.z += 1
	if Input.is_action_pressed("up"):
		direction.z -= 1

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

func _input(event):
	if event is InputEventMouseMotion:
		cameraRY += event.relative.x
		cameraRX += event.relative.y
		
