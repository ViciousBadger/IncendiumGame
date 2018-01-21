extends Node

var editor = null
var turreti = 0
var updating_fields = false

func update_fields():
	if updating_fields: return
	updating_fields = true
	var t = editor.get_turret(turreti)
	f("TurretNum").set_text("Turret #" + str(turreti + 1))
	f("BSize").set_value(t.size)
	f("BCount").set_value(t.bullet_count)
	f("BSpeed").set_value(t.bullet_speed)
	f("BAngle").set_value(rad2deg(t.bullet_angle))
	f("BInterval").set_value(t.shoot_interval)
	updating_fields = false

func _on_TurretRemoveButton_pressed():
	editor.remove_turret(turreti)
	editor.design_changed()

func f(name):
	var fl = get_node("FieldLinks/" + name)
	return fl.get_field()

func _on_BSizeField_value_changed( value ):
	editor.get_turret(turreti).size = value
	editor.design_changed()
func _on_BCountField_value_changed( value ):
	editor.get_turret(turreti).bullet_count = value
	editor.design_changed()
func _on_BSpeedField_value_changed( value ):
	editor.get_turret(turreti).bullet_speed = value
	editor.design_changed()
func _on_BAngleField_value_changed( value ):
	editor.get_turret(turreti).bullet_angle = deg2rad(value)
	editor.design_changed()
func _on_BIntervalField_value_changed( value ):
	editor.get_turret(turreti).shoot_interval = value
	editor.design_changed()
