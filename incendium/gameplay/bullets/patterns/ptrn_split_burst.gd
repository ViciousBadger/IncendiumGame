extends Object

var firetimer = 0
var odd = false

var firer

func init(f):
	firer = f
	firetimer = firer.get_shoot_interval() / 2

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		var start = 0
		if odd:
			start = 1
		for i in range(start,firer.get_bullet_count(),2):
			firer.fire_bullet((i / float(firer.get_bullet_count())) * PI * 2, 1)
		firetimer = firer.get_shoot_interval() / 2
		odd = !odd