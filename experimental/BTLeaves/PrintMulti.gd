extends "res://addons/GDBehavior/Base/BTAction.gd"

var msg0:String
var msg1:String

#	func _init(_msg:String="").(get_display_name()):
func _init(_msg0:String="", _msg1:String="").("print_multi"):
	msg0 = _msg0
	msg1 = _msg1
	
func exe(tick):
	print("%s %s" % [msg0, msg1])
	# print("Hello World!")
	return SUCCESS

func from_dict(data):
	if "args" in data:
		for d in data.args:
			set(d, data.args[d])
	return self
	
func to_dict():
	return {msg0=msg0, msg1=msg1}
	
