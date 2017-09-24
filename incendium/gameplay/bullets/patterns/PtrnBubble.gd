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
		var spread = 0.8
		for i in range(0,boss_part.bullet_count):
			var spread2 = -spread/2 + (i / float(boss_part.bullet_count) * spread)
			var spd = abs(spread2)
			boss_part.fire_bullet(spread2, (1 + spd) * speed)
		firetimer = boss_part.shoot_interval