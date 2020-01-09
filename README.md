# GDBehavior

An addon for writing behavior trees in GDScript.
Written in Godot 3.1.

Influenced by https://github.com/godot-addons/godot-behavior-tree-plugin.

Also https://arxiv.org/pdf/1709.00084.pdf

## Philosophy

Behavior trees with maximum ease.

* Simple
* Extendable
* Good for:
  * learning
  * rapid prototyping
  * experimentation

## Installation
Download from the Godot Asset Store or place into the 'addons' folder in your project.
There currently is little reason to enable from the plugins menu other than being able to access scripts using GDBehavior:

```gdscript
# Not enabled
const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
var seq = GDB.Composites.Sequencer.new(children)

# Enabled from Plugins menu
var seq = GDBehavior.Composites.Sequencer.new(children)
```

## Usage

Behavior nodes extend BTNode

```gdscript
const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const Tick = preload("res://addons/GDBehavior/Tick.gd")

class Print:
	extends "res://addons/GDBehavior/Base/BTNode.gd"
	var msg

	func _init(msg).("print"):
		self.msg = msg

	func _exe(tick):
        print(msg)

const Seq = GDB.Composites.Sequencer
var tick = Tick.new()
func print_hello_world():
    var root = Seq.new([Print.new("Hello"), Print.new("World!")])
    var tree_runner = BTRunner.new(root)
    
    # prints "Hello", "World!"; result = BTNode.SUCCESS
    var result = tree_runner.exe(tick)
    # root.exe(tick) # would also work as no memory is required
    
```

The [example](https://github.com/Dr-Dan/gd-behavior/blob/master/examples/hellooo/TestScene.gd) should explain most things, otherwise look at the addon code.

If you are going to use composites with memory (i.e. SequencerMem) then:
* Call Tick.exit_tree(root, result) after execution
* Use TreeRunner.exe(tick) which will do so automatically

Result constants are defined in the BTNode class (SUCCESS, FAILURE, RUNNING).

## Later...

- [ ] Conditional, Action Nodes
- [ ] More Decorator Types
- [ ] Save/load tree
- [ ] Documentation
- [ ] More Examples
- [ ] Logger + GUI
- [ ] Generated trees (GOAP, PPA)
- [ ] Tests