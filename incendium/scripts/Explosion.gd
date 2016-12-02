
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var velocity = Vector2(0,0)
var scale = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	var maxspd = get_node("RegularPolygon").size * 7
	velocity += Vector2(rand_range(-maxspd,maxspd),rand_range(-maxspd,maxspd))
	pass

func _process(delta):
	translate(velocity * scale * delta)
	scale -= delta * 2
	set_scale(Vector2(scale,scale))
	if scale <= 0:
		queue_free()
