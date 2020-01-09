extends "res://addons/GDBehavior/Base/BTAction.gd"

var msg: String

func _init(msg:String="").("print"):
	self.msg = msg

func _exe(tick):
	print("%s: \"%s\"" % [tick.actor, msg])
	return SUCCESS
	
func to_dict():
	return {msg=msg}
	
func from_dict(dict):
	msg = dict.msg
	return self