extends Object

var firetimer = 0

var boss_part
var speed

func init(bp, spd):
	boss_part = bp
	speed = spd
	firetimer = bp.shoot_interval

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		for i in range(0,boss_part.bullet_count):
			boss_part.fire_bullet((i / float(boss_part.bullet_count)) * PI * 2, speed)
		firetimer = boss_part.shoot_interval