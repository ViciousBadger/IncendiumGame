
extends Node

var displayed_score = 0

func _ready():
	set_process(true)

func _process(delta):
	# Player HP
	if get_parent().has_node("Player"):
		var player = get_parent().get_node("Player")
		get_node("BottomRightLabel").set_text("HP: " + str(player.health) + "/" + str(player.MAX_HEALTH))
	
	# Boss number
	var s = "Boss " + str(get_parent().bossnum) + "/" + str(get_parent().bosses.size())
	get_node("BottomLeftLabel").set_text(s)
	
	# Score
	displayed_score = lerp(displayed_score, get_parent().score, delta * 10)
	get_node("ScoreLabel").set_text(str(floor(displayed_score)))
	
	# Score multiplier
	get_node("ScoreMultLabel").set_text("x" + str(get_parent().score_mult))
	
	# Lives
	get_node("TopRightLabel").set_text("Lives: " + str(get_parent().lives))
	
