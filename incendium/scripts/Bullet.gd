
extends Node2D

# Bullet types
const BTYPE_COUNT = 2

const BTYPE_BASIC = 0
const BTYPE_ACCELERATING = 1
const BTYPE_CURVESHOT = 2

var velocity = Vector2(1000,0)
var type = BTYPE_BASIC
var lifetime = 5

var scale = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_scale(Vector2(0,0))
	set_process(true)

func _process(delta):
	if type == BTYPE_ACCELERATING:
		var length = velocity.length()
		length += delta * 100
		velocity = velocity.normalized() * length
	if type == BTYPE_CURVESHOT:
		var angle = atan2(velocity.y,velocity.x)
		angle += delta * 0.3
		var length = velocity.length()
		velocity = Vector2(cos(angle),sin(angle)) * length
	
	translate(velocity * delta)
	
	if scale < 1:
		scale = min(scale + delta / 0.1,1)
		set_scale(Vector2(scale,scale))
	
	lifetime -= delta
	var pos = get_pos()
	if pos.x < 0 or pos.y < 0 or pos.x > Globals.get("display/width") or pos.y > Globals.get("display/height") or lifetime <= 0:
		queue_free()
		
# func _exit_tree():
# 	var explosion_instance = explosion.instance()
# 	get_tree().get_root().add_child(explosion_instance)
# 	explosion_instance.set_global_pos(get_global_pos())