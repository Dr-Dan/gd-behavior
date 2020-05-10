extends Control

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const Seq = GDB.Composites.Sequencer
const BTAction = preload("res://addons/GDBehavior/Base/BTAction.gd")

class Print:
	extends BTAction
	var msg: String
	
#	func _init(_msg:String="").(get_display_name()):
	func _init(_msg:String="").("print"):
		msg = _msg
		
	func exe(tick):
		print(msg)
		return SUCCESS

	func from_dict(data):
		for d in data:
			set(d, data[d])
		return self
		
	func to_dict():
		return {msg=msg}
		
const nodes = [
	{node_name="composite", sub_cat="Composites", dname="Composite", scn=preload("res://experimental/Composite.tscn")},
	{node_name="decorator", sub_cat="Decorators", dname="Decorator", scn=preload("res://experimental/Decorator.tscn")},
	{node_name="leaf", sub_cat="Leaves", dname="Leaf", scn=preload("res://experimental/Leaf.tscn")}
]

onready var graph = $GraphEdit

func _ready():
#	graph.add_action("print", "Print", {msg = TYPE_STRING})
	for n in nodes:
		graph.add_node_type(n)
