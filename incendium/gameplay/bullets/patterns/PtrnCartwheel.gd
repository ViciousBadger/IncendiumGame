extends Object

var firetimer = 0
var bindex = 0

var boss_part
var speed

func init(bp, spd):
	boss_part = bp
	speed = spd
	firetimer = bp.shoot_interval / float(bp.bullet_count)

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		boss_part.fire_bullet((bindex / float(boss_part.bullet_count)) * PI * 2, speed)
		firetimer = boss_part.shoot_interval / float(boss_part.bullet_count)
		
		bindex += 1
		if bindex >= boss_part.bullet_count:
			bindex = 0