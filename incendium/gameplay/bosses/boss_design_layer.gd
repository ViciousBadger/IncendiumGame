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
	
func fsave(f):
	f.store_8(pgonsides)
	
	f.store_8(pgonexclude.size())
	for b in pgonexclude:
		if not b:
			f.store_8(0)
		else:
			f.store_8(1)
	
	f.store_8(turrets.size())
	for t in turrets:
		t.fsave(f)
	
func fload(f):
	pgonsides = f.get_8()
	
	pgonexclude.clear()
	var num_pgonexclude = f.get_8()
	for i in range(num_pgonexclude):
		var b = f.get_8()
		if b == 0:
			pgonexclude.append(false)
		else:
			pgonexclude.append(true)
			
	turrets.clear()
	var num_turrets = f.get_8()
	for i in range(num_turrets):
		var t = new_turret()
		t.fload(f)