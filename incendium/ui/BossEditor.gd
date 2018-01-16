
extends Node

var BossDesign = preload("res://gameplay/bosses/BossDesign.gd")

var boss
onready var design = BossDesign.new()

func _ready():
	set_process_input(true)
	set_process(true)
	design.new_layer()
	design.new_layer()
	design.new_layer()
	design_changed()
	
func _process(delta):
	pass

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_ENTER and event.pressed == true:
			pass # Test boss here
			
func hotswap():
	var t = 0
	if boss != null:
		t = boss.t
		boss.queue_free()
		
	var newboss = preload("res://gameplay/bosses/Boss.tscn").instance()
	newboss.design = design
	newboss.start_anim = false
	newboss.t = t
	get_node("..").call_deferred("add_child", newboss)
	newboss.set_pos(Vector2(360,360))
	boss = newboss

func design_changed():
	hotswap()
	# Update all fields
	f("BaseSize").set_value(design.base_size)
	f("SizeDropoff").set_value(design.size_dropoff)
	f("BaseHealth").set_value(design.base_health)
	f("HealthDropoff").set_value(design.health_dropoff)
	f("BaseRotSpeed").set_value(design.base_rot_speed)
	f("RotSpeedInc").set_value(design.rot_speed_inc)
	f("StartColor").set_color(design.start_color)
	f("EndColor").set_color(design.end_color)
	f("Regex").set_text(design.regex)
	#f("").set_value(design.)

func f(name):
	var fl = get_node("FieldLinks/" + name)
	var path = fl.field
	return fl.get_node(fl.field)

func _on_BaseSizeField_value_changed( value ):
	design.base_size = value
	design_changed()
func _on_StartColorField_color_changed( color ):
	design.start_color = color
	design_changed()
func _on_EndColorField_color_changed( color ):
	design.end_color = color
	design_changed()
