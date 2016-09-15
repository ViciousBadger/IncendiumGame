
extends Node2D

const SPEED = 420
const FIRE_TIME = 0.05

var angle = 0
var dist = 100
var bullet_p = preload("res://objects/Bullet.tscn")
var fire_timer = 0

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_key_pressed(KEY_LEFT):
		# angle += (delta / dist) * SPEED
		translate(Vector2(-delta,0) * SPEED)
	if Input.is_key_pressed(KEY_RIGHT):
		# angle -= (delta / dist) * SPEED
		translate(Vector2(delta,0) * SPEED)
	if Input.is_key_pressed(KEY_UP):
		# dist -= delta * SPEED
		# if dist < 0.1:
		# 	dist = 0.1
		translate(Vector2(0,-delta) * SPEED)
	if Input.is_key_pressed(KEY_DOWN):
		# dist += delta * SPEED 
		translate(Vector2(0,delta) * SPEED)
		
	var center = Vector2(720/2,720/2)
	
	# set_pos(center + Vector2(cos(angle),sin(angle)) * dist)

	var towards_center =  (center - get_pos()).normalized()
	
	if fire_timer > 0:
		fire_timer -= delta
	
	if Input.is_key_pressed(KEY_SPACE) and fire_timer <= 0:
		var bullet = bullet_p.instance()
		bullet.set_pos(get_pos())
		bullet.velocity = towards_center * 800
		get_tree().get_root().add_child(bullet)
		fire_timer = FIRE_TIME

	set_rot(atan2(towards_center.x,towards_center.y) - PI/2)

func _on_RegularPolygon_area_enter( area ):
	get_node("RegularPolygon/Polygon2D").set_color(Color(0,1,0))

func _on_RegularPolygon_area_exit( area ):
	get_node("RegularPolygon/Polygon2D").set_color(Color(1,1,1))
