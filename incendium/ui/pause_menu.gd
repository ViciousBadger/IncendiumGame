extends Node

onready var wheel = get_node("OptionWheel")

func _ready():
	get_tree().set_pause(true)
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed():
		if event.scancode == KEY_ESCAPE:
			queue_free()

func _exit_tree():
	get_tree().set_pause(false)
