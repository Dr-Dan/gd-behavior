extends "res://addons/GDBehavior/Base/BTAction.gd"

func _init().("stop speaking"):
	pass

func _exe(tick):
	tick.actor.speech = ""
	return SUCCESS
	
		
func to_dict():
	return {}
	
func from_dict(dict):
	return self