
extends Node

var s_bossicon = preload("res://ui/stageprog/bossicon.tscn")

var displayed_score = 0

onready var bossprog = get_node("BossProg")

func _ready():
	set_process(true)
	var bosses = get_parent().bosses
	for b in bosses:
		var icon = s_bossicon.instance()
		bossprog.add_child(icon)
		icon.set_col(b.start_color)

func _process(delta):
	# Player HP
	if get_parent().has_node("Player"):
		var player = get_parent().get_node("Player")
		get_node("BottomRightLabel").set_text("HP: " + str(player.health) + "/" + str(player.MAX_HEALTH))
	
	# Boss number
	for i in range(get_parent().bosses.size()):
		var s
		if get_parent().bossnum < i: s = 0
		elif get_parent().bossnum == i: s = 1
		elif get_parent().bossnum > i: s = 2
		bossprog.get_child(i).set_state(s)
	
	var s = "Boss " + str(get_parent().bossnum) + "/" + str(get_parent().bosses.size())
	get_node("BottomLeftLabel").set_text(s)
	
	# Score
	displayed_score = lerp(displayed_score, get_parent().score, delta * 10)
	get_node("ScoreLabel").set_text(str(floor(displayed_score)))
	
	# Score multiplier
	get_node("ScoreMultLabel").set_text("x" + str(get_parent().score_mult))
	
	# Lives
	get_node("TopRightLabel").set_text("Lives: " + str(get_parent().lives))
	
