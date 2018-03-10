extends Camera2D

var s = 0
var t = 0
onready var basepos = get_global_pos()

func _ready():
	set_process(true)

func _process(delta):
	if s > 0:
		set_global_pos(basepos + Vector2(rand_range(-s*t,s*t),0))
		t -= delta * 3
		if t <= 0:
			t = 0
			s = 0
			set_global_pos(basepos)

func shake(power):
	if s < power:
		s = power
		t = 1