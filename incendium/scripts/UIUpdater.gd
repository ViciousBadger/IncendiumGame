
extends Node

func _ready():
	set_process(true)

func _process(delta):
	# Player HP
	var player = get_parent().get_node("Player")
	if player != null:
		get_node("../BottomLeftLabel").set_text("HP: " + str(player.health) + "/" + str(player.MAX_HEALTH))
	
	# Boss number
	get_node("../BottomRightLabel").set_text("Boss " + str(get_parent().bossnum))
	
	# Score
	get_node("../TopLeftLabel").set_text("Score: " + str(floor(get_parent().score)))
	
	# Lives
	get_node("../TopRightLabel").set_text("Lives: " + str(get_parent().lives))
	
