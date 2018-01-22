extends Object

var firetimer = 0

var firer

func init(f):
	firer = f
	firetimer = f.get_shoot_interval()

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		for i in range(0,firer.get_bullet_count()):
			firer.fire_bullet((i / float(firer.get_bullet_count())) * PI * 2, 1)
		firetimer = firer.get_shoot_interval()