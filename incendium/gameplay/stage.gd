extends Node

var player_s =  preload("res://gameplay/player/player.tscn")
var boss_s = preload("res://gameplay/bosses/boss.tscn")

# Designs for the bosses that make up this stage
var bosses = []

# As long as this is true, new bosses (and players) will be spawned
var playing = false
var gen = preload("res://gameplay/bosses/boss_generator.gd").new()

# Weak reference to last spawned boss
var last_boss_wr

# Slowdown once bosses or players die
var slow = 1

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
	spawn_player()
	# And the first big bad boss
	spawn_boss(bosses[0])
	
func _process(delta):
	# Score multiplier resetting
	#if score_mult_timer > 0:
	#	score_mult_timer -= delta
	#	if score_mult_timer <= 0:
	#		score_mult = 1
	
	if slow < 1:
		slow = min(slow + delta, 1)
		OS.set_time_scale(slow)
		if slow >= 1 and !has_node("Player") and lives > 0:
			spawn_player()
			lives -= 1

	get_node("GameUI").set_offset(Vector2(0, lerp(get_node("GameUI").get_offset().y, ui_y, delta * 10)))

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_R and event.pressed == true:
			# Instakill boss (protip: dont keep this in the release)
			var b = last_boss_wr.get_ref()
			if b != null:
				b.kill()
				
func add_score(amount):
	score += amount * score_mult
	score_mult += 1
	#score_mult_timer = score_mult_time
	
func clear_bullets():
	# Clear bullets
	for node in get_tree().get_root().get_children():
		if node extends preload("res://gameplay/bullets/bullet.gd"):
			node.queue_free()
	
func spawn_player():
	clear_bullets()
	var player = player_s.instance()
	player.set_global_pos(Vector2(360,600))
	player.connect("exit_tree", self, "_on_player_dead")
	add_child(player)
	
# Spawns a boss from a boss design object
func spawn_boss(design):
	clear_bullets()
	var boss_instance = boss_s.instance()
	last_boss_wr = weakref(boss_instance)
	
	boss_instance.design = design.clone()
	
	var g = get_tree().get_root().get_node("Game")
	g.target_bgcol = design.start_color.linear_interpolate(Color(0,0,0), 0.8)
	g.target_fgcol = design.end_color.linear_interpolate(Color(0,0,0), 0)
	
	add_child(boss_instance)
	boss_instance.set_pos(Vector2(360,360))
	boss_instance.connect("dead", self, "_on_boss_dead")
	
	playing = true

func slow(spd):
	if slow > spd:
		slow = spd
		
func _on_player_dead():
	slow(0.02)
	if lives <= 0:
		get_node("GameUI").end_stage()

func _on_boss_dead():
	bossnum += 1
	if bossnum < bosses.size():
		spawn_boss(bosses[bossnum])
		# Good job player, have a health
		var player = get_node("Player")
		if player != null:
			player.health = min(player.health + 1, player.MAX_HEALTH)
	else:
		get_node("GameUI").end_stage()
	slow(0.2)
	
func _exit_tree():
	if slow < 1:
		OS.set_time_scale(1)
	