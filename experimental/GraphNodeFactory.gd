extends Resource

var node_classes = {

}

func add_base_type(base_type, node_cls):
	if not base_type in node_cls:
		node_classes[base_type] = node_cls

# TODO: only needs base_type and arg data?
func create_node(data, offset=Vector2()):
	var nd = node_classes[data.base_type].instance()
	if nd != null:
		data = data.duplicate(true)
		nd.from_data(data)
		nd.offset = offset
		return nd
	return null
