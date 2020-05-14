extends "GraphEditBody.gd"

signal on_node_selected(node, args_type)

const Composite = preload("res://experimental/Composite.tscn")
const Decorator = preload("res://experimental/Decorator.tscn")
const Leaf = preload("res://experimental/Leaf.tscn")
const NodeFactory = preload("res://experimental/GraphNodeFactory.gd")

const LEAF = "leaf"
const COMPOSITE = "composite"
const DECORATOR = "decorator"

var graph_nodes = []
var node_factory = NodeFactory.new()

var save_btn
var load_btn

func _ready():
	context_menu.connect("on_menu_item_chosen", self, "_menu_item_pressed")

	context_menu.create_submenu(LEAF, "Leaves")
	context_menu.create_submenu(COMPOSITE,"Composites")
	context_menu.create_submenu(DECORATOR,"Decorators")

	node_factory.add_base_type(LEAF, Leaf)
	node_factory.add_base_type(COMPOSITE, Composite)
	node_factory.add_base_type(DECORATOR, Decorator)

	save_btn = Button.new()
	save_btn.text = "Save"
	get_zoom_hbox().add_child(save_btn)
	
	load_btn = Button.new()
	load_btn.text = "Load"
	get_zoom_hbox().add_child(load_btn)


func _menu_item_pressed(submenu_name, submenu_idx):
	var node_data = node_factory.node_types[submenu_name][submenu_idx]
	var node = node_factory.create_node(node_data, context_menu.rect_position)
	if node != null:
		add_node_obj(node)

func add_node_obj(nd):
	add_child(nd)
	graph_nodes.append(nd)
	return nd

func add_node_type(base_type, node_type, data):
	node_factory.add_node_type(base_type, node_type, data)
	context_menu.get_submenu(base_type).add_item(data.display_name)
		
func connect_nodes_easy(from:String, to:String):
	_connect_nodes(from, count_links_out(from), to, 0)
		
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

# USES: children, index, base_type
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
			nodes.append(next_data)
		else:
			nodes += get_nodes_dfs_data(c.to, i)

	return nodes
	
# USES: children, index, base_type, offset
func from_data(data):
	clear_nodes()
	var nodes = []
	var start_pos = Vector2()
	for i in range(data.tree.size()-1, -1, -1):
		var nd_data = data.tree[i]
		var offset = Vector2(nd_data.offset_x, nd_data.offset_y)
		var node
		if "children" in nd_data:
			node = node_factory.create_node(nd_data, offset)
			add_node_obj(node)

			for j in nd_data.children:
				# current node is last added
				var c = nodes[nodes.size()-j]
				connect_nodes_easy(node.name, c.name)
		else:
			node = node_factory.create_node(nd_data, offset)
			add_node_obj(node)
			
		# node.args_export = nd_data.args_export
		nodes.append(node)

	connect_nodes_easy($Root.name, nodes.back().name)
	return nodes.back()

func clear_nodes():
	clear_connections()
	for nd in graph_nodes:
		nd.queue_free()
	graph_nodes.clear()
