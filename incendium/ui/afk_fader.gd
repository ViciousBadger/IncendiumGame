extends CanvasItem

const TIME = 5

var timer = TIME
var a = 1

func _ready():
	set_process(true)
	set_process_input(true)
	
func _input(event):
	if event.type != InputEvent.NONE:
		a = 1
		timer = TIME

func _process(delta):
	set_opacity(lerp(get_opacity(), a, delta))
	
	if timer > 0:
		timer -= delta
	else:
		if a > 0:
			a -= delta * 0.1