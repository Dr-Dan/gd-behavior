extends Control

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
#const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")

const Tick = preload("res://addons/GDBehavior/Tick.gd")
const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Utils = preload("res://addons/GDBehavior/Utils.gd")

const NODE_DATA={
	leaf=[
		{
			type_name="print",
			display_name="Print", 
			args_type={msg=TYPE_STRING}, 
			args_export={msg="Hello, world!"},
			filepath="res://experimental/BTLeaves/PrintAction.gd",
		},
		{
			type_name="print_multi",
			display_name="PrintMulti", 
			args_type={msg0=TYPE_STRING, msg1=TYPE_STRING}, 
		# 	args_export={msg0="Hello,", msg1="world!"}
			filepath="res://experimental/BTLeaves/PrintMulti.gd"
		},
		{
			type_name="print_int",
			display_name="Print Int", 
			args_type={value=TYPE_INT}, 
			# args_export={value=-1},
			filepath="res://experimental/BTLeaves/PrintActionInt.gd",
		},
		{
			type_name="always_result",
			display_name="Always Result", 
			args_type={result=TYPE_BOOL}, 
			# args_export={result=false}
			filepath="res://experimental/BTLeaves/AlwaysResult.gd",
		},
	],
	composite=[
		{
			type_name="sequencer", 
			display_name="Sequencer",
			filepath="res://addons/GDBehavior/Composite/Sequencer.gd"
		},
		{
			type_name="selector", 
			display_name="Selector", 
			filepath="res://addons/GDBehavior/Composite/Selector.gd"
		}
	],
	decorator=[
		{
		type_name="invert", 
		display_name="Invert", 
		filepath="res://addons/GDBehavior/Decorator/Invert.gd"
		},
		{
		type_name="succeeder", 
		display_name="Succeeder", 
		filepath="res://addons/GDBehavior/Decorator/Succeeder.gd"
		},
		{
		type_name="failer", 
		display_name="Failer", 
		filepath="res://addons/GDBehavior/Decorator/Failer.gd"
		},
		{
		type_name="repeat",
		display_name="Repeat",
		args_type={n_repeats=TYPE_INT, exit_fail=TYPE_BOOL},
		filepath="res://experimental/BTDecorators/RepeatGraph.gd"
		},
	],
	}

class TestTick:
	extends Tick
	
	# used by repeat decorator
	var data = {}
	
		
onready var graph = $GraphEdit
onready var graph_info_panel = $InfoPanel
onready var save_dialog = $SaveDialog
onready var load_dialog = $LoadDialog

# var f = 0
func _ready():
	OS.low_processor_usage_mode = true
	
	graph.connect("node_selected", graph_info_panel, "show_info")
	graph.save_btn.connect("pressed", save_dialog, "popup")
	graph.load_btn.connect("pressed", load_dialog, "popup")
	
	save_dialog.connect("file_selected", self, "_save")
	load_dialog.connect("file_selected", self, "_load")
	
	$TestButton.connect("pressed", self, "_run_tree")
	
	register_types()
	
func register_types():
	for base_type in NODE_DATA:
		for d in NODE_DATA[base_type]:
			var data = d.duplicate()
			
			var args_type = {}
			if "args_type" in data:
				args_type = data.args_type
				
			graph.add_node_type(base_type, data.type_name, data.display_name, data.filepath, args_type)


func _run_tree():
	var tree_data = graph.to_dict()
	if not tree_data.tree.empty():
		var tree = Utils.from_data(tree_data)
		var tree_runner = BTRunner.new(tree)
		var tick = TestTick.new()
		while tree_runner.exe(tick) == GDB.BTNode.RUNNING:
			pass
#
## SAVING + LOADING
func _save(_filename:String):
	graph.save_graph(_filename)

func _load(_filename:String):
	graph.load_graph(_filename)
	graph_info_panel.clear()
