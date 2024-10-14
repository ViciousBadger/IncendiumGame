# PLAYER class
# Moves n shoots

extends Node2D

var player_shield_s = preload("res://gameplay/player/player_shield.tscn")
var explosion_s = preload("res://effects/explosion.tscn")
var light_s = preload("res://effects/light.tscn")
var bullet_s = preload("res://gameplay/bullets/bullet.tscn")

const SPEED = 300
const ACCEL = 3000
const SHOOTING_MULT = 0.6

export var polar_controls = false
var use_mouse = false
var angle = 0
var dist = 200
var shield_cooldown = 0
var fire_timer = 0
var velocity = Vector2(0,0)
var speed_mult = 1

const MAX_HEALTH = 5
var health = MAX_HEALTH

var inv_time = 0

var col = Color(1,1,1)

func _ready():
	set_process(true)
	set_process_input(true)
	
func _input(event):
	# Input method switching
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_M && event.pressed == true:
			use_mouse = !use_mouse

func _process(delta):
	# Input gathering
	var input_vec = Vector2(0,0)
	# Keyboard
	if !use_mouse:
		if Input.is_key_pressed(KEY_LEFT):
			input_vec += Vector2(-1,0)
		if Input.is_key_pressed(KEY_RIGHT):
			input_vec += Vector2(1,0)
		if Input.is_key_pressed(KEY_UP):
			input_vec += Vector2(0,-1)
		if Input.is_key_pressed(KEY_DOWN):
			input_vec += Vector2(0,1)
	# Mouse
	else:
		var mouse_pos = get_viewport().get_mouse_pos()
		
		var relative_pos = mouse_pos - get_global_pos()
		
		if relative_pos.length() > velocity.length():
			input_vec = relative_pos.normalized()
			
	# Shooting INPUT
	var shooting = false
	if use_mouse:
		shooting = Input.is_mouse_button_pressed(BUTTON_LEFT)
	else:
		shooting = Input.is_key_pressed(KEY_SPACE) || Input.is_key_pressed(KEY_F)
	
	# Normal movement
	if !polar_controls:
		var mult = 1
		if shooting:
			mult = SHOOTING_MULT
		
		var target_velocity = input_vec.normalized() * SPEED * mult
		
		var towards_target = target_velocity - velocity
		var dist_to_target = towards_target.length()
		towards_target = towards_target.normalized()
		towards_target *= min(ACCEL * delta * mult, dist_to_target)
		
		velocity += towards_target
		translate(velocity * delta)
	
	#TODO: Polar movement
				#if polar_controls:
				#angle += (delta / dist) * SPEED
				
				#if polar_controls:
				#angle -= (delta / dist) * SPEED
				
				#if polar_controls:
				#dist -= delta * SPEED
				#if dist < 0.1: dist = 0.1
				
				#if polar_controls:
				#dist += delta * SPEED 
				
				#if polar_controls:
				#	set_pos(center + Vector2(cos(angle),sin(angle)) * dist)
	
	var center = Vector2(720/2,720/2)
	var towards_center =  (center - get_pos()).normalized()
	
	# Rotate towards center
	set_rot(atan2(towards_center.x,towards_center.y) - PI/2)
	
	# Limit position to circle
	if center.distance_to(get_pos()) > 720/2:
		set_pos((get_pos() - center).normalized() * 720/2 + center)
	
	col = col.linear_interpolate(Color(1,1,1),delta * 10)
	get_node("RegularPolygon/Polygon2D").set_color(col)
	
	# Timers
	if inv_time > 0:
		inv_time -= delta
	
	if fire_timer > 0:
		fire_timer -= delta
		
	if shield_cooldown > 0:
		shield_cooldown -= delta
	
	# Shooting
	if shooting && fire_timer <= 0:
		var bullet = bullet_s.instance()
		bullet.set_pos(get_pos())
		get_tree().get_root().get_node("Game/SFX").set_default_pitch_scale(rand_range(0.9,1.1))
		get_tree().get_root().get_node("Game/SFX").play("Laser_Shoot14")
		#bullet.get_node("RegularPolygon").size = 1
		bullet.stats.size = 3
		bullet.stats.damage = 1
		
		var dir = atan2(towards_center.y,towards_center.x)
		var len = 600
		
		var spread = 0.05
		var rot = rand_range(-spread,spread)
		var final = dir + rot
		
		bullet.velocity = Vector2(cos(final),sin(final)) * len
		get_tree().get_root().get_node("Game/Bullets").add_child(bullet,false)
		fire_timer = 0.05
	
	# Shield
	var shielding = false
	if use_mouse:
		shielding = Input.is_mouse_button_pressed(BUTTON_RIGHT)
	else:
		shielding = Input.is_key_pressed(KEY_D)

	if shielding && shield_cooldown <= 0:
		var shield = player_shield_s.instance()
		shield.node_to_follow = get_path()
		get_tree().get_root().add_child(shield)
		shield.set_global_pos(get_global_pos())
		shield_cooldown = 6

func _on_RegularPolygon_area_enter( area ):
	if area.get_groups().has("damage_player"):
		var bullet = area.get_parent()
		bullet.queue_free()
		#var dmgtotake = bullet.stats.damage * 2
		var dmgtotake = 1
		lose_health(dmgtotake)
	if area.get_groups().has("damage_player_solid"):
		lose_health(100)

func lose_health(hp):
	if inv_time <= 0:
		health -= hp
		#inv_time = 1
		col = Color(1,0,0)
		get_parent().score_mult = 1
		get_parent().score_mult_timer = 0
		
		var l = light_s.instance()
		get_tree().get_root().get_node("Game/Background/Lights").add_child(l)
		l.despawn_a = 4
		l.set_global_pos(get_global_pos())
		l.despawn()
		
		if health <= 0:
			for i in range(0, 32):
				var expl = explosion_s.instance()
				expl.velocity = velocity
				get_tree().get_root().get_node("Game/Explosions").add_child(expl)
				expl.init(8, Color(1,1,1))
				expl.set_global_pos(get_global_pos())
			
			l.despawn_a = 4
			l.set_scale(Vector2(1,1) * 0.5)
			l.set_modulate(Color(1,1,1))
			
			queue_free()
		else:
			l.despawn_a = 0.5
			l.set_scale(Vector2(1,1) * 0.1)
			l.set_modulate(Color(1,0,0))

func _on_RegularPolygon_area_exit( area ):
	pass
