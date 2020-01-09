extends "res://addons/GDBehavior/Base/BTAction.gd"

func _init().("say random greeting"):
	pass
	
func _exe(tick):
	var gr = tick.actor.greetings
	var i = randi() % gr.size()
	tick.actor.speech = gr[i]
	return SUCCESS

func to_dict():
	return {}
	
func from_dict(dict):
	return self