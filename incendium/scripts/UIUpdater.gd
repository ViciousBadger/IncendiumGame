
extends Node

var displayed_score = 0
const ui_path = "../GameUI/"

func _ready():
	set_process(true)

func _process(delta):
	# Player HP
	var player = get_parent().get_node("Player")
	if player != null:
		get_node(ui_path + "BottomLeftLabel").set_text("HP: " + str(player.health) + "/" + str(player.MAX_HEALTH))
	
	# Boss number
	get_node(ui_path + "BottomRightLabel").set_text("Boss " + str(get_parent().bossnum))
	
	# Score
	displayed_score = lerp(displayed_score, get_parent().score, delta * 10)
	get_node(ui_path + "ScoreLabel").set_text(str(floor(displayed_score)))
	
	# Score multiplier
	get_node(ui_path + "ScoreMultLabel").set_text("x" + str(get_parent().score_mult))
	
	# Lives
	get_node(ui_path + "TopRightLabel").set_text("Lives: " + str(get_parent().lives))
	
