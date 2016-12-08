
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var s = 1
var charge = 0
var size = 0.5

var follow
var offset

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_scale(Vector2(0,1))
	offset = get_global_pos() - follow.get_ref().get_global_pos()

func _process(delta):
	if charge < 1:
		charge += delta
		set_scale(Vector2(lerp(0,size/2,charge),1))
		set_opacity(charge / 4)
		
		var f = follow.get_ref()
		if f != null:
			set_global_pos(f.get_global_pos() + offset)
		else:
			queue_free()
	else:
		s = lerp(s,-0.1,delta * 5)
		if s <= 0:
			queue_free()
			
		set_opacity(lerp(0,1,s))
		set_scale(Vector2(lerp(0,size,s),1))
