
extends Object

var timer = 2

func update(b, delta):
	timer -= delta
	if timer <= 0:
		for i in range(0,2):
			var newb = preload("res://objects/Bullet.tscn").instance()
			newb.get_node("RegularPolygon").remove_from_group("damage_enemy")
			newb.get_node("RegularPolygon").add_to_group("damage_player")
			newb.get_node("RegularPolygon").size = b.damage/2
			newb.get_node("RegularPolygon/Polygon2D").set_color(b.get_node("RegularPolygon/Polygon2D").get_color())
			newb.damage = b.damage/2
			var angleoffset = -0.3
			if i == 1: angleoffset = 0.3
			var angle = atan2(b.velocity.y,b.velocity.x) + angleoffset
			newb.velocity = Vector2(cos(angle),sin(angle)) * b.velocity.length()
			get_tree().get_root().add_child(newb)
			newb.set_global_pos(get_global_pos())
		b.queue_free()