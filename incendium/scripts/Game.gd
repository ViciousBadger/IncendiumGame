# GAME class
# This class handles the core game loop.
# It generates new random bosses as the player defeats them,
# and also respawns the player when dead.

extends Node

var playing = false

var last_boss
var last_boss_wr

var bgcol = Color(0,0,0)
var target_bgcol = Color(0,0,0)
var fgcol = Color(0,0,0)
var target_fgcol = Color(0,0,0)

var bossnum = 0
var bossdepth = 2

var score = 0

var regex_list = [
"a*b*",
".*",
"(a|c)*b",
".*a.*",
"c*(aa|bb)*c*",
"b.*a",
"(c.b)*",
"ba*b.*",
"c*ba*",
"c*",
"a*b*c*"
]

func start_game():
	playing = true
	gen_boss()

func _ready():
	set_process_input(true)
	set_process(true)
	
func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_R and event.pressed == true:
			if last_boss != null:
				last_boss.queue_free()

func random_regex(size, larg):
	var string = regex_list[abs(randi()) % regex_list.size()]
	var base = randi();
	string = string.replace("a",str(int(base+0)%int(larg)))
	string = string.replace("b",str(int(base+1)%int(larg)))
	string = string.replace("c",str(int(base+2)%int(larg)))
	return string

func _process(delta):
	bgcol = bgcol.linear_interpolate(target_bgcol,delta * 3)
	fgcol = fgcol.linear_interpolate(target_fgcol,delta * 0.5)
	get_node("Background/Polygon2D").set_color(bgcol)
	#tag("Smoke").set_modulate(bgcol)
	
	if playing:
		if OS.get_time_scale() < 1:
			OS.set_time_scale(min(OS.get_time_scale() + delta, 1))
			if OS.get_time_scale() >= 1:
				if (!has_node("Player")):
					var p = preload("res://objects/Player.tscn").instance()
					add_child(p)
					p.set_global_pos(Vector2(360,600))
		
		if !last_boss_wr.get_ref():
			#No boss, spawn a new one
			if bossdepth < 4:
				bossdepth += 1
			gen_boss()
			#also increase player health
			var player = get_node("Player")
			if player != null:
				player.health = floor(lerp(player.health,player.MAX_HEALTH,0.5))
				get_node("Label").set_text("HP: " + str(player.health) + "/" + str(player.MAX_HEALTH))

func add_score(amount):
	score += amount
	get_node("Score").set_text("Score: " + str(floor(score)))

func gen_boss():
	var boss_instance = preload("res://objects/Boss.tscn").instance()
	last_boss = boss_instance
	last_boss_wr = weakref(boss_instance)
	
	randomize() # Randomize random seed
	
	var layer_count = 4 #floor(rand_range(3,5)) + floor(bossdepth / 2) # bossdepth # floor(rand_range(3,5))
	
	var layers = []
	var bullettypes = []
	var largest = 3;
	for i in range(0,layer_count):
		var l = floor(rand_range(3,5));
		if(l>largest):
			largest = l;
		layers.append(l)
		bullettypes.append(floor(rand_range(0,5)))
		#bullettypes.append(2)
	boss_instance.layers = layers
	boss_instance.bullettypes = bullettypes
	
	print("generating regex")
	boss_instance.regex = random_regex(1 + (abs(randi())%3), largest)
	print(boss_instance.regex)
	
	boss_instance.base_size = layer_count * 20
	boss_instance.size_dropoff = rand_range(0.4,0.8)
	
	boss_instance.base_health = 20 + (5 * bossnum)
	#TODO: Health and health dropoff (Should be based on difficulty, and probably affected by the total amount of boss parts)

	var speed = 1

	var min_base_rot = 0.5
	var max_base_rot = 1.5
	var min_rot_inc = 0.05
	var max_rot_inc = 0.15
	
	var rot_speed_focus = rand_range(0,1)
	boss_instance.base_rot_speed = lerp(min_base_rot, max_base_rot, rot_speed_focus) * speed
	boss_instance.rot_speed_inc = lerp(min_rot_inc, max_rot_inc, 1 - rot_speed_focus) * PI * speed
	
	if randi() % 2 == 0: boss_instance.base_rot_speed = -boss_instance.base_rot_speed
	if randi() % 2 == 0: boss_instance.rot_speed_inc = -boss_instance.rot_speed_inc
	
	var boss_start_col = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	var boss_end_col = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	
	#var boss_start_col = Color(0,0,0)
	#var boss_end_col = Color(0,0,0)
	
	boss_instance.start_color = boss_start_col
	boss_instance.end_color = boss_end_col
	
	target_bgcol = boss_start_col.linear_interpolate(Color(0,0,0), 0.8)
	target_fgcol = boss_end_col.linear_interpolate(Color(0,0,0), 0)
	
	add_child(boss_instance)
	boss_instance.set_pos(Vector2(360,360))
	
	bossnum += 1
	get_node("Label1").set_text("Boss " + str(bossnum))

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

