extends Node

enum State {
	DEFAULT,
	PAUSED,
}

var state:State = State.DEFAULT:
	set(new):
		state = new
		_state_updated()
var player:Player:
	get:
		return get_tree().get_first_node_in_group(&"player")
func _state_updated() -> void:
	var pausable_nodes:Array[Node] = get_tree().get_nodes_in_group(&"gameplay_pausable")
	for node:Node in pausable_nodes:
		match(state):
			State.DEFAULT:
				node.process_mode = Node.PROCESS_MODE_INHERIT 
			State.PAUSED:
				node.process_mode = Node.PROCESS_MODE_DISABLED 
