class_name Guard extends CharacterBody3D

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
