extends Object

var firetimer = 0

var firer

func init(f):
	firer = f
	firetimer = firer.get_shoot_interval()

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		var spread = 0.8
		for i in range(0,firer.get_bullet_count()):
			firer.fire_bullet(- spread/2 + (i / float(firer.get_bullet_count()) * spread), 1)
		firetimer = firer.get_shoot_interval()