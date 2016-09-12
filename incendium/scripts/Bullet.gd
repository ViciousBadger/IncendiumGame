
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var velocity = Vector2(1000,0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	translate(velocity * delta)