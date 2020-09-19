extends Area2D

export (PackedScene) var Asteroid
export (int) var number_of_rocks = 10
var start_wait_time = 3.0
var radius
var sizes = ['big', 'small']

func _ready():
	randomize()
	$Timer.wait_time = start_wait_time
	radius = $CollisionShape2D.shape.extents.x
	
func get_rand_size():
	var rand_size = sizes[randi() % sizes.size()]
	return rand_size

func get_rand_pos():
	var rand_pos = rand_range(-radius, radius * 2)
	var placement = Vector2(rand_pos, position.y)
	return placement

func spawn_rocks(size, pos):
	var a = Asteroid.instance()
	a.init(size, pos)
	a.connect('explode', self, 'explode_asteroid')
	$Rocks.call_deferred('add_child', a)

func _on_Timer_timeout():
	if $Timer.wait_time >= 1.0:
		$Timer.wait_time -= 0.1
	number_of_rocks += 2
	spawn_rocks(get_rand_size(), get_rand_pos())

func explode_asteroid(size, extents, pos):
	var newsize = Globals.break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos * max(extents.x/2, extents.y/2)* offset
			spawn_rocks(newsize, newpos)
