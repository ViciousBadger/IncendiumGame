# BOSS PART class
# Handles shooting, health, movement and visual effects for a boss part.

extends Node2D

# Every var below this is set by Boss

#Stuff
var rot_speed
var id
var color
var max_health
# Shooting
var bullet_stats = preload("res://gameplay/bullets/BulletStats.gd").new()
var bullet_speed
var bullet_count
var bullet_patterns = []
var shoot_interval

# Every var below this is not set by Boss

# Health
var health
var health_fade = 0.0
var health_size = 0
# Shooting
var auto_active = true
var active
var shoot_timer = 2
# Misc
var last_pos
var velocity
var scale = 0.01
var outline_width = 0
# Outline alpha
var a = 0

func _ready():
	set_process(true)
	get_node("RegularPolygon/Polygon2D").set_color(Color(color.r,color.g,color.b,0.8))
	health = max_health
	last_pos = get_global_pos()
	
	var spd = 1
	for p in bullet_patterns:
		p.init(self, spd)
		spd *= 0.8
	
	set_scale(Vector2(0,0))
	
func _process(delta):
	if scale < 1:
		scale = min(1,lerp(scale, 1, delta * 4))
	
	# Update transform
	#rotate(delta * rot_speed)
	set_rot(get_parent().t * rot_speed)
	set_pos(get_parent().get_part_pos(id))
	set_scale(Vector2(1,1) * get_parent().get_part_scale(id) * scale * scale)
	
	# Health 'bar' stuff
	if health_fade > 0:
		health_fade -= delta * 4
		if (health_fade < 0): health_fade = 0
		update()
	health_size = lerp(health_size, (1.0 - float(health) / max_health), delta * 12)
	
	# Health auto regen
	if health < max_health:
		health += delta
		update()
	
	# Calc velocity
	velocity = (get_global_pos() - last_pos) * delta
	last_pos = get_global_pos()
	
	shoot_timer -= delta
	
	if auto_active:
		active = !get_parent().has_children(id)
	
	if active and a < 1:
		a = lerp(a, 1, delta * 5)
		update()
		
	if !active and a > 0:
		a = 0
		update()
	
func _on_RegularPolygon_area_enter(area):
	# Take damage
	if area.get_groups().has("damage_enemy") and active and scale > 0.5:
		area.get_parent().queue_free()
		health -= area.get_parent().stats.damage
		health_fade = 1.0
		
		# Sound
		#get_tree().get_root().get_node("Game/SFX").set_default_pitch_scale(rand_range(0.2,0.6) + (health / max_health))
		#get_tree().get_root().get_node("Game/SFX").play("Hit_Hurt4")
		
		# Dead?
		if health <= 0:
			# Explosion
			for i in range(0,get_node("RegularPolygon").size):
				var explosion_instance = preload("res://effects/Explosion.tscn").instance()
				if i == 0:
					get_tree().get_root().get_node("Game/SFX").set_default_pitch_scale(1 + rand_range(-0.5,0.5))
					get_tree().get_root().get_node("Game/SFX").play("explode4")
				explosion_instance.get_node("RegularPolygon").size = get_node("RegularPolygon").size / 4
				explosion_instance.get_node("RegularPolygon/Polygon2D").set_color(color)
				explosion_instance.velocity = velocity * 100
				get_tree().get_root().add_child(explosion_instance)
				explosion_instance.set_global_pos(get_global_pos())
			
			# Light
			var light_instance = preload("res://effects/Light.tscn").instance()
			var s = get_node("RegularPolygon").size * 0.008
			light_instance.despawn_a = 6
			light_instance.set_scale(Vector2(s,s))
			light_instance.set_modulate(get_node("RegularPolygon/Polygon2D").get_color())
			get_tree().get_root().get_node("Game/Lights").add_child(light_instance)
			light_instance.set_global_pos(get_global_pos())
			light_instance.despawn()
			
			# Score
			var game = get_tree().get_root().get_node("Game")
			game.add_score(get_node("RegularPolygon").size)
			
			# Deadmap
			get_parent().dead_map[id] = true
			
			# Done
			queue_free()

# Deprecated function for finding out if any child parts are active
func any_active_child_parts():
	for child in get_children():
		if child.get("enabled") == true:
			return true
		if child.get("enabled") == false:
			if child.any_active_child_parts():
				return true
	return false

func _draw():
	var pgon = Vector2Array(get_node("RegularPolygon/Polygon2D").get_polygon())
	
	# Draw health polygon
	if health < max_health and health > 0: # if health_fade > 0: 
		var hp_pgon = Vector2Array(pgon)
		for i in range(0,hp_pgon.size()):
			hp_pgon[i] = hp_pgon[i] * health_size
		draw_colored_polygon(hp_pgon,Color(1,1,1,lerp(0.5,1,health_fade)))
	
	# Draw outline
	if a > 0:
		for i in range(0,pgon.size()):
			var start = i
			var end = i+1
			if end >= pgon.size(): end = 0
			var col = Color(1,1,1,a).linear_interpolate(color, 0.5)
			draw_line(pgon[start], pgon[end], col, 3)