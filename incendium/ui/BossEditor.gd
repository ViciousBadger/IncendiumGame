
extends Node

var BossDesign = preload("res://gameplay/bosses/BossDesign.gd")

var boss
onready var design = BossDesign.new()
var design_changing = false
const hotswap_delay = 0.1
var time_since_change = 0

func _ready():
	set_process_input(true)
	set_process(true)
	design.new_layer()
	design.new_layer()
	design.new_layer()
	design.new_layer()
	design_changed()
	
func _process(delta):
	if time_since_change < hotswap_delay:
		time_since_change += delta
		if time_since_change > hotswap_delay:
			hotswap()

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_ENTER and event.pressed == true:
			pass # Test boss here
			
func hotswap():
	var t = 0
	if boss != null:
		print("boss not null")
		var b = boss.get_ref()
		if b != null:
			print("boss ref not null either")
			t = b.t
			b.queue_free()
	
	
	var newboss = preload("res://gameplay/bosses/Boss.tscn").instance()
	newboss.design = design
	newboss.start_anim = false
	newboss.t = t
	get_node("..").call_deferred("add_child", newboss)
	newboss.set_pos(Vector2(360,360))
	boss = weakref(newboss)
	
	get_node("..").target_bgcol = design.start_color
	get_node("..").target_fgcol = design.end_color
	
func test():
	var player = preload("res://gameplay/player/Player.tscn").instance()
	player.set_global_pos(Vector2(360,600))
	get_node("..").add_child(player)
	queue_free()
	
func _on_TestButton_pressed():
	test()

func design_changed():
	if design_changing: return # Avoid recursive calls when updating fields
	time_since_change = 0
	design_changing = true
	# Update all fields
	f("BaseSize").set_value(design.base_size)
	f("SizeDropoff").set_value(design.size_dropoff * 100)
	f("BaseHealth").set_value(design.base_health)
	f("HealthDropoff").set_value(design.health_dropoff * 100)
	f("BaseRotSpeed").set_value(design.base_rot_speed)
	f("RotSpeedInc").set_value(design.rot_speed_inc)
	f("StartColor").set_color(design.start_color)
	f("EndColor").set_color(design.end_color)
	f("Regex").set_text(design.regex)
	design_changing = false
	#f("").set_value(design.)

func f(name):
	var fl = get_node("FieldLinks/" + name)
	var path = fl.field
	return fl.get_node(fl.field)

func _on_BaseSizeField_value_changed( value ):
	design.base_size = value
	design_changed()
func _on_SizeDropoffField_value_changed( value ):
	design.size_dropoff = value / 100
	design_changed()
func _on_BaseHealthField_value_changed( value ):
	design.base_health = value
	design_changed()
func _on_HealthDropoffField_value_changed( value ):
	design.health_dropoff = value / 100
	design_changed()
func _on_BaseRotField_value_changed( value ):
	design.base_rot_speed = value
	design_changed()
func _on_RotIncField_value_changed( value ):
	design.rot_speed_inc = value
	design_changed()
func _on_StartColorField_color_changed( color ):
	design.start_color = color
	design_changed()
func _on_EndColorField_color_changed( color ):
	design.end_color = color
	design_changed()