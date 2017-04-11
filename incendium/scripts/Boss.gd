# BOSS class
# Generates all boss parts from a bunch of parameters
# and despawns once all parts are destroyed.

extends Node2D

#Fill out with an instance of BossDesign.gd
var design

var expr
var map
var part_map = {}
var dead_map = {}
var t = 0

func _ready():
	expr = RegEx.new()
	expr.compile(design.regex)
	
	if !expr.is_valid():
		print ("invalid regex!")
	
	create_part("", Vector2(0,0), 0, 0, 1)
	
	#var part_depth_map = {}
	
	var parts = part_map.values()
	var highest = 0
	for part in parts:
		var d = part.id.length()
		if d > highest:
			move_child(part,0)
			#remove_child(part)
			#add_child(part)
			highest = d
		#part_depth_map[part] = d
	
	set_process(true)
	
func _process(delta):
	t += delta
	map = {}
	if get_child_count() == 0:
		# Boss is a goner
		OS.set_time_scale(0.2)
		queue_free()
	
func has_children(id):
	# Outermost parts always return false
	if(id.length() == design.layers.size()):
		return false
	#if(dead_map.has(id)):
		#return false
	var sides = design.layers[id.length()-1]
	for i in range(sides): #Loop though all potential child parts of this part
		var child_id = id + str(i)
		if(has_children(child_id)):
			return true
		if(part_map.has(child_id) && !dead_map.has(child_id)):
			return true
	return false
	

func get_part_pos(id):
	if(map.has(id)):
		return map.id
	if(id==""):
		return Vector2(0, 0)
	var c = id[-1].to_float()
	var depth = id.length() - 1
	var parent_pos = get_part_pos(id.substr(0,depth))
	var theta = (design.base_rot_speed + depth * design.rot_speed_inc) * t + c / design.layers[depth] * 2 * PI
	var r = design.base_size * pow(design.size_dropoff, depth) * get_part_scale(id.substr(0,depth))
	var pos = parent_pos + Vector2(r * cos(-theta), r*sin(-theta)) 
	map.id = pos
	return pos

func get_part_scale(id):
	if id == "": return 1
	return 1 #+ sin(t * id.length()) * 0.3
	

func create_part(id, pos, layer, index, parentsides):
	var sides = design.layers[layer]
	var a = layer / float(design.layers.size() - 1)
	var size = design.base_size * pow(design.size_dropoff, layer)
	
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
		part_instance.rot_speed = design.base_rot_speed + design.rot_speed_inc * layer
		part_instance.color = design.start_color.linear_interpolate(design.end_color, a)
		part_instance.id = id
		part_map[id] = part_instance
		part_instance.max_health = (design.base_health * pow(design.size_dropoff, layer))# / parentsides
		part_instance.shoot_interval = lerp(0.3, 2, a) # 2 - (power * 0.45)
		part_instance.shoot_timer = 1 + (index/parentsides) * part_instance.shoot_interval
		var power = design.layers.size() - layer
		part_instance.bullet_size = power * 2
		part_instance.bullet_count = 1 + (power-1) * 3
		part_instance.bullet_speed = 60 + 20 * power
		part_instance.bullet_type = design.bullettypes[layer]

		# part_instance.shoot_timer = 1.0 + (i / 3.0)
		part_instance.set_draw_behind_parent(true)
		# Add to parent + set pos
		add_child(part_instance)
		part_instance.set_pos(pos)
		
	# Create subparts
	if layer < design.layers.size() - 1:
		for i in range(0,sides):
			var angle = (i / float(sides)) * PI * 2.0
			var dir = Vector2(cos(angle),sin(angle))
			var pos = dir * size
			var newid = id + str(i)
			create_part(newid, pos, layer + 1, i, sides)
