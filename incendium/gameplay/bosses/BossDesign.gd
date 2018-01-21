extends Object

var layers = []
var regex = ".*"

var base_size = 100
var size_dropoff = 0.6

var base_health = 80
var health_dropoff = 0.5

var base_rot_speed = 0.3
var rot_speed_inc = - PI * 0.1

var start_color = Color(0.5,0.5,0.5)
var end_color = Color(1,1,1)

func new_layer():
	var l = preload("./BossDesignLayer.gd").new()
	layers.append(l)
	return l
	
func clone():
	var c = get_script().new()
	for layer in layers:
		c.layers.append(layer.clone())
	c.regex = regex
	c.base_size = base_size
	c.size_dropoff = size_dropoff
	c.base_health = base_health
	c.health_dropoff = health_dropoff
	c.base_rot_speed = base_rot_speed
	c.rot_speed_inc = rot_speed_inc
	c.start_color = start_color
	c.end_color = end_color
	return c
	