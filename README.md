# GDBehavior

An addon for writing behavior trees in GDScript.
Written in Godot 3.1.

Influenced by https://github.com/godot-addons/godot-behavior-tree-plugin.

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
There currently is little reason to enable from the plugins menu other than being able to access scripts using BehaviorTree:

```gdscript
# Not enabled
const BT = preload("res://addons/GDBehavior/GDBehavior.gd")
var seq = BT.Composites.Sequencer.new(children)

# Enabled from Plugins menu
var seq = GDBehavior.Composites.Sequencer.new(children)
```

## Usage

The example should explain most things, otherwise look at the code.

If you are going to use composites with memory (SequencerMem) then you need to manually clear running history.
This will be automatically handled if using the TreeRunner class. Alternatively, this could be handled within the tick class.

Result constants are defined in the BTNode class (SUCCESS, FAILURE, RUNNING).

## Later...

* Conditional, Action Nodes
* More Decorators
* Documentation
* More Examples
* Logger
* Godot Node wrappers for BTNode/s
* Graph editor
* FSM (Basic, Stack, Hierarchical)
* Generated trees (GOAP, PPA)
* Tests
* JSON saving/loading