extends Object

var firetimer = 0
var odd = false

var boss_part

func init(bp):
	boss_part = bp
	firetimer = bp.shoot_interval

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		var start = 0
		if odd:
			start = 1
		for i in range(start,boss_part.bullet_count,2):
			boss_part.fire_bullet((i / float(boss_part.bullet_count)) * PI * 2,1)
		firetimer = boss_part.shoot_interval / 2
		odd = !odd