extends "res://addons/GDBehavior/Base/BTDecorator.gd"

var n_repeats: int
var exit_fail: bool

func _init(child=null, n=1, exit_fail=false).(child, "invert"):
	n_repeats = n
	self.exit_fail = exit_fail
	
func _open(tick):
	tick.running[self] = 0
	
func _exe(tick):
	var r = _get_child().exe(tick)
	if r != RUNNING:
		tick.running[self] += 1
	if exit_fail and r == FAILURE:
		return FAILURE
	if tick.running[self] < n_repeats:
		return RUNNING
	return r
