extends "res://data/Actors/Actor.gd"

export (PackedScene) var Bullet
export (float) var gun_cooldown
var target = null
var can_shoot = true

signal shoot

func _ready():
	health = max_health
	Pause.connect("new_color", self, "_on_new_color")
	$Timer.wait_time = gun_cooldown

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
	if Input.is_action_pressed("slow"):
		Engine.set_time_scale(0.5)
	if Input.is_action_just_released("slow"):
		Engine.set_time_scale(1.0)
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	velocity.y += (gravity * delta)
	look_at(get_global_mouse_position())

func _on_new_color(color):
	modulate = color

func shoot():
	if can_shoot:
		can_shoot = false
		$Timer.start()
		var dir = Vector2(1, 0).rotated(global_rotation)
		emit_signal('shoot', Bullet, $Limbs/Muzzle.global_position, dir, target)

func _on_Timer_timeout():
	can_shoot = true

func take_damage(amount):
	$CameraShake.shake(1.0, 50, 80)
	health -= amount
	if health <= 0:
		die()
		alive = false

func die():
	emit_signal("dead")
	explode()

func explode():
	visible = false
