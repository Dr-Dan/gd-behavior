extends "res://addons/GDBehavior/Base/BTNode.gd"

func _init(name:String).(name):
	pass

func _exe(tick):
	if _validate(tick):
		return SUCCESS
	return FAILURE

# override this function
func _validate(tick):
	return true