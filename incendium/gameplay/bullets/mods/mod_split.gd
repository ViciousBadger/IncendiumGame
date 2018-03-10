
extends Object

func update(b, delta):
	b.stime -= delta
	if b.stime <= 0:
		for i in range(0,2):
			var newb = preload("res://gameplay/bullets/bullet.tscn").instance()
			newb.stats.hostile = b.stats.hostile
			newb.stats.size = b.stats.size / 2
			newb.stats.color = b.stats.color
			newb.stats.damage = b.stats.damage
			var angleoffset = -0.3
			if i == 1: angleoffset = 0.3
			var angle = atan2(b.velocity.y,b.velocity.x) + angleoffset
			newb.velocity = Vector2(cos(angle),sin(angle)) * b.velocity.length()
			b.get_tree().get_root().get_node("Game/Bullets").add_child(newb)
			newb.set_global_pos(b.get_global_pos())
		b.queue_free()