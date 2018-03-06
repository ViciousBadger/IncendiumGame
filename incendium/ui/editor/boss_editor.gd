
extends Node

# Includes
var BossDesign = preload("res://gameplay/bosses/boss_design.gd")
var BossPart = preload("res://gameplay/bosses/boss_part.gd")
var TurretEdit = preload("res://ui/editor/turret_edit.tscn")

# Autosaving paths
const AUTOSAVE_BOSS = "user://autosave.boss"
const AUTOSAVE_PATH = "user://autosave.path"

# Exposed vars
export(NodePath) var turret_edit_parent
# Boss design being edited
var design
# Path to save to (if any)
var save_path = null
# Boss generator
var gen = preload("res://gameplay/bosses/boss_generator.gd").new()
# Weak ref to current boss 'preview'
var boss
# Layer # selected
var layeri = 0
# Avoid recursive calls to field setters
var updating_fields = false
# Hotswapping
const hotswap_delay = 0.05
var time_since_change = 0

func _ready():
	set_process_input(true)
	set_process(true)
	
	# Load autosave is found
	var d = Directory.new()
	if d.file_exists(AUTOSAVE_BOSS):
		design = BossDesign.new()
		design.fload(AUTOSAVE_BOSS)
		# Also try loading save path
		if d.file_exists(AUTOSAVE_PATH):
			var f = File.new()
			f.open(AUTOSAVE_PATH, f.READ)
			save_path = f.get_as_text()
	else:
		default_design()
	design_changed()
	
func default_design():
	design = BossDesign.new()
	for i in range(4):
		var l = design.new_layer()
		var t = l.new_turret()
	
func _process(delta):
	if time_since_change < hotswap_delay:
		time_since_change += delta
		if time_since_change > hotswap_delay:
			hotswap()

func _input(event):
	if event.type == InputEvent.KEY and event.pressed:
		if event.scancode == KEY_RETURN:
			_on_TestButton_pressed()
		if event.scancode == KEY_S and event.control:
			_on_SaveButton_pressed()
				
func _exit_tree():
	# Autosave
	design.fsave(AUTOSAVE_BOSS)
	# Save boss path too
	if save_path != null:
		var f = File.new()
		f.open(AUTOSAVE_PATH, f.WRITE)
		f.store_string(save_path)
	else:
		var d = Directory.new()
		if d.file_exists(AUTOSAVE_PATH):
			d.remove(AUTOSAVE_PATH)

func hotswap():
	var t = 0
	if boss != null:
		var b = boss.get_ref()
		if b != null:
			t = b.t
			b.queue_free()
	
	var newboss = preload("res://gameplay/bosses/boss.tscn").instance()
	newboss.design = design.clone()
	newboss.start_anim = false
	newboss.t = t
	#get_node("..").call_deferred("add_child", newboss)
	get_node("..").add_child(newboss)
	newboss.set_pos(Vector2(360,360))
	boss = weakref(newboss)
	update_boss_parts(newboss)
	
	get_tree().get_root().get_node("Game").target_bgcol = design.start_color
	get_tree().get_root().get_node("Game").target_fgcol = design.end_color
	
func update_boss_parts(boss):
	for c in boss.get_children():
		if c extends BossPart:
			c.auto_active = false
			c.active = c.id.length() == layeri
	
func get_turret(i):
	return design.layers[layeri].turrets[i]
	
func remove_turret(i):
	design.layers[layeri].turrets.remove(i)

#
# Buttons
#

func _on_LoadButton_pressed():
	if save_path != null:
		get_node("LoadFileDialog").set_current_path(save_path)
	get_node("LoadFileDialog").popup()

func _on_SaveButton_pressed():
	if save_path != null:
		design.fsave(save_path)
	else:
		get_node("SaveFileDialog").popup()

func _on_SaveAsButton_pressed():
	if save_path != null:
		get_node("SaveFileDialog").set_current_path(save_path)
	get_node("SaveFileDialog").popup()

func _on_RandomizeButton_pressed():
	get_node("ConfirmRandomDialog").popup()

func _on_ResetButton_pressed():
	get_node("ConfirmResetDialog").popup()

func _on_TestButton_pressed():
	get_tree().get_root().get_node("Game").start_stage([design])
	
func _on_PrevLayerButton_pressed():
	if layeri > 0:
		layeri -= 1
	update_fields()
	update_boss_parts(boss.get_ref())

func _on_NextLayerButton_pressed():
	if layeri < design.layers.size() - 1:
		layeri += 1
	update_fields()
	update_boss_parts(boss.get_ref())
	
func _on_NewTurretButton_pressed():
	design.layers[layeri].new_turret()
	design_changed()

#
# Dialogs
#

func _on_SaveFileDialog_file_selected( path ):
	design.fsave(path)
	save_path = path

func _on_LoadFileDialog_file_selected( path ):
	design.fload(path)
	save_path = path
	design_changed()

func _on_ConfirmRandomDialog_confirmed():
	design = gen.gen_boss_design()
	save_path = null
	design_changed()

func _on_ConfirmResetDialog_confirmed():
	default_design()
	save_path = null
	design_changed()

#
# Field value get/set
#

func design_changed():
	if updating_fields: return # Avoid recursive calls when updating fields
	time_since_change = 0
	update_fields()
	
func update_fields():
	updating_fields = true
	# First make sure the layer index seleced is not beyond this design's layer count
	if design.layers.size() == 0:
		layeri = 0
	elif layeri >= design.layers.size():
		layeri = design.layers.size() - 1
	
	# Template:
	# f("").set_value(design.)
	f("Boss/BaseSize").set_value(design.base_size)
	f("Boss/SizeDropoff").set_value(design.size_dropoff * 100)
	f("Boss/BaseHealth").set_value(design.base_health)
	f("Boss/HealthDropoff").set_value(design.health_dropoff * 100)
	f("Boss/BaseRotSpeed").set_value(design.base_rot_speed)
	f("Boss/RotSpeedInc").set_value(design.rot_speed_inc)
	f("Boss/StartColor").set_color(design.start_color)
	f("Boss/EndColor").set_color(design.end_color)
	f("Boss/Regex").set_text(design.regex)
	f("Layers/LayerIndex").set_text("Layer #" + str(layeri))
	f("Layers/Pgonsides").set_value(design.layers[layeri].pgonsides)
	# Make sure we have the correct amount of turret edit sections
	var tparent = get_node(turret_edit_parent)
	
	var turreti = 0
	for turret in design.layers[layeri].turrets:
		if tparent.get_child_count() < design.layers[layeri].turrets.size():
			var te = TurretEdit.instance()
			tparent.add_child(te)
			te.turreti = turreti
			te.editor = self
			te.update_fields()
		turreti += 1
	# Check if there are too many turret edit sections
	var editi = 0
	for te in tparent.get_children():
		if design.layers[layeri].turrets.size() <= editi:
			te.queue_free()
		else:
			te.turreti = editi
			te.update_fields()
		editi += 1
	
	updating_fields = false

func f(name):
	var fl = get_node("FieldLinks/" + name)
	return fl.get_field()

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
func _on_UpdateRegexButton_pressed():
	design.regex = f("Boss/Regex").get_text()
	design_changed()
func _on_SidesField_value_changed( value ):
	design.layers[layeri].pgonsides = value
	design_changed()



