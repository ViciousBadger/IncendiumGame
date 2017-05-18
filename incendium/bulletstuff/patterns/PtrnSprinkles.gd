extends Object

var firetimer = 0
var t = 0

var boss_part

func init(bp):
	boss_part = bp
	firetimer = bp.shoot_interval / float(bp.bullet_count)

func update(delta):
	t += delta
	firetimer -= delta
	if firetimer <= 0:
		var tetha = sin(t * 3) * 0.5
		boss_part.fire_bullet(tetha, 1)
		firetimer = boss_part.shoot_interval / float(boss_part.bullet_count)