class_name Hackable extends Interactable

@onready var hack_range:Area3D = find_child("HackRange")
func interact() -> void:
	var hackable_targets:Array = hack_range.get_overlapping_areas()
	hackable_targets = hackable_targets.filter(func(item:Area3D):
		var interactable:Interactable = item as Interactable
		if not interactable:
			return false
		return interactable.hack_options().size() > 0
	)
	if hackable_targets.size() == 0:
		print_debug("No hackable targets")
		return
		
	var target:Interactable = await HackManager.get_target(hackable_targets)
	if not target:
		print_debug("No target selected")
		return
	
	var action:StringName = await HackManager.get_target_action(target)
	if not action:
		print_debug("No action selected")
		return
	
	var hacked:bool = await HackManager.initiate_hack(self)
	if not hacked:
		print_debug("Not hacked")
		return
	
	target.call(action)
