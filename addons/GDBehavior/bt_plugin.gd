tool
extends EditorPlugin

const LIB_NAME = 'GDBehavior'

func _enter_tree():
	self.add_autoload_singleton(LIB_NAME, "res://addons/GDBehavior/GDBehavior.gd")

func _exit_tree():
	self.remove_autoload_singleton(LIB_NAME)