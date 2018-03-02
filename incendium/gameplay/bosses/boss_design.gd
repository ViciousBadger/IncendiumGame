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
	var l = preload("boss_design_layer.gd").new()
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
	
func fsave(path):
	var f = File.new()
	f.open(path, f.WRITE)
	f.store_8(0) # Version
	
	f.store_8(layers.size())
	for l in layers:
		l.fsave(f)
	
	f.store_pascal_string(regex)
	
	f.store_real(base_size)
	f.store_real(size_dropoff)
	
	f.store_real(base_health)
	f.store_real(health_dropoff)
	
	f.store_real(base_rot_speed)
	f.store_real(rot_speed_inc)
	
	f.store_real(start_color.r)
	f.store_real(start_color.g)
	f.store_real(start_color.b)
	f.store_real(end_color.r)
	f.store_real(end_color.g)
	f.store_real(end_color.b)
	
func fload(path):
	var f = File.new()
	f.open(path, f.READ)
	var version = f.get_8()
	print("Boss pattern version: " + str(version))
	
	layers.clear()
	var num_layers = f.get_8()
	for i in range(num_layers):
		var l = new_layer()
		l.fload(f)
	
	regex = f.get_pascal_string()
	
	base_size = f.get_real()
	size_dropoff = f.get_real()
	
	base_health = f.get_real()
	health_dropoff = f.get_real()
	
	base_rot_speed = f.get_real()
	rot_speed_inc = f.get_real()
	
	start_color.r = f.get_real()
	start_color.g = f.get_real()
	start_color.b = f.get_real()
	
	end_color.r = f.get_real()
	end_color.g = f.get_real()
	end_color.b = f.get_real()
	
	f.close()