extends Resource

var node_types = {
}

var node_classes = {

}

func setup(data):
	for base_type in data:
		for d in data[base_type]:
			add_node_type(base_type, d.duplicate())


# func get_node_data(type:String, node_name:String):
# 	for n in node_types[type]:
# 		if n.type == node_name:
# 			return n
# 	return null

func add_base_type(base_type, node_cls):
	if not base_type in node_types:
		node_types[base_type] = []
		node_classes[base_type] = node_cls

func add_node_type(base_type, display_name, args_type={}, args_export={}):
	if not args_type.empty():
		if args_export.empty():
			args_export = args_type.duplicate(true)
		else:
			for a in args_type:
				if not a in args_export:
					args_export[a] = get_default(args_type[a])
	var data = {
		base_type=base_type,
		display_name=display_name,
		args_type=args_type,
		args_export=args_export,
	}
	
	node_types[base_type].append(data)

# TODO: only needs base_type and arg data?
func create_node(data, offset=Vector2()):
	var nd = node_classes[data.base_type].instance()
	if nd != null:
		data = data.duplicate(true)
		nd.from_data(data)
		nd.offset = offset
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
		# TYPE_VECTOR2:
		# 	return Vector2()
	return null
