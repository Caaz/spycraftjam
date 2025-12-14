@tool class_name Prop extends Node3D
const MESH_LIBRARY:MeshLibrary = preload("uid://syeh7hpo4yd")
const STANDARD_MATERIAL:Material = preload("uid://dbnueos6cag1s")
@export_custom(PROPERTY_HINT_TYPE_STRING, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY) var mesh_name:String

@export var id:int:
	set(new):
		var last_id:int = id
		id = clamp(new, 0, MESH_LIBRARY.get_last_unused_item_id() - 1)
		if id != last_id:
			mesh_name = MESH_LIBRARY.get_item_name(id)
			name = mesh_name
			_update_visuals()
@export var material_override:Material = STANDARD_MATERIAL:
	set(new):
		material_override = new
		_update_visuals()
@onready var mesh:MeshInstance3D = find_child("MeshInstance3D")
@onready var collision:CollisionShape3D = find_child("CollisionShape3D")

func _ready() -> void:
	_update_visuals()

func _update_visuals():
	if not is_node_ready():
		return
	var item_mesh:Mesh = MESH_LIBRARY.get_item_mesh(id)
	if material_override != STANDARD_MATERIAL:
		mesh.mesh = item_mesh.duplicate()
		mesh.mesh.surface_set_material(1, material_override)
	else:
		mesh.mesh = item_mesh
	# Assumes every mesh in the mesh_library uses a single convex shape.
	collision.shape = MESH_LIBRARY.get_item_shapes(id)[0]
