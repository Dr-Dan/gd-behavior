extends "res://addons/GDBehavior/Base/BTDecorator.gd"

var n_repeats: int
var exit_fail: bool

func _init(child=null, n=1, exit_fail=false).(child, "invert"):
	n_repeats = n
	self.exit_fail = exit_fail
	
func _open(tick):
	tick.data[self] = 0
	tick.running[self] = 0
	
func _exe(tick):
	for i in range(tick.data[self], n_repeats):
		var r = _get_child().exe(tick)
		if exit_fail and r == FAILURE:
			return FAILURE
		elif r == RUNNING:
			return RUNNING
		tick.data[self] += 1
	
	return SUCCESS
	   
func from_dict(data):
	if "args" in data:
		for d in data.args:
			set(d, data.args[d])
	return self
	
func to_dict():
	return {
		n_repeats=n_repeats, 
		exit_fail=exit_fail}
	
