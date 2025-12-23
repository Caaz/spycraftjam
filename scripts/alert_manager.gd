extends Node

signal alert_changed(alert)
signal alert_max()
## Rate at which the alert level raises in seconds
const ALERT_RATE = .05
## Rate at which the alert level deccays in seconds
const ALERT_DECAY = 0
## Time to wait before decaying alert level in seconds
const DECAY_COOLDOWN_TIME:float = 2

## Cooldown timer
var _cooldown:float = 0

## Current alert level from 0-1
var alert_level:float = 0:
	set(new):
		var new_level:float = clampf(0, new, 1)
		if is_equal_approx(alert_level, new_level):
			return
		alert_level = new_level
		alert_changed.emit(alert_level)
		if is_equal_approx(alert_level, 1):
			alert_max.emit()

func _process(delta: float) -> void:
	if is_zero_approx(_cooldown):
		alert_level = alert_level - delta * ALERT_DECAY
	else:
		_cooldown -= delta

func increase_alert(scale:float = 1) -> void:
	alert_level += ALERT_RATE * get_process_delta_time() * scale
	_cooldown = DECAY_COOLDOWN_TIME
