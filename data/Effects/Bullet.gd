extends Area2D

export var damage = 10
export var speed = 100
var velocity = Vector2()
var acceleration = Vector2()
var target = null

func start(_position, _direction, _target = null):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	target = _target


func _on_Bullet_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
	call_deferred('free')

func _process(delta):
	control(delta)

func control(delta):
	move_local_x(delta * speed)

func _on_Timer_timeout():
	call_deferred('free')
