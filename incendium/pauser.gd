extends ColorFrame

func _ready():
	set_process(true)

func _process(delta):
	var target = 0
	if get_tree().is_paused():
		target = 1
	set_opacity(lerp(get_opacity(), target, delta * 10))