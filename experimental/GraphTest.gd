extends Control

const nodes = [
	{sub="Composites", dname="Composite", scn=preload("res://experimental/Composite.tscn")},
	{sub="Leaves", dname="Leaf", scn=preload("res://experimental/Leaf.tscn")}
]

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const Seq = GDB.Composites.Sequencer

var node_types = {
	sequencer="res://addons/GDBehavior/GDBehavior.gd"
}

onready var graph = $GraphEdit

func _ready():
	for n in nodes:
		graph.add_node_type(n)
