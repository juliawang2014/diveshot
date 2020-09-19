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
	var texture = load(textures[size][randi() % textures[size].size()])
	$Sprite.texture = texture
	extents = texture.get_size() / 2
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

func take_damage(amount):
	emit_signal("explode", size, extents, position)
	call_deferred('free')


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred('free')
