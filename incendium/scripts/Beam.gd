
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var s = 1
var charge = 0
var size = 0.4

var follow
var offset
var rotoffset

var coll

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_scale(Vector2(0,1))
	offset = get_global_pos() - follow.get_ref().get_global_pos()
	#set_monitorable(false)
	#coll = get_node("CollisionShape2D")
	#coll.queue_free()

func _process(delta):
	if charge < 1:
		charge += delta
		set_scale(Vector2(lerp(0,size/2,charge),1))
		set_opacity(charge / 4)
		
		if charge >= 1:
			var shape = BoxShape.new()
			shape.set_extents(Vector3(32,512,1))
			add_shape(shape)
			#set_monitorable(true)
			#add_child(coll)
			#get_node("CollisionShape2D").set_hidden(false)
		
		var f = follow.get_ref()
		if f != null:
			set_global_pos(f.get_global_pos() + offset)
		else:
			queue_free()
	else:
		s = lerp(s,-0.1,delta * 5)
		if s <= 0:
			queue_free()
			
		set_opacity(lerp(0,1,s))
		set_scale(Vector2(lerp(0,size,s),1))
