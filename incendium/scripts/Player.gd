
extends Node2D

const SPEED = 420 /1.42
const FIRE_TIME = 0.05

export var polar_controls = false
var angle = 0
var dist = 200
var bullet_p = preload("res://objects/Bullet.tscn")
var fire_timer = 0

const MAX_HEALTH = 100
var health = MAX_HEALTH

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_key_pressed(KEY_LEFT):
		if polar_controls:
			angle += (delta / dist) * SPEED
		else:
			translate(Vector2(-delta,0) * SPEED)
	if Input.is_key_pressed(KEY_RIGHT):
		if polar_controls:
			angle -= (delta / dist) * SPEED
		else:
			translate(Vector2(delta,0) * SPEED)
	if Input.is_key_pressed(KEY_UP):
		if polar_controls:
			dist -= delta * SPEED
			if dist < 0.1: dist = 0.1
		else:
			translate(Vector2(0,-delta) * SPEED)
	if Input.is_key_pressed(KEY_DOWN):
		if polar_controls:
			dist += delta * SPEED 
		else:
			translate(Vector2(0,delta) * SPEED)
	
	var center = Vector2(720/2,720/2)
	
	if polar_controls:
		set_pos(center + Vector2(cos(angle),sin(angle)) * dist)

	var towards_center =  (center - get_pos()).normalized()
	
	if fire_timer > 0:
		fire_timer -= delta
	
	if (Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_F)) and fire_timer <= 0:
		var bullet = bullet_p.instance()
		bullet.set_pos(get_pos())
		bullet.velocity = towards_center * 800
		get_tree().get_root().add_child(bullet)
		fire_timer = FIRE_TIME

	set_rot(atan2(towards_center.x,towards_center.y) - PI/2)
	
	# Limit position to circle
	if center.distance_to(get_pos()) > 720/2:
		set_pos((get_pos() - center).normalized() * 720/2 + center)

func _on_RegularPolygon_area_enter( area ):
	get_node("RegularPolygon/Polygon2D").set_color(Color(0,1,0))
	if area.get_groups().has("damage_player"):
		area.get_parent().queue_free()
		var size = area.size
		health -= size
		get_node("../Label").set_text("HP: " + str(health) + "/" + str(MAX_HEALTH))
		if health <= 0:
			queue_free()

func _on_RegularPolygon_area_exit( area ):
	get_node("RegularPolygon/Polygon2D").set_color(Color(1,1,1))
