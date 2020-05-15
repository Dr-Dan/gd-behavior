extends GraphEdit

#signal _nodes_selected_drag(nodes)

const Utils = preload("res://addons/GDBehavior/Utils.gd")

onready var context_menu = get_node("PopupMenu")

# holds data on addable graph nodes
# currently selected node
var selected:Array
var graph_nodes = []

var dragging_node=false

var drag_start: Vector2
#var drag_end: Vector2

	
func _ready():
	connect("connection_request", self, "_connect_nodes")
	connect("disconnection_request", self, "_disconnect_nodes")
	connect("popup_request", self, "_popup")
	connect("node_selected", self, "_on_node_dragged")
	connect("_end_node_move", self, "_on_node_dropped")

	context_menu.connect("on_menu_item_chosen", self, "_menu_item_pressed")

func _menu_item_pressed(submenu_name, submenu_idx):
	pass
	
func _unhandled_key_input(event):
	if event.scancode == KEY_BACKSPACE:
		delete_selected()
		
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			var s = get_nodes_in_area(Rect2(event.position, Vector2()))
			if not s.empty():
				dragging_node = true
			else:
				drag_start = event.position
				
		elif not dragging_node:
			var start = Utils.min_Vector2(drag_start, event.position)
			var end = Utils.max_Vector2(drag_start, event.position)
			
			var r = Rect2(start, end-start)
			selected = get_nodes_in_area(r)
			
func get_nodes_in_area(rect:Rect2):
	var result = []
	for g in graph_nodes:
		if rect.intersects(g.get_rect()):
			result.append(g)
	return result
	
func delete_selected():
	for node in selected:
		var nodes = get_connections(node.name)
		for l in nodes:
			disconnect_node(l.from, l.from_port, l.to, l.to_port)
		graph_nodes.erase(node)
		node.queue_free()
		
	selected = []
		
###############################################################
# SIGNAL EVENTS

func _connect_nodes(from: String, from_slot: int, to: String, to_slot: int):
	if to != from and connect_node(from, from_slot, to, to_slot) == OK:
		var nd_from = get_node(from)
		if nd_from.max_out > 1: # if many->many and not at capacity
			nd_from.on_output_connected()
			reorder_outputs(nd_from.name)
		return true
	return false
		
func _disconnect_nodes(from: String, from_slot: int, to: String, to_slot: int):
	disconnect_node(from, from_slot, to, to_slot)
	var nd_from = get_node(from)
	if nd_from.max_out > 1: # if many->many/one and ordering_y
		refresh_connections(get_links_out(from), nd_from)

func _popup(pos):
	context_menu.rect_position = pos
	context_menu.popup()

func _on_node_dragged(node):
	dragging_node = true
	selected = [node]
	
func _on_node_dropped():
	dragging_node = false
	# NOTE: could be expensive for big trees
	# but a tree that big begets sufferance
	for c in get_connection_list():
		var nd = get_node(c.from)
		if nd.max_out > 1:
			reorder_outputs(nd.name)



###############################################################

func add_node_obj(nd):
	add_child(nd)
	graph_nodes.append(nd)
	return nd

func clear_nodes():
	clear_connections()
	for nd in graph_nodes:
		nd.queue_free()
	graph_nodes.clear()

	
func refresh_connections(data, node):
	var i = 0
	for l in data:
		disconnect_node(l.from, l.from_port, l.to, l.to_port)
		l.from_port = i
		i += 1
		
	node.clear_outputs()
	node.add_outputs(i)
	
	for l in data:
		connect_node(l.from, l.from_port, l.to, l.to_port)

func reorder_outputs(node_name:String):
#	get children
	var ch = get_links_out(node_name)
	if ch.size() <= 1:
		return
		
	var nodes = []
	for i in ch:
		nodes.append(get_node(i.to))
#	sort and re-id by y position (center)
	nodes.sort_custom(self, "_sort_y")
	var result = []
	for n in nodes:
		for c in ch:
			if n.name == c.to:
				result.append(c)
				continue
	refresh_connections(result, get_node(node_name))
		
func _sort_y(a, b):
	var ar = a.get_rect()
	var br = b.get_rect()
	return ar.position.y + ar.size.y/2 \
		< br.position.y + br.size.y/2


###############################################################
# UTILITIES
	
# func can_connect(from: String, from_slot: int, to: String, to_slot: int):
# 	# NOTE: this only applies for one2one nodes
# 	return from != to\
# 		and count_links_out(from, from_slot) < 1\
# 		and count_links_in(to, to_slot) < 1

func get_connections(node_name):
	return [] + get_links_in(node_name) + get_links_out(node_name)

func get_links_out(source:String):
	var cnl = get_connection_list()
	var n = []
	for c in cnl:
		if c.from == source:
			n.append(c)
	return n
		
func get_links_in(node:String):
	var cnl = get_connection_list()
	var n = []
	for c in cnl:
		if c.to == node:
			n.append(c)
	return n
	
func count_links_out(source, port=-1):
	var cnl = get_connection_list()
	var n = 0
	for c in cnl:
		if c.from == source and (port > 0 and c.from_port == port):
			n += 1
	return n
	
func get_parent_name(node):
	var cnl = get_connection_list()
	var n = 0
	for c in cnl:
		if c.to == node.name:
			return c.from
	return null
	
func count_links_in(source, port):
	var cnl = get_connection_list()
	var n = 0
	for c in cnl:
		if c.to == source and c.to_port == port:
			n += 1
	return n
