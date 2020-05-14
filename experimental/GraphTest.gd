extends Control

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")

const Tick = preload("res://addons/GDBehavior/Tick.gd")
const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Utils = preload("res://addons/GDBehavior/Utils.gd")
const fldr_path = "user://gdbehavior/experimental/save_files/"

const nn={
	leaf={
		"print":{
			display_name="Print", 
			args_type={msg=TYPE_STRING}, 
			args_export={msg="Hello, world!"}
		},
		"print_multi":{
			display_name="PrintMulti", 
			args_type={msg0=TYPE_STRING, msg1=TYPE_STRING}, 
			args_export={msg0="Hello,", msg1="world!"}
		},
		"print_int":{
			display_name="Print Int", 
			args_type={value=TYPE_INT}, 
			args_export={value=-1}
		},
		"always_result":{
			display_name="Always Result", 
			args_type={result=TYPE_BOOL}, 
#			args_export={result=false}
		},
	},
	composite={
		sequencer={display_name="Sequencer"},
		selector={display_name="Selector"}
	},
	decorator={
		invert={display_name="Invert"}
	}
	}

const nodes = {
	"print":"res://experimental/BTLeaves/PrintAction.gd",
	"print_multi":"res://experimental/BTLeaves/PrintMulti.gd",
	"print_int":"res://experimental/BTLeaves/PrintActionInt.gd",
	"always_result":"res://experimental/BTLeaves/AlwaysResult.gd",
	
	"sequencer":"res://addons/GDBehavior/Composite/Sequencer.gd",
	"selector":"res://addons/GDBehavior/Composite/Selector.gd",

	"invert":"res://addons/GDBehavior/Decorator/Invert.gd"
	}

onready var graph = $GraphEdit
onready var graph_info_panel = $InfoPanel
onready var save_dialog = $SaveDialog
onready var load_dialog = $LoadDialog

var f = 0
func _ready():
	OS.low_processor_usage_mode = true
	graph.connect("node_selected", graph_info_panel, "show_info")
	
	for l in nn.leaf:
		var leaf = nn.leaf[l].duplicate(true)
		if "args_type" in leaf:
			if "args_export" in leaf:
				for a in leaf.args_type:
					if not a in leaf.args_export:
						leaf.args_export[a] = get_default(leaf.args_type[a])


		graph.add_leaf(leaf)

	for l in nn.composite:
		graph.add_composite(nn.composite[l])

	for l in nn.decorator:
		graph.add_decorator(nn.decorator[l])
		
	graph.save_btn.connect("pressed", save_dialog, "popup")
	graph.load_btn.connect("pressed", load_dialog, "popup")
	save_dialog.connect("file_selected", self, "_save")
	load_dialog.connect("file_selected", self, "_load")

# TODO: to utility class
static func get_default(_type):
	match _type:
		TYPE_STRING:
			return ""
		TYPE_INT:
			return 0
		TYPE_REAL:
			return 0.0
		TYPE_BOOL:
			return false
		TYPE_VECTOR2:
			return Vector2()
	return null

#func _input(event):
#	if event is InputEventKey and not event.pressed:
#		if event.scancode == KEY_A:
#			var tree_data = get_graph_data()
#			if not tree_data.tree.empty():
#				var tree = Utils.from_data(tree_data)
#				var tick = Tick.new()
#				var tree_runner = BTRunner.new(tree)
#				tree_runner.exe(tick)
#			_save(fldr_path + "test_bt.bt")
#		elif event.scancode == KEY_D:
#			_load(fldr_path + "test_bt.bt")
			
# SAVING + LOADING
func _save(_filename:String):
	
	var dir = Directory.new()
	if not dir.dir_exists(fldr_path):
		dir.make_dir_recursive(fldr_path)
	var data = get_graph_data()
	if not data.tree.empty():
		var saved = SaveLoad.save_data(data, _filename)
		if saved:
			print("saved [%s]" % _filename)
			return true
			
	print("failed to save [%s]" % _filename)
	return false

func _load(_filename:String):
	
	var dir = Directory.new()
	if dir.dir_exists(fldr_path):
		var data_loaded = SaveLoad.load_data(_filename)
		if data_loaded != null:
			graph.from_data(data_loaded)
			print("loaded [%s]" % _filename)
		else:
			print("could not load [%s]" % _filename)
	else:
		print("directory [%s] not found" % _filename)
	
func get_graph_data():
	var tree_nodes = graph.to_dict()
	var tree_data = {nodes=nodes, tree=tree_nodes}
	return tree_data
