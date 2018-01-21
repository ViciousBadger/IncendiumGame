extends Node

# Designs for the bosses that make up this stage
var bosses = []

# As long as this is true, new bosses (and players) will be spawned
var playing = false
var gen = preload("res://gameplay/bosses/BossGenerator.gd").new()

# Strong and weak references to last spawned boss
# Weak reference is nessecary to check when the boss has been destroyed
var last_boss
var last_boss_wr

# Number of bosses spawned
var bossnum = 0

# Those values every game in the known universe have
var score = 0
var lives = 3

# Cool kids know score multipliers are the shit
var score_mult = 1
var score_mult_timer = 0
const score_mult_time = 4

# UI Y position to make it slide in
var ui_y = 720

func _ready():
	set_process(true)
	set_process_input(true)
	
	get_node("GameUI").set_offset(Vector2(0,ui_y))
	ui_y = 0
	
	# Create our ol trusty player
	var player = preload("res://gameplay/player/Player.tscn").instance()
	player.set_global_pos(Vector2(360,600))
	add_child(player)
	if bosses.size() > 0:
		spawn_boss(bosses[0])
	else:
		spawn_boss(gen.gen_boss_design())
	
func _process(delta):
	# Score multiplier resetting
	#if score_mult_timer > 0:
	#	score_mult_timer -= delta
	#	if score_mult_timer <= 0:
	#		score_mult = 1
	
	#TODO: do this more reliably (what if something else changes time scale?)
	if OS.get_time_scale() < 1:
		OS.set_time_scale(min(OS.get_time_scale() + delta, 1))
		if OS.get_time_scale() >= 1 and !has_node("Player") and lives > 0:
			var p = preload("res://gameplay/player/Player.tscn").instance()
			add_child(p)
			p.set_global_pos(Vector2(360,600))
			lives -= 1
	
	if !last_boss_wr.get_ref():
		# No boss, spawn a new one
		spawn_boss(gen.gen_boss_design())
		bossnum += 1
		# Good job player, have a health
		var player = get_node("Player")
		if player != null:
			player.health = min(player.health + 1, player.MAX_HEALTH)
			
	get_node("GameUI").set_offset(Vector2(0, lerp(get_node("GameUI").get_offset().y, ui_y, delta * 10)))

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_R and event.pressed == true:
			# Instakill boss (protip: dont keep this in the release)
			if last_boss != null:
				last_boss.queue_free()
				
func add_score(amount):
	score += amount * score_mult
	score_mult += 1
	#score_mult_timer = score_mult_time
	
func spawn_next():
	bossnum += 1
	if bosses.size() > 0:
		if bossnum < bosses.size():
			spawn_boss(bosses[bossnum])
		else:
			print("stage has been won")
	else:
		spawn_boss(gen.gen_boss_design())
	
# Spawns a boss from a boss design object
func spawn_boss(design):
	var boss_instance = preload("res://gameplay/bosses/Boss.tscn").instance()
	last_boss = boss_instance
	last_boss_wr = weakref(boss_instance)
	
	boss_instance.design = design.clone()
	
	var g = get_tree().get_root().get_node("Game")
	g.target_bgcol = design.start_color.linear_interpolate(Color(0,0,0), 0.8)
	g.target_fgcol = design.end_color.linear_interpolate(Color(0,0,0), 0)
	
	add_child(boss_instance)
	boss_instance.set_pos(Vector2(360,360))
	
	playing = true