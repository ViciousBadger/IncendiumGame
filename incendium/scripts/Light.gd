# LIGHT class
# Light that follows an object and flashes when told to despawn

extends Light2D

var a = 0
var despawn_a = 3
var despawn = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_energy(0)
	set_process(true)
	pass

func _process(delta):
	if !despawn:
		a = lerp(a, 1, delta * 2)
	else:
		a = lerp(a, 0, delta * 4)
		if a <= 0.01:
			queue_free()
	set_energy(a)

func despawn():
	despawn = true
	a = despawn_a
