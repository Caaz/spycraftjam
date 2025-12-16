class_name GuardAnimator extends AnimationTree
@onready var guard:Guard = get_parent() as Guard
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var speed_percentage:float = clamp(guard.speed / guard.TOP_SPEED,0,1)
	set("parameters/Movement/blend_position", speed_percentage)
