extends "res://addons/GDBehavior/Base/BTDecorator.gd"

func _init(child=null).(child, "succeeder decorator"):
	pass
	
func _exe(tick):
	var r = _get_child().exe(tick)
	if r != RUNNING:
		return SUCCESS
	return RUNNING