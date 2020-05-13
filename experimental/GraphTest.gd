extends Control

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")

const Tick = preload("res://addons/GDBehavior/Tick.gd")
const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Utils = preload("res://addons/GDBehavior/Utils.gd")
const fldr_path = "user://gdbehavior/experimental/save_files/"

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
#			args_export={result=false}
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
	if event is InputEventKey and not event.pressed:
		if event.scancode == KEY_A:
#		var tree_data = get_graph_data()
#		if not tree_data.tree.empty():
#			var tree = Utils.from_data(tree_data)
#			var tick = Tick.new()
#			var tree_runner = BTRunner.new(tree)
#			tree_runner.exe(tick)
			_save("test_bt.bt")
		elif event.scancode == KEY_D:
			_load("test_bt.bt")
			
func _ready():
	OS.low_processor_usage_mode = true
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
		
	print(graph.get_type("invert"))
	
# SAVING + LOADING
func _save(_filename:String):
	var test_filename =  fldr_path + _filename
	
	var dir = Directory.new()
	if not dir.dir_exists(fldr_path):
		dir.make_dir_recursive(fldr_path)
	var data = get_graph_data()
	if not data.tree.empty():
		var saved = SaveLoad.save_data(data, test_filename)
		if saved:
			print("saved [%s]" % _filename)
			return true
			
	print("failed to save [%s]" % _filename)
	return false

func _load(_filename:String):
	var test_filename =  fldr_path + _filename
	
	var dir = Directory.new()
	if dir.dir_exists(fldr_path):
		var data_loaded = SaveLoad.load_data(test_filename)
#		print(data_loaded)
#		print(File.new().file_exists(test_filename))
		if data_loaded != null:
			graph.from_data(data_loaded)
			print("loaded")
		else:
			print("could not load [%s]" % test_filename)
	else:
		print("directory [%s] not found" % test_filename)
	
func get_graph_data():
	var tree_nodes = graph.to_dict()
	var tree_data = {nodes=nodes, tree=tree_nodes}
	return tree_data
