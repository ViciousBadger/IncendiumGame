extends Object

var pattern = preload("res://gameplay/bullets/patterns/ptrn_burst.gd")
# Bullet stats
var mods = []
var size = 2
# Params for firing
var bullet_count = 1
var bullet_speed = 80
var bullet_angle = 0
var shoot_interval = 1

func clone():
	var c = get_script().new()
	c.pattern = pattern
	for m in mods:
		c.mods.append(m)
	c.size = size
	c.bullet_count = bullet_count
	c.bullet_speed = bullet_speed
	c.bullet_angle = bullet_angle
	c.shoot_interval = shoot_interval
	return c
	
func fsave(f):
	f.store_pascal_string(pattern.get_path())
	
	f.store_8(mods.size())
	for m in mods:
		f.store_pascal_string(m.get_path())
	
	f.store_8(size)
	f.store_8(bullet_count)
	f.store_real(bullet_speed)
	f.store_real(bullet_angle)
	f.store_real(shoot_interval)

func fload(f):
	pattern = load(f.get_pascal_string())
	
	mods.clear()
	var mod_num = f.get_8()
	for i in range(mod_num):
		mods.append(load(f.get_pascal_string()))
	
	size = f.get_8()
	bullet_count = f.get_8()
	bullet_speed = f.get_real()
	bullet_angle = f.get_real()
	shoot_interval = f.get_real()