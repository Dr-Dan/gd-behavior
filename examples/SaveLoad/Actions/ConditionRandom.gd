extends "res://addons/GDBehavior/Base/BTCondition.gd"

# random

func _init().("random-condition"):
	pass

func _validate(tick):
	return randf() > 0.5