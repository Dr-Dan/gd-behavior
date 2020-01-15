extends Resource

#const Tick = preload("res://addons/GDBehavior/Tick.gd")
const BTComposite = preload("res://addons/GDBehavior/Base/BTComposite.gd")
const BTNode = preload("res://addons/GDBehavior/Base/BTNode.gd")

var root: BTComposite

func _init(root:BTComposite):
	self.root = root

func exe(tick):
	tick.enter_tree(root)
	var result = root.exe(tick)
	tick.exit_tree(root, result)
	return result