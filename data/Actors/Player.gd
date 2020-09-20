extends "res://data/Actors/Actor.gd"

export (PackedScene) var Bullet
export (float) var gun_cooldown
var target = null
var can_shoot = true
var invincible = false
var can_slow = true
var times_entered = 0

signal shoot
signal damaged

func _ready():
	health = max_health
	Pause.connect("new_color", self, "_on_new_color")
	modulate = Pause.my_color
	$Timer.wait_time = gun_cooldown
#	$Trail.set_process(false)

func control(delta):
	var dir = 0
	if Input.is_action_pressed("dive"):
		velocity.y += (speed * 2 * delta)
	if Input.is_action_pressed("left"):
		dir -= 1
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("shoot"):
		shoot()
	if Input.is_action_pressed("slow") and can_slow:
		if times_entered == 0:
			times_entered = 1
			$SlowAllow.start()
			$SlowCharge/AnimationPlayer.play("fade")
#			$Trail.set_process(true)
		Engine.set_time_scale(0.5)
	if Input.is_action_just_released("slow") or !can_slow:
		Engine.set_time_scale(1.0)
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	velocity.y += (gravity * delta)
	var controller_angle = Vector2.ZERO
	var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_2)
	var yAxisUD = Input.get_joy_axis(0, JOY_AXIS_3)
	if abs(xAxisRL) > Globals.deadzone or abs(yAxisUD) > Globals.deadzone:
		controller_angle = Vector2(xAxisRL, yAxisUD).angle()
		rotation = controller_angle
	else:
		look_at(get_global_mouse_position())

func _on_new_color(color):
	modulate = color

func shoot():
	if can_shoot:
		var effect = AudioServer.get_bus_effect(3,0)
		effect.pitch_scale = randf() * 2.0 + 1.0
		$AudioStreamPlayer.play()
		can_shoot = false
		$Timer.start()
		var dir = Vector2(1, 0).rotated(global_rotation)
		emit_signal('shoot', Bullet, $Limbs/Muzzle.global_position, dir, target)

func _on_Timer_timeout():
	can_shoot = true

func take_damage(amount):
	if !invincible and alive:
		$HurtSounds.play()
		$CameraShake.shake(1.0, 50, 80)
		invincible = true
		$IFrames.start()
		$AnimationPlayer.play("damage")
		emit_signal("damaged")
		health -= amount
		if health <= 0:
			die()
			alive = false

func die():
	emit_signal("dead")
	explode()

func explode():
	visible = false
	$CPUParticles2D.modulate = Color.red
	$CPUParticles2D.emitting = true

func _on_IFrames_timeout():
	invincible = false

func _on_SlowAllow_timeout():
	can_slow = false
#	$Trail.set_process(false)
	$SlowRecharge.start()
	$SlowCharge/AnimationPlayer.play("recharge")

func _on_SlowRecharge_timeout():
	can_slow = true
	times_entered = 0

func heal(amount):
	$CPUParticles2D.modulate = Color.magenta
	$CPUParticles2D.emitting = true
	$HealSounds.play()
	health += amount
	health = clamp(health, 0, max_health)
