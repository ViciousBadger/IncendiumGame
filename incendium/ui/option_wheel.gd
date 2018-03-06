extends Node2D

export(StringArray) var options

signal option_picked(name)

var selecti = 0
var labels = []

var rot = 0

var len = 0
var s = 0

onready var game = get_tree().get_root().get_node("Game")

func _ready():
	set_process(true)
	set_process_input(true)
	get_node("RegularPolygon").sides = options.size()
	set_scale(Vector2(0,0))
	for o in options:
		var label = Label.new()
		label.set_text(o)
		get_node("Text").add_child(label)
		labels.append(label)
		
func wrap(n):
	var result = fposmod(n, options.size())
	if result == options.size():
		result = 0
	return result
	
func _process(delta):
	var target_rot = -(selecti / float(options.size())) * PI * 2 + deg2rad(30)
	
	rot = lerp(rot, target_rot, 10 * delta)
	len = lerp(len, 1, 5 * delta)
	
	if abs(rot - target_rot) < 0.01:
		rot = target_rot
	
	var i = 0
	for l in labels:
		var rot2 = (i / float(options.size())) * PI * 2 + deg2rad(60)
		var rot_final = rot + rot2
		
		var len2 = 75
		if wrap(selecti) == i:
			len2 = lerp(75, 90, len)
		
		l.set_global_pos(get_global_pos() - l.get_size()/2 - Vector2(cos(rot_final),sin(rot_final)) * len2)
		i += 1
	
	if s < 1:
		s = lerp(s,1,delta*5)
		set_scale(Vector2(1,1) * s)
	
	get_node("RegularPolygon").set_rot(-rot)
	if game != null:
		get_node("RegularPolygon/Polygon2D").set_color(game.fgcol.linear_interpolate(Color(1,1,1), 0.5))
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		selecti -= 1
		len = 0
		#if selecti < 0:
		#	selecti = options.size() - 1
	if event.is_action_pressed("ui_right"):
		selecti += 1
		len = 0
		#if selecti >= options.size():
		#	selecti = 0
	if event.is_action_pressed("ui_accept"):
		emit_signal("option_picked", options[wrap(selecti)])