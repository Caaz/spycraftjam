class_name Player extends CharacterBody3D
## How fast the player accellerates in meters per second
const MOVEMENT_ACCELLERATION:float = 10
## How fast the player stops or changes direction in meters per second
const MOVEMENT_DECELLERATION:float = 30
## Top speed in meters per second
const TOP_SPEED:float = 5
## how fast the player turns around in... radians per second?
const ROTATION_SPEED:float = 20

## Velocity on just the gameplay plane.
var flat_velocity:Vector2:
	get:
		return Vector2(velocity.x, velocity.z)
	set(new):
		velocity.x = new.x
		velocity.z = new.y

## Current speed of the player in the gameplay plane.
var speed:float:
	get:
		return flat_velocity.length()

@onready var gravity:Vector3 = get_gravity()

func _physics_process(delta: float) -> void:
	# Add gravity when we're in the air
	if not is_on_floor():
		velocity += gravity * delta
	
	# Handle movement input, slow down when nothing is pressed.
	var input_dir := Input.get_vector("move_west", "move_east", "move_south", "move_north")
	if not input_dir.is_zero_approx():
		_handle_movement(input_dir, delta)
	else:
		flat_velocity = flat_velocity.move_toward(Vector2.ZERO, delta * MOVEMENT_DECELLERATION)
	
	# Don't allow the player to speed up infinitely.
	if speed > TOP_SPEED:
		flat_velocity = flat_velocity.normalized() * TOP_SPEED
	
	# Actually move!
	move_and_slide()

func _handle_movement(input:Vector2, delta:float) -> void:
	var angle = input.angle() + PI/2
	rotation.y = rotate_toward(rotation.y, angle, ROTATION_SPEED * delta)
	velocity += basis.z * input.length() * MOVEMENT_ACCELLERATION * delta
	var flat_basis = Vector2(basis.z.x, basis.z.z)
	flat_velocity = flat_velocity.move_toward(flat_basis * speed, delta * MOVEMENT_DECELLERATION)
	
