extends Object

var firetimer = 0
var odd = false

var boss_part
var speed

func init(bp, spd):
	boss_part = bp
	speed = spd
	firetimer = bp.shoot_interval / 2

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		var start = 0
		if odd:
			start = 1
		for i in range(start,boss_part.bullet_count,2):
			boss_part.fire_bullet((i / float(boss_part.bullet_count)) * PI * 2, speed)
		firetimer = boss_part.shoot_interval / 2
		odd = !odd