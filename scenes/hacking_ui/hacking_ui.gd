extends Control
enum Path {
	DOT,
	END,
	STRAIGHT,
	CORNER,
}
const path_textures:Dictionary[Path, Texture2D] = {
	Path.DOT: preload("uid://cdu5vxc8tqhtj"),
	Path.END: preload("uid://dhqsp1o5sxy1g"),
	Path.STRAIGHT: preload("uid://dqmf56so8eqlf"),
	Path.CORNER: preload("uid://b3mgmnw4b1djb"),
}
const HACKING_TILE_SCENE:PackedScene = preload("uid://e1a423l5bcur")
const grid_size:Vector2i = Vector2i(4,3)
const VALUE_RANGE:int = 9
@onready var grid:GridContainer = find_child("GridContainer")
@onready var solution_total:Label = find_child("SolutionTotal")
@onready var line:Line2D = find_child("Line2D")
func _ready() -> void:
	grid.columns = grid_size.x
	for x:int in range(grid_size.x):
		for y:int in range(grid_size.y):
			var tile:HackingTile = HACKING_TILE_SCENE.instantiate()
			tile.value = randi_range(1, VALUE_RANGE)
			grid.add_child(tile)
	@warning_ignore("integer_division")
	var start:HackingTile = get_tile(0, grid_size.y/2)
	start.value = 0
	start.texture = path_textures[Path.DOT]
	
	@warning_ignore("integer_division")
	var end:HackingTile = get_goal_tile()
	end.value = 0
	end.texture = path_textures[Path.DOT]
	_create_solution()
	find_child("Button").pressed.connect(_create_solution)

func _create_solution() -> void:
	
	var solution:Array[Vector2i] = get_solution()
	var total:int = 0
	for step:Vector2i in solution:
		var tile:HackingTile = get_tile(step.x, step.y)
		total += tile.value
	solution_total.text = "%d" % total
	display_path(solution)

func display_path(path:Array[Vector2i]) -> void:
	line.clear_points()
	await get_tree().process_frame
	for step:Vector2i in path:
		var tile:HackingTile = get_tile(step.x, step.y)
		line.add_point(tile.global_position + tile.size/2)
	
func get_tile(x:int, y:int) -> HackingTile:
	return grid.get_child(x + y * grid_size.x)

func get_goal_tile():
	var goal:Vector2i = get_goal()
	return get_tile(goal.x, goal.y)

func get_goal() -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(grid_size.x-1, grid_size.y/2)

func get_solution() -> Array[Vector2i]:
	@warning_ignore("integer_division")
	var path:Array[Vector2i] = [Vector2i(0,grid_size.y/2)]
	var goal:Vector2i = get_goal()
	var last:Vector2i = path.back()
	while last != goal:
		var neighbors:Array[Vector2i] = get_neighbors(last.x, last.y)
		neighbors = neighbors.filter(func(item:Vector2i) -> bool:
			return not path.has(item)
		)
		path.append(neighbors.pick_random())
		last = path.back()
	return path
	
func get_neighbors(x:int, y:int) -> Array[Vector2i]:
	var neighbors:Array[Vector2i]
	if y != 0:
		neighbors.append(Vector2i(x, y-1))
	if y != grid_size.y-1:
		neighbors.append(Vector2i(x, y+1))
	if x != grid_size.x-1:
		neighbors.append(Vector2i(x+1, y))
	return neighbors
