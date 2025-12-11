extends Node
 
signal alert_changed(alert)

const ALERT_RATE = .05
const ALERT_DECAY = 0.05
const DECAY_COOLDOWN_TIME:float = 2

var decay_cooldown:float = 0

var alert_level:float = 0:
	set(new):
		if is_equal_approx(alert_level, new):
			return
		alert_level = new
		alert_changed.emit(alert_level)

func increase_alert(amount:float = ALERT_RATE) -> void:
	alert_level += amount * get_process_delta_time()
	decay_cooldown = DECAY_COOLDOWN_TIME

func _process(delta: float) -> void:
	if is_zero_approx(decay_cooldown):
		alert_level = max(0, alert_level - delta * ALERT_DECAY)
	else:
		decay_cooldown -= delta
