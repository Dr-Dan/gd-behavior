extends "res://addons/GDBehavior/Base/BTAction.gd"
var value: int

func _init(_value:int=0).("print"):
	value = _value
	
func exe(tick):
	print(value)
	return SUCCESS

func from_dict(data):
	if "args_export" in data:
		for d in data.args_export:
			set(d, data.args_export[d])
	return self
	
func to_dict():
	return {value=value}
	
