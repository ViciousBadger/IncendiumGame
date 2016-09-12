
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
export var sides = 5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	get_node("RegularPolygon/Polygon2D").set_color(Color(1,0,0))
	
func _process(delta):
	rotate(delta)


