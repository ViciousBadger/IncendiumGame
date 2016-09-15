
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

const max_health = 20
var health = max_health
var health_fade = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	get_node("RegularPolygon/Polygon2D").set_color(Color(1,0,0))
	pass
	
func _process(delta):
	rotate(delta)
	
	if (health_fade > 0):
		health_fade -= delta * 4
		if (health_fade < 0): health_fade = 0
		update()
	
func _on_RegularPolygon_area_enter( area ):
	health -= 1
	health_fade = 1.0
	if health <= 0:
		queue_free()

func _draw():
	var pgon = Vector2Array(get_node("RegularPolygon/Polygon2D").get_polygon())
	var colors = Array()
	for i in range(0,pgon.size()):
		pgon[i] = pgon[i] * (1.0 - float(health) / max_health)
		print(health / max_health)
		colors.append(Color(1,1,1,health_fade))
	draw_polygon(pgon,colors)