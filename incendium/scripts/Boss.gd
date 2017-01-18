# BOSS class
# Generates all boss parts from a bunch of parameters
# and despawns once all parts are destroyed.

extends Node2D

var layers = [3,3,3,3]
var bullettypes = [0,0,0,0]
var regex = ".*"

var base_size = 100
var size_dropoff = 0.6

var base_health = 80

var base_rot_speed = 0.3
var rot_speed_inc = - PI * 0.1

var start_color = Color(0,0,1)
var end_color = Color(0,1,0)

var expr
var map
var part_map
var dead_map
var t = 0

func _ready():
	expr = RegEx.new()
	expr.compile(regex)
	
	if !expr.is_valid():
		print ("invalid regex!")
	
	part_map = {}
	dead_map = {}
	create_part("", Vector2(0,0), 0, 0, 1, base_health)
	set_process(true)
	pass
	
func _process(delta):
	t += delta
	map = {}
	if get_child_count() == 0:
		# Boss is a goner
		OS.set_time_scale(0.2)
		queue_free()
	
func has_children(id):
	if(id.length() == layers.size()):
		return false
	if(dead_map.has(id)):
		return false
	var sides = layers[id.length()-1]
	for i in range(sides): #Loop though all potential child parts of this part
		var child_id = id + str(i)
		if(has_children(child_id)):
			return true
		if(part_map.has(child_id) && !dead_map.has(child_id)):
			return true
	return false
	

func get_pos(id):
	if(map.has(id)):
		return map.id
	if(id==""):
		return Vector2(0, 0)
	var c = id[-1].to_int()
	var parent_pos = get_pos(id.substr(0,id.length()-1))
	var theta = (base_rot_speed + (id.length()-1)*rot_speed_inc) * t + c / layers[id.length()-1] * 2 * PI
	var r = base_size * pow(size_dropoff, id.length()-1)
	var pos = parent_pos + Vector2(r * cos(-theta), r*sin(-theta)) 
	map.id = pos
	return pos

func create_part(id, pos, layer, index, parentsides, health):
	var sides = layers[layer]
	var a = layer / float(layers.size() - 1)
	var size = base_size * pow(size_dropoff, layer)
	
	# Check if any capture group in the boss' regex matches this boss part's entire id
	var find = expr.find(id)
	var alive = false
	for s in expr.get_captures():
		if(s == id):
			alive = true
			break
	
	if alive || id == "":
		var part_instance = preload("res://objects/BossPart.tscn").instance()
		# Set values
		part_instance.get_node("RegularPolygon").sides = sides
		part_instance.get_node("RegularPolygon").size = size
	
		part_instance.enabled = alive# && find != -1
		part_instance.rot_speed = base_rot_speed + rot_speed_inc * layer
		part_instance.color = start_color.linear_interpolate(end_color, a)
		part_instance.max_health = health
		part_instance.id = id
		part_map[id] = part_instance
		# part_instance.max_health = (base_health * pow(size_dropoff, layer)) / parentsides
		part_instance.shoot_interval = lerp(0.3, 2, a) # 2 - (power * 0.45)
		part_instance.shoot_timer = 1 + (index/parentsides) * part_instance.shoot_interval
		var power = layers.size() - layer
		part_instance.bullet_size = power * 2
		part_instance.bullet_count = 1 + (power-1) * 3
		part_instance.bullet_speed = 40 + 20 * power
		part_instance.bullet_type = bullettypes[layer]

		# part_instance.shoot_timer = 1.0 + (i / 3.0)
		part_instance.set_draw_behind_parent(true)
		# Add to parent + set pos
		add_child(part_instance)
		part_instance.set_pos(pos)
		
	# Create subparts
	if layer < layers.size() - 1:
		for i in range(0,sides):
			var angle = (i / float(sides)) * PI * 2.0
			var dir = Vector2(cos(angle),sin(angle))
			var pos = dir * size
			var newid = id + str(i)
			create_part(newid, pos, layer + 1, i, sides, health / parentsides)
