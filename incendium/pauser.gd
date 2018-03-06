extends ColorFrame

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	var target = 0
	if get_tree().is_paused():
		target = 1
	set_opacity(lerp(get_opacity(), target, delta * 10))

func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed():
		if event.scancode == KEY_P:
			get_tree().set_pause(!get_tree().is_paused())
			