extends Object

var pgonsides
var turrets = []

func new_turret():
	var t = preload("./BossDesignTurret.gd").new()
	turrets.append(t)
	return t