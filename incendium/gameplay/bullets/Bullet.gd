# BULLET class
# wow a bullet

extends Node2D

# Bullet types
const BTYPE_COUNT = 2

const BTYPE_BASIC = 0
const BTYPE_ACCELERATING = 1
const BTYPE_CURVESHOT = 2
const BTYPE_CURVESHOT_CCW = 3
const BTYPE_SPLITTING = 4
var type = BTYPE_BASIC # TODO remove

# Set from outside before _ready() to change stats
var stats = preload("res://gameplay/bullets/BulletStats.gd").new()

var velocity = Vector2(1000,0)

# Timing/tweening
var lifetime = 6
var actiontime = 2
var scale = 0

# Light attached to the bullet
var light_instance

onready var collider = get_node("Area2D")
onready var sprite = get_node("Area2D/Sprite1")

func _ready():
	set_process(true)
	
	set_scale(Vector2(0,0))
	collider.set_scale(Vector2(stats.size,stats.size) * 0.1)
	sprite.set_modulate(stats.color)
	
	if stats.hostile:
		collider.add_to_group("damage_player")
	else:
		collider.add_to_group("damage_enemy")
	
	# Instance light
	var light = preload("res://effects/Light.tscn")
	light_instance = light.instance()
	var s = stats.size * 0.04
	light_instance.set_scale(Vector2(s,s))
	light_instance.set_modulate(sprite.get_modulate())
	get_tree().get_root().get_node("Game/Lights").add_child(light_instance)
	
	# Bullets with 1 damage cant split
	if type == BTYPE_SPLITTING && stats.damage == 1:
		type = BTYPE_BASIC

func _process(delta):
	# Update light pos
	light_instance.set_global_pos(get_global_pos())
	
	for mod in stats.mods:
		mod.update(self, delta)
	
	# Move
	translate(velocity * delta)
	
	# Tween scale
	if scale < 1:
		scale = min(1,lerp(scale,1,delta * 16))
		set_scale(Vector2(scale,scale))
	
	lifetime -= delta
	
	# Delete if at game border
	var pos = get_pos()
	var dist_to_center = pos.distance_to(Vector2(720/2,720/2))
	if dist_to_center > 720/2 or lifetime <= 0:
		queue_free()
		
func _exit_tree():
	# Explode when removed
	var expl = preload("res://effects/Explosion.tscn").instance()
	expl.velocity = -velocity * 0.5
	expl.get_node("RegularPolygon").size = stats.size
	var col = stats.color
	expl.get_node("RegularPolygon/Polygon2D").set_color(Color(col.r,col.g,col.b,0.5))
	get_tree().get_root().add_child(expl)
	expl.set_global_pos(get_global_pos())
	
	light_instance.despawn()