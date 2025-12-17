class_name Hackable extends Interactable

@onready var hack_range:Area3D = find_child("HackRange")
@onready var range_mesh:MeshInstance3D = find_child("RangeMesh")
var range_tween:Tween
func interact() -> void:
	GameManager.state = GameManager.State.PAUSED
	var hackable_targets:Array = hack_range.get_overlapping_areas()
	hackable_targets = hackable_targets.filter(func(item:Area3D):
		var interactable:Interactable = item as Interactable
		if not interactable:
			return false
		return interactable.hack_options().size() > 0
	)
	if hackable_targets.size() == 0:
		print_debug("No hackable targets")
		GameManager.state = GameManager.State.DEFAULT
		return
		
	var target:Interactable = await HackManager.get_target(hackable_targets)
	if not target:
		print_debug("No target selected")
		GameManager.state = GameManager.State.DEFAULT
		return
	
	var action:StringName = await HackManager.get_target_action(target)
	if not action:
		print_debug("No action selected")
		GameManager.state = GameManager.State.DEFAULT
		return
	
	var hacked:bool = await HackManager.initiate_hack(self)
	if not hacked:
		print_debug("Not hacked")
		GameManager.state = GameManager.State.DEFAULT
		return
	
	GameManager.state = GameManager.State.DEFAULT
	target.call(action)

func _hover() -> void:
	if range_tween and range_tween.is_running():
		range_tween.stop()
	range_tween = create_tween()
	var shader:ShaderMaterial = range_mesh.mesh.surface_get_material(0) as ShaderMaterial
	range_tween.tween_method(func(value:float) -> void:
		shader.set_shader_parameter("height", value)
	, 0., 1., .3)
	$Label3D.show()

func _off_hover() -> void:
	if range_tween and range_tween.is_running():
		range_tween.stop()
	range_tween = create_tween()
	var shader:ShaderMaterial = range_mesh.mesh.surface_get_material(0) as ShaderMaterial
	range_tween.tween_method(func(value:float) -> void:
		shader.set_shader_parameter("height", value)
	, 1., 0., .3)
	$Label3D.hide()
