extends "res://addons/GDBehavior/Base/BTAction.gd"
var msg: String

#	func _init(_msg:String="").(get_display_name()):
func _init(_msg:String="").("print"):
	msg = _msg
	
func exe(tick):
	print(msg)
	# print("Hello World!")
	return SUCCESS

func from_dict(data):
	if "args" in data:
		for d in data.args:
			set(d, data.args[d])
	return self
	
func to_dict():
	return {msg=msg}
	
