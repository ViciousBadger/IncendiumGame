extends Node2D

export(StringArray) var options

signal option_picked(name)

var selecti = 0

func _ready():
	set_process(true)
	set_process_input(true)
	get_node("RegularPolygon").sides = options.size()
	
func _process(delta):
	var rot = (selecti / float(options.size())) * PI * 2
	
	get_node("RegularPolygon").set_rot(lerp(get_node("RegularPolygon").get_rot(), rot, 10 * delta))
	pass
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		selecti -= 1
		print("left")
		if selecti < 0:
			selecti = options.size() - 1
	if event.is_action_pressed("ui_right"):
		selecti += 1
		print("right")
		if selecti >= options.size():
			selecti = 0
	if event.is_action_pressed("ui_accept"):
		print("use")
		emit_signal("option_picked", options[selecti])