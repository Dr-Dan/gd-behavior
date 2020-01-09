tool
extends EditorScript

"""
Simple example
"""
const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const Tick = preload("res://addons/GDBehavior/Tick.gd")
const Seq = GDB.Composites.Sequencer

class Print:
	extends "res://addons/GDBehavior/Base/BTNode.gd"
	var msg

	func _init(msg).("print"):
		self.msg = msg

	func _exe(tick):
        print(msg)


var tick = Tick.new()

func print_hello_world():
    var root = Seq.new([Print.new("Hello"), Print.new("World!")])
    var tree_runner = BTRunner.new(root)
    
    # prints "Hello", "World!"; result = BTNode.SUCCESS
    var result = tree_runner.exe(tick)
    # root.exe(tick) # would also work as no running memory is required in tree
    
func _run():
    print_hello_world()