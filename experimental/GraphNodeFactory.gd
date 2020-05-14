extends Resource

const Composite = preload("res://experimental/Composite.tscn")
const Decorator = preload("res://experimental/Decorator.tscn")
const Leaf = preload("res://experimental/Leaf.tscn")

const LEAF = "leaf"
const COMPOSITE = "composite"
const DECORATOR = "decorator"

var node_types = {
	# LEAF:[],
	# COMPOSITE:[],
	# DECORATOR:[]
}

var node_classes = {

}


func get_node_data(type:String, node_name:String):
	for n in node_types[type]:
		if n.type == node_name:
			return n
	return null

func add_base_type(base_type, node_cls):
	if not base_type in node_types:
		node_types[base_type] = []
		node_classes[base_type] = node_cls

func add_node_type(base_type, node_type, data):
	data = data.duplicate(true)
	data["base_type"] = base_type
	data["type"] = node_type
	
	if "args_type" in data:
		if "args_export" in data:
			for a in data.args_type:
				if not a in data.args_export:
					data.args_export[a] = get_default(data.args_type[a])
		else:
			data.args_export = data.args_type.duplicate(true)
	node_types[base_type].append(data)

func create_node(data, offset=Vector2()):
	# var nd = get_instance(type)
	var nd = node_classes[data.base_type].instance()
	if nd != null:
		data = data.duplicate(true)
		nd.from_data(data)
		nd.offset = offset
		# add_child(nd)
		return nd
	return null

static func get_default(_type):
match _type:
	TYPE_STRING:
		return ""
	TYPE_INT:
		return 0
	TYPE_REAL:
		return 0.0
	TYPE_BOOL:
		return false
	TYPE_VECTOR2:
		return Vector2()
return null
