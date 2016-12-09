
extends Node

var last_boss
var last_boss_wr

var bgcol = Color(0,0,0)
var target_bgcol = Color(0,0,0)
var fgcol = Color(0,0,0)
var target_fgcol = Color(0,0,0)

var bossnum = 0
var bossdepth = 2

var score = 0

func _ready():
	set_process_input(true)
	set_process(true)
	gen_boss()
	
func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_R and event.pressed == true:
			if last_boss != null:
				last_boss.queue_free()

func _process(delta):
	bgcol = bgcol.linear_interpolate(target_bgcol,delta * 3)
	fgcol = fgcol.linear_interpolate(target_fgcol,delta * 0.5)
	get_node("Background/Polygon2D").set_color(bgcol)
	#tag("Smoke").set_modulate(bgcol)
	
	if (!has_node("Player")):
		OS.set_time_scale(min(OS.get_time_scale() + delta, 1))
		if OS.get_time_scale() >= 1:
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
	
	var layer_count = bossdepth # floor(rand_range(3,5))
	
	var layers = []
	var bullettypes = []
	for i in range(0,layer_count):
		layers.append(floor(rand_range(3,6)))
		bullettypes.append(floor(rand_range(-1,4)))
		#bullettypes.append(2)
	boss_instance.layers = layers
	boss_instance.bullettypes = bullettypes
	
	print("generating regex")
	# boss_instance.regex = gen_regex(layer_count - 1, layers)
	print(boss_instance.regex)
	
	boss_instance.base_size = layer_count * 25
	boss_instance.size_dropoff = 0.5
	
	boss_instance.base_health = 20 + (10 * bossnum)
	#TODO: Health and health dropoff (Should be based on difficulty, and probably affected by the total amount of boss parts)
	
	var neg_base_rot_speed = randi() % 2 == 0
	boss_instance.base_rot_speed = rand_range(0.2,0.8)
	if neg_base_rot_speed:
		boss_instance.base_rot_speed = -boss_instance.base_rot_speed
	
	var neg_rot_inc = randi() % 2 == 0
	boss_instance.rot_speed_inc = boss_instance.base_rot_speed + rand_range(0.1,0.2) * PI
	if neg_rot_inc:
		boss_instance.rot_speed_inc = -boss_instance.rot_speed_inc
	
	var boss_start_col = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	var boss_end_col = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	
	boss_instance.start_color = boss_start_col
	boss_instance.end_color = boss_end_col
	
	target_bgcol = boss_start_col.linear_interpolate(Color(0,0,0), 0.5)
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

