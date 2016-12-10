# PLAYER SHIELD class
# A shield that blocks bullets

extends Node2D

const TIME = 3.0

var poly

var a = 1 # Polygon alpha
var s = 0 # Shield scale
var t = TIME # Time till done

var done = false

var node_to_follow

func _ready():
	poly = get_node("RegularPolygon/Polygon2D")
	set_scale(Vector2(0,0))
	set_process(true)

func _process(delta):
	if !done:
		a = lerp(a,0.4,delta*10)
		s = lerp(s,1 - ((TIME - t) / TIME) * 0.5,delta*10)
		t -= delta
		if t < 0:
			done = true
	else:
		a = lerp(a,0,delta*20)
		if a < 0.01:
			queue_free()
	
	poly.set_color(Color(1,1,1,a))
	set_scale(Vector2(s,s))
	
	var node = get_tree().get_root().get_node(node_to_follow)
	if node != null:
		set_global_pos(node.get_global_pos())
	else:
		done = true


func _on_RegularPolygon_area_enter( area ):
	if area.get_groups().has("damage_player") and !done:
		area.get_parent().queue_free()