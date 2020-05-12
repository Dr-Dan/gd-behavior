extends "res://addons/GDBehavior/Base/BTAction.gd"

# always returns result

var result: bool

func _init(_result:bool=true).("always_result"):
	result = _result

func exe(tick):
	if result == true:
		return SUCCESS
	return FAILURE

func from_dict(data):
	if "args_export" in data:
		for d in data.args_export:
			set(d, data.args_export[d])
	return self
	
func to_dict():
	return {result=result}
	
