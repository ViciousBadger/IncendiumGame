
extends Polygon2D

var speed = 420

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_key_pressed(KEY_LEFT):
		translate(Vector2(-delta,0) * speed)
	if Input.is_key_pressed(KEY_RIGHT):
		translate(Vector2(delta,0) * speed)
	if Input.is_key_pressed(KEY_UP):
		translate(Vector2(0,-delta) * speed)
	if Input.is_key_pressed(KEY_DOWN):
		translate(Vector2(0,delta) * speed)

func _on_Area2D_area_enter( area ):
	set_color(Color(0,1,0))
	pass # replace with function body


func _on_Area2D_area_exit( area ):
	set_color(Color(1,1,1))
	pass # replace with function body
