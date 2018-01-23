# EXPLOSION class
# just a circle that gets smaller

extends Node2D

var velocity = Vector2(0,0)
var scale = 1

onready var fadespd = rand_range(2, 5)

func _ready():
	set_process(true)
	var maxspd = get_node("RegularPolygon").size * 35
	
	var spd = rand_range(0,maxspd)
	var angle = rand_range(0,PI*2)
	
	velocity += Vector2(cos(angle),sin(angle)) * spd

func _process(delta):
	translate(velocity * scale * delta)
	scale = lerp(scale, 0, delta * fadespd) #delta * 0.2
	set_scale(Vector2(scale,scale))
	#var speed = velocity.length()
	#speed = lerp(speed, 0, delta * 4)
	#velocity = velocity.normalized() * speed
	if scale <= 0.01:
		queue_free()
