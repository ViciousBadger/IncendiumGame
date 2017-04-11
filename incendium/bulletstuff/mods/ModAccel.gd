
extends Object

func update(b, delta):
	var length = b.velocity.length()
	length += delta * 100
	b.velocity = b.velocity.normalized() * length