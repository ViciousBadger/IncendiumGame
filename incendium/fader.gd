extends ColorFrame

func _ready():
	set_process(true)
	
func _process(delta):
	if get_opacity() > 0:
		set_opacity(max(get_opacity() - delta / 2, 0))
