extends "res://data/Actors/Actor.gd"

signal explode

var textures = {'big': ["res://assets/Sprites/Rockbig1.png",
						"res://assets/Sprites/Rockbig2.png"],
				'small': ["res://assets/Sprites/Rocksmall1.png",
						"res://assets/Sprites/Rocksmall2.png"]}

var size
var extents
var screensize

func control(delta):
	velocity.y += (gravity * delta)

func init(init_size, init_pos):
	size = init_size
	var my_texture = load(textures[size][randi() % textures[size].size()])
	$Sprite.texture = my_texture
	extents = my_texture.get_size() / 2
	var shape = CircleShape2D.new()
	shape.radius = min(extents.x - 10, extents.y - 10)
	var damageshape = CircleShape2D.new()
	damageshape.radius = min(extents.x, extents.y)
#	var o = create_shape_owner(self)
#	shape_owner_add_shape(o, shape)
	$CollisionShape2D.shape = shape
	$DamageZone/CollisionShape2D.shape = damageshape
	position = init_pos

func _on_DamageZone_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)
		emit_signal("explode", size, extents, position)
		explode()

func take_damage(amount):
	emit_signal("explode", size, extents, position)
	explode()


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred('free')

func explode():
	$CPUParticles2D.emitting = true
	$Sprite.visible = false
	$CollisionShape2D.set_deferred('disabled', true)
	$DamageZone/CollisionShape2D.set_deferred('disabled', true)
	var effect = AudioServer.get_bus_effect(3,0)
	effect.pitch_scale = randf() * 1.0 + 0.5
	$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	call_deferred('free')


func _on_DamageZone_area_entered(area):
	if area.name == "Bullet":
		take_damage(area.damage)
