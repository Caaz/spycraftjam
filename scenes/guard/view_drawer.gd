@tool class_name ViewDrawer extends Node3D
@export var arc:float = 1.:
	set(new):
		arc = clamp(new, 0, 1)
		_update_raycasts()

@export var radius:float = 5:
	set(new):
		radius = clamp(new, .1, 10)
		_update_raycasts()

@export var ray_count:int = 16:
	set(new):
		ray_count = clamp(new, 3, 36)
		_update_raycasts()

@warning_ignore("unused_private_class_variable")
@export_tool_button("Create Mesh") var __create_mesh = _update_shape

@warning_ignore("unused_private_class_variable")
@export_tool_button("Update Raycasts") var __update_raycasts = _update_raycasts

@onready var polygon:Polygon2D = find_child("Polygon2D")

var tick:float = 0
const UPDATE_RATE:float = 0
const SCALE_2D:float = 50

func _ready() -> void:
	_update_raycasts()
func _process(delta: float) -> void:
	tick += delta
	if tick > UPDATE_RATE:
		tick = 0
		_update_shape()

func _update_raycasts():
	if not is_node_ready():
		return
	
	for child in get_children():
		var raycast:RayCast3D = child as RayCast3D
		if not raycast:
			continue
		child.queue_free()
	
	for point:int in range(ray_count + 1):
		var radian:float = (float(point) / float(ray_count)) * (PI * 2 * arc) - (PI * 2 * arc)/2
		var raycast:RayCast3D = RayCast3D.new()
		var direction:Vector2 = Vector2.from_angle(radian)
		add_child(raycast)
		raycast.target_position = Vector3(direction.x, 0, direction.y) * radius
		#raycast.owner = get_tree().edited_scene_root
		raycast.collision_mask = 0b10
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	_update_shape()
	
func _update_shape() -> void:
	if not is_node_ready():
		return
	
	var points:Array[Vector2]
	points.append(Vector2.ZERO)
	for child:Node in get_children():
		var raycast:RayCast3D = child as RayCast3D
		if not raycast:
			continue
		
		var point:Vector3 = raycast.to_global(raycast.target_position)
		#raycast.get
		if raycast.is_colliding():
			point = raycast.get_collision_point()
		point = to_local(point)
		points.append(Vector2(point.x, point.z) * SCALE_2D)
	#points.append(Vector2.ZERO)
	polygon.polygon = PackedVector2Array(points)
