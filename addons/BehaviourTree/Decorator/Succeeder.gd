extends "res://addons/BehaviourTree/Base/BTDecorator.gd"

func _init(child).(child, "succeeder decorator"):
	pass
	
func _exe(tick):
	var r = _get_child().exe(tick)
	if r != RUNNING:
		return SUCCESS
	return RUNNING