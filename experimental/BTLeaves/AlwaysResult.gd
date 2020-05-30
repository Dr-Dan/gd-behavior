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
	if "args" in data:
		for d in data.args:
			set(d, data.args[d])
	return self
	
func to_dict():
	return {result=result}
	
