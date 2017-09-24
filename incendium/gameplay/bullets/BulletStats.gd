extends Object

var color = Color(1,1,1)
var damage = 1
var hostile = false # Damages player instead of enemy
var mods = []
var size = 4

func clone():
	var new = get_script().new()
	new.color = color
	new.damage = damage
	new.hostile = hostile
	new.mods = mods
	new.size = size
	return new