extends PopupMenu

# var submenus = {}

func create_submenu(node_name, display_name):
	var submenu = PopupMenu.new()
	submenu.set_name(node_name)
	add_child(submenu)
	add_submenu_item(display_name, node_name)
	return submenu
