class_name Player extends CharacterBody3D
const TranslocatorScene:PackedScene = preload("uid://bhrhmup3slvg")
const ThrownTranslocatorScene:PackedScene = preload("uid://b2rowday7qqdn")
## How fast the player accellerates in meters per second
const MOVEMENT_ACCELLERATION:float = 10
## How fast the player stops or changes direction in meters per second
const MOVEMENT_DECELLERATION:float = 30
## Top speed in meters per second
const TOP_SPEED:float = 3
## how fast the player turns around in... radians per second?
const ROTATION_SPEED:float = 10

## Velocity on just the gameplay plane.
var flat_velocity:Vector2:
	get:
		return Tools.flatten(velocity)
	set(new):
		velocity.x = new.x
		velocity.z = new.y

## Current speed of the player in the gameplay plane.
var speed:float:
	get:
		return flat_velocity.length()

@onready var gravity:Vector3 = get_gravity()
@onready var interaction_area:Area3D = find_child("InteractionArea")
var translocator:Translocator
var thrown_translocator:ThrownTranslocator

func _physics_process(delta: float) -> void:
	
	# Handle movement input, slow down when nothing is pressed.
	var input_dir := Input.get_vector("move_west", "move_east", "move_south", "move_north")
	if not input_dir.is_zero_approx():
		_handle_movement(input_dir, delta)
	else:
		flat_velocity = flat_velocity.move_toward(Vector2.ZERO, delta * MOVEMENT_DECELLERATION)
	
	# Don't allow the player to speed up infinitely.
	if speed > TOP_SPEED:
		flat_velocity = flat_velocity.normalized() * TOP_SPEED
	
	if translocator:
		if Input.is_action_just_pressed("activate_translocator"):
			_translocate()
	elif not thrown_translocator:
		if Input.is_action_just_pressed("place_translocator"):
			_place_translocator(global_position)
		if Input.is_action_just_pressed("throw_translocator"):
			_throw_translocator()
	
	if Input.is_action_just_pressed("interact"):
		_interact()
	# Actually move!
	move_and_slide()

func _handle_movement(input:Vector2, delta:float) -> void:
	var angle = input.angle() + PI/2
	var flat_basis:Vector2 = Vector2(basis.z.x, basis.z.z)
	var dot:float = input.dot(flat_basis * Vector2(1,-1))
	rotation.y = rotate_toward(rotation.y, angle, ROTATION_SPEED * delta * max(.4, 1.0-dot))
	velocity += basis.z * input.length() * MOVEMENT_ACCELLERATION * delta * dot
	flat_velocity = flat_velocity.move_toward(flat_basis * speed, delta * MOVEMENT_DECELLERATION)
	
func _place_translocator(g_position:Vector3) -> void:
	translocator = TranslocatorScene.instantiate() as Translocator
	add_child(translocator)
	translocator.global_position = g_position

func _throw_translocator() -> void:
	thrown_translocator = ThrownTranslocatorScene.instantiate() as ThrownTranslocator
	add_child(thrown_translocator)
	thrown_translocator.global_position = global_position + Vector3(0,1,0)
	thrown_translocator.linear_velocity = basis.z * 10
	thrown_translocator.landed.connect(func(g_position:Vector3):
		_place_translocator(g_position)
		_translocate()
	)

func _translocate() -> void:
	#@warning_ignore("incompatible_ternary")
	#var teleport_node:Node3D = translocator if translocator else thrown_translocator
	global_position = translocator.global_position
	translocator.queue_free()

func _interact() -> void:
	var areas:Array[Area3D] = interaction_area.get_overlapping_areas()
	for area:Area3D in areas:
		var door:Door = area as Door
		if not door:
			return
		door.interact()
