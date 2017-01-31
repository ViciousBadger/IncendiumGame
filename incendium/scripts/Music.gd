
extends SamplePlayer

# member variables here, example:
# var a=2
# var b="textvar"

var stems = [
"kickdrum",
"bass",
"pad",
"synth",
"cymbal"
]

var voices = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_process_input(true)
	for stemname in stems:
		var i = play(stemname)
		var v = {}
		v.index = i
		v.on = false
		voices.append(v)
		set_volume(i, 0)
		
func _input(event):
	if event.type == InputEvent.KEY:
		if event.pressed == true:
			if event.scancode == KEY_0:
				toggle(0)
			if event.scancode == KEY_1:
				toggle(1)
			if event.scancode == KEY_2:
				toggle(2)
			if event.scancode == KEY_3:
				toggle(3)
			if event.scancode == KEY_4:
				toggle(4)

func toggle(i):
	voices[i].on = !voices[i].on

func _process(delta):
	for v in voices:
		var vol = get_volume(v.index)
		var targetvol = 0
		if v.on and vol < 1:
			set_volume(v.index, min(1, vol + delta * 0.2))
		if !v.on and vol > 0:
			set_volume(v.index, max(0, vol - delta * 0.2))
