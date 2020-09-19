extends Node

func _on_Player_shoot(bullet, _position, _direction, _target = null):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _target)

func _input(event):
	if event.is_action_pressed("pause"):
		Globals.pause()
		Pause.show_self()
	if !$Player.alive:
		if event is InputEventKey and event.pressed:
			get_tree().reload_current_scene()
		


func _on_Player_dead():
	$CanvasLayer/Deathmessage.visible = true


