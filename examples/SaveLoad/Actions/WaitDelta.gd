extends "res://addons/GDBehavior/Base/BTAction.gd"

var duration: float

func _init(duration_secs:float=1.0).("wait_delta_time"):
	self.duration = duration_secs
	
func _open(tick):
	tick.time_waited[self] = 0.0

func _exe(tick):
	tick.time_waited[self] += tick.delta
	if tick.time_waited[self] > duration:
		return SUCCESS
	return RUNNING
	
func to_dict():
	return {duration=duration}
	
func from_dict(dict):
	duration = float(dict.duration)
	return self