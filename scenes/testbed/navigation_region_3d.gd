extends NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.navigation_region = self
	await create_tween().tween_interval(.2).finished
	Game.rebake_navmesh()
