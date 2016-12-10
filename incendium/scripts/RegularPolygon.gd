# REGULAR POLYGON class
# Generates a regular polygon for looks and as a collider

extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"
export(int, 3, 32) var sides = 3
export var size = 100
export var circle_collision = false

func _ready():
	
	# Create regular polygon vectors
	var vectors = Array()
	for i in range(0,sides):
		vectors.append(Vector2(cos(2 * PI * i / sides) * size,sin(2 * PI * i / sides) * size))
	
	# Create and add collisionshape
	if circle_collision:
		var collisionShape = CircleShape2D.new()
		collisionShape.set_radius(size)
		add_shape(collisionShape)
	else:
		var collisionShape = ConvexPolygonShape2D.new()
		collisionShape.set_points(vectors)
		add_shape(collisionShape)
	# Set visual polygon look
	get_node("Polygon2D").set_uv(vectors)
	get_node("Polygon2D").set_polygon(vectors)
	pass


