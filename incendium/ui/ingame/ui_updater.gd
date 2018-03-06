
extends Node

var s_bossicon = preload("res://ui/ingame/stageprog/bossicon.tscn")

var displayed_score = 0
var stage_done = false

onready var bossprog = get_node("BossProg")

func end_stage():
	stage_done = true
	get_node("BottomRightLabel").hide()
	get_node("ScoreMultLabel").hide()
	get_node("BossProg").hide()
	get_node("TopRightLabel").hide()

func _ready():
	set_process(true)
	var bosses = get_parent().bosses
	for b in bosses:
		var icon = s_bossicon.instance()
		bossprog.add_child(icon)
		icon.set_col(b.start_color.linear_interpolate(Color(1,1,1),0.1))

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
	
	if stage_done:
		var sl = get_node("ScoreLabel")
		sl.set_pos(sl.get_pos().linear_interpolate(Vector2(720/2,720/2) - sl.get_size()/2, delta * 10))
	
