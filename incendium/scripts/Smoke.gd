# SMOKE class
# Background smoke

extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"'

var rot

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	rot = rand_range(-0.05,0.05)
	set_process(true)
	
func _process(delta):
	rotate(delta * rot)
	var c = get_tree().get_root().get_node("Game").fgcol
	set_modulate(Color(c.r,c.g,c.b,get_modulate().a))
	
	var towards_center = Vector2(720,720)/2 - get_global_pos()
	
	var move = Vector2(towards_center.y,-towards_center.x).normalized()
	
	translate(move * delta * 10)


