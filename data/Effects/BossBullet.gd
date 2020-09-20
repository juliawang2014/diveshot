extends "res://data/Effects/Bullet.gd"

export (float) var steer_force = 0

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer

func control(delta):
	if target:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
	position += velocity * delta


func _on_BossBullet_area_entered(area):
	if area.name == "Bullet":
		explode()

func explode():
	$AudioStreamPlayer.play()
	$CPUParticles2D.emitting = true

func _on_AudioStreamPlayer_finished():
	call_deferred('free')
