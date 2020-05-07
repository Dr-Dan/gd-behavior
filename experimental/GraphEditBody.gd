extends GraphEdit

const Composite = preload("res://experimental/Composite.gd")

# 
#const NODES = {
#	Composites=[
#		{sub="Composites", dname="Composite", scn=preload("res://experimental/Composite.tscn")},
#	],
#	Leaves=[
#		{sub="Leaves", dname="Leaf", scn=preload("res://experimental/Leaf.tscn")}
#	]
#}

const NODES = [
	{sub="Composites", dname="Composite", scn=preload("res://experimental/Composite.tscn")},
	{sub="Leaves", dname="Leaf", scn=preload("res://experimental/Leaf.tscn")}
]


onready var context_menu = get_parent().get_node("PopupMenu")
func _ready():
	for i in NODES:
#		var subsubmenu = PopupMenu.new()
#		subsubmenu.set_name(i.sub)
#		subsubmenu.add_item(i.dname)
#		context_menu.add_child(subsubmenu)
#		context_menu.add_submenu_item(i.dname, i.sub)
#		for c in NODES[i]:
#		context_menu.add_separator(i.sub)
		context_menu.add_item(i.dname)
	context_menu.connect("index_pressed", self, "_context_item_pressed")
	
	connect("connection_request", self, "_connect_nodes")
	connect("disconnection_request", self, "_disconnect_nodes")
#	connect("connection_to_empty", self, "_drop_link")
	connect("popup_request", self, "_popup")
	
func _connect_nodes(from: String, from_slot: int, to: String, to_slot: int):
	if can_connect(from, from_slot, to, to_slot):
		connect_node(from, from_slot, to, to_slot)
		var nd = get_node(from)
		if nd is Composite:
			nd.add_output()

func can_connect(from: String, from_slot: int, to: String, to_slot: int):
	return from != to\
		and count_links_out(from, from_slot) < 1\
		and count_links_in(to, to_slot) < 1
	
func count_links_out(source, port):
	var cnl = get_connection_list()
	var n = 0
	for c in cnl:
		if c.from == source and c.from_port == port:
			n += 1
	return n
	
func count_links_in(source, port):
	var cnl = get_connection_list()
	var n = 0
	for c in cnl:
		if c.to == source and c.to_port == port:
			n += 1
	return n
	
var dc = false
var dnd = null
var ds = -1

func _disconnect_nodes(from: String, from_slot: int, to: String, to_slot: int):
	disconnect_node(from, from_slot, to, to_slot)
	var nd = get_node(from)
	if nd is Composite:
		dc = true
		dnd = nd
		ds = from_slot

#func _drop_link(from: String, from_slot: int, release_position: Vector2):

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			if dc:
				dnd.remove_output(ds)
				dc = false
				dnd = null
				ds = -1

func _popup(pos):
	context_menu.rect_position = pos
	context_menu.popup()

func _context_item_pressed(i):
	var cmp = NODES[i].scn.instance()
	cmp.offset = context_menu.rect_position
	add_child(cmp)
