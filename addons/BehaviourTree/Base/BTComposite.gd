extends "res://addons/BehaviourTree/Base/BTNode.gd"

var children:Array = []
func _init(children:Array, name:String).(name):
	assert(children.size() > 0)
	self.children = children