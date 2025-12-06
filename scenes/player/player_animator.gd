class_name PlayerAnimator extends AnimationTree
@onready var player:Player = get_parent() as Player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var speed_percentage:float = clamp(player.speed / player.TOP_SPEED,0,1)
	set("parameters/Movement/blend_position", speed_percentage)
