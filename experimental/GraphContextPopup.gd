extends PopupMenu

signal on_menu_item_chosen(item_name, submenu_idx)

var submenus = {}

func create_submenu(node_name, display_name):
	var submenu = PopupMenu.new()
	submenu.set_name(node_name)
	add_child(submenu)
	add_submenu_item(display_name, node_name)
	submenus[node_name] = submenu
	submenus[node_name].connect("index_pressed", self, "_menu_item_pressed", [node_name])
	
	return submenu

func get_submenu(submenu_name):
	return submenus[submenu_name]
	
func add_submenu(menu_name):
	submenus[menu_name] = create_submenu("leaves", "Leaves")
	submenus[menu_name].connect("index_pressed", self, "_menu_item_pressed", [menu_name])
	
func _menu_item_pressed(i, menu_name):
	emit_signal("on_menu_item_chosen", menu_name, i)
