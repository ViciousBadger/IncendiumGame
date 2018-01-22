extends Object

var firetimer = 0

var firer

func init(f):
	firer = f

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		var spread = 0.8
		for i in range(0,firer.get_bullet_count()):
			var spread2 = -spread/2 + (i / float(firer.get_bullet_count()) * spread)
			var spd = abs(spread2)
			firer.fire_bullet(spread2, (1 + spd))
		firetimer = firer.get_shoot_interval()