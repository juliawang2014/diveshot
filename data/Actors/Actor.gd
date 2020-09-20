extends KinematicBody2D

signal dead

var velocity = Vector2()
export var speed = 100
export var gravity = -98
var alive = true
export var damage = 10
export var acceleration = 0.5
export (int) var max_health = 100
var health
export var friction = 0.05

func _ready():
	health = max_health

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func control(delta):
	pass

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		alive = false

func die():
	pass
