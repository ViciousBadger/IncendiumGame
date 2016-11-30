
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

var move = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	rotate(delta * 0.05)
	var c = get_tree().get_root().get_node("Game").fgcol
	set_modulate(Color(c.r,c.g,c.b,get_modulate().a))
	
	move += delta * 0.2
	var move_sin = sin(move) * 5
	
	var away_from_center = get_global_pos() - Vector2(720,720)/2
	translate(away_from_center.normalized() * delta * move_sin)


