extends Node2D

var bullet_s = preload("res://gameplay/bullets/Bullet.tscn")

# Node references
onready var bosspart = get_node("..")

var design = preload("res://gameplay/bosses/boss_design_turret.gd").new()
# Instance of bullet pattern to use
var pattern

var velocity
var last_pos

func _ready():
	pattern = design.pattern.new()
	pattern.init(self)
	last_pos = get_global_pos()
	set_process(true)
	
func _process(delta):
	velocity = (get_global_pos() - last_pos) * delta
	last_pos = get_global_pos()
	
	if bosspart.active:
		pattern.update(delta)

func get_shoot_interval(): return design.shoot_interval
func get_bullet_count(): return design.bullet_count

func fire_bullet(angle, speedmult):
	bosspart.scale = 0.95
	var b = bullet_s.instance()
	
	# Calculate bullet velocity
	var velocityAngle
	if velocity.x == 0 and velocity.y == 0:
		# Use rotation if no velocity
		velocityAngle = get_global_rot() * 3
	else:
		velocityAngle = atan2(velocity.y, velocity.x)
	velocityAngle += angle + design.bullet_angle # Add on angle from pattern and design
	var bulletVelocity = Vector2(cos(velocityAngle),sin(velocityAngle)).normalized() * (design.bullet_speed * speedmult)
	
	# Set bullet stats
	b.stats.hostile = true
	b.stats.mods = design.mods
	b.stats.color = bosspart.color
	b.stats.size = design.size
	b.velocity = bulletVelocity
	
	# K done
	b.set_pos(get_global_pos())
	get_tree().get_root().add_child(b)