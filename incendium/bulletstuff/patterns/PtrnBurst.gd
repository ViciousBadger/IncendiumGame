extends Object

var firetimer = 0

var boss_part

func init(bp):
	boss_part = bp
	firetimer = bp.shoot_interval

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		for i in range(0,boss_part.bullet_count):
			boss_part.fire_bullet((i / float(boss_part.bullet_count)) * PI * 2,1)
		firetimer = boss_part.shoot_interval