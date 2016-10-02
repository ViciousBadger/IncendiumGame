
extends Node

var boss = preload("res://objects/Boss.tscn")

var last_boss

const POLYGON_DEGREE = 3

func _ready():
	set_process_input(true)
	gen_boss()

	
func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_R and event.pressed == true:
			if last_boss != null:
				last_boss.queue_free()
			gen_boss()

func gen_boss():
	var boss_instance = boss.instance()
	last_boss = boss_instance
	
	randomize() # Randomize random seed
	
	var layer_count = floor(rand_range(3,5))
	
	var layers = []
	for i in range(0,layer_count):
		layers.append(floor(rand_range(3,6)))
	boss_instance.layers = layers
	
	boss_instance.regex = gen_regex(layer_count - 1, layers)
	print(boss_instance.regex)
	
	boss_instance.base_size = rand_range(70,100)
	boss_instance.size_dropoff = rand_range(0.5,0.6)
	
	#TODO: Health and health dropoff (Should be based on difficulty, and probably affected by the total amount of boss parts)
	
	var neg_base_rot_speed = randi() % 2 == 0
	boss_instance.base_rot_speed = rand_range(0.2,0.8)
	if neg_base_rot_speed:
		boss_instance.base_rot_speed = -boss_instance.base_rot_speed
	
	var neg_rot_inc = randi() % 2 == 0
	boss_instance.rot_speed_inc = rand_range(0.1,0.3) * PI
	if neg_rot_inc:
		boss_instance.rot_speed_inc = -boss_instance.rot_speed_inc
	
	boss_instance.start_color = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	boss_instance.end_color = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	
	add_child(boss_instance)
	boss_instance.set_pos(Vector2(360,360))

func gen_regex(depth, layers):
	if depth == 0:
		return str(floor(rand_range(0, layers[depth])))
		
	var option = floor(rand_range(0,3))
	print (option)
	if option == 0:
		return "(" + gen_regex(depth - 1, layers) + ")*"
	if option == 1:
		return "(" + gen_regex(depth - 1, layers) + ")+(" + gen_regex(depth - 1, layers) + ")"
	if option == 2:
		return "(" + gen_regex(depth - 1, layers) + ")|(" + gen_regex(depth - 1, layers) + ")"

