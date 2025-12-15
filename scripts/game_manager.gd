extends Node

enum State {
	DEFAULT,
	PAUSED,
}

var state:State = State.DEFAULT:
	set(new):
		state = new
		_state_updated()

func _state_updated() -> void:
	# TODO: Pause game when paused.
	pass
