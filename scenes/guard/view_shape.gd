@tool class_name ViewShape3D extends CollisionShape3D
@export var arc:float = 1.:
	set(new):
		arc = clamp(new, 0, 1)
		_update_raycasts()

@export var height:float = 1:
	set(new):
		height = clamp(new, .1, 10)
		_update_shape()

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

var tick:float = 0
const UPDATE_RATE:float = .2
func _update_raycasts():
	if not is_node_ready():
		return
	
	for child in get_children():
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

func _ready() -> void:
	shape = shape.duplicate()
	_update_raycasts()

func _process(delta: float) -> void:
	tick += delta
	if tick > UPDATE_RATE:
		tick = 0
		_update_shape()

func _update_shape():
	if not is_node_ready():
		return
	
	var child_count:int = get_child_count()
	var points:Array[Vector3]
	points.append(Vector3(0, -height/2-.01, 0))
	points.append(Vector3(0, height/2 + .01, 0))
	var high:Vector3 = Vector3(0,height/2,0)
	var low:Vector3 = Vector3(0,height/2,0)
	for i:int in range(child_count):
		# 
		
		var raycast:RayCast3D = get_child(i)
		var point:Vector3 = raycast.target_position
		if raycast.is_colliding():
			point = raycast.get_collision_point()
		point = to_local(point)
		
		# Tri A
		points.append(low)
		points.append(point + low)
		points.append(point + high)
		# Tri B
		points.append(point + high)
		points.append(high)
		points.append(low)
		#points.append(point - Vector3(0, height/2, 0))
		#points.append(point + Vector3(0, height/2, 0))
	
	var c_shape:ConcavePolygonShape3D = shape as ConcavePolygonShape3D
	c_shape.points = points
	shape = c_shape
