
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

var t = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	t += delta
	get_material().set_shader_param("t", t)


