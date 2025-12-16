class_name Guard extends CharacterBody3D

## How fast the player accellerates in meters per second
const MOVEMENT_ACCELLERATION:float = 10
## How fast the player stops or changes direction in meters per second
const MOVEMENT_DECELLERATION:float = 30
## Top speed in meters per second
const TOP_SPEED:float = 3
const WALK_SPEED:float = TOP_SPEED * .3
## how fast the player turns around in... radians per second?
const ROTATION_SPEED:float = 10
const WALKING_ROTATION_SPEED:float = 4

var walking:bool = true
@onready var gravity:Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector") * ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var detection_area:DetectionArea = find_child("DetectionArea")
@onready var navigation_agent:NavigationAgent3D = find_child("NavigationAgent3D")
@onready var door_raycast:RayCast3D = find_child("DoorRaycast")
@onready var path:GuardPath = find_child("GuardPath")
var last_door_opened:Door
## Velocity on just the gameplay plane.
var flat_velocity:Vector2:
	get:
		return Tools.flatten(velocity)
	set(new):
		velocity.x = new.x
		velocity.z = new.y

## Current speed of the guard in the gameplay plane.
var speed:float:
	get:
		return flat_velocity.length()
		
var _wait_tween:Tween
var waiting:bool:
	get:
		return _wait_tween and _wait_tween.is_running()

func _ready() -> void:
	navigation_agent.path_desired_distance = 0.6
	navigation_agent.target_desired_distance = 0.5
	detection_area.spotted.connect(func(body:Node3D) -> void:
		walking = false
		navigation_agent.target_position = body.global_position
		AlertManager.increase_alert()
	)

func _physics_process(delta:float) -> void:
	if walking:
		navigation_agent.target_position = path.get_target(global_position)
		
	var input_dir:Vector2 = _get_target_direction()
	if not input_dir.is_zero_approx():
		_handle_movement(input_dir, delta)
	else:
		flat_velocity = flat_velocity.move_toward(Vector2.ZERO, delta * MOVEMENT_DECELLERATION)
	
	var top_speed:float = WALK_SPEED if walking else TOP_SPEED
	if speed > top_speed:
		flat_velocity = flat_velocity.normalized() * top_speed
		
	move_and_slide()
	if last_door_opened:
		var flat_basis:Vector2 = Vector2(basis.z.x, basis.z.z) 
		var local_position:Vector2 = Tools.flatten(global_position.direction_to(last_door_opened.global_position))
		var direction:float = flat_basis.dot(local_position)
		if global_position.distance_squared_to(last_door_opened.global_position) < 1:
			return
		if direction >= 0:
			return
		print("Closing")
		last_door_opened.close()
		last_door_opened = null
		_wait_tween = create_tween()
		_wait_tween.tween_interval(.5)

func _get_target_direction() -> Vector2:
	var current_agent_position: Vector3 = global_position
	
	if navigation_agent.is_navigation_finished():
		if not path:
			return Vector2.ZERO
			
		walking = true
		var new_target_position:Vector3 = path.get_target(current_agent_position)
		if not navigation_agent.target_position.is_equal_approx(new_target_position):
			navigation_agent.target_position = path.get_target(current_agent_position)
		
	if not navigation_agent.is_target_reachable():
		_try_open_door()
		return Vector2.ZERO
	
	if waiting:
		return Vector2.ZERO
	var next_path_position:Vector3 = navigation_agent.get_next_path_position()
	return Tools.flatten(current_agent_position.direction_to(next_path_position)) * Vector2(1,-1)

func _handle_movement(input:Vector2, delta:float) -> void:
	var angle = input.angle() + PI/2
	var flat_basis:Vector2 = Vector2(basis.z.x, basis.z.z)
	var dot:float = input.dot(flat_basis * Vector2(1,-1))
	rotation.y = rotate_toward(rotation.y, angle, (WALKING_ROTATION_SPEED if walking else ROTATION_SPEED) * delta * max(.4, 1.0-dot))
	velocity += basis.z * input.length() * MOVEMENT_ACCELLERATION * delta * dot
	flat_velocity = flat_velocity.move_toward(flat_basis * speed, delta * MOVEMENT_DECELLERATION)

func _try_open_door() -> void:
	if not door_raycast.is_colliding():
		return
		
	var door:Door = door_raycast.get_collider() as Door
	if not door:
		return
	door.open()
	last_door_opened = door
	_wait_tween = create_tween()
	_wait_tween.tween_interval(.5)
