extends Node

var crumb_array = [
		{"id": "qwer", "name": "some project"},
		{"id": "asdf", "name": "some stage"},
		{"id": "zxcv", "name": "some boss"},
	]

func _ready():
	crumbs_updated()

func crumbs_updated():
	get_node("Breadcrumbs").set_breadcrumbs(crumb_array)

func _on_Breadcrumbs_Editor_pressed():
	crumb_array.resize(0)
	crumbs_updated()

func _on_Breadcrumbs_Project_pressed():
	crumb_array.resize(1)
	crumbs_updated()

func _on_Breadcrumbs_Stage_pressed():
	crumb_array.resize(2)
	crumbs_updated()