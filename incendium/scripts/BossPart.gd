# BOSS PART class
# Handles shooting, health, movement and visual effects for a boss part.

extends Node2D

# Every var below this is set by Boss

#Stuff
var parent_part
var rot_speed
var id
var color
var max_health
# Shooting
var bullet_stats = preload("res://structs/BulletStats.gd").new()
var bullet_speed
#var bullet_type
var bullet_count
var bullet_pattern = preload("res://bulletstuff/patterns/PtrnShotgun.gd").new()
var shoot_interval

# Every var below this is not set by Boss

# Health
var health
var health_fade = 0.0
var health_size = 0
# Shooting
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
	bullet_pattern.init(self)
	
	set_scale(Vector2(0,0))
	
func _process(delta):
	if scale < 1:
		scale = min(1,lerp(scale, 1, delta * 4))
	
	# Update transform
	rotate(delta * rot_speed)
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
	
	if !get_parent().has_children(id):
		a = lerp(a, 1, delta * 5)
		update()
	
	if bullet_pattern != null && !get_parent().has_children(id):
		bullet_pattern.update(delta)
		
	#if shoot_timer <= 0:
	#	shoot_timer = shoot_interval # + (angle_towards_center * 0.4)
	#	if !get_parent().has_children(id):
	#		scale = 0.95
	#		for i in range(0,bullet_count):

func fire_bullet(angle, speedmult):
	scale = 0.95
	var b = preload("res://objects/Bullet.tscn").instance()
	# Calculate bullet direction
	var velocityAngle
	if velocity.x == 0 and velocity.y == 0:
		# Use rotation if no velocity
		velocityAngle = get_rot() * 3
	else:
		velocityAngle = atan2(velocity.y,velocity.x)
	velocityAngle += angle
	#velocityAngle += (i / float(bullet_count)) * PI * 2
	var bulletVelocity = Vector2(cos(velocityAngle),sin(velocityAngle)).normalized() * (bullet_speed * speedmult)
	
	# Set bullet stats
	b.stats.hostile = true
	b.stats.damage = bullet_stats.damage #bullet_size * 2
	b.stats.color = Color(1,1,1).linear_interpolate(color,0.6)
	b.stats.size = bullet_stats.size
	b.velocity = bulletVelocity
	
	# K done
	b.set_pos(get_global_pos())
	get_tree().get_root().add_child(b)
	
func _on_RegularPolygon_area_enter(area):
	# Take damage
	if area.get_groups().has("damage_enemy") and !get_parent().has_children(id) and scale > 0.5:
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
				var explosion_instance = preload("res://objects/Explosion.tscn").instance()
				if i == 0:
					get_tree().get_root().get_node("Game/SFX").set_default_pitch_scale(1 + rand_range(-0.5,0.5))
					get_tree().get_root().get_node("Game/SFX").play("explode4")
				explosion_instance.get_node("RegularPolygon").size = get_node("RegularPolygon").size / 4
				explosion_instance.get_node("RegularPolygon/Polygon2D").set_color(color)
				explosion_instance.velocity = velocity * 100
				get_tree().get_root().add_child(explosion_instance)
				explosion_instance.set_global_pos(get_global_pos())
			
			# Light
			var light_instance = preload("res://objects/Light.tscn").instance()
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
			draw_line(pgon[start], pgon[end], col, 2)