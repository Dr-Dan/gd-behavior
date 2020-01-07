extends "res://addons/GDBehavior/Base/BTDecorator.gd"

"""
	Do something every time node exits
"""
var on_exit

func _init(on_exit, child).(child, "on-exit decorator"):
	self.on_exit = on_exit
	
func _exe(tick):
	var r = _get_child().exe(tick)
	return r
       
func _exit(tick):
	on_exit.exe(tick)	