extends Node

onready var boss = preload("res://data/Actors/Boss.tscn")
onready var health_pickup = preload("res://data/Effects/Health.tscn")
var boss_instance
var game_won = false

func _ready():
	boss_instance = boss.instance()
	boss_instance.connect("dead", self, "_on_boss_dead")
	boss_instance.connect("shoot", self, "_on_Player_shoot")
	if Globals.current_level == Globals.game:
		$ChromaticAberration/TextureRect.material.set_shader_param('apply', false)

func _on_Player_shoot(bullet, _position, _direction, _target = null):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _target)

func _input(event):
	if event.is_action_pressed("pause"):
		Globals.pause()
#		Pause.show_self()
	if !$Player.alive or game_won:
		if event is InputEventKey and event.pressed:
			get_tree().reload_current_scene()
		


func _on_Player_dead():
	$CanvasLayer/Deathmessage.visible = true

func _on_Player_damaged():
	$ChromaticAberration/TextureRect.material.set_shader_param('apply', true)
	yield(get_tree().create_timer(1.0), "timeout")
	$ChromaticAberration/TextureRect.material.set_shader_param('apply', false)
	$Player.modulate = Pause.my_color

func _on_boss_dead():
	game_won = true
	$CanvasLayer/Winmessage.show()

func summon_boss():
	call_deferred('add_child', boss_instance)

func _on_BossTimer_timeout():
	summon_boss()
	$Rockspawn.allowed_to_emit = false

func _on_NextZone_body_entered(body):
	Globals.next_level()

func _on_HealthTimer_timeout():
	var num = randi() % 3
	if num == 0:
		var health_instance = health_pickup.instance()
		health_instance.position = $HealthSpawns/Position2D.global_position
		$HealthSpawns.call_deferred('add_child', health_instance)
	elif num == 1:
		var health_instance = health_pickup.instance()
		health_instance.position = $HealthSpawns/Position2D2.global_position
		$HealthSpawns.call_deferred('add_child', health_instance)
