extends "res://addons/GDBehavior/Base/BTNode.gd"

var children:Array = []
func _init(children:Array, name:String).(name):
#	assert(children.size() > 0)
	self.children = children
	
func set_children(children):
	self.children=children