
extends Node

var boss = preload("res://objects/Boss.tscn")

func _ready():
	var boss_instance = boss.instance()
	
	randomize() # Randomize random seed
	
	var layer_count = floor(rand_range(3,5))
	
	var layers = []
	for i in range(0,layer_count):
		layers.append(floor(rand_range(3,6)))
	boss_instance.layers = layers
	
	#TODO: Generate regex
	
	boss_instance.base_size = rand_range(70,120)
	boss_instance.size_dropoff = rand_range(0.5,0.8)
	
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


