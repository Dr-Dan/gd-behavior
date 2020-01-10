extends "res://addons/GDBehavior/Base/BTDecorator.gd"

# var conditions: Array

# expects array of BTCondition nodes
# TODO: Due to simplicity of saving system. conditions are saved as unexecuted children.
func _init(conditions:Array=[], child=null).(child, "meets conditions decorator"):
	# self.conditions = conditions
	children += conditions
	pass

func _exe(tick):
	var passing = 0
	var run_child = false
	for i in range(1, children.size()):
		var c = children[i]
		assert(c.has_method("_validate"))
		if not c._validate(tick):
			return FAILURE
		
	var r = _get_child().exe(tick)
	if r != RUNNING:
		return SUCCESS
	return RUNNING

# func to_dict():
# 	return 