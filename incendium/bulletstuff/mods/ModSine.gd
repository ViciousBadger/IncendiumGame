
extends Object

var t = PI

func update(b, delta):
	t += delta
	var angle = atan2(b.velocity.y,b.velocity.x)
	var length = b.velocity.length()
	var inc = sin(t * 15) * 10
	angle += delta * inc
	
	b.velocity = Vector2(cos(angle),sin(angle)) * length
	