# BOSS PART class
# Handles shooting, health, movement and visual effects for a boss part.

extends Node2D

# Set by Boss
var enabled
var parent_part
var rot_speed
var id
var color
var max_health
var bullet_size
var bullet_count
var bullet_speed
var bullet_type
var shoot_interval
var usebeam = false
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

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	if enabled:
		get_node("RegularPolygon/Polygon2D").set_color(color)
	else:
		get_node("RegularPolygon/Polygon2D").set_color(Color(0,0,0,0))
	health = max_health
	last_pos = get_global_pos()
	usebeam = bullet_type == -1
	#usebeam = true
	
	set_scale(Vector2(0,0))
	
func _process(delta):
	rotate(delta * rot_speed)
	set_pos(get_parent().get_pos(id))
	
	if scale < 1:
		scale = min(1,lerp(scale, 1, delta * 4))
		set_scale(Vector2(scale * scale, scale * scale))
	
	if health_fade > 0:
		health_fade -= delta * 4
		if (health_fade < 0): health_fade = 0
		update()
	
	health_size = lerp(health_size, (1.0 - float(health) / max_health), delta * 12)
	
	if health < max_health:
		health += delta
		update()
	
	velocity = (get_global_pos() - last_pos) * delta
	last_pos = get_global_pos()
	
	var pos = get_global_pos()
	
	if enabled:
		shoot_timer -= delta
	
	if shoot_timer <= 0:
		shoot_timer = shoot_interval # + (angle_towards_center * 0.4)
		if !get_parent().has_children(id):
			scale = 0.95
			for i in range(0,bullet_count):
				if !usebeam:
					var bullet_instance = preload("res://objects/Bullet.tscn").instance()
					
					# Calculate bullet direction
					var velocityAngle
					if velocity.x == 0 and velocity.y == 0:
						# Use rotation if no velocity
						velocityAngle = get_rot() * 3
					else:
						velocityAngle = atan2(velocity.y,velocity.x)
					velocityAngle += (i / float(bullet_count)) * PI * 2
					var bulletVelocity = Vector2(cos(velocityAngle),sin(velocityAngle)).normalized() * (bullet_speed)
					
					bullet_instance.type = bullet_type
					bullet_instance.damage = bullet_size
					bullet_instance.velocity = bulletVelocity
					bullet_instance.get_node("RegularPolygon/Polygon2D").set_color(Color(1,1,1).linear_interpolate(color,0.4))
					bullet_instance.get_node("RegularPolygon").size = bullet_size
					bullet_instance.get_node("RegularPolygon").remove_from_group("damage_enemy")
					bullet_instance.get_node("RegularPolygon").add_to_group("damage_player")
					bullet_instance.set_pos(get_global_pos())
					get_tree().get_root().add_child(bullet_instance)
				else:
					var beam = preload("res://objects/Beam.tscn").instance()
					beam.follow = weakref(self)
					beam.set_pos(get_global_pos())
					beam.get_node("Sprite").set_modulate(get_node("RegularPolygon/Polygon2D").get_color().linear_interpolate(Color(1,1,1),0.5))
					
					var velocityAngle
					if velocity.x == 0 and velocity.y == 0:
						# Use rotation if no velocity
						velocityAngle = get_rot() * 3
					else:
						velocityAngle = atan2(velocity.x,velocity.y)
					velocityAngle += (i / float(bullet_count)) * PI * 2
					#var bulletVelocity = Vector2(cos(velocityAngle),sin(velocityAngle)).normalized() * (bullet_speed)
					beam.set_rot(velocityAngle)
					get_tree().get_root().add_child(beam)
	
func _on_RegularPolygon_area_enter(area):
	if area.get_groups().has("damage_enemy") and !get_parent().has_children(id) and enabled and scale > 0.5:
		area.get_parent().queue_free()
		health -= area.get_parent().damage
		health_fade = 1.0
		get_node("SamplePlayer").set_default_pitch_scale(rand_range(0.2,0.6) + (health / max_health))
		get_node("SamplePlayer").play("Hit_Hurt4")
		if health <= 0:
			for i in range(0,8):
				var explosion_instance = preload("res://objects/Explosion.tscn").instance()
				if i == 0:
					explosion_instance.get_node("SamplePlayer").set_default_pitch_scale((6 - get_node("RegularPolygon").size / 25) + rand_range(-0.5,0.5))
					explosion_instance.get_node("SamplePlayer").set_default_volume(get_node("RegularPolygon").size / 50)
					explosion_instance.get_node("SamplePlayer").play("Explosion21")
				explosion_instance.get_node("RegularPolygon").size = get_node("RegularPolygon").size / 2
				explosion_instance.get_node("RegularPolygon/Polygon2D").set_color(color)
				explosion_instance.velocity = velocity * 100
				get_tree().get_root().add_child(explosion_instance)
				explosion_instance.set_global_pos(get_global_pos())
			
			get_parent().dead_map[id] = true
			var light_instance = preload("res://objects/Light.tscn").instance()
			var s = get_node("RegularPolygon").size * 0.008
			light_instance.despawn_a = 1
			light_instance.set_scale(Vector2(s,s))
			light_instance.set_modulate(get_node("RegularPolygon/Polygon2D").get_color())
			get_tree().get_root().get_node("Game/Lights").add_child(light_instance)
			light_instance.set_global_pos(get_global_pos())
			light_instance.despawn()
			
			var game = get_tree().get_root().get_node("Game")
			game.add_score(get_node("RegularPolygon").size)
			
			queue_free()

func any_active_child_parts():
	for child in get_children():
		if child.get("enabled") == true:
			return true
		if child.get("enabled") == false:
			if child.any_active_child_parts():
				return true
	return false

func _draw():
	if health < max_health and health > 0: # if health_fade > 0: 
		var pgon = Vector2Array(get_node("RegularPolygon/Polygon2D").get_polygon())
		var colors = Array()
		for i in range(0,pgon.size()):
			pgon[i] = pgon[i] * health_size
			colors.append(Color(1,1,1,lerp(0.5,1,health_fade)))
		draw_polygon(pgon,colors)