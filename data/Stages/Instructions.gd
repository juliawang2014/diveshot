extends Sprite

const RANGE_LIMIT = 10.0
const MAGNIFICATION_FACTOR = 4.0
const DECAY_SPEED = 1.5
const TILT = 6
const MOD_SPEED = 1.0

var mx = 0
var my = 0
var time_count = 0

func _process(delta):
	time_count += delta * MOD_SPEED
	var r = (1.0 + sin(time_count)) / 2.0
	var g = (1.0 + sin(time_count + PI)) / 2.0
	var b = (1.0 + cos(time_count)) / 2.0
	self_modulate = Color(r,g,b)
