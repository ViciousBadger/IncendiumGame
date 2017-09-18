extends SamplePlayer

var tracks = [
"1",
"2",
"3",
"4",
]

var playing

func _ready():
	set_process(true)
	playing = tracks[0]
	go()
	
func go():
	play(playing)
	
func _process(delta):
	pass
