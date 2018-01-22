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