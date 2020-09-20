extends Area2D

export var damage = 10

signal done_firing

func _on_Laser_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)

func _on_Laser_area_entered(area):
	area.call_deferred('free')

func fire():
	$AnimationPlayer.play("fire")

func retract():
	$AnimationPlayer.play("retract")


func _on_Timer_timeout():
	retract()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "retract":
		emit_signal('done_firing')
		call_deferred('free')
