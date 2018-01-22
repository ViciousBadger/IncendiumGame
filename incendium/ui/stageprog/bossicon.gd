extends TextureFrame

var c_size = 1
var c_target = 0

onready var circle = get_node("BossIconCircle")

func _ready():
	set_process(true)

func _process(delta):
	if c_size != c_target:
		c_size = lerp(c_size, c_target, delta * 14)
		if abs(c_size - c_target) < 1: c_size = c_target
		circle.set_size(Vector2(c_size,c_size))
		var off = 8 - (c_size / 2)
		circle.set_pos(Vector2(off,off))

func set_state(state):
	if state == 0:
		c_target = 0
	if state == 1:
		c_target = 8
	if state == 2:
		c_target = 16

func set_col(col):
	circle.set_modulate(col)