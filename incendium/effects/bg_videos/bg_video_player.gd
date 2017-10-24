extends VideoPlayer

var cur = -1

var clips = [
	#preload("res://effects/bg_videos/mandelbrot.ogv"),
	preload("res://effects/bg_videos/sunrise.ogv"),
	preload("res://effects/bg_videos/desert.ogv"),
	preload("res://effects/bg_videos/rainforest1.ogv"),
	preload("res://effects/bg_videos/rainforest2.ogv"),
	preload("res://effects/bg_videos/rainforest3.ogv"),
	preload("res://effects/bg_videos/whale.ogv"),
]

func _ready():
	set_process(true)
	randomize()

func _process(delta):
	if (!is_playing()):
		#var i = randi()%clips.size()
		#print ("playing " + str(i))
		cur += 1
		cur = cur % clips.size()
		var i = cur
		set_stream(clips[i])
		play()