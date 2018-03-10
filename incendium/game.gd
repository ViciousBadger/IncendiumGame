# GAME class
# Handles really basic things like the background color and switching game state.

extends Node

# Includes
var Menu = preload("res://ui/main/main_menu.tscn")
var Stage = preload("res://gameplay/stage.tscn")
var BossEditor = preload("res://ui/editor/boss_editor.tscn")

# Node references
onready var mainnode = get_node("Main")

# Values for current and target fore- and background colors
# Used for slowly fading into new colors
var bgcol = Color(0,0,0)
var target_bgcol = Color(0.6,0.6,0.6)
var fgcol = Color(0,0,0)
var target_fgcol = Color(1,1,1)

const NONE = 0
const MENU = 1
const EDITOR = 2
const GAME = 3

var prev = NONE
var mode = NONE

var stage_wr

func _ready():
	randomize()
	target_fgcol = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	fgcol = target_fgcol
	target_bgcol = Color(rand_range(0,1),rand_range(0,1),rand_range(0,1))
	bgcol = target_bgcol
	set_process_input(true)
	set_process(true)
	start_menu()

func _process(delta):
	bgcol = bgcol.linear_interpolate(target_bgcol,delta * 0.5)
	fgcol = fgcol.linear_interpolate(target_fgcol,delta * 0.3)
	get_node("Background/BgEffect").set_modulate(bgcol)

func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed():
		if event.scancode == KEY_ESCAPE:
			if mode == GAME:
				if prev == EDITOR:
					start_editor()
				else:
					start_menu()
			elif mode == EDITOR:
				start_menu()
			else:
				get_tree().quit()
			
func clear():
	for node in mainnode.get_children():
		node.queue_free()
	
	# Clear bullets
	for node in get_tree().get_root().get_node("Game/Bullets").get_children():
		if node extends preload("res://gameplay/bullets/bullet.gd"):
			node.queue_free()
	
	prev = mode

func start_menu():
	clear()
	var m = Menu.instance()
	mainnode.add_child(m)
	mode = MENU

func start_stage(bosses):
	clear()
	var s = Stage.instance()
	s.bosses = bosses
	mainnode.add_child(s)
	stage_wr = weakref(s)
	mode = GAME
	
func start_editor():
	clear()
	var e = BossEditor.instance()
	mainnode.add_child(e)
	mode = EDITOR
	
func add_score(num):
	if stage_wr != null:
		var stage = stage_wr.get_ref()
		if stage != null:
			stage.add_score(num)