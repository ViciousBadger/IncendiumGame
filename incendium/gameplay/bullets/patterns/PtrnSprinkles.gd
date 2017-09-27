extends Object

var firetimer = 0
var t = 0

var firer

func init(f):
	firer = f
	firetimer = firer.get_shoot_interval() / float(firer.get_bullet_count())

func update(delta):
	t += delta
	firetimer -= delta
	if firetimer <= 0:
		var tetha = sin(t * 3) * 0.7
		firer.fire_bullet(tetha, 1)
		firetimer = firer.get_shoot_interval() / float(firer.get_bullet_count())