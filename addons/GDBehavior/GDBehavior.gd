extends Node

const BTNode = preload("res://addons/GDBehavior/Base/BTNode.gd")
const BTDecorator = preload("res://addons/GDBehavior/Base/BTDecorator.gd")
const BTComposite = preload("res://addons/GDBehavior/Base/BTComposite.gd")

const TreeRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Tick = preload("res://addons/GDBehavior/Tick.gd")

const Composites = preload("res://addons/GDBehavior/Composites.gd")
const Decorators = preload("res://addons/GDBehavior/Decorators.gd")

const Seq = Composites.Sequencer
const SeqMem = Composites.SequencerMem
const Sel = Composites.Selector
const SelMem = Composites.SelectorMem
const Parallel = Composites.Parallel

const Succeeder = Decorators.Succeeder
const Invert = Decorators.Invert
const MultiCondition = Decorators.MultiCondition