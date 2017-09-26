
extends Object

func update(b, delta):
	var angle = atan2(b.velocity.y,b.velocity.x)
	var length = b.velocity.length()
	var inc = 0.003
	angle += delta * length * inc
	
	b.velocity = Vector2(cos(angle),sin(angle)) * length
	