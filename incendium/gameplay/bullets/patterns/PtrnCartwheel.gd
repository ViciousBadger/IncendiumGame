extends Object

var firetimer = 0
var bindex = 0

var firer

func init(f):
	firer = f
	firetimer = firer.get_shoot_interval() / float(firer.get_bullet_count())

func update(delta):
	firetimer -= delta
	if firetimer <= 0:
		firer.fire_bullet((bindex / float(firer.get_bullet_count())) * PI * 2, 1)
		firetimer = firer.get_shoot_interval() / float(firer.get_bullet_count())
		
		bindex += 1
		if bindex >= firer.get_bullet_count():
			bindex = 0