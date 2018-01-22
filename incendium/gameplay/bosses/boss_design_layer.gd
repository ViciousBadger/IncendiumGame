extends Object

var pgonsides = 3
var pgonexclude = [] # Pgon #s maked 'true' will not get child boss parts
var turrets = []

func new_turret():
	var t = preload("boss_design_turret.gd").new()
	turrets.append(t)
	return t
	
func clone():
	var c = get_script().new()
	c.pgonsides = pgonsides
	c.pgonexclude = pgonexclude
	for t in turrets:
		c.turrets.append(t.clone())
	return c