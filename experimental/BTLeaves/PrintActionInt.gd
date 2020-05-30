extends "res://addons/GDBehavior/Base/BTAction.gd"
var value: int

func _init(_value:int=0).("print"):
	value = _value
	
func exe(tick):
	print(value)
	return SUCCESS

func from_dict(data):
	if "args" in data:
		for d in data.args:
			set(d, data.args[d])
	return self
	
func to_dict():
	return {value=value}
	
