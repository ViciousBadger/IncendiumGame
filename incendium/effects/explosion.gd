# EXPLOSION class
# just a circle that gets smaller

extends Node2D

const COL_VAR = 0.02

var velocity = Vector2(0,0)
var scale = 1

onready var fadespd = rand_range(2, 5)
onready var sprite = get_node("Sprite")

func init(size, color, white=false):
	var spdpct = rand_range(0,1)
	
	if white:
		color = color.linear_interpolate(Color(1,1,1), 1 - spdpct)
	
	var maxspd = size * 35
	var spd = spdpct * maxspd
	var angle = rand_range(0,PI*2)
	set_rot(rand_range(0,PI*2))
	velocity += Vector2(cos(angle),sin(angle)) * spd
	
	# Mix up the color brightness
	var b = rand_range(-COL_VAR, COL_VAR)
	sprite.set_modulate(Color(color.r+b,color.g+b,color.b+b))
	sprite.set_scale(Vector2(size,size) * 0.04)

func _ready():
	set_process(true)

func _process(delta):
	translate(velocity * scale * delta)
	scale = lerp(scale, 0, delta * fadespd) #delta * 0.2
	set_scale(Vector2(scale,scale))
	if scale <= 0.01:
		queue_free()
