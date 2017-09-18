
extends Panel

# member variables here, example:
# var a=2
# var b="textvar"

var BossDesign = preload("res://gameplay/bosses/BossDesign.gd")

var drawtimer = 0
const drawtime = 0.2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	set_process(true)
	
func _process(delta):
	if drawtime > 0:
		drawtime -= delta
		if drawtime <= 0:
			update()

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_ENTER and event.pressed == true:
			_on_FightButton_pressed()

func _on_FightButton_pressed():
	var boss = preload("res://gameplay/bosses/Boss.tscn").instance()
	
	var boss = BossDesign.new()
	boss.base_size = get_node("BaseSizeField").get_value()
	boss.base_health = get_node("BaseHealthField").get_value()
	boss.size_dropoff = get_node("SideDropoffField").get_value() / 100
	boss.base_rot_speed = get_node("BaseRotField").get_value()
	boss.rot_speed_inc = get_node("RotIncField").get_value()
	boss.start_color = get_node("StartColorField").get_color()
	boss.end_color = get_node("EndColorField").get_color()
	boss.regex = get_node("RegexField").get_text()
	
	get_node("..").spawn_boss(boss)
	queue_free()

var expr = RegEx.new()

func _draw():
	expr.compile(get_node("RegexField").get_text())
	draw_boss_part("")
	
func draw_boss_part(id):
	var find = expr.find(id)
	var alive = false
	for s in expr.get_captures():
		if(s == id):
			alive = true
			break
	
	if alive:
		var col = get_node("StartColorField").get_color().linear_interpolate(get_node("EndColorField").get_color(),id.length() / 4.0)
		var poly = Vector2Array()
		var s = get_node("BaseSizeField").get_value() * pow(get_node("SideDropoffField").get_value() / 100, id.length())
		var base_pos = Vector2(500,360) + get_part_pos(id)
		for i in range(3):
			var t = i / 3.0 * 2 * PI
			poly.append(base_pos + Vector2(cos(t)*s,sin(t)*s))
		draw_colored_polygon(poly, col)
	if id.length() < 4:
		for i in range(3):
			draw_boss_part(id + str(i))

func get_part_pos(id):
	#if(map.has(id)):
#		return map.id
	if(id==""):
		return Vector2(0, 0)
	var c = id[-1].to_float()
	var depth = id.length() - 1
	var parent_pos = get_part_pos(id.substr(0,depth))
	var theta = c / 3.0 * 2 * PI
	var r = get_node("BaseSizeField").get_value() * pow(get_node("SideDropoffField").get_value() / 100, depth)
	var pos = parent_pos + Vector2(r * cos(-theta), r*sin(-theta)) 
	#map.id = pos
	return pos

func _on_RegexField_text_changed( text ):
	#drawtime = drawtimer
	update()
