
extends Sprite

var a = 0
var despawn = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_opacity(0)
	set_process(true)
	pass

func _process(delta):
	if !despawn:
		a = lerp(a, 0.1, delta * 2)
	else:
		a = lerp(a, 0, delta * 2)
		if a <= 0.01:
			queue_free()
	set_opacity(a)

func despawn():
	despawn = true
