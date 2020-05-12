extends Control

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")

const Tick = preload("res://addons/GDBehavior/Tick.gd")
const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Utils = preload("res://addons/GDBehavior/Utils.gd")

var nn={
	leaf={
		"print":{
			dname="Print", 
			args_type={msg=TYPE_STRING}, 
			args_export={msg="Hello, world!"}
		},
		"print_int":{
			dname="Print Int", 
			args_type={value=TYPE_INT}, 
			args_export={value=-1}
		},
		"always_result":{
			dname="Always Result", 
			args_type={result=TYPE_BOOL}, 
			# args_export={result=false}
		},
	},
	composite={
		sequencer={dname="Sequencer"},
		selector={dname="Selector"}
	},
	decorator={
		invert={dname="Invert"}
	}
	}

var nodes = {
	"print":"res://experimental/BTLeaves/PrintAction.gd",
	"print_int":"res://experimental/BTLeaves/PrintActionInt.gd",
	"always_result":"res://experimental/BTLeaves/AlwaysResult.gd",
	
	"sequencer":"res://addons/GDBehavior/Composite/Sequencer.gd",
	"selector":"res://addons/GDBehavior/Composite/Selector.gd",

	"invert":"res://addons/GDBehavior/Decorator/Invert.gd"
	}

onready var graph = $GraphEdit
onready var graph_info_panel = $InfoPanel

func _input(event):
	if event is InputEventKey and not event.pressed and event.scancode == KEY_A:
		var tree_nodes = graph.get_nodes_dfs_data(graph.get_root_connection().to)
		var tree_data = {nodes=nodes, tree=tree_nodes}
		var tree = Utils.from_data(tree_data)
		var tick = Tick.new()
		var tree_runner = BTRunner.new(tree)
		tree_runner.exe(tick)
			
			
func _ready():
	graph.connect("node_selected", graph_info_panel, "show_info")
	for l in nn.leaf:
		var args_export = {}
		var args_type = {}
		if "args_export" in nn.leaf[l]:
			args_export = nn.leaf[l].args_export.duplicate()
		if "args_type" in nn.leaf[l]:
			args_type = nn.leaf[l].args_type.duplicate()
		graph.add_leaf(l, nn.leaf[l].dname, args_type, args_export)

	for l in nn.composite:
		graph.add_composite(l, nn.composite[l].dname)

	for l in nn.decorator:
		graph.add_decorator(l, nn.decorator[l].dname)
	
