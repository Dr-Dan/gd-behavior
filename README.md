# GDBehavior

An addon for writing behavior trees in GDScript.
Written in Godot 3.1.

## Influences

* https://github.com/godot-addons/godot-behavior-tree-plugin
* [Behavior Trees in Robotics and AI](https://arxiv.org/pdf/1709.00084.pdf)

## Philosophy

* Simple
* Extendable
* Good for:
  * learning
  * rapid prototyping
  * experimentation

## Installation

Download from the Godot Asset Store or clone and place into the 'addons' folder in your project.

```gdscript
# Not enabled
const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
var seq = GDB.Composites.Sequencer.new(children)

# Enabled from Plugins menu
var seq = GDBehavior.Composites.Sequencer.new(children)
```
## Usage

[Examples](https://github.com/Dr-Dan/gd-behavior/blob/master/examples)

Result constants are defined in the BTNode class (SUCCESS, FAILURE, RUNNING).

Base node types (Action, Conditional, Composite, Decorator) are in GDBehavior/Base folder.

### The Tick

```gdscript
  var tick = Tick.new()
	var result = root.exe(tick)
```

The tick passes through each node in the tree in order of execution. By default, it holds a history of all nodes currently in a RUNNING state but it has  other uses such as holding a blackboard or logging tree history for debugging.

### Leaf Nodes
#### Action

```gdscript
class Print:
	extends "res://addons/GDBehavior/Base/BTAction.gd"
	var msg

	func _init(msg).("print"):
		self.msg = msg

  func _exe(tick):
      print(msg)
      return SUCCESS
    
```

Override the _exe function to apply an action's effects and be sure to return a result on completion.

_open, _closed, _enter, _exit functions are also inherited from BTNode via BTAction.

#### Condition
```gdscript
class AlwaysCondition:
	extends "res://addons/GDBehavior/Base/BTCondition.gd"
	var value:bool

	func _init(value:bool).("always-condition"):
		self.value = value

	func _validate(tick):
		return value	
```

Identical to BTAction except _validate is overriden (and returns a bool) instead of _exe.
This class is optional and will operate the same as an action return SUCCESS/FAILURE in place of true/false.
			
### Composites

```gdscript
# execute all 3 actions in order while result==SUCCESS
var wander = SequencerMem.new([
  GotoRandom.new(),
  Wait.new(2.0),
  LookAround()
])

var stay_safe = Selector.new([
  IsSafe.new(),
  # nesting is cool
  SequencerMem.new([
    EvadeThreat.new(),
    LookAround()
  ])
])
```

Composites expect children as an array of BTNodes.

If you are going to use composites with memory (i.e. SequencerMem) then:
* Call Tick.exit_tree(root, result) after each pass of the tree
* Or use TreeRunner.exe(tick) which will do so automatically

### Decorators
```gdscript
# SUCCESS = FAILURE and vice versa
var is_not_speaking = Invert.new(IsSpeaking.new())

MultiCondition.new(
  # if all conditions return SUCCESS
  [is_not_speaking, ActorInRange.new(80.0)],	
  # do this. (can be any type of node.)
  SayRandom.new())
```

Have a single child. Some example uses are guarding execution, modifying a result from the child and repeating execution of children.

### Saving and Loading
```gdscript
const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")
var file_path =  "user://gdbehavior/example/bt_save_test.bt"

var saved = SaveLoad.save_tree(root_node, file_path)

# returns root of loaded tree
var root_loaded = SaveLoad.load_tree(file_path)
```

[Saving and Loading Example](https://github.com/Dr-Dan/gd-behavior/blob/master/examples/SaveLoad/SaveLoadExample.gd)

The save and load implementation is in early stages and will likely change in the near future.