extends GraphEdit

onready var context_menu = get_parent().get_node("PopupMenu")

# holds data on addable graph nodes
# currently selected node
var selected:Node

func _ready():
	connect("connection_request", self, "_connect_nodes")
	connect("disconnection_request", self, "_disconnect_nodes")
	connect("popup_request", self, "_popup")
	connect("_end_node_move", self, "_on_node_moved")
	connect("node_selected", self, "_on_node_selected")
			
# BUG: this fails if reconnecting before release
# func _input(event):
# 	if event is InputEventKey and not event.pressed and  event.scancode == KEY_A:
# 		print(get_connection_list())
# #		print(get_children())
		
###############################################################
# SIGNAL EVENTS

func _connect_nodes(from: String, from_slot: int, to: String, to_slot: int):
	if can_connect(from, from_slot, to, to_slot):
		connect_node(from, from_slot, to, to_slot)
		var nd_from = get_node(from)
		if nd_from.max_out > 1: # if many->many and not at capacity
			nd_from.on_output_connected()
			reorder_outputs(nd_from.name)
		
func _disconnect_nodes(from: String, from_slot: int, to: String, to_slot: int):
	disconnect_node(from, from_slot, to, to_slot)
	var nd_from = get_node(from)
	if nd_from.max_out > 1: # if many->many/one and ordering_y
		refresh_connections(get_links_out(from), nd_from)

func _popup(pos):
	context_menu.rect_position = pos
	context_menu.popup()

# func _context_item_pressed(i):
# 	pass
	
func _on_node_moved():
#	var p = get_parent_name(selected)
#	if p != null:
#		reorder_outputs(p)
##	elif selected != null and selected.max_out > 1:
##		reorder_outputs(selected.name)
		
	# NOTE: could be expensive for big trees
	# but a tree that big begets sufferance
	for c in get_connection_list():
		var nd = get_node(c.from)
		if nd.max_out > 1:
			reorder_outputs(nd.name)
			
	selected = null
	
func _on_node_selected(node):
	selected = node

###############################################################

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
	
func can_connect(from: String, from_slot: int, to: String, to_slot: int):
	# NOTE: this only applies for one2one nodes
	return from != to\
		and count_links_out(from, from_slot) < 1\
		and count_links_in(to, to_slot) < 1

func get_links_out(source):
	var cnl = get_connection_list()
	var n = []
	for c in cnl:
		if c.from == source:
			n.append(c)
	return n
		
func count_links_out(source, port):
	var cnl = get_connection_list()
	var n = 0
	for c in cnl:
		if c.from == source and c.from_port == port:
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
