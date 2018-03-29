extends Node

onready var e_p = get_node("HBox/Editor-Project")
onready var p = get_node("HBox/Project")
onready var p_s = get_node("HBox/Project-Stage")
onready var s = get_node("HBox/Stage")
onready var s_b = get_node("HBox/Stage-Boss")
onready var b = get_node("HBox/Boss")

onready var chain = [p, s, b]
onready var seperators = [e_p, p_s, s_b]

func set_breadcrumbs(crumb_array):
	for i in range(chain.size()):
		var link = chain[i]
		var sep = seperators[i]
		if crumb_array.size() > i:
			link.show()
			sep.show()
			link.set_text(crumb_array[i].name)
		else:
			link.hide()
			sep.hide()