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

@onready var grid:GridContainer = find_child("HackContainer")
@onready var solution_total:Label = find_child("SolutionTotal")
@onready var line:Line2D = find_child("Line2D")
@onready var player_total:Label = find_child("PlayerTotal")
@onready var progress:ProgressBar = find_child("HackProgress")
## The solution to the puzzle
var solution:int = -1
var player:int
## The player's current path
var player_path:Array[Vector2i]

var _start_position:Vector2i:
	get: return Vector2i.ZERO

var _end_position:Vector2i:
	get: return grid_size - Vector2i(1, 1)

func _ready() -> void:
	player_path.append(_start_position)
	grid.columns = grid_size.x
	for x:int in range(grid_size.x):
		for y:int in range(grid_size.y):
			var tile:HackingTile = HACKING_TILE_SCENE.instantiate()
			tile.value = randi_range(0, VALUE_RANGE)
			tile.selected.connect(func() -> void:
				_try_add_path(Vector2i(y, x))
			)
			grid.add_child(tile)

	var start:HackingTile = get_tile(_start_position.x, _start_position.y)
	start.value = 0
	
	#var end:HackingTile = get_goal_tile()
	#end.value = 0
	
	_create_solution()
	display_path(player_path)
	find_child("Undo").pressed.connect(func() -> void:
		if player_path.size() > 1:
			player_path.pop_back()
			display_path(player_path)
	)
	find_child("Reset").pressed.connect(func() -> void:
		player_path = [_start_position]
		display_path(player_path)
	)
	_reveal()

func _reveal() -> void:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	scale = Vector2(0,1)
	tween.tween_property(self, "scale", Vector2(1,1), .3)

func _close() -> Tween:
	$AnimationPlayer.play('hacked')
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "scale", Vector2(0,1), 1)
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
		_try_add_path(new_position)

func _try_add_path(grid_position:Vector2i) -> void:
	if not _is_valid(grid_position):
		$AnimationPlayer.stop()
		$AnimationPlayer.play('bad_move')
		return
	var existing_position:int = player_path.find(grid_position)
	if existing_position == -1:
		player_path.append(grid_position)
		if grid_position == _end_position:
			closed.emit(true)
	else:
		while player_path.size() > existing_position + 1:
			player_path.pop_back()
	display_path(player_path)

func _is_valid(grid_position:Vector2i) -> bool:
	var in_grid:bool = not (grid_position.x < 0 or grid_position.y < 0 or grid_position.y > grid_size.y - 1 or grid_position.x > grid_size.x - 1)
	if not in_grid:
		return false
		
	var next_value:int = player + get_tile(grid_position.x,grid_position.y).value
	if grid_position == _end_position:
		return next_value == solution
		
	if solution != -1 and not (grid_position in player_path) and next_value > solution:
		return false
	
	var last_position:Vector2i = player_path.back()
	return grid_position in get_neighbors(last_position.x, last_position.y)

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
	var goal:HackingTile = get_goal_tile()
	for tile in grid.get_children():
		if tile != goal:
			tile.theme_type_variation = "HackTile"
		tile.self_modulate = Color("#494949")
	
	goal.self_modulate = Color.WHITE
	goal.theme_type_variation = &"HackTileGoal"
	for step:Vector2i in path:
		var tile:HackingTile = get_tile(step.x, step.y)
		if path.find(step) == path.size() - 1:
			tile.theme_type_variation = "HackTileHead"
		else:
			tile.theme_type_variation = "HackTile"
		tile.self_modulate = Color("#5fffff")
		#var tile_position:Vector2 = (tile.get_screen_position()) + tile.size/2
		#line.add_point(tile_position)
		total += tile.value
	player_total.text = "%d" % total
	player = total
	progress.value = float(player)/float(solution)
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
