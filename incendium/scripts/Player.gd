
extends Node2D

const SPEED = 420 /1.42
const FIRE_TIME = 0.05

export var polar_controls = false
var angle = 0
var dist = 200
var bullet_p = preload("res://objects/Bullet.tscn")
var explosion = preload("res://objects/Explosion.tscn")
var shield_p = preload("res://objects/PlayerShield.tscn")
var shield_cooldown = 0
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
		bullet.velocity = towards_center * 600
		get_tree().get_root().add_child(bullet)
		fire_timer = FIRE_TIME
		
	if shield_cooldown > 0:
		shield_cooldown -= delta
	
	if Input.is_key_pressed(KEY_D) and shield_cooldown <= 0:
		var shield = shield_p.instance()
		shield.node_to_follow = get_path()
		get_tree().get_root().add_child(shield)
		shield.set_global_pos(get_global_pos())
		shield_cooldown = 3

	set_rot(atan2(towards_center.x,towards_center.y) - PI/2)
	
	# Limit position to circle
	if center.distance_to(get_pos()) > 720/2:
		set_pos((get_pos() - center).normalized() * 720/2 + center)

func _on_RegularPolygon_area_enter( area ):
	if area.get_groups().has("damage_player"):
		area.get_parent().queue_free()
		var size = area.size
		lose_health(size)
	if area.get_groups().has("damage_player_solid"):
		lose_health(100)

func lose_health(hp):
	health -= hp
	get_node("../Label").set_text("HP: " + str(health) + "/" + str(MAX_HEALTH))
	if health <= 0:
		for i in range(0,8):
			var explosion_instance = explosion.instance()
			explosion_instance.get_node("RegularPolygon").size = get_node("RegularPolygon").size
			explosion_instance.get_node("RegularPolygon/Polygon2D").set_color(get_node("RegularPolygon/Polygon2D").get_color())
			# explosion_instance.velocity = Vector2(0,0)
			get_tree().get_root().add_child(explosion_instance)
			explosion_instance.set_global_pos(get_global_pos())
		OS.set_time_scale(0.1)
		queue_free()

func _on_RegularPolygon_area_exit( area ):
	pass
