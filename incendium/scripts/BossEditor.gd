
extends Panel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _on_FightButton_pressed():
	var boss = preload("res://objects/Boss.tscn").instance()
	boss.base_size = get_node("BaseSizeField").get_value()
	boss.base_health = get_node("BaseHealthField").get_value()
	boss.size_dropoff = get_node("SideDropoffField").get_value() / 100
	boss.base_rot_speed = get_node("BaseRotField").get_value()
	boss.rot_speed_inc = get_node("RotIncField").get_value()
	boss.start_color = get_node("StartColorField").get_color()
	boss.end_color = get_node("EndColorField").get_color()
	boss.regex = get_node("RegexField").get_text()
	
	get_node("..").add_child(boss)
	boss.set_global_pos(Vector2(360,360))
	
	get_node("..").last_boss = boss
	get_node("..").last_boss_wr = weakref(boss)
	get_node("..").target_bgcol = boss.start_color.linear_interpolate(Color(0,0,0), 0.8)
	get_node("..").target_fgcol = boss.end_color.linear_interpolate(Color(0,0,0), 0)
	get_node("..").playing = true
	queue_free()
	pass # replace with function body
