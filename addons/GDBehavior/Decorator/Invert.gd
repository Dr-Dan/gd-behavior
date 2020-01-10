extends "res://addons/GDBehavior/Base/BTDecorator.gd"

func _init(child=null).(child, "invert decorator"):
	pass
	
func _exe(tick):
	var r = _get_child().exe(tick)
	if r == SUCCESS:
		return FAILURE
	elif r == FAILURE:
		return SUCCESS
	return RUNNING
       