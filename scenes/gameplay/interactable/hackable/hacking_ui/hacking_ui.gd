class_name HackingUI extends Control
signal closed(hacked:bool)
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
const grid_size:Vector2i = Vector2i(4,4)
const VALUE_RANGE:int = 3

@onready var grid:GridContainer = find_child("GridContainer")
@onready var solution_total:Label = find_child("SolutionTotal")
@onready var line:Line2D = find_child("Line2D")
@onready var player_total:Label = find_child("PlayerTotal")

## The solution to the puzzle
var solution:int
var player:int
## The player's current path
var player_path:Array[Vector2i]

var _start_position:Vector2i:
	get: return Vector2i.ZERO

var _end_position:Vector2i:
	get: return grid_size - Vector2i(1, 1)

func _ready() -> void:
	@warning_ignore("integer_division")
	player_path.append(_start_position)
	grid.columns = grid_size.x
	for x:int in range(grid_size.x):
		for y:int in range(grid_size.y):
			var tile:HackingTile = HACKING_TILE_SCENE.instantiate()
			tile.value = randi_range(0, VALUE_RANGE)
			grid.add_child(tile)
	@warning_ignore("integer_division")

	var start:HackingTile = get_tile(_start_position.x, _start_position.y)
	start.value = 0
	
	@warning_ignore("integer_division")
	var end:HackingTile = get_goal_tile()
	end.value = 0
	
	_create_solution()
	display_path(player_path)
	find_child("NewButton").pressed.connect(_create_solution)
	_reveal()

func _reveal() -> void:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	scale = Vector2(0,1)
	tween.tween_property(self, "scale", Vector2(1,1), .3)

func _close() -> Tween:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2(0,1), .3)
	return tween
	
func _process(_delta:float) -> void:
	var move_position = Vector2i.ZERO
	if Input.is_action_just_pressed("move_north"):
		move_position.y -= 1
	elif Input.is_action_just_pressed("move_south"):
		move_position.y += 1
	
	if Input.is_action_just_pressed("move_west"):
		move_position.x -= 1
	elif Input.is_action_just_pressed("move_east"):
		move_position.x += 1
		
	if move_position != Vector2i.ZERO:
		var new_position = player_path.back() + move_position
		if not _is_valid(new_position):
			return
		var existing_position:int = player_path.find(new_position)
		if existing_position == -1:
			player_path.append(new_position)
			if new_position == _end_position:
				closed.emit(true)
		else:
			while player_path.size() > existing_position + 1:
				player_path.pop_back()
		display_path(player_path)
		
func _is_valid(grid_position:Vector2i) -> bool:
	if grid_position == _end_position:
		return player == solution
	return not (grid_position.x < 0 or grid_position.y < 0 or grid_position.y > grid_size.y - 1 or grid_position.x > grid_size.x - 1)

func _create_solution() -> void:
	var _solution:Array[Vector2i] = get_solution_path()
	var total:int = 0
	for step:Vector2i in _solution:
		var tile:HackingTile = get_tile(step.x, step.y)
		total += tile.value
	solution_total.text = "%d" % total
	solution = total

func display_path(path:Array[Vector2i]) -> void:
	#line.clear_points()
	await get_tree().process_frame
	var total:int = 0
	for tile in grid.get_children():
		tile.self_modulate = Color.DIM_GRAY
	
	var goal:HackingTile = get_goal_tile()
	goal.self_modulate = Color.WHITE
	goal.theme_type_variation = &"HackTileGoal"
	for step:Vector2i in path:
		var tile:HackingTile = get_tile(step.x, step.y)
		tile.self_modulate = Color("#00d3d6")
		#var tile_position:Vector2 = (tile.get_screen_position()) + tile.size/2
		#line.add_point(tile_position)
		total += tile.value
	player_total.text = "%d" % total
	player = total
	#line.global_position = Vector2(0,0)
	#line.show()
	
func get_tile(x:int, y:int) -> HackingTile:
	return grid.get_child(x + y * grid_size.x)

func get_goal_tile():
	var goal:Vector2i = _end_position
	return get_tile(goal.x, goal.y)


func get_solution_path() -> Array[Vector2i]:
	@warning_ignore("integer_division")
	var path:Array[Vector2i] = [_start_position]
	var last:Vector2i = path.back()
	while last != _end_position:
		var neighbors:Array[Vector2i] = get_neighbors(last.x, last.y)
		neighbors = neighbors.filter(func(item:Vector2i) -> bool:
			return not path.has(item)
		)
		if neighbors.size() == 0:
			@warning_ignore("integer_division")
			path = [_start_position]
		else:
			path.append(neighbors.pick_random())
		last = path.back()
	return path
	
func get_neighbors(x:int, y:int) -> Array[Vector2i]:
	var neighbors:Array[Vector2i]
	if y != 0:
		neighbors.append(Vector2i(x, y-1))
	if x != 0:
		neighbors.append(Vector2i(x-1, y))
	if y != grid_size.y-1:
		neighbors.append(Vector2i(x, y+1))
	if x != grid_size.x-1:
		neighbors.append(Vector2i(x+1, y))
	return neighbors
