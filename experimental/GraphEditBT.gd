extends "GraphEditBody.gd"

signal on_node_selected(node, args_type)

const Composite = preload("res://experimental/Composite.tscn")
const Decorator = preload("res://experimental/Decorator.tscn")
const Leaf = preload("res://experimental/Leaf.tscn")

const LEAF = "leaf"
const COMPOSITE = "composite"
const DECORATOR = "decorator"

var graph_nodes = []

var node_types = {
	LEAF:[],
	COMPOSITE:[],
	DECORATOR:[]
}

var save_btn
var load_btn

func _ready():
	context_menu.create_submenu(LEAF, "Leaves")
	context_menu.create_submenu(COMPOSITE,"Composites")
	context_menu.create_submenu(DECORATOR,"Decorators")
	context_menu.connect("on_menu_item_chosen", self, "_menu_item_pressed")

	save_btn = Button.new()
	save_btn.text = "Save"
	get_zoom_hbox().add_child(save_btn)
	
	load_btn = Button.new()
	load_btn.text = "Load"
	get_zoom_hbox().add_child(load_btn)

func _menu_item_pressed(submenu_name, submenu_idx):
	var node_data = node_types[submenu_name][submenu_idx]
	create_node(submenu_name, node_data, context_menu.rect_position)

func create_node(type, data, offset=Vector2()):
	var nd = get_instance(type)
	if nd != null:
		data = data.duplicate(true)
		nd.from_data(data)
		nd.offset = offset
		add_child(nd)
		graph_nodes.append(nd)
		return nd
	return null

func get_instance(type):
	var nd = null
	match type:
		LEAF:
			nd = Leaf.instance()
		COMPOSITE:
			nd = Composite.instance()
		DECORATOR:
			nd = Decorator.instance()
	return nd
	

func get_node_data(type:String, node_name:String):
	for n in node_types[type]:
		if n.type == node_name:
			return n
	return null

	
func connect_nodes_easy(from:String, to:String):
	_connect_nodes(from, count_links_out(from), to, 0)


func add_node_type(node_type, data):
	data["type"] = node_type
	context_menu.get_submenu(node_type).add_item(data.display_name)
	node_types[node_type].append(data)
		
func add_leaf(node_data):
	add_node_type(LEAF, node_data.duplicate())

func add_composite(node_data):
	add_node_type(COMPOSITE, node_data.duplicate())

func add_decorator(node_data):
	add_node_type(DECORATOR, node_data.duplicate())


func get_nodes_dfs(root):
	var nodes = [get_node(root)]
	var children = get_links_out(root)
	for c in children:
		var next = get_node(c.to)
		if next.base_type == LEAF:
			nodes.append(next)
		else:
			nodes += get_nodes_dfs(c.to)

	return nodes

# result.children_ids is the offset from parent to child not absolute position in data
func get_nodes_dfs_data(root, i=[0]):
	var node = get_node(root)
	var data = node.to_data()
	data["index"] = i[0]
	data["children"] = []
	
	var nodes = [data]
	var temp_i = i[0]
	for c in get_links_out(root):
		i[0] += 1
		data.children.append(i[0]-temp_i)
		
		var next = get_node(c.to)
		if next.base_type == LEAF:
			var next_data = next.to_data()
			next_data["index"] = i[0]
			nodes.append(next.to_data())
		else:
			nodes += get_nodes_dfs_data(c.to, i)

	return nodes
	
# connection list looks like: [{from:"Source", from_port:0, to:"Dest", to_port:0}, ...]
func get_root_connection():
	for c in get_connection_list():
		if c.from == "Root":
			return c
	return null

func to_dict():
	var d = {}
	var r = get_root_connection()
	if r != null:
		d = get_nodes_dfs_data(r.to)
	return d
	
func from_data(data):
	clear_nodes()
	var nodes = []
	var start_pos = Vector2()
	for i in range(data.tree.size()-1, -1, -1):
		var nd_data = data.tree[i]
		var offset = Vector2(nd_data.offset_x, nd_data.offset_y)
		var node
		if "children" in nd_data:
			node = create_node(nd_data.base_type, get_node_data(nd_data.base_type, nd_data.type), offset)

			for j in nd_data.children:
				# current node is last added
				var c = nodes[nodes.size()-j]
				connect_nodes_easy(node.name, c.name)
		else:
			node = create_node(nd_data.base_type, get_node_data(nd_data.base_type, nd_data.type), offset)
			
		node.args_export = nd_data.args_export
		nodes.append(node)

	connect_nodes_easy($Root.name, nodes.back().name)
	return nodes.back()

func clear_nodes():
	clear_connections()
	for nd in graph_nodes:
		nd.queue_free()
	graph_nodes.clear()
