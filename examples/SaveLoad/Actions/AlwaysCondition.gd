extends "res://addons/GDBehavior/Base/BTCondition.gd"

# always returns result

var result: bool

func _init(result:bool=true).("always-condition"):
	self.result = result

func _validate(tick):
	return result

func to_dict():
	return {result=result}
	
func from_dict(dict):
	result = dict.result
	return self