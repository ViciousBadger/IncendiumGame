
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var max_health = 100
var health
var health_fade = 0.0

var create_subparts = 4
var subpart = preload("res://objects/BossPart.tscn")
var color = Color(1,0,1)

var bullet = preload("res://objects/Bullet.tscn")
var shoot_timer = 1

var last_pos

var rot_speed = 0.3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	get_node("RegularPolygon/Polygon2D").set_color(color)
	health = max_health
	last_pos = get_global_pos()
	var mysize = get_node("RegularPolygon").size
	if create_subparts > 0:
		for i in range(0,3):
			var subpart_instance = subpart.instance()
			subpart_instance.get_node("RegularPolygon").size = mysize * 0.6
			subpart_instance.create_subparts = create_subparts - 1
			subpart_instance.color = Color(color.r - 0.2, color.g + 0.2, color.b)
			subpart_instance.max_health = max_health / 3.0
			subpart_instance.rot_speed = rot_speed + PI * 0.1
			# subpart_instance.shoot_timer = 1.0 + (i / 3.0)
			subpart_instance.set_draw_behind_parent(true)
			
			add_child(subpart_instance)
			
			var angle = (i / 3.0) * PI * 2.0
			var dir = Vector2(cos(angle),sin(angle))
			subpart_instance.set_pos(dir * mysize)
	
func _process(delta):
	rotate(delta * rot_speed)
	
	if (health_fade > 0):
		health_fade -= delta * 4
		if (health_fade < 0): health_fade = 0
		update()
	
	var velocity = get_global_pos() - last_pos
	last_pos = get_global_pos()
	
	var pos = get_global_pos()
	
	shoot_timer -= delta
	if shoot_timer <= 0 and get_child_count() <= 1:
		var bullets_to_create = create_subparts * 2 + 1
		for i in range(0,bullets_to_create):
			var bullet_instance = bullet.instance()
			
			var velocityAngle = atan2(velocity.y,velocity.x)
			if velocity.x == 0 and velocity.y == 0:
				velocityAngle = get_rot() * 3
			
			if create_subparts > 0:
				velocityAngle += (i / float(bullets_to_create)) * PI * 2
			
			var bulletVelocity = Vector2(cos(velocityAngle),sin(velocityAngle)).normalized() * (100 + 50 * create_subparts)
			
			bullet_instance.velocity = bulletVelocity
			bullet_instance.get_node("RegularPolygon").size = 2 + create_subparts * 2
			bullet_instance.get_node("RegularPolygon").remove_from_group("damage_enemy")
			bullet_instance.get_node("RegularPolygon").add_to_group("damage_player")
			bullet_instance.set_pos(get_global_pos())
			get_tree().get_root().add_child(bullet_instance)
			# var angle_towards_center = atan2(pos.x - 720/2, pos.y - 720/2)
			shoot_timer = 2 - (create_subparts * 0.45) # + (angle_towards_center * 0.4)
	
	
	
func _on_RegularPolygon_area_enter(area):
	if area.get_groups().has("damage_enemy") and get_child_count() <= 1:
		area.get_parent().queue_free()
		health -= 1
		health_fade = 1.0
		if health <= 0:
			queue_free()

func _draw():
	if health_fade > 0:
		var pgon = Vector2Array(get_node("RegularPolygon/Polygon2D").get_polygon())
		var colors = Array()
		for i in range(0,pgon.size()):
			pgon[i] = pgon[i] * (1.0 - float(health) / max_health)
			colors.append(Color(1,1,1,health_fade))
		draw_polygon(pgon,colors)