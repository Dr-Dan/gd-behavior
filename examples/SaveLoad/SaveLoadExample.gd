extends Node2D

"""
An example showing the save system.
Note that nodes need to be defined in seperate files as the script-path needs to be saved.
Also if a file is moved or renamed post-save, loading will fail.
"""

# ================================================================		
const Tick = preload("res://addons/GDBehavior/Tick.gd")

class TestTick:
	extends Tick
	
	var time_waited = {}
	var delta: float
	var actor
	
	func _init(actor):
		self.actor = actor
		
# ================================================================		

const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Composites = preload("res://addons/GDBehavior/Composites.gd")
const SeqMem = Composites.SequencerMem
const Parallel = Composites.Parallel

const Wait = preload("res://examples/SaveLoad/Actions/WaitDelta.gd")
const GotoRandom = preload("res://examples/SaveLoad/Actions/GotoRandom.gd")
const Speak = preload("res://examples/SaveLoad/Actions/SayRandom.gd")
const StopSpeaking = preload("res://examples/SaveLoad/Actions/StopSpeaking.gd")

const Utils = preload("res://addons/GDBehavior/Utils.gd")
const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")

onready var actors = $Actors.get_children()

var ticks = []
var tree_runner: BTRunner

# ================================================================		

func _ready() -> void:
	setup_behavior()

func _process(delta):
	run_behavior(delta)
		
# ================================================================		

func setup_behavior():
	var vp_sz = get_viewport_rect().size
	for a in actors:
		var tick = TestTick.new(a)
		ticks.append(tick)
		a.position = Vector2(randf() * vp_sz.x, randf() * vp_sz.y)
	
	var goto = SeqMem.new([
		GotoRandom.new(vp_sz, 400.0),
		Wait.new(1.0)])
		
	var speak = SeqMem.new([
		Speak.new(),
		Wait.new(2.0),
		StopSpeaking.new(),
		Wait.new(3.0)])

	var root = Parallel.new([goto, speak], 2)
	
	# just so you know it all works...
	
	# DATA
	
	# to_data returns a dictionary of tree data and actions
	# this is all handled in SaveLoad class and is not a necessary step.
	var data_save = Utils.to_data(root)
	
	print("-ACTIONS-")
	print(data_save.actions)
	print("-NODE DATA-")
	print(data_save.tree)
	
	# returns the root of a tree generated from 'data_save'
	root = Utils.from_data(data_save)

	
	# SAVING + LOADING

	var fldr_path = "user://gdbehavior/example/"
	var test_filename =  fldr_path + "bt_save_test.bt"
	
	var dir = Directory.new()
	if not dir.dir_exists(fldr_path):
		dir.make_dir_recursive(fldr_path)
		
	var saved = SaveLoad.save_tree(root, test_filename)
	var root_loaded = SaveLoad.load_tree(test_filename)

#	var destroyed = SaveLoad.delete_file(test_filename)
#	dir.remove(fldr_path)
	
	tree_runner = BTRunner.new(root_loaded)


func run_behavior(delta):
	for t in ticks:
		t.delta = delta
		tree_runner.exe(t)