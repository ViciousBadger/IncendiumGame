
extends Node2D

var part = preload("res://objects/BossPart.tscn")
var layers = [3,3,3,3,3]
var bullettypes = [0,0,0,0,0]
var regex = ".*"

var base_size = 100
var size_dropoff = 0.6

var base_health = 80
var health_dropoff = 0.4

var base_rot_speed = 0.3
var rot_speed_inc = - PI * 0.1

var start_color = Color(0,0,1)
var end_color = Color(0,1,0)

var expr

func _ready():
	expr = RegEx.new()
	expr.compile(regex)
	
	if !expr.is_valid():
		print ("invalid regex!")
	
	create_part(self, "", Vector2(0,0), 0, true)
	pass

func create_part(parent, id, pos, layer, enabled):
	var sides = layers[layer]
	var a = layer / float(layers.size() - 1)
	var size = base_size * pow(size_dropoff, layer)
	
	var part_instance = part.instance()
	# Set values
	part_instance.get_node("RegularPolygon").sides = sides
	part_instance.get_node("RegularPolygon").size = size
	part_instance.enabled = enabled
	part_instance.rot_speed = base_rot_speed + rot_speed_inc * layer
	part_instance.color = start_color.linear_interpolate(end_color, a)
	part_instance.max_health = base_health * pow(health_dropoff, layer)
	part_instance.shoot_interval = lerp(0.1, 2, a) # 2 - (power * 0.45)
	var power = layers.size() - layer
	part_instance.bullet_size = power * 2
	part_instance.bullet_count = 1 + (power-1) * 3
	part_instance.bullet_speed = 50 + 50 * power
	part_instance.bullet_type = bullettypes[layer]

	# part_instance.shoot_timer = 1.0 + (i / 3.0)
	part_instance.set_draw_behind_parent(true)
	# Add to parent + set pos
	parent.add_child(part_instance)
	part_instance.set_pos(pos)
	# Create subparts
	if layer < layers.size() - 1:
		for i in range(0,sides):
			var angle = (i / float(sides)) * PI * 2.0
			var dir = Vector2(cos(angle),sin(angle))
			var pos = dir * size
			var newid = id + str(i)
			var find = expr.find(newid)
			create_part(part_instance, newid, pos, layer + 1, find > -1)
			pass