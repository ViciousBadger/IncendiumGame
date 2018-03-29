# GAME class
# Handles really basic things like the background color and switching game state.

extends Node

var pause_s = preload("res://ui/pause_menu.tscn")

# Includes
var Menu = preload("res://ui/main/main_menu.tscn")
var Stage = preload("res://gameplay/stage.tscn")
var Editor = preload("res://ui/editor/editor.tscn")

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
var pause_wr

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
			if mode == MENU:
				get_tree().quit()
			else:
				var removed = false
				if pause_wr != null:
					var p = pause_wr.get_ref()
					if p != null:
						p.queue_free()
						removed = true
				
				if !removed:
					var p = pause_s.instance()
					
					if mode == GAME:
						if prev == EDITOR:
							p.get_node("OptionWheel").options[2] = "Editor"
						else:
							p.get_node("OptionWheel").options[2] = "Menu"
					elif mode == EDITOR:
						p.get_node("OptionWheel").options[2] = "Menu"
					
					get_node("TopLayer").add_child(p)
					p.get_node("OptionWheel").connect("option_picked", self, "_on_pause_option_picked")
					pause_wr = weakref(p)

func unpause():
	var removed = false
	if pause_wr != null:
		var p = pause_wr.get_ref()
		if p != null:
			p.queue_free()
			removed = true
	if !removed:
		get_tree().set_pause(false)

func _on_pause_option_picked(name):
	if name == "Resume":
		unpause()
	elif name == "Settings":
		pass
	elif name == "Quit":
		get_tree().quit()
	elif name == "Editor":
		unpause()
		start_editor()
	elif name == "Menu":
		unpause()
		start_menu()

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
	var e = Editor.instance()
	mainnode.add_child(e)
	mode = EDITOR
	
func add_score(num):
	if stage_wr != null:
		var stage = stage_wr.get_ref()
		if stage != null:
			stage.add_score(num)