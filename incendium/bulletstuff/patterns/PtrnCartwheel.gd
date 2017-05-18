extends Object

var firetimer = 0
var bindex = 0

var boss_part

func init(bp):
	boss_part = bp
	firetimer = bp.shoot_interval / float(bp.bullet_count)

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		boss_part.fire_bullet((bindex / float(boss_part.bullet_count)) * PI * 2, 1)
		firetimer = boss_part.shoot_interval / float(boss_part.bullet_count)
		
		bindex += 1
		if bindex >= boss_part.bullet_count:
			bindex = 0