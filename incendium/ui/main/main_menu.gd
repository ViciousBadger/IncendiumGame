
extends Node

onready var game = get_tree().get_root().get_node("Game")

const COL_TIME = 15
var col_t = COL_TIME

func _ready():
	set_process(true)
	
func _process(delta):
	col_t -= delta
	if col_t <= 0:
		col_t = COL_TIME
		game.target_bgcol = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
		game.target_fgcol = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))

func _on_PlayButton_pressed():
	game.start_game()
	queue_free()

func _on_OptionWheel_option_picked( name ):
	if name == "Play":
		var gen = preload("res://gameplay/bosses/boss_generator.gd").new()
		var bosses = []
		for i in range(5):
			bosses.append(gen.gen_boss_design(i))
		game.start_stage(bosses)
	elif name == "Edit":
		game.start_editor()
	elif name == "Exit":
		get_tree().quit()