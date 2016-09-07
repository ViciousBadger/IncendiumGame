
extends Polygon2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	var size = 100
	var vectors = Vector2Array()
	var n = 5
	for i in range(0,n):
		vectors.append(Vector2(cos(2 * PI * i / n) * size,sin(2 * PI * i / n) * size))
	set_polygon(vectors)
	get_child(0).get_child(0).set_polygon(vectors)
	set_color(Color(1.0,0.0,0.0))
	
func _process(delta):
	rotate(delta)


