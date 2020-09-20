extends "res://data/Actors/Actor.gd"

export (PackedScene) var Bullet
var laser = preload("res://data/Effects/Laser.tscn")
export (float) var gun_cooldown
export (int) var gun_shots = 1
export (float, 0, 1.5) var gun_spread = 0.2
export (float) var turret_speed
var target = null
var can_shoot = true
var laser_instance

signal shoot

func _ready():
	health = max_health
	$Timer.wait_time = gun_cooldown

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body


func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null

func shoot(num, spread, target = null):
	if can_shoot:
		can_shoot = false
		$ShootSounds.play()
		$Timer.start()
		emit_signal("shoot", Bullet, $Turret1/Muzzle.global_position, Vector2.UP, target)
		emit_signal("shoot", Bullet, $Turret2/Muzzle.global_position, Vector2.UP, target)

func _process(delta):
	if not alive:
		return
	if target:
		shoot(gun_shots, gun_spread, target)
		

func _on_Timer_timeout():
	can_shoot = true


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"appear":
			$AnimationPlayer.play("hover")
			$LaserTimer.start()
		"death":
			emit_signal("dead")
			call_deferred('free')

func take_damage(amount):
	health -= amount
	$DamagePlayer.play("damage")
	play_hurt_noise()
	if health <= 0:
		die()
		alive = false

func play_hurt_noise():
	$AudioStreamPlayer.play()

func explode():
	for i in $ExplosionPoints.get_child_count():
		var explosion = $ExplosionPoints.get_child(i)
		explosion.emitting = true
		yield(get_tree().create_timer(0.1), "timeout")

func die():
	$AnimationPlayer.play("death")

func _on_laser_done_firing():
	$LaserCharge/AnimationPlayer.play_backwards("charge")

func fire_laser():
	laser_instance = laser.instance()
	laser_instance.position = $LaserCharge.position
	laser_instance.connect('done_firing', self, '_on_laser_done_firing')
	$LaserCharge.call_deferred('add_child', laser_instance)
	$LaserCharge/AnimationPlayer.play("charge")
	laser_instance.fire()

func _on_LaserTimer_timeout():
	var num = randi() % 2
	if num == 0 and alive:
		fire_laser()
