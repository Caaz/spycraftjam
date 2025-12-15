class_name Hackable extends Interactable

@onready var hack_range:Area3D = find_child("HackRange")
func interact() -> void:
	HackManager.initiate_hack(self)
	#var hackable_targets:Array = hack_range.get_overlapping_areas()
	#hackable_targets = hackable_targets.filter(func(item:Area3D):
		#var interactable:Interactable = item as Interactable
		#if not interactable:
			#return false
		#return interactable.hack_options().size() > 0
	#)
	#var target:Interactable = await Game.get_hack_target(hackable_targets)
	#if not target:
		#return
	#
	#var action:StringName = Game.get_hack_option(target)
	#if not action:
		#return
	#
	#var hacked:bool = await Game.hack(self)
	#if not hacked:
		#return
	#
	#
