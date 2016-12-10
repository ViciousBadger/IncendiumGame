# BULLET class
# wow a bullet

extends Node2D

# Bullet types
const BTYPE_COUNT = 2

const BTYPE_BASIC = 0
const BTYPE_ACCELERATING = 1
const BTYPE_CURVESHOT = 2
const BTYPE_SPLITTING = 3

var velocity = Vector2(1000,0)
var type = BTYPE_BASIC
var lifetime = 6

var actiontime = 2

var scale = 0
var light_instance

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_scale(Vector2(0,0))
	set_process(true)
	
	# Light
	var light = preload("res://objects/Light.tscn")
	light_instance = light.instance()
	var s = get_node("RegularPolygon").size * 0.04
	light_instance.set_scale(Vector2(s,s))
	light_instance.set_modulate(get_node("RegularPolygon/Polygon2D").get_color())
	get_tree().get_root().get_node("Game/Lights").add_child(light_instance)

func _process(delta):
	light_instance.set_global_pos(get_global_pos())
	if type == BTYPE_ACCELERATING:
		var length = velocity.length()
		length += delta * 100
		velocity = velocity.normalized() * length
	if type == BTYPE_CURVESHOT:
		var angle = atan2(velocity.y,velocity.x)
		var length = velocity.length()
		angle += delta * length * 0.005
		velocity = Vector2(cos(angle),sin(angle)) * length
	
	translate(velocity * delta)
	
	if scale < 1:
		scale = min(1,lerp(scale,1,delta * 16))
		set_scale(Vector2(scale,scale))
	
	lifetime -= delta
	
	if actiontime > 0:
		actiontime -= delta
		if actiontime <= 0:
			if type == BTYPE_SPLITTING:
				for i in range(0,2):
					var bullet_instance = preload("res://objects/Bullet.tscn").instance()
					bullet_instance.type = BTYPE_BASIC
					bullet_instance.get_node("RegularPolygon").remove_from_group("damage_enemy")
					bullet_instance.get_node("RegularPolygon").add_to_group("damage_player")
					bullet_instance.get_node("RegularPolygon/Polygon2D").set_color(get_node("RegularPolygon/Polygon2D").get_color())
					bullet_instance.get_node("RegularPolygon").size = get_node("RegularPolygon").size / 2.0
					var angleoffset = -0.3
					if i == 1: angleoffset = 0.3
					var angle = atan2(velocity.y,velocity.x) + angleoffset
					bullet_instance.velocity = Vector2(cos(angle),sin(angle)) * velocity.length()
					get_tree().get_root().add_child(bullet_instance)
					bullet_instance.set_global_pos(get_global_pos())
				queue_free()
	
	var pos = get_pos()
	
	var dist_to_center = pos.distance_to(Vector2(720/2,720/2))
	
	if dist_to_center > 720/2 or lifetime <= 0:
		queue_free()
		
func _exit_tree():
	var explosion_instance = preload("res://objects/Explosion.tscn").instance()
	explosion_instance.velocity = -velocity * 0.5
	explosion_instance.get_node("RegularPolygon").size = get_node("RegularPolygon").size
	var col = get_node("RegularPolygon/Polygon2D").get_color()
	explosion_instance.get_node("RegularPolygon/Polygon2D").set_color(Color(col.r,col.g,col.b,0.5))
	get_tree().get_root().add_child(explosion_instance)
	explosion_instance.set_global_pos(get_global_pos())
	light_instance.despawn()