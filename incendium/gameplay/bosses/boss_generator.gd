extends Object


# List of Nikolaj-curaged regexes for the boss generator to use
# The letters a, b and c will each be replaced by a random number from 0 to the highest poly degree of the boss
var regex_list = [
#".*",
"a*b*",
".*a.*",
"c*(aa|bb)*c*",
"c*ba*",
"c*",
"a*b*c*"
]

var pattern_list = [
preload("res://gameplay/bullets/patterns/ptrn_burst.gd"),
preload("res://gameplay/bullets/patterns/ptrn_shotgun.gd"),
preload("res://gameplay/bullets/patterns/ptrn_cartwheel.gd"),
preload("res://gameplay/bullets/patterns/ptrn_sprinkles.gd"),
#preload("res://bulletstuff/patterns/ptrn_bubble.gd"),
preload("res://gameplay/bullets/patterns/ptrn_split_burst.gd"),
]

var mod_list = [
preload("res://gameplay/bullets/mods/mod_accel.gd"),
preload("res://gameplay/bullets/mods/mod_curve.gd"),
#preload("res://gameplay/bullets/mods/mod_sine.gd"),
preload("res://gameplay/bullets/mods/mod_split.gd"),
]

func gen_boss_design(difficulty):
	var design = preload("res://gameplay/bosses/boss_design.gd").new()
	
	var layer_count = 4
	if difficulty == 0:
		layer_count = 3
	#var layer_count = 4 #floor(rand_range(3,5)) + floor(bossdepth / 2) # bossdepth # floor(rand_range(3,5))
	
	var largest = 3;
	for layer_i in range(0,layer_count):
		var layer = design.new_layer()
		#Polygon sides
		layer.pgonsides = floor(rand_range(3,6))
		for i in range(layer.pgonsides):
			var exclude = false
			if (rand_range(0,1)) > 0.7: exclude = true
			layer.pgonexclude.append(exclude)
		if (layer.pgonsides > largest): largest = layer.pgonsides;
		#Turrets
		for turret_i in range(0,layer_count - layer_i):
			var t = layer.new_turret()
			t.pattern = pattern_list[floor(rand_range(0,pattern_list.size()))]
			#TODO: Generate bullet mods
			var power = layer_count - layer_i
			t.size = 1 + power * 1
			t.bullet_count = 1 + (power-1) * 3
			t.bullet_speed = 120 + 30 * (power-1) + rand_range(-turret_i * 20, turret_i * 20)
			t.bullet_angle = 0
			if turret_i > 0: t.bullet_angle = rand_range(2, 2)
			var a = layer_i / float(layer_count - 1)
			t.shoot_interval = lerp(max(0.1, 0.5 - 0.1 * difficulty), 1.5 - 0.1 * difficulty, a)
			#TODO: Set initial shoot timer to make part shoot in succession
			# part.shoot_timer = 1 + (index/parentsides) * part.shoot_interval
	
	design.regex = ".*"#random_regex(1 + (abs(randi())%3), largest)
	
	design.base_size = layer_count * 22
	design.size_dropoff = 0.6
	
	#design.base_health = 15 + (2.5 * bossnum)
	design.base_health = 80 + 30 * difficulty
	design.health_dropoff = 0.3
	#TODO: Health and health dropoff (Should be based on difficulty, and probably affected by the total amount of boss parts)

	var speed = 1

	#var min_base_rot = 0.5
	#var max_base_rot = 1.5
	#var min_rot_inc = 0.05
	#var max_rot_inc = 0.15
	
	#var rot_speed_focus = rand_range(0,1)
	#design.base_rot_speed = lerp(min_base_rot, max_base_rot, rot_speed_focus) * speed
	#design.rot_speed_inc = lerp(min_rot_inc, max_rot_inc, 1 - rot_speed_focus) * PI * speed
	design.base_rot_speed = 0.25
	design.rot_speed_inc = 0.8
	
	if randi() % 2 == 0: design.base_rot_speed = -design.base_rot_speed
	if randi() % 2 == 0: design.rot_speed_inc = -design.rot_speed_inc
	
	var boss_start_col = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	var boss_end_col = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	
	design.start_color = boss_start_col
	design.end_color = boss_end_col
	
	return design
	
# Generates regexes using the regex list and some info about the boss
func random_regex(size, larg):
	var string = regex_list[abs(randi()) % regex_list.size()]
	var base = randi();
	string = string.replace("a",str(int(base+0)%int(larg)))
	string = string.replace("b",str(int(base+1)%int(larg)))
	string = string.replace("c",str(int(base+2)%int(larg)))
	return string
	
# Unused broken regex generator
func gen_regex(depth, layers):
	print(depth)
	if depth == 0:
		return str(floor(rand_range(0, layers[depth])))
		
	var option = floor(rand_range(0,3))
	if option == 0:
		return "(" + gen_regex(depth - 1, layers) + ")*"
	if option == 1:
		return "(" + gen_regex(depth - 1, layers) + ")+(" + gen_regex(depth - 1, layers) + ")"
	if option == 2:
		return "(" + gen_regex(depth - 1, layers) + ")(" + gen_regex(depth - 1, layers) + ")"